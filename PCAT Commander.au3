#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>

#include "PCAT_update_configs.au3"


; Create string for PlatfCombo
$sPatforms = ""

For $i = 0 To UBound($arPlatforms) - 1
    $sPatforms = $sPatforms & $arPlatforms[$i]("name") & "|"
Next
_GetSettings()
_CreateGUI()

; Create GUI Function
Func _CreateGUI()
	Local $hPCAT
    ; Create a GUI

    Local $hGUI = GUICreate("PCAT Commander", 210, 200)
	GUISetIcon("PCAT_commander.ico")
	; Create a label for Combobox
	Local $idPlatfLabel = GUICtrlCreateLabel("Platform:", 10, 10)
    ; Create a combobox control.
    Local $idPlatfCombo = GUICtrlCreateCombo("", 70, 10, 120, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	; Create a label for IP
	Local $idIPLabel = GUICtrlCreateLabel("IP address:", 10, 40)
	; Create a inputBox for IP address
	Local $idIPBox = GUICtrlCreateInput("IP address", 70, 40, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for TimeZone
	Local $idTZLabel = GUICtrlCreateLabel("Timezone:", 10, 60)
	; Create a label for Timezone value
	Local $idTZBox = GUICtrlCreateInput("Timezone", 70, 60, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for Login
	Local $idLoginLabel = GUICtrlCreateLabel("Login:", 10, 90)
	; Create an inputBox for Login
	Local $idLoginBox = GUICtrlCreateInput("", 70, 90, 120, 20)
	; Create a label for Password
	Local $idPasswordLabel = GUICtrlCreateLabel("Password:", 10, 110)
	; Create an inputBox for Password
	Local $idPasswordBox = GUICtrlCreateInput("", 70, 110, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	; Create Auto Select Latest Version checkBox
	Local $idVersionCheckBox = GUICtrlCreateCheckbox("Auto select the latest version", 10, 140, $ES_READONLY)
	; Create a Run button
	Local $runButton = GUICtrlCreateButton("Run PCAT", 110, 170, 85, 25);

	; Update platforms Combobox with data
	GUICtrlSetData($idPlatfCombo, $sPatforms, $oPlatfDefault("name"))
	; Update Platform Info Boxes with data
	_SetPlatfControls($idIPBox, $idTZBox, $idLoginBox, $idPasswordBox, $idVersionCheckBox)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    Local $sComboRead = ""
	Local $newTitle
    ; Loop until the user exits.
    While 1
		$hPCAT = WinGetHandle("[REGEXPTITLE:(Product Catalog.*|PCAT.*); REGEXPCLASS:SunAwt(Dialog|Frame)]", "")
		$newTitle = "PCAT" & " " & $oPlatfDefault("name") & " " & $oPlatfDefault("timezone")
		If $hPCAT And WinGetTitle($hPCAT) <> $newTitle Then
			WinSetTitle($hPCAT, "", $newTitle)
		EndIf
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $idClose
                ExitLoop

			Case $idPlatfCombo
				$sComboRead = GUICtrlRead($idPlatfCombo)
				$oPlatfDefault = _GetPlatfbyName($sComboRead)
				_SetPlatfControls($idIPBox, $idTZBox, $idLoginBox, $idPasswordBox, $idVersionCheckBox)

            Case $runButton
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
					$sLogin = GUICtrlRead($idLoginBox)
					If $sLogin Then $sPassword = GUICtrlRead($idPasswordBox)
					$iVersion = GUICtrlRead($idVersionCheckBox)
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
    GUIDelete($hGUI)
EndFunc


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