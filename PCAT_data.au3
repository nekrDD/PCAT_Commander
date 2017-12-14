#include <File.au3>

Global $sAppDir, $sConfPath, $sAppPath, $sSettingsPath, $arPlatforms, $sDefaultConf, $oPlatfDefault, _
		$sLogin, $sPassword, $bVersion, $sIP

$sLogin = ""

$sPassword = ""

$iVersion = 1

$sDefaultConf = "-J-XX:NewRatio=2 -J-XX:NewSize=100m -J-XX:MaxNewSize=320m -J-Xms416m -J-Xmx1024m -J-XX:PermSize=128m -J-XX:MaxPermSize=256m -J-Xverify:none -J-Dnetbeans.logger.console=true -J-ea -J-XX:+HeapDumpOnOutOfMemoryError -J-XX:HeapDumpPath=D: -J-Xloggc:D:/gc.log -J-verbose:gc -J-XX:+PrintGCDateStamps -J-XX:+PrintGCDetails"

$sAppDir = "C:\Program Files (x86)\Comverse\CBS-PC\"

$sAppPath = _PathFull("internal\bin\Product Catalog.exe", $sAppDir)

$sConfPath = _PathFull("internal\etc\internal.conf", $sAppDir)

$sSettingsPath = _PathFull("pcSettings\jdbc.properties", @UserProfileDir)

; ConsoleWrite (@UserProfileDir & " " & @ProgramFilesDir)
; ConsoleWrite($sConfPath & @CRLF)
; ConsoleWrite($sSettingsPath & @CRLF)

Global $arPlatforms[11]
For $i = 0 To UBound($arPlatforms) - 1
	$arPlatforms[$i] = ObjCreate("Scripting.Dictionary")
Next

$arPlatforms[0]("name") = "SRT"
$arPlatforms[0]("IP") = "172.25.186.232"
$arPlatforms[0]("timezone") = "GMT+3"

$arPlatforms[1]("name") = "CNT"
$arPlatforms[1]("IP") = "192.168.89.73"
$arPlatforms[1]("timezone") = "GMT+3"

$arPlatforms[2]("name") = "MSK"
$arPlatforms[2]("IP") = "192.168.105.112"
$arPlatforms[2]("timezone") = "GMT+3"

$arPlatforms[3]("name") = "BER"
$arPlatforms[3]("IP") = "192.168.111.3"
$arPlatforms[3]("timezone") = "GMT+3"

$arPlatforms[4]("name") = "KHB"
$arPlatforms[4]("IP") = "172.27.12.105"
$arPlatforms[4]("timezone") = "GMT+10"

$arPlatforms[5]("name") = "SPB"
$arPlatforms[5]("IP") = "172.26.132.40"
$arPlatforms[5]("timezone") = "GMT+3"

$arPlatforms[6]("name") = "EKT"
$arPlatforms[6]("IP") = "10.127.130.120"
$arPlatforms[6]("timezone") = "GMT+2"

$arPlatforms[7]("name") = "RST"
$arPlatforms[7]("IP") = "172.26.35.125"
$arPlatforms[7]("timezone") = "GMT+3"

$arPlatforms[8]("name") = "NSK"
$arPlatforms[8]("IP") = "172.27.214.139"
$arPlatforms[8]("timezone") = "GMT+7"

$arPlatforms[9]("name") = "MERCURY"
$arPlatforms[9]("IP") = "192.168.91.154"
$arPlatforms[9]("timezone") = "GMT+3"

$arPlatforms[10]("name") = "JUPITER"
$arPlatforms[10]("IP") = "172.21.30.150"
$arPlatforms[10]("timezone") = "GMT+3"


; Define default Platform
$oPlatfDefault = ObjCreate("Scripting.Dictionary")
$oPlatfDefault = $arPlatforms[0]


