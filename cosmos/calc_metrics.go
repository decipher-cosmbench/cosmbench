package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// TxLog represents a transaction log entry
type TxLog struct {
	TxIdx     int    `json:"txIdx"`
	Timestamp int64  `json:"timestamp"`
	Height    int    `json:"height"`
	TxHash    string `json:"txHash"`
}

// BlockLog represents a block log entry
type BlockLog struct {
	Timestamp int64 `json:"timestamp"`
	Height    int   `json:"height"`
}

// TPSData represents TPS-related information
type TPSData struct {
	TotalTxs         int     `json:"totalTxs"`
	FirstTxTimestamp int64   `json:"firstTxTimestamp"`
	LastTxTimestamp  int64   `json:"lastTxTimestamp"`
	TotalElapsedTime int64   `json:"totalElapsedTime"`
	TPS              float64 `json:"tps"`
}

// BlockTransactionCount represents block-wise transaction count
type BlockTransactionCount struct {
	Height           int `json:"height"`
	TransactionCount int `json:"transactionCount"`
}

func parseTxLogs(filePath string) ([]TxLog, error) {
	fmt.Println("[INFO] Parsing transaction logs...")
	file, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to open tx log file: %v", err)
	}
	defer file.Close()

	var txLogs []TxLog
	decoder := json.NewDecoder(file)
	if err := decoder.Decode(&txLogs); err != nil {
		return nil, fmt.Errorf("failed to decode JSON tx log file: %v", err)
	}

	fmt.Printf("[INFO] Parsed %d transactions from %s\n", len(txLogs), filePath)
	return txLogs, nil
}

func parseBlockLogs(logDir string) (map[int]int64, error) {
	fmt.Println("[INFO] Parsing block logs...")
	files, err := filepath.Glob(filepath.Join(logDir, "logs/output*.log"))
	if err != nil || len(files) == 0 {
		return nil, fmt.Errorf("failed to find block log files: %v", err)
	}

	blockLogs := make(map[int]int64)
	blockLogRegex := regexp.MustCompile(`(\d+)\s+.*committed state.*height=(\d+).*`)

	for _, file := range files {
		fmt.Printf("[INFO] Processing block log file: %s\n", file)
		f, err := os.Open(file)
		if err != nil {
			return nil, fmt.Errorf("failed to open block log file %s: %v", file, err)
		}
		defer f.Close()

		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			line := scanner.Text()
			// Remove color codes if any
			colorCodeRegex := regexp.MustCompile(`\x1b\[[0-9;]*m`)
			cleanedLine := colorCodeRegex.ReplaceAllString(line, "")

			matches := blockLogRegex.FindStringSubmatch(cleanedLine)
			if len(matches) > 0 {
				timestamp, _ := strconv.ParseInt(matches[1], 10, 64)
				height, _ := strconv.Atoi(matches[2])
				blockLogs[height] = timestamp
			}
		}

		if err := scanner.Err(); err != nil {
			return nil, fmt.Errorf("failed to read block log file %s: %v", file, err)
		}
	}

	fmt.Printf("[INFO] Parsed %d block entries\n", len(blockLogs))
	return blockLogs, nil
}

