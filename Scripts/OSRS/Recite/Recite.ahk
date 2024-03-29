#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance Force
#EscapeChar \
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

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

FileEncoding, UTF-8

Main() {
	Local inputFile := FileOpen("venture-bros_grand-galactic-inquisitor.txt", "r")

	While(inputFile.Position < inputFile.Length) {
		TextLine := inputFile.ReadLine()
		Loop, Parse, TextLine
		{
			SendRaw % A_LoopField
			Sleep, generateSleepTime(63, 97)
		}
	}
}

;; ============================================================================================================================================================ ;;
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;



;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::Main()

#If
^R::Reload
+^C::ExitApp
