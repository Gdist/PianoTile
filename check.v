module check(div_clk, rst, btn1, btn2, btn3, data, score);
	input div_clk, rst, btn1, btn2, btn3;
	input [2:0] data;
	reg [2:0] tmp_data;
	reg [2:0] tmp_score;
	output reg [1:0] score = 2'd0;

	reg [31:0] cnt;

	always@(posedge div_clk or negedge rst)
	begin
		if (~rst) begin
			score = 2'd0;
			cnt <= 32'd0;
			tmp_score[2] <= 1'b0;
			tmp_score[1] <= 1'b0;
			tmp_score[0] <= 1'b0;
			tmp_data = data;
		end
		else begin
			if (cnt == 32'd1000) begin
				score <= tmp_score[2] + tmp_score[1] + tmp_score[0];
				tmp_score[2] <= 1'b0;
				tmp_score[1] <= 1'b0;
				tmp_score[0] <= 1'b0;
				cnt <= 32'd0;
				tmp_data = data;
			end
			else begin
				//tmp_score[2] = (!btn1 && tmp_data[2])? 1'b1 :tmp_score[2];
				tmp_score[1] = (!btn1 && tmp_data[1])? 1'b1 :tmp_score[1];
				tmp_score[0] = (!btn1 && tmp_data[0])? 1'b1 :tmp_score[0];
			
				if (!btn1 && tmp_data[2]) begin
					tmp_score[2] = 1'b1;
					tmp_data[2] = ~tmp_data[2];
				end
				else
					tmp_score[2] = tmp_score[2];
					
				if (!btn2 && tmp_data[1]) begin
					tmp_score[1] = 1'b1;
					tmp_data[1] = ~tmp_data[1];
				end
				else
					tmp_score[1] = tmp_score[1];
					
				if (!btn3 && tmp_data[0]) begin
					tmp_score[0] = 1'b1;
					tmp_data[0] = ~tmp_data[0];
				end
				else
					tmp_score[0] = tmp_score[0];
				cnt <= cnt + 32'b1;
			end
		end
	end
endmodule