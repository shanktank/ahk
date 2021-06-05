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

;#IfWinActive ^(RuneLite|OpenOSRS)$

Global ScanBoundsFull := New PixelScanArea(0xDCE0D0, [ 1294, 379 ], [ 1350, 84 ], 10)
Global ScanBoundsSlim := New PixelScanArea(0xDCE0D0, [ 1334, 350 ], [ 1350, 84 ], 10)

/*
SetTimer, CheckXpGain, 250
Return

CheckXpGain:
Result := FireMakingScanBounds.scanAreaForPixelColor()
;ToolTip % "rc=" rc5 ", xy: " x5 ", " y5, 0, 0
;If(Result["rc"] == 0) {
;	ToolTip % "YES", 0, 0
;} Else {
;	ToolTip % "no", 0, 0
;}
Return
*/

F1::
	Loop {
		;PixelSearch, X5, Y5, 1294, 379, 1350, 84, 0xDCE0D0, 10, Fast RGB
		PixelSearch, X5, Y5, 1334, 350, 1350, 84, 0xDCE0D0, 10, Fast RGB
		If(ErrorLevel == 0) {
			;MsgBox % "ErrorLevel: " ErrorLevel ", XY: " X5 ", " Y5
			ToolTip % "XP GAIN DETECTED", 0, 0
			Sleep, 2500
		} Else {
			ToolTip % "Nothing", 0, 0
		}
		Sleep, 25
	}

#If
^R::Reload
+^C::ExitApp
