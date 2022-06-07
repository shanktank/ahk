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

;; Config: camera facing west, at zenith, fully zoomed in

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

main() {
	Loop {
		ToolTip % "Waiting for chest to reset...", 0, 0
		While(chestLooted1.verifyPixelColor() || chestLooted2.verifyPixelColor()) {
			Sleep, UIObject.generateSleepTime(132, 217)
		}
		Sleep, UIObject.generateSleepTime(84, 114)

		ToolTip % "Looting chest...", 0, 0
		Random, clicks, 2, 3
		Loop, %clicks% {
			UIObject.doClick(generateSleepTime(79, 143))
		}
		Sleep, 9999
	}
}

;; ============================================================================================================================================================ ;;
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

;; TODO: possibly specify plugin on/off configuration to remove need for two color checks
Global chestLooted1 := New PixelColorLocation(0x85190D, [ 848, 216 ]) ; Color if not hovered or whatever
Global chestLooted2 := New PixelColorLocation(0xCD0000, [ 848, 216 ])

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::main()
F2::UIObject.moveMouse([ chestLooted1.pixelCoords[1], chestLooted1.pixelCoords[2] ])

#If
^R::Reload
+^C::ExitApp
