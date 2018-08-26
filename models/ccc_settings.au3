#include-once
#include './file_func.au3'
#include "./constants.au3"
#include "./platforms.au3"

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
		ConsoleWrite("$oCccSettings(" & $vKey & ") = " & $oCccSettings($vKey) & @CRLF)
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

Func _UpdateCccSettings($sSapi)
	; Check if CCC config  exists
	If Not FileExists($CCCCONFPATH) Then
		Return SetError(1, 7)
	EndIf

	; Create CCC config backup if doesn't exist
	If Not _CreateBackupFile($CCCCONFPATH) Then
		Return SetError(2, 7)
	EndIf

	; Read CCC config file
	$sFileContents = FileRead($CCCCONFPATH)
	If @error Then
		Return SetError(3, 7)
	EndIf
	Local $sSapiPattern = '(?m)^(\s*<setting name\s*=\s*"SAPIServiceEndPoint".*?>\s*<value>https://)(.*)(:8001/services/</value>)' ; the second group match is SAPI IP or name
	#cs
	$arTemp = StringRegExp($sFileContents, $sSapiPattern, $STR_REGEXPARRAYMATCH)
	If Not @error Then
		$oPatterns($vKey) = $arTemp[1]
	Else
		$oPatterns($vKey) = ''
	EndIf
	#ce
	Local $sNewContents = StringRegExpReplace($sFileContents, $sSapiPattern, '${1}' & $sSapi & '$3')
	;ConsoleWrite("SAPI replacement: " & @CRLF & $1 @CRLF
	If Not @extended Then
		ConsoleWrite ("Error updating SapiEndPoint!" & @CRLF)
		Return SetError(10, 7) ; return error if not updated
	EndIf
	;ConsoleWrite ("regexp match extended: " & @extended & @CRLF); & $sNewContents & @CRLF)
	; Remove existing lines for #cccComm settings
	$sNewContents = StringRegExpReplace($sNewContents, '(?m)(\s+^<!--cccComm.*-->$)*', '')
	; Add new lines with Login and Password
	$sNewContents = $sNewContents & @CRLF & "<!--cccCommLogin=" & $oCccSettings("login") & "-->" & @CRLF & _
											"<!--cccCommPassword=" & $oCccSettings("password")  & "-->" & @CRLF & _
											"<!--cccCommPlatform=" & $oCccSettings("platform")  & "-->"
	; rewriting the file
	If Not _RewriteFile($CCCCONFPATH, $sNewContents) Then
		ConsoleWrite ("Error writing to CCC config!")
		Return SetError(2, 7)
	EndIf
EndFunc

; Run this func for testing
; Test()
Func Test()
	Local $oCccPlatform = _GetCccPlatform()
	Local $sSapi = $oCccPlatform("sapi")
	_UpdateCccSettings($sSapi)
EndFunc