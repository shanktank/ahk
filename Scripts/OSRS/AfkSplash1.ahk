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
	Local NextTime := (StartTime - A_TickCount + SleepTime) / 1000
	
	ToolTip % "Next action in " Format("{:d}", NextTime / 60) ":" Format("{:02d}", Mod(NextTime, 60)), 0, 0
	
	Return NextTime * 1000 ;; ?
}

GenerateSleep() {
	Return Rand(SleepLowerBound, SleepUpperBound) / 4
}

Jitter() {
	StartTime := A_TickCount
	
	;Send, {Left Down}
	;Sleep, Rand(142, 265)
	;Send, {Left Up}
	;Sleep, Rand(39, 63)
	;Send, {Right Down}
	;Sleep, Rand(169, 259)
	;Send, {Right Up}
	UIObject.inputKeyAndSleep("{Left Down}", Rand(142, 265))
	UIObject.inputKeyAndSleep("{Left Up}", Rand(39, 63))
	UIObject.inputKeyAndSleep("{Right Down}", Rand(39, 63))
	UIObject.inputKeyAndSleep("{Right Up}", generateSleep())
	
	Sleep, GenerateSleep()
}

Words() {
	StartTime := A_TickCount
	
	;Send % (Rand(1.0, 100.0) > 73.73) ? "asdf" : "adsf"
	;Sleep, Rand(313, 429)
	UIObject.inputKeyAndSleep(((Rand(1.0, 100.0) > 73.73) ? "asdf" : "adsf"), Rand(313, 429))
	;Send, {Control Down}d{Control Up}
	;Sleep, GenerateSleep()
	UIObject.inputKeyAndSleep("{Control Down}d{Control Up}", GenerateSleep())
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
	UIObject.moveMouseRelative(Rand(-27, 35), Rand(-99, -124), 2, Rand(32, 114))
	UIObject.moveMouseRelative(Rand(-33, 42), Rand(92, 129), 2, Rand(67, 121))
	
	Sleep, GenerateSleep()
}


AfkSplash() {
	SetTimer, Info, 250

    Loop {
		Switch Rand(1, 4) {
			Case 1: Jitter()
			Case 2: Words()
			Case 3: Jiggle()
			Case 4: RightClick()
		}
		
		/*
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
		*/
    }
	
    Return
}


F1::AfkSplash()


#If
^R::Reload
+^C::ExitApp
