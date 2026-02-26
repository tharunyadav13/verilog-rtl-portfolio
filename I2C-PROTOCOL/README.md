# I2C Protocol Verification (SystemVerilog)

##  Project Overview

This project implements and verifies an I2C Slave design using 
SystemVerilog verification architecture.

The verification environment includes:
- Transaction-based stimulus generation
- Driver
- Monitor
- Scoreboard
- Assertions (SVA)
- Functional Coverage

The design models open-drain SDA behavior and supports
read and write transactions.

---

##  What is I2C?

I2C (Inter-Integrated Circuit) is a synchronous serial 
communication protocol using two wires:

I2C--> is half duplex 

- SDA (Serial Data Line)
- SCL (Serial Clock Line)

It supports multiple masters and multiple slaves 
with open-drain architecture.

---

##  I2C Protocol Rules

- START: SDA transitions HIGH → LOW while SCL is HIGH
- STOP: SDA transitions LOW → HIGH while SCL is HIGH
- Data changes only when SCL = 0
- Data is sampled when SCL = 1
- Each transfer = 8 data bits + 1 ACK/NACK bit
- ACK = Receiver pulls SDA LOW on 9th clock
- SDA is open-drain (devices only pull LOW)

---

## 🏗 Project Architecture
