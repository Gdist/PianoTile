module test(clk,rst,dot_row,dot_col);
	
	input clk,rst;
	output reg [7:0] dot_row;
	output reg [15:0] dot_col;
	
	reg [15:0] dot_col_buff[0:7];

	reg [15:0] dot_col_display[0:7];
	reg [15:0] dot_col_map;
	reg [2:0] row_count;
	reg [4:0] count;
	// for buttom sample
	reg [31:0] cnt_4Hz;
	reg clk_4Hz;
	always@(posedge clk or negedge rst)
	begin
		if (~rst)
		begin
			cnt_4Hz <= 32'd0;
			clk_4Hz <= 1'd0;
		end
		else begin
			if (cnt_4Hz == 6250000) 
			begin
				clk_4Hz <= ~clk_4Hz;
				cnt_4Hz <= 32'd0;
			end
			else
			begin
				cnt_4Hz <= cnt_4Hz + 32'd1;
			end	
		end
	end
	
	
	//////////////////////////////////////////////
	// For dot matrix display
	reg [31:0] cnt_dot;
	reg display_dot;
	always@(posedge clk or negedge rst)
	begin
		if (~rst)
		begin
			cnt_dot <= 32'd0;
			display_dot <= 1'b0;
		end
		else
		begin
			if (cnt_dot == 5000) 
			begin
				display_dot <= ~display_dot;
				cnt_dot <= 32'd0;
			end
			else
			begin
				cnt_dot <= cnt_dot + 32'd1;
			end	
		end
	end
	//row controller
	always@ (posedge display_dot or negedge rst)
	begin
		if (~rst)
		begin
			dot_row <= 8'd0;
			dot_col <= 16'd0;
			row_count <= 3'd0;
		end
		else
		begin
		    row_count <= row_count + 1;
			 dot_col <= dot_col_display[row_count];
		    case (row_count)
				3'd0: dot_row <= 8'b01111111;
				3'd1: dot_row <= 8'b10111111;
				3'd2: dot_row <= 8'b11011111;
				3'd3: dot_row <= 8'b11101111;
				3'd4: dot_row <= 8'b11110111;
				3'd5: dot_row <= 8'b11111011;
				3'd6: dot_row <= 8'b11111101;
				3'd7: dot_row <= 8'b11111110;
			endcase
		end
	end
	always@(posedge clk_4Hz or negedge rst)
	begin
		if(~rst)
		begin
			count <= 5'b00000;
			dot_col_buff[0] <= 16'b1100100100001000;
			dot_col_buff[1] <= 16'b1100100100001000;
			dot_col_buff[2] <= 16'b0000000000000000;
			dot_col_buff[3] <= 16'b0100100010010001;
			dot_col_buff[4] <= 16'b0100100010010001;
			dot_col_buff[5] <= 16'b0000000000000000;
			dot_col_buff[6] <= 16'b1010010001001001;
			dot_col_buff[7] <= 16'b1010010001001001;
			
			dot_col_display[0] <= 16'b0000000000000000;
			dot_col_display[1] <= 16'b0000000000000000;
			dot_col_display[2] <= 16'b0000000000000000;
			dot_col_display[3] <= 16'b0000000000000000;
			dot_col_display[4] <= 16'b0000000000000000;
			dot_col_display[5] <= 16'b0000000000000000;
			dot_col_display[6] <= 16'b0000000000000000;
			dot_col_display[7] <= 16'b0000000000000000;
			dot_col_map <= 16'b0000000000000000;
		end
		else
			if(count <= 5'b01111)
			begin
				case(count)
					5'b00000:
					begin
						dot_col_display[0] <= {dot_col_buff[0][0],dot_col_map[14:0]};
						dot_col_display[1] <= {dot_col_buff[1][0],dot_col_map[14:0]};
						dot_col_display[2] <= {dot_col_buff[2][0],dot_col_map[14:0]};
						dot_col_display[3] <= {dot_col_buff[3][0],dot_col_map[14:0]};
						dot_col_display[4] <= {dot_col_buff[4][0],dot_col_map[14:0]};
						dot_col_display[5] <= {dot_col_buff[5][0],dot_col_map[14:0]};
						dot_col_display[6] <= {dot_col_buff[6][0],dot_col_map[14:0]};
						dot_col_display[7] <= {dot_col_buff[7][0],dot_col_map[14:0]};
						count <= count + 5'b00001;						
					end
					5'b00001:
					begin
						dot_col_display[0] <= {dot_col_buff[0][1:0],dot_col_map[13:0]};
						dot_col_display[1] <= {dot_col_buff[1][1:0],dot_col_map[13:0]};
						dot_col_display[2] <= {dot_col_buff[2][1:0],dot_col_map[13:0]};
						dot_col_display[3] <= {dot_col_buff[3][1:0],dot_col_map[13:0]};
						dot_col_display[4] <= {dot_col_buff[4][1:0],dot_col_map[13:0]};
						dot_col_display[5] <= {dot_col_buff[5][1:0],dot_col_map[13:0]};
						dot_col_display[6] <= {dot_col_buff[6][1:0],dot_col_map[13:0]};
						dot_col_display[7] <= {dot_col_buff[7][1:0],dot_col_map[13:0]};
						count <= count + 5'b00001;						
					end
					5'b00010:
					begin
						dot_col_display[0] <= {dot_col_buff[0][2:0],dot_col_map[12:0]};
						dot_col_display[1] <= {dot_col_buff[1][2:0],dot_col_map[12:0]};
						dot_col_display[2] <= {dot_col_buff[2][2:0],dot_col_map[12:0]};
						dot_col_display[3] <= {dot_col_buff[3][2:0],dot_col_map[12:0]};
						dot_col_display[4] <= {dot_col_buff[4][2:0],dot_col_map[12:0]};
						dot_col_display[5] <= {dot_col_buff[5][2:0],dot_col_map[12:0]};
						dot_col_display[6] <= {dot_col_buff[6][2:0],dot_col_map[12:0]};
						dot_col_display[7] <= {dot_col_buff[7][2:0],dot_col_map[12:0]};
						count <= count + 5'b00001;						
					end
					5'b00011:
					begin
						dot_col_display[0] <= {dot_col_buff[0][3:0],dot_col_map[11:0]};
						dot_col_display[1] <= {dot_col_buff[1][3:0],dot_col_map[11:0]};
						dot_col_display[2] <= {dot_col_buff[2][3:0],dot_col_map[11:0]};
						dot_col_display[3] <= {dot_col_buff[3][3:0],dot_col_map[11:0]};
						dot_col_display[4] <= {dot_col_buff[4][3:0],dot_col_map[11:0]};
						dot_col_display[5] <= {dot_col_buff[5][3:0],dot_col_map[11:0]};
						dot_col_display[6] <= {dot_col_buff[6][3:0],dot_col_map[11:0]};
						dot_col_display[7] <= {dot_col_buff[7][3:0],dot_col_map[11:0]};	
						count <= count + 5'b00001;					
					end
					5'b00100:
					begin
						dot_col_display[0] <= {dot_col_buff[0][4:0],dot_col_map[10:0]};
						dot_col_display[1] <= {dot_col_buff[1][4:0],dot_col_map[10:0]};
						dot_col_display[2] <= {dot_col_buff[2][4:0],dot_col_map[10:0]};
						dot_col_display[3] <= {dot_col_buff[3][4:0],dot_col_map[10:0]};
						dot_col_display[4] <= {dot_col_buff[4][4:0],dot_col_map[10:0]};
						dot_col_display[5] <= {dot_col_buff[5][4:0],dot_col_map[10:0]};
						dot_col_display[6] <= {dot_col_buff[6][4:0],dot_col_map[10:0]};
						dot_col_display[7] <= {dot_col_buff[7][4:0],dot_col_map[10:0]};
						count <= count + 5'b00001;						
					end
					5'b00101:
					begin
						dot_col_display[0] <= {dot_col_buff[0][5:0],dot_col_map[9:0]};
						dot_col_display[1] <= {dot_col_buff[1][5:0],dot_col_map[9:0]};
						dot_col_display[2] <= {dot_col_buff[2][5:0],dot_col_map[9:0]};
						dot_col_display[3] <= {dot_col_buff[3][5:0],dot_col_map[9:0]};
						dot_col_display[4] <= {dot_col_buff[4][5:0],dot_col_map[9:0]};
						dot_col_display[5] <= {dot_col_buff[5][5:0],dot_col_map[9:0]};
						dot_col_display[6] <= {dot_col_buff[6][5:0],dot_col_map[9:0]};
						dot_col_display[7] <= {dot_col_buff[7][5:0],dot_col_map[9:0]};
						count <= count + 5'b00001;						
					end
					5'b00110:
					begin
						dot_col_display[0] <= {dot_col_buff[0][6:0],dot_col_map[8:0]};
						dot_col_display[1] <= {dot_col_buff[1][6:0],dot_col_map[8:0]};
						dot_col_display[2] <= {dot_col_buff[2][6:0],dot_col_map[8:0]};
						dot_col_display[3] <= {dot_col_buff[3][6:0],dot_col_map[8:0]};
						dot_col_display[4] <= {dot_col_buff[4][6:0],dot_col_map[8:0]};
						dot_col_display[5] <= {dot_col_buff[5][6:0],dot_col_map[8:0]};
						dot_col_display[6] <= {dot_col_buff[6][6:0],dot_col_map[8:0]};
						dot_col_display[7] <= {dot_col_buff[7][6:0],dot_col_map[8:0]};
						count <= count + 5'b00001;						
					end
					5'b00111:
					begin
						dot_col_display[0] <= {dot_col_buff[0][7:0],dot_col_map[7:0]};
						dot_col_display[1] <= {dot_col_buff[1][7:0],dot_col_map[7:0]};
						dot_col_display[2] <= {dot_col_buff[2][7:0],dot_col_map[7:0]};
						dot_col_display[3] <= {dot_col_buff[3][7:0],dot_col_map[7:0]};
						dot_col_display[4] <= {dot_col_buff[4][7:0],dot_col_map[7:0]};
						dot_col_display[5] <= {dot_col_buff[5][7:0],dot_col_map[7:0]};
						dot_col_display[6] <= {dot_col_buff[6][7:0],dot_col_map[7:0]};
						dot_col_display[7] <= {dot_col_buff[7][7:0],dot_col_map[7:0]};
						count <= count + 5'b00001;						
					end
					5'b01000:
					begin
						dot_col_display[0] <= {dot_col_buff[0][8:0],dot_col_map[6:0]};
						dot_col_display[1] <= {dot_col_buff[1][8:0],dot_col_map[6:0]};
						dot_col_display[2] <= {dot_col_buff[2][8:0],dot_col_map[6:0]};
						dot_col_display[3] <= {dot_col_buff[3][8:0],dot_col_map[6:0]};
						dot_col_display[4] <= {dot_col_buff[4][8:0],dot_col_map[6:0]};
						dot_col_display[5] <= {dot_col_buff[5][8:0],dot_col_map[6:0]};
						dot_col_display[6] <= {dot_col_buff[6][8:0],dot_col_map[6:0]};
						dot_col_display[7] <= {dot_col_buff[7][8:0],dot_col_map[6:0]};
						count <= count + 5'b00001;						
					end
					5'b01001:
					begin
						dot_col_display[0] <= {dot_col_buff[0][9:0],dot_col_map[5:0]};
						dot_col_display[1] <= {dot_col_buff[1][9:0],dot_col_map[5:0]};
						dot_col_display[2] <= {dot_col_buff[2][9:0],dot_col_map[5:0]};
						dot_col_display[3] <= {dot_col_buff[3][9:0],dot_col_map[5:0]};
						dot_col_display[4] <= {dot_col_buff[4][9:0],dot_col_map[5:0]};
						dot_col_display[5] <= {dot_col_buff[5][9:0],dot_col_map[5:0]};
						dot_col_display[6] <= {dot_col_buff[6][9:0],dot_col_map[5:0]};
						dot_col_display[7] <= {dot_col_buff[7][9:0],dot_col_map[5:0]};
						count <= count + 5'b00001;
					end
					5'b01010:
					begin
						dot_col_display[0] <= {dot_col_buff[0][10:0],dot_col_map[4:0]};
						dot_col_display[1] <= {dot_col_buff[1][10:0],dot_col_map[4:0]};
						dot_col_display[2] <= {dot_col_buff[2][10:0],dot_col_map[4:0]};
						dot_col_display[3] <= {dot_col_buff[3][10:0],dot_col_map[4:0]};
						dot_col_display[4] <= {dot_col_buff[4][10:0],dot_col_map[4:0]};
						dot_col_display[5] <= {dot_col_buff[5][10:0],dot_col_map[4:0]};
						dot_col_display[6] <= {dot_col_buff[6][10:0],dot_col_map[4:0]};
						dot_col_display[7] <= {dot_col_buff[7][10:0],dot_col_map[4:0]};
						count <= count + 5'b00001;						
					end
					5'b01011:
					begin
						dot_col_display[0] <= {dot_col_buff[0][11:0],dot_col_map[3:0]};
						dot_col_display[1] <= {dot_col_buff[1][11:0],dot_col_map[3:0]};
						dot_col_display[2] <= {dot_col_buff[2][11:0],dot_col_map[3:0]};
						dot_col_display[3] <= {dot_col_buff[3][11:0],dot_col_map[3:0]};
						dot_col_display[4] <= {dot_col_buff[4][11:0],dot_col_map[3:0]};
						dot_col_display[5] <= {dot_col_buff[5][11:0],dot_col_map[3:0]};
						dot_col_display[6] <= {dot_col_buff[6][11:0],dot_col_map[3:0]};
						dot_col_display[7] <= {dot_col_buff[7][11:0],dot_col_map[3:0]};
						count <= count + 5'b00001;						
					end
					5'b01100:
					begin
						dot_col_display[0] <= {dot_col_buff[0][12:0],dot_col_map[2:0]};
						dot_col_display[1] <= {dot_col_buff[1][12:0],dot_col_map[2:0]};
						dot_col_display[2] <= {dot_col_buff[2][12:0],dot_col_map[2:0]};
						dot_col_display[3] <= {dot_col_buff[3][12:0],dot_col_map[2:0]};
						dot_col_display[4] <= {dot_col_buff[4][12:0],dot_col_map[2:0]};
						dot_col_display[5] <= {dot_col_buff[5][12:0],dot_col_map[2:0]};
						dot_col_display[6] <= {dot_col_buff[6][12:0],dot_col_map[2:0]};
						dot_col_display[7] <= {dot_col_buff[7][12:0],dot_col_map[2:0]};
						count <= count + 5'b00001;						
					end
					5'b01101:
					begin
						dot_col_display[0] <= {dot_col_buff[0][13:0],dot_col_map[1:0]};
						dot_col_display[1] <= {dot_col_buff[1][13:0],dot_col_map[1:0]};
						dot_col_display[2] <= {dot_col_buff[2][13:0],dot_col_map[1:0]};
						dot_col_display[3] <= {dot_col_buff[3][13:0],dot_col_map[1:0]};
						dot_col_display[4] <= {dot_col_buff[4][13:0],dot_col_map[1:0]};
						dot_col_display[5] <= {dot_col_buff[5][13:0],dot_col_map[1:0]};
						dot_col_display[6] <= {dot_col_buff[6][13:0],dot_col_map[1:0]};
						dot_col_display[7] <= {dot_col_buff[7][13:0],dot_col_map[1:0]};
						count <= count + 5'b00001;						
					end
					5'b01110:
					begin
						dot_col_display[0] <= {dot_col_buff[0][14:0],dot_col_map[0:0]};
						dot_col_display[1] <= {dot_col_buff[1][14:0],dot_col_map[0:0]};
						dot_col_display[2] <= {dot_col_buff[2][14:0],dot_col_map[0:0]};
						dot_col_display[3] <= {dot_col_buff[3][14:0],dot_col_map[0:0]};
						dot_col_display[4] <= {dot_col_buff[4][14:0],dot_col_map[0:0]};
						dot_col_display[5] <= {dot_col_buff[5][14:0],dot_col_map[0:0]};
						dot_col_display[6] <= {dot_col_buff[6][14:0],dot_col_map[0:0]};
						dot_col_display[7] <= {dot_col_buff[7][14:0],dot_col_map[0:0]};
						count <= count + 5'b00001;
					end
					5'b01111:
					begin
						dot_col_display[0] <= 16'b1100100100001000;
						dot_col_display[1] <= 16'b1100100100001000;
						dot_col_display[2] <= 16'b0000000000000000;
						dot_col_display[3] <= 16'b0100100010010001;
						dot_col_display[4] <= 16'b0100100010010001;
						dot_col_display[5] <= 16'b0000000000000000;
						dot_col_display[6] <= 16'b1010010001001001;
						dot_col_display[7] <= 16'b1010010001001001;
						count <= count + 5'b00001;
					end
				endcase
			end
			else
			begin
				dot_col_display[0] <= {dot_col_display[0][0],dot_col_display[0][15:1]};
				dot_col_display[1] <= {dot_col_display[1][0],dot_col_display[1][15:1]};
				dot_col_display[2] <= {dot_col_display[2][0],dot_col_display[2][15:1]};
				dot_col_display[3] <= {dot_col_display[3][0],dot_col_display[3][15:1]};
				dot_col_display[4] <= {dot_col_display[4][0],dot_col_display[4][15:1]};
				dot_col_display[5] <= {dot_col_display[5][0],dot_col_display[5][15:1]};
				dot_col_display[6] <= {dot_col_display[6][0],dot_col_display[6][15:1]};
				dot_col_display[7] <= {dot_col_display[7][0],dot_col_display[7][15:1]};
			end
	end
endmodule