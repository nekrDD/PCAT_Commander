#include <File.au3>

Global Const $APPVERSION = "1.1"

Local Const $PCATDIR = _PathFull("Comverse\CBS-PC\", @ProgramFilesDir)

Global Const $PCATPATH = _PathFull("internal\bin\Product Catalog.exe", $PCATDIR)
Global Const $CONFPATH = _PathFull("internal\etc\internal.conf", $PCATDIR)
Global Const $SETTINGSPATH = _PathFull("pcSettings\jdbc.properties", @UserProfileDir)
Global Const $WPCLIENTPATH = _PathFull("pcSettings\workpoint-client.properties", @UserProfileDir)
Global Const $DEFAULTCONF = "-J-XX:NewRatio=2 -J-XX:NewSize=100m -J-XX:MaxNewSize=320m -J-Xms416m -J-Xmx1024m -J-XX:PermSize=128m -J-XX:MaxPermSize=256m -J-Xverify:none -J-Dnetbeans.logger.console=true -J-ea -J-XX:+HeapDumpOnOutOfMemoryError -J-XX:HeapDumpPath=D: -J-Xloggc:D:/gc.log -J-verbose:gc -J-XX:+PrintGCDateStamps -J-XX:+PrintGCDetails"
Global Const $CLIENTURL = "http://{{UPM_IP}}:8800/wp/wpClientServlet"
