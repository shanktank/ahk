#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

F1::
    Loop {
		Send, {Left Down}
		Sleep, 42, 65
		Send, {Left Up}
		Sleep, 50, 104
		Send, {Right Down}
		Sleep, 40, 59
		Send, {Right Up}
		
		Random, sleepy, 642000, 101300
        Sleep, sleepy
    }
	
    Return

^R::Reload
+^C::ExitApp
