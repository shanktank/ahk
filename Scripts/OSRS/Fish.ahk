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
Global notFishingCheck		:= New PixelColorLocation(0xCB0000, [ 51,    70 ])
Global depositScreenCheck	:= New PixelColorLocation(0x771C1A, [ 630,  560 ])

Global invSlot01Bounds		:= New ClickAreaBounds([ 1465, 665 ], [ 1495, 690 ])
Global depositFishBounds	:= New ClickAreaBounds([ 880,  500 ], [ 915,  525 ])

main() {
	Loop {
		While(verifyPixelColor(notFishingCheck.pixelColor, notFishingCheck.pixelCoords) == False)
			Sleep, 1000

		If(verifyPixelColor(invSlot28MonkFish.pixelColor, invSlot28MonkFish.pixelCoords)) {
			moveMouseAndClick(findPixelByColor(depositBoxTileColor)["xy"])
			waitForPixelToBeColor(depositScreenCheck.pixelColor, depositScreenCheck.pixelCoords, 10000)
			moveMouseAndClick(generateCoords(depositFishBounds.lowerBounds, depositFishBounds.upperBounds))
			Sleep, 1000
		}

		While(findPixelByColor(fishingSpotColor)["rc"] != 0)
			Sleep, 1000
		XY := findPixelByColor(fishingSpotColor)["xy"]
		Random, dx, 3, 8
		Random, dy, 3, 8
		XY[1] := XY[1] - dx
		XY[2] := XY[2] + dy
		moveMouseAndClick(XY)
		Sleep, 10000 ; Wait until we're like there and fishing and stuff
	}
}

F1::main()
F2::moveMouse(findPixelByColor(fishingSpotColor)["xy"])

#If
^R::Reload
+^C::ExitApp
