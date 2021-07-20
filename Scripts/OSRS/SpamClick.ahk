#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

F1::
	Sleep, 5000
	UIObject.moveMouse([ 825, 308 ])

	Loop {
		Click	
		Random, sleepy, 642, 854
		Sleep, sleepy
	}
	
	Return

^R::Reload
+^C::ExitApp
