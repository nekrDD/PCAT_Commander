Local $oPlatfDefault = ObjCreate("Scripting.Dictionary")

Local $arPlatforms[11]

For $i = 0 To UBound($arPlatforms) - 1
	$arPlatforms[$i] = ObjCreate("Scripting.Dictionary")
Next

$arPlatforms[0]("name") = "SRT"
$arPlatforms[0]("IP") = "172.25.186.232"
$arPlatforms[0]("timezone") = "GMT+3"
$arPlatforms[0]("connectURL") = "http://vip-upm-srt.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[1]("name") = "CNT"
$arPlatforms[1]("IP") = "192.168.89.73"
$arPlatforms[1]("timezone") = "GMT+3"
$arPlatforms[1]("connectURL") = "http://vip-upm-cr.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[2]("name") = "MSK"
$arPlatforms[2]("IP") = "192.168.105.112"
$arPlatforms[2]("timezone") = "GMT+3"
$arPlatforms[2]("connectURL") = "http://vip-upm-main.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[3]("name") = "BER"
$arPlatforms[3]("IP") = "192.168.111.3"
$arPlatforms[3]("timezone") = "GMT+3"
$arPlatforms[3]("connectURL") = "http://vip_upm.ber.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[4]("name") = "KHB"
$arPlatforms[4]("IP") = "172.27.12.105"
$arPlatforms[4]("timezone") = "GMT+10"
$arPlatforms[4]("connectURL") = "http://vip-upm-khb.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[5]("name") = "SPB"
$arPlatforms[5]("IP") = "172.26.132.40"
$arPlatforms[5]("timezone") = "GMT+3"
$arPlatforms[5]("connectURL") = "http://vip-upm-spb.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[6]("name") = "EKT"
$arPlatforms[6]("IP") = "10.127.130.120"
$arPlatforms[6]("timezone") = "GMT+2"
$arPlatforms[6]("connectURL") = "http://vip-upm-ural.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[7]("name") = "RST"
$arPlatforms[7]("IP") = "172.26.35.125"
$arPlatforms[7]("timezone") = "GMT+3"
$arPlatforms[7]("connectURL") = "http://172.26.35.24:8800/wp/wpClientServlet"  ; need to be checked

$arPlatforms[8]("name") = "NSK"
$arPlatforms[8]("IP") = "172.27.214.139"
$arPlatforms[8]("timezone") = "GMT+7"
$arPlatforms[8]("connectURL") = "http://vip-upm-nsk.vimpelcom.ru:8800/wp/wpClientServlet"

$arPlatforms[9]("name") = "MERCURY"
$arPlatforms[9]("IP") = "192.168.91.154"
$arPlatforms[9]("timezone") = "GMT+3"
$arPlatforms[9]("connectURL") = "http://192.168.112.49:8800/wp/wpClientServlet"

$arPlatforms[10]("name") = "JUPITER"
$arPlatforms[10]("IP") = "172.21.30.150"
$arPlatforms[10]("timezone") = "GMT+3"
$arPlatforms[10]("connectURL") = "http://172.21.30.160:8800/wp/wpClientServlet"

; Create string for PlatfCombo
Func  _ConcatPlatfNames()
	Local $sPatforms
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

; Set default Platform
Func _SetDefaultPlatform($oNewPlatfDefault)
	$oPlatfDefault = $oNewPlatfDefault
	Return $oPlatfDefault
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
