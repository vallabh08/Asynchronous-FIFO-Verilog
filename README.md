# Introduction
This repository contains a complete Verilog implementation of an Asynchronous First-In, First-Out (FIFO) memory buffer. In modern digital systems, it's common for different modules to operate on separate, unsynchronized clocks. Passing data between these "clock domains" is a major challenge, as it can lead to timing violations and a critical failure state known as metastability.

This Asynchronous FIFO is designed to be a robust and reliable solution to this Clock Domain Crossing (CDC) problem. It acts as a safe, elastic buffer that allows data to be written from one clock domain and read from another without data loss or corruption, ensuring the stability and integrity of the entire system.

# Features
This FIFO design incorporates several industry-standard features to ensure robust and reliable operation:

1) CDC Safe by Design: The core architecture is built specifically to handle asynchronous clock domains safely.

2) Gray Code Pointers: Pointers are converted to Gray code before being passed between clock domains. This ensures that only one bit changes at a time, preventing data corruption during synchronization even if the pointer is sampled while changing.

3) 2-Flip-Flop Synchronizers: A standard 2-FF synchronizer is used to safely transfer the Gray code pointers across clock domains, drastically minimizing the probability of metastability propagating through the system.

4) Robust Full and Empty Flags: The design includes reliable wfull and rempty flags to prevent overflow (writing to a full FIFO) and underflow (reading from an empty FIFO). The logic correctly anticipates the full condition to provide maximum safety.

5) Parameterized Design: The data width (DATA_SIZE) and FIFO depth (ADDR_SIZE) are fully parameterized, making the design easily reusable and adaptable for different applications.

6) Modular and Readable Code: The project is broken down into logical, well-commented modules (memory, pointer logic, synchronizer), making it easy to understand, maintain, and integrate.

7) Fully Verified: The design is accompanied by a self-checking Verilog testbench that performs a series of stress tests to validate its correctness, including overflow and underflow conditions.

# Verification and Simulation Results

The FIFO design was rigorously verified using a self-checking Verilog testbench. The testbench simulates a real-world scenario with different, asynchronous write and read clocks (wclk @ 100MHz, rclk @ 62.5MHz) and performs a series of stress tests. The following waveforms demonstrate the correct behavior of the FIFO during key operational phases.

<img width="1549" height="703" alt="Screenshot 2025-07-19 143906" src="https://github.com/user-attachments/assets/ed3804fb-c461-4745-b364-3c0df948161e" />

### Initial Write and Read Operation
This waveform shows the start of the simulation.

1) Reset: Initially, the active-low resets (wr_rstn, rd_rstn) are held low, and the rempty flag is correctly asserted high.

2) First Write: After the reset is released, the first write operation occurs (see wr_en pulse). Immediately, the rempty flag goes low, correctly indicating that the FIFO now contains data.

3) Read Latency: The rd_en signal is high, requesting a read. The data written (56) appears on the rd_data bus after a one-cycle read latency, which is the expected behavior for this type of memory.

<img width="1551" height="703" alt="Screenshot 2025-07-19 143931" src="https://github.com/user-attachments/assets/d57f7820-4860-43a4-856f-2e27016a8e33" />

### Continuous Asynchronous Operation
This waveform captures the FIFO during continuous, simultaneous read and write operations.

1) Asynchronous Clocks: The wclk and rclk are clearly running at different frequencies.

2) Data Flow: Data is being written (wr_en pulses) and read (rd_en pulses) concurrently. You can see the data values flowing from the wr_data input to the rd_data output after buffering inside the FIFO.

3) Status Flags: During this phase, the FIFO is neither full nor empty, so both the wfull and rempty flags remain correctly de-asserted (low).

<img width="1550" height="702" alt="Screenshot 2025-07-19 143955" src="https://github.com/user-attachments/assets/79f33d23-ee90-4f74-8f3b-f5b1d8f376d9" />

### Sustained Data Transfer
This final waveform shows a later stage of the sustained data transfer test.

1) Data Integrity: The data being read out on rd_data continues to correctly match the sequence of data that was previously written, confirming that no data is being lost or corrupted during the clock domain crossing.

2) Stable Operation: The design remains stable and operates as expected over a long period of simultaneous read and write operations, proving the robustness of the CDC synchronization logic.

# Conclusion
This project successfully implements a critical component used in complex digital and SoC designs. By correctly applying fundamental CDC principles like Gray coding and multi-flop synchronization, this Asynchronous FIFO provides a reliable method for transferring data across different clock domains. The modular design and thorough verification demonstrate a complete and robust engineering solution suitable for real-world applications.
