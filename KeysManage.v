module KeysManage(editMode, disMode, editCur, KEY, SW, SW2, Clk);
	output reg[1:0] disMode = 0; // Perform 3 view mode
	output reg editMode = 0; // Perform Edit Mode is on
	input[3:0] KEY; // 4 Push buttons to control the clock
	input SW, SW2, Clk; // Switch to detech 24h mode and 12h mode
	output reg [2:0] editCur = 0; // The current Position of edit value
	
	 // declare initial signals
	
	/*initial begin
		disMode = 0;
		editMode = 0;
		editCur = 0;
	end*/
	
	// Activate Edit mode
	reg SWFake;
	always @(negedge KEY[0]) begin
		editMode <= editMode == 1? 0: 1; // KEY0 Activate Edit mode
	end
	
	always @(SW) begin
		SWFake <= SW;
	end
	
	always @(negedge KEY[1], negedge KEY[2], negedge KEY[3], posedge SW, negedge SWFake) begin
		if (KEY[3] == 0) begin
			if (editMode == 1) begin
				if (SW == 0) begin
					if (SW2 == 0) begin
						editCur <= (disMode == 0 && editCur == 5)? editCur + 3: editCur + 1; // KEY3 change position of current edit value
					end
					else begin
						editCur <= (disMode == 0 && editCur == 0)? editCur - 3: editCur - 1; // KEY3 change position of current edit value
					end
				end
				else begin
					if (SW2 == 0) begin
						editCur <= (disMode == 0 && (editCur == 5 || editCur == 0))? editCur + 2: editCur + 1; // KEY3 change position of current edit value
					end
					else begin
						editCur <= (disMode == 0 && (editCur == 7 || editCur == 2))? editCur - 2: editCur - 1; // KEY3 change position of current edit value
					end
				end
			end
		end
		else if (KEY[1] == 0) begin
			if (editMode == 0) begin
				editCur <= 0;
				disMode <= (disMode == 2)? 0: disMode + 1;
			end
		end
		else if (KEY[2] == 0) begin
			if (editMode == 0) begin
				editCur <= 0;
				disMode <= (disMode == 0)? 2: disMode - 1;
			end
		end
		else if (SW == 1) begin
			editCur <= (disMode == 0 && editCur == 1)? 0: editCur; // SW change position of current edit value
		end
		else if (SWFake == 0) begin
			editCur <= (disMode == 0 && editCur == 7)? 5: editCur; // SW change position of current edit value
		end
	end
	
endmodule
