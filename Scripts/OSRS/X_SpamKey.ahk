#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode SendPlay


;#SingleInstance Force
;#EscapeChar \
;#Persistent
;#NoEnv
;#Warn

SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx
SetKeyDelay, 0, 1, Play
SendMode, Play




Global BREAKOUT := False

MouseGetPos, sx, sy
SetTimer, CheckCursor, 100
Return

CheckCursor:
MouseGetPos, cx, cy
If(cx != sx Or cy != sy Or cx > sx + 1 Or cx < sx - 1 Or cy > sy + 1 Or cy < sy - 1) {
	BREAKOUT := True
}
Return

F1::
    BREAKOUT := False
    
	Loop {
		;Send, {Space}
		Send, {Enter}
		
		If(BREAKOUT = True)
			Return
		
		;Random, sleepy, 63, 213
		Random, sleepy, 50, 100
		ToolTip % "Next sleep in " sleepy, 0, 0
		;Random, sleepy, 250, 750
        Sleep, sleepy
    }
    Return

^R::Reload
+^C::ExitApp
