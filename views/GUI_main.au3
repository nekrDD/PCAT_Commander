#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <TrayConstants.au3>

; Create GUI Function
Func _MainGUI()
	Local $oMainGUI = ObjCreate("Scripting.Dictionary")
    ; Create a GUI
    $oMainGUI("mainWindow") = GUICreate("PCAT Commander v" & $APPVERSION, 220, 220)
	GUISetIcon("pccomm.ico")
	; Create a label for Combobox
	$oMainGUI("platfLabel") = GUICtrlCreateLabel("Platform:", 28, 12)
    ; Create a combobox control.
    $oMainGUI("platfCombo") = GUICtrlCreateCombo("", 75, 10, 120, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	; Create a label for IP
	$oMainGUI("ipLabel") = GUICtrlCreateLabel("SDP IP:", 31, 42)
	; Create a inputBox for IP address
	$oMainGUI("ipBox") = GUICtrlCreateInput("IP address", 75, 40, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for UPM IP
	$oMainGUI("upmIPLabel") = GUICtrlCreateLabel("UPM IP:", 29, 63)
	; Create a inputBox for UPM IP value
	$oMainGUI("upmIPBox") = GUICtrlCreateInput("UPM IP", 75, 60, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for TimeZone
	$oMainGUI("tzLabel") = GUICtrlCreateLabel("Timezone:", 20, 82)
	; Create a InputBox for Timezone value
	$oMainGUI("tzBox") = GUICtrlCreateInput("Timezone", 75, 80, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	; Create a label for Login
	$oMainGUI("loginLabel") = GUICtrlCreateLabel("Login:", 38, 112)
	; Create an inputBox for Login
	$oMainGUI("loginBox") = GUICtrlCreateInput("", 75, 110, 120, 20)
	; Create a label for Password
	$oMainGUI("passwordLabel") = GUICtrlCreateLabel("Password:", 20, 132)
	; Create an inputBox for Password
	$oMainGUI("passwordBox") = GUICtrlCreateInput("", 75, 130, 120, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	; Create Auto Select Latest Version checkBox
	$oMainGUI("versionCheckBox") = GUICtrlCreateCheckbox("Auto select the latest version", 37, 160, $ES_READONLY)
	; Create a Run button
	$oMainGUI("runButton") = GUICtrlCreateButton("Run PCAT", 115, 190, 85, 25)
	return $oMainGUI
EndFunc

Func _MsgBoxPCATRunning($hPCAT)
	MsgBox(4144,"PCAT commander info", 'PCAT "' & WinGetTitle($hPCAT) & '" is already running!')
EndFunc

Func _MsgBoxPropagateRestricted($sFailedURL)
	$sFailedURL = StringReplace($CLIENTURL, "{{UPM_IP}}", $sFailedURL)
	MsgBox(4144,"PCAT commander info", 'WARNING!!!' & @CRLF & 'DO NOT PROPAGATE IN THIS PCAT SESSION!' & @CRLF & _
					'The "client.connect.URL = ' & $sFailedURL & '" failed to load.' & @CRLF & _
					'It means that probably propagation job will not start.' & @CRLF & _
					'Check that UPM is alive and "workpoint-client.properties" file manualy.' & @CRLF & _
					'Meantime, you may perform the changes in PCAT safely.')
EndFunc

Func _SetTray()
	Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
	Opt("TrayMenuMode", 1) ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
	; TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "TrayEvent")
EndFunc

Func _TrayTip($sMessage, $iTimeout, $sTipType=1)
	Const $TITLE = "PCAT Commander"
	TrayTip($TITLE, $sMessage, $iTimeout, $sTipType)
EndFunc