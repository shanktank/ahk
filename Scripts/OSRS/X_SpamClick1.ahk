#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk
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

	Loop {
		MouseGetPos, X2, Y2
		If(X1 != X2 Or Y1 != Y2)
			Reload

		UIObject.doClick(Rand(213, 343))
    }

    Return

^R::Reload
+^C::ExitApp
