Func _CccAutoLogin($hLogin)
	WinActivate($hLogin)
	ConsoleWrite("login/password: " & $oCccSettings("login") & $oCccSettings("password") & @CRLF)
	Send($oCccSettings("login"), 1)
	Send("{TAB}")
	Send($oCccSettings("password"), 1)
	Send("{ENTER}")
EndFunc