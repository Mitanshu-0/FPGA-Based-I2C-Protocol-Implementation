module master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg scl,
    inout wire sda,
    output reg done,
    output reg [3:0] state,
    output wire bit_scl,
    output wire bit_sda,
    input wire clk_1
);

    parameter FIXED_ADDRESS = 7'b1110001;

    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg sda_out;
    reg sda_en;

    assign bit_sda = sda;
    assign bit_scl = scl;
    
    reg [25:0] clk_div;
    parameter CLK_DIVIDER = 50000000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div <= 0;
            scl <= 1;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div >= CLK_DIVIDER) begin
                scl <= ~scl;
                clk_div <= 0;
            end
        end
    end

    assign sda = sda_en ? sda_out : 1'bz;

    localparam IDLE          = 4'b0001,
               START         = 4'b0010,
               SEND_ADDRESS  = 4'b0011,
               WAIT_ACK      = 4'b0100,
               SEND_DATA     = 4'b0101,
               WAIT_ACK_DATA = 4'b0110,
               STOP          = 4'b0111,
               HOLD          = 4'b1000;

    always @(posedge scl or posedge reset) begin
        if (reset) 
        begin
            state <= IDLE;
            sda_en <= 0;
            done <= 0;
        end 
        else 
        begin
            case (state)

                IDLE: begin
                    if(start) 
                    begin
                        state <= START;
                        sda_en <= 1;
                        sda_out <= 0;
                    end
                end

                START: 
                begin
                    shift_reg <= {FIXED_ADDRESS, 1'b0};
                    bit_count <= 8;
                    state <= SEND_ADDRESS;
                end

                SEND_ADDRESS: 
                begin
                    if (bit_count > 0) 
                    begin
                        sda_out <= shift_reg[7];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end 
                    else 
                    begin
                        state <= HOLD;
                        sda_en <= 0;
                    end
                end

                WAIT_ACK: 
                begin
                    if(sda == 0) 
                    begin
                        shift_reg <= data_in;
                        bit_count <= 8;
                        state <= SEND_DATA;
                        sda_en <= 1;
                    end 
                    else 
                    begin
                        state <= STOP;
                    end
                end
                     
                HOLD:
                begin
                    state <= WAIT_ACK;
                end

                SEND_DATA: 
                begin
                    if (bit_count > 0) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end else begin
                        state <= WAIT_ACK_DATA;
                        sda_en <= 0;
                    end
                end

                WAIT_ACK_DATA: 
                begin
                    if (sda == 0) begin
                        state <= STOP;
                    end else begin
                        state <= STOP;
                    end
                end

                STOP: 
                begin
                    sda_out <= 1;
                    sda_en <= 0;
                    done <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end
endmodule
