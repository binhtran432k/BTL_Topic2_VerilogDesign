module HourCounter(hours, Clk, KEY, editCur, editMode, disMode, SW);
	output reg[5:0] hours = 23;
	input [3:0] KEY;
	input [2:0] editCur;
	input editMode, SW, Clk;
	input [1:0] disMode;
	
	/*initial begin
		hours <= 23;
	end*/
	always @(negedge Clk, negedge KEY[3], negedge KEY[2], negedge KEY[1], negedge KEY[0]) begin
		if(KEY[1] == 0) begin
			if(SW == 0) begin
				if (editCur == 1 && disMode == 0 && editMode == 1) begin
					if(((hours - (hours % 10)) / 10) % 10 == 2) begin
						hours <= hours % 10 == 3? hours - 3: hours + 1;
					end
					else begin
						hours <= hours % 10 == 9? hours - 9: hours + 1;
					end
				end
				else if (editCur == 0 && disMode == 0 && editMode == 1) begin
					hours <= ((hours - (hours % 10)) / 10) % 10 == 2? hours - 20: hours + 10;
				end
			end
			else begin
				if (editCur == 0 && disMode == 0 && editMode == 1) begin
					if (hours >= 12) begin
						hours <= hours == 23? 12: hours + 1;
					end
					else begin
						hours <= hours == 11? 0: hours + 1;
					end
				end
				else if (editCur == 7 && disMode == 0 && editMode == 1) begin
					if (hours >= 12) begin
						hours <= hours - 12;
					end
					else begin
						hours <= hours + 12;
					end
				end
			end
		end
		else if(KEY[2] == 0) begin
			if(SW == 0) begin
				if (editCur == 1 && disMode == 0 && editMode == 1) begin
					if(((hours - (hours % 10)) / 10) % 10 == 2) begin
						hours <= hours % 10 == 0? hours + 3: hours - 1;
					end
					else begin
						hours <= hours % 10 == 0? hours + 9: hours - 1;
					end
				end
				else if (editCur == 0 && disMode == 0 && editMode == 1) begin
					hours <= ((hours - (hours % 10)) / 10) % 10 == 0? hours + 20: hours - 10;
				end
			end
			else begin
				if (editCur == 0 && disMode == 0 && editMode == 1) begin
					if (hours >= 12) begin
						hours <= hours == 12? 23: hours - 1;
					end
					else begin
						hours <= hours == 0? 11: hours - 1;
					end
				end
				else if (editCur == 7 && disMode == 0 && editMode == 1) begin
					if (hours >= 12) begin
						hours <= hours - 12;
					end
					else begin
						hours <= hours + 12;
					end
				end
			end
		end
		/*else if(KEY[0] == 0) begin
			if(hours > 23 && disMode == 0 && editMode == 1) begin
				hours <= Clk == 0? 22: 23;
			end
			else if(editMode == 1 && (editCur == 1 || editCur == 0) && disMode == 0 && editMode == 1) begin
				hours <= Clk == 0? (hours == 0? 23: hours - 1): hours;
			end
		end*/
		else if(KEY[3] == 0 || KEY[0] == 0) begin
			if(hours > 23 && disMode == 0 && editMode == 1) begin
				hours <= 23;
			end
		end
		else if(Clk == 0) begin
			if(editMode == 0) begin
				hours <= hours == 23? 0: hours + 1;
			end
		end
	end
	
endmodule
