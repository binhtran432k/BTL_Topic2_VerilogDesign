module MiniProjectTopic2(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, CLOCK_50, KEY, SW);
	input CLOCK_50; // 1 Clock frequency 50_000_000 Hz
	input [17:0] SW; // 3 Switch to perform special function
	input [3:0] KEY; // 4 Push buttons to control the clock
	output reg [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7; // Real 7-Segment
	output [2:0] LEDR; // 3 Leds to perform View Mode
	
	wire[5:0] seconds, minutes; // Value of time, day, time zone,...
	wire [4:0] hours;
	wire [3:0] DayNight, hours2;
	wire [0:6] HEX2A, HEX3A, HEX4A, HEX5A, HEX6A, HEX7A, //Fake 7-Segment in Normal Mode in 12h
				HEX0A2, HEX6A2, HEX7A2; //Fake 7-Segment in Normal Mode in 24h
	wire [1:0] screen; // Perform 3 view mode
	wire EditMode, ClkFlick, ClkHour, ClkMinute, ClkDay; // Perform Edit Mode is on __ Perform Clock for flicker 7-segment
	wire [2:0] EditPos; // The current Position of edit value
	
	FlickerCounter fc0(ClkFlick, CLOCK_50, SW[17]); // Convert CLOCK_50 to clock for flicker 7-segment
	
	//For Seconds Counter
	
	SecondCounter s0(seconds, ClkMinute, CLOCK_50, SW[16], SW[15], KEY[1], KEY[2], SW[17], EditPos, EditMode, screen); // Manage Seconds
	HexDisp uS(seconds % 10, HEX2A); // Convert units of seconds to 7-segment
	HexDisp tS(seconds / 10, HEX3A); // Convert tens of seconds to 7-segment
	
	//For Minutes Counter

	MinuteCounter m0(minutes, ClkHour, ClkMinute, CLOCK_50, KEY[1], KEY[2], SW[17], EditPos, EditMode, screen); // Manage Minutes
	HexDisp uM(minutes % 10, HEX4A); // Convert units of minutes to 7-segment
	HexDisp tM(minutes / 10, HEX5A); // Convert tens of minutes to 7-segment
	
	//For Hours Counter in 24h mode

	HourCounter h0(hours, ClkDay, ClkHour, CLOCK_50, KEY[1], KEY[2], SW[17], SW[0], EditPos, EditMode, screen); // Manage Hours
	HexDisp uH(hours % 10, HEX6A); // Convert units of hours to 7-segment
	HexDisp tH(hours / 10, HEX7A); // Convert tens of hours to 7-segment
	
	//For 12-clock hour
	
	Clk24toClk12 clk2412(hours2, DayNight, hours); // Convert 24h-clock to 12h-clock
	HexDisp textDN(DayNight, HEX0A2); // Convert day/night to 7-segment
	HexDisp uH2(hours2 % 10, HEX6A2); // Convert units of 12h-clock hour to 7-segment
	HexDisp tH2(hours2 / 10, HEX7A2); // Convert tens of 12h-clock hour to 7-segment
	
	// Manage Mode and Keys
	
	KeysManage km0(EditMode, screen, EditPos, KEY[1], KEY[2], KEY[0], KEY[3], SW[0], SW[1], CLOCK_50, SW[17]);
		
	// Show mode through leds
	
	assign LEDR = SW[17] == 0? 3'b000:
					(screen == 0)? 3'b001: // Normal Mode
					(screen == 1)? 3'b011: // DayMonth Mode
					(screen == 2)? 3'b111: 3'b000; // TimeZone Mode __ Unknown Mode
	
	// Detect signals to control 7-segment theme
	
	always @(*) begin
		if(SW[17]) begin
			if (screen == 0) begin // In Normal Mode
				if (SW[0] == 0) begin // When in 24h mode
					HEX7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: HEX7A; // When Edit Mode the 7-segment is flicker when the edit position is the current 7-segment
					HEX6 <= (EditMode == 1 && EditPos == 1 && ClkFlick == 1)? 7'b111_1111: HEX6A; // ...
					HEX0 <= 7'b111_1111; // blank
				end
				else begin // when in 12h mode
					HEX7 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: HEX7A2; // When Edit Mode the 7-segment is flicker when the edit position is the current 7-segment
					HEX6 <= (EditMode == 1 && EditPos == 0 && ClkFlick == 1)? 7'b111_1111: HEX6A2; // ...
					HEX0 <= (EditMode == 1 && EditPos == 7 && ClkFlick == 1)? 7'b111_1111: HEX0A2; // ...
				end
				// Common elements of 12h and 24h mode
				HEX5 <= (EditMode == 1 && EditPos == 2 && ClkFlick == 1)? 7'b111_1111: HEX5A; // ...
				HEX4 <= (EditMode == 1 && EditPos == 3 && ClkFlick == 1)? 7'b111_1111: HEX4A; // ...
				HEX3 <= (EditMode == 1 && EditPos == 4 && ClkFlick == 1)? 7'b111_1111: HEX3A; // ...
				HEX2 <= (EditMode == 1 && EditPos == 5 && ClkFlick == 1)? 7'b111_1111: HEX2A; // ...
				HEX1 <= 7'b111_1111; // blank
			end
			else if (screen == 1) begin // In DayMonth Mode
				HEX7 <= 7'b100_1111; // 1
				HEX6 <= 7'b000_1111; // 1
				HEX5 <= 7'b100_1111; // 1
				HEX4 <= 7'b100_1111; // 7
				HEX3 <= 7'b001_0010; // 2
				HEX2 <= 7'b000_0001; // 0
				HEX1 <= 7'b100_1111; // 1
				HEX0 <= 7'b000_0100; // 9
			end
			else if (screen == 2) begin // In TimeZone Mode
				HEX7 <= 7'b100_1110; // space ~ -/
				HEX6 <= 7'b111_1000; // + ~ /-
				HEX5 <= 7'b000_0001; // 0
				HEX4 <= 7'b000_1111; // 7
				HEX3 <= 7'b000_0001; // 0
				HEX2 <= 7'b000_0001; // 0
				HEX1 <= 7'b111_1111; // blank
				HEX0 <= 7'b111_1111; // blank
			end
		end
		else begin
			HEX7 <= 7'b111_1111; // blank
			HEX6 <= 7'b111_1111; // blank
			HEX5 <= 7'b111_1111; // blank
			HEX4 <= 7'b111_1111; // blank
			HEX3 <= 7'b111_1111; // blank
			HEX2 <= 7'b111_1111; // blank
			HEX1 <= 7'b111_1111; // blank
			HEX0 <= 7'b111_1111; // blank
		end
	end
	
endmodule
