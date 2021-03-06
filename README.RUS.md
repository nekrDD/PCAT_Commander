﻿# Описание:
## “C1 Commander” - скрипт AutoIt для автоматизации изменения конфигурационных файлов Comverse C1 Product Catalog (далее PCAT) и Customer Care Client (далее CCC)
для подключении к одной из платформ, прописанных в программе (hardcoded).
Для работы программы необходимо корректно установленный в папку по умолчанию экземпляр PCAT.

## Установка и работа:
### “C1 Commander” распространяется простым копированием (Portable), для начала работы достаточно запустить файл “C1 Commander.exe” сохранив его в любой удобной директории.
### В окне программы выбрать нужную платформу из списка для ССС или PCAT.
### Опционально:
* Ввести логин/пароль для PCAT-а
* Снять галку Auto Select the latest version
### Нажать кнопку “Run PCAT” или “Run ССС”

## Описание работы:
* PCAT Launcher: При запуске считывает текущий SDP_IP из параметра `jdbc_url` в файле `jdbc.properties` на запускаемой машине и выбирает в начало раскрывающегося списка «Platform»
соответствующую платформу, устанавливая в окне программы прописанные для нее значения (Platform, SDP_IP, UPM_IP, Timezone).
* CCC Launcher: При запуске программы считывает ранее сохраненные Login, Password, Platform и заполняет поля программы, найдя соответствующую платформу из списка `models/platforms.au3`.
При первом запуске устанавливается платформа SRT.
<br>
* При нажатии на кнопку “Run PCAT”:
	1.	Записывает в файл jdbc.properties параметр jdbc_url для выбранной платформы
	2.	Изменяет параметр  default_options= “-J-Duser.timezone= “ в файле  internal.conf
	3.	Сохраняет Login и Password в закомментированных строках в конце файла internal.conf.
	4.	Изменяет параметр  client.connect.URL = в файле workpoint-client.properties
	5.	При первом запуске делает бэкап выше указанных файлов с раширением .bkp в тех же папках.
	6.	Запускает «Product Catalog.exe» из пути установки по умолчанию.
	7.	Проверяет доступность security server и выводит предупреждение о невозможности пропагейта, если он недоступен.
* При заполненом поле Login, как только появится окно «Login» попытается выполнить автологин (поле Password  на заполненность не проверяется).
* При установленной галке «Autoselect latest version», при появлении окна выбора версий выбирает последнюю версию из списка.
	Состояние галки не сохраняется между запусками программы, по умолчанию – установлена.
* Меняет заголовок окна с  “Product Catalog” на “PCAT < имя платформы> <часовой пояс>”
* При попытке запустить вторую копию PCAT-а выдает сообщение и делает активным PCAT.
</br></br>
*Внимание! UPM_IP используется только для изменения параметра client.connect.URL = в файле workpoint-client.properties,
security.server.ip в файле security.properties не менятся!*

* При нажатии на кнопку “Run CCC”:
1. Создает копию файла  `Comverse.CCBS.CCC.exe.config` с расширением `.bkp`, если он не сущетвует.
2. Изменяет значение параметра SAPIServiceEndPoint в `Comverse.CCBS.CCC.exe.config` на значение из "SAPI IP" inputBox.
3. Сохраняет Login, Password и выбранное имя платформы в закомментированной строке в конце файла `Comverse.CCBS.CCC.exe.config`.
4. Launches `Customer Care Client.exe` из пути установки по умолчанию.
	* При заполненом поле Login, как только появится окно «Login» попытается выполнить автологин (поле Password  на заполненность не проверяется).
5. Изменяет заголовок окна с "Customer Care Client" на “CCC < Platform name>”
6. При попытке запустить вторую копию CCC, выдает сообщение и делает активным окно ССС.

## FAQ:
1. Почему после нажатия на кнопку “Run PCAT”, запуска PCAT-а не происходит? Возможные причины:
	* Остался висеть процесс “java.exe” от предыдущей, некорректно завершенной работы PCAT.
		* Решение – прибить процесс “java.exe” через диспетчер задач. (внимание, при этомы вы можете убить другие запущенные  java –приложения!)
	* Известный, но плохо изученный баг: PCAT-у не дает запуститься какая-то другая работающая программа
		* Решение – закрывать поочередно работающие программы пока PCAT не запустится. (Чаще всего помогает закрытие “Skype for Business” и “IE/Helpdesk”)
2.	Как удалить сохраненный ранее логин/пароль?
	* Очистить поля Login/Password и нажать “Run PCAT” или “Run CCC”
3.	Как запустить ССС на конкретном SAPI вместо SOAPFARM?
	*	Изменить SAPI IP inputBox, прописав доменное имя SAPI или его IP, например, "SAPI1-srt.vimpelcom.ru" или "172.25.186.168".

### Known issues:
1.	Возможность запустить несколько копий
2.	Хранение незашифрованного пароля

### Change Log
* 1.2 :
	* Bugfix for autologin feature: special symbols were not sent to PCAT login.
* 1.2.1 :
	* Убрано исползование буфера обмена для автоматического ввода логина/пароля (позволяло поддерживать наличие кирилллицы в пароле, но работало не стабильно)
* 1.2.2 :
	* Исправлен часовой пояс для платформы EKT
* 1.2.3 :
	* Исправлен SDP_IP для платформы RST (ранее ошибочно использовался IP ноды А, заменен на кластерный).
	* В файле internal.conf, в строке  `default_options=` теперь изменяется только часовой пояс, остальные параметры остаются без изменений. В предыдущих версиях строка заменялась целиком на рекомендованные поставщиком параметры.
	* Добавлена проверка искомых строк перед их изменением в конфиг файлах.
* 2.0
	* Добавлен CCC Launcher
	* Добавлено меню Help
* 2.1 :
	* MSK SDP IP changed
* 2.1.1 :
	* Mercury SDP and UPM IPs changed