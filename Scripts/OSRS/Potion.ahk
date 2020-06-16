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

Global unfinishedPotion			:= [ 0x8AA88B, [  450,  350 ] ]
Global snapeGrass				:= [ 0x0D874E, [  510,  345 ] ]
Global amuletBank				:= [ 0x000000, [    0,    0 ] ]
Global inventoryPane			:= [ 0x78281F, [ 1210, 1010 ] ]
Global equipmentPane			:= [ 0x3D3129, [ 1255, 1025 ] ]
Global amuletEquipped			:= [ 0x72A64D, [ 1500,  740 ] ]
Global slot01Unfinished			:= [ 0x99B199, [ 1420,  685 ] ]
Global slot01Amulet				:= [ 0x72A64D, [ 1415,  690 ] ]
Global slot15SnapeGrass			:= [ 0x010D08, [ 1530,  820 ] ]
Global slot14Prayer				:= [ 0x49D2A2, [ 1475,  830 ] ]
Global slot14ViewerPrayer3		:= [ 0x32C796, [ 1495,  470 ] ]
Global slot14ViewerPrayer4		:= [ 0x30BE8F, [ 1495,  470 ] ]
Global slot28ViewerSnapeGrass	:= [ 0x0D874E, [ 1603,  608 ] ]
Global bankOpenCheck			:= [ 0x151111, [  445,  395 ] ]
Global herbPrompt				:= [ 0x5CE5B1, [  340,  970 ] ]

Global invSlot01Bounds			:= [ [ 1405, 660 ], [ 1435, 690 ] ]
Global invSlot14Bounds			:= [ [ 1465, 805 ], [ 1490, 835 ] ]
Global invSlot15Bounds			:= [ [ 1515, 800 ], [ 1555, 835 ] ]
Global bankerBounds				:= [ [  410, 260 ], [  460, 380 ] ]
Global depositAllBounds			:= [ [  905, 780 ], [  940, 815 ] ]
Global unfinishedPotionBounds	:= [ [  435, 330 ], [  460, 360 ] ]
Global snapeGrassBounds			:= [ [  500, 330 ], [  525, 355 ] ]
Global amuletBankBounds			:= [ [  565, 330 ], [  585, 355 ] ]

;=================================================================================================;

openInventoryPane() {
	If(verifyPixelColor(inventoryPane[1], inventoryPane[2]) == False)
		inputKeyAndSleep("{Esc}", generateSleepTime())
}

openEquipmentPane() {
	If(verifyPixelColor(equipmentPane[1], equipmentPane[2]) == False)
		inputKeyAndSleep("{F4}", generateSleepTime())
}

checkNecklace() {
	checkTimeout := 20000
	sleepTime    := 100
	totalLoops   := checkTimeout / sleepTime

	openEquipmentPane()

	Loop, %totalLoops% {
		; Return early if finished making potions
		If(verifyPixelColor(slot28ViewerSnapeGrass[1], slot28ViewerSnapeGrass[2]) == False)
			Return False

		; Withdraw new necklace if needed and restart loop
		If(verifyPixelColor(amuletEquipped[1], amuletEquipped[2]) == False) {
			doBank(generateSleepTime(213, 389), True)
			Return True
		}

		Sleep, %sleepTime%
	}
}

doHerblore() {
	; Switch to inventory pane
	openInventoryPane()

	; If first inventory item isn't unfinished potion, rebank
	While(verifyPixelColor(slot01Unfinished[1], slot01Unfinished[2]) == False) {
		doBank()
		If(A_Index > 3) {
			MsgBox % "Can't seem to withdraw the right shit"
			Reload
		}
	}

	; Use unfinished potion on snape grass
	moveMouseAndClick(generateCoords(invSlot14Bounds[1], invSlot14Bounds[2]))
	moveMouseAndClick(generateCoords(invSlot15Bounds[1], invSlot15Bounds[2]))

	; Wait for heblore prompt to appear, then press space
	waitForPixelToBeColor(herbPrompt[1], herbPrompt[2])
	inputKeyAndSleep("{Space}", generateSleepTime(243, 557))

	; Hover banker while waiting for potion mixing to finish
	moveMouse(generateCoords(bankerBounds[1], bankerBounds[2]))
}

doBank(sleepFor := 0, getAmulet := False) {
	; Open bank
	Click
	waitForPixelToBeColor(bankOpenCheck[1], bankOpenCheck[2])
	Sleep, generateSleepTime()

	; Deposit all
	moveMouseAndClick(generateCoords(depositAllBounds[1], depositAllBounds[2]))

	; Withdraw and equip a new amulet
	If(getAmulet == True) {
		inputKeyAndSleep("{Shift Down}", generateSleepTime(473, 655))
		moveMouseAndClick(generateCoords(amuletBankBounds[1], amuletBankBounds[2]),, generateSleepTime(172, 316))
		moveMouseAndClick(generateCoords(invSlot01Bounds[1], invSlot01Bounds[2]),, generateSleepTime(737, 944))
		While(verifyPixelColor(slot01Amulet[1], slot01Amulet[2]))
			doClick(generateSleepTime())
		inputKeyAndSleep("{Shift Up}", generateSleepTime())
	}

	; Withdraw more reagents
	moveMouseAndClick(generateCoords(unfinishedPotionBounds[1], unfinishedPotionBounds[2]))
	moveMouseAndClick(generateCoords(snapeGrassBounds[1], snapeGrassBounds[2]))
	waitForPixelToBeColor(slot15SnapeGrass[1], slot15SnapeGrass[2])

	; Close bank
	Send, {Esc}
	waitForPixelToNotBeColor(bankOpenCheck[1], bankOpenCheck[2])
	Sleep, generateSleepTime()

	openInventoryPane()

	Sleep, sleepFor
}

main() {
	Loop {
		doHerblore()

		If(checkNecklace())
			Continue

		doBank()
	}
}

;=================================================================================================;

F1::main()
F2::traceCoordsBounds(bankerBounds[1], bankerBounds[2])

;=================================================================================================;

#If
^R::Reload
+^C::ExitApp
