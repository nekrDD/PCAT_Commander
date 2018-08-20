#include-once

#include <TrayConstants.au3>

#include "../models/constants.au3"

Func _SetTray()
	Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
	Opt("TrayMenuMode", 1) ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
	; TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "TrayEvent")
EndFunc

Func _TrayTip($sMessage, $iTimeout, $sTipType=1)
	TrayTip($APPNAME, $sMessage, $iTimeout, $sTipType)
EndFunc

;_SetTray()
;_TrayTip("TEST", 3000)


