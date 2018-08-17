
Local $oCccSettings = ObjCreate("Scripting.Dictionary")
;_ReadCccSettings()
Func _ReadCccSettings()

	; Check if CCC config  exists
	If Not FileExists($CCCCONFPATH) Then
		Return SetError(1, 7)
	EndIf

	; Get Platform, Login and Password from internal.config file
	$sFileContents = FileRead($CCCCONFPATH)
	If @error Then
		Return SetError(3, 7)
	EndIf

	; Define regexp patterns to look for in the file
	$oCccSettings("login") = '(?m)^(<!--cccCommLogin=)(.*)(-->$)'
	$oCccSettings("password") = '(?m)^(<!--cccCommPassword=)(.*)(-->$)'
	$oCccSettings("platform") = '(?m)^(<!--cccCommPlatform=)(.*)(-->$)'

	; Set Login, Password  and Platform Settings to the values from Comverse.CCBS.CCC.exe.config
	_GetParams($sFileContents, $oCccSettings)
	Local $vKey
	For $vKey in $oCccSettings
		ConsoleWrite($oCccSettings($vKey) & @CRLF)
	Next
EndFunc




; Function to get parameters from file using provided param - pattern dictionary and replace the pattern with extracted values(or set blank if not found)
Func _GetParams($sFileContents, $oPatterns)
	For $vKey In $oPatterns
		Local $arTemp = StringRegExp($sFileContents, $oPatterns.Item($vKey), $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$oPatterns($vKey) = $arTemp[1]
		Else
			$oPatterns($vKey) = ''
		EndIf
	Next
EndFunc
