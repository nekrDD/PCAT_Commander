#include "../models/constants.au3"
#include "../views/GUI_main.au3"
#include "../models/platforms.au3"
#include "../models/read_settings.au3"
#include "../models/update_settings.au3"
#include "../controllers/win_PCAT_proc.au3"
;#include "../models/pcat_props.au3"
#include "check_connectURL.au3"

Local $hPCAT 	; Product Catalog window handler
Local $sTitle 	; Product Catalog window Title
Local $sComboRead = "" ; Platform name ComboBox value
Local $sNewTitle	; new title for Product Catalog window
Local $oPlatfDefault = ObjCreate("Scripting.Dictionary") ; Default Platform object (name, IP, timezone, UPM_IP)
;Local $oSettings = ObjCreate("Scripting.Dictionary")	; Settings object
Local $oMainGUI = ObjCreate("Scripting.Dictionary")		; Main GUI elements object

;	Local $hConnectURL ; client.connect.URL request handler
;	Local $oPcatProps("bLoginAttempted") = False
;	Local $oPcatProps("bSelectVerAttempted") = False


Func _CtrlMain()

	; read the settings from config files
	_ReadSettings()

	; check and update the default platform object
	; use the value from config if it exists
	If $oSettings("ip") Then
		_SetDefaultPlatform(_GetPlatfbyIP($oSettings("ip")))
	EndIf
	$oPlatfDefault = _GetDefaultPlatform()
	; create app main window
	$oMainGUI = _MainGUI()
	; Update platforms Combobox with data
	GUICtrlSetData($oMainGUI("platfCombo"), _ConcatPlatfNames(), $oPlatfDefault("name"))
	; Update Platform Info Boxes with data
	_SetPlatfControls()
	; Set tray behaviour
	_SetTray()

	; update CCC frame
	; Update platforms Combobox with data
	GUICtrlSetData($oMainGUI("cccPlatfCombo"), _ConcatPlatfNames(), $oPlatfDefault("name"))

	; Display the GUI.
	GUISetState(@SW_SHOW, $oMainGUI("mainWindow"))
	; ConsoleWrite("Login " &  $oSettings("login") & $oPcatProps("bLoginAttempted")  & @CRLF)
	; Loop until the user exits.
	While 1
		; Get PCAT window handler
		$hPCAT = _GetPCATHandler()
		_winPCATproc($hPCAT)

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $oMainGUI("platfCombo")
				If Not $hPCAT Then
					$sComboRead = GUICtrlRead($oMainGUI("platfCombo"))
					$oPlatfDefault = _SetDefaultPlatform(_GetPlatfbyName($sComboRead))
					_SetPlatfControls()
				Else
					_MsgBoxPCATRunning($hPCAT)
					WinActivate($hPCAT)
					; reset platfComboBox to default platform name
					GUICtrlSetData($oMainGUI("platfCombo"), "")
					GUICtrlSetData($oMainGUI("platfCombo"), _ConcatPlatfNames(), $oPlatfDefault("name"))
				EndIf
			Case $oMainGUI("runButton")
				$hPCAT = _GetPCATHandler()
				; If PCAT is not running, update configs, store options and run PCAT
				If Not $hPCAT and Not ProcessExists($oPcatProps("iPID")) Then
					; Read the GUI data and store it
					$oSettings("login") = GUICtrlRead($oMainGUI("loginBox"))
					If $oSettings("login") Then $oSettings("password") = GUICtrlRead($oMainGUI("passwordBox"))
					_UpdateSettings($oPlatfDefault, $oSettings)
					; If error occured on config update, raise an error, continue loop
					If @error Then
						_RaiseError(@error, @extended)
						ContinueCase
					EndIf
					$oSettings("selectVersion") = GUICtrlRead($oMainGUI("versionCheckBox"))
					; Run PCAT
					$oPcatProps("bLoginAttempted") = False
					$oPcatProps("bSelectVerAttempted") = False
					$oPcatProps("iPID") = Run($PCATPATH)
					; ConsoleWrite("PID: " & $oPcatProps("iPID") & @CRLF)
					; ConsoleWrite("LoginAttempted " & $oPcatProps("bLoginAttempted")  & @CRLF)
					If @error Then
						_RaiseError(4)
						ContinueCase
					EndIf
					$oPcatProps("hConnectURL") = _SendRequestConnectURL($oPlatfDefault("UPM_IP"))
				Else
					_MsgBoxPCATRunning($hPCAT)
					WinActivate($hPCAT)
				EndIf
		EndSwitch
	WEnd

	; Delete the GUI and all controls.
	GUIDelete($oMainGUI("mainWindow"))
