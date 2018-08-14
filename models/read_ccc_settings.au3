#include './constants.au3'
#include <StringConstants.au3>
Local $oCccSettings = ObjCreate("Scripting.Dictionary")
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

	; Set Login and Password Settings to the values from internal.config
	Local $arTemp = StringRegExp($sFileContents, '(?m)^(<!--cccCommLogin=)(.*)(-->$)', $STR_REGEXPARRAYMATCH)
	If Not @error Then $oCccSettings("login") = $arTemp[1]
	ConsoleWrite($oCccSettings("login") & @CRLF)
EndFunc

_ReadCccSettings()



