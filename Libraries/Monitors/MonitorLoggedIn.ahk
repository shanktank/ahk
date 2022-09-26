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
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

Global LoggedInCheck         := New PixelColorLocation(0x8A814F, [ 1620, 43 ]) ;; "Logout" X at top-right of screen

Global DisconnectedClickArea := New ClickAreaBounds([ 729, 456 ], [ 914,  493 ])
Global LoginClickArea        := New ClickAreaBounds([ 849, 443 ], [ 1034, 476 ])
Global WelcomeClickArea      := New ClickAreaBounds([ 665, 475 ], [ 976,  581 ])

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

Main() {
	Local pass := "1111808"

	If(LoggedInCheck.verifyPixelColor() == False) {
		MsgBox % "not logged in"
		
		DisconnectedClickArea.moveMouseAndClick()
		LoginClickArea.moveMouseAndClick()
		Loop, Parse, pass
			UIObject.inputKeyAndSleep(A_LoopField, generateSleepTime(63, 97), True)
		UIObject.inputKeyAndSleep("{Return}", generateSleepTime(4321, 8765), True)
		
		WelcomeClickArea.moveMouseAndClick()
	}
}

;SetTimer, Main, 100
;Return

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::Main()

#If
^R::Reload
+^C::ExitApp
