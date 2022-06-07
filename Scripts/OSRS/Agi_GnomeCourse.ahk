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

; Contextual Cursor: disabled
; Entity Hider: hide NPCs
; Low detail off?
; Camera zoom: 223/1004

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

Main() {
	Loop {
		points := [ pointa, pointb, pointc, pointd, pointe, pointf, pointg ]
		sleeps := [ ]
		
		sleeps.push(Rand(sleepa[1], sleepa[2]))
		sleeps.push(Rand(sleepb[1], sleepb[2]))
		sleeps.push(Rand(sleepc[1], sleepc[2]))
		sleeps.push(Rand(sleepd[1], sleepd[2]))
		sleeps.push(Rand(sleepe[1], sleepe[2]))
		sleeps.push(Rand(sleepf[1], sleepf[2]))
		sleeps.push(Rand(sleepg[1], sleepg[2]))
		
		For index, wait In sleeps {
			If(points[index].moveMouseAndClick(, wait) == False) {
				MsgBox % "fug"
				Return
			}
		}



		/*
		sleeps.push(Rand(waitba, waitbb))
		sleeps.push(Rand(waitca, waitcb))
		sleeps.push(Rand(waitda, waitdb))
		sleeps.push(Rand(waitea, waiteb))
		sleeps.push(Rand(waitfa, waitfb))
		sleeps.push(Rand(waitga, waitgb))
		*/

		/*
		If(pointa.moveMouseAndClick(, Rand(waitaa, waitab)) == False Or pointb.moveMouseAndClick(, Rand(waitba, waitbb)) == False Or pointc.moveMouseAndClick(, Rand(waitca, waitcb)) == False Or pointd.moveMouseAndClick(, Rand(waitda, waitdb)) == False Or pointe.moveMouseAndClick(, Rand(waitea, waiteb)) == False Or pointf.moveMouseAndClick(, Rand(waitfa, waitfb)) == False Or pointg.moveMouseAndClick(, Rand(waitga, waitgb)) == False) {
			MsgBox % "fuck"
			Return
		}
		*/
		
		/*
		If(pointa.moveMouseAndClick(, Rand(waitaa, waitab)) == False)
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

;Global pointa := New ClickAreaBounds([ 1375, 465 ], [ 1389, 442 ])
;Global pointb := New ClickAreaBounds([  816, 354 ], [  879, 339 ])
;Global pointc := New ClickAreaBounds([  822, 502 ], [  830, 466 ])
;Global pointd := New ClickAreaBounds([  596, 545 ], [  624, 520 ])
;Global pointe := New ClickAreaBounds([  684, 495 ], [  703, 477 ])
;Global pointf := New ClickAreaBounds([  760, 826 ], [  833, 795 ])
;Global pointg := New ClickAreaBounds([  808, 688 ], [  824, 668 ])

Global pointa := New ClickAreaBounds([ 1569, 444 ], [ 1582, 410 ]) ;; Log
Global pointb := New ClickAreaBounds([  822, 289 ], [  894, 277 ]) ;; Net
Global pointc := New ClickAreaBounds([  825, 486 ], [  830, 445 ]) ;; Branch
Global pointd := New ClickAreaBounds([  513, 533 ], [  557, 526 ]) ;; Rope
Global pointe := New ClickAreaBounds([  627, 486 ], [  661, 479 ]) ;; Branch
Global pointf := New ClickAreaBounds([  747, 913 ], [  820, 900 ]) ;; Net
Global pointg := New ClickAreaBounds([  802, 768 ], [  826, 740 ]) ;; Pipe

Global sleepa := [ 10123, 10419 ]
Global sleepb := [  3668,  4013 ]
Global sleepc := [  1833,  2112 ]
Global sleepd := [  6689,  7179 ]
Global sleepe := [  3112,  3521 ]
Global sleepf := [  5687,  5913 ]
Global sleepg := [  8597,  9198 ]

Global waitaa := 10123
Global waitab := 10419
Global waitba := 3668
Global waitbb := 4013
Global waitca := 1833
Global waitcb := 2112
Global waitda := 6689
Global waitdb := 7179
Global waitea := 3112
Global waiteb := 3521
Global waitfa := 5687
Global waitfb := 5913
Global waitga := 8587
Global waitgb := 9198

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::Main()
F2::pointg.moveMouse(pointg.generateCoords())

#If
^R::Reload
+^C::ExitApp
