#Include %A_MyDocuments%/Git/ahk/Libraries/Math.ahk

#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

F1::
	MouseGetPos, X1, Y1
	SetTimer, CheckCursor, 100
	Loop {
        Click
		Sleep, Rand(642, 854)
    }
    Return

CheckCursor:
MouseGetPos, X2, Y2
If(X1 != X2 Or Y1 != Y2)
	Reload
Return

^R::Reload
+^C::ExitApp