EndFunc

Func _GetPCATHandler()
	Local $hPCAT = WinGetHandle("[REGEXPTITLE:(Login.*|Select Reseller Version.*|Product Catalog.*|PCAT.*); REGEXPCLASS:SunAwt(Dialog|Frame)]", "")
	If $hPCAT Then
		Return $hPCAT
	EndIf
	Return
EndFunc

; Set Data for GUI Platform Controls
Func _SetPlatfControls()
	; Set items for the combobox.
    GUICtrlSetData("", "", $oPlatfDefault("name"))

	; Set InputBoxes Data
	GUICtrlSetData($oMainGUI("ipBox"), $oPlatfDefault("IP"))
	GUICtrlSetData($oMainGUI("tzBox"), $oPlatfDefault("timezone"))
	GUICtrlSetData($oMainGUI("upmIPBox"), $oPlatfDefault("UPM_IP"))

	; Set Login and Password Data
	GUICtrlSetData($oMainGUI("loginBox"),  $oSettings("login"))
	GUICtrlSetData($oMainGUI("passwordBox"), $oSettings("password"))

	; Set Autoversion Checkbox
	GUICtrlSetState($oMainGUI("versionCheckBox"), $oSettings("selectVersion"))
EndFunc

; Autologin
Func _AutoLogin($hLogin)
	WinActivate($hLogin)
	ConsoleWrite("login/password: " & $oSettings("login") & $oSettings("password") & @CRLF)
	Send($oSettings("login"), 1)
	Send("{TAB}")
	Send($oSettings("password"), 1)
	Send("{ENTER}")
EndFunc


; Bugfix for Send (cyrillic symbols are not sent properly)
Func _SendEx($sString)
    Local $sOld_Clip = ClipGet()
    ClipPut($sString)
    Sleep(10)
    Send("+{INSERT}")
    ClipPut($sOld_Clip)
EndFunc

; Auto version select
Func _AutoVersion($hVersion)
	WinActivate($hVersion)
	Send("{TAB}^{END}^{ENTER}")
EndFunc

Func _RaiseError($iErrorCode, $iErrParamCode=0)
	ConsoleWrite("Error code: " & $iErrorCode & "ErrParamCode: " & $iErrParamCode)
	Local $arErrors[10]
	$arErrors[0] = ""
	$arErrors[1] = "File not found"
	$arErrors[2] = "Could not write file. Probably java.exe process is blocking it, or you don't have Admin permissions."
	$arErrors[3] = "Could not read file."
	$arErrors[4] = "Could not start PCAT. Check PCAT log for details."
	$arErrors[5] = "Timeout in waiting for PCAT Login window." & @CRLF & _
					"Try to close some programs and try again"
	$arErrors[6] = "Timeout in waiting for PCAT Select Reseller Version window."
	$arErrors[7] = "Error reading internal.conf file, couldn't find properly formatted `default_options=""...""` string."
	$arErrors[8] = "Error reading jdbc.properties file, couldn't find properly formatted `jdbc.url=""...""` string."
	$arErrors[9] = "Error reading workpoint-client.properties file, couldn't find properly formatted `client.connect.URL=""...""` string."

	Local $arErrParams[7]
	$arErrParams[0] = ""
	$arErrParams[1] = $CONFPATH
	$arErrParams[2] = $SETTINGSPATH
	$arErrParams[3] = $CONFPATH & ".bkp"
	$arErrParams[4] = $SETTINGSPATH & ".bkp"
	$arErrParams[5] = $WPCLIENTPATH
	$arErrParams[6] = $WPCLIENTPATH & ".bkp"

	MsgBox(4112, "PCAT commander error", $arErrors[$iErrorCode] & @CRLF & $arErrParams[$iErrParamCode])

EndFunc