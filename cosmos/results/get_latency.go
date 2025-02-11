package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
)

func main() {
	// CSV 파일 열기
	file, err := os.Open("latency.csv") // CSV 파일 경로
	if err != nil {
		log.Fatalf("Failed to open file: %s", err)
	}
	defer file.Close()

	// CSV 리더 생성
	reader := csv.NewReader(file)

	// 첫 번째 줄 읽기 (헤더 탐지)
	headers, err := reader.Read()
	if err != nil {
		log.Fatalf("Failed to read header: %s", err)
	}

	// "latency" 열의 인덱스 찾기
	latencyIndex := -1
	for i, header := range headers {
		if header == "latency" {
			latencyIndex = i
			break
		}
	}

	// "latency" 열이 없는 경우 처리
	if latencyIndex == -1 {
		log.Fatal("No 'latency' column found in the CSV file.")
	}

	// 데이터 읽기 및 "latency" 값 추출
	var latencies []string
	for {
		record, err := reader.Read()
		if err != nil { // 파일 끝 또는 에러 발생 시 종료
			break
		}

		// "latency" 값 추출
		latencies = append(latencies, record[latencyIndex])
	}

	// 새로운 파일에 저장
	outFile, err := os.Create("latency_only.csv")
	if err != nil {
		log.Fatalf("Failed to create output file: %s", err)
	}
	defer outFile.Close()

	writer := csv.NewWriter(outFile)
	defer writer.Flush()

	// 첫 번째 줄에 "latency" 추가
	writer.Write([]string{"latency"})

	// "latency" 값 작성
	for _, latency := range latencies {
		writer.Write([]string{latency})
	}

	fmt.Println("Latencies successfully extracted to 'latency_only.csv'")
}

