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

;=================================================================================================;

Class ClickBounds {
	; Elements: North, South, West, East
	Static seaweedCoordBounds := [ [  434, 136 ], [  465, 163 ] ]
	Static sandCoordBounds    := [ [  504, 135 ], [  528, 164 ] ]
	Static spellCoordBounds   := [ [ 1404, 670 ], [ 1419, 691 ] ]
	Static bankerCoordBounds  := [ [  830, 131 ], [  918, 389 ] ]
	Static depositCoordBounds := [ [  903, 776 ], [  938, 815 ] ]

	; Lower and upper bounds for random sleep times
	Static seaweedSleepBounds := [  97, 143 ]
    Static sandSleepBounds    := [ 172, 239 ]
    Static spellSleepBounds   := [ 123, 321 ]
    Static bankerSleepBounds  := [ 329, 455 ]
    Static depositSleepBounds := [ 232, 278 ]

	Static seaweedSpeedBounds := [ 389, 462 ]
    Static sandSpeedBounds    := [ 201, 286 ]
    Static spellSpeedBounds   := [ 365, 418 ]
    Static bankerSpeedBounds  := [ 417, 501 ]
    Static depositSpeedBounds := [ 275, 369 ]

	; Coords and colors
	Static spellBookColor     := [ 1345, 1010, 0x71261D ]
	Static spellCastColor     := [ 1410,  675, 0xD00D2F ]
	Static bankOpenColor      := [  450,  148, 0x096744 ]

	clickQueue := []
    sleepQueue := []
	speedQueue := []

	__New() {
		This.clickQueue := [ This.seaweedCoordBounds, This.sandCoordBounds, This.spellCoordBounds, This.bankerCoordBounds, This.depositCoordBounds ]
        This.sleepQueue := [ This.seaweedSleepBounds, This.sandSleepBounds, This.spellSleepBounds, This.bankerSleepBounds, This.depositSleepBounds ]
		This.speedQueue := [ This.seaweedSpeedBounds, This.sandSpeedBounds, This.spellSpeedBounds, This.bankerSpeedBounds, This.depositSpeedBounds ]
	}

	generateCoords(targets) {
		clickCoords := [ ]

		For index, element In targets {
			Random, X, element[1][1], element[2][1]
			Random, Y, element[1][2], element[2][2]
			clickCoords.Push(Array(X, Y))
		}

		Return clickCoords
	}

    generateSleeps(targets) {
		sleepTimes := []
		For index, element In targets {
			Random, sleepTime, element[1], element[2]
			sleepTimes.Push(sleepTime)
		}
		Return sleepTimes
    }

	checkColor(target) {
		PixelGetColor, pixelColor, target[1], target[2], RGB
		Return pixelColor == target[3]
	}

	handleDropdown(itemCoords, taskSleep, mouseSpeed) {
		Random, menuCoordsX, 64, 78
		Random, menuCoordsY, -100, 100
		Random, sleepBonus, 10, 25
		Random, speedBonus, 20, 30

		This.doClick(Array(itemCoords[1] + menuCoordsY, itemCoords[2] + menuCoordsX), taskSleep + sleepBonus, "T"(mouseSpeed + speedBonus)" OT5 OB5 OL5 OR5 P2-4")
	}

	pressAndSleep(lowerBound, upperBound, buttonInput := 0) {
		If(buttonInput)
			Send, {%buttonInput%}
		Random, sleepFor, %lowerBound%, %upperBound%
		Sleep, sleepFor
	}

	doClick(clickCoords, sleepFor, optString, numClicks := 1, rightClick := False, simpleMove := False) {
		Random, randomNum, 1, 1000
		If(randomNum == 123) {
			Random, extraSleep, 2143, 7281
			ToolTip, Rando extra sleeping!
			Sleep, extraSleep
			ToolTip
		}

		If(simpleMove == False) {
			RandomBezier(clickCoords[1], clickCoords[2], optString)
		} Else {
			Random, moveSpeed, 5, 15
			MouseMove, clickCoords[1], clickCoords[2], moveSpeed
		}

		If(rightClick == True) {
			Click, Right
		} Else {
			Loop %numClicks% {
				Random, preClick, 52, 163
				Sleep, preClick
				Click
			}
		}

        Sleep, sleepFor
    }

    startCycle() {
		Loop {
			; Generate random numbers for our various operations
			coords := This.generateCoords(This.clickQueue)
			sleeps := This.generateSleeps(This.sleepQueue)
			speeds := This.generateSleeps(This.speedQueue)

			; Withdraw seaweed and sand buckets
			This.doClick(coords[1], sleeps[1], "T"speeds[1]" OT38 OB40 OL40 OR39 P2-4", 3)
			This.doClick(coords[2], sleeps[2], "T"speeds[2]" OT5 OB5 OL5 OR5 P2-4")

			; Close bank
			This.pressAndSleep(99, 149, "Esc")

			; Check if spell book is open
			While This.checkColor(This.spellBookColor) == False {
				This.pressAndSleep(243, 364, "F3")
				If(A_Index > 5) {
					Return
				}
			}

			; Check if spell can be cast
			If(This.checkColor(This.spellCastColor) == False) {
				Return
			}

			; Cast spell then click on banker
			This.doClick(coords[3], sleeps[3], "T"speeds[3]" OT47 OB44 OL42 OR43 P2-4")
			This.doClick(coords[4], sleeps[4], "T"speeds[4]" OT41 OB45 OL48 OR50 P2-4")

			; Spam click the banker until the bank is open, and take a short pause before continuing
			While(This.checkColor(This.bankOpenColor) == False) {
				This.pressAndSleep(169, 232, "Click")
				If(A_Index > 25) {
					Return
				}
			}
			This.pressAndSleep(124, 219)

			; Deposit all
			This.doClick(coords[5], sleeps[5], "t"speeds[5]" OT27 OB24 OL25 OR27 P2-3")
			Random, 25, 75
			Click
		}
    }

	testCoordBounds(coordBounds) {
		MouseMove, coordBounds[3], coordBounds[1], 20
		Sleep, 1000
		MouseMove, coordBounds[4], coordBounds[1], 20
		Sleep, 1000
		MouseMove, coordBounds[3], coordBounds[2], 20
		Sleep, 1000
		MouseMove, coordBounds[4], coordBounds[2], 20
		Sleep, 1000
		MouseMove, coordBounds[3], coordBounds[1], 20
	}

	displayCoords(coords) {
		ToolTipText := ""
		For index, element in coords {
			ToolTipText := % ToolTipText "\n" element[1] ", " element[2]
		}
		StringTrimLeft, ToolTipText, ToolTipText, 1
		ToolTip, %ToolTipText%, 0, 0
	}
}

;=================================================================================================;

cb := New ClickBounds()

;=================================================================================================;

F1::cb.startCycle()
Ctrl & Alt::cb.startCycle()

^R::Reload
^C::ExitApp
