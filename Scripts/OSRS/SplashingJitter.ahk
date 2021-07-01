#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

#IfWinActive OpenOSRS

Global SleepLowerBound := 423000
Global SleepUpperBound := 873000
Global StartTime := A_TickCount
Global SleepTime := 0

CountDown() {
	Local RawTime := (StartTime - A_TickCount + SleepTime) / 1000
	Local Minutes := RawTime / 60
	Local Seconds := Mod(RawTime, 60)
	ToolTip % "Next jitter in " Format("{:d}", Minutes) ":" Format("{:02d}", Seconds), 0, 0
}

F1::
	SetTimer, CountDown, 1000

    Loop {
		StartTime := A_TickCount
		Random, SleepTime, SleepLowerBound, SleepUpperBound
		
		Random, Sleep1, 142, 265
		Random, Sleep2, 150, 214
		Random, Sleep3, 169, 259

		Send, {Left Down}
		Sleep, Sleep1
		Send, {Left Up}
		
		Sleep, Sleep2
		
		Send, {Right Down}
		Sleep, Sleep3
		Send, {Right Up}
		
        Sleep, SleepTime
    }
	
    Return

#If
^R::Reload
+^C::ExitApp
