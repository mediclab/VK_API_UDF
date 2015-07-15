#include-once
#include <IE.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>

;Opt("MustDeclareVars",1)

Global $_sAccessToken

; #FUNCTION# =================================================================================================
; Name...........: _VK_SignIn()
; Description ...: Совершает авторизацию на сайте ВКонтакте
; Syntax.........: _VK_SignIn($iAppID, $sScope, $sRedirect_uri = "https://oauth.vk.com/blank.html", $sResponse_type = "token")
; Parameters ....: $iAppID - App ID приложения полученного на сайте ВКонтакте
;    			   $sScope - Битовые маски для доступа к разным возможностям ВКонтакте (Будут указаны к описаниям функций)
;				   $sRedirect_uri -
;				   $sDisplay -
;				   $sResponse_type -
; Return values .: При удачной Авторизации возвращает ключ доступа для использованя остальных функций
; Author ........: Fever
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _VK_SignIn($iAppID, $sScope,  $sRedirect_uri = "https://oauth.vk.com/blank.html", $sDisplay = "wap", $sResponse_type = "token")
	Local $sOAuth_url = "https://oauth.vk.com/authorize?client_id=" & $iAppID & "&scope=" & $sScope & "&display=" & $sDisplay & "&redirect_uri=" & $sRedirect_uri & "&response_type=" & $sResponse_type
	Return __guiAccessToken($sOAuth_url, "ВКонтакте | Вход", $sRedirect_uri)
EndFunc   ;==>_VK_SignIn


#region User Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_get()
; Description ...: Возвращает расширенную информацию о пользователях.
; Syntax.........: _VK_users_get()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_get()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_get



; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_search()
; Description ...: Возвращает список пользователей в соответствии с заданным критерием поиска.
; Syntax.........: _VK_users_search()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_search()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_search



; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_isAppUser()
; Description ...: Возвращает информацию о том, установил ли пользователь приложение.
; Syntax.........: _VK_users_isAppUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_isAppUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.isAppUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_isAppUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_getSubscriptions()
; Description ...: Возвращает список идентификаторов пользователей и сообществ, которые входят в список подписок пользователя.
; Syntax.........: _VK_users_getSubscriptions()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_getSubscriptions()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.getSubscriptions.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_getSubscriptions



; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_getFollowers()
; Description ...: Возвращает список идентификаторов пользователей, которые являются подписчиками пользователя. Идентификаторы пользователей в списке отсортированы в порядке убывания времени их добавления.
; Syntax.........: _VK_users_getFollowers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_getFollowers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.getFollowers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_getFollowers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_report()
; Description ...: Позволяет пожаловаться на пользователя.
; Syntax.........: _VK_users_report()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_report()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.report.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_report



; #FUNCTION# =================================================================================================
; Name...........:  _VK_users_getNearby()
; Description ...: Индексирует текущее местоположение пользователя и возвращает список пользователей, которые находятся вблизи.
; Syntax.........: _VK_users_getNearby()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_users_getNearby()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/users.getNearby.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_users_getNearby

#endregion User Functions

#region Authorize Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_auth_checkPhone()
; Description ...: Проверяет правильность введённого номера.
; Syntax.........: _VK_auth_checkPhone()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_auth_checkPhone()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/auth.checkPhone.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_auth_checkPhone



; #FUNCTION# =================================================================================================
; Name...........:  _VK_auth_signup()
; Description ...: Регистрирует нового пользователя по номеру телефона.
; Syntax.........: _VK_auth_signup()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_auth_signup()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/auth.signup.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_auth_signup



; #FUNCTION# =================================================================================================
; Name...........:  _VK_auth_confirm()
; Description ...: Завершает регистрацию нового пользователя, начатую методом auth.signup, по коду, полученному через SMS.
; Syntax.........: _VK_auth_confirm()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_auth_confirm()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/auth.confirm.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_auth_confirm



; #FUNCTION# =================================================================================================
; Name...........:  _VK_auth_restore()
; Description ...: Позволяет восстановить доступ к аккаунту, используя код, полученный через SMS.
; Syntax.........: _VK_auth_restore()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_auth_restore()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/auth.restore.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_auth_restore

#endregion Authorize Functions

#region Wall Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_get()
; Description ...: Возвращает список записей со стены пользователя или сообщества.
; Syntax.........: _VK_wall_get()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_get()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_get



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_search()
; Description ...: Метод, позволяющий осуществлять поиск по стенам пользователей.
; Syntax.........: _VK_wall_search()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_search()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_search



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_getById()
; Description ...: Возвращает список записей со стен пользователей или сообществ по их идентификаторам.
; Syntax.........: _VK_wall_getById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_getById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_getById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_post()
; Description ...: Публикует новую запись на своей или чужой стене.
; Syntax.........: _VK_wall_post()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_post()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.post.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_post



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_repost()
; Description ...: Копирует объект на стену пользователя или сообщества.
; Syntax.........: _VK_wall_repost()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_repost()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.repost.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_repost



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_getReposts()
; Description ...: Позволяет получать список репостов заданной записи.
; Syntax.........: _VK_wall_getReposts()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_getReposts()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.getReposts.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_getReposts



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_edit()
; Description ...: Редактирует запись на стене.
; Syntax.........: _VK_wall_edit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_edit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_edit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_delete()
; Description ...: Удаляет запись со стены.
; Syntax.........: _VK_wall_delete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_delete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_delete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_restore()
; Description ...: Восстанавливает удаленную запись на стене пользователя или сообщества.
; Syntax.........: _VK_wall_restore()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_restore()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.restore.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_restore



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_pin()
; Description ...: Закрепляет запись на стене (запись будет отображаться выше остальных).
; Syntax.........: _VK_wall_pin()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_pin()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.pin.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_pin



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_unpin()
; Description ...: Отменяет закрепление записи на стене.
; Syntax.........: _VK_wall_unpin()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_unpin()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.unpin.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_unpin



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_getComments()
; Description ...: Возвращает список комментариев к записи на стене.
; Syntax.........: _VK_wall_getComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_getComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_getComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_addComment()
; Description ...: Добавляет комментарий к записи на стене пользователя или сообщества.
; Syntax.........: _VK_wall_addComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_addComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.addComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_addComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_editComment()
; Description ...: Редактирует комментарий на стене пользователя или сообщества.
; Syntax.........: _VK_wall_editComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_editComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.editComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_editComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_deleteComment()
; Description ...: Удаляет комментарий текущего пользователя к записи на своей или чужой стене.
; Syntax.........: _VK_wall_deleteComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_deleteComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.deleteComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_walldeleteComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_restoreComment()
; Description ...: Восстанавливает комментарий текущего пользователя к записи на своей или чужой стене.
; Syntax.........: _VK_wall_restoreComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_restoreComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.restoreComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_restoreComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_reportPost()
; Description ...: Позволяет пожаловаться на запись.
; Syntax.........: _VK_wall_reportPost()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_reportPost()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.reportPost.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_reportPost



; #FUNCTION# =================================================================================================
; Name...........:  _VK_wall_reportComment()
; Description ...: Позволяет пожаловаться на комментарий к записи.
; Syntax.........: _VK_wall_reportComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_wall_reportComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/wall.reportComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_wall_reportComment

#endregion Wall Functions

