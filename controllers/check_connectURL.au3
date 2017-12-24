#cs
	This module is intended to send request to client.connect.URL from workpoint-client.poperties
	and get a response
	A template for the client.connect.URL is defined in the "../models/constatnts.au3" module as $CLIENTURL
#ce

#include <InetConstants.au3>
;#include "../models/constants.au3" ; uncomment this line to test as separate module (see example at the end of module)

; Sends request to client.connect.URL using the $CLIENTURL template
; Returns a request handler
Func _SendRequestConnectURL($sUpmIp)
	Local $sClientURL = StringReplace($CLIENTURL, "{{UPM_IP}}", $sUpmIp)
	;ConsoleWrite($sClientURL & @CRLF)
	Local $hRequest = InetGet($sClientURL, "", $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Return $hRequest
EndFunc

; Gets a response for request handler
; Returns a response (true on success, false on fail) or None if request not completed yet
Func _GetResponseURL($hRequest)
	If InetGetInfo($hRequest, $INET_DOWNLOADCOMPLETE) Then
		Return InetGetInfo($hRequest,  $INET_DOWNLOADSUCCESS)
	EndIf
	Return
EndFunc

#cs
$hReq = _SendRequestConnectURL("172.25.186.93")
Do
	sleep(250)
	ConsoleWrite("response: " & _GetResponseURL($hReq) & @CRLF)

Until _GetResponseURL($hReq) <> Null
#ce
