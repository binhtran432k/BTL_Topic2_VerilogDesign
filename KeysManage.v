module KeysManage(EditMode, screen, EditPos, KeyPlus, KeyMinus, KeyEdit, KeySwi, Mode12t24, SwiReverse, clk, reset);
	output reg[1:0] screen; // Perform 3 view mode
	output reg EditMode; // Perform Edit Mode is on
	input Mode12t24, SwiReverse, KeyPlus, KeyMinus, KeyEdit, KeySwi, clk, reset; // Switch to detech 24h mode and 12h mode
	output reg [2:0] EditPos; // The current Position of edit value
		
	// Activate Edit mode
	reg [2:0] mode;
	
	always @(negedge KeyPlus, negedge KeyMinus, negedge KeySwi, posedge clk, negedge KeyEdit, negedge reset) begin
		if(~reset) begin
			screen <= 0;
			EditMode <= 0;
			EditPos <= 0;
			mode <= 0;
		end
		else if(~KeyEdit) begin
			if(screen == 0) mode <= 7; // KEY0 Activate Edit mode
		end
		else if(~KeySwi) begin
			if (EditMode == 1) begin
				if (Mode12t24 == 0) begin
					if (SwiReverse == 0) mode <= 1;
					else mode <= 2;
				end
				else begin
					if (SwiReverse == 0) mode <= 3;
					else mode <= 4;
				end
			end
			else mode <= 0;
		end
		else if(~KeyPlus) begin
			if (EditMode == 0) mode <= 5;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (EditMode == 0) mode <= 6;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			case(mode)
			1: EditPos <= (screen == 0 && EditPos == 5)? EditPos + 3: EditPos + 1;
			2: EditPos <= (screen == 0 && EditPos == 0)? EditPos - 3: EditPos - 1;
			3: EditPos <= (screen == 0 && (EditPos == 5 || EditPos == 0))? EditPos + 2: EditPos + 1;
			4: EditPos <= (screen == 0 && (EditPos == 7 || EditPos == 2))? EditPos - 2: EditPos - 1;
			5: screen <= (screen >= 2)? 0: screen + 1;
			6: screen <= (screen == 0)? 2: screen - 1;
			7: begin
				EditMode <= EditMode + 1;
				EditPos <= 0;
			end
			default: EditPos <= Mode12t24 == 1? ((screen == 0 && EditPos == 1)? 0: EditPos):
												((screen == 0 && EditPos == 7)? 5: EditPos);
			endcase
		end
	end
		
	/*always @(Mode12t24) begin
		Mode12t24Fake = Mode12t24;
	end
	
	/*always @(negedge KeyPlus, negedge KeyMinus, negedge KeySwi, posedge Mode12t24, negedge Mode12t24Fake) begin
		if (KeySwi == 0) begin
			if (EditMode == 1) begin
				if (Mode12t24 == 0) begin
					if (SwiReverse == 0) begin
						EditPos <= (screen == 0 && EditPos == 5)? EditPos + 3: EditPos + 1; // KEY3 change position of current edit value
					end
					else begin
						EditPos <= (screen == 0 && EditPos == 0)? EditPos - 3: EditPos - 1; // KEY3 change position of current edit value
					end
				end
				else begin
					if (SwiReverse == 0) begin
						EditPos <= (screen == 0 && (EditPos == 5 || EditPos == 0))? EditPos + 2: EditPos + 1; // KEY3 change position of current edit value
					end
					else begin
						EditPos <= (screen == 0 && (EditPos == 7 || EditPos == 2))? EditPos - 2: EditPos - 1; // KEY3 change position of current edit value
					end
				end
			end
		end
		else if (KeyPlus == 0) begin
			if (EditMode == 0) begin
				EditPos <= 0;
				screen <= (screen >= 2)? 0: screen + 1;
			end
		end
		else if (KeyMinus == 0) begin
			if (EditMode == 0) begin
				EditPos <= 0;
				screen <= (screen == 0)? 2: screen - 1;
			end
		end
		else if (Mode12t24 == 1) begin
			EditPos <= (screen == 0 && EditPos == 1)? 0: EditPos; // Mode12t24 change position of current edit value
		end
		else if (Mode12t24Fake == 0) begin
			EditPos <= (screen == 0 && EditPos == 7)? 5: EditPos; // Mode12t24 change position of current edit value
		end
	end*/
	
endmodule
