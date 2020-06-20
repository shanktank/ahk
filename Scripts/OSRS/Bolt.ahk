#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
SendMode Input

sleepClick(key, sleepy) {
    Sleep, sleepy
	Send, %key%
}

Numpad1::MouseMove, 1475, 765, 50
Numpad2::MouseMove, 1520, 765, 50
Numpad3::Click

^B::
	Loop {
		Random, sleep1, 400, 550
		Random, sleep2, 400, 500
		Random, sleep3, 900, 1000
		Random, sleep4, 900, 1000

		sleepClick("{Numpad1}", sleep1)
		sleepClick("{Numpad2}", sleep2)
		sleepClick("1", sleep3)

		ToolTip % "Sleeping forever"
		Sleep, sleep4
		ToolTip
	}

	Return

^R::Reload
