#include <File.au3>
Global $sAppDir, $sConfPath, $sAppPath, $sSettingsPath, $arPlatforms, $sDefaultConf, $sPlatformFromConfig, _
		$oPlatfDefault, $sLogin, $sPassword, $bVersion, $sIP

;$sLogin = ""

;$sPassword = ""

$iVersion = 1

$sDefaultConf = "-J-XX:NewRatio=2 -J-XX:NewSize=100m -J-XX:MaxNewSize=320m -J-Xms416m -J-Xmx1024m -J-XX:PermSize=128m -J-XX:MaxPermSize=256m -J-Xverify:none -J-Dnetbeans.logger.console=true -J-ea -J-XX:+HeapDumpOnOutOfMemoryError -J-XX:HeapDumpPath=D: -J-Xloggc:D:/gc.log -J-verbose:gc -J-XX:+PrintGCDateStamps -J-XX:+PrintGCDetails"

$sAppDir = "C:\Program Files (x86)\Comverse\CBS-PC\"

$sAppPath = _PathFull("internal\bin\Product Catalog.exe", $sAppDir)

$sConfPath = _PathFull("internal\etc\internal.conf", $sAppDir)

$sSettingsPath = _PathFull("pcSettings\jdbc.properties", @UserProfileDir)


ConsoleWrite(@ProgramFilesDir)
MsgBox(4096, "title", @ProgramFilesDir)