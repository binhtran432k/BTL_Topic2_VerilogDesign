module SecondCounter(seconds, clkMinute, Clk, KEY, editCur, editMode, disMode, SW);
	output reg[5:0] seconds = 0;
	output clkMinute;
	input [3:0] KEY;
	input [2:0] editCur;
	input editMode, SW, Clk;
	input [1:0] disMode;
	
	assign clkMinute = seconds == 59? 1: 0;
	
	reg[27:0] count = 0; // For counter count to 67_108_864
	reg clkFake; // Creat Sub Clock in order to stop when EditMode is on
	/*initial begin // declare initial signals
		seconds = 0;
		count = 0;
		clkFake = 0;
	end*/
	always @(posedge Clk, negedge KEY[1], negedge KEY[2], negedge KEY[0]) begin
		if(KEY[1] == 0) begin
			if (editMode == 1 && editCur == 5 && disMode == 0) begin
				seconds <= seconds % 10 == 9? seconds - 9: seconds + 1;
			end
			else if (editMode == 1 && editCur == 4 && disMode == 0) begin
				seconds <= ((seconds - (seconds % 10)) / 10) % 10 == 5? seconds - 50: seconds + 10;
			end
		end
		else if(KEY[2] == 0) begin
			if (editMode == 1 && editCur == 5 && disMode == 0) begin
				seconds <= seconds % 10 == 0? seconds + 9: seconds - 1;
			end
			else if (editMode == 1 && editCur == 4 && disMode == 0) begin
				seconds <= ((seconds - (seconds % 10)) / 10) % 10 == 0? seconds + 50: seconds - 10;
			end
		end
		else if(KEY[0] == 0) begin
			count <= 0;
		end
		else if(Clk == 1) begin
			if (editMode == 0) begin
				if(SW == 1) begin
					seconds <= count == 1? (seconds == 59? 0: seconds + 1): seconds; // Real count: 13_888.(8) ~ 13_888
					count <= count == 1? 0: count + 1; // Real count: 13_888.(8) ~ 13_888
				end
				else begin
					seconds <= count == 49? (seconds == 59? 0: seconds + 1): seconds; // Real count: 49_999_999
					count <= count == 49? 0: count + 1; // Real count: 49_999_999
				end
			end
		end
	end
	
	always @(Clk) begin
		clkFake <= editMode == 1? 0: 1;
	end
		
endmodule
