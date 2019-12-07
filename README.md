# BTL_Topic2_VerilogDesign
This project contains all module of Big Assignment that is topic2 - A digital clock

Set top file: MiniProjectTopic2.v (it only call MainManager.v to pass the input, output suitable with the De2i-150)<br/>
Testbench: MiniProjectTopic2_tb.v<br/>
<br/>
Manage all module: MainManager.v<br/>
<br/>
Screen 1 - The seconds, minutes, hours display (include SecondCounter.v, MinuteCounter.v, HourCounter.v, Clk24toClk12.v)<br/>
Screen 2 - The days, months, years display (include DayCounter.v, MonthCounter.v, YearCounter.v, DayOfWeekCounter.v)<br/>
Screen 3 - The time zone display (include TimeZoneMinutes.v, TimeZoneHours.v, TimeZonePlusMinus.v)<br/>
Screen 4 - Manage Mode24t12 Signal (Mode24to12Signal.v)<br/>
<br/>
Display 7-Segment module: HexDisp.v<br/>
Manage signal of edit mode, screen, edit position: KeysManage.v<br/>
Manage signal of switch reverse: SwitchReverseSignal.v<br/>
Manage signal of reset: ResetSignal.v<br/>
For flicker effect when in edit mode: FlickerCounter.v<br/>
<br/>
Todo:<br/>
- Read all file begin at file MiniProjectTopic2.v
