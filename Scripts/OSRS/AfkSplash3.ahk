#Include %A_MyDocuments%/Git/ahk/Libraries/Math.ahk

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
Global TotalTimer      := A_TickCount
Global StartTime       := A_TickCount
Global SleepTime       := 0


Jitter(Key, SleepRange) {
	Send, {%Key% Down}
	Sleep, Rand(SleepRange[1], SleepRange[2])
	Send, {%Key% Up}
}

CountDown() {
	Local Elapsed := (A_TickCount - TotalTimer) / 1000
	Local RawTime := (StartTime - A_TickCount + SleepTime) / 1000
	Local Minutes := RawTime / 60
	Local Seconds := Mod(RawTime, 60)
	
	ToolTip % "Next jitter in " Format("{:d}", Minutes) ":" Format("{:02d}", Seconds) " [time running: " Format("{:d}", (Elapsed / 60)) " seconds]", 0, 0
}


F1::
	SetTimer, CountDown, 1000

    Loop {
		StartTime := A_TickCount

		Jitter("Left", [142, 265])
		Sleep, Rand(150, 214)
		Jitter("Right", [169, 259])
		
        Sleep, Rand(SleepLowerBound, SleepUpperBound)
    }
	
    Return


#If
^R::Reload
+^C::ExitApp
