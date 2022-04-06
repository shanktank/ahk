#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk
#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%

Global InvBounds := New PixelScanArea(0xE2DDDD, [1367, 985], [1624, 627])

f::Click

dropAll() {
	; rxy = scanAreaForPixelColor(InvBounds[2][1], InvBounds[2][2], InvBounds[3][1], InvBounds[2][2], InvBounds[1])
	; While(rxy['rc'] = 0)
	;	mouse move to color with click area range
	;	click
	;	rxy = scanAreaForPixelColor(InvBounds[2][1], InvBounds[2][2], InvBounds[3][1], InvBounds[2][2], InvBounds[1])
}

main() {
	While(1) {
		;IF(not woodcutting red pixel)
		;	Click
		IF(invFullCheck.verifyPixelColor() == True)
			dropAll();
	}
}

^R::Reload
+^C::ExitApp
