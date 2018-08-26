#include-once
; File processing functions

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