module i2c_slave (
 input wire scl,
 input wire rst,
 inout wire sda,
 output reg [7:0] data_out,
 output reg [2:0] state,
 output bit_scl,
 output bit_sda,
 output rst1,
 input start
);
 
 reg [2:0] bit_count;
 reg [3:0] counter;
 reg sda_dir;
 reg sda_out;
 reg [7:0] shift_reg;
 reg [7:0] shift_reg_addr;
 reg rw_bit;
 reg [7:0] tx_reg;

 parameter address = 8'b11100010;

 assign sda = sda_dir ? sda_out : 1'bz;
 
 localparam IDLE = 3'b001,
            RECV = 3'b010,
            ACK = 3'b011,
            WRITE = 3'b100, 
            ACK_DATA = 3'b101, 
            STOP = 3'b110;

 always @(negedge scl or posedge rst) begin
 if (rst) 
 begin
     state <= IDLE;
     bit_count <= 0;
     sda_dir <= 0;
     shift_reg <= 0;
     shift_reg_addr <= 0;
     sda_out <= 1; 
     counter <= 8;
     rw_bit <= 0;
     tx_reg <= 8'b10101010;
 end 
 else 
 begin
 case (state)

 IDLE: 
 begin
     if (sda==0 && start==1) 
     begin
         counter <= 8;
         state <= RECV;
     end
 end
 
 RECV: 
 begin
     shift_reg_addr[counter-1] = sda; 
     counter <= counter -1;

     if(counter == 0)
     begin
         rw_bit <= shift_reg_addr[0];

         if(address == shift_reg_addr)
         begin
             sda_dir <= 1;
             sda_out <= 0;
             state <= ACK;
         end
         else
             state <= STOP;
     end
 end
 
 ACK: 
 begin
     counter <= 8;

     if (rw_bit == 1'b0)
     begin
         state <= WRITE;
     end
     else
     begin
         state <= WRITE;
     end
 end
 
 WRITE: 
 begin
     if (rw_bit == 1'b0)
     begin
         shift_reg[counter-1] = sda; 
         counter <= counter -1;

         if(counter == 0)
         begin
             sda_dir <= 1;
             sda_out <= 0;
             state <= ACK_DATA;
         end
     end
     else
     begin
         sda_dir <= 1;
         sda_out <= tx_reg[counter-1];
         counter <= counter -1;

         if(counter == 0)
         begin
             sda_dir <= 0;
             state <= ACK_DATA;
         end
     end
 end

 ACK_DATA: 
 begin
     if (rw_bit == 1'b0)
     begin
         data_out <= shift_reg;
     end
     state <= STOP;
 end
 
 STOP: 
 begin
     sda_dir <= 0;
     state <= IDLE;
 end

 endcase
 end
 end

 assign bit_sda = sda;
 assign bit_scl = scl;
 assign rst1 = rst;

endmodule
