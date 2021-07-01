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
Global StartTime := A_TickCount
Global SleepTime := 0


Jitter(Key, SleepRange) {
	Random, SleepRange, SleepRange[1], SleepRange[2]
	
	Send, {%Key% Down}
	Sleep, SleepRange
	Send, {%Key% Up}
}

CountDown() {
	Local RawTime := (StartTime - A_TickCount + SleepTime) / 1000
	Local Minutes := RawTime / 60
	Local Seconds := Mod(RawTime, 60)
	
	ToolTip % "Next jitter in " Format("{:d}", Minutes) ":" Format("{:02d}", Seconds), 0, 0
}


F1::
	SetTimer, CountDown, 1000

    Loop {
		SleepTime := Rand(SleepLowerBound, SleepUpperBound)
		StartTime := A_TickCount

		Jitter("Left", [142, 265])
		Sleep, Rand(150, 214)
		Jitter("Right", [169, 259])
		
        Sleep, SleepTime
    }
	
    Return


#If
^R::Reload
+^C::ExitApp
