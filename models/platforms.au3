#include-once

Local Const $SAPI = "SOAPFARM" ; default sapi to connect
Local $oCccPlatform = ObjCreate("Scripting.Dictionary")
Local $oPlatfDefault = ObjCreate("Scripting.Dictionary")

Local $arPlatforms[11]

For $i = 0 To UBound($arPlatforms) - 1
	$arPlatforms[$i] = ObjCreate("Scripting.Dictionary")
Next

$arPlatforms[0]("name") = "SRT"
$arPlatforms[0]("IP") = "172.25.186.232"
$arPlatforms[0]("timezone") = "GMT+3"
$arPlatforms[0]("UPM_IP") = "172.25.186.93"
$arPlatforms[0]("sapi") = $SAPI & "-srt.vimpelcom.ru"

$arPlatforms[1]("name") = "CNT"
$arPlatforms[1]("IP") = "192.168.89.73"
$arPlatforms[1]("timezone") = "GMT+3"
$arPlatforms[1]("UPM_IP") = "192.168.89.84"
$arPlatforms[1]("sapi") = $SAPI & "-cr.vimpelcom.ru"

$arPlatforms[2]("name") = "MSK"
$arPlatforms[2]("IP") = "192.168.105.94"
$arPlatforms[2]("timezone") = "GMT+3"
$arPlatforms[2]("UPM_IP") = "192.168.113.113"
$arPlatforms[2]("sapi") = $SAPI & "-main.vimpelcom.ru"

$arPlatforms[3]("name") = "BER"
$arPlatforms[3]("IP") = "192.168.111.3"
$arPlatforms[3]("timezone") = "GMT+3"
$arPlatforms[3]("UPM_IP") = "192.168.111.122"
$arPlatforms[3]("sapi") = $SAPI & ".ber.vimpelcom.ru"

$arPlatforms[4]("name") = "KHB"
$arPlatforms[4]("IP") = "172.27.12.105"
$arPlatforms[4]("timezone") = "GMT+10"
$arPlatforms[4]("UPM_IP") = "172.27.12.60"
$arPlatforms[4]("sapi") = $SAPI & "-khb.vimpelcom.ru"

$arPlatforms[5]("name") = "SPB"
$arPlatforms[5]("IP") = "172.26.132.40"
$arPlatforms[5]("timezone") = "GMT+3"
$arPlatforms[5]("UPM_IP") = "172.26.132.67"
$arPlatforms[5]("sapi") = $SAPI & "-spb.vimpelcom.ru"

$arPlatforms[6]("name") = "EKT"
$arPlatforms[6]("IP") = "10.127.130.120"
$arPlatforms[6]("timezone") = "GMT+5"
$arPlatforms[6]("UPM_IP") = "10.127.130.90"
$arPlatforms[6]("sapi") = $SAPI & "-ural.vimpelcom.ru"

$arPlatforms[7]("name") = "RST"
$arPlatforms[7]("IP") = "172.26.35.127"
$arPlatforms[7]("timezone") = "GMT+3"
$arPlatforms[7]("UPM_IP") = "172.26.35.24"
$arPlatforms[7]("sapi") = $SAPI & "-rst.vimpelcom.ru"

$arPlatforms[8]("name") = "NSK"
$arPlatforms[8]("IP") = "172.27.214.139"
$arPlatforms[8]("timezone") = "GMT+7"
$arPlatforms[8]("UPM_IP") = "172.27.214.57"
$arPlatforms[8]("sapi") = $SAPI & "-nsk.vimpelcom.ru"

$arPlatforms[9]("name") = "MERCURY"
$arPlatforms[9]("IP") = "192.168.91.153"
$arPlatforms[9]("timezone") = "GMT+3"
$arPlatforms[9]("UPM_IP") = "192.168.106.49"
$arPlatforms[9]("sapi") = ""

$arPlatforms[10]("name") = "YUPITER"
$arPlatforms[10]("IP") = "172.21.30.150"
$arPlatforms[10]("timezone") = "GMT+3"
$arPlatforms[10]("UPM_IP") = "172.21.30.160"
$arPlatforms[10]("sapi") = "172.21.30.179"

; Create string for PlatfCombo
Func  _ConcatPlatfNames()
	Local $sPatforms = ''
	For $i = 0 To UBound($arPlatforms) - 1
		$sPatforms = $sPatforms & $arPlatforms[$i]("name") & "|"
	Next
	Return $sPatforms
EndFunc

; Get default Platform
Func _GetDefaultPlatform()
	If not $oPlatfDefault("name") Then $oPlatfDefault = $arPlatforms[0]
	Return $oPlatfDefault
EndFunc

Func _GetCccPlatform()
	If not $oCccPlatform("name") Then $oCccPlatform = $arPlatforms[0]
	Return $oCccPlatform
EndFunc


; Set default Platform
Func _SetDefaultPlatform($oNewPlatfDefault)
	$oPlatfDefault = $oNewPlatfDefault
	Return $oPlatfDefault
EndFunc

; Find platform object by requested name.
; If not found, return default platform object
Func _GetPlatfbyName($sPlatfName)
	For $i = 0 To UBound($arPlatforms) - 1
		If $arPlatforms[$i]("name") = $sPlatfName Then
			Return $arPlatforms[$i]
		EndIf
	Next
	Return $oPlatfDefault
EndFunc

; Find platform object by IP.
; If not found, return default platform object
Func _GetPlatfbyIP($sPlatfIP)
	For $i = 0 To UBound($arPlatforms) - 1
		If $arPlatforms[$i]("IP") = $sPlatfIP Then
			Return $arPlatforms[$i]
		EndIf
	Next
	Return $oPlatfDefault
EndFunc