#region Photos Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_photoscreateAlbum()
; Description ...: Создает пустой альбом для фотографий.
; Syntax.........: _VK_photoscreateAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photoscreateAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.createAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photoscreateAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photoseditAlbum()
; Description ...: Редактирует данные альбома для фотографий пользователя.
; Syntax.........: _VK_photoseditAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photoseditAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.editAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photoseditAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetAlbums()
; Description ...: Возвращает список альбомов пользователя или сообщества.
; Syntax.........: _VK_photosgetAlbums()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetAlbums()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getAlbums.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetAlbums



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosget()
; Description ...: Возвращает список фотографий в альбоме.
; Syntax.........: _VK_photosget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetAlbumsCount()
; Description ...: Возвращает количество доступных альбомов пользователя или сообщества.
; Syntax.........: _VK_photosgetAlbumsCount()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetAlbumsCount()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getAlbumsCount.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetById()
; Description ...: Возвращает информацию о фотографиях по их идентификаторам.
; Syntax.........: _VK_photosgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetUploadServer()
; Description ...: Возвращает адрес сервера для загрузки фотографий.
; Syntax.........: _VK_photosgetUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetOwnerPhotoUploadServer()
; Description ...: Возвращает адрес сервера для загрузки главной фотографии на страницу пользователя или сообщества.
; Syntax.........: _VK_photosgetOwnerPhotoUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetOwnerPhotoUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getOwnerPhotoUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetOwnerPhotoUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetChatUploadServer()
; Description ...: Позволяет получить адрес для загрузки фотографий мультидиалогов.
; Syntax.........: _VK_photosgetChatUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetChatUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getChatUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetChatUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photossaveOwnerPhoto()
; Description ...: Позволяет сохранить главную фотографию пользователя или сообщества.
; Syntax.........: _VK_photossaveOwnerPhoto()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photossaveOwnerPhoto()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.saveOwnerPhoto.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photossaveOwnerPhoto



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photossaveWallPhoto()
; Description ...: Сохраняет фотографии после успешной загрузки на URI, полученный методом photos.getWallUploadServer.
; Syntax.........: _VK_photossaveWallPhoto()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photossaveWallPhoto()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.saveWallPhoto.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photossaveWallPhoto



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetWallUploadServer()
; Description ...: Возвращает адрес сервера для загрузки фотографии на стену пользователя или сообщества.
; Syntax.........: _VK_photosgetWallUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetWallUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getWallUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetWallUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetMessagesUploadServer()
; Description ...: Возвращает адрес сервера для загрузки фотографии в личное сообщение пользователю.
; Syntax.........: _VK_photosgetMessagesUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetMessagesUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getMessagesUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetMessagesUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photossaveMessagesPhoto()
; Description ...: Сохраняет фотографию после успешной загрузки на URI, полученный методом photos.getMessagesUploadServer.
; Syntax.........: _VK_photossaveMessagesPhoto()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photossaveMessagesPhoto()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.saveMessagesPhoto.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photossaveMessagesPhoto



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosreport()
; Description ...: Позволяет пожаловаться на фотографию.
; Syntax.........: _VK_photosreport()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosreport()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.report.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosreport



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosreportComment()
; Description ...: Позволяет пожаловаться на комментарий к фотографии.
; Syntax.........: _VK_photosreportComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosreportComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.reportComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosreportComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photossearch()
; Description ...: Осуществляет поиск изображений по местоположению или описанию.
; Syntax.........: _VK_photossearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photossearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photossearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photossave()
; Description ...: Сохраняет фотографии после успешной загрузки.
; Syntax.........: _VK_photossave()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photossave()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.save.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photossave



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photoscopy()
; Description ...: Позволяет скопировать фотографию в альбом "Сохраненные фотографии"
; Syntax.........: _VK_photoscopy()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photoscopy()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.copy.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photoscopy



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosedit()
; Description ...: Изменяет описание у выбранной фотографии.
; Syntax.........: _VK_photosedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosedit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosmove()
; Description ...: Переносит фотографию из одного альбома в другой.
; Syntax.........: _VK_photosmove()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosmove()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.move.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosmove



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosmakeCover()
; Description ...: Делает фотографию обложкой альбома.
; Syntax.........: _VK_photosmakeCover()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosmakeCover()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.makeCover.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosmakeCover



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosreorderAlbums()
; Description ...: Меняет порядок альбома в списке альбомов пользователя.
; Syntax.........: _VK_photosreorderAlbums()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosreorderAlbums()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.reorderAlbums.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosreorderAlbums



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosreorderPhotos()
; Description ...: Меняет порядок фотографии в списке фотографий альбома пользователя.
; Syntax.........: _VK_photosreorderPhotos()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosreorderPhotos()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.reorderPhotos.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosreorderPhotos



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetAll()
; Description ...: Возвращает все фотографии пользователя или сообщества в антихронологическом порядке.
; Syntax.........: _VK_photosgetAll()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetAll()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getAll.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetAll



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetUserPhotos()
; Description ...: Возвращает список фотографий, на которых отмечен пользователь
; Syntax.........: _VK_photosgetUserPhotos()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetUserPhotos()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getUserPhotos.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetUserPhotos



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosdeleteAlbum()
; Description ...: Удаляет указанный альбом для фотографий у текущего пользователя
; Syntax.........: _VK_photosdeleteAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosdeleteAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.deleteAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosdeleteAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosdelete()
; Description ...: Удаление фотографии на сайте.
; Syntax.........: _VK_photosdelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosdelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosdelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosrestore()
; Description ...: Восстанавливает удаленную фотографию.
; Syntax.........: _VK_photosrestore()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosrestore()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.restore.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosrestore



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosconfirmTag()
; Description ...: Подтверждает отметку на фотографии.
; Syntax.........: _VK_photosconfirmTag()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosconfirmTag()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.confirmTag.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosconfirmTag



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetComments()
; Description ...: Возвращает список комментариев к фотографии.
; Syntax.........: _VK_photosgetComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetAllComments()
; Description ...: Возвращает отсортированный в антихронологическом порядке список всех комментариев к конкретному альбому или ко всем альбомам пользователя.
; Syntax.........: _VK_photosgetAllComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetAllComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getAllComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetAllComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photoscreateComment()
; Description ...: Создает новый комментарий к фотографии.
; Syntax.........: _VK_photoscreateComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photoscreateComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.createComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photoscreateComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosdeleteComment()
; Description ...: Удаляет комментарий к фотографии.
; Syntax.........: _VK_photosdeleteComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosdeleteComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.deleteComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosdeleteComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosrestoreComment()
; Description ...: Восстанавливает удаленный комментарий к фотографии.
; Syntax.........: _VK_photosrestoreComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosrestoreComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.restoreComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosrestoreComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photoseditComment()
; Description ...: Изменяет текст комментария к фотографии.
; Syntax.........: _VK_photoseditComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photoseditComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.editComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photoseditComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetTags()
; Description ...: Возвращает список отметок на фотографии.
; Syntax.........: _VK_photosgetTags()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetTags()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getTags.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetTags



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosputTag()
; Description ...: Добавляет отметку на фотографию.
; Syntax.........: _VK_photosputTag()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosputTag()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.putTag.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosputTag



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosremoveTag()
; Description ...: Удаляет отметку с фотографии.
; Syntax.........: _VK_photosremoveTag()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosremoveTag()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.removeTag.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosremoveTag



; #FUNCTION# =================================================================================================
; Name...........:  _VK_photosgetNewTags()
; Description ...: Возвращает список фотографий, на которых есть непросмотренные отметки.
; Syntax.........: _VK_photosgetNewTags()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_photosgetNewTags()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/photos.getNewTags.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_photosgetNewTags

#endregion Photos Functions

#region Friends Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsget()
; Description ...: Возвращает список идентификаторов друзей пользователя или расширенную информацию о друзьях пользователя (при использовании параметра <b>fields</b>).
; Syntax.........: _VK_friendsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetOnline()
; Description ...: Возвращает список идентификаторов друзей пользователя, находящихся на сайте.
; Syntax.........: _VK_friendsgetOnline()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetOnline()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getOnline.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetOnline



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetMutual()
; Description ...: Возвращает список идентификаторов общих друзей между парой пользователей.
; Syntax.........: _VK_friendsgetMutual()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetMutual()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getMutual.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetMutual



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetRecent()
; Description ...: Возвращает список идентификаторов недавно добавленных друзей текущего пользователя
; Syntax.........: _VK_friendsgetRecent()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetRecent()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getRecent.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetRecent



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetRequests()
; Description ...: Возвращает информацию о полученных или отправленных заявках на добавление в друзья для текущего пользователя.
; Syntax.........: _VK_friendsgetRequests()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetRequests()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getRequests.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetRequests



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsadd()
; Description ...: Одобряет или создает заявку на добавление в друзья.
; Syntax.........: _VK_friendsadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsadd



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsedit()
; Description ...: Редактирует списки друзей для выбранного друга.
; Syntax.........: _VK_friendsedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsedit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsdelete()
; Description ...: Удаляет пользователя из списка друзей или отклоняет заявку в друзья.
; Syntax.........: _VK_friendsdelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsdelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsdelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetLists()
; Description ...: Возвращает список меток друзей текущего пользователя.
; Syntax.........: _VK_friendsgetLists()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetLists()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getLists.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetLists



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsaddList()
; Description ...: Создает новый список друзей у текущего пользователя.
; Syntax.........: _VK_friendsaddList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsaddList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.addList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsaddList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendseditList()
; Description ...: Редактирует существующий список друзей текущего пользователя.
; Syntax.........: _VK_friendseditList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendseditList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.editList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendseditList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsdeleteList()
; Description ...: Удаляет существующий список друзей текущего пользователя.
; Syntax.........: _VK_friendsdeleteList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsdeleteList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.deleteList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsdeleteList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetAppUsers()
; Description ...: Возвращает список идентификаторов друзей текущего пользователя, которые установили данное приложение.
; Syntax.........: _VK_friendsgetAppUsers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetAppUsers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getAppUsers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetAppUsers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetByPhones()
; Description ...: Возвращает список друзей пользователя, у которых завалидированные или указанные в профиле телефонные номера входят в заданный список.
; Syntax.........: _VK_friendsgetByPhones()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetByPhones()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getByPhones.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetByPhones



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsdeleteAllRequests()
; Description ...: Отмечает все входящие заявки на добавление в друзья как просмотренные.
; Syntax.........: _VK_friendsdeleteAllRequests()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsdeleteAllRequests()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.deleteAllRequests.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsdeleteAllRequests



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetSuggestions()
; Description ...: Возвращает список профилей пользователей, которые могут быть друзьями текущего пользователя.
; Syntax.........: _VK_friendsgetSuggestions()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetSuggestions()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getSuggestions.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetSuggestions



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsareFriends()
; Description ...: Возвращает информацию о том, добавлен ли текущий пользователь в друзья у указанных пользователей.
; Syntax.........: _VK_friendsareFriends()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsareFriends()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.areFriends.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsareFriends



; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsgetAvailableForCall()
; Description ...: Позволяет получить список идентификаторов пользователей, доступных для вызова в приложении, используя метод JSAPI <b>callUser</b>. <br><br>
; Syntax.........: _VK_friendsgetAvailableForCall()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendsgetAvailableForCall()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.getAvailableForCall.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsgetAvailableForCall


Подробнее о схеме вызова из приложений.

; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendssearch()
; Description ...: Позволяет искать по списку друзей пользователей.
; Syntax.........: _VK_friendssearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_friendssearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/friends.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendssearch

#endregion Friends Functions

#region Widget Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_widgetsgetComments()
; Description ...: Получает список комментариев к странице, оставленных через Виджет комментариев.
; Syntax.........: _VK_widgetsgetComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_widgetsgetComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/widgets.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_widgetsgetComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_widgetsgetPages()
; Description ...: Получает список страниц приложения/сайта, на которых установлен Виджет комментариев или «Мне нравится».
; Syntax.........: _VK_widgetsgetPages()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_widgetsgetPages()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/widgets.getPages.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_widgetsgetPages

#endregion Widget Functions

#region Storage Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_storageget()
; Description ...: Возвращает значение переменной, название которой передано в параметре <b>key</b>.
; Syntax.........: _VK_storageget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_storageget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/storage.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_storageget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_storageset()
; Description ...: Сохраняет значение переменной, название которой передано в параметре <b>key</b>.
; Syntax.........: _VK_storageset()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_storageset()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/storage.set.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_storageset



; #FUNCTION# =================================================================================================
; Name...........:  _VK_storagegetKeys()
; Description ...: Возвращает названия всех переменных.
; Syntax.........: _VK_storagegetKeys()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_storagegetKeys()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/storage.getKeys.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_storagegetKeys

#endregion Storage Functions

#region Status Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_statusget()
; Description ...: Получает текст статуса пользователя или сообщества.
; Syntax.........: _VK_statusget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_statusget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/status.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_statusget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_statusset()
; Description ...: Устанавливает новый статус текущему пользователю или сообществу.
; Syntax.........: _VK_statusset()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_statusset()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/status.set.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_statusset

#endregion Status Functions

#region Audio Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_audioget()
; Description ...: Возвращает список аудиозаписей пользователя или сообщества.
; Syntax.........: _VK_audioget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audioget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audioget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetById()
; Description ...: Возвращает информацию об аудиозаписях.
; Syntax.........: _VK_audiogetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetLyrics()
; Description ...: Возвращает текст аудиозаписи.
; Syntax.........: _VK_audiogetLyrics()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetLyrics()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getLyrics.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetLyrics



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiosearch()
; Description ...: Возвращает список аудиозаписей в соответствии с заданным критерием поиска.
; Syntax.........: _VK_audiosearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiosearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiosearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetUploadServer()
; Description ...: Возвращает адрес сервера для загрузки аудиозаписей.
; Syntax.........: _VK_audiogetUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiosave()
; Description ...: Сохраняет аудиозаписи после успешной загрузки.
; Syntax.........: _VK_audiosave()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiosave()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.save.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiosave



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audioadd()
; Description ...: Копирует аудиозапись на страницу пользователя или группы.
; Syntax.........: _VK_audioadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audioadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audioadd



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiodelete()
; Description ...: Удаляет аудиозапись со страницы пользователя или сообщества.
; Syntax.........: _VK_audiodelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiodelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiodelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audioedit()
; Description ...: Редактирует данные аудиозаписи на странице пользователя или сообщества.
; Syntax.........: _VK_audioedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audioedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audioedit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audioreorder()
; Description ...: Изменяет порядок аудиозаписи, перенося ее между аудиозаписями, идентификаторы которых переданы параметрами <b>after</b> и <b>before</b>.
; Syntax.........: _VK_audioreorder()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audioreorder()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.reorder.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audioreorder



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiorestore()
; Description ...: Восстанавливает аудиозапись после удаления.
; Syntax.........: _VK_audiorestore()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiorestore()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.restore.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiorestore



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetAlbums()
; Description ...: Возвращает список альбомов аудиозаписей пользователя или группы.
; Syntax.........: _VK_audiogetAlbums()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetAlbums()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getAlbums.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetAlbums



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audioaddAlbum()
; Description ...: Создает пустой альбом аудиозаписей.
; Syntax.........: _VK_audioaddAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audioaddAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.addAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audioaddAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audioeditAlbum()
; Description ...: Редактирует название альбома аудиозаписей.
; Syntax.........: _VK_audioeditAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audioeditAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.editAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audioeditAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiodeleteAlbum()
; Description ...: Удаляет альбом аудиозаписей.
; Syntax.........: _VK_audiodeleteAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiodeleteAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.deleteAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiodeleteAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiomoveToAlbum()
; Description ...: Перемещает аудиозаписи в альбом.
; Syntax.........: _VK_audiomoveToAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiomoveToAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.moveToAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiomoveToAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiosetBroadcast()
; Description ...: Транслирует аудиозапись в статус пользователю или сообществу.
; Syntax.........: _VK_audiosetBroadcast()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiosetBroadcast()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.setBroadcast.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiosetBroadcast



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetBroadcastList()
; Description ...: Возвращает список друзей и сообществ пользователя, которые транслируют музыку в статус.
; Syntax.........: _VK_audiogetBroadcastList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetBroadcastList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getBroadcastList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetBroadcastList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetRecommendations()
; Description ...: Возвращает список рекомендуемых аудиозаписей на основе списка воспроизведения заданного пользователя или на основе одной выбранной аудиозаписи.
; Syntax.........: _VK_audiogetRecommendations()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetRecommendations()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getRecommendations.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetRecommendations



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetPopular()
; Description ...: Возвращает список аудиозаписей из раздела "Популярное".
; Syntax.........: _VK_audiogetPopular()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetPopular()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getPopular.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetPopular



; #FUNCTION# =================================================================================================
; Name...........:  _VK_audiogetCount()
; Description ...: Возвращает количество аудиозаписей пользователя или сообщества.
; Syntax.........: _VK_audiogetCount()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_audiogetCount()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/audio.getCount.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_audiogetCount

#endregion Audio Functions

#region Pages Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagesget()
; Description ...: Возвращает информацию о вики-странице.
; Syntax.........: _VK_pagesget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagesget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagesget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagessave()
; Description ...: Сохраняет текст вики-страницы.
; Syntax.........: _VK_pagessave()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagessave()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.save.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagessave



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagessaveAccess()
; Description ...: Сохраняет новые настройки доступа на чтение и редактирование вики-страницы.
; Syntax.........: _VK_pagessaveAccess()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagessaveAccess()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.saveAccess.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagessaveAccess



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagesgetHistory()
; Description ...: Возвращает список всех старых версий вики-страницы.
; Syntax.........: _VK_pagesgetHistory()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagesgetHistory()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.getHistory.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagesgetHistory



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagesgetTitles()
; Description ...: Возвращает список вики-страниц в группе.
; Syntax.........: _VK_pagesgetTitles()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagesgetTitles()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.getTitles.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagesgetTitles



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagesgetVersion()
; Description ...: Возвращает текст одной из старых версий страницы.
; Syntax.........: _VK_pagesgetVersion()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagesgetVersion()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.getVersion.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagesgetVersion



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagesparseWiki()
; Description ...: Возвращает html-представление вики-разметки.
; Syntax.........: _VK_pagesparseWiki()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagesparseWiki()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.parseWiki.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagesparseWiki



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pagesclearCache()
; Description ...: Позволяет очистить кеш отдельных <b>внешних</b> страниц, которые могут быть прикреплены к записям ВКонтакте. После очистки кеша при последующем прикреплении ссылки к записи, данные о странице будут обновлены.
; Syntax.........: _VK_pagesclearCache()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pagesclearCache()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/pages.clearCache.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pagesclearCache

#endregion Pages Functions

