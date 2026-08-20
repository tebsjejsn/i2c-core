module shft_reg(
    input  logic       clk,
    input  logic       scl,
    input  logic       reset,
    input  logic       sdaIn,
    input  logic [7:0] txData,
    input  logic       load,
    input  logic       en,
    output logic [7:0] rxData,
    output logic       sdaOut
);
    logic [7:0] data;
    logic       sclPrev;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            data <= '0;
            sclPrev <= '1;
        end
        else begin
            sclPrev <= scl;

            if (load) begin
                    data <= txData;
                end
            else if (en == '1 && scl == '1 && sclPrev == '0) begin
                data <= {data[6:0], sdaIn};
            end
        end
    end

    assign sdaOut = data[7];
    assign rxData = data;
endmodule