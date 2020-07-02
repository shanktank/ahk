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

Global fishingSpotColor		:= 0x08ADAF
Global depositBoxTileColor	:= 0x0303F7

Global invSlot28MonkFish	:= New PixelColorLocation(0x8A644E, [ 1585, 965 ])
Global fishingCheck			:= New PixelColorLocation(0x00F500, [   67,  68 ])
Global depositScreenCheck	:= New PixelColorLocation(0x771C1A, [  630, 560 ])

Global invSlot01Bounds		:= New ClickAreaBounds([ 1465, 665 ], [ 1495, 690 ])
Global depositFishBounds	:= New ClickAreaBounds([  880, 500 ], [  915, 525 ])

main() {
	Loop {
		; Periodically check if we're still fishing
		While(verifyPixelColor(fishingCheck.pixelColor, fishingCheck.pixelCoords) == True) {
			Sleep, generateSleepTime(1750, 3250)
		}

		; Bank fish if inventory is full
		If(verifyPixelColor(invSlot28MonkFish.pixelColor, invSlot28MonkFish.pixelCoords)) {
			Loop {
				XY := findPixelByColor(depositBoxTileColor, [ 0, 50 ], [ 1350, 950 ], 25)["xy"]
				Random, dx, 3, 8
				Random, dy, 3, 8
				If(moveMouseAndClick([ XY[1] - dx, XY[2] + dy ],,, "Interact") == True) {
					Break
				} Else If(A_Index > 10) {
					MsgBox % "Tons of misclicks"
					Reload
				}
			}
			waitForPixelToBeColor(depositScreenCheck.pixelColor, depositScreenCheck.pixelCoords, 10000)
			moveMouseAndClick(generateCoords(depositFishBounds.lowerBounds, depositFishBounds.upperBounds))
			Sleep, generateSleepTime(243, 413)
			Send {Esc}
			Sleep, generateSleepTime()
		}

		; Walk back out of the bank to the purple marker
		If(findPixelByColor(fishingSpotColor, [ 0, 50 ], [ 1350, 950 ], 25)["rc"] != 0) {
			XY := findPixelByColor(PURPLE, [ 0, 50 ], [ 1350, 950 ], 25)["xy"]
			Random, dx, -14, 16
			Random, dy, -9, 13
			moveMouseAndClick([ XY[1] - dx, XY[2] + dy ])
			Sleep, generateSleepTime(3323, 4836)
		}
		
		; Wait until a fishing pool is visible
		;While(findPixelByColor(fishingSpotColor, [ 0, 50 ], [ 1350, 950 ])["rc"] != 0) {
		While(findPixelByColorWaveSearch(fishingSpotColor, [ 0, 50 ], [ 1350, 950 ], 25)["rc"] != 0) {
			If(A_Index > 5) {
				MsgBox % "Couldn't find a fishing spot"
				Reload
			}
			Sleep, 200
		}

		; Resume fishing
		Loop {
			;XY := findPixelByColor(fishingSpotColor, [ 0, 50 ], [ 1350, 950 ], 25)["xy"]
			XY := findPixelByColorWaveSearch(fishingSpotColor, [ 0, 50 ], [ 1350, 950 ], 25)["xy"]
			Random, dx, 3, 7
			Random, dy, 3, 7
			If(moveMouseAndClick([ XY[1] - dx, XY[2] + dy ],,, "Interact") == True) {
				Break
			} Else If(A_Index > 10) {
				MsgBox % "Tons of misclicks"
				Reload
			}
		}
		Sleep, 7500
	}
}

F1::main()
F2::moveMouse(findPixelByColor(fishingSpotColor,, [ 1350, 950 ])["xy"])

#If
^R::Reload
+^C::ExitApp
