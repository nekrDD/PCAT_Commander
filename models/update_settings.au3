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

	If Not _CreateBackupFile($SETTINGSPATH) Then
		Return SetError(2, 4)
	EndIf

	; Update  workpoint-client.properties
	$sFileContents = FileRead($WPCLIENTPATH)
	If @error Then
		Return SetError(3, 5)
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

	; Update internal.config file
	$sFileContents = FileRead($CONFPATH)
	If @error Then
		Return SetError(3, 1)
	EndIf

	; Replace default_options with new value for -Duser.timezone  and pre-defined recommended java options
	$sNewContents = StringRegExpReplace($sFileContents, '(?m)^default_options=".*"$', 'default_options="-J-Duser.timezone=' & $oPlatfDefault("timezone") & ' ' & $DEFAULTCONF & '"')
	; Remove existing lines with Login And Password and Platform
	$sNewContents = StringRegExpReplace($sNewContents, '(?m)\s+^#pcCommLogin=.*\s+#pcCommPassword=.*\s+#pcCommDefaultPlatform=.*?$', '')
	; Add new lines with Login and Password
	$sNewContents = $sNewContents & @CRLF & "#pcCommLogin=" & $oSettings("login") & @CRLF & "#pcCommPassword=" & $oSettings("password") & @CRLF & "#pcCommDefaultPlatform=" & $oPlatfDefault("name")

	; rewriting the file
	If Not _RewriteFile($CONFPATH, $sNewContents) Then
		Return SetError(2, 1)
	EndIf
	$sFileContents = ""
	$sNewContents = ""

	; Update pcSettings/jdbc.properties file
	$sFileContents = FileRead($SETTINGSPATH)
	If @error Then
		Return SetError(3, 2)
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

; Check if $sFile backup exists or create backup it
; Returns True at success , False if fails
Func _CreateBackupFile($sFile)
	If FileExists($sFile & ".bkp") = 0 Then
		If Not FileCopy($sFile, $sFile & ".bkp") Then
			Return False
		EndIf
	EndIf
	Return True
EndFunc

; Rewrites content of $sFile with new $sContent
; Returns True if success , False if fails
Func _RewriteFile($sFile, $sContent)
	If Not FileDelete($sFile) Or Not FileWrite($sFile, $sContent) Then
		Return False
	EndIf
	Return True
EndFunc
