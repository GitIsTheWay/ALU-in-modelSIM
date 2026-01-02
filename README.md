# ALU-in-modelSIM
ALU VERILOG PROJECT

Files included:
1. alu.v - 32-bit ALU with 16 operations
2. alu_tb.v - Testbench with sample tests

How to run in ModelSim:
1. Open ModelSim
2. Type these commands:

vlog alu.v alu_tb.v
vsim alu_tb
add wave *
run 200ns

Expected results:
- Test 1: 5 + 3 = 8
- Test 2: 10 - 3 = 7
- Test 3: 5 & 3 = 1
