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

;=================================================================================================;

Global unfinishedPotion := [ 0x8AA88B, [ 450, 350 ] ]
Global snapeGrass := [ 0x0D874E, [ 510, 345 ] ]
Global amuletBank := [  ]
Global inventoryPane := [ 0x78281F, [ 1210, 1010 ] ]
Global equipmentPane := [ 0x3D3129, [ 1255, 1025 ] ]
Global amuletEquipped := [ 0x72A64D, [ 1500, 740 ] ]
Global slot01Unfinished := [ 0x99B199, [ 1420, 685 ] ]
Global slot15SnapeGrass := [ 0x010D08, [ 1530, 820 ] ]
Global slot14Prayer := [ 0x49D2A2, [ 1475, 830 ] ]
Global slot14ViewerPrayer := [ 0x32C796, [ 1495, 470 ] ]
Global bankOpen := [ 0x151111, [ 445, 395 ] ]
Global herbPrompt1 := [ 0x57E1AD, [ 340, 970 ] ]
Global herbPrompt2 := [ 0xB1E55C, [ 340, 970 ] ]

Global invSlot01Bounds := [ [ 1405, 660 ], [ 1435, 690 ] ]
Global invSlot15Bounds := [ [ 1515, 800 ], [ 1555, 835 ] ]
Global bankerBounds := [ [ 410, 260 ], [ 460, 380 ] ]
Global depositAllBounds := [ [ 905, 780 ], [ 940, 815 ] ]
Global unfinishedPotionBounds := [ [ 435, 330 ], [ 460, 360 ] ]
Global snapeGrassBounds := [ [ 500, 330 ], [ 525, 355 ] ]
Global amuletBankBounds := [ [ 565, 330 ], [ 585, 355 ] ]

;=================================================================================================;

neededNewNecklace() {
	checkTimeout := 20000
	sleepTime := 100
	totalLoops := checkTimeout / sleepTime

	Loop, %totalLoops% {
		If(verifyPixelColor(slot14ViewerPrayer[1], slot14ViewerPrayer[2]) == True) {
			Return False
		}

		If(verifyPixelColor(amuletEquipped[1], amuletEquipped[2]) == False) {
			; Open bank by clicking on banker
			moveMouseAndClick(generateCoords(bankerBounds[1], bankerBounds[2]))

			; Wait for bank interface
			waitForPixelToBeColor(bankOpen[1], bankOpen[2])

			; Deposit all
			moveMouseAndClick(generateCoords(depositAllBounds[1], depositAllBounds[2]))

			; Withdraw and equip a new amulet
			Send, {Shift Down}
			Sleep, generateSleepTime(473, 655)
			moveMouseAndClick(generateCoords(amuletBankBounds[1], amuletBankBounds[2]))
			Sleep, generateSleepTime()
			moveMouseAndClick(generateCoords(invSlot01Bounds[1], invSlot01Bounds[2]))
			Sleep, generateSleepTime(253, 495)
			Send, {Shift Up}

			; Withdraw more reagents
			moveMouseAndClick(generateCoords(unfinishedPotionBounds[1], unfinishedPotionBounds[2]))
			moveMouseAndClick(generateCoords(snapeGrassBounds[1], snapeGrassBounds[2]))

			; Close bank
			Send, {Esc}
			Sleep, generateSleepTime(774, 1024)

			; Reopen inventory pane
			If(verifyPixelColor(inventoryPane[1], inventoryPane[2]) == False)
				Send, {Esc}

			; Restart loop
			Sleep, generateSleepTime(313, 589)
			Return True
		}

		Sleep, %sleepTime%
	}
}

main() {
	Loop {
		; Switch to inventory pane
		If(verifyPixelColor(inventoryPane[1], inventoryPane[2]) == False)
			Send, {Esc}

		; Use unfinished potion on snape grass
		moveMouseAndClick(generateCoords(invSlot01Bounds[1], invSlot01Bounds[2]))
		moveMouseAndClick(generateCoords(invSlot15Bounds[1], invSlot15Bounds[2]))

		; Wait for heblore prompt to appear, then press space
		Sleep, generateSleepTime(777, 1024)
		Send, {Space}
		Sleep, generateSleepTime(243, 557)

		; Switch to equipment screen to monitor amulet
		If(verifyPixelColor(equipmentPane[1], equipmentPane[2]) == False)
			Send, {F4}
		Sleep, generateSleepTime()

		If(neededNewNecklace() == True)
			Continue

		/*
		; Wait for potion mixing to finish
		waitForPixelToBeColor(slot14ViewerPrayer[1], slot14ViewerPrayer[2], 20000)

		; If our amulet was exhausted:
		If(verifyPixelColor(amuletEquipped[1], amuletEquipped[2]) == False) {
			; Open bank by clicking on banker
			moveMouseAndClick(generateCoords(bankerBounds[1], bankerBounds[2]))

			; Wait for bank interface
			waitForPixelToBeColor(bankOpen[1], bankOpen[2])

			; Deposit all
			moveMouseAndClick(generateCoords(depositAllBounds[1], depositAllBounds[2]))

			; Withdraw and equip a new amulet
			Send, {Shift Down}
			Sleep, generateSleepTime(473, 655)
			moveMouseAndClick(generateCoords(amuletBankBounds[1], amuletBankBounds[2]))
			Sleep, generateSleepTime()
			moveMouseAndClick(generateCoords(invSlot01Bounds[1], invSlot01Bounds[2]))
			Sleep, generateSleepTime(253, 495)
			Send, {Shift Up}

			; Withdraw more reagents
			moveMouseAndClick(generateCoords(unfinishedPotionBounds[1], unfinishedPotionBounds[2]))
			moveMouseAndClick(generateCoords(snapeGrassBounds[1], snapeGrassBounds[2]))

			; Close bank
			Send, {Esc}
			Sleep, generateSleepTime(774, 1024)

			; Reopen inventory pane
			If(verifyPixelColor(inventoryPane[1], inventoryPane[2]) == False)
				Send, {Esc}

			; Restart loop
			Sleep, generateSleepTime(313, 589)
			Continue
		}
		*/

		; Open inventory pane
		If(verifyPixelColor(inventoryPane[1], inventoryPane[2]) == False)
			Send, {Esc}
		Sleep, generateSleepTime()

		; Open bank
		moveMouseAndClick(generateCoords(bankerBounds[1], bankerBounds[2]))
		waitForPixelToBeColor(bankOpen[1], bankOpen[2])
		Sleep, generateSleepTime()

		; Deposit all
		moveMouseAndClick(generateCoords(depositAllBounds[1], depositAllBounds[2]))

		; Withdraw more reagents
		moveMouseAndClick(generateCoords(unfinishedPotionBounds[1], unfinishedPotionBounds[2]))
		moveMouseAndClick(generateCoords(snapeGrassBounds[1], snapeGrassBounds[2]))
		waitForPixelToBeColor(slot15SnapeGrass[1], slot15SnapeGrass[2])

		; Close bank
		Send, {Esc}
		Sleep, generateSleepTime(474, 624)
	}
}

;=================================================================================================;

F1::main()

#If
^R::Reload
+^C::ExitApp
