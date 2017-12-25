Func _ReadSettings()
	Local $oSettings = ObjCreate("Scripting.Dictionary")
	$oSettings("selectVersion") = 1 ; hardcoded autoselect version option
	; Temp array for regExp matches
	Local $arTemp, $sFileContents

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

	; Get client.connect.URL from workpoint-client.properties
	;$sFileContents = FileRead($WPCLIENTPATH)
	;If @error Then
	;	Return SetError(3, 5)
	;EndIf

	; Set $oSettings connectURL to the value from jdbc.properties
	;$arTemp = StringRegExp($sFileContents, '(?m)^(\s*client.connect.URL\s*=\s*)(.+?)$', $STR_REGEXPARRAYMATCH)
	;If Not @error Then $oSettings("connectURL") = $arTemp[1]

	; Get IP from pcSettings/jdbc.properties file
	$sFileContents = FileRead($SETTINGSPATH)
	If @error Then
		Return SetError(3, 2)
	EndIf

	; Set IP  to the value from jdbc.properties
	$arTemp = StringRegExp($sFileContents, '(?m)^(jdbc.url=jdbc:oracle:thin:@)(.+?):1521:pcat$', $STR_REGEXPARRAYMATCH)
	If Not @error Then $oSettings("ip") = $arTemp[1]

	; Get Platform, Login and Password from internal.config file
	$sFileContents = FileRead($CONFPATH)
	If @error Then
		Return SetError(3, 1)
	EndIf

	; Set global Login and Password Settings to the values from internal.config
	Local $arTemp = StringRegExp($sFileContents, '(?m)^(#pcCommLogin=)(.*$)', $STR_REGEXPARRAYMATCH)
	If Not @error Then $oSettings("login") = $arTemp[1]

	If $oSettings("login") Then
		; Set global $sPassword variable to the value from internal.config
		$arTemp = StringRegExp($sFileContents, '(?m)^(#pcCommPassword=)(.*$)', $STR_REGEXPARRAYMATCH)
		If Not @error Then $oSettings("password") = $arTemp[1]
	EndIf
	; ConsoleWrite($oSettings("connectURL") & @CRLF)
	Return $oSettings

EndFunc