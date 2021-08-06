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
	MouseMove, 1560, 765, 0
	Return

Numpad2::
	MouseMove, 1560, 805, 0
	Return

Numpad3::
	MouseMove, 750, 480, 0
	Return

Numpad4::
	MouseMove, 1475, 805, 0
	Return

Numpad5::
	MouseMove, 590, 290, 0
	Return

^B::
	BREAKOUT := False

	Loop {
		Random, sleep1, 500, 1000
		Random, sleep2, 500, 1000
		Random, sleep3, 1500, 2500
		Random, sleep4, 500, 1000
		Random, sleep5, 16000, 20000
		Random, sleep6, 2000, 3000
		Random, sleep7, 1000, 2000
		Random, sleep8, 1000, 2000
		Random, sleep9, 1000, 2000
		
		;; Click needle
		Send {Numpad1}
		sleepClick(sleep1)
		;; Click leather
		Send {Numpad2}
		sleepClick(sleep2)
		;; Press 1
		Sleep, sleep3
		Send 1
		;;Sleep, sleep4
		;; Click banker
		Send {Numpad3}
		sleepClick(sleep5)
		If(BREAKOUT = True) {
			Return
		}
		;; Deposit bodies
		Send {Numpad4}
		sleepClick(sleep6)
		;; Withdraw leather
		Send {Numpad5}
		sleepClick(sleep7)
		;; Press escape
		Sleep, sleep8
		Send {Esc}
	}

	Return

PrintScreen::
	BREAKOUT := True
	Return

^R::Reload
+^C::ExitApp