#region Groups Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsisMember()
; Description ...: Возвращает информацию о том, является ли пользователь участником сообщества.
; Syntax.........: _VK_groupsisMember()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsisMember()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.isMember.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsisMember



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetById()
; Description ...: Возвращает информацию о заданном сообществе или о нескольких сообществах.
; Syntax.........: _VK_groupsgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsget()
; Description ...: Возвращает список сообществ указанного пользователя.
; Syntax.........: _VK_groupsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetMembers()
; Description ...: Возвращает список участников сообщества.
; Syntax.........: _VK_groupsgetMembers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetMembers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getMembers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetMembers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsjoin()
; Description ...: Данный метод позволяет вступить в группу, публичную страницу, а также подтвердить участие во встрече.
; Syntax.........: _VK_groupsjoin()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsjoin()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.join.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsjoin



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsleave()
; Description ...: Данный метод позволяет выходить из группы, публичной страницы, или встречи.
; Syntax.........: _VK_groupsleave()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsleave()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.leave.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsleave



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupssearch()
; Description ...: Осуществляет поиск сообществ по заданной подстроке.
; Syntax.........: _VK_groupssearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupssearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupssearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetInvites()
; Description ...: Данный метод возвращает список приглашений в сообщества и встречи текущего пользователя.
; Syntax.........: _VK_groupsgetInvites()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetInvites()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getInvites.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetInvites



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetInvitedUsers()
; Description ...: Возвращает список пользователей, которые были приглашены в группу.
; Syntax.........: _VK_groupsgetInvitedUsers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetInvitedUsers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getInvitedUsers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetInvitedUsers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsbanUser()
; Description ...: Добавляет пользователя в черный список группы.
; Syntax.........: _VK_groupsbanUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsbanUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.banUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsbanUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsunbanUser()
; Description ...: Убирает пользователя из черного списка сообщества.
; Syntax.........: _VK_groupsunbanUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsunbanUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.unbanUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsunbanUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetBanned()
; Description ...: Возвращает список забаненных пользователей в сообществе.
; Syntax.........: _VK_groupsgetBanned()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetBanned()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getBanned.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetBanned



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupscreate()
; Description ...: Позволяет создавать новые сообщества.
; Syntax.........: _VK_groupscreate()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupscreate()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.create.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupscreate



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsedit()
; Description ...: Позволяет редактировать информацию групп.
; Syntax.........: _VK_groupsedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsedit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupseditPlace()
; Description ...: Позволяет редактировать информацию о месте группы.
; Syntax.........: _VK_groupseditPlace()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupseditPlace()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.editPlace.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupseditPlace



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetSettings()
; Description ...: Позволяет получать данные, необходимые для отображения страницы редактирования данных сообщества.
; Syntax.........: _VK_groupsgetSettings()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetSettings()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getSettings.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetSettings



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsgetRequests()
; Description ...: Возвращает список заявок на вступление в сообщество.
; Syntax.........: _VK_groupsgetRequests()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsgetRequests()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.getRequests.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsgetRequests



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupseditManager()
; Description ...: Позволяет назначить/разжаловать руководителя в сообществе или изменить уровень его полномочий.
; Syntax.........: _VK_groupseditManager()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupseditManager()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.editManager.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupseditManager



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsinvite()
; Description ...: Позволяет приглашать друзей в группу.
; Syntax.........: _VK_groupsinvite()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsinvite()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.invite.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsinvite



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsaddLink()
; Description ...: Позволяет добавлять ссылки в сообщество.
; Syntax.........: _VK_groupsaddLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsaddLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.addLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsaddLink



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsdeleteLink()
; Description ...: Позволяет удалить ссылки из сообщества.
; Syntax.........: _VK_groupsdeleteLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsdeleteLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.deleteLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsdeleteLink



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupseditLink()
; Description ...: Позволяет редактировать ссылки в сообществе.
; Syntax.........: _VK_groupseditLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupseditLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.editLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupseditLink



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsreorderLink()
; Description ...: Позволяет менять местоположение ссылки в списке.
; Syntax.........: _VK_groupsreorderLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsreorderLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.reorderLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsreorderLink



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsremoveUser()
; Description ...: Позволяет исключить пользователя из группы или отклонить заявку на вступление.
; Syntax.........: _VK_groupsremoveUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsremoveUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.removeUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsremoveUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_groupsapproveRequest()
; Description ...: Позволяет одобрить заявку в группу от пользователя.
; Syntax.........: _VK_groupsapproveRequest()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_groupsapproveRequest()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/groups.approveRequest.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_groupsapproveRequest

#endregion Groups Functions

#region Board Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardgetTopics()
; Description ...: Возвращает список тем в обсуждениях указанной группы.
; Syntax.........: _VK_boardgetTopics()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardgetTopics()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.getTopics.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardgetTopics



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardgetComments()
; Description ...: Возвращает список сообщений в указанной теме.
; Syntax.........: _VK_boardgetComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardgetComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardgetComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardaddTopic()
; Description ...: Создает новую тему в списке обсуждений группы.
; Syntax.........: _VK_boardaddTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardaddTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.addTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardaddTopic



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardaddComment()
; Description ...: Добавляет новое сообщение в теме сообщества.
; Syntax.........: _VK_boardaddComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardaddComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.addComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardaddComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boarddeleteTopic()
; Description ...: Удаляет тему в обсуждениях группы.
; Syntax.........: _VK_boarddeleteTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boarddeleteTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.deleteTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boarddeleteTopic



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardeditTopic()
; Description ...: Изменяет заголовок темы в списке обсуждений группы.
; Syntax.........: _VK_boardeditTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardeditTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.editTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardeditTopic



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardeditComment()
; Description ...: Редактирует одно из сообщений в теме группы.
; Syntax.........: _VK_boardeditComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardeditComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.editComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardeditComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardrestoreComment()
; Description ...: Восстанавливает удаленное сообщение темы в обсуждениях группы.
; Syntax.........: _VK_boardrestoreComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardrestoreComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.restoreComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardrestoreComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boarddeleteComment()
; Description ...: Удаляет сообщение темы в обсуждениях сообщества.
; Syntax.........: _VK_boarddeleteComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boarddeleteComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.deleteComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boarddeleteComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardopenTopic()
; Description ...: Открывает ранее закрытую тему (в ней станет возможно оставлять новые сообщения).
; Syntax.........: _VK_boardopenTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardopenTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.openTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardopenTopic



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardcloseTopic()
; Description ...: Закрывает тему в списке обсуждений группы (в такой теме невозможно оставлять новые сообщения).
; Syntax.........: _VK_boardcloseTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardcloseTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.closeTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardcloseTopic



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardfixTopic()
; Description ...: Закрепляет тему в списке обсуждений группы (такая тема при любой сортировке выводится выше остальных).
; Syntax.........: _VK_boardfixTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardfixTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.fixTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardfixTopic



; #FUNCTION# =================================================================================================
; Name...........:  _VK_boardunfixTopic()
; Description ...: Отменяет прикрепление темы в списке обсуждений группы (тема будет выводиться согласно выбранной сортировке).
; Syntax.........: _VK_boardunfixTopic()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_boardunfixTopic()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/board.unfixTopic.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_boardunfixTopic

#endregion Board Functions

