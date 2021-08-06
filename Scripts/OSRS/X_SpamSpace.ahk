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
If(cx != sx or cy != sy) {
	If(cx > (sx+1) or cx < (sx-1) or cy > (sy+1) or cy < (sy-1)) {
		MouseGetPos, sx, sy
		BREAKOUT := True
	}
}
Return

F1::
    BREAKOUT := False
    Loop {
		If(BREAKOUT = True)
			Return
		Random, sleepy, 6300, 21300
        Send, {SPACE}
        Sleep, sleepy
    }
    Return

^R::Reload
+^C::ExitApp
