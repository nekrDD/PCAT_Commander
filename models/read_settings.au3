Func _ReadSettings()
	Local $oSettings = ObjCreate("Scripting.Dictionary")
	; Temp array for regExp matches
	Local $arTemp

	; Check if PCAT config  exists
	If Not FileExists($CONFPATH) Then
		Return SetError(1, 1)
	EndIf
	; Check if pcSettings exists
	If Not FileExists($SETTINGSPATH) Then
		Return SetError(1, 2)
	EndIf

	; Get IP from pcSettings/jdbc.properties file
	$sSettings = FileRead($SETTINGSPATH)
	If @error Then
		Return SetError(3, 2)
	EndIf
	; Set global $sIP variable to the value from jdbc.properties
	$arTemp = StringRegExp($sSettings, '(?m)^(jdbc.url=jdbc:oracle:thin:@)(.+?):1521:pcat$', $STR_REGEXPARRAYMATCH)
	If Not @error Then $oSettings("ip") = $arTemp[1]

	; Get Platform, Login and Password from internal.config file
	$sConf = FileRead($CONFPATH)
	If @error Then
		Return SetError(3, 1)
	EndIf
	; Set global $sPlatform variable to the value from internal.config
	Local $arTemp = StringRegExp($sConf, '(?m)^(#pcCommDefaultPlatform=)(.*$)', $STR_REGEXPARRAYMATCH)
	If Not @error Then $oSettings("platfname") = $arTemp[1]

	; Set global $sLogin and $sPassword variables to the values from internal.config
	Local $arTemp = StringRegExp($sConf, '(?m)^(#pcCommLogin=)(.*$)', $STR_REGEXPARRAYMATCH)
	If Not @error Then $oSettings("login") = $arTemp[1]

	If $oSettings("login") Then
		; Set global $sPassword variable to the value from internal.config
		$arTemp = StringRegExp($sConf, '(?m)^(#pcCommPassword=)(.*$)', $STR_REGEXPARRAYMATCH)
		If Not @error Then $oSettings("password") = $arTemp[1]
	EndIf
	Return $oSettings
	;ConsoleWrite($sIP & " " & $sLogin & " " & $sPassword & @CRLF)
EndFunc