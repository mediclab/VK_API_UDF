#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "../API/VK_API.au3"

Global $sSt, $sFriends, $iApp_ID = 2672631

$aAuth = _VK_SignIn($iApp_ID,"audio,status")

GUICreate("Testing API UDF VKontakte", 621, 444, 192, 124)
$Pic1 = GUICtrlCreatePic("", 8, 8, 201, 417)
$idStatus = GUICtrlCreateEdit("", 224, 32, 393, 65, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
GUICtrlSetData($idStatus,_VK_statusGet())
$ChangeStatus = GUICtrlCreateButton("Сменить статус", 488, 104, 121, 25)
$Hello = GUICtrlCreateLabel("Добро пожаловать! ", 224, 8, 107, 17)
GUICtrlCreateGroup("Последние аудиозаписи:", 224, 144, 385, 121)
$aAudios = _VK_audioGet()
$sAudios = ""
;_ArrayDisplay($aAudios)
;$aFriends = _VK_friendsGet("","full")
;_ArrayDisplay($aFriends)
For $i = 1 to 5
		$sAudios &= $aAudios[$i][2] & " - " & $aAudios[$i][3] & @CRLF
Next
$Last_Audio = GUICtrlCreateLabel($sAudios, 240, 168, 356, 81)
GUICtrlCreateGroup("Последние новости:", 224, 280, 385, 145)
$Last_News = GUICtrlCreateLabel("", 240, 304, 356, 105)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ChangeStatus
			_VK_statusSet(GUICtrlRead($idStatus))
			GUICtrlSetData($idStatus,_VK_statusGet())
	EndSwitch
WEnd

