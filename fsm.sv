module fsm(
    input  logic       clk,
    input  logic       scl,
    input  logic       reset,
    input  logic       cmd,
    input  logic       sclIn,
    input  logic       sdaIn,
    output logic       ready,
    output logic       en,
    output logic       load,
    output logic       sclOe,
    output logic       sdaOe
);
    logic [2:0] count;
    logic       sclPrev;

    typedef enum logic [3:0] {
        IDLE,
        START,
        ADDR,
        ACK1,
        WRITE,
        ACK2,
        READ,
        ACK3,
        STOP
    } statetype;

    statetype state, nextState;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            ready <= '0;
            count <= '0;
            sclPrev <= '1;
            state <= IDLE;
        end
        else begin
            sclPrev <= scl;
            state <= nextState;

            if (state == START)
                    count <= '0;

            if (scl == '1 && sclPrev == '0)
                if (state == ADDR)
                    count <= count + 1;
        end
    end

    always_comb begin
        nextState = state;
        sdaOe = '0;
        sclOe = '0;
        en = '0;
        load = '0;

        case (state)
            IDLE:
                if (cmd)
                    nextState = START;
            START: begin
                load = '1;
                nextState = ADDR;
            end
            ADDR: begin
                en = '1;
                sdaOe = '1;
                sclOe = '1;

                if (count == 3'd7 && scl == '0 && sclPrev == '1)
                    nextState = ACK1;
            end
        endcase
    end
endmodule