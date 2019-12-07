/** Day Of Week Manager
 * 
 * Input: days, months, years, ClkLeap
 * Output: DayOfWeek
 * 
 * Dependence: none
 * 
 * Function: Manage day of week of project
 * 
 * Description Input, Output:
 * 
 * - DayOfWeek: perform day of week of project
 * - days: perform days of project
 * - months: perform months of project
 * - years: perform years of project
 * - ClkLeap: the clock perform year is leap or not, it is leap when high
 */
module DayOfWeekCounter(DayOfWeek, days, months, years, ClkLeap);
	output [31:0] DayOfWeek;
	input [6:0] days, months;
	input [14:0] years;
	input ClkLeap;
	
	wire [31:0] DaysOfTime;
	
	assign DaysOfTime = days +
							((months - 1) * 30 - (months < 3? 0: ClkLeap == 1? 1: 2) + (months <= 8? months: months + 1) / 2) +
							((years - 1) * 365 + (years - 1) / 4 - (years - 1) / 100 + (years - 1) / 400);
	assign DayOfWeek = DaysOfTime % 7;
	
endmodule
