#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk
#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

DoLog := False

F1::
	MouseGetPos, X1, Y1

	sleepTimes := []

	Loop {
		MouseGetPos, X2, Y2
		If(X1 != X2 || Y1 != Y2)
			Reload

		sleepTime := Rand(213, 343)
		
		If(DoLog == True) {
			sleepTimes.Push(sleepTime)
			FileAppend % sleepTime "`, ", sleeptimes.txt
		}
		
		ToolTip % "Next click in " sleepTime " ms", 0, 0
		UIObject.doClick(sleepTime)
    }

    Return

^R::Reload
+^C::ExitApp
