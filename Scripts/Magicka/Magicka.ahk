#NoEnv
Process,Priority,qmagicka,High 
SetKeyDelay, 25, 75
SetMouseDelay, 50

if not A_IsAdmin
{ 
	DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath 
	, str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1) 
	ExitApp 
}

; z::send fqsa

C:: ; Cancel spell stack by imbuing onto weapon
	send +{Click}
	return

1:: ; Bombs
	SetKeyDelay, 25, 25
	send sef
	sleep 75
	send f
	sleep 75
	send f
	sleep 25
	send +{Click Right}
	return

2:: ; Lightning
	SetKeyDelay, 25, 50
	send qfas
	sleep 50
	send a
	sleep 25
	send {Space}
	return

3:: ; Conflagrate
	SetKeyDelay, 25, 75
	send qf
	sleep 25
	send f
	sleep 25
	send fqf
	sleep 25
	send fq
	sleep 25
	send +{Click Right}
	return

4::
	SetKeyDelay, 25, 75
	send qfs
	sleep 25
	send sa
	sleep 25
	send a
	return

F1:: ; Teleport
	SetKeyDelay, 25, 50
	send asa
	sleep 25
	send {Space}
	return

F2:: ; Heal
	SetKeyDelay, 25, 25
	send w{Click Middle}
	return

F3:: ; Haste
	SetKeyDelay, 25, 25
	send asf
	sleep 25
	send {Space}
	return

F4:: ; Nullify
	SetKeyDelay, 25, 25
	send se{Space}
	return