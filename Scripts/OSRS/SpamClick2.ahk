#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

CursorMovement() {
	Static X1, Y1, X2, Y2
	MouseGetPos, X1, Y1
	
	CheckCursor:
	MouseGetPos, X2, Y2
	If(X1 != X2 Or Y1 != Y2) {
		Reload
	} Else {
		Click
	}
	
	SetTimer, CheckCursor, 100
	Return
}

F1::CursorMovement()

^R::Reload
+^C::ExitApp
