#include-once
#include "../models/platforms.au3"
#include "../models/ccc_settings.au3"
#include "../views/tray_lib.au3"
Local $oCccProps = ObjCreate("Scripting.Dictionary")

#cs
; This is for testing
Local $hCCC = _GetCccHandler()
ConsoleWrite ("CCC Handler: " & $hCCC)
$sTitle = WinGetTitle($hCCC)
ConsoleWrite($sTitle & @CRLF)
 _winCccProc($hCCC)
#ce

Func _winCccProc($hCCC)
	If $hCCC Then
		$sTitle = WinGetTitle($hCCC)
		;ConsoleWrite($sTitle & @CRLF)

		Switch $sTitle
			Case "Customer Care Client Login"
				_TitleReplace($hCCC, $sTitle)
				; Try to autologin if Login InputBox is not Empty and no Login attempts have been made
				If $oCccSettings("login") And Not $oCccProps("bLoginAttempted") Then
					_TrayTip("Trying to Login to CCC", 3)
					_CccAutoLogin($hCCC)
					$oCccProps("bLoginAttempted") = True
				EndIf
			Case "Customer Care Client"
				_TitleReplace($hCCC, $sTitle)
		EndSwitch
	EndIf
EndFunc

Func _TitleReplace($hCCC, $sTitle)
	$sTitle = StringReplace($sTitle, "Customer Care Client", "CCC" & " " & $oCccPlatform("name"))
	WinSetTitle($hCCC, "", $sTitle)
EndFunc

Func _GetCccHandler()
	Local $hCCC = WinGetHandle("[REGEXPTITLE:(Customer Care Client.*|CCC.*); REGEXPCLASS:WindowsForms.*]", "")
	If $hCCC Then
		Return $hCCC
	EndIf
	Return
EndFunc


Func _CccAutoLogin($hLogin)
	WinActivate($hLogin)
	ConsoleWrite("login/password: " & $oCccSettings("login") & $oCccSettings("password") & @CRLF)
	Send($oCccSettings("login"), 1)
	Send("{TAB}")
	Send($oCccSettings("password"), 1)
	Send("{ENTER}")
EndFunc
