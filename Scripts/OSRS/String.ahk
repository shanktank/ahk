#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
SendMode Input

Global BREAKOUT := False

sleepAndClick(sleepy) {
    Sleep, sleepy
	If(BREAKOUT = True) {
		Return
	}
    Send ``
}

`::
	Click
	Return

; Unstrung bow
Numpad1::
	MouseMove, 1520, 880, 0
	Return

; Bow string
Numpad2::
	MouseMove, 1560, 880, 0
	Return

; Banker
Numpad3::
	MouseMove, 825, 500, 0
	Return

; Deposit all
Numpad4::
	MouseMove, 900, 830, 0
	Return

; Unstrung bow in bank
Numpad5::
	MouseMove, 540, 290, 0
	Return

; Bow string in bank
Numpad6::
	MouseMove, 590, 290, 0
	Return

^B::
	BREAKOUT := False

	Loop {
		Random, sleep1, 250, 500
		Random, sleep2, 250, 500
		Random, sleep3, 1500, 2500
		Random, sleep4, 17500, 20000
		Random, sleep5, 1000, 1500
		Random, sleep6, 250, 500
		Random, sleep7, 250, 500
		Random, sleep8, 1000, 1500
		Random, sleep9, 250, 500

		; Click unstrung bow
		Send {Numpad1}
		sleepAndClick(sleep1)
		; Click bow string
		Send {Numpad2}
		sleepAndClick(sleep2)
		; Press 1
		Sleep, sleep3
		Send 1
		; Click banker
		Send {Numpad3}
		sleepAndClick(sleep4)
		If(BREAKOUT = True) {
			Return
		}
		; Deposit inventory
		Send {Numpad4}
		sleepAndClick(sleep5)
		; Withdraw unstrung bows
		Send {Numpad5}
		sleepAndClick(sleep6)
		; Withdraw bow strings
		Send {Numpad6}
		sleepAndClick(sleep7)
		; Press escape
		Sleep, sleep8
		Send {Esc}
		Sleep, sleep9

		If(BREAKOUT = True) {
			Return
		}
	}

	Return

^C::
PrintScreen::
	BREAKOUT := True
	Return