#include "./_CccAutoLogin.au3"
Local $oCccProps = ObjCreate("Scripting.Dictionary")
Func _winCCCproc($hCCC)
	If $hCCC Then
		$sTitle = WinGetTitle($hCCC)
		; ConsoleWrite($sTitle & @CRLF)
		Switch $sTitle
			Case "Customer Care Client Login"
				; Try to autologin if Login InputBox is not Empty and no Login attempts have been made
				If $oCccSettings("login") And Not $oCccProps("bLoginAttempted") Then
					_TrayTip("Trying to Login to CCC", 3)
					_CccAutoLogin($hCCC)
					$oCccProps("bLoginAttempted") = True
				EndIf
			Case "Customer Care Client"
				$sNewTitle = "CCC" & " " & $oCccPlatform("name")
				WinSetTitle($hCCC, "", $sNewTitle)
		EndSwitch
	EndIf
EndFunc