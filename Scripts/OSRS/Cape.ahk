#Include "../../Libraries/RandomBezier.ahk"

#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, RegEx
SendMode, Input

#IfWinActive ^(RuneLite|OpenOSRS)$

;; Config:
;	Camera zoom set to 496/896, camera position set to "Look North" compass click
;	Hammer, saw, and red cavalier in last three inventory slots
;	Options keyboard shortcut set to F5
;	Plugins panel expanded

; ============================================================================================================================================================ ;
; == Functions =============================================================================================================================================== ;
; ============================================================================================================================================================ ;

checkPixelColor(target) {
	PixelGetColor, pixelColor, target["xy"][1], target["xy"][2], RGB
	Return pixelColor == target["color"]
}

findPixel(target, loops := 5) {
	Loop, %loops% {
		PixelSearch, X, Y, target["xy1"][1], target["xy1"][2], target["xy2"][1], target["xy2"][2], target["color"], 5, RGB, Fast
		If(ErrorLevel == 1) {
			Sleep, 100
		} Else {
			Return [ X, Y ]
		}
	}
	Return False
}

waitForPixel(target, timeout := 10000, hoverNext := 0) {
	sleepFor := 100
	sleepNum := timeout / sleepFor
	Loop, %sleepNum% {
		Sleep, sleepFor
		If(checkPixelColor(target)) {
			Return True
		}
	}
	Return False
}

generateCoords(target, rel := False) {
	If(rel == True) {
		MouseGetPos, x, y
		xy := [ x, y ]
	} Else {
		xy := findPixel(target)
	}

	Random, xr, target["xr"][1], target["xr"][2]
	Random, yr, target["yr"][1], target["yr"][2]

	Return [ xy[1] + xr, xy[2] + yr ]
}

generateCoordsStatic(target) {
	Random, x, target["xy1"][1], target["xy2"][1]
	Random, y, target["xy1"][2], target["xy2"][2]

	Return [ x, y ]
}

moveMouse(newCoords, optString := "") {
	If(optString == "") {
		mouseSpeed := DecideSpeed(CalculateDistance(newCoords), 2.5)
		optString := "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3"
	}
	RandomBezier(newCoords[1], newCoords[2], optString)
}

doLeftClick(sleepFor := 0) {
	Sleep, generateSleepTime(52, 163)
	Click

	If(sleepFor == 0)
		sleepFor := generateSleepTime()
	Sleep, sleepFor
}

doRightClick(sleepFor := 0) {
	Sleep, generateSleepTime(52, 163)
	Click, Right
	If(sleepFor == 0)
		sleepFor := generateSleepTime()
	Sleep, sleepFor
}

moveAndClick(clickCoords, rightClick := False, sleepFor := 0, divisor := 0.75, attemptNo := 1) {
	mouseSpeed := DecideSpeed(CalculateDistance(clickCoords), divisor)
	If(attemptNo > 1)
		mouseSpeed := mouseSpeed / 2
	optString := "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3"
	moveMouse(clickCoords, optString)
	Return doClick(sleepFor, rightClick)
}

doLeftClickAndVerify() {
	Sleep, generateSleepTime(52, 163)
	MouseGetPos, X, Y
	Click
	Loop, 20 {
		Sleep, 5
		PixelGetColor, pixelColor, X, Y, RGB
		If(pixelColor == 0xFF0000) {
			Return True
		}
	}
	Return False
}

generateSleepTime(lowerBound := 109, upperBound := 214) {
	Random, sleepFor, %lowerBound%, %upperBound%
	Return sleepFor
}

doBuildCycle() {
	Loop {
		moveAndClick(generateCoords(capeSpotInfo), True, generateSleepTime(132, 222))
		If(moveAndClick(generateCoords(capeMenuEntryPlay, True)))
			Break
		Else If(A_Index > 5)
			Return False
	}
	waitForPixel(removePrompt)
	Sleep, generateSleepTime(139, 313)
	Send, 1

	waitForPixel(emptyBuildSpot2)
	Sleep, generateSleepTime(148, 267)
	Loop {
		moveAndClick(generateCoords(buildSpotInfo), True, generateSleepTime(113, 219))
		If(moveAndClick(generateCoords(buildMenuPlay, True)))
			Break
		Else If(A_Index > 5)
			Return False
	}
	waitForPixel(buildInterface)
	Send, 4
	Sleep, generateSleepTime(1750, 2250)
}