#region Video Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoget()
; Description ...: Возвращает информацию о видеозаписях.
; Syntax.........: _VK_videoget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoedit()
; Description ...: Редактирует данные видеозаписи на странице пользователя.
; Syntax.........: _VK_videoedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoedit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoadd()
; Description ...: Добавляет видеозапись в список пользователя.
; Syntax.........: _VK_videoadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoadd



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videosave()
; Description ...: Возвращает адрес сервера (необходимый для загрузки) и данные видеозаписи.
; Syntax.........: _VK_videosave()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videosave()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.save.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videosave



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videodelete()
; Description ...: Удаляет видеозапись со страницы пользователя.
; Syntax.........: _VK_videodelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videodelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videodelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videorestore()
; Description ...: Восстанавливает удаленную видеозапись.
; Syntax.........: _VK_videorestore()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videorestore()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.restore.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videorestore



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videosearch()
; Description ...: Возвращает список видеозаписей в соответствии с заданным критерием поиска.
; Syntax.........: _VK_videosearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videosearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videosearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetUserVideos()
; Description ...: Возвращает список видеозаписей, на которых отмечен пользователь.
; Syntax.........: _VK_videogetUserVideos()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetUserVideos()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getUserVideos.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetUserVideos



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetAlbums()
; Description ...: Возвращает список альбомов видеозаписей пользователя или сообщества.
; Syntax.........: _VK_videogetAlbums()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetAlbums()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getAlbums.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetAlbums



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetAlbumById()
; Description ...: Позволяет получить информацию об альбоме с видео.
; Syntax.........: _VK_videogetAlbumById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetAlbumById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getAlbumById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetAlbumById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoaddAlbum()
; Description ...: Создает пустой альбом видеозаписей.
; Syntax.........: _VK_videoaddAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoaddAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.addAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoaddAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoeditAlbum()
; Description ...: Редактирует название альбома видеозаписей.
; Syntax.........: _VK_videoeditAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoeditAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.editAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoeditAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videodeleteAlbum()
; Description ...: Удаляет альбом видеозаписей.
; Syntax.........: _VK_videodeleteAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videodeleteAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.deleteAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videodeleteAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoreorderAlbums()
; Description ...: Позволяет изменить порядок альбомов с видео.
; Syntax.........: _VK_videoreorderAlbums()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoreorderAlbums()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.reorderAlbums.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoreorderAlbums



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoaddToAlbum()
; Description ...: Позволяет добавить видеозапись в альбом.
; Syntax.........: _VK_videoaddToAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoaddToAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.addToAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoaddToAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoremoveFromAlbum()
; Description ...: Позволяет убрать видеозапись из альбома.
; Syntax.........: _VK_videoremoveFromAlbum()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoremoveFromAlbum()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.removeFromAlbum.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoremoveFromAlbum



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetAlbumsByVideo()
; Description ...: Возвращает список альбомов, в которых находится видеозапись.
; Syntax.........: _VK_videogetAlbumsByVideo()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetAlbumsByVideo()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getAlbumsByVideo.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetAlbumsByVideo



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetComments()
; Description ...: Возвращает список комментариев к видеозаписи.
; Syntax.........: _VK_videogetComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videocreateComment()
; Description ...: Cоздает новый комментарий к видеозаписи
; Syntax.........: _VK_videocreateComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videocreateComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.createComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videocreateComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videodeleteComment()
; Description ...: Удаляет комментарий к видеозаписи.
; Syntax.........: _VK_videodeleteComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videodeleteComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.deleteComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videodeleteComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videorestoreComment()
; Description ...: Восстанавливает удаленный комментарий к видеозаписи.
; Syntax.........: _VK_videorestoreComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videorestoreComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.restoreComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videorestoreComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoeditComment()
; Description ...: Изменяет текст комментария к видеозаписи.
; Syntax.........: _VK_videoeditComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoeditComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.editComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoeditComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetTags()
; Description ...: Возвращает список отметок на видеозаписи.
; Syntax.........: _VK_videogetTags()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetTags()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getTags.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetTags



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoputTag()
; Description ...: Добавляет отметку на видеозапись.
; Syntax.........: _VK_videoputTag()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoputTag()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.putTag.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoputTag



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoremoveTag()
; Description ...: Удаляет отметку с видеозаписи.
; Syntax.........: _VK_videoremoveTag()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoremoveTag()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.removeTag.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoremoveTag



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videogetNewTags()
; Description ...: Возвращает список видеозаписей, на которых есть непросмотренные отметки.
; Syntax.........: _VK_videogetNewTags()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videogetNewTags()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.getNewTags.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videogetNewTags



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoreport()
; Description ...: Позволяет пожаловаться на видеозапись.
; Syntax.........: _VK_videoreport()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoreport()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.report.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoreport



; #FUNCTION# =================================================================================================
; Name...........:  _VK_videoreportComment()
; Description ...: Позволяет пожаловаться на комментарий к видеозаписи.
; Syntax.........: _VK_videoreportComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_videoreportComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/video.reportComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_videoreportComment

#endregion Video Functions

#region Notes Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesget()
; Description ...: Возвращает список заметок, созданных пользователем.
; Syntax.........: _VK_notesget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesgetById()
; Description ...: Возвращает заметку по её <b>id</b>.
; Syntax.........: _VK_notesgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesgetFriendsNotes()
; Description ...: Возвращает список заметок друзей пользователя.
; Syntax.........: _VK_notesgetFriendsNotes()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesgetFriendsNotes()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.getFriendsNotes.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesgetFriendsNotes



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesadd()
; Description ...: Создает новую заметку у текущего пользователя.
; Syntax.........: _VK_notesadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesadd



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesedit()
; Description ...: Редактирует заметку текущего пользователя.
; Syntax.........: _VK_notesedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesedit



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesdelete()
; Description ...: Удаляет заметку текущего пользователя.
; Syntax.........: _VK_notesdelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesdelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesdelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesgetComments()
; Description ...: Возвращает список комментариев к заметке.
; Syntax.........: _VK_notesgetComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesgetComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesgetComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notescreateComment()
; Description ...: Добавляет новый комментарий к заметке.
; Syntax.........: _VK_notescreateComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notescreateComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.createComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notescreateComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_noteseditComment()
; Description ...: Редактирует указанный комментарий у заметки.
; Syntax.........: _VK_noteseditComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_noteseditComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.editComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_noteseditComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesdeleteComment()
; Description ...: Удаляет комментарий к заметке.
; Syntax.........: _VK_notesdeleteComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesdeleteComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.deleteComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesdeleteComment



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notesrestoreComment()
; Description ...: Восстанавливает удалённый комментарий.
; Syntax.........: _VK_notesrestoreComment()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notesrestoreComment()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notes.restoreComment.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notesrestoreComment

#endregion Notes Functions

#region Places Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_placesadd()
; Description ...: Добавляет новое место в базу географических мест.
; Syntax.........: _VK_placesadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_placesadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/places.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_placesadd



; #FUNCTION# =================================================================================================
; Name...........:  _VK_placesgetById()
; Description ...: Возвращает информацию о местах по их идентификаторам.
; Syntax.........: _VK_placesgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_placesgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/places.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_placesgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_placessearch()
; Description ...: Возвращает список мест, найденных по заданным условиям поиска.
; Syntax.........: _VK_placessearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_placessearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/places.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_placessearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_placescheckin()
; Description ...: Отмечает пользователя в указанном месте.
; Syntax.........: _VK_placescheckin()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_placescheckin()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/places.checkin.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_placescheckin



; #FUNCTION# =================================================================================================
; Name...........:  _VK_placesgetCheckins()
; Description ...: Возвращает список отметок пользователей в местах согласно заданным параметрам.
; Syntax.........: _VK_placesgetCheckins()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_placesgetCheckins()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/places.getCheckins.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_placesgetCheckins



; #FUNCTION# =================================================================================================
; Name...........:  _VK_placesgetTypes()
; Description ...: Возвращает список всех возможных типов мест.
; Syntax.........: _VK_placesgetTypes()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_placesgetTypes()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/places.getTypes.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_placesgetTypes

#endregion Places Functions

#region Account Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetCounters()
; Description ...: Возвращает ненулевые значения счетчиков пользователя.
; Syntax.........: _VK_accountgetCounters()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetCounters()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getCounters.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetCounters



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsetNameInMenu()
; Description ...: Устанавливает короткое название приложения (до 17 символов), которое выводится пользователю в левом меню.
; Syntax.........: _VK_accountsetNameInMenu()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsetNameInMenu()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.setNameInMenu.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsetNameInMenu



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsetOnline()
; Description ...: Помечает текущего пользователя как online на 15 минут.
; Syntax.........: _VK_accountsetOnline()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsetOnline()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.setOnline.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsetOnline



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsetOffline()
; Description ...: Помечает текущего пользователя как offline.
; Syntax.........: _VK_accountsetOffline()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsetOffline()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.setOffline.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsetOffline



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountlookupContacts()
; Description ...: Позволяет искать пользователей <b>ВКонтакте</b>, используя телефонные номера, email-адреса, и идентификаторы пользователей в других сервисах. Найденные пользователи могут быть также в дальнейшем получены методом friends.getSuggestions.
; Syntax.........: _VK_accountlookupContacts()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountlookupContacts()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.lookupContacts.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountlookupContacts



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountregisterDevice()
; Description ...: Подписывает устройство на базе iOS, Android или Windows Phone на получение Push-уведомлений.
; Syntax.........: _VK_accountregisterDevice()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountregisterDevice()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.registerDevice.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountregisterDevice



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountunregisterDevice()
; Description ...: Отписывает устройство от Push уведомлений.
; Syntax.........: _VK_accountunregisterDevice()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountunregisterDevice()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.unregisterDevice.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountunregisterDevice



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsetSilenceMode()
; Description ...: Отключает push-уведомления на заданный промежуток времени.
; Syntax.........: _VK_accountsetSilenceMode()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsetSilenceMode()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.setSilenceMode.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsetSilenceMode



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetPushSettings()
; Description ...: Позволяет получать настройки Push уведомлений.
; Syntax.........: _VK_accountgetPushSettings()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetPushSettings()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getPushSettings.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetPushSettings



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsetPushSettings()
; Description ...: Изменяет настройку Push-уведомлений.
; Syntax.........: _VK_accountsetPushSettings()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsetPushSettings()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.setPushSettings.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsetPushSettings



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetAppPermissions()
; Description ...: Получает настройки текущего пользователя в данном приложении.
; Syntax.........: _VK_accountgetAppPermissions()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetAppPermissions()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getAppPermissions.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetAppPermissions



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetActiveOffers()
; Description ...: Возвращает список активных рекламных предложений (офферов), выполнив которые пользователь сможет получить соответствующее количество голосов на свой счёт внутри приложения.
; Syntax.........: _VK_accountgetActiveOffers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetActiveOffers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getActiveOffers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetActiveOffers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountbanUser()
; Description ...: Добавляет пользователя в черный список.
; Syntax.........: _VK_accountbanUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountbanUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.banUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountbanUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountunbanUser()
; Description ...: Убирает пользователя из черного списка.
; Syntax.........: _VK_accountunbanUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountunbanUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.unbanUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountunbanUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetBanned()
; Description ...: Возвращает список пользователей, находящихся в черном списке.
; Syntax.........: _VK_accountgetBanned()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetBanned()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getBanned.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetBanned



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetInfo()
; Description ...: Возвращает информацию о текущем аккаунте.
; Syntax.........: _VK_accountgetInfo()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetInfo()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getInfo.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetInfo



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsetInfo()
; Description ...: Позволяет редактировать информацию о текущем аккаунте.
; Syntax.........: _VK_accountsetInfo()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsetInfo()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.setInfo.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsetInfo



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountchangePassword()
; Description ...: Позволяет сменить пароль пользователя после успешного восстановления доступа к аккаунту через СМС, используя метод auth.restore.
; Syntax.........: _VK_accountchangePassword()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountchangePassword()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.changePassword.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountchangePassword



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountgetProfileInfo()
; Description ...: Возвращает информацию о текущем профиле.
; Syntax.........: _VK_accountgetProfileInfo()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountgetProfileInfo()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.getProfileInfo.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountgetProfileInfo



