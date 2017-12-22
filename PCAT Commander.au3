#include "views/GUI_main.au3"
#include "models/constants.au3"
#include "models/platforms.au3"
#include "models/read_settings.au3"
#include "PCAT_update_configs.au3"

Local $hPCAT
Local $sComboRead = ""
Local $sNewTitle
Local $oPlatfDefault = ObjCreate("Scripting.Dictionary")
Local $oSettings = ObjCreate("Scripting.Dictionary")
Local $oMainGUI = ObjCreate("Scripting.Dictionary")

; read the settings
$oSettings = _ReadSettings()
; check and update the default platform object
; use the value from config if it exists
If $oSettings("platfname") Then
	_SetDefaultPlatform(_GetPlatfbyName($oSettings("platfname")))
EndIf
$oPlatfDefault = _GetDefaultPlatform()

$oMainGUI = _MainGUI()
; Update platforms Combobox with data
GUICtrlSetData($oMainGUI("platfCombo"), _ConcatPlatfNames(), $oPlatfDefault("name"))
; Update Platform Info Boxes with data
_SetPlatfControls($oMainGUI("ipBox"), $oMainGUI("tzBox"), $oMainGUI("loginBox"), $oMainGUI("passwordBox"), $oMainGUI("versionCheckBox"))

; Display the GUI.
GUISetState(@SW_SHOW, $oMainGUI("mainWindow"))

; Loop until the user exits.
While 1
	$hPCAT = _GetPCATHandler()
	$sNewTitle = "PCAT" & " " & $oPlatfDefault("name") & " " & $oPlatfDefault("timezone")
	If $hPCAT And WinGetTitle($hPCAT) <> $sNewTitle Then
		WinSetTitle($hPCAT, "", $sNewTitle)
	EndIf
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop

		Case $oMainGUI("platfCombo")
			If Not $hPCAT Then
				$sComboRead = GUICtrlRead($oMainGUI("platfCombo"))
				$oPlatfDefault = _SetDefaultPlatform(_GetPlatfbyName($sComboRead))
				_SetPlatfControls($oMainGUI("ipBox"), $oMainGUI("tzBox"), $oMainGUI("loginBox"), $oMainGUI("passwordBox"), $oMainGUI("versionCheckBox"))
			Else
				_MsgBoxPCATRunning($hPCAT)
				WinActivate($hPCAT)
				; reset platfComboBox to default platform name
				GUICtrlSetData($oMainGUI("platfCombo"), "")
				GUICtrlSetData($oMainGUI("platfCombo"), _ConcatPlatfNames(), $oPlatfDefault("name"))
			EndIf
		Case $oMainGUI("runButton")
			; If PCAT is not running, update configs, store options and run PCAT
			If Not $hPCAT Then
				; Read the GUI data and store it
				$oSettings("login") = GUICtrlRead($oMainGUI("loginBox"))
				If $oSettings("login") Then $oSettings("password") = GUICtrlRead($oMainGUI("passwordBox"))
				_UpdateSettings($oPlatfDefault, $oSettings)
				; If error occured on config update, raise an error, continue loop
				If @error Then
					_RaiseError(@error, @extended)
					ContinueCase
				EndIf


				$iVersion = GUICtrlRead($oMainGUI("versionCheckBox"))
				;ConsoleWrite("Login: " & $oSettings("login")  & " Password: " & $oSettings("password") & _
				;				" AutoVersion: " & $iVersion & @CRLF)

				; Run PCAT
				Run($APPPATH)
				If @error Then
					_RaiseError(4)
					ContinueCase
				EndIf

				; Wait for PCAT Login window
				_TrayTip("Waiting for PCAT Login Window", 30)
				Local $hLogin = WinWait("[TITLE:Login; CLASS:SunAwtDialog]", "", 30)
				If Not $hLogin Then
					_RaiseError(5)
					ContinueCase
				EndIf

				; Try to autologin if Login InputBox is not Empty
				If $oSettings("login") Then
					_TrayTip("Trying to Login to PCAT", 3)
					_AutoLogin($hLogin)
					If $iVersion = 1 Then
						; Wait for PCAT "Select Reseller Version" Window
						_TrayTip("Waiting for PCAT Select Reseller Version Window", 30)
						Local $hVersion = WinWait("[TITLE:Select Reseller Version; CLASS:SunAwtDialog]", "", 30)
						If Not $hVersion Then
							;_RaiseError(6)
							_TrayTip("Timeout in waiting for Select Version Window", 3, 3)
							ContinueCase
						EndIf
						_TrayTip("Selecting the Latest version", 2)
						_AutoVersion($hVersion)
					EndIf
				EndIf
			Else
				_MsgBoxPCATRunning($hPCAT)
				WinActivate($hPCAT)
			EndIf

	EndSwitch
