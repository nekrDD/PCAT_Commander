; This Function updates jdbc.properties file with relevant IP
; And internal.conf default_options with relevant -Duser.timezone
; Accepts timeZoone and IP as parameters
; Returns None at success, sets @error if fails to update the file.

Func _UpdateSettings($oPlatfDefault, $oSettings)
	Local $sConf, $sSettings, $sOutput
	;ConsoleWrite("running update config...")

	; Check if PCAT config  exists
	If Not FileExists($CONFPATH) Then
		Return SetError(1, 1)
	EndIf

	; Check if pcSettings exists
	If Not FileExists($SETTINGSPATH) Then
		Return SetError(1, 2)
	EndIf

	; Create internal.config and jdbc.properties backups if they don't exist
	If Not _CreateBackupFile($CONFPATH) Then
		Return SetError(2, 3)
	EndIf

	If Not _CreateBackupFile($SETTINGSPATH) Then
		Return SetError(2, 4)
	EndIf

	; Update internal.config file
	$sConf = FileRead($CONFPATH)
	If @error Then
		Return SetError(3, 1)
	EndIf

	; Replace default_options with new value for -Duser.timezone  and pre-defined recommended java options
	$sOutput = StringRegExpReplace($sConf, '(?m)^default_options=".*"$', 'default_options="-J-Duser.timezone=' & $oPlatfDefault("timezone") & ' ' & $DEFAULTCONF & '"')
	; Remove existing lines with Login And Password and Platform
	$sOutput = StringRegExpReplace($sOutput, '(?m)^#pcCommLogin=.*\s+#pcCommPassword=.*\s+#pcCommDefaultPlatform=.*?$', '')
	; Add new lines with Login and Password
	$sOutput = $sOutput & "#pcCommLogin=" & $oSettings("login") & @CRLF & "#pcCommPassword=" & $oSettings("password") & @CRLF & "#pcCommDefaultPlatform=" & $oPlatfDefault("name")

	; rewriting the file
	If Not _RewriteFile($CONFPATH, $sOutput) Then
		Return SetError(2, 1)
	EndIf
	$sConf = ""
	$sOutput = ""

	; Update pcSettings/jdbc.properties file
	$sSettings = FileRead($SETTINGSPATH)
	If @error Then
		Return SetError(3, 2)
	EndIf

	; Replace IP with a new value
	$sOutput = StringRegExpReplace($sSettings, '(?m)^jdbc.url=jdbc:oracle:thin:@.+?:1521:pcat$', 'jdbc.url=jdbc:oracle:thin:@' & $oPlatfDefault("IP") & ':1521:pcat')
	;ConsoleWrite($sOutput)
	; rewriting the file
	If Not _RewriteFile($SETTINGSPATH, $sOutput) Then
		Return SetError(2, 2)
	EndIf
	$sConf = ""
	$sOutput = ""

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
