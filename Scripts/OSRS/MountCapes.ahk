#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance Force
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
;;	Camera zoom set to 1004/1004, camera position set to "Look North" compass click
;;	Hammer, saw, and red cavalier in last three inventory slots
;;	Options keyboard shortcut set to F5
;;	Plugins panel expanded

;; ========================================================================================================================================================= ;;
;; == Functions ============================================================================================================================================ ;;
;; ========================================================================================================================================================= ;;

;; TODO: Problem: For one frame between the left-click actions interchanging, "Walk here" is the action and kind of fucks us up.
doBuildCycle() {
	;; Open remove interface
	UIObject.doClick()
	While(removePrompt.waitForPixelToBeColor(generateSleepTime(216, 299)) == False) {
		If(A_Index > 10) {
			ToolTip % "Error opening remove prompt!", 0, 0
			;Reload
			Break
		} Else {
			If(removePrompt.verifyPixelColor() == False) {
				UIObject.doClick()
			} Else {
				Break
			}
		}
	}
	
	;; Remove mounted cape
	UIObject.inputKeyAndSleep("1")
	While(removePrompt.verifyPixelColor()) {
		If(A_Index > 10) {
			ToolTip % "Error removing mounted cape!", 0, 0
			;Reload
			Break
		} Else {
			UIObject.inputKeyAndSleep("1", generateSleepTime(146, 232))
		}
	}

	;; Wait for mounted cape to be removed
	While(emptyBuildSpot1.verifyPixelColor() == False And emptyBuildSpot2.verifyPixelColor() == False) {
		If(A_Index > 50) {
			MsgBox % "Cape never actually removed?"
			Reload
		} Else {
			Sleep, 50
		}
	}

	;; Open build interface
	UIObject.doClick()
	While(buildInterface.waitForPixelToBeColor(generateSleepTime(142, 213)) == False) {
		If(A_Index > 10) {
			MsgBox % "Error opening build interface!"
			Reload
		} Else {
			If(buildInterface.verifyPixelColor() == False) {
				UIObject.doClick()
			} Else {
				Break
			}
		}
	}
	
	;; Build mounted cape
	While(buildInterface.verifyPixelColor()) {
		If(A_Index > 10) {
			MsgBox % "Error building mounted cape!"
			Reload
		} Else {
			UIObject.inputKeyAndSleep("4", generateSleepTime(176, 272))
		}
	}
}

getMorePlanks() {
	;; Open options menu if not open
	If(optionsButton.verifyPixelColor() == False)
		Send, {F5}
		
	;; Click house options button and wait for call servant button
	houseOptionsButton.moveMouseAndClick(3)
	callServantVisible.waitForPixelToBeColor()
	
	;; Click call servant button, and do it again if he's slow
	UIObject.doClick()
	While(getPlanksChat.waitForPixelToBeColor(generateSleepTime(943, 1642)) == False) {
		If(A_Index > 5) {
			MsgBox % "Error calling butler!"
			Reload
		} Else {
			If(callServantVisible.verifyPixelColor() && getPlanksChat.verifyPixelColor() == False) {
				UIObject.doClick()
			} Else {
				Break
			}
		}
	}
	
	;; Send butler to get planks
	While(getPlanksChat.verifyPixelColor() == True) {
		UIObject.inputKeyAndSleep("1", generateSleepTime(152, 243))
	}
	
	;Move mouse back to build spot
	capeSpotBounds.moveMouse(3.5)
	;Sleep, generateSleepTime()
}

main() {
	Loop {
		If(inventorySlot24.waitForPixelToBeColor(3000) == False) {
			MsgBox % "Done, or at least mostly."
			Reload
		}

		;; Move mouse to building spot and begin building
		While(inventorySlot21.verifyPixelColor())
			doBuildCycle()

		;; Send butler for more planks when we have 6 left
		getMorePlanks()

		;; Use our last three planks while the butler is gone
		While(inventorySlot24.verifyPixelColor())
			doBuildCycle()

		/*
		;; Wait for butler to return and finish dialogue so he'll fuck off
		If(demonButlerChat.waitForPixelToBeColor(500) == False) {
			;; Click house options button and wait for call servant button
			houseOptionsButton.moveMouseAndClick(3)
			callServantVisible.waitForPixelToBeColor()
	
			;; Click call servant button, and do it again if he's slow
			UIObject.doClick()		
		}
		*/

		demonButlerChat.waitForPixelToBeColor(9001)
		Sleep, generateSleepTime()
		;UIObject.inputKeyAndSleep("{Space}")
	}
}

;; ========================================================================================================================================================= ;;
;; == Global Variables ===================================================================================================================================== ;;
;; ========================================================================================================================================================= ;;

Global capeSpotBounds		:= New TileMarkerBounds(0x6D98BF, [ -57, 89 ], [ 63, 241 ])

Global houseOptionsButton	:= New ClickAreaBounds([ 1520, 945 ], [ 1560, 965 ])
Global callServantBounds	:= New ClickAreaBounds([ 1510, 925 ], [ 1580, 960 ])

Global removePrompt			:= New PixelColorLocation(0x368D88, [  553,  871 ])
Global buildInterface		:= New PixelColorLocation(0xFF0000, [  390,  295 ])
Global emptyBuildSpot1		:= New PixelColorLocation(0xEDEAE3, [  825,  200 ])
Global emptyBuildSpot2		:= New PixelColorLocation(0xEDEAE3, [  900,  240 ])
Global optionsButton		:= New PixelColorLocation(0x6B241B, [ 1525, 1015 ])
Global houseOptionsCheck	:= New PixelColorLocation(0x6B6983, [ 1540,  955 ])
Global callServantVisible	:= New PixelColorLocation(0x000001, [ 1611,  669 ])
Global callServantButton	:= New PixelColorLocation(0xDFDFDF, [  648,  887 ])
Global getPlanksChat		:= New PixelColorLocation(0x368D89, [  549,  871 ])
Global demonButlerChat		:= New PixelColorLocation(0x151111, [   76,  885 ])
Global inventorySlot01		:= New PixelColorLocation(0x604E2C, [ 1440,  315 ])
Global inventorySlot18		:= New PixelColorLocation(0x5E4C2B, [ 1495,  510 ])
Global inventorySlot21		:= New PixelColorLocation(0x695630, [ 1435,  560 ])
Global inventorySlot24		:= New PixelColorLocation(0x62502C, [ 1605,  560 ])

;; ========================================================================================================================================================= ;;
;; == Hotkeys ============================================================================================================================================== ;;
;; ========================================================================================================================================================= ;;

F1::main()

;; ========================================================================================================================================================= ;;
;; == Script Controls ====================================================================================================================================== ;;
;; ========================================================================================================================================================= ;;

#If
^R::Reload
+^C::ExitApp
