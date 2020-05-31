﻿#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

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

;#IfWinActive ^(RuneLite|OpenOSRS)$

Global knightTabardColor := 0x6B18BF
Global knightStarColor := 0x97119F
Global miniSearchArea := 40

Global coinPouch := [ 0x58513C, [ 1440, 320 ] ]
Global coinPouchInv := [ 0x58513C, [ 1420, 680 ] ]
Global coinPouchCheck := [ 0xF3F207, 1428, 302 ]
Global goldStack := [ 0xC7A218, [ 1495, 320 ] ]
Global healthCheck := [ 0x5B0301, [ 1414, 122 ] ]

Global wineColor := 0xA7433C
Global invFoodBounds := [ [ 1405, 750 ], [ 1615, 985 ] ]

Global necklaceColor := 0xC2C1A1
Global invNecklaceBounds := [ [ 1400, 655 ], [ 1615, 745 ] ]

Global stunCheck := [ 0xECB900, [ 132, 69 ] ]

Global invViewerCoinPouchesFull := [ 0xC1BD0B, [ 1429, 301 ] ]

Global equippedNecklace := [ 0xC7C1B6, [ 1495, 735 ] ]

checkHitpoints() {
	If(verifyPixelColor(healthCheck[1], healthCheck[2]) == True) {
		Return False
	} Else {
		While(verifyPixelColor(healthCheck[1], healthCheck[2]) == False) {
			Coords := findPixelByColor(wineColor, invFoodBounds[1], invFoodBounds[2])
			If(Coords["rc"] = 0) {
				moveMouseAndClick(Coords["xy"])
				Sleep, 500
			} Else {
				MsgBox % "out of food"
				Reload
			}
		}
		Return True
	}
}

openCoinPouches() {
	;If(verifyPixelColor(coinPouch[1], coinPouch[2])) {
	If(verifyPixelColor(coinPouchInv[1], coinPouchInv[2])) {
		moveMouseAndClick(coinPouchInv[2])
		While(verifyPixelColor(coinPouch[1], coinPouch[2])) {
			doClick()
		}
	}
}

shouldEquipNecklace() {

}

shouldOpenCoinPouches() {
	If(verifyPixelColor(stunCheck[1], stunCheck[2]) || verifyPixelColor(invViewerCoinPouchesFull[1], invViewerCoinPouchesFull[2])) {
		openCoinPouches()
	}
}

main() {
	Loop {
		; Test 1
		/*
		If(checkHitpoints() || shouldOpenCoinPouches())
			Continue
		If(Mod(A_Index, 100) == 0) {
			openCoinPouches()
			Continue
		}
		*/

		; Test 2
		/*
		Send, {F4}
		Sleep, 250
		If(verifyPixelColor(equippedNecklace[1], equippedNecklace[2] == False)) {
			Send, {Esc}
			Sleep, 234
			moveMouseAndClick(findPixelByColor(0xC2C1A1, [ 1400, 655 ], [ 1615, 745 ])["xy"])
			Sleep, 333
			Send, {F4}
			Sleep, 321
		}
		Send, {Esc}
		Reload
		*/

		If(Mod(A_Index, 5) == 0) {
			openCoinPouches()
			Continue
		}

		; Find the Knight
		FindBy := knightStarColor
		Coords := findPixelByColor(FindBy, [ 570, 250 ], [ 1260, 800 ])
		If(Coords["rc"] != 0) {
			FindBy := knightTabardColor
			Coords := findPixelByColor(FindBy, [ 570, 250 ], [ 1260, 800 ])
		} If(Coords["rc"] != 0) {
			Continue
		}

		; Thieve until he moves
		XY := Coords["xy"]
		moveMouseAndClick(XY, 1)
		lowerBounds := [ XY[1] - miniSearchArea, XY[2] - miniSearchArea ]
		upperBounds := [ XY[1] + miniSearchArea, XY[2] + miniSearchArea ]
		While(findPixelByColor(FindBy, lowerBounds, upperBounds)["rc"] == 0) {
			moveMouseAndClick(XY, 1)
			doClick()
			If(checkHitpoints() || shouldOpenCoinPouches())
				Continue
			If(Mod(A_Index, 25) == 0) {
				openCoinPouches()
				Continue
			}
		}
	}
}

F1::main()

#If
^R::Reload
+^C::ExitApp
