; This Function updates jdbc.properties file with relevant IP
; And internal.conf default_options with relevant -Duser.timezone
; Accepts timeZoone and IP as parameters
; Returns None at success, sets @error if fails to update the file.

#include "PCAT_data.au3"

Func _GetSettings()
	; Temp array for regExp matches
	Local $arTemp

	; Check if PCAT config  exists
	If Not FileExists($sConfPath) Then
		Return SetError(1, 1)
	EndIf
	; Check if pcSettings exists
	If Not FileExists($sSettingsPath) Then
		Return SetError(1, 2)
	EndIf

	; Get IP from pcSettings/jdbc.properties file
	$sSettings = FileRead($sSettingsPath)
	If @error Then
		Return SetError(3, 2)
	EndIf
	; Set global $sIP variable to the value from jdbc.properties
	$arTemp = StringRegExp($sSettings, '(?m)^(jdbc.url=jdbc:oracle:thin:@)(.+?):1521:pcat$', $STR_REGEXPARRAYMATCH)
	If Not @error Then $sIP = $arTemp[1]

	; Get Platform, Login and Password from internal.config file
	$sConf = FileRead($sConfPath)
	If @error Then
		Return SetError(3, 1)
	EndIf
	; Set global $sPlatform variable to the value from internal.config
	Local $arTemp = StringRegExp($sConf, '(?m)^(#pcCommDefaultPlatform=)(.*$)', $STR_REGEXPARRAYMATCH)
	If Not @error Then $sPlatformFromConfig = $arTemp[1]

	; Set global $sLogin and $sPassword variables to the values from internal.config
	Local $arTemp = StringRegExp($sConf, '(?m)^(#pcCommLogin=)(.*$)', $STR_REGEXPARRAYMATCH)
	If Not @error Then $sLogin = $arTemp[1]

	If $sLogin Then
		; Set global $sPassword variable to the value from internal.config
		$arTemp = StringRegExp($sConf, '(?m)^(#pcCommPassword=)(.*$)', $STR_REGEXPARRAYMATCH)
		If Not @error Then $sPassword = $arTemp[1]
	EndIf
	;ConsoleWrite($sIP & " " & $sLogin & " " & $sPassword & @CRLF)

EndFunc

;_UpdateInternalConf("test", "1.1.1.1")

Func _UpdateInternalConf($sTimezone, $sIP, $sPlatform)
	Local $sConf, $sSettings, $sOutput
	;ConsoleWrite("running update config...")

	; Check if PCAT config  exists
	If Not FileExists($sConfPath) Then
		Return SetError(1, 1)
	EndIf

	; Check if pcSettings exists
	If Not FileExists($sSettingsPath) Then
		Return SetError(1, 2)
	EndIf

	; Create internal.config and jdbc.properties backups if they don't exist
	If Not _CreateBackupFile($sConfPath) Then
		Return SetError(2, 3)
	EndIf

	If Not _CreateBackupFile($sSettingsPath) Then
		Return SetError(2, 4)
	EndIf

	; Update internal.config file
	$sConf = FileRead($sConfPath)
	If @error Then
		Return SetError(3, 1)
	EndIf

	; Replace default_options with new value for -Duser.timezone  and pre-defined recommended java options
	$sOutput = StringRegExpReplace($sConf, '(?m)^default_options=".*"$', 'default_options="-J-Duser.timezone=' & $sTimezone & ' ' & $sDefaultConf & '"')
	; Remove existing lines with Login And Password
	$sOutput = StringRegExpReplace($sOutput, '(?m)^#pcCommLogin=.*\s+#pcCommPassword=.*?$', '')
	; Add new lines with Login and Password
	$sOutput = $sOutput & "#pcCommLogin=" & $sLogin & @CRLF & "#pcCommPassword=" & $sPassword & @CRLF & "#pcCommDefaultPlatform=" & $sPlatform

	; rewriting the file
	If Not _RewriteFile($sConfPath, $sOutput) Then
		Return SetError(2, 1)
	EndIf
	$sConf = ""
	$sOutput = ""

	; Update pcSettings/jdbc.properties file
	$sSettings = FileRead($sSettingsPath)
	If @error Then
		Return SetError(3, 2)
	EndIf

	; Replace IP with a new value
	$sOutput = StringRegExpReplace($sSettings, '(?m)^jdbc.url=jdbc:oracle:thin:@.+?:1521:pcat$', 'jdbc.url=jdbc:oracle:thin:@' & $sIP & ':1521:pcat')
	;ConsoleWrite($sOutput)
	; rewriting the file
	If Not _RewriteFile($sSettingsPath, $sOutput) Then
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
