#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>

#include <ButtonConstants.au3>
#include "../models/constants.au3"


; Create GUI Function
Func _MainGUI()
	Local $oMainGUI = ObjCreate("Scripting.Dictionary")
    ; Create a GUI
    $oMainGUI("mainWindow") = GUICreate($APPNAME & " v" & $APPVERSION, 440, 250)
	GUISetIcon("pccomm.ico")

	GUICtrlCreateGroup("PCAT Launcher", 5, 5, 213, 240)
	; Create a label for Combobox
	$oMainGUI("platfLabel") = GUICtrlCreateLabel("Platform:", 28, 37)
    ; Create a combobox control.
    $oMainGUI("platfCombo") = GUICtrlCreateCombo("", 75, 35, 120, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	; Create a label for IP
	$oMainGUI("ipLabel") = GUICtrlCreateLabel("SDP IP:", 31, 67)
	; Create a inputBox for IP address
	$oMainGUI("ipBox") = GUICtrlCreateInput("IP address", 75, 65, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for UPM IP
	$oMainGUI("upmIPLabel") = GUICtrlCreateLabel("UPM IP:", 29, 88)
	; Create a inputBox for UPM IP value
	$oMainGUI("upmIPBox") = GUICtrlCreateInput("UPM IP", 75, 85, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for TimeZone
	$oMainGUI("tzLabel") = GUICtrlCreateLabel("Timezone:", 20, 107)
	; Create a InputBox for Timezone value
	$oMainGUI("tzBox") = GUICtrlCreateInput("Timezone", 75, 105, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for Login
	$oMainGUI("loginLabel") = GUICtrlCreateLabel("Login:", 38, 137)
	; Create an inputBox for Login
	$oMainGUI("loginBox") = GUICtrlCreateInput("", 75, 135, 120, 20)
	; Create a label for Password
	$oMainGUI("passwordLabel") = GUICtrlCreateLabel("Password:", 20, 157)
	; Create an inputBox for Password
	$oMainGUI("passwordBox") = GUICtrlCreateInput("", 75, 155, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	; Create Auto Select Latest Version checkBox
	$oMainGUI("versionCheckBox") = GUICtrlCreateCheckbox("Auto select the latest version", 37, 175, 175, 20, $ES_READONLY)
	; Create a Run button
	$oMainGUI("runButton") = GUICtrlCreateButton("Run PCAT", 115, 205, 85, 25)
	GUICtrlSetImage (-1, "PCAT_ico.ico")
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
	;
	; CCC launcher frame
	GUICtrlCreateGroup("CCC Launcher",223, 5, 213, 240)
	; Create a label for Combobox
	$oMainGUI("cccPlatfLabel") = GUICtrlCreateLabel("Platform:", 248, 37)
    ; Create a combobox control.
    $oMainGUI("cccPlatfCombo") = GUICtrlCreateCombo("", 295, 35, 120, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	; Create a label for IP
	$oMainGUI("sapiIpLabel") = GUICtrlCreateLabel("SAPI IP:", 248, 67)
	; Create a inputBox for IP address
	$oMainGUI("sapiIpBox") = GUICtrlCreateInput("IP address", 295, 65, 120, 40, $ES_MULTILINE)
	; Create a label for Login
	$oMainGUI("cccLoginLabel") = GUICtrlCreateLabel("Login:", 258, 137)
	; Create an inputBox for Login
	$oMainGUI("cccLoginBox") = GUICtrlCreateInput("", 295, 135, 120, 20)
	; Create a label for Password
	$oMainGUI("cccPasswordLabel") = GUICtrlCreateLabel("Password:", 240, 157)
	; Create an inputBox for Password
	$oMainGUI("cccPasswordBox") = GUICtrlCreateInput("", 295, 155, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	; Create a Run button
	$oMainGUI("cccRunButton") = GUICtrlCreateButton("Run CCC", 335, 205, 85, 25)
	GUICtrlSetImage (-1, "mdiicon.ico")
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
	return $oMainGUI
EndFunc

Func _MsgBoxPCATRunning($hApp, $runAppName='')
	MsgBox(4144, $APPNAME & " info", $runAppName & ' "' & WinGetTitle($hApp) & '" is already running!')
EndFunc

Func _MsgBoxPropagateRestricted($sFailedURL)
	$sFailedURL = StringReplace($CLIENTURL, "{{UPM_IP}}", $sFailedURL)
	MsgBox(4144,"PCAT commander info", 'WARNING!!!' & @CRLF & 'DO NOT PROPAGATE IN THIS PCAT SESSION!' & @CRLF & _
					'The "client.connect.URL = ' & $sFailedURL & '" failed to load.' & @CRLF & _
					'It means that probably propagation job will not start.' & @CRLF & _
					'Check that UPM is alive and "workpoint-client.properties" file manualy.' & @CRLF & _
					'Meantime, you may perform the changes in PCAT safely.')
EndFunc

