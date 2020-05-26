#Include "../../Libraries/RandomBezier.ahk"

#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetTitleMatchMode, RegEx
#IfWinActive, RuneLite

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;=================================================================================================;

Class Target {
	targetName := ""

	targetCoordBounds := [ ]
	targetSleepBounds := [ ]
	targetSpeedBounds := [ ]
	targetColorConfirmation := [ ]

	clickCoords := []
	sleepTime := 0
	mouseSpeed := 0

	__New(name, coordBounds, sleepBounds, speedBounds, colorConfirmation := 0) {
		This.targetName := name
		This.targetCoordBounds := coordBounds
		This.targetSleepBounds := sleepBounds
		This.targetSpeedBounds := speedBounds
		This.targetColorConfirmation := colorConfirmation

		This.generateValues()
	}

	generateValues() {
		Random, coordX, This.targetCoordBounds[3], This.targetCoordBounds[4]
		Random, coordY, This.targetCoordBounds[1], This.targetCoordBounds[2]
		This.clickCoords := [ coordX, coordY ]
		Random, sleepTime, This.targetSleepBounds[1], This.targetSleepBounds[2]
		This.sleepTime := sleepTime
		Random, mouseSpeed, This.targetSpeedBounds[1], This.targetSpeedBounds[2]
		This.mouseSpeed := mouseSpeed
	}

	display() {
		MsgBox % This.clickCoords[1] ", " This.clickCoords[2] " " This.sleepTime " " This.mouseSpeed
	}
}

targetList := []
targetList.Push(New Target("Seaweed", [ 283, 298, 818, 843 ],   [ 97, 143 ],  [ 298, 401 ]))
targetList.Push(New Target("Sand",    [ 283, 298, 869, 886 ],   [ 172, 239 ], [ 133, 198 ]))
targetList.Push(New Target("Spell",   [ 812, 828, 1607, 1616 ], [ 123, 321 ], [ 365, 418 ]))
targetList.Push(New Target("Banker",  [ 425, 552, 664, 687 ],   [ 329, 455 ], [ 417, 501 ]))
targetList.Push(New Target("Deposit", [ 816, 843, 883, 910 ],   [ 232, 772 ], [ 119, 256 ]))
for i2, e2 in targetList {
	e2.display()
}

;=================================================================================================;

