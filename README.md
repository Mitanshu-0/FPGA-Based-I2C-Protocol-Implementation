# FPGA-Based-I2C-Protocol-Implementation

## Overview

This project presents the implementation of the Inter-Integrated Circuit (I2C) communication protocol using Verilog HDL on FPGA. The design includes both I2C Master and I2C Slave modules, enabling serial communication between devices through the standard two-wire I2C interface consisting of Serial Clock Line (SCL) and Serial Data Line (SDA).

The project demonstrates address matching, acknowledgment generation, data transmission, data reception, and finite state machine (FSM) based control logic.

---

## Project Objectives

- Understand the I2C communication protocol.
- Implement I2C Master and I2C Slave modules in Verilog HDL.
- Design FSM-based communication architecture.
- Simulate and verify communication between master and slave devices.
- Develop an FPGA-compatible implementation.

---

## Features

### I2C Master

- Generates START condition
- Sends slave address
- Performs data transmission
- Receives acknowledgment from slave
- Generates STOP condition

### I2C Slave

- Detects START condition
- Receives and verifies slave address
- Generates acknowledgment (ACK)
- Receives data from master
- Stores received data
- Supports bidirectional SDA communication

---

## System Architecture

```text
Master Device
     │
     │ SDA / SCL
     ▼
Slave Device
```

Communication Flow:

```text
START
   │
   ▼
Send Address
   │
   ▼
Address Match
   │
   ▼
ACK
   │
   ▼
Data Transfer
   │
   ▼
ACK
   │
   ▼
STOP
```

---

## Finite State Machines

### Master FSM

```text
IDLE
  │
  ▼
START
  │
  ▼
SEND_ADDRESS
  │
  ▼
WAIT_ACK
  │
  ▼
SEND_DATA
  │
  ▼
WAIT_ACK_DATA
  │
  ▼
STOP
```

### Slave FSM

```text
IDLE
  │
  ▼
RECV
  │
  ▼
ACK
  │
  ▼
WRITE
  │
  ▼
ACK_DATA
  │
  ▼
STOP
```

---

## Project Structure

```text
FPGA-Based-I2C-Protocol-Implementation
│
├── README.md
│
├── docs
│   └── Project_Report.pdf
│
└── src
    ├── i2c_master.v
    └── i2c_slave.v
```

---

## Source Files

### i2c_master.v

Implements the I2C Master Controller responsible for:

- Clock generation
- START condition generation
- Address transmission
- Data transmission
- ACK handling
- STOP condition generation

### i2c_slave.v

Implements the I2C Slave Controller responsible for:

- Address detection
- Address verification
- Data reception
- ACK generation
- Data storage
- State machine control

---

## Design Methodology

1. Generate I2C clock signal.
2. Initiate START condition.
3. Transmit slave address.
4. Verify address match.
5. Generate acknowledgment.
6. Transfer data.
7. Receive acknowledgment.
8. Generate STOP condition.
9. Return to IDLE state.

---

## Simulation

The design was verified through simulation using Verilog HDL.

Simulation validates:

- Address transmission
- Address matching
- ACK generation
- Data transfer
- State transitions
- STOP condition handling

---

## Tools Used

- Verilog HDL
- FPGA Design Flow
- Xilinx Vivado
- RTL Design Methodology
- Digital System Design Techniques

---

## Applications

- Embedded Systems
- Sensor Interfaces
- FPGA-Based Controllers
- Microcontroller Communication
- IoT Devices
- Peripheral Device Communication

---

## Documentation

Detailed project report:

📄 `docs/Project_Report.pdf`

The report includes:

- Introduction to I2C Protocol
- State-of-the-Art Analysis
- Limitations of Existing Technology
- Proposed Methodology
- Flowchart
- RTL View
- Technology Schematic
- Simulation Waveforms
- Conclusion

---

## Future Improvements

- Support for Multiple Slave Devices
- 10-bit Addressing
- High-Speed I2C Mode
- Clock Stretching Support
- Read and Write Mode Extensions
- Multi-Master Support

---

## Author

**Mitanshu Dhameliya**  
B.Tech Electronics and Communication Engineering  
Institute of Technology, Nirma University

---

## License

This project is intended for educational and academic purposes.