WEnd

; Delete the previous GUI and all controls.
GUIDelete($oMainGUI("mainWindow"))

Func _GetPCATHandler()
	Local $hPCAT = WinGetHandle("[REGEXPTITLE:(Login.*|Select Reseller Version.*|Product Catalog.*|PCAT.*); REGEXPCLASS:SunAwt(Dialog|Frame)]", "")
	If $hPCAT Then
		Return $hPCAT
	EndIf
	Return
EndFunc

; Set Data for GUI Platform Controls
Func _SetPlatfControls($idIPBox, _
						$idTZBox, _
						$idLoginBox, _
						$idPasswordBox, _
						$idVersionCheckBox, _
						$sPlatfName = $oPlatfDefault("name"), _
						$sPlatfIP = $oPlatfDefault("IP"), _
						$sPlatfTZ = $oPlatfDefault("timezone"), _
						$sPlatfLogin = $oSettings("login"), _
						$sPlatfPassword = $oSettings("password"), _
						$iPlatfVersion = $iVersion)
	; Set items for the combobox.
    GUICtrlSetData("", "", $sPlatfName)

	; Set InputBoxes Data
	GUICtrlSetData($idIPBox, $sPlatfIP)
	GUICtrlSetData($idTZBox, $sPlatfTZ)

	; Set Login and Password Data
	GUICtrlSetData($idLoginBox, $sPlatfLogin)
	GUICtrlSetData($idPasswordBox, $sPlatfPassword)

	; Set Autoversion Checkbox
	GUICtrlSetState($idVersionCheckBox, $iPlatfVersion)
EndFunc

; Autologin
Func _AutoLogin($hLogin)
	WinActivate($hLogin)
	Send($oSettings("login") & "{TAB}" & $oSettings("password") & "{ENTER}")
EndFunc

; Auto version select
Func _AutoVersion($hVersion)
	WinActivate($hVersion)
	Send("{TAB}^{END}^{ENTER}")
EndFunc

Func _RaiseError($iErrorCode, $iErrParamCode=0)
	ConsoleWrite("Error code: " & $iErrorCode & "ErrParamCode: " & $iErrParamCode)
	Local $arErrors[7]
	$arErrors[0] = ""
	$arErrors[1] = "File not found"
	$arErrors[2] = "Could not write file"
	$arErrors[3] = "Could not read file"
	$arErrors[4] = "Could not start PCAT. Check PCAT log for details."
	$arErrors[5] = "Timeout in waiting for PCAT Login window." & @CRLF & _
					"Try to close some programs and try again"
	$arErrors[6] = "Timeout in waiting for PCAT Select Reseller Version window."

	Local $arErrParams[5]
	$arErrParams[0] = ""
	$arErrParams[1] = $CONFPATH
	$arErrParams[2] = $SETTINGSPATH
	$arErrParams[3] = $CONFPATH & ".bkp"
	$arErrParams[4] = $SETTINGSPATH & ".bkp"
	MsgBox(4112, "PCAT commander error", $arErrors[$iErrorCode] & @CRLF & $arErrParams[$iErrParamCode])

EndFunc