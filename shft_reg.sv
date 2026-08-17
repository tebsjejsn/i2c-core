module shft_reg(
    input  logic       scl,
    input  logic       sdaIn,
    input  logic       reset,
    input  logic [7:0] txData,
    input  logic       load,
    input  logic       en,
    output logic [7:0] rxData,
    output logic       sdaOut
);
    // write states
    // shift bits when writing 0 (or ack bit?). otherwise, output z
endmodule