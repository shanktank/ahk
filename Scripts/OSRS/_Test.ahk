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

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

main() {
	RCXY := flaxPixelColorLocation.proximitySearch()
	MsgBox % RCXY["rc"] " - " RCXY["xy"][1] ", " RCXY["xy"][2]
	UIObject.moveMouseAndClick(RCXY)
}

;; ============================================================================================================================================================ ;;
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

Global flaxPixelColorLocation := New TileMarkerBounds(0x9FE4E7, [ 771, 481 ])

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::main()

#If
^R::Reload
+^C::ExitApp