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

; Config:
;  Entity Hider and Inventory Viewer active
;  Menu Entry Swapper set to prioritize "walk here" over everything but pickpocket
;  Interface pane open to Worn Equipment
;  Camera zoom: 533/1004
;  World: 378
;  First slot: Coin Pouch
;  Second slot: Coins
;  Third through eighth slots: Dodgy Necklace
;  Ninth through last slots: Jug of Wine

Global knightTabardColor := 0x6B18BF
Global knightStarColor := 0x97119F
Global miniSearchArea := 40

Global coinPouch := [ 0x58513C, [ 1440, 320 ] ]
Global coinPouchInv := [ 0x58513C, [ 1420, 680 ] ]
Global coinPouchCheck := [ 0xF3F207, 1428, 302 ]
Global goldStack := [ 0xC7A218, [ 1495, 320 ] ]
Global healthCheck := [ 0x5B0301, [ 1414, 122 ] ]

Global coinPouchBounds := [ [ 1410, 665 ], [ 1430, 685 ] ]

Global wineColor := 0xA7433C
Global invFoodBounds := [ [ 1405, 750 ], [ 1615, 985 ] ]
Global wineDrinkPlayRoom := [ [ -8, 8 ], [ 0, 20 ] ]

Global necklaceColor := 0xC2C1A1
Global invNecklaceBounds := [ [ 1400, 655 ], [ 1615, 745 ] ]

Global stunCheck := [ 0xECB900, [ 132, 69 ] ]

Global invViewerCoinPouchesFull := [ 0xC1BD0B, [ 1429, 301 ] ]
Global invViewerCoinPouches := [ 0x58513C, [ 1440, 325 ] ]

Global freshNecklace := [ 0xC3C1BD [ 1580, 712 ] ]
Global equippedNecklace := [ 0xC7C1B6, [ 1495, 735 ] ]

Global inventoryOpen := [ 0x35110E, [ 1240, 1010 ] ]

getKnightCoords(ByRef FindBy, ByRef Coords) {
	FindBy := knightStarColor
	Coords := findPixelByColor(FindBy, [ 570, 250 ], [ 1260, 800 ])
	If(Coords["rc"] != 0) {
		FindBy := knightTabardColor
		Coords := findPixelByColor(FindBy, [ 570, 250 ], [ 1260, 800 ])
	}
}

checkHitpoints() {
	If(verifyPixelColor(healthCheck[1], healthCheck[2]) == True) {
		Return False
	} Else {
		Send, {Esc}
		Sleep, 150
		While(verifyPixelColor(healthCheck[1], healthCheck[2]) == False) {
			Coords := findPixelByColor(wineColor, invFoodBounds[1], invFoodBounds[2])
			If(Coords["rc"] = 0) {
				XY := Coords["xy"]
				Random, XR, wineDrinkPlayRoom[1][1], wineDrinkPlayRoom[1][2]
				Random, YR, wineDrinkPlayRoom[2][1], wineDrinkPlayRoom[2][2]
				moveMouseAndClick([ XY[1] + XR, XY[2] + YR ])
				Sleep, 500
			} Else {
				MsgBox % "out of food"
				Reload
			}
		}
		Send, {F4}
		Return True
	}
}

; TODO: Bug: when cash stack gets to like 127k, this operation will click the money stack instead of a necklace
checkNecklace() {
	If(verifyPixelColor(equippedNecklace[1], equippedNecklace[2]) == False) {
		Send, {Esc}
		Sleep, 150
		Coords := findPixelByColor(necklaceColor, invNecklaceBounds[1], invNecklaceBounds[2])
		If(Coords["rc"] = 0) {
			moveMouseAndClick(Coords["xy"])
			Sleep, 500
		}
		Send, {F4}
		Return True
	}
	Return False
}

openCoinPouches() {
	;If(verifyPixelColor(coinPouch[1], coinPouch[2])) {
	;If(verifyPixelColor(coinPouchInv[1], coinPouchInv[2])) {
	If(verifyPixelColor(invViewerCoinPouches[1], invViewerCoinPouches[2])) {
		Send, {Esc}
		Sleep, 150
		moveMouseAndClick(generateCoords(coinPouchBounds[1], coinPouchBounds[2]))
		While(verifyPixelColor(coinPouch[1], coinPouch[2])) {
			doClick()
		}
		Send, {F4}
		Return True
	}
	Return False
}

shouldOpenCoinPouches() {
	If(verifyPixelColor(stunCheck[1], stunCheck[2]) || verifyPixelColor(invViewerCoinPouchesFull[1], invViewerCoinPouchesFull[2])) {
	;If(verifyPixelColor(stunCheck[1], stunCheck[2]) || verifyPixelColor(invViewerCoinPouches[1], invViewerCoinPouches[2])) {
		Return openCoinPouches()
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
		/*
		FindBy := knightStarColor
		Coords := findPixelByColor(FindBy, [ 570, 250 ], [ 1260, 800 ])
		If(Coords["rc"] != 0) {
			FindBy := knightTabardColor
			Coords := findPixelByColor(FindBy, [ 570, 250 ], [ 1260, 800 ])
		} If(Coords["rc"] != 0) {
			Continue
		}
		*/
		FindBy := ""
		Coords := ""
		getKnightCoords(FindBy, Coords)
		If(Coords["rc"] != 0)
			Continue

		; Thieve until he moves
		rc := True
		XY := Coords["xy"]
		moveMouseAndClick(XY)
		lowerBounds := [ XY[1] - miniSearchArea, XY[2] - miniSearchArea ]
		upperBounds := [ XY[1] + miniSearchArea, XY[2] + miniSearchArea ]
		;moveMouse(XY, 2)
		;While(findPixelByColor(FindBy, lowerBounds, upperBounds)["rc"] == 0 || rc == True) {
		;While(findPixelByColor(FindBy, lowerBounds, upperBounds)["rc"] == 0 && rc == True) {
		While(rc == True) {
			;moveMouseAndClick(XY, 2)
			rc := doClick(, "Interact")
			If(checkHitpoints() || shouldOpenCoinPouches() || checkNecklace()) {
				getKnightCoords(FindBy, Coords)
				If(Coords["rc"] != 0) {
					Break
				} Else {
					XY := Coords["xy"]
					moveMouseAndClick(XY, 2)
					Continue
				}
			} Else If(Mod(A_Index, 75) == 0) {
				openCoinPouches()
				getKnightCoords(FindBy, Coords)
				If(Coords["rc"] != 0) {
					Break
				} Else {
					XY := Coords["xy"]
					moveMouseAndClick(XY, 2)
					Continue
				}
			}
		}
	}
}

F1::main()

#If
^R::Reload
+^C::ExitApp
