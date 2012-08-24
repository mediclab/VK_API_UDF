#include <IE.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>

Func _VK_SignIn($iAppID, $sScope, $sRedirect_uri = "http://api.vkontakte.ru/blank.html", $sDisplay = "wap", $sResponse_type = "token")
	Local $sOAuth_url = "http://api.vkontakte.ru/oauth/authorize?client_id=" & $iAppID & "&scope=" & $sScope & "&redirect_uri=" & $sRedirect_uri & "&display=" & $sDisplay & "&response_type=" & $sResponse_type
	Return __guiAccessToken($sOAuth_url, "ВКонтакте | Вход", $sRedirect_uri)
EndFunc

#region Users Functions

Func _VK_getProfiles($_sAccessToken, $_sUIDs, $_sFields = "", $_sName_case = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/getProfiles.xml?uid=" & $_sUIDs & "&fields=" & $_sFields & "&name_case=" & $_sName_case & "&access_token=" & $_sAccessToken), 4)
EndFunc

Func _VK_getUserSettings($_sAccessToken)
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/getUserSettings.xml?access_token=" & $_sAccessToken), 4)
EndFunc

#endregion User Functions

Func _VK_getAudio($_sAccessToken,$uid = "", $gid = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/audio.get.xml?access_token=" & $_sAccessToken & "&uid=" & $uid & "&gid=" & $gid), 4)
EndFunc

#region Friends Functions

Func _VK_friendsGet($_sAccessToken, $_sUID = "", $_sFields = "", $_sName_case = "", $_iCount = "", $_sOffset = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.get.xml?uid=" & $_sUID & "&fields=" & $_sFields & "&name_case=" & $_sName_case & "&count=" & $_iCount & "&offset=" & $_sOffset & "&access_token=" & $_sAccessToken), 4)
EndFunc

Func _VK_friendsGetOnline($_sAccessToken, $_sUID = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.getOnline.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken), 4)
EndFunc

Func _VK_friendsAddList($_sAccessToken, $sName, ByRef $sArray)
	Local $sFriendsdotString = ""
	For $i = 0 To UBound($sArray) - 1
		$sFriendsdotString &= $sArray[$i] & ","
	Next
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.addList.xml?access_token=" & $_sAccessToken & "&name=" & $sName & "&uids=" & $sFriendsdotString), 4)
EndFunc

#endregion Friends Functions

#region Status Functions

Func _VK_statusGet($_sAccessToken, $_sUID = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/status.get.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken), 4)
EndFunc

Func _VK_statusSet($_sAccessToken, $_sText = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/status.set.xml?text=" & $_sText & "&access_token=" & $_sAccessToken), 4)
EndFunc

#endregion Status Functions
#region Photos Functions

Func _VK_photosGetAlbums($_sAccessToken, $_sUID = "", $_iIDs = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAlbums.xml?uid=" & $_sUID & "&aids=" & $_iIDs & "&access_token=" & $_sAccessToken), 4)
EndFunc

Func _VK_photosGet($_sAccessToken, $_sUID, $_iID, $_iPIDs = "", $_iExtended = "", $_iLimit = "", $_iOffset = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.get.xml?uid=" & $_sUID & "&aid=" & $_iID & "&pids=" & $_iPIDs & "&extended=" & $_iExtended & "&limit=" & $_iLimit & "&offset=" & $_iOffset & "&access_token=" & $_sAccessToken), 4)
EndFunc

Func _VK_photosGetById($_sAccessToken, $_sPhotos, $_iExtended = "")
	Return BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getById.xml?photos=" & $_sPhotos & "&extended=" & $_iExtended & "&access_token=" & $_sAccessToken), 4)
EndFunc

#endregion Photos Functions
#region Internal Functions

Func __guiAccessToken($_sURI, $_sGUITitle, $_sRedirect_uri)
	Local $oIE = _IECreateEmbedded()
	Local $hTimer = TimerInit()

	$_hATgui = GUICreate($_sGUITitle, 400, 300, -1, -1, $WS_SYSMENU)
	GUICtrlCreateObj($oIE, 5, 5, 385, 260)

	_IENavigate($oIE, $_sURI)
	$sResponse = _IEBodyReadText($oIE)

	If StringInStr($sResponse, "access_token=") Then
		Return __responseParse($sResponse)
	EndIf

	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Return SetError(1,0,1)
		EndSwitch

		If TimerDiff($hTimer) > 250 Then
			$sURL = _IEPropertyGet($oIE, "locationurl")
			If StringInStr($sURL, $_sRedirect_uri & "#") Then
				GUISetState(@SW_HIDE)
				$sResponse = _IEBodyReadText($oIE)
				If StringInStr($sResponse, "access_token=") Then
					GUIDelete($_hATgui)
					Return __responseParse($sResponse)
				Else
					GUIDelete($_hATgui)
					Return SetError(-1,0,-1)
				EndIf
			EndIf
			$hTimer = TimerInit()
		EndIf
	WEnd
EndFunc

Func __responseParse($_sResponse)
	Local $aNArray = StringSplit($_sResponse, "&"), $aResArray[UBound($aNArray)]
	$aResArray[0] = UBound($aNArray)-1

	For $i = 1 To $aNArray[0]
		$_sStr = StringSplit($aNArray[$i], "=")
		$aResArray[$i] = $_sStr[2]
	Next

	Return $aResArray
EndFunc

#endregion Internal Functions

;VK