doBuildCycleOneClick() {

}

getMorePlanks() {
	moveAndClick(generateCoordsStatic(houseOptionsButton),,, 2.5)
	waitForPixel(callServantVisible)
	Sleep, generateSleepTime(239, 312)
	moveAndClick(generateCoordsStatic(callServantBounds))
	If(waitForPixel(getPlanksChat, 2000) == False) {
		moveAndClick(generateCoordsStatic(houseOptionsButton))
		waitForPixel(callServantVisible)
		Sleep, generateSleepTime(239, 312)
		moveAndClick(generateCoordsStatic(callServantBounds))
		waitForPixel(getPlanksChat)
	}
	Sleep, generateSleepTime(265, 446)
	Send, 1
	moveMouse(generateCoords(capeSpotInfo))
	Sleep, generateSleepTime(500, 813)
}

main() {
	Loop {
		Loop, 7 {
			doBuildCycle()
		}
		getMorePlanks()
		doBuildCycle()
		waitForPixel(demonButlerChat, 2000)
		Send, {Space}
	}
}

; ============================================================================================================================================================ ;
; == Global Variables ======================================================================================================================================== ;
; ============================================================================================================================================================ ;

; Elements: (1) pixel color, (2) top left search area coords, (3) bottom right search area coords, (4) x-axis click offset range, (5) y-axis click offset range
Global capeSpotInfo			:= { "color" : 0x6D99C0, "xy1" : [ 750, 400 ], "xy2" : [  900, 475 ], "xr" : [ -25, 30 ], "yr" : [ -10,  63 ] }
Global buildSpotInfo		:= { "color" : 0xEDEAE3, "xy1" : [ 750, 400 ], "xy2" : [  900, 475 ], "xr" : [   0, 60 ], "yr" : [   0,  59 ] }
Global demonButlerInfo		:= { "color" : 0x311106, "xy1" : [ 600, 400 ], "xy2" : [ 1000, 650 ], "xr" : [  -9, 23 ], "yr" : [  20, 130 ] }

; Elements: (1) pixel color, (2) x-axis click offset range, (3) y-axis click offset range
Global capeMenuEntryPlay	:= { "color" : 0x000000, "xr" : [ -55, 62 ], "yr" : [ 86, 105 ] }
Global buildMenuEntryPlay	:= { "color" : 0x000000, "xr" : [ -73, 80 ], "yr" : [ 65,  84 ] }

; Elements: (1) pixel color, (2) pixel coordinates
Global removePrompt			:= { "color" : 0x1D8480, "xy" : [  554,  871 ] }
Global buildInterface		:= { "color" : 0xFF0000, "xy" : [  390,  295 ] }
Global emptyBuildSpot1		:= { "color" : 0xEDEAE3, "xy" : [  800,  410 ] }
Global emptyBuildSpot2		:= { "color" : 0xEDEAE3, "xy" : [  825,  410 ] }
Global optionsButton		:= { "color" : 0x6B241B, "xy" : [ 1525, 1015 ] }
Global houseOptionsCheck	:= { "color" : 0x6B6983, "xy" : [ 1540,  955 ] }
Global callServantVisible	:= { "color" : 0x4F4F4B, "xy" : [ 1510,  930 ] }
Global callServantButton	:= { "color" : 0xDFDFDF, "xy" : [  648,  887 ] }
Global getPlanksChat		:= { "color" : 0x4E4B20, "xy" : [  554,  871 ] }
Global demonButlerChat		:= { "color" : 0x6D240D, "xy" : [   79,  904 ] }

; Elements: (1) top left click area coords, (2) bottom right click area coords
Global houseOptionsButton	:= { "xy1" : [ 1520, 945 ], "xy2" : [ 1560, 985 ] }
Global callServantBounds	:= { "xy1" : [ 1510, 925 ], "xy2" : [ 1580, 960 ] }

; ============================================================================================================================================================ ;
; == Hotkeys ================================================================================================================================================= ;
; ============================================================================================================================================================ ;

F1::
	main()
	Return

; ============================================================================================================================================================ ;
; == Script Controls ========================================================================================================================================= ;
; ============================================================================================================================================================ ;

#If
^R::Reload
+^C::ExitApp
