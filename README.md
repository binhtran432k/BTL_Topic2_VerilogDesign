# BTL_Topic2_VerilogDesign
This project contains all module of Big Assignment that is topic2 - A digital clock

Set top file: MiniProjectTopic2.v (it only call MainManager.v to pass the input, output suitable with the De2i-150)
Testbench: MiniProjectTopic2_tb.v

Manage all module: MainManager.v
Manage signal of edit mode, screen, edit position: KeysManage.v

Screen 1 - The seconds, minutes, hours display (include SecondCounter.v, MinuteCounter.v, HourCounter.v, Clk24toClk12.v)
Screen 2 - The days, months, years display (include DayCounter.v, MonthCounter.v, YearCounter.v)
Screen 3 - The time zone display (Coming soon)

Display 7-Segment module: HexDisp.v
For flicker 7-Segment when in edit mode: FlickerCounter.v

Todo:
- Read the DayCounter.v, MonthCounter.v, YearCounter.v, to fix the time counter and finish the edit mode of screen
