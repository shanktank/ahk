#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#InstallKeybdHook
#MaxThreadsPerHotkey, 255
#SingleInstance Force
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, RegEx
SendMode, Input

#IfWinActive ^(RuneLite|OpenOSRS)$


Global SleepLowerBound := 423000
Global SleepUpperBound := 873000
Global SleepTime       := 1000
Global StartTime       := A_TickCount


Info() {
	Local RawTime := (StartTime - A_TickCount + SleepTime) / 1000
	Local Minutes := RawTime / 60
	Local Seconds := Mod(RawTime, 60)
	
	ToolTip % "Next action in " Format("{:d}", Minutes) ":" Format("{:02d}", Seconds), 0, 0
	
	Return RawTime * 1000
}

GenerateSleep() {
	SleepTime := Rand(SleepLowerBound, SleepUpperBound) / 4
	Return SleepTime
}

Jitter() {
	StartTime := A_TickCount
	
	Send, {Left Down}
	Sleep, Rand(142, 265)
	Send, {Left Up}
	Sleep, Rand(39, 63)
	Send, {Right Down}
	Sleep, Rand(169, 259)
	Send, {Right Up}
	
	Sleep, GenerateSleep()
}

Words() {
	StartTime := A_TickCount
	
	Send % "asdf"
	Sleep, Rand(313, 429)
	Send, {Control Down}d{Control Up}
	
	Sleep, GenerateSleep()
}

Jiggle() {
	StartTime := A_TickCount
	
	Send, {MButton Down}
	UIObject.moveMouseRelative(Rand(-6, 7), Rand(-5, 8))
	Sleep, Rand(53, 78)
	Send, {MButton Up}
	
	Sleep, GenerateSleep()
}

RightClick() {
	StartTime := A_TickCount
	
	Click, Right
	Sleep, Rand(32, 114)
	UIObject.moveMouseRelative(Rand(-27, 35), Rand(-99, -124), 2)
	Sleep, Rand(67, 114)
	UIObject.moveMouseRelative(Rand(-33, 42), Rand(92, 129), 2)
	
	Sleep, GenerateSleep()
}


AfkSplash() {
	SetTimer, Info, 1000

    Loop {
		Action := Rand(1, 4)
		
		If(Action == 1) { 
			Jitter()
		} Else If(Action == 2) {
			Words()
		} Else If(Action == 3) {
			Jiggle()
		} Else {
			RightClick()
		}
    }
	
    Return
}


F1::AfkSplash()


#If
^R::Reload
+^C::ExitApp
