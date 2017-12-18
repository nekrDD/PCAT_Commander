#include "views/GUI_main.au3"
#include "PCAT_update_configs.au3"

Local $hPCAT
Local $sComboRead = ""
Local $newTitle
Local $sPatforms = ""
Local $oMainGUI = ObjCreate("Scripting.Dictionary")

; Create string for PlatfCombo
For $i = 0 To UBound($arPlatforms) - 1
    $sPatforms = $sPatforms & $arPlatforms[$i]("name") & "|"
Next
; read the settings
_GetSettings()
$oMainGUI = _MainGUI()
; Update platforms Combobox with data
GUICtrlSetData($oMainGUI("platfCombo"), $sPatforms, $oPlatfDefault("name"))
; Update Platform Info Boxes with data
_SetPlatfControls($oMainGUI("ipBox"), $oMainGUI("tzBox"), $oMainGUI("loginBox"), $oMainGUI("passwordBox"), $oMainGUI("versionCheckBox"))

; Display the GUI.
GUISetState(@SW_SHOW, $oMainGUI("mainWindow"))


    ; Loop until the user exits.
    While 1
		$hPCAT = WinGetHandle("[REGEXPTITLE:(Product Catalog.*|PCAT.*); REGEXPCLASS:SunAwt(Dialog|Frame)]", "")
		$newTitle = "PCAT" & " " & $oPlatfDefault("name") & " " & $oPlatfDefault("timezone")
		If $hPCAT And WinGetTitle($hPCAT) <> $newTitle Then
			WinSetTitle($hPCAT, "", $newTitle)
		EndIf
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

			Case $oMainGUI("platfCombo")
				$sComboRead = GUICtrlRead($oMainGUI("platfCombo"))
				$oPlatfDefault = _GetPlatfbyName($sComboRead)
				_SetPlatfControls($oMainGUI("ipBox"), $oMainGUI("tzBox"), $oMainGUI("loginBox"), $oMainGUI("passwordBox"), $oMainGUI("versionCheckBox"))

            Case $oMainGUI("runButton")
				; Check that PCAT is not running
				$hPCAT = _getPCATHandler()

				; If PCAT is not running, update configs, store options and run PCAT
				If Not $hPCAT Then
					_UpdateInternalConf($oPlatfDefault("timezone"), $oPlatfDefault("IP"))
					; If error occured on config update, raise an error, continue loop
					If @error Then
						_RaiseError(@error, @extended)
						ContinueCase
					EndIf

					; Read the GUI data and store it
					$sLogin = GUICtrlRead($oMainGUI("loginBox"))
					If $sLogin Then $sPassword = GUICtrlRead($oMainGUI("passwordBox"))
					$iVersion = GUICtrlRead($oMainGUI("versionCheckBox"))
					ConsoleWrite("Login: " & $sLogin  & " Password: " & $sPassword & _
									" AutoVersion: " & $iVersion & @CRLF)


					; Run PCAT
					Run($sAppPath)
					If @error Then
						_RaiseError(4)
						ContinueCase
					EndIf

					; Wait for PCAT Login window
					TrayTip("PCAT Commander", "Waiting for PCAT Login Window", 30)
					Local $hLogin = WinWait("[TITLE:Login; CLASS:SunAwtDialog]", "", 30)
					If Not $hLogin Then
						_RaiseError(5)
						ContinueCase
					EndIf

					; Try to autologin if Login InputBox is not Empty
					If $sLogin Then
						TrayTip("PCAT Commander", "Trying to Login to PCAT", 3)
						_AutoLogin($hLogin)
						;ConsoleWrite (WinGetTitle("[CLASS:SunAwtDialog]") & @CRLF)
						;TrayTip("My Title", "TEST", 15)
						If $iVersion = 1 Then
							; Wait for PCAT "Select Reseller Version" Window
							TrayTip("PCAT Commander", "Waiting for PCAT Select Reseller Version Window", 30)
							Local $hVersion = WinWait("[TITLE:Select Reseller Version; CLASS:SunAwtDialog]", "", 30)
							If Not $hVersion Then
								_RaiseError(6)
								ContinueCase
							EndIf
							TrayTip("PCAT Commander", "Selecting the Latest version...", 2)
							_AutoVersion($hVersion)
						EndIf
					EndIf

					;MsgBox($MB_SYSTEMMODAL, "", "The combobox is currently displaying: " & $sComboRead, 0, $hGUI)
				Else
					MsgBox(4144,"PCAT commander info", "PCAT '"  & WinGetTitle($hPCAT) & "' is already running!")
					WinActivate($hPCAT)
					;MsgBox(4132, "PCAT commander question", "PCAT is already running, Do you want to close it?"
				EndIf

        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($oMainGUI("mainWindow"))



Func _getPCATHandler()
	Local $hPCAT = WinGetHandle("[REGEXPTITLE:(Login.*|Select Reseller Version.*|Product Catalog.*|PCAT.*); REGEXPCLASS:SunAwt(Dialog|Frame)]", "")
	If $hPCAT Then
		Return $hPCAT
	EndIf
	Return
EndFunc

; Find platform object by it's name.
; If not found, return default platform object
Func _GetPlatfbyName($sPlatfName)
	For $i = 0 To UBound($arPlatforms) - 1
		If $arPlatforms[$i]("name") = $sPlatfName Then
			Return $arPlatforms[$i]
		EndIf
	Next
	Return $oPlatfDefault
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
						$sPlatfLogin = $sLogin, _
						$sPlatfPassword = $sPassword, _
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
	Send($sLogin & "{TAB}" & $sPassword & "{ENTER}")
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
	$arErrParams[1] = $sConfPath
	$arErrParams[2] = $sSettingsPath
	$arErrParams[3] = $sConfPath & ".bkp"
	$arErrParams[4] = $sSettingsPath & ".bkp"
	MsgBox(4112, "PCAT commander error", $arErrors[$iErrorCode] & @CRLF & $arErrParams[$iErrParamCode])

EndFunc