#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

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
;	Camera zoom set to 1004/1004, camera position set to "Look North" compass click
;	Hammer, saw, and red cavalier in last three inventory slots
;	Options keyboard shortcut set to F5
;	Plugins panel expanded

; ============================================================================================================================================================ ;
; == Functions =============================================================================================================================================== ;
; ============================================================================================================================================================ ;

doBuildCycle() {
	; Remove mounted cape
	Click
	removePrompt.waitForPixelToBeColor()
	Send, 1

	; Wait for mounted cape to be removed
	Loop, 10 {
		If(emptyBuildSpot1.verifyPixelColor() Or emptyBuildSpot2.verifyPixelColor())
			Break
		Sleep, 250
	}
	Sleep, generateSleepTime(273, 429)

	; Build mounted cape
	Click
	buildInterface.waitForPixelToBeColor()
	Sleep, generateSleepTime(219, 414)
	Send, 4
	Sleep, generateSleepTime(1776, 2130)
}

getMorePlanks() {
	; Open options menu if not open
	If(optionsButton.verifyPixelColor() == False)
		Send, {F5}
		
	; Click house options button and wait for call servant button
	houseOptionsButton.moveMouseAndClick()
	callServantVisible.waitForPixelToBeColor()
	
	; Click call servant button, and do it again if he's slow
	Sleep, generateSleepTime(134, 213)
	Click
	If(getPlanksChat.waitForPixelToBeColor(2000) == False) {
		Click
		callServantVisible.waitForPixelToBeColor()
		Sleep, generateSleepTime(239, 312)
		Click
		If(getPlanksChat.waitForPixelToBeColor() == False) {
			MsgBox % "The butler never came :("
			Reload
		}
	}
	
	; Send butler to get planks
	While(getPlanksChat.verifyPixelColor() == True) {
		Sleep, generateSleepTime(269, 392)
		Send, 1
	}
	
	; Move mouse back to build spot
	;capeSpotBounds.moveMouse(capeSpotBounds.generateCoords())
	capeSpotBounds.moveMouse()
	Sleep, generateSleepTime(333, 539)
}

main() {
	Loop {
		;If(verifyPixelColor(inventorySlot01["color"], inventorySlot01["xy"]) == False) {
		;	MsgBox % "We're done!"
		;	Return
		;}

		; Move mouse to building spot and begin building
		;capeSpotBounds.moveMouse(capeSpotBounds.generateCoords())
		capeSpotBounds.moveMouse()
		While(inventorySlot21.verifyPixelColor())
			doBuildCycle()

		; Send butler for more planks when we have 3 left
		getMorePlanks()

		; Use our last three planks while the butler is gone
		If(inventorySlot24.verifyPixelColor())
			doBuildCycle()

		; Wait for the butler and finish dialogue so he'll fuck off
		demonButlerChat.waitForPixelToBeColor(9001)
		Sleep, generateSleepTime(123, 321)
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

Global removePrompt			:= New PixelColorLocation(0x368D88, [  553,  871 ])
Global buildInterface		:= New PixelColorLocation(0xFF0000, [  390,  295 ])
Global emptyBuildSpot1		:= New PixelColorLocation(0xEDEAE3, [  820,  200 ])
Global emptyBuildSpot2		:= New PixelColorLocation(0xEDEAE3, [  900,  200 ])
Global optionsButton		:= New PixelColorLocation(0x6B241B, [ 1525, 1015 ])
Global houseOptionsCheck	:= New PixelColorLocation(0x6B6983, [ 1540,  955 ])
Global callServantVisible	:= New PixelColorLocation(0x000001, [ 1611,  669 ])
Global callServantButton	:= New PixelColorLocation(0xDFDFDF, [  648,  887 ])
Global getPlanksChat		:= New PixelColorLocation(0x368D89, [  549,  871 ])
Global demonButlerChat		:= New PixelColorLocation(0x151111, [   76,  885 ])
Global inventorySlot01		:= New PixelColorLocation(0x604E2C, [ 1440,  315 ])
Global inventorySlot21		:= New PixelColorLocation(0x695630, [ 1435,  560 ])
Global inventorySlot24		:= New PixelColorLocation(0x62502C, [ 1605,  560 ])

Global capeSpotBounds       := New ClickAreaBounds([  810, 168 ], [  988, 387 ])
Global houseOptionsButton	:= New ClickAreaBounds([ 1520, 945 ], [ 1560, 965 ])
Global callServantBounds	:= New ClickAreaBounds([ 1510, 925 ], [ 1580, 960 ])

; ============================================================================================================================================================ ;
; == Hotkeys ================================================================================================================================================= ;
; ============================================================================================================================================================ ;

F1::main()

; ============================================================================================================================================================ ;
; == Script Controls ========================================================================================================================================= ;
; ============================================================================================================================================================ ;

#If
^R::Reload
+^C::ExitApp