; #FUNCTION# =================================================================================================
; Name...........:  _VK_accountsaveProfileInfo()
; Description ...: Редактирует информацию текущего профиля.
; Syntax.........: _VK_accountsaveProfileInfo()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_accountsaveProfileInfo()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/account.saveProfileInfo.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_accountsaveProfileInfo

#endregion Account Functions

#region Messages Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesget()
; Description ...: Возвращает список входящих либо исходящих личных сообщений текущего пользователя.
; Syntax.........: _VK_messagesget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetDialogs()
; Description ...: Возвращает список диалогов текущего пользователя.
; Syntax.........: _VK_messagesgetDialogs()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetDialogs()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getDialogs.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetDialogs



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetById()
; Description ...: Возвращает сообщения по их <b>id</b>.
; Syntax.........: _VK_messagesgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagessearch()
; Description ...:   <div class="dev_methods_list_desc fl_l">Возвращает список найденных личных сообщений текущего пользователя по введенной строке поиска.
; Syntax.........: _VK_messagessearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagessearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagessearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetHistory()
; Description ...: Возвращает историю сообщений для указанного пользователя.
; Syntax.........: _VK_messagesgetHistory()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetHistory()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getHistory.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetHistory



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagessend()
; Description ...: Отправляет сообщение.
; Syntax.........: _VK_messagessend()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagessend()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.send.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagessend



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesdelete()
; Description ...: Удаляет сообщение.
; Syntax.........: _VK_messagesdelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesdelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesdelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesdeleteDialog()
; Description ...: Удаляет все личные сообщения в диалоге.
; Syntax.........: _VK_messagesdeleteDialog()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesdeleteDialog()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.deleteDialog.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesdeleteDialog



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesrestore()
; Description ...: Восстанавливает удаленное сообщение.
; Syntax.........: _VK_messagesrestore()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesrestore()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.restore.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesrestore



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesmarkAsRead()
; Description ...: Помечает сообщения как прочитанные.
; Syntax.........: _VK_messagesmarkAsRead()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesmarkAsRead()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.markAsRead.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesmarkAsRead



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesmarkAsImportant()
; Description ...:   <div class="dev_methods_list_desc fl_l">Помечает сообщения как важные либо снимает отметку.
; Syntax.........: _VK_messagesmarkAsImportant()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesmarkAsImportant()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.markAsImportant.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesmarkAsImportant



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetLongPollServer()
; Description ...: Возвращает данные, необходимые для подключения к Long Poll серверу.
; Syntax.........: _VK_messagesgetLongPollServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetLongPollServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getLongPollServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetLongPollServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetLongPollHistory()
; Description ...: Возвращает обновления в личных сообщениях пользователя.
; Syntax.........: _VK_messagesgetLongPollHistory()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetLongPollHistory()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getLongPollHistory.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetLongPollHistory



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetChat()
; Description ...: Возвращает информацию о беседе.
; Syntax.........: _VK_messagesgetChat()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetChat()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getChat.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetChat



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagescreateChat()
; Description ...: Создаёт беседу с несколькими участниками.
; Syntax.........: _VK_messagescreateChat()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagescreateChat()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.createChat.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagescreateChat



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messageseditChat()
; Description ...: Изменяет название беседы.
; Syntax.........: _VK_messageseditChat()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messageseditChat()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.editChat.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messageseditChat



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetChatUsers()
; Description ...: Позволяет получить список пользователей мультидиалога по его <b>id</b>.
; Syntax.........: _VK_messagesgetChatUsers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetChatUsers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getChatUsers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetChatUsers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagessetActivity()
; Description ...: Изменяет статус набора текста пользователем в диалоге.
; Syntax.........: _VK_messagessetActivity()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagessetActivity()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.setActivity.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagessetActivity



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagessearchDialogs()
; Description ...: Возвращает список найденных диалогов текущего пользователя по введенной строке поиска.
; Syntax.........: _VK_messagessearchDialogs()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagessearchDialogs()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.searchDialogs.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagessearchDialogs



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesaddChatUser()
; Description ...: Добавляет в мультидиалог нового пользователя.
; Syntax.........: _VK_messagesaddChatUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesaddChatUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.addChatUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesaddChatUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesremoveChatUser()
; Description ...: Исключает из мультидиалога пользователя, если текущий пользователь был создателем беседы либо пригласил исключаемого пользователя.
; Syntax.........: _VK_messagesremoveChatUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesremoveChatUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.removeChatUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesremoveChatUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesgetLastActivity()
; Description ...: Возвращает текущий статус и дату последней активности указанного пользователя.
; Syntax.........: _VK_messagesgetLastActivity()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesgetLastActivity()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.getLastActivity.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesgetLastActivity



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagessetChatPhoto()
; Description ...: Позволяет установить фотографию мультидиалога, загруженную с помощью метода photos.getChatUploadServer.
; Syntax.........: _VK_messagessetChatPhoto()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagessetChatPhoto()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.setChatPhoto.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagessetChatPhoto



; #FUNCTION# =================================================================================================
; Name...........:  _VK_messagesdeleteChatPhoto()
; Description ...: Позволяет удалить фотографию мультидиалога.
; Syntax.........: _VK_messagesdeleteChatPhoto()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_messagesdeleteChatPhoto()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/messages.deleteChatPhoto.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_messagesdeleteChatPhoto

#endregion Messages Functions

#region News Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedget()
; Description ...: Возвращает данные, необходимые для показа списка новостей для текущего пользователя.
; Syntax.........: _VK_newsfeedget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedgetRecommended()
; Description ...: Получает список новостей, рекомендованных пользователю.
; Syntax.........: _VK_newsfeedgetRecommended()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedgetRecommended()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.getRecommended.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedgetRecommended



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedgetComments()
; Description ...: Возвращает данные, необходимые для показа раздела комментариев в новостях пользователя.
; Syntax.........: _VK_newsfeedgetComments()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedgetComments()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.getComments.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedgetComments



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedgetMentions()
; Description ...: Возвращает список записей пользователей на своих стенах, в которых упоминается указанный пользователь.
; Syntax.........: _VK_newsfeedgetMentions()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedgetMentions()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.getMentions.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedgetMentions



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedgetBanned()
; Description ...: Возвращает список пользователей и групп, которые текущий пользователь скрыл из ленты новостей.
; Syntax.........: _VK_newsfeedgetBanned()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedgetBanned()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.getBanned.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedgetBanned



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedaddBan()
; Description ...: Запрещает показывать новости от заданных пользователей и групп в ленте новостей текущего пользователя.
; Syntax.........: _VK_newsfeedaddBan()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedaddBan()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.addBan.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedaddBan



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeeddeleteBan()
; Description ...: Разрешает показывать новости от заданных пользователей и групп в ленте новостей текущего пользователя.
; Syntax.........: _VK_newsfeeddeleteBan()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeeddeleteBan()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.deleteBan.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeeddeleteBan



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedignoreItem()
; Description ...: Позволяет скрыть объект из ленты новостей.
; Syntax.........: _VK_newsfeedignoreItem()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedignoreItem()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.ignoreItem.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedignoreItem



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedunignoreItem()
; Description ...: Позволяет вернуть ранее скрытый объект в ленту новостей.
; Syntax.........: _VK_newsfeedunignoreItem()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedunignoreItem()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.unignoreItem.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedunignoreItem



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedsearch()
; Description ...: Возвращает результаты поиска по статусам. Новости возвращаются в порядке от более новых к более старым.
; Syntax.........: _VK_newsfeedsearch()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedsearch()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.search.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedsearch



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedgetLists()
; Description ...: Возвращает пользовательские списки новостей.
; Syntax.........: _VK_newsfeedgetLists()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedgetLists()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.getLists.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedgetLists



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedsaveList()
; Description ...: Метод позволяет создавать или редактировать пользовательские списки для просмотра новостей.
; Syntax.........: _VK_newsfeedsaveList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedsaveList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.saveList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedsaveList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeeddeleteList()
; Description ...: Метод позволяет удалить пользовательский список новостей
; Syntax.........: _VK_newsfeeddeleteList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeeddeleteList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.deleteList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeeddeleteList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedunsubscribe()
; Description ...: Отписывает текущего пользователя от комментариев к заданному объекту.
; Syntax.........: _VK_newsfeedunsubscribe()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedunsubscribe()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.unsubscribe.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedunsubscribe



; #FUNCTION# =================================================================================================
; Name...........:  _VK_newsfeedgetSuggestedSources()
; Description ...: Возвращает сообщества и пользователей, на которые текущему пользователю рекомендуется подписаться.
; Syntax.........: _VK_newsfeedgetSuggestedSources()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_newsfeedgetSuggestedSources()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/newsfeed.getSuggestedSources.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_newsfeedgetSuggestedSources

#endregion News Functions

#region Likes Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_likesgetList()
; Description ...: Получает список идентификаторов пользователей, которые добавили заданный объект в свой список <b>Мне нравится</b>.
; Syntax.........: _VK_likesgetList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_likesgetList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/likes.getList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_likesgetList



; #FUNCTION# =================================================================================================
; Name...........:  _VK_likesadd()
; Description ...: Добавляет указанный объект в список <b>Мне нравится</b> текущего пользователя.
; Syntax.........: _VK_likesadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_likesadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/likes.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_likesadd



; #FUNCTION# =================================================================================================
; Name...........:  _VK_likesdelete()
; Description ...: Удаляет указанный объект из списка <b>Мне нравится</b> текущего пользователя
; Syntax.........: _VK_likesdelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_likesdelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/likes.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_likesdelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_likesisLiked()
; Description ...: Проверяет, находится ли объект в списке <b>Мне нравится</b> заданного пользователя.
; Syntax.........: _VK_likesisLiked()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_likesisLiked()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/likes.isLiked.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_likesisLiked

#endregion Likes Functions

#region Polls Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_pollsgetById()
; Description ...: Возвращает детальную информацию об опросе по его идентификатору.
; Syntax.........: _VK_pollsgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pollsgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/polls.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pollsgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pollsaddVote()
; Description ...: Отдает голос текущего пользователя за выбранный вариант ответа в указанном опросе.
; Syntax.........: _VK_pollsaddVote()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pollsaddVote()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/polls.addVote.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pollsaddVote



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pollsdeleteVote()
; Description ...: Снимает голос текущего пользователя с выбранного варианта ответа в указанном опросе.
; Syntax.........: _VK_pollsdeleteVote()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pollsdeleteVote()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/polls.deleteVote.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pollsdeleteVote



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pollsgetVoters()
; Description ...: Получает список идентификаторов пользователей, которые выбрали определенные варианты ответа в опросе.
; Syntax.........: _VK_pollsgetVoters()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pollsgetVoters()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/polls.getVoters.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pollsgetVoters



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pollscreate()
; Description ...: Позволяет создавать опросы, которые впоследствии можно прикреплять к записям на странице пользователя или сообщества.
; Syntax.........: _VK_pollscreate()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pollscreate()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/polls.create.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pollscreate



; #FUNCTION# =================================================================================================
; Name...........:  _VK_pollsedit()
; Description ...: Позволяет редактировать созданные опросы.
; Syntax.........: _VK_pollsedit()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_pollsedit()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/polls.edit.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_pollsedit

#endregion Polls Functions

#region Docs Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_docsget()
; Description ...: Возвращает расширенную информацию о документах пользователя или сообщества.
; Syntax.........: _VK_docsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docsget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_docsgetById()
; Description ...: Возвращает информацию о документах по их идентификаторам.
; Syntax.........: _VK_docsgetById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docsgetById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.getById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docsgetById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_docsgetUploadServer()
; Description ...: Возвращает адрес сервера для загрузки документов.
; Syntax.........: _VK_docsgetUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docsgetUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.getUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docsgetUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_docsgetWallUploadServer()
; Description ...: Возвращает адрес сервера для загрузки документов в папку <b>Отправленные</b>, для последующей отправки документа на стену или личным сообщением.
; Syntax.........: _VK_docsgetWallUploadServer()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docsgetWallUploadServer()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.getWallUploadServer.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docsgetWallUploadServer



; #FUNCTION# =================================================================================================
; Name...........:  _VK_docssave()
; Description ...: Сохраняет документ после его успешной загрузки на сервер.
; Syntax.........: _VK_docssave()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docssave()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.save.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docssave



; #FUNCTION# =================================================================================================
; Name...........:  _VK_docsdelete()
; Description ...: Удаляет документ пользователя или группы.
; Syntax.........: _VK_docsdelete()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docsdelete()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.delete.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docsdelete



; #FUNCTION# =================================================================================================
; Name...........:  _VK_docsadd()
; Description ...: Копирует документ в документы текущего пользователя.
; Syntax.........: _VK_docsadd()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_docsadd()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/docs.add.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_docsadd

#endregion Docs Functions

#region Favourites Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_favegetUsers()
; Description ...: Возвращает список пользователей, добавленных текущим пользователем в закладки.
; Syntax.........: _VK_favegetUsers()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_favegetUsers()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.getUsers.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_favegetUsers



; #FUNCTION# =================================================================================================
; Name...........:  _VK_favegetPhotos()
; Description ...: Возвращает фотографии, на которых текущий пользователь поставил отметку "Мне нравится".
; Syntax.........: _VK_favegetPhotos()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_favegetPhotos()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.getPhotos.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_favegetPhotos



; #FUNCTION# =================================================================================================
; Name...........:  _VK_favegetPosts()
; Description ...: Возвращает записи, на которых текущий пользователь поставил отметку <b>«Мне нравится»</b>.
; Syntax.........: _VK_favegetPosts()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_favegetPosts()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.getPosts.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_favegetPosts



; #FUNCTION# =================================================================================================
; Name...........:  _VK_favegetVideos()
; Description ...: Возвращает список видеозаписей, на которых текущий пользователь поставил отметку <b>«Мне нравится»</b>.
; Syntax.........: _VK_favegetVideos()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_favegetVideos()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.getVideos.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_favegetVideos



; #FUNCTION# =================================================================================================
; Name...........:  _VK_favegetLinks()
; Description ...: Возвращает ссылки, добавленные в закладки текущим пользователем.
; Syntax.........: _VK_favegetLinks()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_favegetLinks()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.getLinks.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_favegetLinks



; #FUNCTION# =================================================================================================
; Name...........:  _VK_faveaddUser()
; Description ...: Добавляет пользователя в закладки.
; Syntax.........: _VK_faveaddUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_faveaddUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.addUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_faveaddUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_faveremoveUser()
; Description ...: Удаляет пользователя из закладок.
; Syntax.........: _VK_faveremoveUser()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_faveremoveUser()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.removeUser.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_faveremoveUser



; #FUNCTION# =================================================================================================
; Name...........:  _VK_faveaddGroup()
; Description ...: Добавляет сообщество в закладки.
; Syntax.........: _VK_faveaddGroup()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_faveaddGroup()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.addGroup.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_faveaddGroup



; #FUNCTION# =================================================================================================
; Name...........:  _VK_faveremoveGroup()
; Description ...: Удаляет сообщество из закладок.
; Syntax.........: _VK_faveremoveGroup()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_faveremoveGroup()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.removeGroup.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_faveremoveGroup



; #FUNCTION# =================================================================================================
; Name...........:  _VK_faveaddLink()
; Description ...: Добавляет ссылку в закладки.
; Syntax.........: _VK_faveaddLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_faveaddLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.addLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_faveaddLink



; #FUNCTION# =================================================================================================
; Name...........:  _VK_faveremoveLink()
; Description ...: Удаляет ссылку из закладок.
; Syntax.........: _VK_faveremoveLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_faveremoveLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/fave.removeLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_faveremoveLink

#endregion Favourites Functions

#region Notifications Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_notificationsget()
; Description ...: Возвращает список оповещений об ответах других пользователей на записи текущего пользователя.
; Syntax.........: _VK_notificationsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notificationsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notifications.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notificationsget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_notificationsmarkAsViewed()
; Description ...: Сбрасывает счетчик непросмотренных оповещений об ответах других пользователей на записи текущего пользователя.
; Syntax.........: _VK_notificationsmarkAsViewed()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_notificationsmarkAsViewed()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/notifications.markAsViewed.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_notificationsmarkAsViewed

#endregion Notifications Functions

