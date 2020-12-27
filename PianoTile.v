`define dat_in "dat.txt"

module PianoTile(clk, rst, btn1, btn2, btn3, sevenDP2, sevenDP1, sevenDP0, dot_row, dot_col);
	input clk, rst, btn1, btn2, btn3;
	output [6:0] sevenDP2,sevenDP1,sevenDP0;
	//output reg [3:0] O_red,O_green,O_blue;
	//output O_hs,O_vs;
	reg [23:0] score = 24'd0;
	
	reg [2:0] data_in [0:99];
	initial $readmemb (`dat_in,data_in);
	reg [2:0] data_now [0:16];

	// div_clk_1Hz
	reg clk_1Hz;
	reg [31:0] cnt_1Hz;
	always@(posedge clk or negedge rst) begin
		if (~rst) begin
			cnt_1Hz <= 32'd0;
			clk_1Hz <= 1'd0;
		end
		else begin
			if (cnt_1Hz == 32'd25000000) begin
				clk_1Hz <= ~clk_1Hz;
				cnt_1Hz <= 32'd0;
			end
			else begin
				cnt_1Hz <= cnt_1Hz + 32'd1;
			end	
		end
	end

	// div_clk_1000Hz
	reg clk_1000Hz;
	reg [31:0] cnt_1000Hz;
	always@(posedge clk or negedge rst) begin
		if (~rst) begin
			cnt_1000Hz <= 32'd0;
			clk_1000Hz <= 1'd0;
		end
		else begin
			if (cnt_1000Hz == 32'd25000) begin
				clk_1000Hz <= ~clk_1000Hz;
				cnt_1000Hz <= 32'd0;
			end
			else begin
				cnt_1000Hz <= cnt_1000Hz + 32'd1;
			end	
		end
	end
	
	//check
	reg [2:0] tmp_score;
	reg [2:0] tmp_data;
	reg [31:0] cnt;
	always@(posedge clk_1000Hz or negedge rst)
	begin
		if (~rst) begin
			score = 2'd0;
			cnt <= 32'd0;
			tmp_score[2] <= 1'b0;
			tmp_score[1] <= 1'b0;
			tmp_score[0] <= 1'b0;
			tmp_data = data_now[15];
		end
		else begin
			if (cnt == 32'd1000) begin
				score <= score + tmp_score[2] + tmp_score[1] + tmp_score[0];
				tmp_score[2] <= 1'b0;
				tmp_score[1] <= 1'b0;
				tmp_score[0] <= 1'b0;
				cnt <= 32'd0;
				tmp_data = data_now[15];
			end
			else begin
				tmp_score[2] <= (!btn1 && tmp_data[2])? 1'b1 : tmp_score[2];
				tmp_score[1] <= (!btn2 && tmp_data[1])? 1'b1 : tmp_score[1];
				tmp_score[0] <= (!btn3 && tmp_data[0])? 1'b1 : tmp_score[0];
				cnt <= cnt + 32'b1;
			end
		end
	end
	
	//fall
	reg [15:0] count_in;
	always@(posedge clk_1Hz or negedge rst) begin
		if (~rst) begin
			data_now[0] <= 3'b000; 
			data_now[1] <= 3'b000;
			data_now[2] <= 3'b000;
			data_now[3] <= 3'b000;
			data_now[4] <= 3'b000;
			data_now[5] <= 3'b000;
			data_now[6] <= 3'b000;
			data_now[7] <= 3'b000;
			data_now[8] <= 3'b000;
			data_now[9] <= 3'b000;
			data_now[10] <= 3'b000;
			data_now[11] <= 3'b000;
			data_now[12] <= 3'b000;
			data_now[13] <= 3'b000;
			data_now[14] <= 3'b000;
			data_now[15] <= 3'b000;
			data_now[16] <= 3'b000;
			count_in <= 16'd0;
		end
		else begin
			data_now[0] <= data_in[count_in]; 
			data_now[1] <= data_now[0];
			data_now[2] <= data_now[1];
			data_now[3] <= data_now[2];
			data_now[4] <= data_now[3];
			data_now[5] <= data_now[4];
			data_now[6] <= data_now[5];
			data_now[7] <= data_now[6];
			data_now[8] <= data_now[7];
			data_now[9] <= data_now[8]; 
			data_now[10] <= data_now[9]; 
			data_now[11] <= data_now[10];
			data_now[12] <= data_now[11];
			data_now[13] <= data_now[12];
			data_now[14] <= data_now[13];
			data_now[15] <= data_now[14];
			data_now[16] <= data_now[15];
			count_in <= count_in+1;
		end
	end
	
	//SevenDP
	SevenDP SevenDP2(dec[2],sevenDP2);
	SevenDP SevenDP1(dec[1],sevenDP1);
	SevenDP SevenDP0(dec[0],sevenDP0);
	
	reg [3:0] dec [5:0];
	
	always@(*) begin
		dec[2] = score/100%10;
		dec[1] = score/10%10;
		dec[0] = score%10;
	end
	
	//Dot DP
	output [7:0] dot_row;
	output [15:0] dot_col;
	Dot DotDP(clk,clk_1Hz,rst,data_now[0],dot_row,dot_col);
	
	//VGA DP
	wire [50:0] brick;
	assign brick[50:48] = data_in[count_in];
	assign brick[47:45] = data_now[0];
	assign brick[44:42] = data_now[1];
	assign brick[41:39] = data_now[2];
	assign brick[38:36] = data_now[3];
	assign brick[35:33] = data_now[4];
	assign brick[32:30] = data_now[5];
	assign brick[29:27] = data_now[6];
	assign brick[26:24] = data_now[7];
	assign brick[23:21] = data_now[8];
	assign brick[20:18] = data_now[9];
	assign brick[17:15] = data_now[10];
	assign brick[14:12] = data_now[11];
	assign brick[11:9] = data_now[12];
	assign brick[8:6] = data_now[13];
	assign brick[5:3] = data_now[14];
	assign brick[2:0] = data_now[15];
	//VGA VGADP(clk,rst,brick,O_red,O_green,O_blue,O_hs,O_vs)

	
endmodule