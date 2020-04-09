#SingleInstance FORCE

;Joy5::
;Joy9::
;	Send Joy5
;	return

;Joy6::
;Joy10::
;	Send, Joy6
;	return

;Joy10:
;	GetKeyState, joyZ, %joyNumber%JoyZ
;	MsgBox, "asdf"
;	if joyZ = 100
;	{
;		Send, {Joy5}
;	}
;	if joyZ = 200
;	{
;		Send, {Joy6}
;	}
;	return

#Persistent  ; Keep this script running until the user explicitly exits it.
SetTimer, WatchAxis, 5
return

WatchAxis:
GetKeyState, JoyZ, JoyZ  ; Get position of X axis.
;KeyToHoldDownPrev = %KeyToHoldDown%  ; Prev now holds the key that was down before (if any).

GetKeyState, joyz, %jz%JoyR

if joyz <= 100
{
	MsgBox, "asdf"
	Send, {Joy5}
}
else if joyz >= 199
{
	MsgBox, "qwer"
	Send, {Joy6}
}
else
{
	MsgBox, %joyz%
}
return