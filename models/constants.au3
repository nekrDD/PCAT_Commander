#include-once
#include <File.au3>

Global Const $APPVERSION = "2.0"
Global Const $APPNAME = "C1 Commander"
Global Const $APPURL = "https://github.com/weehaa/PCAT_Commander/blob/master/"

Local Const $PCATDIR = _PathFull("Comverse\CBS-PC\", @ProgramFilesDir)
Local Const $CCCDIR = _PathFull("Comverse\ComverseONE CCC\", @ProgramFilesDir)

Global Const $PCATPATH = _PathFull("internal\bin\Product Catalog.exe", $PCATDIR)
Global Const $CCCPATH = _PathFull("Comverse.CCBS.CCC.exe", $CCCDIR)
Global Const $CONFPATH = _PathFull("internal\etc\internal.conf", $PCATDIR)
Global Const $CCCCONFPATH = _PathFull("Comverse.CCBS.CCC.exe.config", $CCCDIR)
Global Const $SETTINGSPATH = _PathFull("pcSettings\jdbc.properties", @UserProfileDir)
Global Const $WPCLIENTPATH = _PathFull("pcSettings\workpoint-client.properties", @UserProfileDir)
; $DEFAULTCONF is deprecated in versions 1.2.3 and later
Global Const $DEFAULTCONF = "-J-XX:NewRatio=2 -J-XX:NewSize=100m -J-XX:MaxNewSize=320m -J-Xms1024m -J-Xmx1128m -J-XX:PermSize=128m -J-XX:MaxPermSize=512m -J-Xverify:none -J-Dnetbeans.logger.console=true -J-ea -J-XX:+HeapDumpOnOutOfMemoryError -J-XX:HeapDumpPath=D: -J-Xloggc:D:/gc.log -J-verbose:gc -J-XX:+PrintGCDateStamps -J-XX:+PrintGCDetails"
Global Const $CLIENTURL = "http://{{UPM_IP}}:8800/wp/wpClientServlet"
