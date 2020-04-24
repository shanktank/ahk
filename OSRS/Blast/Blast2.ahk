#Include, class_DD.ahk

#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

randomSleep(lowerBound, upperBound) {
	Random, sleepFor, lowerBound, upperBound
	Sleep, sleepFor
}

moveMouse(key1, num1) {
	Loop, %num1% {
		dd._key_press(key1)
		randomSleep(175, 240)
	}
}

F1::
	If(GetKeyState("NumLock", "T")) {
		dd._key("Ctrl", "Down")
		
		moveMouse("NumPad7", 4)
		moveMouse("NumPad8", 1)
		randomSleep(512, 819)
		
		moveMouse("NumPad3", 3)
		moveMouse("NumPad2", 7)
		randomSleep(512, 819)
		
		moveMouse("NumPad3", 3)
		moveMouse("NumPad6", 3)
		randomSleep(512, 819)
		
		moveMouse("NumPad7", 2)
		moveMouse("NumPad4", 2)
		randomSleep(512, 819)
		
		moveMouse("NumPad7", 2)
		moveMouse("NumPad8", 4)
		dd._key_press("NumPad5")
		randomSleep(512, 819)
		
		moveMouse("NumPad6", 1)
		dd._key_press("Shift", "NumPad5")
		
		dd._key("Ctrl", "Up")
	} Else {
		MsgBox % "Numlock is off"
	}
	
	Return

^R::Reload
