#include-once
#include <IE.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>


;Opt("MustDeclareVars",1)
#cs
	photos.editAlbum – обновляет данные альбома для фотографий.
	photos.edit – изменяет описание у выбранной фотографии.
	photos.move – переносит фотографию из одного альбома в другой.
	photos.makeCover – делает фотографию обложкой альбома.
	photos.reorderAlbums – меняет порядок альбома в списке альбомов пользователя.
	audio.getById – возвращает информацию об аудиозаписях по их идентификаторам.
	audio.getLyrics - возвращает текст аудиозаписи.
	audio.getUploadServer – возвращает адрес сервера для загрузки аудиозаписей.
	audio.save – сохраняет аудиозаписи после успешной загрузки.
	audio.search – осуществляет поиск по аудиозаписям.
	audio.add – копирует существующую аудиозапись на страницу пользователя или группы.
	audio.delete – удаляет аудиозапись со страницы пользователя или группы.
#ce

; #FUNCTION# =================================================================================================
; Name...........: _VK_SignIn()
; Description ...: Совершает авторизацию на сайте ВКонтакте
; Syntax.........: _VK_SignIn($iAppID, $sScope, $sRedirect_uri = "http://api.vkontakte.ru/blank.html", $sDisplay = "wap", $sResponse_type = "token")
; Parameters ....: $iAppID - App ID приложения полученного на сайте ВКонтакте
;    			   $sScope - Битовые маски для доступа к разным возможностям ВКонтакте (Будут указаны к описаниям функций)
;				   $sRedirect_uri -
;				   $sDisplay -
;				   $sResponse_type -
; Return values .: При удачной Авторизации возвращает ключ доступа для использованя остальных функций
; Author ........: Fever
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _VK_SignIn($iAppID, $sScope, $sRedirect_uri = "http://api.vkontakte.ru/blank.html", $sDisplay = "popup", $sResponse_type = "token")
	Local $sOAuth_url = "http://api.vkontakte.ru/oauth/authorize?client_id=" & $iAppID & "&scope=" & $sScope & "&redirect_uri=" & $sRedirect_uri & "&display=" & $sDisplay & "&response_type=" & $sResponse_type
	Return __guiAccessToken($sOAuth_url, "ВКонтакте | Вход", $sRedirect_uri)
EndFunc   ;==>_VK_SignIn

