// Parameterized ALU with multiple operations - CORRECTED VERSION
module alu #(
    parameter WIDTH = 32          // Data width (default 32-bit)
) (
    input wire [WIDTH-1:0] a,    // Operand A
    input wire [WIDTH-1:0] b,    // Operand B
    input wire [3:0] opcode,     // Operation code
    output reg [WIDTH-1:0] out,  // Result
    output reg zero,             // Zero flag
    output reg carry,            // Carry flag
    output reg overflow,         // Overflow flag
    output reg sign              // Sign flag
);

    // Define operation codes
    localparam [3:0]
        OP_ADD  = 4'b0000,   // Addition
        OP_SUB  = 4'b0001,   // Subtraction
        OP_AND  = 4'b0010,   // Bitwise AND
        OP_OR   = 4'b0011,   // Bitwise OR
        OP_XOR  = 4'b0100,   // Bitwise XOR
        OP_NOT  = 4'b0101,   // Bitwise NOT (on A)
        OP_NOR  = 4'b0110,   // Bitwise NOR
        OP_SLL  = 4'b0111,   // Shift Left Logical
        OP_SRL  = 4'b1000,   // Shift Right Logical
        OP_SRA  = 4'b1001,   // Shift Right Arithmetic
        OP_LT   = 4'b1010,   // Set Less Than (signed)
        OP_LTU  = 4'b1011,   // Set Less Than (unsigned)
        OP_EQ   = 4'b1100,   // Equality comparison
        OP_NE   = 4'b1101,   // Not equal comparison
        OP_PASS = 4'b1110;   // Pass through A

    // Internal signals - FIXED: shift_amount as wire for continuous assignment
    reg [WIDTH-1:0] result;
    reg [WIDTH:0] add_sub_result;  // Extra bit for carry
    wire [WIDTH-1:0] shift_amount;  // CHANGED FROM reg TO wire

    // Extract shift amount from lower bits of B - THIS IS OK NOW
    assign shift_amount = b[($clog2(WIDTH))-1:0];

    // Arithmetic operations with extended width for flags
    always @(*) begin
        case(opcode)
            OP_ADD: begin
                add_sub_result = {1'b0, a} + {1'b0, b};
                result = add_sub_result[WIDTH-1:0];
                carry = add_sub_result[WIDTH];
                // Overflow for signed addition
                overflow = (a[WIDTH-1] == b[WIDTH-1]) && 
                          (result[WIDTH-1] != a[WIDTH-1]);
            end
            
            OP_SUB: begin
                add_sub_result = {1'b0, a} - {1'b0, b};
                result = add_sub_result[WIDTH-1:0];
                carry = add_sub_result[WIDTH];
                // Overflow for signed subtraction
                overflow = (a[WIDTH-1] != b[WIDTH-1]) && 
                          (result[WIDTH-1] != a[WIDTH-1]);
            end
            
            OP_AND: begin
                result = a & b;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_OR: begin
                result = a | b;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_XOR: begin
                result = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_NOT: begin
                result = ~a;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_NOR: begin
                result = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_SLL: begin
                result = a << shift_amount;
                carry = (shift_amount > 0) ? a[WIDTH - shift_amount] : 1'b0;
                overflow = 1'b0;
            end
            
            OP_SRL: begin
                result = a >> shift_amount;
                carry = (shift_amount > 0) ? a[shift_amount - 1] : 1'b0;
                overflow = 1'b0;
            end
            
            OP_SRA: begin
                result = $signed(a) >>> shift_amount;
                carry = (shift_amount > 0) ? a[shift_amount - 1] : 1'b0;
                overflow = 1'b0;
            end
            
            OP_LT: begin
                result = ($signed(a) < $signed(b)) ? {WIDTH{1'b1}} : {WIDTH{1'b0}};
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_LTU: begin
                result = (a < b) ? {WIDTH{1'b1}} : {WIDTH{1'b0}};
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_EQ: begin
                result = (a == b) ? {WIDTH{1'b1}} : {WIDTH{1'b0}};
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_NE: begin
                result = (a != b) ? {WIDTH{1'b1}} : {WIDTH{1'b0}};
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            OP_PASS: begin
                result = a;
                carry = 1'b0;
                overflow = 1'b0;
            end
            
            default: begin
                result = {WIDTH{1'b0}};
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
        
        // Set flags
        zero = (result == 0);
        sign = result[WIDTH-1];
        
        // Output assignment
        out = result;
    end

endmodule