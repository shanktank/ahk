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

;; Entity Hider
;;  Hide Pets
;;  Hide NPCs Names: Arnold Lydspor
;;  Hide Players?
;;  Hide Players 2D?
;; NPC Indicators
;;  Hightlight Style: Hull

Global fishingSpotColor		:= CYAN
Global depositHullColor		:= BLUE
Global invSlot28MonkFish	:= New PixelColorLocation(0x8A644E, [ 1585, 965 ])
Global fishingCheck			:= New PixelColorLocation(0x00F500, [   67,  68 ])
Global depositScreenCheck	:= New PixelColorLocation(0x771C1A, [  630, 560 ])
Global invSlot01Bounds		:= New ClickAreaBounds([ 1465, 665 ], [ 1495, 690 ])
Global depositFishBounds	:= New ClickAreaBounds([  880, 500 ], [  915, 525 ])

Global shadeTolerance       := 25
Global screenLowerBounds	:= [ 0, 25 ]
Global screenUpperBounds	:= [ 1350, 950 ]
;;Global fishingSpot          := New TileMarkerBounds(fishingSpotColor, [ 0, 0 ], [ 0, 0 ], shadeTolerance)
Global fishingSpot          := New TileMarkerBounds(fishingSpotColor, [ 3, 3 ], [ 9, 9 ], shadeTolerance)
;;Global depositSpot          := New TileMarkerBounds(depositHullColor, [ -5, 9 ], [ 0, 9 ], shadeTolerance)
;;Global depositSpot          := New TileMarkerBounds(depositHullColor, [ -5, 4 ], [ -16, 13 ], shadeTolerance)
Global depositSpot          := New TileMarkerBounds(depositHullColor, [ 0, 3 ], [ 0, 7 ], shadeTolerance)

main() {
	Loop {
		;; Periodically check if we're still fishing
		While(verifyPixelColor(fishingCheck.pixelColor, fishingCheck.pixelCoords) == True) {
			Sleep, generateSleepTime(1750, 3250)
		}

		;; Bank fish if inventory is full
		If(verifyPixelColor(invSlot28MonkFish.pixelColor, invSlot28MonkFish.pixelCoords)) {
			Send {Space}
			Loop {
				/*
				XY := findPixelByColor(depositHullColor, screenLowerBounds, screenUpperBounds, shadeTolerance)["xy"]
				Random, dx, 3, 8
				Random, dy, 3, 8
				If(moveMouseAndClick([ XY[1] - dx, XY[2] + dy ],,, "Interact") == True) {
					Break
				} Else If(A_Index > 10) {
					MsgBox % "Tons of misclicks (1)"
					Reload
				}
				*/

				If(UIObject.moveMouseAndClick(depositSpot.generateCoords(),,, "Interact") == True) {
					Break
				} Else If(A_Index > 10) {
					MsgBox % "Tons of misclicks or something"
					Reload
				}
			}
			waitForPixelToBeColor(depositScreenCheck.pixelColor, depositScreenCheck.pixelCoords, 10000)
			moveMouseAndClick(generateCoords(depositFishBounds.lowerBounds, depositFishBounds.upperBounds))
			Sleep, generateSleepTime(243, 413)
			Send {Esc}
			Sleep, generateSleepTime()

			;; repeated shit from below, need to shore up
			XY := findPixelByColor(PURPLE, screenLowerBounds, screenUpperBounds, shadeTolerance)["xy"]
			Random, dx, -74, 66
			Random, dy, -99, 113
			moveMouseAndClick([ XY[1] - dx, XY[2] + dy ])
			Sleep, generateSleepTime(1323, 2836)
		}

		;; Walk back out of the bank to the purple marker
		If(findPixelByColor(fishingSpotColor, screenLowerBounds, screenUpperBounds, shadeTolerance)["rc"] != 0) {
			XY := findPixelByColor(PURPLE, screenLowerBounds, screenUpperBounds, shadeTolerance)["xy"]
			Random, dx, -14, 16
			Random, dy, -9, 13
			moveMouseAndClick([ XY[1] - dx, XY[2] + dy ])
			Sleep, generateSleepTime(3323, 3836)
		}
		
		;; Wait until a fishing pool is visible
		;;While(findPixelByColor(fishingSpotColor, screenLowerBounds, screenUpperBounds, shadeTolerance)["rc"] != 0) {
		While(fishingSpot.proximitySearch(screenLowerBounds, screenUpperBounds)["rc"] != 0) {
			If(A_Index > 10) {
				MsgBox % "Couldn't find a fishing spot"
				Reload
			}
			Sleep, 500
		}

		;; Resume fishing
		Loop {
			If(A_Index > 10) {
				MsgBox % "Tons of misclicks or couldn't find a fishing spot"
				Reload
			}
			;;XYR := findPixelByColor(fishingSpotColor, screenLowerBounds, screenUpperBounds, shadeTolerance)
			XYR := fishingSpot.proximitySearch(screenLowerBounds, screenUpperBounds)
			If(XYR["rc"] != 0)
				Continue
			;;Random, dx, -3, 3
			;;Random, dy, -3, 3
			;;If(moveMouseAndClick([ XYR["xy"][1] + dx, XYR["xy"][2] + dy ],,, "Interact") == True) {
			If(moveMouseAndClick([ XYR["xy"][1], XYR["xy"][2] ],,, "Interact") == True) {
				Random, offsetX, -119, -231
				Random, offsetY, -312, 287
				moveMouse([ XYR["xy"][1] + offsetX, XYR["xy"][2] + offsetY ], 1.5)
				Break
			}
		}
		Sleep, 7500
	}
}

F1::main()
F2::moveMouse(findPixelByColor(BLUE, screenLowerBounds, screenUpperBounds, shadeTolerance)["xy"])
F3::moveMouse(fishingSpot.proximitySearch(screenLowerBounds, screenUpperBounds)["xy"])

#If
^R::Reload
+^C::ExitApp