#region Users Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_getProfiles()
; Description ...: Возвращает расширенную информацию о пользователях.
; Syntax.........: _VK_getProfiles($_sAccessToken, $_sUIDs, $_sFields = "", $_sName_case = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации
;                  $_sUIDs - Идентификаторы пользователей или их короткие имена (screen_name). Максимум 1000 пользователей.
;				   Значения могут быть переданы либо в виде строки, где идентификаторы перечислены через запятую, либо в виде массива
;                  $_sFields - перечисленные через запятую поля анкет, которые необходимо получить. По умолчанию все возможные поля.
;				   $_sName_case - падеж для склонения имени и фамилии пользователя. По умолчанию Именительный падеж.
;						Возможные значения: именительный – nom, родительный – gen, дательный – dat, винительный – acc, творительный – ins, предложный – abl.
; Return values .: Успех - Массив с данными aFullArray[$Count][$CountFields] - где
;						$Count - порядковый номер полученного пользователя
;						$CountFields - порядковый номер поля, который идет по порядку, как он был указан. По умолчанию:
;							0 - uid (идентификатор пользователя)
;							1 - first_name (Имя)
;							2 - last_name (Фамилия)
;							3 - sex (Пол: 1 - женский, 2 - мужской, 0 - без указания пола. )
;							4 - online (Статус:  0 - пользователь не в сети, 1 - пользователь в сети. )
;							5 - bdate (Дата рождения. Выдаётся в формате: "23.11.1981" или "21.9" (если год скрыт). Если дата рождения скрыта целиком, то ячейка пустая)
;							6 - city (Выдаётся id города. Название города по его id можно узнать при помощи функции getCities. Если город не указан, то ячейка пустая)
;							7 - country (Выдаётся id страны. Название страны по её id можно узнать при помощи метода getCountries. Если страна не указана, то ячейка пустая)
;							8 - photo (Выдаётся url фотографии пользователя, имеющей ширину 50 пикселей.)
;							9 - photo_medium (Выдаётся url фотографии пользователя, имеющей ширину 100 пикселей.)
;							10 - photo_medium_rec (Выдаётся url квадратной фотографии пользователя, имеющей ширину 50 пикселей.)
;							11 - photo_big (Выдаётся url фотографии пользователя, имеющей ширину 200 пикселей.)
;							12 - photo_rec (Выдаётся url квадратной фотографии пользователя, имеющей ширину 50 пикселей.)
;							13 - screen_name (Возвращает короткий адрес страницы (возвращается только имя адреса, например andrew). Если пользователь не менял адрес своей страницы, возвращается 'id'+uid, например id35828305)
;							14 - has_mobile (Показывает, известен ли номер мобильного телефона пользователя. Возвращаемые значения: 1 - известен, 0 - не известен. )
;							15 - rate (Рейтинг пользователя)
;							16 - home_phone (домашний телефон пользователя)
;							17 - mobile_phone (мобильный телефон пользователя)
;							18 - university (Код университета)
;							19 - university_name (Название университета)
;							20 - faculty (код факультета)
;							21 - faculty_name (Имя факультета)
;							22 - graduation (Год окончания обучения)
;							23 - can_post (Разрешено ли оставлять записи на стене у данного пользователя.)
;							24 - can_write_private_message (Разрешено ли написание личных сообщений данному пользователю. )
;							25 - activity (Возвращает статус, расположенный в профиле, под именем пользователя )
;							26 - relation (Возвращает семейное положение пользователя: 1 - не женат/не замужем 2 - есть друг/есть подруга 3 - помолвлен/помолвлена 4 - женат/замужем 5 - всё сложно 6 - в активном поиске 7 - влюблён/влюблена )
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Подробнее: http://vkontakte.ru/pages?oid=-1&p=getProfiles
;				   Если в списке или в массиве будет более 1000 пользователей, то будет выдана только первая 1000
;				   Если в $_sFields будет указано поле contacts, то будет возвращено 1 дополнительное поле
;				   Если в $_sFields будет указано поле education, то будет возвращено 4 дополнительных поля
; ============================================================================================================
Func _VK_getProfiles($_sAccessToken, $_sUIDs, $_sFields = "", $_sName_case = "")
	Local $sUIDsDots = "", $sResponse, $aFields, $aUIDs, $nCount, $aTemp, $aUsers

	If $_sFields = "" Then $_sFields = "uid,first_name,last_name,sex,online,bdate,city,country,photo,photo_medium,photo_medium_rec," _
			 & "photo_big,photo_rec,screen_name,has_mobile,rate,contacts,education,can_post,can_write_private_message,activity,relation"

	$aFields = StringReplace($_sFields, "contacts", "home_phone,mobile_phone")
	$aFields = StringReplace($aFields, "education", "university,university_name,faculty,faculty_name,graduation")

	$aFields = StringSplit($aFields, ",", 2)

	If Not IsArray($_sUIDs) Then
		$aUIDs = StringRegExpReplace($_sUIDs, "^[,\h]+|[,\h]+$", "")
		$aUIDs = StringSplit($aUIDs, ",", 2)
	Else
		$aUIDs = $_sUIDs
	EndIf

	If UBound($aUIDs) > 1000 Then
		$nCount = 1000
	Else
		$nCount = UBound($aUIDs)
	EndIf

	For $i = 0 To $nCount - 1
		If $aUIDs[$i] <> "" Then
			$sUIDsDots &= StringStripWS($aUIDs[$i], 8) & ","
		EndIf
	Next

	$sUIDsDots = StringRegExpReplace($sUIDsDots, "^[,\h]+|[,\h]+$", "")
	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/getProfiles.xml?uids=" & $sUIDsDots & "&fields=" & $_sFields & "&name_case=" & $_sName_case & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		Dim $aFullArray[$nCount][UBound($aFields)]

		$aUsers = _CreateArray($sResponse, "user")

		For $i = 0 To UBound($aFields) - 1
			For $j = 0 To UBound($aUsers) - 1
				$aTemp = _CreateArray($aUsers[$j], StringStripWS($aFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_getProfiles

; #FUNCTION# =================================================================================================
; Name...........: _VK_getUserSettings()
; Description ...: Получает настройки текущего пользователя в данном приложении.
; Syntax.........: _VK_getUserSettings($_sAccessToken)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации
;				   $_sUID - Идентификатор пользователя. По умолчанию Идентификатор текущего пользователя.
; Return values .: Успех - Строка с битовой маской и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _VK_getUserSettings($_sAccessToken, $_sUID = "")
	Local $sReturn, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/getUserSettings.xml?access_token=" & $_sAccessToken & "&uid=" & $_sUID), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "settings")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_getUserSettings

; #FUNCTION# =================================================================================================
; Name...........: _VK_getUserBalance()
; Description ...: Возвращает баланс текущего пользователя на счету приложения в сотых долях голоса.
; Syntax.........: _VK_getUserBalance($_sAccessToken)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
; Return values .: Успех - Строка с балансом пользователя и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Если функция возвращает 350, это означает, что на балансе пользователя в данном приложении три с половиной голоса.
; ============================================================================================================
Func _VK_getUserBalance($_sAccessToken)
	Local $sReturn, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/getUserBalance.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "balance")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_getUserBalance

#endregion Users Functions

#region Friends Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_friendsGet()
; Description ...: Возвращает список идентификаторов друзей пользователя или расширенную информацию о друзьях пользователя
; Syntax.........: _VK_friendsGet($_sAccessToken, $_sUID = "", $_sFields = "", $_sName_case = "", $_iCount = "", $_sOffset = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sUID - Идентификатор пользователя, друзей которого необходимо получить. По умолчанию - текущий пользователь
;                  $_sFields - Поля анкет, которые необходимо получить. По умолчанию только Идентификаторы пользователей. Если указано full то выдает двумерный массив из 27 полей
;                  $_sName_case - падеж для склонения имени и фамилии пользователя. По умолчанию Именительный падеж.
;						Возможные значения: именительный – nom, родительный – gen, дательный – dat, винительный – acc, творительный – ins, предложный – abl.
;                  $_iCount - количество друзей, которое нужно вернуть. По умолчанию – все друзья
;                  $_sOffset - смещение, необходимое для выборки определенного подмножества друзей.
; Return values .: Успех - Массив с данными aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученного пользователя
;						$CountFields - порядковый номер поля. По умолчанию:
;							0 - uid (идентификатор пользователя)(если $_sFields = "", то выведет только этот массив)
;							1 - first_name (Имя)
;							2 - last_name (Фамилия)
;							3 - sex (Пол: 1 - женский, 2 - мужской, 0 - без указания пола. )
;							4 - online (Статус:  0 - пользователь не в сети, 1 - пользователь в сети. )
;							5 - bdate (Дата рождения. Выдаётся в формате: "23.11.1981" или "21.9" (если год скрыт). Если дата рождения скрыта целиком, то ячейка пустая)
;							6 - city (Выдаётся id города. Название города по его id можно узнать при помощи функции getCities. Если город не указан, то ячейка пустая)
;							7 - country (Выдаётся id страны. Название страны по её id можно узнать при помощи метода getCountries. Если страна не указана, то ячейка пустая)
;							8 - photo (Выдаётся url фотографии пользователя, имеющей ширину 50 пикселей.)
;							9 - photo_medium (Выдаётся url фотографии пользователя, имеющей ширину 100 пикселей.)
;							10 - photo_medium_rec (Выдаётся url квадратной фотографии пользователя, имеющей ширину 50 пикселей.)
;							11 - photo_big (Выдаётся url фотографии пользователя, имеющей ширину 200 пикселей.)
;							12 - photo_rec (Выдаётся url квадратной фотографии пользователя, имеющей ширину 50 пикселей.)
;							13 - screen_name (Возвращает короткий адрес страницы (возвращается только имя адреса, например andrew). Если пользователь не менял адрес своей страницы, возвращается 'id'+uid, например id35828305)
;							14 - has_mobile (Показывает, известен ли номер мобильного телефона пользователя. Возвращаемые значения: 1 - известен, 0 - не известен. )
;							15 - rate (Рейтинг пользователя)
;							16 - home_phone (домашний телефон пользователя)
;							17 - mobile_phone (мобильный телефон пользователя)
;							18 - university (Код университета)
;							19 - university_name (Название университета)
;							20 - faculty (код факультета)
;							21 - faculty_name (Имя факультета)
;							22 - graduation (Год окончания обучения)
;							23 - can_post (Разрешено ли оставлять записи на стене у данного пользователя.)
;							24 - can_write_private_message (Разрешено ли написание личных сообщений данному пользователю. )
;							25 - activity (Возвращает статус, расположенный в профиле, под именем пользователя )
;							26 - relation (Возвращает семейное положение пользователя: 1 - не женат/не замужем 2 - есть друг/есть подруга 3 - помолвлен/помолвлена 4 - женат/замужем 5 - всё сложно 6 - в активном поиске 7 - влюблён/влюблена )
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
;				   Если в $_sFields будет указано поле contacts, то будет возвращено 1 дополнительное поле
;				   Если в $_sFields будет указано поле education, то будет возвращено 4 дополнительных поля
; ============================================================================================================
Func _VK_friendsGet($_sAccessToken, $_sUID = "", $_sFields = "", $_sName_case = "", $_iCount = "", $_sOffset = "")
	Local $aFields, $sResponse, $aTemp, $aUsers

	If $_sFields = "" Then
		$_sFields = "uid"
	ElseIf $_sFields = "full" Then
		$_sFields = "uid,first_name,last_name,sex,online,bdate,city,country,photo,photo_medium,photo_medium_rec," _
				 & "photo_big,photo_rec,screen_name,has_mobile,rate,contacts,education,can_post,can_write_private_message,activity,relation"
	EndIf

	$aFields = StringReplace($_sFields, "contacts", "home_phone,mobile_phone")
	$aFields = StringReplace($aFields, "education", "university,university_name,faculty,faculty_name,graduation")

	$aFields = StringSplit($aFields, ",", 2)


	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.get.xml?uid=" & $_sUID & "&fields=" & $_sFields & "&name_case=" & $_sName_case & "&count=" & $_iCount & "&offset=" & $_sOffset & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aUsers = _CreateArray($sResponse, "user")

		Dim $aFullArray[UBound($aUsers)][UBound($aFields)]

		For $i = 0 To UBound($aFields) - 1
			For $j = 0 To UBound($aUsers) - 1
				$aTemp = _CreateArray($aUsers[$j], StringStripWS($aFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_friendsGet

; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsGetOnline()
; Description ...: Возвращает список идентификаторов, находящихся на сайте друзей, текущего пользователя.
; Syntax.........: _VK_friendsGetOnline($_sAccessToken, $_sUID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sUID - Идентификатор пользователя, друзей которого необходимо получить. По умолчанию - текущий пользователь
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsGetOnline($_sAccessToken, $_sUID = "")
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.getOnline.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsGetOnline

; #FUNCTION# =================================================================================================
; Name...........: _VK_friendsGetMutual()
; Description ...: Возвращает список идентификаторов общих друзей между парой пользователей.
; Syntax.........: _VK_friendsGetMutual($_sAccessToken, $_sTarget_uid, $_sSource_uid = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sTarget_uid - идентификатор пользователя, с которым необходимо искать общих друзей.
;                  $_sSource_uid - идентификатор пользователя, чьи друзья пересекаются с друзьями пользователя с идентификатором target_uid
;				   По умолчанию - текущий пользователь
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsGetMutual($_sAccessToken, $_sTarget_uid, $_sSource_uid = "")
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.getMutual.xml?access_token=" & $_sAccessToken & "&target_uid=" & $_sTarget_uid & "&source_uid=" & $_sSource_uid), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsGetMutual

; #FUNCTION# =================================================================================================
; Name...........: _VK_friendsAddList()
; Description ...: Создает новый список друзей у текущего пользователя.
; Syntax.........: _VK_friendsAddList($_sAccessToken, $sName, $_sUIDs)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $sName - Имя списка
;                  $_sUIDs - Идентификаторы друзей, которых необходимо занести в список
;				   		Можно задавать как массивом, так и перечислением идентификаторов через запятую
; Return values .: Успех - Идентификатор списка и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsAddList($_sAccessToken, $sName, $_sUIDs)
	Local $sUIDsDots = "", $sResponse, $aUIDs, $sReturn

	If Not IsArray($_sUIDs) Then
		$aUIDs = StringRegExpReplace($_sUIDs, "^[,\h]+|[,\h]+$", "")
		$aUIDs = StringSplit($aUIDs, ",", 2)
	Else
		$aUIDs = $_sUIDs
	EndIf

	For $i = 0 To UBound($aUIDs) - 1
		If $aUIDs[$i] <> "" Then
			$sUIDsDots &= StringStripWS($aUIDs[$i], 8) & ","
		EndIf
	Next

	$sUIDsDots = StringRegExpReplace($sUIDsDots, "^[,\h]+|[,\h]+$", "")

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.addList.xml?access_token=" & $_sAccessToken & "&name=" & $sName & "&uids=" & $sUIDsDots), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "lid")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_friendsAddList

#endregion Friends Functions

#region Group Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_groupsGet()
; Description ...: Возвращает список групп указанного пользователя.
; Syntax.........: _VK_groupsGet($_sAccessToken, $iExtended = 0, $_sUID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $iExtended - Возвращение полной информации о группах пользователя. По умолчанию - нет
;                  $_sUID - Идентификатор пользователя у которого нужно получить список групп
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной группы
;						$CountFields - порядковый номер поля:
;							0 - gid (Если $iExtended = 0, то выведет только это поле)
;							1 - name
;							2 - screen_name
;							3 - is_closed
;							4 - is_admin
;							5 - photo
;							6 - photo_medium
;							7 - photo_big
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 262144.
; ============================================================================================================
Func _VK_groupsGet($_sAccessToken, $iExtended = 0, $_sUID = "")
	Local $Temp, $sResponse, $sReturn0, $asFields[8] = ["gid", "name", "screen_name", "is_closed", "is_admin", "photo", "photo_medium", "photo_big"]

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/groups.get.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken & "&extended=" & $iExtended), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn0 = _CreateArray($sResponse, $asFields[0])

		If $iExtended Then
			For $i = 1 To UBound($asFields) - 1
				$Temp = _CreateArray($sResponse, $asFields[$i])
				Assign('sReturn' & $i, $Temp)
			Next
		EndIf

		Dim $aFullArray[UBound($sReturn0)][UBound($asFields)]

		For $i = 0 To UBound($sReturn0) - 1
			For $j = 0 To UBound($asFields) - 1
				$aFullArray[$i][$j] = Execute('$sReturn' & $j & '[$i]')
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_groupsGet

; #FUNCTION# =================================================================================================
; Name...........: _VK_groupsGetByID()
; Description ...: Возвращает информацию о заданной группе или о нескольких группах.
; Syntax.........: _VK_groupsGetByID($_sAccessToken, $_sGIDs)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sGIDs - идентификаторы групп, информацию о которых необходимо получить. Могут быть использованы короткие имена групп.
;			       Значения могут быть переданы либо в виде строки, где идентификаторы перечислены через запятую, либо в виде массива. Максимум 500 групп.
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной группы
;						$CountFields - порядковый номер поля:
;							0 - gid
;							1 - name
;							2 - screen_name
;							3 - is_closed
;							4 - is_admin
;							5 - photo
;							6 - photo_medium
;							7 - photo_big
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 262144.
;				   Если в списке или в массиве будет более 500 групп, то будет выдана только первые 500
; ============================================================================================================
Func _VK_groupsGetByID($_sAccessToken, $_sGIDs)
	Local $sResponse, $asFields[8] = ["gid", "name", "screen_name", "is_closed", "is_admin", "photo", "photo_medium", "photo_big"]
	Local $sGIDsDots, $aGIDs, $nCount, $Temp

	If Not IsArray($_sGIDs) Then
		$aGIDs = StringSplit($_sGIDs, ",", 2)
	Else
		$aGIDs = $_sGIDs
	EndIf

	If UBound($aGIDs) > 500 Then
		$nCount = 500
	Else
		$nCount = UBound($aGIDs)
	EndIf

	For $i = 0 To $nCount - 1
		If $aGIDs[$i] <> "" Then
			$sGIDsDots &= StringStripWS($aGIDs[$i], 8) & ","
		EndIf
	Next

	$sGIDsDots = StringRegExpReplace($sGIDsDots, "^[,\h]+|[,\h]+$", "")
	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/groups.getById.xml?gids=" & $sGIDsDots & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		$aGroups = _CreateArray($sResponse, "group")

		Dim $aFullArray[UBound($aGroups)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aGroups) - 1
				$aTemp = _CreateArray($aGroups[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_groupsGetByID

#endregion Group Functions

#region Audio Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_audioGet()
; Description ...: Возвращает список аудиозаписей пользователя или группы.
; Syntax.........: _VK_audioGet($_sAccessToken, $_sUID = "", $_sGID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_iNeed_User - если этот параметр равен 1, сервер возвратит базовую информацию о владельце аудиозаписей
;                  $_sUID - id пользователя, которому принадлежат аудиозаписи (по умолчанию — текущий пользователь)
;                  $_sGID - id группы, которой принадлежат аудиозаписи. Если указан параметр gid, uid игнорируется.
;                  $_iAlbumID - id альбома, аудиозаписи которого необходимо вернуть (по умолчанию возвращаются аудиозаписи из всех альбомов).
;                  $_sAIDs - перечисленные через запятую id аудиозаписей, входящие в выборку по uid или gid.
;                  $_iCount - количество возвращаемых аудиозаписей.
;                  $_iOffset - смещение относительно первой найденной аудиозаписи для выборки определенного подмножества.
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной аудиозаписи (начиная с 1, нулевой элемент описан ниже)
;						$CountFields - порядковый номер поля. По умолчанию:
;							0 - aid (идентификатор аудиозаписи)
;							1 - owner_id (id пользователя, которому принадлежит аудиозапись)
;							2 - artist (исполнитель аудиозаписи)
;							3 - title (название аудиозаписи)
;							4 - duration (длительность аудиозаписи в секундах)
;							5 - url (ссылка на аудиозапись)
;						[0][0] - количество полученных аудиозаписей.
;						Если $_iNeed_User = 1, то информация о пользователе будет в 0 строке:
;							[0][1] - id (идентификатор пользователя)
;							[0][2] - photo (Выдаётся url фотографии пользователя, имеющей ширину 50 пикселей.)
;							[0][3] - name (Имя Фамилия пользователя)
;							[0][4] - name_gen (Имя пользователя в родительном падеже)
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 8.
;				   Обратите внимание, что ссылки на аудиозаписи привязаны к ip адресу.
; ============================================================================================================
Func _VK_audioGet($_sAccessToken, $_iNeed_User = 0, $_sUID = "", $_sGID = "", $_iAlbumID = "", $_sAIDs = "", $_iCount = "", $_iOffset = "")
	Local $Temp, $sResponse, $asFields[6] = ["aid", "owner_id", "artist", "title", "duration", "url"]
	Local $aOwnerFields[4] = ["id", "photo", "name", "name_gen"]

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/audio.get.xml?access_token=" & $_sAccessToken & "&uid=" & $_sUID & "&gid=" & $_sGID & "&aids=" & $_sAIDs & "&need_user=" & $_iNeed_User & "&album_id=" & $_iAlbumID & "&count=" & $_iCount & "&offset=" & $_iOffset), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		$aAudio = _CreateArray($sResponse, "audio")

		Dim $aFullArray[UBound($aAudio) + 1][UBound($asFields)]

		$aFullArray[0][0] = UBound($aAudio)

		If $_iNeed_User Then
			$aOwner = _CreateArray($sResponse, "user")
			If IsArray($aOwner) Then
				For $i = 0 To UBound($aOwnerFields) - 1
					$Temp = _CreateArray($aOwner[0], $aOwnerFields[$i])
					$aFullArray[0][$i + 1] = $Temp[0]
				Next
			EndIf
		EndIf

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aAudio) - 1
				$aTemp = _CreateArray($aAudio[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j + 1][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_audioGet

#endregion Audio Functions

#region Status Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_statusGet()
; Description ...: Получает статус пользователя.
; Syntax.........: _VK_statusGet($_sAccessToken, $_sUID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sUID - UID пользователя у которого требуется получить статус. По умолчанию - текущий пользователь
; Return values .: Успех - Строка со статусом и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 1024.
; ============================================================================================================
Func _VK_statusGet($_sAccessToken, $_sUID = "")
	Local $sStatus, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/status.get.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sStatus = _CreateArray($sStatus, "text")
		Return $sStatus[0]
	EndIf
EndFunc   ;==>_VK_statusGet

; #FUNCTION# =================================================================================================
; Name...........: _VK_statusSet()
; Description ...: Устанавливает новый статус текущему пользователю.
; Syntax.........: _VK_statusSet($_sAccessToken, $_sText = "")
; Parameters ....: $_sAccessToken - максимальное допустимое значение для секретного ключа в диапазоне
;                  $_sText - текст статуса, который необходимо установить.  По умолчанию - очищение статуса
; Return values .: Успех - 1 и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 1024.
; ============================================================================================================
Func _VK_statusSet($_sAccessToken, $_sText = "")
	Local $sStatus, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/status.set.xml?text=" & $_sText & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sStatus = _CreateArray($sResponse, "response")
		Return $sStatus[0]
	EndIf
EndFunc   ;==>_VK_statusSet

#endregion Status Functions

#region Photos Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetAlbums()
; Description ...: Возвращает список альбомов пользователя.
; Syntax.........:  _VK_photosGetAlbums($_sAccessToken, $_iNeed_Covers = 0 , $_sUID = "", $_sGID = "", $_sAIDs = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_iNeed_Covers - будет возвращено дополнительное поле thumb_src. По умолчанию поле thumb_src не возвращается.
;                  $_sUID - ID пользователя, которому принадлежат альбомы. По умолчанию – ID текущего пользователя.
;				   $_sGID - ID группы, которой принадлежат альбомы.
;				   $_sAIDs - перечисленные через запятую ID альбомов.
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной фотографии
;						$CountFields - порядковый номер поля. По умолчанию:
;							0 - aid (идентификатор альбома)
;							1 - owner_id (идентификатор владельца)
;							2 - title (название альбома)
;							3 - description (описание альбома)
;							4 - created (дата создания)
;							5 - updated (дата обновления)
;							6 - size (количество фотографий в альбоме)
;							7 - privacy (уровень доступа к альбому. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей, 3 - только я.)
;							8 - thumb_id (идентификатор фотографии обложки)
;							9 - thumb_src (url фотографии обложки. Поле выдается только если $_iNeed_Covers равен 1)
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 4.
; ============================================================================================================
Func _VK_photosGetAlbums($_sAccessToken, $_iNeed_Covers = 0, $_sUID = "", $_sGID = "", $_sAIDs = "")
	Local $aTemp, $sResponse, $Temp, $aAlbums

	If $_iNeed_Covers Then
		Dim $asFields[10] = ["aid", "owner_id", "title", "description", "created", "updated", "size", "privacy", "thumb_id", "thumb_src"]
	Else
		Dim $asFields[9] = ["aid", "owner_id", "title", "description", "created", "updated", "size", "privacy", "thumb_id"]
	EndIf

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAlbums.xml?uid=" & $_sUID & "&aids=" & $_sAIDs & "&gid=" & $_sGID & "&need_covers=" & $_iNeed_Covers & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aAlbums = _CreateArray($sResponse, "album")

		Dim $aFullArray[UBound($aAlbums)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aAlbums) - 1
				$aTemp = _CreateArray($aAlbums[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If ($i = 5) Or ($i = 4) Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGetAlbums

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGet
; Description ...: Возвращает список фотографий в альбоме.
; Syntax.........: _VK_photosGet($_sAccessToken, $_sUID, $_sGID, $_sAID, $_iExtended = 0, $_iPIDs = "", $_iLimit = "", $_iOffset = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sUID - ID пользователя, которому принадлежит альбом с фотографиями.
;                  $_sGID - ID группы, которой принадлежит альбом с фотографиями.
;                  $_sAID - ID альбома с фотографиями.
;                  $_iExtended - если равен 1, то будет возвращено дополнительное поле likes. По умолчанию поле likes не возвращается.
;                  $_iPIDs - перечисленные через запятую ID фотографий.
;                  $_iLimit - количество фотографий, которое нужно вернуть. (по умолчанию – все фотографии)
;                  $_iOffset - смещение, необходимое для выборки определенного подмножества фотографий.
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной фотографии
;						$CountFields - порядковый номер поля. По умолчанию:
;							0 - aid (идентификатор альбома)
;							1 - owner_id (идентификатор владельца)
;							2 - src 		====|
;							3 - src_small 		|===|
;							4 - src_big 			|====> url'ы изображений разного качества
;							5 - src_xbig 		|===|
;							6 - src_xxbig 	====|
;							7 - text (подпись к фотографии)
;							8 - created (дата создания)
;							9 - count (количество likes фотографии. Поле выдается только если $_iExtended равен 1)
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 4.
; ============================================================================================================
Func _VK_photosGet($_sAccessToken, $_sUID, $_sGID, $_sAID, $_iExtended = 0, $_iPIDs = "", $_iLimit = "", $_iOffset = "")
	Local $sReturn0, $sResponse, $Temp

	If Not $_sUID Then $_sUID = ""
	If Not $_sGID Then $_sGID = ""

	If $_iExtended Then
		Dim $asFields[10] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created", "count"]
	Else
		Dim $asFields[9] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created"]
	EndIf

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.get.xml?uid=" & $_sUID & "&aid=" & $_sAID & "&gid=" & $_sGID & "&pids=" & $_iPIDs & "&extended=" & $_iExtended & "&limit=" & $_iLimit & "&offset=" & $_iOffset & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		$aPhotos = _CreateArray($sResponse, "photo")

		Dim $aFullArray[UBound($aPhotos)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aPhotos) - 1
				$aTemp = _CreateArray($aPhotos[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If $i = 8 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGet

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetAlbumsCount()
; Description ...: Возвращает количество доступных альбомов пользователя.
; Syntax.........: _VK_photosgetAlbumsCount($_sAccessToken, $_sUID = "", $_sGID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sUID - ID пользователя, которому принадлежат альбомы. По умолчанию – ID текущего пользователя.
;                  $_sGID - ID группы, которой принадлежат альбомы.
; Return values .: Успех - Сткока с количеством альбомов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _VK_photosGetAlbumsCount($_sAccessToken, $_sUID = "", $_sGID = "")
	Local $sCount, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAlbumsCount.xml?uid=" & $_sUID & "&gid=" & $_sGID & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sCount = _CreateArray($sResponse, "response")
		Return $sCount[0]
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetById()
; Description ...: Возвращает информацию о фотографиях по их идентификаторам.
; Syntax.........: _VK_photosGetById($_sAccessToken, $_sPhotos, $_iExtended = 0)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sPhotos - перечисленные через запятую идентификаторы (либо массив), которые представляют собой идущие через
;				   		знак подчеркивания id пользователей, разместивших фотографии, и id самих фотографий. Чтобы получить
;				   		информацию о фотографии в альбоме группы, вместо id пользователя следует указать -id группы.
;                  $_iExtended - если равен 1, то будет возвращено дополнительное поле likes. По умолчанию поле likes не возвращается.
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной фотографии
;						$CountFields - порядковый номер поля. По умолчанию:
;							0 - aid (идентификатор альбома)
;							1 - owner_id (идентификатор владельца)
;							2 - src 		====|
;							3 - src_small 		|===|
;							4 - src_big 			|====> url'ы изображений разного качества
;							5 - src_xbig 		|===|
;							6 - src_xxbig 	====|
;							7 - text (подпись к фотографии)
;							8 - created (дата создания)
;							9 - count (количество likes фотографии. Поле выдается только если $_iExtended равен 1)
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever, Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 4.
; ============================================================================================================
Func _VK_photosGetById($_sAccessToken, $_sPhotos, $_iExtended = 0)
	Local $aPhoto, $sResponse, $aTemp, $sPhotosDots, $aPhotos

	If $_iExtended Then
		Dim $asFields[10] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created", "count"]
	Else
		Dim $asFields[9] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created"]
	EndIf

	If Not IsArray($_sPhotos) Then
		$aPhoto = StringSplit($_sPhotos, ",", 2)
	Else
		$aPhoto = $_sPhotos
	EndIf

	For $i = 0 To UBound($aPhoto) - 1
		If $aPhoto[$i] <> "" Then
			$sPhotosDots &= StringStripWS($aPhoto[$i], 8) & ","
		EndIf
	Next

	$sPhotosDots = StringRegExpReplace($sPhotosDots, "^[,\h]+|[,\h]+$", "")


	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getById.xml?photos=" & $sPhotosDots & "&extended=" & $_iExtended & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aPhotos = _CreateArray($sResponse, "photo")

		Dim $aFullArray[UBound($aPhotos)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aPhotos) - 1
				$aTemp = _CreateArray($aPhotos[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If $i = 8 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGetById

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetAll()
; Description ...: Возвращает все фотографии пользователя или группы в антихронологическом порядке.
; Syntax.........: _VK_photosGetAll($_sAccessToken, $_iExtended = 0, $_sCount = "", $_sOffset = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_iExtended - если равен 1, то будет возвращено дополнительное поле likes. По умолчанию поле likes не возвращается.
;                  $_sOwnerID -идентификатор пользователя (по умолчанию - текущий пользователь). Если передано отрицательное значение,
;								вместо фотографий пользователя будут возвращены все фотографии группы с идентификатором -owner_id.
;                  $_sCount - количество фотографий, которое необходимо получить (но не более 100). По умолчанию 100
;                  $_sOffset - смещение, необходимое для выборки определенного подмножества фотографий.
; Return values .: Успех - Массив с данными  aFullArray[$Count][$CountFields] - где:
;						$Count - порядковый номер полученной фотографии
;						$CountFields - порядковый номер поля. По умолчанию:
;							1 - pid (идентификатор фотографии)
;							1 - aid (идентификатор альбома)
;							2 - owner_id (идентификатор владельца)
;							3 - src 		====|
;							4 - src_small 		|===|
;							5 - src_big 			|====> url'ы изображений разного качества
;							6 - src_xbig 		|===|
;							7 - src_xxbig 	====|
;							8 - text (подпись к фотографии)
;							9 - created (дата создания)
;							10 - count (количество likes фотографии. Поле выдается только если $_iExtended равен 1)
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 4.
; ============================================================================================================
Func _VK_photosGetAll($_sAccessToken, $_iExtended = 0, $_sOwnerID = "", $_sCount = 100, $_sOffset = "")
	Local $sResponse, $aTemp

	If $_sCount > 100 Then $_sCount = 100

	If $_iExtended Then
		Dim $asFields[11] = ["pid", "aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created", "count"]
	Else
		Dim $asFields[10] = ["pid", "aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created"]
	EndIf

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAll.xml?access_token=" & $_sAccessToken & "&count=" & $_sCount & "&owner_id=" & $_sOwnerID & "&extended=" & $_iExtended & "&offset=" & $_sOffset), 4)
	ConsoleWrite($sResponse)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aPhotos = _CreateArray($sResponse, "photo")

		Dim $aFullArray[UBound($aPhotos) + 1][UBound($asFields)]

		$aFullArray[0][0] = UBound($aPhotos)

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aPhotos) - 1
				$aTemp = _CreateArray($aPhotos[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If $i = 9 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j + 1][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGetAll

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosСreateAlbum()
; Description ...: Создает пустой альбом для фотографий.
; Syntax.........: _VK_photosСreateAlbum($_sAccessToken, $_sTitle, $_sDescription = "", $_iPrivacy = 0, $_iComment_Privacy = 0)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sTitle - название альбома.
;                  $_sDescription - текст описания альбома.
;                  $_iPrivacy - уровень доступа к альбому. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей, 3 - только я.
;                  $_iComment_Privacy - уровень доступа к комментированию альбома. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей, 3 - только я.
; Return values .: Успех - Массив с данными  aFullArray[$CountFields] - где:
;						$CountFields - порядковый номер поля. По умолчанию:
;							0 - aid (идентификатор альбома)
;							1 - thumb_id (идентификатор фотографии обложки)
;							2 - owner_id (идентификатор владельца)
;							3 - title (название альбома)
;							4 - description (описание альбома)
;							5 - created (дата создания)
;							6 - updated (дата обновления)
;							7 - size (количество фотографий в альбоме)
;							8 - privacy (уровень доступа к альбому. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей, 3 - только я.)
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 4.
; ============================================================================================================
Func _VK_photosCreateAlbum($_sAccessToken, $_sTitle, $_sDescription = "", $_iPrivacy = 0, $_iComment_Privacy = 0)
	Local $aRetArray, $sResponse
	Dim $asFields[9] = ["aid","thumb_id","owner_id","title","description","created","updated","size","privacy"]

	If Not $_sDescription = "" Then $_sDescription = BinaryToString(StringToBinary($_sDescription, 4))

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.createAlbum.xml?title=" & $_sTitle & "&description=" & $_sDescription & "&privacy=" & $_iPrivacy & "&comment_privacy=" & $_iComment_Privacy & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		For $i = 0 to UBound($asFields) - 1
			$aTemp = _CreateArray($sResponse, $asFields[$i])
			If $i = 6 or $i = 7 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
			$aRetArray[$i] = $aTemp[0]
		Next

		Return $aRetArray
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosEditAlbum()
; Description ...: Создает пустой альбом для фотографий.
; Syntax.........: _VK_photosEditAlbum($_sAccessToken, $_sAID, $_sTitle, $_sDescription = -1, $_iPrivacy = -1, $_iComment_Privacy = -1)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sAID - идентификатор редактируемого альбома.
;                  $_sTitle - новое название альбома.
;                  $_sDescription - новый текст описания альбома.
;                  $_iPrivacy - новый уровень доступа к альбому. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей, 3 - только я.
;                  $_iComment_Privacy - новый уровень доступа к комментированию альбома. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей, 3 - только я.
; Return values .: Успех - 1 и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 4.
; ============================================================================================================
Func _VK_photosEditAlbum($_sAccessToken, $_sAID, $_sTitle, $_sDescription = -1, $_iPrivacy = -1, $_iComment_Privacy = -1)
	Local $sRet, $sResponse, $sQuery = ""

	If Not $_sDescription = -1 Then
		$_sDescription = BinaryToString(StringToBinary($_sDescription, 4))
		$sQuery &= "&description=" & $_sDescription
	EndIf
	If Not $_iPrivacy = -1 Then $sQuery &= "&privacy=" & $_iPrivacy
	If Not $_iComment_Privacy = -1 Then $sQuery &= "&comment_privacy=" & $_iComment_Privacy

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.editAlbum.xml?title=" & $_sTitle & "&access_token=" & $_sAccessToken & $sQuery), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sRet = _CreateArray($sResponse, "response")

		Return $sRet[0]
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount
#endregion Photos Functions

#region Wall Functions
; #FUNCTION# =================================================================================================
; Name...........: _VK_wallPost()
; Description ...: Возвращает все фотографии пользователя или группы в антихронологическом порядке.
; Syntax.........: _VK_wallPost($_sAccessToken, $_sMessage = "", $_sAttashments = "", $_sOwner_ID = "", $_sServices = "", $_sFrom_Group = 0, $_sFriends_Only = 0)
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sMessage - текст сообщения (является обязательным, если не задан параметр attachment)
;                  $_sAttashments - список объектов, приложенных к записи и разделённых символом ",". Поле attachments представляется в формате:
;						<type><owner_id>_<media_id>,<type><owner_id>_<media_id> где:
;							<type> - тип медиа-приложения:
;								photo - фотография
;								video - видеозапись
;								audio - аудиозапись
;								doc - документ
;						<owner_id> - идентификатор владельца медиа-приложения
;						<media_id> - идентификатор медиа-приложения.
;				   $_sOwner_ID - идентификатор пользователя, у которого должна быть опубликована запись. Если параметр не задан, то считается, что он равен идентификатору текущего пользователя.
;                  $_sServices - Список сервисов или сайтов, на которые необходимо экспортировать статус, в случае если пользователь настроил соответствующую опцию. Например twitter, facebook.
;                  $_sFrom_Group - Данный параметр учитывается, если owner_id < 0 (статус публикуется на стене группы). 1 - статус будет опубликован от имени группы, 0 - статус будет опубликован от имени пользователя (по умолчанию).
;                  $_sFriends_Only - 1 - статус будет доступен только друзьям, 0 - всем пользователям. По умолчанию публикуемые статусы доступны всем пользователям.
; Return values .: Успех - Строка с идентификатором записи и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 8192.
; ============================================================================================================
Func _VK_wallPost($_sAccessToken, $_sMessage = "", $_sAttashments = "", $_sOwner_ID = "", $_sServices = "", $_sFrom_Group = 0, $_sFriends_Only = 0)
	Local $sReturn, $sResponse

	If $_sAttashments = "" And $_sMessage = "" Then Return SetError(2, 0, -1)
	If Not $_sMessage = "" Then $_sMessage = BinaryToString(StringToBinary($_sMessage, 4))

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/wall.post.xml?access_token=" & $_sAccessToken & "&message=" & $_sMessage & "&attachments=" & $_sAttashments & "&owner_id=" & $_sOwner_ID & "&services=" & $_sServices & "&from_group=" & $_sFrom_Group & "&friends_only=" & $_sFriends_Only), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "post_id")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_wallPost

; #FUNCTION# =================================================================================================
; Name...........: _VK_wallDelete()
; Description ...: Возвращает все фотографии пользователя или группы в антихронологическом порядке.
; Syntax.........: _VK_wallDelete($_sAccessToken, $_sPost_ID, $_sOwner_ID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;                  $_sPost_ID - идентификатор записи на стене пользователя.
;                  $_sOwnerID - идентификатор пользователя, на чьей стене необходимо удалить запись. Если параметр не задан, то он считается равным идентификатору текущего пользователя.
; Return values .: Успех - 1 и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 8192.
; ============================================================================================================
Func _VK_wallDelete($_sAccessToken, $_sPost_ID, $_sOwner_ID = "")
	Local $sReturn, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/wall.delete.xml?access_token=" & $_sAccessToken & "&post_id=" & $_sPost_ID & "&owner_id=" & $_sOwner_ID), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "response")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_wallDelete
#endregion Wall Functions

#region Likes Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesAdd()
; Description ...: Добавляет указанный объект в список Мне нравится текущего пользователя.
; Syntax.........: _VK_likesAdd($_sAccessToken, $_sType, $_iItem_id, $_sUID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;    			   $_sType - идентификатор типа Like-объекта.
;				   $_iItem_id - идентификатор Like-объекта.
;				   $_sOwnerID - идентификатор владельца Like-объекта. Если параметр не задан, то считается, что он равен идентифкатору текущего пользователя.
; Return values .: Успех - Строка с количеством пользователей, которые добавили данный объект в свой список Мне нравится и @error = 0.
;				   Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever
; Remarks .......: Типы Like-объектов:
;					post - запись на стене пользователя или группы
;					comment - комментарий к записи на стене
;					photo - фотография
;					audio - аудиозапись
;					video - видеозапись
;					note - заметка
;					sitepage - страница сайта, на которой установлен виджет «Мне нравится»
;
;				   Для вызова этого метода Ваше приложение должно иметь права с битовой маской, содержащей 8192.
; ============================================================================================================
Func _VK_likesAdd($_sAccessToken, $_sType, $_iItem_id, $_sOwnerID = "")
	Local $sLikes, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.add.xml?owner_id=" & $_sOwnerID & "&type=" & $_sType & "&item_id" & $_iItem_id & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sLikes = _CreateArray($sResponse, "likes")
		Return $sLikes[0]
	EndIf
EndFunc   ;==>_VK_likesAdd

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesDelete()
; Description ...: Удаляет указанный объект из списка Мне нравится текущего пользователя.
; Syntax.........: _VK_likesDelete($_sAccessToken, $_sType, $_iItem_id, $_sUID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;				   $_sType - идентификатор типа Like-объекта.
;				   $_iItem_id - идентификатор Like-объекта.
;				   $_sOwnerID - идентификатор владельца Like-объекта. Если параметр не задан, то считается, что он равен идентифкатору текущего пользователя.
; Return values .: Успех - Строка с количеством пользователей, которые добавили данный объект в свой список Мне нравится и @error = 0.
;				   Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever
; Remarks .......: Типы Like-объектов:
;					post - запись на стене пользователя или группы
;					comment - комментарий к записи на стене
;					photo - фотография
;					audio - аудиозапись
;					video - видеозапись
;					note - заметка
;					sitepage - страница сайта, на которой установлен виджет «Мне нравится»
;
;				   Для вызова этого метода Ваше приложение должно иметь права с битовой маской, содержащей 8192.
; ============================================================================================================
Func _VK_likesDelete($_sAccessToken, $_sType, $_iItem_id, $_sOwnerID = "")
	Local $sLikes, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.delete.xml?owner_id=" & $_sOwnerID & "&type=" & $_sType & "&item_id" & $_iItem_id & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sLikes = _CreateArray($sResponse, "likes")
		Return $sLikes[0]
	EndIf
EndFunc   ;==>_VK_likesDelete

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesIsLiked()
; Description ...: Проверяет находится ли объект в списке Мне нравится заданного пользователя.
; Syntax.........: _VK_likesIsLiked($_sAccessToken, $_sType, $_iItem_id, $_sUserID = "", $_sOwnerID = "")
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;				   $_sType - идентификатор типа Like-объекта.
;				   $_iItem_id - идентификатор Like-объекта.
;				   $_sUserID - идентификатор пользователя у которого необходимо проверить наличие объекта в списке Мне нравится.
;				   Если параметр не задан, то считается, что он равен идентификатору текущего пользователя.
;				   $_sOwnerID - идентификатор владельца Like-объекта. Если параметр не задан, то считается, что он равен идентифкатору текущего пользователя.
; Return values .: Успех - @error = 0, Возвращает одно из следующих значений:
;				   		0 – указанный Like-объект не входит в список Мне нравится пользователя с идентификатором user_id.
;				   		1 – указанный Like-объект находится в списке Мне нравится пользователя с идентификатором user_id.
;				   Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever
; Remarks .......: Типы Like-объектов:
;					post - запись на стене пользователя или группы
;					comment - комментарий к записи на стене
;					photo - фотография
;					audio - аудиозапись
;					video - видеозапись
;					note - заметка
;					sitepage - страница сайта, на которой установлен виджет «Мне нравится»
;
;				   Для вызова этого метода Ваше приложение должно иметь права с битовой маской, содержащей 8192.
; ============================================================================================================
Func _VK_likesIsLiked($_sAccessToken, $_sType, $_iItem_id, $_sUserID = "", $_sOwnerID = "")
	Local $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.isLiked.xml?user_id=" & $_sUserID & "&owner_id=" & $_sOwnerID & "&type=" & $_sType & "&item_id" & $_iItem_id & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sResponse = _CreateArray($sResponse, "response")
		Return $sResponse[0]
	EndIf
EndFunc   ;==>_VK_likesIsLiked

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesGetList()
; Description ...: Получает список идентификаторов пользователей, которые добавили заданный объект в свой список Мне нравится.
; Syntax.........: _VK_likesGetList($_sType, $_sOwnerID = "", $_iItem_id = "", $_sPageURL = "", $_sFilter = "", $_iFriendsOnly = 0, $_iOffset = 0, $_iCount = 100)
; Parameters ....: $_sType - идентификатор типа Like-объекта.
;				   $_sOwnerID - идентификатор владельца Like-объекта (id пользователя или id приложения).
;				   Если параметр type равен sitepage, то в качестве owner_id необходимо передавать id приложения.
;				   Если параметр не задан, то считается, что он равен либо идентификатору текущего пользователя, либо идентификатору текущего приложения (если type равен sitepage).
;				   $_iItem_id - идентификатор Like-объекта. Если type равен sitepage, то параметр item_id может содержать значение параметра page_id, используемый при инициализации виджета «Мне нравится».
;				   $_sPageURL - url страницы, на которой установлен виджет «Мне нравится». Используется вместо параметра item_id.
;				   $_sFilter - указывает, следует ли вернуть всех пользователей, добавивших объект в список "Мне нравится" или только тех, которые рассказали о нем друзьям.
;				   Параметр может принимать следующие значения:
;						likes – возвращать всех пользователей
;						copies – возвращать только пользователей, рассказавших об объекте друзьям
;						По умолчанию возвращаются все пользователи.
;				   $_iFriendsOnly - указывает, необходимо ли возвращать только пользователей, которые являются друзьями текущего пользователя.
;				   Параметр может принимать следующие значения:
;						0 – возвращать всех пользователей в порядке убывания времени добавления объекта
;						1 – возвращать только друзей текущего пользователя в порядке убывания времени добавления объекта
;						Если метод был вызван без авторизации или параметр не был задан, то считается, что он равен 0.
;				   $_iOffset - смещение, относительно начала списка, для выборки определенного подмножества. Если параметр не задан, то считается, что он равен 0.
;				   $_iCount - количество возвращаемых идентификаторов пользователей.
;				   Если параметр не задан, то считается, что он равен 100, если не задан параметр friends_only, в противном случае 10.
;				   Максимальное значение параметра 1000, если не задан параметр friends_only, в противном случае 100.
; Return values .: Успех - В случае успеха возвращает массив:
;					$aVar[0] – общее количество пользователей, которые добавили заданный объект в свой список Мне нравится.
;					$aVar[1..n] – список индентификаторов пользователей с учетом параметров offset и count, которые добавили заданный объект в свой список Мне нравится.
;				   Если параметр type равен sitepage, то будет возвращён список пользователей, воспользовавшихся виджетом «Мне нравится» на внешнем сайте.
;				   Адрес страницы задаётся при помощи параметра page_url или item_id.
;				   Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Fever
; Remarks .......: Типы Like-объектов:
;					post - запись на стене пользователя или группы
;					comment - комментарий к записи на стене
;					photo - фотография
;					audio - аудиозапись
;					video - видеозапись
;					note - заметка
;					sitepage - страница сайта, на которой установлен виджет «Мне нравится»
;
;				   Данная функция может быть вызвана без использования авторизационных данных (параметры session или access_token).
; ============================================================================================================
Func _VK_likesGetList($_sType, $_sOwnerID = "", $_iItem_id = "", $_sPageURL = "", $_sFilter = "likes", $_iFriendsOnly = 0, $_iOffset = 0, $_iCount = 100)
	Local $sResponse, $iCount

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.getList.xml?type=" & $_sType & "&owner_id=" & $_sOwnerID & "&item_id=" & $_iItem_id & "&page_url=" & $_sPageURL & "&filter=" & $_sFilter & "&friends_only" & $_iFriendsOnly & "&offset" & $_iOffset & "&count" & $_iCount), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sResponse = _CreateArray($sResponse, "uid")
		$iCount = _CreateArray($sResponse, "count")
		_ArrayInsert($sResponse, 0, $iCount[0])

		Return $sResponse
	EndIf
EndFunc   ;==>_VK_likesGetList

#endregion Likes Functions

#region Internal Functions

; #FUNCTION# =================================================================================================
; Name...........: __guiAccessToken()
; Description ...: Открывает окно для получения доступа приложению
; Syntax.........: __guiAccessToken($_sURI, $_sGUITitle, $_sRedirect_uri)
; Parameters ....: $_sURI - Ссылка.
;				   $_sGUITitle - Название окна
;				   $_sRedirect_uri - ссылка перенаправления
; Return values .: Успех - Нет возвращаемого значения
;                  Неудача - -1 и @error = -1
; Author ........: Fever
; Remarks .......: Отсутствуют
; ============================================================================================================
Func __guiAccessToken($_sURI, $_sGUITitle, $_sRedirect_uri)
	Local $_hATgui, $sResponse, $sURL
	Local $oIE = _IECreateEmbedded()
	Local $hTimer = TimerInit()

	$_hATgui = GUICreate($_sGUITitle, 550, 400, -1, -1, $WS_POPUPWINDOW)
	GUICtrlCreateObj($oIE, 1, 1, 548, 398)

	_IENavigate($oIE, $_sURI)
	$sResponse = _IEBodyReadText($oIE)

	If StringInStr($sResponse, "access_token=") Then
		Return __responseParse($sResponse)
	EndIf

	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Return SetError(1, 0, 1)
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
					Return SetError(-1, 0, -1)
				EndIf
			EndIf
			$hTimer = TimerInit()
		EndIf
	WEnd
EndFunc   ;==>__guiAccessToken

; #FUNCTION# =================================================================================================
; Name...........: __responseParse()
; Description ...: Генерирует открытый и секретный ключи для шифрования по алгоритму RSA
; Syntax.........:  __responseParse($_sResponse)
; Parameters ....: $_sResponse - Ответ сервера.
; Return values .: Успех - Возвращает строку access_token и @error = 0.
;                  Неудача - почему то не предусмотрена))
; Author ........: Fever
; Remarks .......: Отсутствуют
; ============================================================================================================
Func __responseParse($_sResponse)
	Local $aNArray = StringSplit($_sResponse, "&"), $aResArray[UBound($aNArray)], $_sStr
	$aResArray[0] = UBound($aNArray) - 1

	For $i = 1 To $aNArray[0]
		$_sStr = StringSplit($aNArray[$i], "=")
		$aResArray[$i] = $_sStr[2]
	Next

	Return $aResArray[1]
EndFunc   ;==>__responseParse

; #FUNCTION# =================================================================================================
; Name...........: _VK_CheckForError()
; Description ...: Проверка на то, вернул ли нам сайт ошибку
; Syntax.........: _VK_CheckForError($sResponse)
; Parameters ....: $sResponse - неформатированный ответ сервера
; Return values .: Успех - Строка с описанием ошибки
;                  Неудача - 0
; Author ........: Medic84
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _VK_CheckForError($sResponse)
	Local $error_Code, $error_Msg

	$error_Code = _CreateArray($sResponse, "error_code")
	$error_Msg = _CreateArray($sResponse, "error_msg")

	If IsArray($error_Code) Then
		Return "Error: " & $error_Code[0] & " - " & $error_Msg[0]
	Else
		Return 0
	EndIf
EndFunc   ;==>_VK_CheckForError

; #FUNCTION# =================================================================================================
; Name...........: _CreateArray()
; Description ...: Создает массив из ответной строки по кодовому слову
; Syntax.........: _CreateArray($sString, $sCodeWord)
; Parameters ....: $sString - Ответная стока - та которую выдал ВКонтакте
;                  $sCodeWord - слово для поиска - которое заключено в галки
; Return values .: Успех -  Массив с даными
;                  Неудача - 1
; Author ........: Medic84
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _CreateArray($sString, $sCodeWord)
	Dim $aRetArray

	$aRetArray = StringRegExp($sString, "(?s)(?i)<" & $sCodeWord & ">(.*?)</" & $sCodeWord & ">", 3)

	Return $aRetArray
EndFunc   ;==>_CreateArray

;===============================================================================
; Description:      _StringFormatTime - Get a string representation of a timestamp
;					according to the format string given to the function.
; Syntax:			_StringFormatTime( "format", timestamp)
; Parameter(s):     Format String - A format string to convert the timestamp to.
; 									See notes for some of the values that can be
; 									used in this string.
; 					Timestamp     - A timestamp to format, possibly returned from
; 									_TimeMakeStamp. If left empty, default, or less
;									than 0, the current time is used. (default is -1)
; Return Value(s):  On Success - Returns string formatted timestamp.
;		   			On Failure - Returns False, sets @error = 99
; Requirement(s):	CrtDll.dll
; Notes:			The date/time specifiers for the Format String:
; 						%a	- Abbreviated weekday name (Fri)
; 						%A	- Full weekday name (Friday)
; 						%b	- Abbreviated month name (Jul)
; 						%B	- Full month name (July)
; 						%c	- Date and time representation (MM/DD/YY hh:mm:ss)
; 						%d	- Day of the month (01-31)
; 						%H	- Hour in 24hr format (00-23)
; 						%I	- Hour in 12hr format (01-12)
; 						%j	- Day of the year (001-366)
; 						%m	- Month number (01-12)
; 						%M	- Minute (00-59)
; 						%p	- Ante meridiem or Post Meridiem (AM / PM)
; 						%S	- Second (00-59)
; 						%U	- Week of the year, with Sunday as the first day of the week (00 - 53)
; 						%w	- Day of the week as a number (0-6; Sunday = 0)
; 						%W	- Week of the year, with Monday as the first day of the week (00 - 53)
; 						%x	- Date representation (MM/DD/YY)
; 						%X	- Time representation (hh:mm:ss)
; 						%y	- 2 digit year (99)
; 						%Y	- 4 digit year (1999)
; 						%z, %Z	- Either the time-zone name or time zone abbreviation, depending on registry settings; no characters if time zone is unknown
; 						%%	- Literal percent character
;	 				The # character can be used as a flag to specify extra settings:
; 						%#c	- Long date and time representation appropriate for current locale. (ex: "Tuesday, March 14, 1995, 12:41:29")
; 						%#x	- Long date representation, appropriate to current locale. (ex: "Tuesday, March 14, 1995")
; 						%#d, %#H, %#I, %#j, %#m, %#M, %#S, %#U, %#w, %#W, %#y, %#Y	- Remove leading zeros (if any).
;
; User CallTip:		_StringFormatTime($s_Format, $i_Timestamp, $i_MaxLen = 255) - Get a string representation of a timestamp according to the format string given to the function. (required: <_UnixTime.au3>)
; Author(s):        Rob Saunders (admin@therks.com)
;===============================================================================
Func _StringFormatTime($s_Format, $i_Timestamp)
	Local $ptr_Time, $av_StrfTime

	$ptr_Time = DllCall('CrtDll.dll', 'ptr:cdecl', 'localtime', 'long*', $i_Timestamp)
	If @error Then
		Return SetError(99, 0, "Error CrtDLL.dll")
	EndIf

	$av_StrfTime = DllCall('CrtDll.dll', 'int:cdecl', 'strftime', _
			'str', '', _
			'int', 255, _
			'str', $s_Format, _
			'ptr', $ptr_Time[0])
	Return $av_StrfTime[1]
EndFunc   ;==>_StringFormatTime
#endregion Internal Functions