func calculateTPS(txLogs []TxLog, outputFile string) error {
	fmt.Println("[INFO] Calculating TPS...")

	// Check if txLogs is empty
	if len(txLogs) == 0 {
		return fmt.Errorf("[ERROR] No transactions found in txLogs")
	}

	// Extract the first transaction timestamp
	firstTxTimestamp := txLogs[0].Timestamp

	// Get the height of the last transaction
	lastTxHeight := txLogs[len(txLogs)-1].Height

	// Open the log file to find the last transaction's timestamp
	file, err := os.Open("logs/output0.log")
	if err != nil {
		fmt.Printf("[ERROR] Unable to open log file: %v\n", err)
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lastTxTimestamp int64
	found := false

	for scanner.Scan() {
		line := scanner.Text()

		// Look for the line containing the specific height
		if strings.Contains(line, "height="+strconv.Itoa(lastTxHeight)) {
			fmt.Printf("[DEBUG] Found line for lastTxHeight: %s\n", line)

			words := strings.Fields(line)
			if len(words) > 0 {
				lastTxTimestamp, err = strconv.ParseInt(words[0], 10, 64)
				if err != nil {
					return fmt.Errorf("[ERROR] Failed to parse timestamp: %v", err)
				}
				found = true
			} else {
				fmt.Printf("[DEBUG] No words found in line: %s\n", line)
			}
			break
		}
	}

	if !found {
		return fmt.Errorf("[ERROR] Last transaction timestamp not found for height %d", lastTxHeight)
	}

	// Calculate TPS
	totalElapsedTime := lastTxTimestamp - firstTxTimestamp
	if totalElapsedTime <= 0 {
		return fmt.Errorf("[ERROR] Invalid elapsed time: %d", totalElapsedTime)
	}

	tps := float64(len(txLogs)) / (float64(totalElapsedTime) / 1000.0)

	// Create TPS data
	tpsData := TPSData{
		TotalTxs:         len(txLogs),
		FirstTxTimestamp: firstTxTimestamp,
		LastTxTimestamp:  lastTxTimestamp,
		TotalElapsedTime: totalElapsedTime,
		TPS:              tps,
	}

	// Write TPS data to the output file
	file, err = os.Create(outputFile)
	if err != nil {
		return fmt.Errorf("[ERROR] Failed to create TPS file: %v", err)
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(tpsData); err != nil {
		return fmt.Errorf("[ERROR] Failed to write TPS data to file: %v", err)
	}

	fmt.Printf("[INFO] TPS calculation completed successfully. Results saved to %s\n", outputFile)
	return nil
}

func calculateBlockTransactionCounts(txLogs []TxLog, outputFile string) error {
	fmt.Println("[INFO] Calculating block transaction counts...")
	blockCounts := make(map[int]int)

	for _, tx := range txLogs {
		blockCounts[tx.Height]++
	}

	var results []BlockTransactionCount
	for height, count := range blockCounts {
		results = append(results, BlockTransactionCount{
			Height:           height,
			TransactionCount: count,
		})
	}

	// Sort results by height in ascending order
	sort.Slice(results, func(i, j int) bool {
		return results[i].Height < results[j].Height
	})

	file, err := os.Create(outputFile)
	if err != nil {
		return fmt.Errorf("failed to create block transaction count file: %v", err)
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(results); err != nil {
		return fmt.Errorf("failed to write block transaction count file: %v", err)
	}

	fmt.Printf("[INFO] Block transaction counts calculation completed. Results saved to %s\n", outputFile)
	return nil
}

func calculateLatency(txLogs []TxLog, blockLogs map[int]int64, outputFile string) error {
	fmt.Println("[INFO] Calculating latency...")
	file, err := os.Create(outputFile)
	if err != nil {
		return fmt.Errorf("failed to create latency file: %v", err)
	}
	defer file.Close()

	var results []struct {
		TxIdx     int   `json:"txIdx"`
		Timestamp int64 `json:"timestamp"`
		Height    int   `json:"height"`
		Latency   int64 `json:"latency"`
	}

	for _, tx := range txLogs {
		blockTimestamp, exists := blockLogs[tx.Height]
		if !exists {
			fmt.Printf("[WARN] No block timestamp found for height %d (TxIdx: %d)\n", tx.Height, tx.TxIdx)
			continue
		}

		latency := blockTimestamp - tx.Timestamp
		fmt.Printf("[INFO] TxIdx: %d, Latency: %d ms\n", tx.TxIdx, latency)
		results = append(results, struct {
			TxIdx     int   `json:"txIdx"`
			Timestamp int64 `json:"timestamp"`
			Height    int   `json:"height"`
			Latency   int64 `json:"latency"`
		}{
			TxIdx:     tx.TxIdx,
			Timestamp: tx.Timestamp,
			Height:    tx.Height,
			Latency:   latency,
		})
	}

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(results); err != nil {
		return fmt.Errorf("failed to write latency file: %v", err)
	}

	fmt.Printf("[INFO] Latency calculation completed. Results saved to %s\n", outputFile)
	return nil
}

func main() {
	txLogFile := "results/tx_log.json"
	logDir := "./"
	resultDir := "results/"
	os.MkdirAll(resultDir, os.ModePerm)

	tpsFile := filepath.Join(resultDir, "tps.json")
	blockTransactionFile := filepath.Join(resultDir, "block_transactions.json")
	latencyFile := filepath.Join(resultDir, "latency.json")

	fmt.Println("[INFO] Starting latency calculation tool...")

	// Parse transaction logs
	txLogs, err := parseTxLogs(txLogFile)
	if err != nil {
		fmt.Printf("[ERROR] Failed to parse tx logs: %v\n", err)
		return
	}

	// Parse block logs
	blockLogs, err := parseBlockLogs(logDir)
	if err != nil {
		fmt.Printf("[ERROR] Failed to parse block logs: %v\n", err)
		return
	}

	// Calculate latency and write to JSON file
	if err := calculateLatency(txLogs, blockLogs, latencyFile); err != nil {
		fmt.Printf("[ERROR] Failed to calculate latency: %v\n", err)
		return
	}

	// Calculate TPS and write to JSON file
	if err := calculateTPS(txLogs, tpsFile); err != nil {
		fmt.Printf("[ERROR] Failed to calculate TPS: %v\n", err)
		return
	}

	// Calculate block transaction counts and write to JSON file
	if err := calculateBlockTransactionCounts(txLogs, blockTransactionFile); err != nil {
		fmt.Printf("[ERROR] Failed to calculate block transaction counts: %v\n", err)
		return
	}

	fmt.Println("[INFO] All calculations completed successfully.")
}
