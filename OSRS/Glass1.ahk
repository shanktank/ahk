#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;#IfWinActive ahk_exe OSBuddy.exe

;=============================================================================;

;SetTimer, WatchCursor, 25
;Return

;WatchCursor:
;MouseGetPos, X, Y
;ToolTip, %X% %Y%, 0, 0
;Return

;=============================================================================;

Class Banker {
	Static boundaryNorth := 517
	Static boundarySouth := 567
	Static boundaryWest  := 738
	Static boundaryEast  := 756
	
	;X := 0, Y := 0
	;XY := []
	
	;getXY() {
	;	Random, X, This.boundaryNorth, This.boundarySouth
	;	Random, Y, This.boundaryWest, This.boundaryEast
	;	This.XY.Push(X)
	;	This.XY.Push(Y)
	;	Return This.XY
	;}
	
	getCoords(ByRef X, ByRef Y) {
		Random, X, This.boundaryNorth, This.boundarySouth
		Random, Y, This.boundaryWest, This.boundaryEast
		Return
	}
}

;=============================================================================;

b := new Banker

;xy := b.getXY()
;MsgBox % xy

;x := 0, y := 0
b.getCoords(x, y)
MsgBox, %x% %y%




















