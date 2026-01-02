
module alu_tb;
    parameter WIDTH = 32;
    
    reg [WIDTH-1:0] a, b;
    reg [3:0] opcode;
    wire [WIDTH-1:0] out;
    wire zero, carry, overflow, sign;
    
    // Instantiate ALU
    alu #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .out(out),
        .zero(zero),
        .carry(carry),
        .overflow(overflow),
        .sign(sign)
    );
    
    // Test cases
    initial begin
        $monitor("Time=%0t A=%h B=%h Op=%b Out=%h Z=%b C=%b O=%b S=%b",
                $time, a, b, opcode, out, zero, carry, overflow, sign);
        
        // Test ADD
        #10 a = 32'h00000005; b = 32'h00000003; opcode = 4'b0000;
        
        // Test SUB
        #10 a = 32'h0000000A; b = 32'h00000003; opcode = 4'b0001;
        
        // Test AND
        #10 a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; opcode = 4'b0010;
        
        // Test OR
        #10 a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; opcode = 4'b0011;
        
        // Test XOR
        #10 a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; opcode = 4'b0100;
        
        // Test SLL
        #10 a = 32'h00000001; b = 32'h00000004; opcode = 4'b0111;
        
        // Test SRL
        #10 a = 32'h80000000; b = 32'h00000001; opcode = 4'b1000;
        
        // Test SRA
        #10 a = 32'h80000000; b = 32'h00000001; opcode = 4'b1001;
        
        #10 $finish;
    end
endmodule