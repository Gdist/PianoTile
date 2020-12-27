module check(clk, div_clk, rst, btn1, btn2, btn3, data, score);
	input clk, div_clk, rst, btn1, btn2, btn3;
	input [2:0] data;
	wire btn1_check, btn2_check, btn3_check;
	output reg [1:0] score = 2'd0;

	btn_control btn1_control(clk,rst,btn1,btn1_check); //btn1_check
	btn_control btn2_control(clk,rst,btn2,btn2_check); //btn2_check
	btn_control btn3_control(clk,rst,btn3,btn3_check); //btn3_check

	//check
	reg tmp_score [2:0];

	always@(posedge div_clk or negedge rst) begin
		if (~rst) begin
			score <= 2'd0;
			tmp_score[2] <= 1'd0;
			tmp_score[1] <= 1'd0;
			tmp_score[0] <= 1'd0;
		end
		else begin
			if (data[2]==1'd1 && btn1_check==1'd1) tmp_score[2] <= 1'd1;
			else tmp_score[2] <= 1'd0;
			if (data[1]==1'd1 && btn2_check==1'd1) tmp_score[1] <= 1'd1;
			else tmp_score[1] <= 1'd0;
			if (data[0]==1'd1 && btn3_check==1'd1) tmp_score[0] <= 1'd1;
			else tmp_score[0] <= 1'd0;
			score <= tmp_score[2] + tmp_score[1] + tmp_score[0];
		end
	end

endmodule

module btn_control(clk, rst, btn_signal, btn_check);
	input clk, rst, btn_signal;
	output reg btn_check;

	reg [31:0] cnt;

	always@(posedge clk or negedge rst)
	begin
		if (~rst) begin
			btn_check <= 1'b0;
			cnt <= 32'd0;
		end
		else begin
			if (cnt == 32'd12500000) begin
				btn_check <= 1'b0;
				cnt <= 25'd0;
			end
			else if(cnt[7:0] == 8'd0) begin //check per 256 clocks
				btn_check <= (!btn_signal)? 1'b1 : btn_check;
				cnt <= cnt + 32'b1;
			end
			else begin
				cnt <= cnt + 32'b1;
			end
		end
	end
endmodule