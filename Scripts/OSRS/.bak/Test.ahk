#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen

;Global pixelColor := 0x00FF00
Global pixelColor := 0x4E3535

findPixel() {
	PixelSearch, OutputVarX, OutputVarY, 175, 25, 1370, 850, %pixelColor%, , Fast RGB
	If(ErrorLevel == 0) {
		ToolTip, here, OutputVarX, OutputVarY
	} Else {
		ToolTip, %ErrorLevel%, 0, 0
	}
}

SetTimer, findPixel, 250
Return
