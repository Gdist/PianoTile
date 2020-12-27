`define dat_in "dat.txt"

module PianoTile(clk, rst, btn1, btn2, btn3, sevenDP1, sevenDP2,LED);
	input clk, rst, btn1, btn2, btn3;
	output [6:0] sevenDP1,sevenDP2;
	output reg [2:0] LED;
	reg [7:0] score = 8'd0;
	
	reg [2:0] data_in [0:99];
	initial $readmemb (`dat_in,data_in);
	reg [2:0] data_now [0:16];
	
	SevenDP SevenDP1(score[7:4],sevenDP2);
	SevenDP SevenDP2(score[3:0],sevenDP1);
	
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
	
	//check
	wire [2:0] add_score;
	check checkD(clk, clk_1Hz, rst, btn1, btn2, btn3, data_now[15], add_score);
	
	//fall
	reg [15:0] count_in;
	always@(posedge clk_1Hz or negedge rst) begin
		if (~rst) begin
			data_now[0] <= data_in[0];
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
			score <= 8'd0;
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
			score <= score + add_score;
			LED <= data_now[14];
		end
	end
	
endmodule