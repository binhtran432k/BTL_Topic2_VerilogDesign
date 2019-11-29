# BTL_Topic2_VerilogDesign
This project contains all module of Big Assignment that is topic2 - A digital clock

Set top file: MiniProjectTopic2.v (it only call MainManager.v to pass the input, output suitable with the De2i-150)<br/>
Testbench: MiniProjectTopic2_tb.v<br/>
<br/>
Manage all module: MainManager.v<br/>
Manage signal of edit mode, screen, edit position: KeysManage.v<br/>
<br/>
Screen 1 - The seconds, minutes, hours display (include SecondCounter.v, MinuteCounter.v, HourCounter.v, Clk24toClk12.v)<br/>
Screen 2 - The days, months, years display (include DayCounter.v, MonthCounter.v, YearCounter.v)<br/>
Screen 3 - The time zone display (Coming soon)<br/>
<br/>
Display 7-Segment module: HexDisp.v<br/>
For flicker 7-Segment when in edit mode: FlickerCounter.v<br/>
<br/>
Todo:<br/>
- Read the DayCounter.v, MonthCounter.v, YearCounter.v, to fix the time counter and finish the edit mode of screen<br/>
