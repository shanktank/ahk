#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

Global BREAKOUT := False

MouseGetPos, sx, sy
SetTimer, CheckCursor, 100
Return

CheckCursor:
	MouseGetPos, cx, cy
	If(cx != sx Or cy != sy) {
		If(cx > sx + 1 Or cx < sx - 1 Or cy > sy + 1 Or cy < sy - 1) {
			BREAKOUT := True
		}
	}
	Return

F1::
    BREAKOUT := False
    Loop {
		If(BREAKOUT = True) {
			Return
		}
		
        Click
		
		Random, sleepy, 642, 854
        Sleep, sleepy
    }
    Return

^R::Reload
+^C::ExitApp
