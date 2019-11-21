module MiniProjectTopic2_tb();
	reg CLOCK_50;
	reg [17:0] SW;
	reg [3:0] KEY;
	wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	wire [2:0] LEDR;
	
	wire [7:0] ASC0, ASC1, ASC2, ASC3, ASC4, ASC5, ASC6, ASC7;
	wire [2:0] KEYS;
	
	MiniProjectTopic2 t1(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, CLOCK_50, KEY, SW);
	HEX7toASC2 ha0(HEX0, ASC0);
	HEX7toASC2 ha1(HEX1, ASC1);
	HEX7toASC2 ha2(HEX2, ASC2);
	HEX7toASC2 ha3(HEX3, ASC3);
	HEX7toASC2 ha4(HEX4, ASC4);
	HEX7toASC2 ha5(HEX5, ASC5);
	HEX7toASC2 ha6(HEX6, ASC6);
	HEX7toASC2 ha7(HEX7, ASC7);

	//initial #5_000_000 $stop;
	initial begin
		//$monitor("%t, %c%c %c%c %c%c%c%c _ %b", $time, ASC7, ASC6, ASC5, ASC4, ASC3, ASC2, ASC1, ASC0, LEDR);
		//$monitor("%d%d:%d%d:%d%d %h", ASC7, ASC6, ASC5, ASC4, ASC3, ASC2, ASC0)
		CLOCK_50 <= 0;
		SW <= 0;
		KEY <= 4'b1111;
		/*
		#2000 KEY[0] = 0; #10 KEY <= 4'b1111; // EditMode Button
		#2000 KEY[1] = 0; #10 KEY <= 4'b1111; // + Button
		#2000 KEY[2] = 0; #10 KEY <= 4'b1111; // - Button
		#2000 KEY[3] = 0; #10 KEY <= 4'b1111; // ChangeEdit Button
		*/
		SW[17] <= 0;#5 SW[17] <= 1;
		/*KEY[0] = 0; #10 KEY <= 4'b1111; // EditMode Button
		#2000 KEY[1] = 0; #10 KEY <= 4'b1111; // + Button
		#2000 KEY[0] = 0; #10 KEY <= 4'b1111; // EditMode Button
		#2000 KEY[1] = 0; #10 KEY <= 4'b1111; // + Button
		#2000 KEY[1] = 0; #10 KEY <= 4'b1111; // + Button*/
		#50000 $stop; // 5_000_000 > 1Day
	end
	always #10 CLOCK_50 = ~CLOCK_50;
	bin2key bk0(KEY, KEYS);
	always @(ASC7, ASC6, ASC5, ASC4, ASC3, ASC2, ASC1, ASC0, SW, KEYS) begin
		$display("Time = %t, HEX7 = %c%c %c%c %c%c%c%c, LED = %b, SW = %b, KEY = %d.", $time, ASC7, ASC6, ASC5, ASC4, ASC3, ASC2, ASC1, ASC0, LEDR, SW, KEYS);
	end
endmodule

module HEX7toASC2(HEX, ASC);
	input [0:6] HEX;
	output [0:7] ASC;
	assign ASC = (HEX == 7'b000_0001)? 8'b0011_0000: // 0
            (HEX == 7'b100_1111)? 8'b0011_0001: //1
            (HEX == 7'b001_0010)? 8'b0011_0010: //2
            (HEX == 7'b000_0110)? 8'b0011_0011: // 3
            (HEX == 7'b100_1100)? 8'b0011_0100: // 4
            (HEX == 7'b010_0100)? 8'b0011_0101: // 5
            (HEX == 7'b010_0000)? 8'b0011_0110: // 6
            (HEX == 7'b000_1111)? 8'b0011_0111: // 7
            (HEX == 7'b000_0000)? 8'b0011_1000: // 8
            (HEX == 7'b000_0100)? 8'b0011_1001: // 9
            (HEX == 7'b000_1000)? 8'b0100_0001: // A
            (HEX == 7'b001_1000)? 8'b0101_0000: // P
            (HEX == 7'b100_1110)? 8'b0010_0000: // space ~ -/
            (HEX == 7'b111_1000)? 8'b0010_1011: // + ~ /-
            (HEX == 7'b111_1110)? 8'b0010_1101: 8'b0010_0000; // - __ space
endmodule

module bin2key (bin, key);
	input [3:0] bin;
	output [2:0] key;
	assign key = (bin == 4'b1111)? 0:
					(bin == 4'b1110)? 1:
					(bin == 4'b1101)? 2:
					(bin == 4'b1011)? 3:
					(bin == 4'b0111)? 4: 5;
endmodule
