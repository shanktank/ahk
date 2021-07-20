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

#IfWinActive ^(RuneLite|OpenOSRS)$

; Camera zoom: 223/1004

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

Main() {
	Loop {
		If(pointa.moveMouseAndClick(, Rand(waitaa, waitab)) == False Or pointb.moveMouseAndClick(, Rand(waitba, waitbb)) == False Or pointc.moveMouseAndClick(, Rand(waitca, waitcb)) == False Or pointd.moveMouseAndClick(, Rand(waitda, waitdb)) == False Or pointe.moveMouseAndClick(, Rand(waitea, waiteb)) == False Or pointf.moveMouseAndClick(, Rand(waitfa, waitfb)) == False Or pointg.moveMouseAndClick(, Rand(waitga, waitgb)) == False) {
			MsgBox % "fuck"
			Return
		}
		/*
			Return
		If(pointb.moveMouseAndClick(, Rand(waitba, waitbb)) == False)
			Return
		If(pointc.moveMouseAndClick(, Rand(waitca, waitcb)) == False)
			Return
		If(pointd.moveMouseAndClick(, Rand(waitda, waitdb)) == False)
			Return
		If(pointe.moveMouseAndClick(, Rand(waitea, waiteb)) == False)
			Return
		If(pointf.moveMouseAndClick(, Rand(waitfa, waitfb)) == False)
			Return
		If(pointg.moveMouseAndClick(, Rand(waitga, waitgb)) == False)
			Return
		*/
	}
}

;; ============================================================================================================================================================ ;;
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

Global CLICK_TYPE := "Interact"

Global pointa := New ClickAreaBounds([ 1375, 465 ], [ 1389, 442 ])
Global pointb := New ClickAreaBounds([  816, 354 ], [  879, 339 ])
Global pointc := New ClickAreaBounds([  822, 502 ], [  830, 466 ])
Global pointd := New ClickAreaBounds([  596, 545 ], [  624, 520 ])
Global pointe := New ClickAreaBounds([  684, 495 ], [  703, 477 ])
Global pointf := New ClickAreaBounds([  760, 826 ], [  833, 795 ])
Global pointg := New ClickAreaBounds([  804, 713 ], [  829, 679 ])

Global waitaa := 10123
Global waitab := 10419

Global waitba := 3668
Global waitbb := 4013

Global waitca := 1833
Global waitcb := 2112

Global waitda := 6480
Global waitdb := 7129

Global waitea := 3112
Global waiteb := 3521

Global waitfa := 5487
Global waitfb := 5713

Global waitga := 8587
Global waitgb := 9198

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::Main()

#If
^R::Reload
+^C::ExitApp
