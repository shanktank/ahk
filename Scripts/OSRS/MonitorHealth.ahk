#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance Force
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

SetTimer, CheckHitpoints, 100
Return

CheckHitpoints:
If(LowHealthCheck.verifyPixelColor() == True) {
	ToolTip % "High health", 250, 0
} Else {
	ToolTip % "Low health", 250, 0
}
Return

/*
checkHitpoints() {
	If(LowHealthCheck.verifyPixelColor() == True) {
		ToolTip % "High health"
	} Else {
		ToolTip % "Low health"
	}
}

main() {
	Loop {
		checkHitpoints()
	}
}

F1::main()
*/

#If
^R::Reload
+^C::ExitApp
