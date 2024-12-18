# AHB Verification IP (VIP)

---

## 🚀 Overview
This repository contains the **Verification IP (VIP) for the AMBA Advanced High-Performance Bus (AHB)** protocol, designed using **SystemVerilog** and **Universal Verification Methodology (UVM)**. The project ensures comprehensive verification of AHB protocol functionalities through modular, reusable testbenches and robust assertion-based checking.

## 🚀 Overall Architectural View
![gite](https://github.com/user-attachments/assets/241caee2-5a78-4eb5-b636-8c5f81a39e5f)

---

## ✨ Features
- **Verification Components (UVCs):** Modular testbench architecture for Manager and Subordinate components.
- **SystemVerilog Assertions (SVA):** Ensures compliance with AHB protocol specifications.
- **Scoreboard Implementation:** Validates data integrity between Manager and Subordinate.
- **Coverage Metrics:** Functional and code coverage to assess verification completeness.
- **Supported Transactions:** Single bursts, incremental bursts (INCR4, INCR8, INCR16), wrapping bursts (WRAP4, WRAP8, WRAP16).

---

## 📂 Repository Structure
```plaintext
├── manager_uvc/
│   ├── sequencer.sv
│   ├── driver.sv
│   ├── monitor.sv
│   └── assertions.sv
├── subordinate_uvc/
│   ├── sequencer.sv
│   ├── driver.sv
│   ├── monitor.sv
│   └── assertions.sv
├── top_uvc/
│   ├── scoreboard.sv
│   ├── manager_instance.sv
│   ├── subordinate_instance.sv
│   └── tests/
│       ├── single_burst_test.sv
│       ├── incr4_test.sv
│       ├── incr8_test.sv
│       ├── wrap4_test.sv
│       └── full_coverage_test.sv
├── docs/
│   ├── AHB_protocol_overview.pdf
│   ├── VIP_architecture_diagram.png
│   ├── functional_coverage_report.txt
│   └── code_coverage_report.txt
└── README.md
```

---

## 🛠 Methodology
1. **Manager UVC:** 
   - Sequencer generates transaction sequences.
   - Driver drives transactions onto the Manager interface.
   - Monitor checks the protocol compliance using assertions.
   - Coverage tracks transaction types (Single, Increment, Wrap).
   
2. **Subordinate UVC:**
   - Sequencer generates response sequences.
   - Driver simulates Subordinate behavior.
   - Monitor validates compliance and signal correctness.
   - Assertions include error responses, ready signal handling, and data integrity checks.
   
3. **Top UVC:**
   - Integrates Manager and Subordinate UVCs.
   - Scoreboard validates data transfer integrity and timing.
   - Includes tests for multiple transaction types and corner cases.

---

## 📊 Coverage
- **Functional Coverage:**
  - Ensures adherence to AHB protocol rules and specifications.
  - Validates all defined transaction types and edge cases.
  
- **Code Coverage:**
  - Measures execution of testbench and design code.
  - Highlights untested paths and unused design features.

---

## 🔧 How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ahb-vip.git
   ```
2. Set up the required simulation environment (SystemVerilog and UVM libraries).
3. Run tests:
   ```bash
   cd top_uvc/tests
   make run_test TEST=<test_name>
   ```
4. Analyze coverage results in the `docs/` directory.

---

## 👥 Contributors
- **Usama Ahmed**  
- **Ahmad Mukhtar**  
- **Khizer Mehmood**  
- **Coordinator:** Hira Sohail  

---

## 📜 License
The licensed is under process.  

For further details, refer to the [documentation](https://github.com/ahmadamukhtar/UVM_PROJECT_AHB_VIP-/edit/main/AHB_protocol_overview.pdf) or contact the contributors.  

--- 

**🌟 Happy Verifying!** 


