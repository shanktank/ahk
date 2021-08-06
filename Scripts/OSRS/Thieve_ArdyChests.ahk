#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk
#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

foo() {
	
}

F1::foo()

^R::Reload
+^C::ExitApp
