#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
SendMode Input

Global BREAKOUT := False

sleepClick(sleepy) {
    Sleep, sleepy
	If(BREAKOUT = True) {
		Return
	}
	Send ``
}

`::
	Click
	Return

Numpad1::
	MouseMove, 1475, 765, 0
	Return

Numpad2::
	MouseMove, 1520, 765, 0
	Return

^B::
	BREAKOUT := False
	
	Loop {
		Random, sleep1, 100, 200
		Random, sleep2, 250, 500
		Random, sleep3, 1500, 2500
		Random, sleep4, 13000, 15000

		Send {Numpad1}
		sleepClick(sleep1)
		Send {Numpad2}
		sleepClick(sleep2)
		Sleep, sleep3
		Send 1
		Sleep, sleep4
		
		If(BREAKOUT = True) {
			Return
		}
	}

	Return

PrintScreen::
	BREAKOUT := True
	Return