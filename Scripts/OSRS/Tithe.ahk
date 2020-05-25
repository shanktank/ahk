#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
SendMode Input

`::
	MouseMove, 1475, 765, 0
	Random, sleepy, 50, 100
	Sleep, sleepy
	Click
	Return

PrintScreen::Pause