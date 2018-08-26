#include './file_func.au3'

; This Function updates:
;	jdbc.properties file with platform's IP
;	internal.conf default_options with platform's TZ (-Duser.timezone)
; Accepts default platform and settings objects as parameters
; Returns None at success, sets @error if fails to update the file.

Func _UpdateSettings($oPlatfDefault, $oSettings)
	Local $sFileContents, $sFileContents, $sNewContents
	;ConsoleWrite("running update config...")

	; Check if PCAT config  exists
	If Not FileExists($CONFPATH) Then
		Return SetError(1, 1)
	EndIf

	; Check if pcSettings exists
	If Not FileExists($SETTINGSPATH) Then
		Return SetError(1, 2)
	EndIf

	; Check if workpoint-client.properties exists
	If Not FileExists($WPCLIENTPATH) Then
		Return SetError(1, 5)
	EndIf

	; Create internal.config, jdbc.properties and workpoint-client.properties backups if they don't exist
	If Not _CreateBackupFile($WPCLIENTPATH) Then
		Return SetError(2, 6)
	EndIf

	If Not _CreateBackupFile($CONFPATH) Then
		Return SetError(2, 6)
	EndIf

	If Not _CreateBackupFile($SETTINGSPATH) Then
		Return SetError(2, 4)
	EndIf

	; Read  workpoint-client.properties
	$sFileContents = FileRead($WPCLIENTPATH)
	If @error Then
		Return SetError(3, 5)
	EndIf

	; Check that `client.connect.URL=` string exists in $sFileContents
	If Not StringRegExp($sFileContents, '(?m)^\s*client.connect.URL\s*=\s*http://.*$') Then
		Return SetError(9, 5)
	EndIf

	; Replace UPM IP with a new value
	$sNewContents = StringRegExpReplace($sFileContents, '(?m)^\s*client.connect.URL\s*=\s*http://.*$', 'client.connect.URL = http://' & _
															$oPlatfDefault("UPM_IP") & ':8800/wp/wpClientServlet')
	;ConsoleWrite($sNewContents)
	; rewriting the file
	If Not _RewriteFile($WPCLIENTPATH, $sNewContents) Then
		Return SetError(2, 5)
	EndIf
	$sFileContents = ""
	$sNewContents = ""

	; Read internal.config file
	$sFileContents = FileRead($CONFPATH)
	If @error Then
		Return SetError(3, 1)
	EndIf

	; Check that default_options string exists in $sFileContents
	If Not StringRegExp($sFileContents, '(?m)^default_options=\s*".*"\s*$') Then
		Return SetError(7, 1)
	EndIf

	; Update timezone settings in default_options
	$sNewContents = StringRegExpReplace($sFileContents, '-J-Duser.timezone=.*?\s+', '') ; remove all timezone settings from the file
	$sNewContents = StringRegExpReplace($sNewContents, '(?m)^default_options=\s*"(.*)"$', 'default_options="-J-Duser.timezone=' & $oPlatfDefault("timezone") & ' $1"')
	; Remove existing lines for #pcComm settings
	$sNewContents = StringRegExpReplace($sNewContents, '(?m)(\s+^#pcComm.*$)*', '')
	; Add new lines with Login and Password
	$sNewContents = $sNewContents & @CRLF & "#pcCommLogin=" & $oSettings("login") & @CRLF & "#pcCommPassword=" & $oSettings("password")

	; rewriting the file
	If Not _RewriteFile($CONFPATH, $sNewContents) Then
		Return SetError(2, 1)
	EndIf
	$sFileContents = ""
	$sNewContents = ""

	; Read pcSettings/jdbc.properties file
	$sFileContents = FileRead($SETTINGSPATH)
	If @error Then
		Return SetError(3, 2)
	EndIf

	; Check that `jdbc.url=` string exists in $sFileContents
	If Not StringRegExp($sFileContents, '(?m)^jdbc.url=jdbc:oracle:thin:@.+?:1521:pcat$') Then
		Return SetError(8, 2)
	EndIf

	; Replace IP with a new value
	$sNewContents = StringRegExpReplace($sFileContents, '(?m)^jdbc.url=jdbc:oracle:thin:@.+?:1521:pcat$', 'jdbc.url=jdbc:oracle:thin:@' & $oPlatfDefault("IP") & ':1521:pcat')
	;ConsoleWrite($sNewContents)
	; rewriting the file
	If Not _RewriteFile($SETTINGSPATH, $sNewContents) Then
		Return SetError(2, 2)
	EndIf
	$sFileContents = ""
	$sNewContents = ""

	Return
EndFunc


