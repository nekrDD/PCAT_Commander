#include "../models/pcat_props.au3"
Func _winPCATproc($hPCAT)
	If $hPCAT Then
		$sTitle = WinGetTitle($hPCAT)
		; ConsoleWrite($sTitle & @CRLF)
		Switch $sTitle
			Case "Login"
				; Try to autologin if Login InputBox is not Empty and no Login attempts have been made
				If $oSettings("login") And Not $oPcatProps("bLoginAttempted") Then
					_TrayTip("Trying to Login to PCAT", 3)
					_AutoLogin($hPCAT)
					$oPcatProps("bLoginAttempted") = True
				EndIf
			Case "Select Reseller Version"
				If $oSettings("selectVersion") = 1 And Not $oPcatProps("bSelectVerAttempted") Then
					_TrayTip("Selecting the Latest version", 2)
					_AutoVersion($hPCAT)
					$oPcatProps("bSelectVerAttempted") = True
				EndIf
			Case "Product Catalog"
				$sNewTitle = "PCAT" & " " & $oPlatfDefault("name") & " " & $oPlatfDefault("timezone")
				WinSetTitle($hPCAT, "", $sNewTitle)
			Case $sNewTitle
				; Check UPM client.connect.URL status and display error if it's not ok
				If $oPcatProps("hConnectURL") Then
					If _GetResponseURL($oPcatProps("hConnectURL"))==False Then
						_MsgBoxPropagateRestricted($oPlatfDefault("UPM_IP"))
						InetClose($oPcatProps("hConnectURL"))
					EndIf
				EndIf
		EndSwitch
	EndIf
EndFunc