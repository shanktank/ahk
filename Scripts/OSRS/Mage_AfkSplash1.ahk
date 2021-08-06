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

Global StartTime := A_TickCount
Global SleepTime := 0


Info() {
	NextTime := StartTime - A_TickCount + SleepTime
	ToolTip % "Next action in " Format("{:d}", NextTime / 60000) ":" Format("{:02d}", Mod(NextTime, 60000) / 1000), 0, 0
}

Jitter() {
	UIObject.inputKeyAndSleep("{Left Down}", Rand(142, 265))
	UIObject.inputKeyAndSleep("{Left Up}", Rand(39, 63))
	UIObject.inputKeyAndSleep("{Right Down}", Rand(139, 263))
	Send, {Right Up}
}

Words() {
	UIObject.inputKeyAndSleep(((Rand(1.0, 100.0) > 73.73) ? "asdf" : "adsf"), Rand(313, 429))
	Send, {Control Down}d{Control Up}
}

Jiggle() {
	Send, {MButton Down}
	UIObject.moveMouseRelative(Rand(-6, 7), Rand(-5, 8),, Rand(53, 78))
	Send, {MButton Up}
}

RightClick() {
	Click, Right
	UIObject.moveMouseRelative(Rand(-27, 35), Rand(-99, -124), 2, Rand(132, 214))
	UIObject.moveMouseRelative(Rand(-33, 42), Rand(92, 129), 2)
}


AfkSplash() {
	SetTimer, Info, 1000

    Loop {
		StartTime := A_TickCount
		
		Switch Rand(1, 4) {
			Case 1: Jitter()
			Case 2: Words()
			Case 3: Jiggle()
			Case 4: RightClick()
		}
		
		SleepTime := Rand(SleepLowerBound, SleepUpperBound) / 2
		Info()
		
		Sleep, SleepTime
    }
}


F1::AfkSplash()


#If
^R::Reload
+^C::ExitApp
