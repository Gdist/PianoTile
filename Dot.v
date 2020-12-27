module Dot(clk,div_clk,rst,data,dot_row,dot_col);
	input clk,div_clk,rst;
	input [2:0] data;
	output reg [7:0] dot_row;
	output reg [15:0] dot_col;

	reg [15:0] dot_col_buff[0:7];
	reg [2:0] row_count;

	
	// For dot matrix display
	reg [31:0] cnt_dot;
	reg clk_dot;
	always@(posedge clk or negedge rst)
	begin
		if (~rst)
		begin
			cnt_dot <= 32'd0;
			clk_dot <= 1'b0;
		end
		else
		begin
			if (cnt_dot == 5000) 
			begin
				clk_dot <= ~clk_dot;
				cnt_dot <= 32'd0;
			end
			else
			begin
				cnt_dot <= cnt_dot + 32'd1;
			end	
		end
	end
	
	//row controller
	always@ (posedge clk_dot or negedge rst)
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
			 dot_col <= dot_col_buff[row_count];
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
	
	always@(posedge div_clk or negedge rst)
	begin
		if(~rst) begin
			dot_col_buff[0] <= 16'b0000000000000000;
			dot_col_buff[1] <= 16'b0000000000000000;
			dot_col_buff[2] <= 16'b0000000000000000;
			dot_col_buff[3] <= 16'b0000000000000000;
			dot_col_buff[4] <= 16'b0000000000000000;
			dot_col_buff[5] <= 16'b0000000000000000;
			dot_col_buff[6] <= 16'b0000000000000000;
			dot_col_buff[7] <= 16'b0000000000000000;
		end
		else begin
			dot_col_buff[0] <= {data[0],dot_col_buff[0][15:1]};
			dot_col_buff[1] <= {data[0],dot_col_buff[1][15:1]};
			dot_col_buff[3] <= {data[1],dot_col_buff[3][15:1]};
			dot_col_buff[4] <= {data[1],dot_col_buff[4][15:1]};
			dot_col_buff[6] <= {data[2],dot_col_buff[6][15:1]};
			dot_col_buff[7] <= {data[2],dot_col_buff[7][15:1]};
		end
	end
endmodule