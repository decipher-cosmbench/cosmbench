# Cosmbench

Welcome to **Cosmbench**, a cutting-edge benchmarking repository meticulously developed and maintained by the **Decipher** team. This project serves as a foundational component of our research, which we will be presenting at **DE-FERENCE 2025**.

## Overview

Blockchain technology is often measured and evaluated based on its **Transactions Per Second (TPS)** claims. However, these figures are frequently based on theoretical or ideal conditions rather than real-world performance. At **Cosmbench**, our goal is to critically assess and validate these claims by directly measuring the TPS of various blockchain networks under realistic conditions.

Through rigorous testing, we aim to provide a more accurate and practical understanding of blockchain performance. This repository contains scripts, logs, and result data for different blockchain networks to ensure transparency and reproducibility.

## Repository Structure

This repository is systematically organized into multiple blockchain-related directories, each containing scripts and documentation specific to that network. Below is the list of blockchain ecosystems we currently support:

### How to Run Benchmarks for Each Network

> **Note:**
> - The benchmarking scripts are designed to run in a **Linux environment**, and we highly recommend using **Ubuntu 22.04 LTS** for the best compatibility and performance.
> - Before running the benchmarks, make sure to **pull all required binary files** using the following command:
>   ```bash
>   git lfs pull
>   ```

- [Axelar](axelar/README.md)
- [Cosmos](cosmos/README.md)
- [Injective](injective/README.md)
- [Sei](sei/README.md)
- [Celestia](celestia/README.md)(TBD)
- [Cronos](cronos/README.md)(TBD)

Each directory contains essential benchmarking scripts, performance logs, and result files, providing an extensive look into each blockchain's actual transaction handling capacity.

### Binary Versions

The benchmarking process requires specific blockchain binaries. Below are the versions used for each network:

| Blockchain | Binary Version |
|------------|---------------|
| **Injective** | Mainnet-v1.13.2 |
| **Cronos** | v1.4.1 |
| **Axelar** | v1.1.0-4-gee4809d3 |
| **Celestia** | v1.7.0 |
| **Cosmos** | v0.50.11 |
| **Sei** | v6.0.1 |

Ensure that you are using the correct versions to maintain consistency in benchmarking results.

## Contribution & Community

We welcome contributions from the blockchain and research community to further enhance our benchmarking methodologies. If you are interested in collaborating with us, feel free to **open an issue, submit a pull request, or reach out to our team**.

Our goal is to foster a more transparent and empirical approach to blockchain performance evaluation, helping developers, researchers, and industry experts make informed decisions.

---

For more details, refer to the respective directories above or contact the **Decipher Cosmbench** team. We appreciate your interest and support in making blockchain performance evaluation more accurate and reliable.