#region Stats Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_statsget()
; Description ...: Возвращает статистику сообщества или приложения.
; Syntax.........: _VK_statsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_statsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/stats.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_statsget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_statstrackVisitor()
; Description ...: Добавляет данные о текущем сеансе в статистику посещаемости приложения.
; Syntax.........: _VK_statstrackVisitor()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_statstrackVisitor()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/stats.trackVisitor.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_statstrackVisitor



; #FUNCTION# =================================================================================================
; Name...........:  _VK_statsgetPostReach()
; Description ...: Возвращает статистику для записи на стене.
; Syntax.........: _VK_statsgetPostReach()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_statsgetPostReach()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/stats.getPostReach.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_statsgetPostReach

#endregion Stats Functions

#region Apps Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_appsgetCatalog()
; Description ...: Возвращает список приложений, доступных для пользователей сайта через каталог приложений.
; Syntax.........: _VK_appsgetCatalog()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_appsgetCatalog()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/apps.getCatalog.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_appsgetCatalog



; #FUNCTION# =================================================================================================
; Name...........:  _VK_appsget()
; Description ...: Возвращает данные о запрошенном приложении на платформе ВКонтакте
; Syntax.........: _VK_appsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_appsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/apps.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_appsget



; #FUNCTION# =================================================================================================
; Name...........:  _VK_appssendRequest()
; Description ...: Позволяет отправить запрос другому пользователю в приложении, использующем авторизацию ВКонтакте.
; Syntax.........: _VK_appssendRequest()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_appssendRequest()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/apps.sendRequest.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_appssendRequest



; #FUNCTION# =================================================================================================
; Name...........:  _VK_appsdeleteAppRequests()
; Description ...: Удаляет все уведомления о запросах, отправленных из текущего приложения
; Syntax.........: _VK_appsdeleteAppRequests()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_appsdeleteAppRequests()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/apps.deleteAppRequests.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_appsdeleteAppRequests



; #FUNCTION# =================================================================================================
; Name...........:  _VK_appsgetFriendsList()
; Description ...: Создает список друзей, который будет использоваться при отправке пользователем приглашений в приложение.
; Syntax.........: _VK_appsgetFriendsList()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_appsgetFriendsList()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/apps.getFriendsList.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_appsgetFriendsList

#endregion Apps Functions

#region Utilites Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_utilscheckLink()
; Description ...: Возвращает информацию о том, является ли внешняя ссылка заблокированной на сайте ВКонтакте.
; Syntax.........: _VK_utilscheckLink()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_utilscheckLink()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/utils.checkLink.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_utilscheckLink


; #FUNCTION# =================================================================================================
; Name...........:  _VK_utilsresolveScreenName()
; Description ...: Определяет тип объекта (пользователь, сообщество, приложение) и его идентификатор по короткому имени <b>screen_name</b>.
; Syntax.........: _VK_utilsresolveScreenName()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_utilsresolveScreenName()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/utils.resolveScreenName.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_utilsresolveScreenName



; #FUNCTION# =================================================================================================
; Name...........:  _VK_utilsgetServerTime()
; Description ...: Возвращает текущее время на сервере <b>ВКонтакте</b> в <b>unixtime</b>.
; Syntax.........: _VK_utilsgetServerTime()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_utilsgetServerTime()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/utils.getServerTime.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_utilsgetServerTime

#endregion Utilites Functions

#region Database Functions

; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetCountries()
; Description ...: Возвращает список стран.
; Syntax.........: _VK_databasegetCountries()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetCountries()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getCountries.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetCountries



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetRegions()
; Description ...: Возвращает список регионов.
; Syntax.........: _VK_databasegetRegions()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetRegions()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getRegions.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetRegions



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetStreetsById()
; Description ...: Возвращает информацию об улицах по их идентификаторам (<b>id</b>).
; Syntax.........: _VK_databasegetStreetsById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetStreetsById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getStreetsById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetStreetsById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetCountriesById()
; Description ...: Возвращает информацию о странах по их идентификаторам
; Syntax.........: _VK_databasegetCountriesById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetCountriesById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getCountriesById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetCountriesById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetCities()
; Description ...: Возвращает список городов.
; Syntax.........: _VK_databasegetCities()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetCities()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getCities.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetCities



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetCitiesById()
; Description ...: Возвращает информацию о городах по их идентификаторам.
; Syntax.........: _VK_databasegetCitiesById()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetCitiesById()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getCitiesById.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetCitiesById



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetUniversities()
; Description ...: Возвращает список высших учебных заведений.
; Syntax.........: _VK_databasegetUniversities()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetUniversities()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getUniversities.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetUniversities



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetSchools()
; Description ...: Возвращает список школ.
; Syntax.........: _VK_databasegetSchools()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetSchools()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getSchools.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetSchools



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetSchoolClasses()
; Description ...: Возвращает список классов, характерных для школ определенной страны.
; Syntax.........: _VK_databasegetSchoolClasses()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetSchoolClasses()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getSchoolClasses.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetSchoolClasses



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetFaculties()
; Description ...: Возвращает список факультетов.
; Syntax.........: _VK_databasegetFaculties()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetFaculties()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getFaculties.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetFaculties



; #FUNCTION# =================================================================================================
; Name...........:  _VK_databasegetChairs()
; Description ...: Возвращает список кафедр университета по указанному факультету.
; Syntax.........: _VK_databasegetChairs()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_databasegetChairs()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/database.getChairs.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_databasegetChairs

#endregion Database Functions


; #FUNCTION# =================================================================================================
; Name...........:  _VK_giftsget()
; Description ...: Возвращает список полученных подарков пользователя.
; Syntax.........: _VK_giftsget()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_giftsget()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/gifts.get.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_giftsget

; #FUNCTION# =================================================================================================
; Name...........:  _VK_searchgetHints()
; Description ...: Метод позволяет получить результаты быстрого поиска по произвольной подстроке
; Syntax.........: _VK_searchgetHints()
; Parameters ....: $_sAccessToken - ключ доступа выданный функцией авторизации.
;
; Return values .: Успех - Массив идентификаторов и @error = 0.
;                  Неудача - Ошибка выданная сайтом и @error = 1
; Author ........: Medic84
; Remarks .......: Для вызова этой функции приложение должно иметь права с битовой маской, содержащей 2.
; ============================================================================================================
Func _VK_searchgetHints()
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vk.com/method/search.getHints.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_searchgetHints


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
    Local $oIE = _IECreateEmbedded()
    Local $hTimer = TimerInit() , $sURL

    $_hATgui = GUICreate($_sGUITitle, 800, 450, -1, -1, $WS_SYSMENU)
    GUICtrlCreateObj($oIE, 0, 0, 800, 450)

    _IENavigate($oIE, $_sURI)
    $sResponse = _IEBodyReadText($oIE)

    If StringInStr($sResponse, "Пожалуйста, не копируйте") Then
        $sURL = _IEPropertyGet($oIE, "locationurl")
        Return __responseParse($sURL)
    EndIf

    GUISetState(@SW_SHOW)

    While 1
        If GUIGetMsg() = $GUI_EVENT_CLOSE Then
            Exit
        ElseIf TimerDiff($hTimer) > 50 Then
            $sURL = _IEPropertyGet($oIE, "locationurl")
            If StringInStr($sURL, "#access_token") Then
                GUISetState(@SW_HIDE)
                $sResponse = _IEBodyReadText($oIE)
                If StringInStr($sResponse, "Пожалуйста, не копируйте") Then
                    GUIDelete($_hATgui)
                    Return __responseParse($sURL)
                Else
                    GUIDelete($_hATgui)
                    Return SetError(-1,0,-1)
                EndIf
            ElseIf StringInStr($sURL,'error') Then
                Exit
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

	$_sAccessToken = $aResArray[1]

	Return $aResArray
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

	$aRetArray = StringRegExp($sString, "(?si)<" & $sCodeWord & ">(.*?)</" & $sCodeWord & ">", 3)

	Return $aRetArray
EndFunc   ;==>_CreateArray

;===============================================================================
; Description:      _StringFormatTime - Get a string representation of a timestamp
;					according to the format string given to the function.
; Syntax:			_StringFormatTime("format", timestamp)
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


; #FUNCTION# =================================================================================================
; Name...........: _Encoding_URIEncode()
; Description ...: Кодирование текстовой строки в URI-кодю
; Syntax.........: _Encoding_URIEncode($sString)
; Parameters ....: $sString - строка? которую необходимо преобразовать
; Return values .: Успех -  закодированный текст
;                  Неудача - 0
; Author ........: CreatoR
; Remarks .......: Отсутствуют
; ============================================================================================================
Func _Encoding_URIEncode($sString)
	Local $oSC = ObjCreate("ScriptControl")
	$oSC.Language = "JavaScript"
	Local $Encode_URI = $oSC.Eval("encodeURI('" & $sString & "');")

	$oSC = 0

	Return $Encode_URI
EndFunc   ;==>_Encoding_URIEncode

#endregion Internal Functions