#Include, class_DD.ahk

#SingleInstance FORCE
;#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

/*
From hovering second item in bank
	at bottom right:
		Esc
		4UL, 1U
		Click
		3DR, 7D
		Click
		3DR, 3R
		Click
		2UL, 2L
		Click
		2UL, 4U
		Shift Click
		1R
		Click
*/

moveMouse(key1, num1) {
	Loop, %num1% {
		Send, {NumPad7}
	}
}

F1::
	moveMouse("{NumPad7}", 4)
	Return

F2::
	dd._key_press("Ctrl", "NumPad7")
	Return