Class ClickBounds {
	; Elements: North, South, West, East
	Static seaweedCoordBounds := [ 283, 298, 818, 843 ]
	Static sandCoordBounds    := [ 283, 298, 869, 886 ]
	Static spellCoordBounds   := [ 812, 828, 1607, 1616 ]
	Static bankerCoordBounds  := [ 425, 552, 664, 687 ]
	Static depositCoordBounds := [ 816, 843, 883, 910 ]

	; Lower and upper bounds for random sleep times
	Static seaweedSleepBounds := [ 97, 143 ]
    Static sandSleepBounds    := [ 172, 239 ]
    Static spellSleepBounds   := [ 123, 321 ]
    Static bankerSleepBounds  := [ 329, 455 ]
    Static depositSleepBounds := [ 232, 772 ]

	; Lower and upper bounds for mouse movement speed
	Static seaweedSpeedBounds := [ 298, 401 ]
    Static sandSpeedBounds    := [ 133, 198 ]
    Static spellSpeedBounds   := [ 365, 418 ]
    Static bankerSpeedBounds  := [ 417, 501 ]
    Static depositSpeedBounds := [ 119, 256 ]

	; Coords and colors
	Static spellBookColor := [ 1417, 1019, 0x75281E ]
	Static spellCastColor := [ 1611, 817, 0xD00C2E ]
	;Static bankOpenColor  := [ 710, 510, 0x473D32 ]
	Static bankOpenColor  := [ 573, 370, 0x494034 ]

	clickQueue := []
    sleepQueue := []
	speedQueue := []

	__New() {
		This.clickQueue := [ This.seaweedCoordBounds, This.sandCoordBounds, This.spellCoordBounds, This.bankerCoordBounds, This.depositCoordBounds ]
        This.sleepQueue := [ This.seaweedSleepBounds, This.sandSleepBounds, This.spellSleepBounds, This.bankerSleepBounds, This.depositSleepBounds ]
		This.speedQueue := [ This.seaweedSpeedBounds, This.sandSpeedBounds, This.spellSpeedBounds, This.bankerSpeedBounds, This.depositSpeedBounds ]
	}

	generateCoords(targets) {
		clickCoords := []

		For index, element In targets {
			Random, X, element[3], element[4]
			Random, Y, element[1], element[2]
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

		This.doClick(Array(itemCoords[1]+menuCoordsY, itemCoords[2]+menuCoordsX), taskSleep+sleepBonus, "T"(mouseSpeed+speedBonus)" OT5 OB5 OL5 OR5 P2-4")
	}

	pressAndSleep(lowerBound, upperBound, buttonInput := 0) {
		If(buttonInput)
			Send, {%buttonInput%}
		Random, sleepFor, %lowerBound%, %upperBound%
		Sleep, sleepFor
	}

	doClick(clickCoords, sleepFor, optString, numClicks := 1, rightClick := False, simpleMove := False) {
		If(simpleMove == False) {
			MouseGetPos, px, py
			RandomBezier(px, py, clickCoords[1], clickCoords[2], optString)
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

    doCycle() {
		Loop {
			; Generate random numbers for our various operations
			coords := This.generateCoords(This.clickQueue)
			sleeps := This.generateSleeps(This.sleepQueue)
			speeds := This.generateSleeps(This.speedQueue)

			; Withdraw seaweed and sand buckets
			This.doClick(coords[1], sleeps[1], "T"speeds[1]" OT38 OB40 OL40 OR39 P2-4", 3)
			This.doClick(coords[2], sleeps[2], "T"speeds[2]" OT5 OB5 OL5 OR5 P2-4", , True)

			; Offset right click menu to withdraw x because shift click works like shit
			This.handleDropdown(coords[2], sleeps[2], speeds[2])

			; Close bank
			This.pressAndSleep(99, 149, "Esc")

			; Check if spell book is open
			While This.checkColor(This.spellBookColor) == False {
				This.pressAndSleep(243, 364, "F3")
				If(A_Index > 5)
					Return
			}

			; Check if spell can be case
			If(This.checkColor(This.spellCastColor) == False)
				Return

			; Cast Superglass Make then click on banker
			This.doClick(coords[3], sleeps[3], "T"speeds[3]" OT47 OB44 OL42 OR43 P2-4")
			This.doClick(coords[4], sleeps[4], "T"speeds[4]" OT41 OB45 OL48 OR50 P2-4")

			; Spam click the banker until the bank is open, and take a short pause before continuing
			While This.checkColor(This.bankOpenColor) == False {
				This.pressAndSleep(169, 232, "Click")
			}
			This.pressAndSleep(124, 219)

			; Deposit all
			This.doClick(coords[5], sleeps[5], "t"speeds[5]" OT27 OB24 OL25 OR27 P2-4", 2)
		}
    }
}

;=================================================================================================;

displayCoords(coords) {
    ToolTipText := ""

    For index, element in coords {
        ToolTipText := % ToolTipText "\n" element[1] ", " element[2]
    }

    StringTrimLeft, ToolTipText, ToolTipText, 1

    ToolTip, %ToolTipText%, 0, 0
}

;=================================================================================================;

cb := New ClickBounds()

;=================================================================================================;

F1::cb.doCycle()

^R::Reload
^C::ExitApp

;=================================================================================================;
;== End of current version =======================================================================;
;=================================================================================================;



;=================================================================================================;
;== Old version ==================================================================================;
;=================================================================================================;

/*#Include "../../Libraries/RandomBezier.ahk"

#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetTitleMatchMode, RegEx
#IfWinActive, RuneLite

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;=================================================================================================;

Class ClickBounds {
	; Elements: North, South, West, East
	Static seaweedCoordBounds := [ 283, 298, 818, 843 ]
	Static sandCoordBounds    := [ 283, 298, 869, 886 ]
	Static spellCoordBounds   := [ 812, 828, 1607, 1616 ]
	;Static bankerCoordBounds  := [ 425, 552, 664, 687 ]
	Static bankerCoordBounds  := [ 406, 672, 470, 543 ]
	Static depositCoordBounds := [ 816, 843, 883, 910 ]

	; Lower and upper bounds for random sleep times
	Static seaweedSleepBounds := [ 97, 143 ]
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
	Static spellBookColor := [ 1417, 1019, 0x75281E ]
	Static spellCastColor := [ 1611, 817, 0xD00C2E ]
	;Static bankOpenColor  := [ 710, 510, 0x473D32 ]
	Static bankOpenColor  := [ 573, 370, 0x494034 ]

	clickQueue := []
    sleepQueue := []
	speedQueue := []

	__New() {
		This.clickQueue := [ This.seaweedCoordBounds, This.sandCoordBounds, This.spellCoordBounds, This.bankerCoordBounds, This.depositCoordBounds ]
        This.sleepQueue := [ This.seaweedSleepBounds, This.sandSleepBounds, This.spellSleepBounds, This.bankerSleepBounds, This.depositSleepBounds ]
		This.speedQueue := [ This.seaweedSpeedBounds, This.sandSpeedBounds, This.spellSpeedBounds, This.bankerSpeedBounds, This.depositSpeedBounds ]
	}

	generateCoords(targets) {
		clickCoords := []

		For index, element In targets {
			Random, X, element[3], element[4]
			Random, Y, element[1], element[2]
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
			This.doClick(coords[2], sleeps[2], "T"speeds[2]" OT5 OB5 OL5 OR5 P2-4", , True)

			; Offset right click menu to withdraw x because shift click works like shit
			This.handleDropdown(coords[2], sleeps[2], speeds[2])

			; Close bank
			This.pressAndSleep(99, 149, "Esc")

			; Check if spell book is open
			While This.checkColor(This.spellBookColor) == False {
				This.pressAndSleep(243, 364, "F3")
				If(A_Index > 5)
					Return
			}

			; Check if spell can be case
			If(This.checkColor(This.spellCastColor) == False)
				Return

			; Cast Superglass Make then click on banker
			This.doClick(coords[3], sleeps[3], "T"speeds[3]" OT47 OB44 OL42 OR43 P2-4")
			This.doClick(coords[4], sleeps[4], "T"speeds[4]" OT41 OB45 OL48 OR50 P2-4")

			; Spam click the banker until the bank is open, and take a short pause before continuing
			While This.checkColor(This.bankOpenColor) == False {
				This.pressAndSleep(169, 232, "Click")
				If(A_Index > 25)
					Return
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
		;Sleep, 1000
		Return

		Loop, 10 {
			Random, X, coordBounds[3], coordBounds[4]
			Random, Y, coordBounds[1], coordBounds[2]
			MouseMove, %X%, %Y%
			Sleep, 1000
		}
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

F1::
Ctrl & Alt::
	cb.startCycle()
	Return

F4::
	cb.testCoordBounds(cb.bankerCoordBounds)
	Return

^R::Reload
^C::ExitApp
*/