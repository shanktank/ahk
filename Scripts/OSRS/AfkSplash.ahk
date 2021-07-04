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
SetKeyDelay, 0, 1, Input
SendMode, Input

;#IfWinActive ^(RuneLite|OpenOSRS)$


;CD := Func("CountDown").Bind(CountDown())


Global SleepLowerBound := 423000
Global SleepUpperBound := 873000
Global SleepTime       := 1000
Global StartTime       := A_TickCount
Global Executing       := False


If(A_Args[1] == "F1") {
	AfkSplash()
}


Info() {
	Local RawTime := (StartTime - A_TickCount + SleepTime) / 1000
	Local Minutes := RawTime / 60
	Local Seconds := Mod(RawTime, 60)
	
	ToolTip % "Next action in " Format("{:d}", Minutes) ":" Format("{:02d}", Seconds), 0, 0
	
	Return RawTime * 1000
}

GenerateSleep() {
	Return Rand(SleepLowerBound, SleepUpperBound) / 4
}

foo(f) {
	%f%(GenerateSleep())
}

ResetTime() {
	StartTime := A_TickCount
	SleepTime := GenerateSleep()
	
	Sleep, SleepTime
}

Jitter(SleepTime) {
	ResetTime()
	
	Send, {Left Down}
	Sleep, Rand([ 142, 265 ])
	Send, {Left Up}
	
	Send, {Right Down}
	Sleep, Rand([ 169, 259 ])
	Send, {Right Up}
	
	Sleep, SleepTime
}

Words(SleepTime) {
	ResetTime()
	
	Send % "asdf"
	Sleep, Rand(313, 429)
	Send, {Control Down}d{Control Up}
	
	Sleep, SleepTime
}

Jiggle(SleepTime) {
	ResetTime()
	
	Send, {MButton Down}
	UIObject.moveMouseRelative(Rand(-6, 7), Rand(-5, 8))
	Sleep, Rand(53, 78)
	Send, {MButton Up}
	
	Sleep, SleepTime
}

RightClick(SleepTime) {
	ResetTime()
	
	Click, Right
	Sleep, Rand(32, 114)
	UIObject.moveMouseRelative(Rand(-27, 35), Rand(-99, -124), 2)
	Sleep, Rand(67, 114)
	UIObject.moveMouseRelative(Rand(-33, 42), Rand(92, 129), 2)
	
	Sleep, SleepTime
}


AfkSplash() {
	If(Executing == True) {
		Run, "%A_AhkPath%" /r "%A_ScriptFullPath%" "F1"
	} Else {
		Executing := True
	}

	SetTimer, Info, 1000

    Loop {
		SleepTimes := [ GenerateSleep(), GenerateSleep(), GenerateSleep(), GenerateSleep() ]
fn := Func("Jitter").Bind(GenerateSleep())
;foo("Jitter")
fn.Call()
Return
		Jitter(SleepTimes[1])
		Words(SleepTimes[2])
		Jiggle(SleepTimes[3])
		RightClick(SleepTimes[4])
    }
	
	Executing := False
	
    Return
}


F1::AfkSplash()


#If
^R::Reload
+^C::ExitApp
