module clk_gen
#(
    // 100 KHz or 400 KHz (fast mode)
    parameter MODE = 100000,
    // 100 MHz
    parameter CLK_FREQ = 100000000
) (
    input  logic clk,
    input  logic reset,
    output logic scl
);
    localparam DIVIDER = CLK_FREQ / MODE / 2;
    
    logic [15:0] count;
    logic        sclTrack;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= '0;
            sclTrack <= 1'b1;
        end
        else if (count == DIVIDER - 1) begin
            count <= '0;
            sclTrack <= ~sclTrack;
        end
        else 
            count <= count + 1;
    end

    assign scl = (sclTrack == 1'b0) ? 1'b0 : 1'bz;
endmodule