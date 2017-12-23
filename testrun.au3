
Func AutoLoginAndSelectVersion()
	$h = WinWait("[TITLE:Login; CLASS:SunAwtDialog]")
	WinActivate($h)
	Send("AVESELOV{TAB}Pp$516184{ENTER}")
	$h = WinWait("[TITLE:Select Reseller Version; CLASS:SunAwtDialog]")
	WinActivate($h)
	Send("{TAB}^{END}^{ENTER}")
	ConsoleWrite($h)
EndFunc

Func _TrayTip()
	TrayTip("My Title", "TEST", 15)
EndFunc

;TrayTip()
$iTest = 0
Switch $iTest
	Case 0
		ConsoleWrite("1")
	Case 0
		ConsoleWrite("2")
EndSwitch
;If $iTest Then ConsoleWrite ("Ok")