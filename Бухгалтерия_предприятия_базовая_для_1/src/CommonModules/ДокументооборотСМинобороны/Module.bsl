////////////////////////////////////////////////////////////////////////////////
// Подсистема "Документооборот с Министерством обороны России".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
	
Функция ПолучитьНастройки(Организация) Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("СертификатАбонентаОтпечаток", "");
	Настройки.Вставить("ИспользоватьОбмен", Ложь);
	Настройки.Вставить("ОбменНастроен", Ложь);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НастройкиОбменаМинобороны.ИспользоватьОбмен КАК ИспользоватьОбмен,
	|	НастройкиОбменаМинобороны.СертификатАбонентаОтпечаток КАК Сертификат
	|ИЗ
	|	РегистрСведений.НастройкиОбменаМинобороны КАК НастройкиОбменаМинобороны
	|ГДЕ
	|	НастройкиОбменаМинобороны.Организация = &Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Настройки.СертификатАбонентаОтпечаток = Выборка.Сертификат;
		Настройки.ИспользоватьОбмен = Выборка.ИспользоватьОбмен;
		Настройки.ОбменНастроен = ЗначениеЗаполнено(Выборка.Сертификат);
	КонецЕсли;
		
	Возврат Настройки;
	
КонецФункции

Функция СохранитьНастройки(Организация, Сертификат) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.НастройкиОбменаМинобороны.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация = Организация;
	МенеджерЗаписи.ИспользоватьОбмен = Истина;
	МенеджерЗаписи.СертификатАбонентаОтпечаток = Сертификат;
	МенеджерЗаписи.Записать();
	
	Возврат ПолучитьНастройки(Организация);
	
КонецФункции

Функция ПолучитьТекстЗапросаДляФормыНастроек() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА Организации.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК ПометкаУдаления,
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(НастройкиОбменаМинобороны.ИспользоватьОбмен, ЛОЖЬ)
	|			ТОГДА ""Используется""
	|		ИНАЧЕ ""Не используется""
	|	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаМинобороны КАК НастройкиОбменаМинобороны
	|		ПО (НастройкиОбменаМинобороны.Организация = Организации.Ссылка)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьТекстыДляЗапросаСпискаНастроекОбмена() Экспорт
	
	ПеречислениеКолонок =
		"	ЕСТЬNULL(НастройкиОбменаМинобороны.ИспользоватьОбмен, ЛОЖЬ) КАК НастройкиОбменаМинобороны_ИспользоватьОбмен,
		|	ЕСТЬNULL(НастройкиОбменаМинобороны.СертификатАбонентаОтпечаток, """") КАК НастройкиОбменаМинобороны_СертификатАбонентаОтпечаток";
	
	СоединениеСОрганизацией =
		"		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаМинобороны КАК НастройкиОбменаМинобороны
		|		ПО НастройкиОбменаМинобороны.Организация = Организации.Ссылка";
	
	Возврат Новый Структура("ПеречислениеКолонок, СоединениеСОрганизацией", ПеречислениеКолонок, СоединениеСОрганизацией);
	
КонецФункции

Функция ПолучитьТекстЗапросаДляВсеОтправки() Экспорт
	
	ТекстЗапроса = 
	"
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтправкиМинобороны.ПометкаУдаления,
	|	ОтправкиМинобороны.Ссылка,
	|	""Минобороны"",
	|	"""",
	|	ОтправкиМинобороны.Организация,
	|	ОтправкиМинобороны.ПредставлениеПериода,
	|	ОтправкиМинобороны.ПредставлениеВидаДокумента,
	|	ОтправкиМинобороны.ДатаОтправки,
	|	ВЫБОР
	|		КОГДА ГОД(ОтправкиМинобороны.ДатаЗакрытия) = 3999
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ОтправкиМинобороны.ДатаЗакрытия
	|	КОНЕЦ,
	|	ОтправкиМинобороны.Идентификатор,
	|	НЕОПРЕДЕЛЕНО
	|ИЗ
	|	Справочник.ОтправкиМинобороны КАК ОтправкиМинобороны
	|ГДЕ
	|	ОтправкиМинобороны.ОтчетСсылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СвойстваОбменаОрганизации(Знач ОрганизацияСсылка, 
									  ОтчетСсылка = Неопределено) Экспорт
	
	Результат = Новый Структура("НастройкиОбмена, 
									|ПравоИзмененияУчетнойЗаписи, 
									|ЭтоРегламентированныйОтчет, 
									|ЭтоЭлектроннаяПодписьВМоделиСервиса", 
									Неопределено, Неопределено, Неопределено, Неопределено);
	
	
	Результат.ЭтоЭлектроннаяПодписьВМоделиСервиса = Ложь;
	Результат.НастройкиОбмена = ПолучитьНастройки(ОрганизацияСсылка);
	Результат.ПравоИзмененияУчетнойЗаписи = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиОбменаМинобороны);
	
	Если ОтчетСсылка <> Неопределено Тогда
		
		ТипЗнчСсылкаНаОтчет = ТипЗнч(ОтчетСсылка);
		Результат.ЭтоРегламентированныйОтчет = (ТипЗнчСсылкаНаОтчет = Тип("ДокументСсылка.РегламентированныйОтчет") ИЛИ ТипЗнчСсылкаНаОтчет = Тип("Неопределено"));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьАрхивПакета(ПараметрыАрхивации) Экспорт

	ИмяФайлаПодписи = ПараметрыАрхивации.ИмяФайлаПодписи;
	СтрокаДанныхПодписи = ПараметрыАрхивации.СтрокаДанныхПодписи;
	ИмяФайлаВыгрузки = ПараметрыАрхивации.ИмяФайлаВыгрузки;
	АдресФайлаВыгрузки = ПараметрыАрхивации.АдресФайлаВыгрузки;
	ОтчетСсылка = ПараметрыАрхивации.ОтчетСсылка;
	
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", Ложь);
	Результат.Вставить("АдресАрхива", Неопределено);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ДатаСоставления", ОтчетСсылка.ДатаОкончания);
	
	ДвоичныеДанныеФайлаВыгрузки = ПолучитьИзВременногоХранилища(АдресФайлаВыгрузки);
	
	КаталогВременныхФайловНаСервере = ПолучитьКаталогВременныхФайлов();
	ПолноеИмяФайлаПодписи = КаталогВременныхФайловНаСервере + ИмяФайлаПодписи;
	ПолноеИмяФайлаВыгрузки = КаталогВременныхФайловНаСервере + ИмяФайлаВыгрузки;
	
	// записываем файл без BOM
	Попытка
		Текст = Новый ЗаписьТекста(ПолноеИмяФайлаПодписи, КодировкаТекста.ANSI,,,Символы.ПС);
		Текст.Записать(СтрокаДанныхПодписи);
		Текст.Закрыть();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Электронный документооборот с минобороны. Запись файлов пакета'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ТекстОшибки = НСтр("ru='Ошибка записи файла отчета на сервере.'");
		Результат.ОписаниеОшибки = ТекстОшибки;
		Возврат Результат;
	КонецПопытки;
	
	ДвоичныеДанныеФайлаВыгрузки.Записать(ПолноеИмяФайлаВыгрузки);
	
	ПолноеИмяФайлаАрхива = ПолучитьИмяВременногоФайла();
	
	ЗаписьZIP = Новый ЗаписьZipФайла(ПолноеИмяФайлаАрхива,
										"", 
										"",
										МетодСжатияZIP.Копирование,
										УровеньСжатияZIP.Минимальный,
										МетодШифрованияZIP.Zip20);
										
	ЗаписьZIP.Добавить(ПолноеИмяФайлаПодписи);
	ЗаписьZIP.Добавить(ПолноеИмяФайлаВыгрузки);
		
	Попытка
		ЗаписьZIP.Записать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Электронный документооборот с минобороны. Запись zip архива пакета'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ТекстОшибки = НСтр("ru='Ошибка записи файла архива на сервере.'");
		Результат.ОписаниеОшибки = ТекстОшибки;
		Возврат Результат;
	КонецПопытки;
	
	Данные = Новый ДвоичныеДанные(ПолноеИмяФайлаАрхива);
	Адрес = ПоместитьВоВременноеХранилище(Данные, Новый УникальныйИдентификатор);
	
	УдалитьФайлы(ПолноеИмяФайлаАрхива);
	УдалитьФайлы(ПолноеИмяФайлаПодписи);
	УдалитьФайлы(ПолноеИмяФайлаВыгрузки);
	
	Результат.АдресАрхива = Адрес;
	Результат.Выполнено = Истина;
	
	Возврат Результат;
		
КонецФункции

Функция ТекущаяДатаНаСервере() Экспорт
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции

Функция СтрокаОтпечаткаВДвоичныеДанные(Строка) Экспорт
	
	ДлинаОтпечаткаВБайтах = 20;
	
	Если СтрДлина(Строка) <> ДлинаОтпечаткаВБайтах * 2 Тогда
		ВызватьИсключение "Неверная длина строкового представления отпечатка!";
	КонецЕсли; 
	
	Данные = ПолучитьДвоичныеДанныеИзHexСтроки(Строка);
	
	Проверка = ДокументооборотСМинобороныКлиентСервер.ДвоичныеДанныеВСтроку(Данные) = Строка;
	Если НЕ Проверка Тогда
		ВызватьИсключение "Ошибка преобразования строки в двоичные данные!";
	КонецЕсли; 
	
	Возврат Данные;
	
КонецФункции

Функция ПрочитатьАрхивОтвета(Адрес) Экспорт
	
	ВременныйКаталог = ПолучитьКаталогВременныхФайлов();
	
	Данные = ПолучитьИзВременногоХранилища(Адрес);
	ИмяВременногоФайла = ВременныйКаталог + Строка(Новый УникальныйИдентификатор) + ".zip";
	Данные.Записать(ИмяВременногоФайла);
	
	ЧтениеZip = Новый ЧтениеZipФайла;
	ЧтениеZip.Открыть(ИмяВременногоФайла);
	
	Результат = Новый Структура;
	Результат.Вставить("ИсходныеДанные", Неопределено);
	Результат.Вставить("Подпись", Неопределено);
	
	Для каждого Файл Из ЧтениеZip.Элементы Цикл
		
		ИмяФайлВАрхиве = Файл.Имя;
		Если СтрНайти("message.xml,message.sign", ИмяФайлВАрхиве) = 0 Тогда
			Продолжить;
		КонецЕсли; 
		
		ИмяВременногоФайлаПослеРаспаковки = ВременныйКаталог + ИмяФайлВАрхиве;
		ЧтениеZip.Извлечь(Файл, ВременныйКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		
		Если ИмяФайлВАрхиве = "message.xml" Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайлаПослеРаспаковки);
			Результат.ИсходныеДанные = ДвоичныеДанные;
		ИначеЕсли ИмяФайлВАрхиве = "message.sign" Тогда
			Текст = Новый ТекстовыйДокумент;
			Текст.Прочитать(ИмяВременногоФайлаПослеРаспаковки);
			СтрокаВBase64 = Текст.ПолучитьТекст();
			// переводим из url-safe в обычное кодирование
			СтрокаВBase64 = СтрЗаменить(СтрЗаменить(СтрокаВBase64, "-", "+"), "_", "/");
			ДвоичныеДанные = Base64Значение(СтрокаВBase64);
			Результат.Подпись = ДвоичныеДанные;
		КонецЕсли;
		
		УдалитьФайлы(ИмяВременногоФайлаПослеРаспаковки);
		
	КонецЦикла; 
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат Результат;
	
КонецФункции

Функция СохранитьОтвет(Параметры) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", Истина);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОтчетСсылка", Неопределено);
	Результат.Вставить("ТекстПротокола", "");
	Результат.Вставить("ОтправкаСсылка", Неопределено);
	
	ДанныеОтвета = Параметры.ДанныеОтвета;
	ИмяФайла = Параметры.ИмяФайла;
	Идентификатор = Параметры.Идентификатор;
	АдресАрхива = Параметры.АдресАрхива;
	
	// находим последнюю отправку с заданным идентификатором
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	ОтправкиМинобороны.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ОтправкиМинобороны КАК ОтправкиМинобороны
	               |ГДЕ
	               |	ОтправкиМинобороны.Идентификатор = &Идентификатор
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ОтправкиМинобороны.ДатаОтправки УБЫВ";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Отправки = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
	Если Отправки.Количество() = 0 Тогда
		Результат.Выполнено = Ложь;
		Результат.ОписаниеОшибки = НСтр("ru='Ошибка поиска данных о передаче пакета.'", "ru");
		Возврат Результат;
	КонецЕсли;
	
	Отправка = Отправки[0].Ссылка.ПолучитьОбъект();
	Отправка.Протокол = Новый ХранилищеЗначения(ДанныеОтвета, Новый СжатиеДанных(9));
	Отправка.ДатаПолученияРезультата = ТекущаяДатаНаСервере();
	Отправка.ДатаЗакрытия = Отправка.ДатаПолученияРезультата;
	Отправка.ИмяФайлаУведомления = ИмяФайла;
	Отправка.Уведомление = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресАрхива), Новый СжатиеДанных(9));
	
	// определяем статус
	ЧтениеДанных = Новый ЧтениеДанных(ДанныеОтвета, КодировкаТекста.UTF8);
	СтрокаПротокола = ЧтениеДанных.ПрочитатьСимволы();
	ОписаниеОшибки = "";
	Результат.ТекстПротокола = СтрокаПротокола;
	
	Попытка
		Если Отправка.ПометкаУдаления Тогда
			Отправка.ПометкаУдаления = Ложь;
		КонецЕсли;
		Отправка.Записать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Электронный документооборот с минобороны. Сохранение отправки'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		Результат.Выполнено = Ложь;
		Результат.ОписаниеОшибки = НСтр("ru='Ошибка записи инфомации в базу данных.'", "ru");
		Возврат Результат;
	КонецПопытки;
	
	Результат.ОтправкаСсылка = Отправка.Ссылка;
	Результат.ОтчетСсылка = Отправка.ОтчетСсылка;
	
	Возврат Результат;
	
КонецФункции

Функция СохранитьСтатусОтправки(Отправка, Статус) Экспорт
	
	ОтправкаОбъект = Отправка.ПолучитьОбъект();
	ОтправкаОбъект.СтатусОтправки = Статус;
	Попытка
		ОтправкаОбъект.Записать();
	Исключение
		ИнформацияОбОшибке = СтрШаблон("ru = 'Ошибка при записи отправки Минобороны: %1'", ОписаниеОшибки());
		ИнформацияОбОшибке = НСтр(ИнформацияОбОшибке);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Электронный документооборот с минобороны. Определение статуса протокола.'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ИнформацияОбОшибке);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция СохранитьПакет(Параметры) Экспорт
	
	СсылкаНаОтчет          = Параметры.ОтчетСсылка;
	ИмяФайлаПакета         = Параметры.ИмяФайлаПакета;
	Организация            = Параметры.ОрганизацияСсылка;
	КаталогВыгрузки        = Параметры.КаталогВыгрузки;
	АдресДанныхПакета      = Параметры.АдресДанныхПакета;
	
	ДвоичныеДанныеПакета = ПолучитьИзВременногоХранилища(АдресДанныхПакета);
	Идентификатор = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаПакета).ИмяБезРасширения;
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		НоваяОтправка = Справочники.ОтправкиМинобороны.СоздатьЭлемент();
		
		НоваяОтправка.ОтчетСсылка                = СсылкаНаОтчет;
		НоваяОтправка.Идентификатор              = Идентификатор;
		НоваяОтправка.Пакет                      = Новый ХранилищеЗначения(ДвоичныеДанныеПакета, Новый СжатиеДанных(9));
		НоваяОтправка.ИмяФайлаПакета             = ИмяФайлаПакета;
		НоваяОтправка.КаталогВыгрузки            = КаталогВыгрузки;
		НоваяОтправка.ДатаОтправки               = ТекущаяДатаСеанса();
		НоваяОтправка.Организация                = Организация;
		НоваяОтправка.ВидОтчета                  = Справочники.ВидыОтправляемыхДокументов.ИсполнениеКонтрактовГОЗ;
		НоваяОтправка.ДатаНачалаПериода          = СсылкаНаОтчет.ДатаНачала; 
		НоваяОтправка.ДатаОкончанияПериода       = СсылкаНаОтчет.ДатаОкончания;
		НоваяОтправка.Версия                     = СсылкаНаОтчет.Вид;
		НоваяОтправка.ПредставлениеПериода       = ПредставлениеПериода(НоваяОтправка.ДатаНачалаПериода, КонецДня(НоваяОтправка.ДатаОкончанияПериода), "ФП=Истина");
		НоваяОтправка.ПредставлениеВидаДокумента = СсылкаНаОтчет.ПредставлениеВида;
		НоваяОтправка.СтатусОтправки             = Перечисления.СтатусыОтправки.Отправлен;
		
		Попытка
			НоваяОтправка.Записать();
		Исключение
			Возврат Неопределено;
		КонецПопытки;

		Возврат НоваяОтправка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПоследнююОтправкуОтчета(ОтчетСсылка) Экспорт
	
	Отправка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтправкиМинобороны.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ОтправкиМинобороны КАК ОтправкиМинобороны
	|ГДЕ
	|	ОтправкиМинобороны.ОтчетСсылка = &ЭтотОтчет
	|	И НЕ ОтправкиМинобороны.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОтправкиМинобороны.ДатаОтправки УБЫВ";
	Запрос.Параметры.Вставить("ЭтотОтчет", ОтчетСсылка);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Отправка = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат Отправка;
	
КонецФункции

Функция ПолучитьНеЗавершенныеОтправки(Организация) Экспорт
	
	Настройки = ПолучитьНастройки(Организация);
	Если ЗначениеЗаполнено(Настройки) И Настройки.ИспользоватьОбмен Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОтправкиМинобороны.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ОтправкиМинобороны КАК ОтправкиМинобороны
		|ГДЕ
		|	ОтправкиМинобороны.СтатусОтправки = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Отправлен) И
		|	НЕ ОтправкиМинобороны.ПометкаУдаления
		|	И ОтправкиМинобороны.Организация = &Организация";
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьАдресДереваПротоколаСдачи(ИсточникСсылка) Экспорт
	
	ТипИсточника = ТипЗнч(ИсточникСсылка);
	ДеревоПротокола = Неопределено;
	Результат = Неопределено;
	
	Если ТипИсточника = Тип("СправочникСсылка.ОтправкиМинобороны") Тогда
		Отправка = ИсточникСсылка;
	Иначе //РегламентированныйОтчет или ЭлектронноеПредставление
		Отправка = ДокументооборотСМинобороны.ПолучитьПоследнююОтправкуОтчета(ИсточникСсылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отправка) Тогда 
		Протокол = Отправка.Протокол.Получить();
		Если Протокол <> Неопределено Тогда
			ЧтениеДанных = Новый ЧтениеДанных(Протокол, КодировкаТекста.UTF8);
			Строка = ЧтениеДанных.ПрочитатьСимволы();
			ОписаниеОшибки = "";
			ДеревоПротокола = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЗагрузитьСтрокуXMLВДеревоЗначений(Строка, ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
	Результат = ПоместитьВоВременноеХранилище(ДеревоПротокола, Новый УникальныйИдентификатор);
	
	Возврат Результат;
	
КонецФункции

Функция УстановитьНовыйСтатус(Отчет, Знач Статус) Экспорт
	
	Если ТипЗнч(Статус) = Тип("Строка") Тогда
		Статус = ДокументооборотСМинобороныКлиентСервер.СтатусИзСтрокиВПеречисление(Статус);
	КонецЕсли; 
	
	Отправка = ПолучитьПоследнююОтправкуОтчета(Отчет);
	Если Отправка <> Неопределено Тогда
		ОтправкаОбъект = Отправка.ПолучитьОбъект();
	Иначе
		Возврат Ложь;
	КонецЕсли; 
	ОтправкаОбъект.СтатусОтправки = Статус;
	ОтправкаОбъект.Записать();
	Возврат Истина;
	
КонецФункции

Функция СтатусУстановленВручную(Отправка, Знач СтатусИзЖурнала) Экспорт
	
	Если СтатусИзЖурнала = "Передано в Минобороны" Тогда
		СтатусИзЖурнала = "Передано";
	КонецЕсли; 
	
	СтатусИзЖурналаПеречисление = ДокументооборотСМинобороныКлиентСервер.СтатусИзСтрокиВПеречисление(СтатусИзЖурнала);
	
	Возврат СтатусИзЖурнала = "В работе" ИЛИ НЕ ЗначениеЗаполнено(Отправка) ИЛИ (ЗначениеЗаполнено(Отправка) И Отправка.СтатусОтправки <> СтатусИзЖурналаПеречисление);
	
КонецФункции

Функция СформироватьПрокси(НастройкиПрокси, Протокол)
	
	Прокси = Новый ИнтернетПрокси;
	Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкиПрокси["НеИспользоватьПроксиДляЛокальныхАдресов"];
	Прокси.Установить(Протокол, НастройкиПрокси["Сервер"], СтроковыеФункцииКлиентСервер.СтрокаВЧисло(НастройкиПрокси["Порт"]), НастройкиПрокси["Пользователь"], НастройкиПрокси["Пароль"]);
		
	Возврат Прокси;
	
КонецФункции

Функция ПроверитьПараметрыНаСервереИнтернетПоддержки(Логин = "", Пароль = "")
	
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", Ложь);
	Результат.Вставить("ОшибкаСоединенияССервером", Ложь);
	Результат.Вставить("ОшибкаАвторизации", Ложь);
	Результат.Вставить("ОшибкаВыполненияЗапроса", Ложь);
	Результат.Вставить("СтатусПоддержки", Ложь);
	Результат.Вставить("СтатусПодпискиИТС", Ложь);
	Результат.Вставить("СтатусРегистрации", Ложь);
	
	ИмяПрограммы = "";
	ИнтернетПоддержкаПользователейПереопределяемый.ПриОпределенииИмениПрограммы(ИмяПрограммы);
	
	Если ПустаяСтрока(ИмяПрограммы) Тогда
		// по умолчанию считаем, что это БП
		ИмяПрограммы = "Accounting";
	КонецЕсли;
	
	АдресСервиса = "1cv8update.com";
	АдресРесурса = "/rest/public/checkProgram/" + ИмяПрограммы;
	
	СтрокаПараметров = "{
	|  ""auth"": {
	|    ""login"": ""%1"",
	|    ""password"": ""%2""
	|  },
	|  ""getUpdateAvailabilityStatus"": false,
	|  ""params"": {},
	|  ""platformVersion"": ""%3"",
	|  ""programVersion"": ""%4""
	|}";
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	ВерсияПрограммы = ИнтернетПоддержкаПользователей.ВерсияКонфигурации();
	
	СтрокаПараметров = СтрШаблон(СтрокаПараметров, Логин, Пароль, ВерсияПлатформы, ВерсияПрограммы );

	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаПараметров, КодировкаТекста.UTF8);
	HTTPЗапрос.Заголовки.Вставить("Accept", "application/json");
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	
	// инициализируем настройки прокси, если они определены
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкаПроксиСервера <> Неопределено Тогда
		Прокси = СформироватьПрокси(НастройкаПроксиСервера, "http");
	Иначе
		Прокси = Новый ИнтернетПрокси;
	КонецЕсли;
	
	Таймаут = 5;
	HTTPСоединение = Новый HTTPСоединение(АдресСервиса,,,,
		Прокси,
		Таймаут,
		Новый ЗащищенноеСоединениеOpenSSL);
		
	Попытка
		Ответ = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		Результат.ОшибкаСоединенияССервером = Истина;
		Результат.Выполнено = Истина;
		Возврат Результат;
	КонецПопытки;
	
	Если Ответ.КодСостояния = 200 Тогда
		
		СтрокаОтвет = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
		Если Не ПустаяСтрока(СтрокаОтвет) Тогда
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(СтрокаОтвет);
			Данные = ФабрикаXDTO.ПрочитатьJSON(ЧтениеJSON);
			ЧтениеJSON.Закрыть();
			
			СтатусАвторизации = Данные.authResult.authenticated;
			Если НЕ СтатусАвторизации Тогда
				Результат.ОшибкаАвторизации = Истина;
				Возврат Результат;
			КонецЕсли;
			
			Если Данные.programName = Неопределено Тогда
				Результат.Выполнено = Истина;
				Возврат Результат;
			КонецЕсли;
			
			НеизвестныйСтатус = Неопределено;
			
			СтатусПоддержки = Данные.supportConditionsImplStatus.status;
			СтатусПодпискиИТС = Данные.supportConditionsImplStatus.itsStatus;
			СтатусРегистрации = Данные.supportConditionsImplStatus.productRegistrationStatus;
			
			Если СтатусПоддержки <> "OK" И СтатусПоддержки <> "WARNING" Тогда
				// Статус ИТС.
				Результат.СтатусПодпискиИТС =
					СтатусПодпискиИТС = "OK"
					ИЛИ СтатусПодпискиИТС = "WARNING"
					ИЛИ СтатусПодпискиИТС = НеизвестныйСтатус;
				// Статус регистрации.
				Результат.СтатусРегистрации =
					СтатусРегистрации = "REGISTERED"
					ИЛИ СтатусРегистрации = НеизвестныйСтатус;
				// Иногда общий статус поддержки неизвестен.
				Если СтатусПоддержки =
					НеизвестныйСтатус
					И Данные.supportConditionsImplStatus.blockStatus = "503"
					И Результат.СтатусПодпискиИТС
					И Результат.СтатусРегистрации Тогда
					// Перерпределяем статус поддержки на основании других статусов.
					Результат.СтатусПоддержки = Истина;
					Результат.Выполнено = Истина;
				КонецЕсли;
				Возврат Результат;
			Иначе
				Результат.СтатусПодпискиИТС = Истина;
				Результат.СтатусРегистрации = Истина;
				Результат.СтатусПоддержки = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Результат.Выполнено = Истина;
		
	Иначе
		
		Результат.ОшибкаВыполненияЗапроса = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьВозможностьВыполненияОперации(Знач ПараметрыАутентификации) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат "ВыполнениеРазрешено";
	Иначе
		РезультатПроверкиПоддержки = ПроверитьПараметрыНаСервереИнтернетПоддержки();
		Если РезультатПроверкиПоддержки.ОшибкаСоединенияССервером Тогда
			Возврат "ВыполнениеРазрешено";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации)
			ИЛИ НЕ (ПараметрыАутентификации.Свойство("Логин") И ЗначениеЗаполнено(ПараметрыАутентификации.Логин))
			ИЛИ НЕ (ПараметрыАутентификации.Свойство("Пароль") И ЗначениеЗаполнено(ПараметрыАутентификации.Пароль)) Тогда
			УстановитьПривилегированныйРежим(Истина);
			ПараметрыАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации) Тогда
			Возврат "ПараметрыАутентификацииНеЗаполнены";
		Иначе
			Результат = ПараметрыАутентификацииКорректные(ПараметрыАутентификации);
			Если Результат = "НекорректноеИмяПользователяИлиПароль" Тогда
				Возврат "ПараметрыАутентификацииУказаныНеВерно";
			ИначеЕсли Результат = "АутентификацияВыполнена" Тогда
				РезультатПроверкиПоддержки = ПроверитьПараметрыНаСервереИнтернетПоддержки(ПараметрыАутентификации.Логин, ПараметрыАутентификации.Пароль);
				Если НЕ РезультатПроверкиПоддержки.Выполнено Тогда
					// не выполнены условия поддержки или сервер не доступен
					Если РезультатПроверкиПоддержки.ОшибкаСоединенияССервером Тогда
						Возврат "ОшибкаСоединенияССервером";
					КонецЕсли;
					Если РезультатПроверкиПоддержки.ОшибкаВыполненияЗапроса Тогда
						Возврат "ОшибкаВыполненияЗапроса";
					КонецЕсли;
					Если РезультатПроверкиПоддержки.ОшибкаАвторизации Тогда
						Возврат "ПараметрыАутентификацииУказаныНеВерно";
					ИначеЕсли НЕ РезультатПроверкиПоддержки.СтатусПоддержки Тогда
						Если РезультатПроверкиПоддержки.СтатусРегистрации = Неопределено ИЛИ НЕ РезультатПроверкиПоддержки.СтатусРегистрации  Тогда
							Возврат "ОтсутствуетРегистрацияПродукта";
						КонецЕсли;
						Если РезультатПроверкиПоддержки.СтатусПодпискиИТС = Неопределено ИЛИ НЕ РезультатПроверкиПоддержки.СтатусПодпискиИТС  Тогда
							Возврат "ОтсутствуетПодпискаИТС";
						КонецЕсли;
						Возврат "НеВыполненыУсловияПоддержки";
					Иначе
						Возврат "ВыполнениеЗапрещено";
					КонецЕсли;
				Иначе
					Возврат "ВыполнениеРазрешено";
				КонецЕсли;
			ИначеЕсли Результат = "НеизвестнаяОшибка" Тогда
				Возврат "НеизвестнаяОшибкаПриПроверке";
			Иначе
				Возврат "ВыполнениеЗапрещено";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ЗагрузитьСертификатыМинобороны() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Сертификаты", Новый Массив);
	Результат.Вставить("Хранилища", Новый Соответствие);
	Результат.Вставить("ОписаниеОшибки", "");
	
	ОписаниеОшибки = "";
	Соединение = УстановитьСоединениеССерверомМеханизмаОнлайнСервисовРО(, ОписаниеОшибки);
	Если Соединение = Неопределено Тогда
		ОписаниеОшибки = "Ошибка установки соединения с сервером справочной информации"
			+ ?(ЗначениеЗаполнено(ОписаниеОшибки), ": " + ОписаниеОшибки, ".");
		Результат.ОписаниеОшибки = ОписаниеОшибки;
		Возврат Результат;
	КонецЕсли;
	
	// получаем файл с сервера
	ИмяФайлаСертификатов = ПолучитьРесурсССервера(Соединение, "mod.dat", ОписаниеОшибки);
	Если ИмяФайлаСертификатов = Неопределено Тогда
		ОписаниеОшибки = "Ошибка получения файла c сертификатами с сервера справочной информации"
			+ ?(ЗначениеЗаполнено(ОписаниеОшибки), ": " + ОписаниеОшибки, ".");
		Результат.ОписаниеОшибки = ОписаниеОшибки;
		Возврат Результат;
	КонецЕсли;
	
	Файл = Новый ЧтениеТекста(ИмяФайлаСертификатов, КодировкаТекста.UTF8);
	ДанныеФайла = Файл.Прочитать();
	Файл.Закрыть();
	УдалитьФайлы(ИмяФайлаСертификатов);
	
	ДеревоСертификатов = ЗагрузитьСтрокуXMLВДеревоЗначений(ДанныеФайла);
	
	ТаблицаСертификатов = Новый Массив;
	
	ДанныеСертификатаШаблон = Новый Структура;
	ДанныеСертификатаШаблон.Вставить("Описание", "");
	ДанныеСертификатаШаблон.Вставить("Отпечаток", "");
	ДанныеСертификатаШаблон.Вставить("Хранилище", "");
	ДанныеСертификатаШаблон.Вставить("СодержимоеСертификата", "");
	ДанныеСертификатаШаблон.Вставить("СодержимоеСертификатаBase64", "");
	ДанныеСертификатаШаблон.Вставить("СертификатНайденВХранилище", Ложь);
	
	Хранилища = Новый Соответствие;
	
	Для каждого Строка Из ДеревоСертификатов.Строки Цикл
		Если Строка.Имя = "Сертификаты" Тогда
			Для каждого СтрокаСертификатов Из Строка.Строки Цикл
				Если СтрокаСертификатов.Имя = "Сертификат" Тогда
					
					СтрокаТаблицыСертификатов = КопироватьПростуюСтруктуру(ДанныеСертификатаШаблон);
					Для каждого ДанныеСертификата Из СтрокаСертификатов.Строки Цикл
						Если ДанныеСертификата.Имя                         = "Описание" Тогда
							СтрокаТаблицыСертификатов.Описание                = ДанныеСертификата.Значение;
						ИначеЕсли ДанныеСертификата.Имя                    = "Отпечаток" Тогда
							СтрокаТаблицыСертификатов.Отпечаток               = ДанныеСертификата.Значение;
						ИначеЕсли ДанныеСертификата.Имя                    = "Хранилище" Тогда
							СтрокаТаблицыСертификатов.Хранилище               = ДанныеСертификата.Значение;
						ИначеЕсли ДанныеСертификата.Имя                    = "Данные" Тогда
							СодержимоеВВидеСтроки = ДанныеСертификата.Значение;
							СодержимоеБинарное = Base64Значение(СодержимоеВВидеСтроки);
							СтрокаТаблицыСертификатов.СодержимоеСертификата   = СодержимоеБинарное;
							СтрокаТаблицыСертификатов.СодержимоеСертификатаBase64 = СодержимоеВВидеСтроки;
						КонецЕсли;
					КонецЦикла;
					
					// проверяем заполненность данных
					Если ПустаяСтрока(СтрокаТаблицыСертификатов.Отпечаток) ИЛИ 
						СтрокаТаблицыСертификатов.СодержимоеСертификата.Размер() = 0 ИЛИ
						ПустаяСтрока(СтрокаТаблицыСертификатов.Хранилище) Тогда
						Продолжить;
					КонецЕсли;
					
					Хранилища.Вставить(СтрокаТаблицыСертификатов.Хранилище, Истина);
					
					СтрокаТаблицыСертификатов.СертификатНайденВХранилище = Ложь;
					ТаблицаСертификатов.Добавить(СтрокаТаблицыСертификатов);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Результат.Сертификаты = ТаблицаСертификатов;
	Результат.Хранилища = Хранилища;
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьВЖурналРегистрации(Уровень, ТекстОшибки) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), Уровень,,, ТекстОшибки);
	
КонецПроцедуры

Функция ПолучитьКоличествоОтправокМинобороныНаДату(Организация, Дата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтправкиМинобороны.Ссылка) КАК КоличествоОтправок,
	               |	ОтправкиМинобороны.Организация КАК Организация
	               |ИЗ
	               |	Справочник.ОтправкиМинобороны КАК ОтправкиМинобороны
	               |ГДЕ
	               |	ОтправкиМинобороны.ПометкаУдаления = ЛОЖЬ
	               |	И НАЧАЛОПЕРИОДА(ОтправкиМинобороны.ДатаОтправки, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтправки, ДЕНЬ)
	               |	И ОтправкиМинобороны.Организация = &Организация
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ОтправкиМинобороны.Организация";
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ДатаОтправки", Дата);
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.КоличествоОтправок;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция СтатусОтчетаУстановленВручную(СсылкаНаОтчет, Статус) Экспорт
	
	Отправка = ПолучитьПоследнююОтправкуОтчета(СсылкаНаОтчет);
	СтатусУстановленВручную = СтатусУстановленВручную(Отправка, Статус);
	Возврат СтатусУстановленВручную;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьНастройкиМеханизмаОнлайнСервисовРО() Экспорт
	
	Результат = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьНастройкиМеханизмаОнлайнСервисовРО();
	
	Возврат Результат;
	
КонецФункции

Функция УстановитьСоединениеССерверомМеханизмаОнлайнСервисовРО(ПараметрыСоединения = Неопределено, ОписаниеОшибки = Неопределено) Экспорт
	
	URLСервера = "downloads.1c.ru";
	
	Если ПараметрыСоединения = Неопределено Тогда
		НастройкиДоступаВИнтернет = ПолучитьНастройкиМеханизмаОнлайнСервисовРО();
	Иначе
		НастройкиДоступаВИнтернет = ПараметрыСоединения;
	КонецЕсли;
	
	Если НастройкиДоступаВИнтернет.ИспользоватьПрокси = Истина Тогда
		Попытка
			Прокси               = Новый ИнтернетПрокси;
			Прокси.Пользователь  = НастройкиДоступаВИнтернет.ИмяПользователя;
			Прокси.Пароль        = НастройкиДоступаВИнтернет.Пароль;
		Исключение
			ОписаниеОшибки = ИнформацияОбОшибке().Описание;
			Возврат Неопределено;
		КонецПопытки;
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	
	Таймаут = 10;
	Попытка
		Соединение = Новый HTTPСоединение(URLСервера, , , , Прокси, Таймаут);
	Исключение
		ОписаниеОшибки = ИнформацияОбОшибке().Описание;
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

Функция ПолучитьРесурсССервера(Соединение, ИмяРесурсаНаСервере, ОписаниеОшибки = Неопределено) Экспорт
	
	ИспользуетсяТестовыйСервер = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ИспользоватьТестовыйСервер();
	
	ПутьККаталогуРесурсов = "/RO_OnlineServices/Certificates/";
	Если ИспользуетсяТестовыйСервер Тогда
		ПутьККаталогуРесурсов = ПутьККаталогуРесурсов + "Test/";
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Попытка
		Соединение.Получить(ПутьККаталогуРесурсов + ИмяРесурсаНаСервере, ИмяВременногоФайла);
	Исключение
		ОписаниеОшибки = ИнформацияОбОшибке().Описание;
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ИмяВременногоФайла;
	
КонецФункции

Функция ЗагрузитьСтрокуXMLВДеревоЗначений(СтрокаXML, ОписаниеОшибки = Неопределено, ЧтениеXML = Неопределено, Знач ТекУзел = Неопределено) Экспорт
	
	ПерваяИтерация = (ТекУзел = Неопределено);
	Если ПерваяИтерация Тогда
		ТекУзел = СоздатьДеревоСтруктурыXML();
		Попытка
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(СтрокаXML);
		Исключение
			ОписаниеОшибки = "Ошибка разбора XML: " + ИнформацияОбОшибке().Описание + ".";
			Возврат Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Попытка
		Пока ЧтениеXML.Прочитать() Цикл
			ТипУзла = ЧтениеXML.ТипУзла;
			Если ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				НовУзел = ТекУзел.Строки.Добавить();
				НовУзел.Имя = ЧтениеXML.Имя;
				НовУзел.Тип = "Э";
				НовУзел.Значение = ЧтениеXML.Значение;
				Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
					НовАтрибут = НовУзел.Строки.Добавить();
					НовАтрибут.Имя = ЧтениеXML.Имя;
					НовАтрибут.Тип = "А";
					НовАтрибут.Значение = ЧтениеXML.Значение;
				КонецЦикла;
				ЗагрузитьСтрокуXMLВДеревоЗначений(СтрокаXML, ОписаниеОшибки, ЧтениеXML, НовУзел);
				Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
					Возврат Неопределено;
				КонецЕсли;
			ИначеЕсли ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				Прервать;
			ИначеЕсли ТипУзла = ТипУзлаXML.Текст И ТипЗнч(ТекУзел) = Тип("СтрокаДереваЗначений") И ТекУзел.Тип = "Э" Тогда
				ТекУзел.Значение = ЧтениеXML.Значение;
			КонецЕсли;
		КонецЦикла;
	Исключение
		ОписаниеОшибки = "Ошибка разбора XML: " + ИнформацияОбОшибке().Описание + ".";
		Возврат Неопределено;
	КонецПопытки;
	
	Если ПерваяИтерация Тогда
		Возврат ТекУзел;
	КонецЕсли;
	
КонецФункции

Функция СоздатьДеревоСтруктурыXML() Экспорт
	
	ДеревоСтруктуры = Новый ДеревоЗначений;
	ДеревоСтруктуры.Колонки.Добавить("Имя");
	ДеревоСтруктуры.Колонки.Добавить("Тип");
	ДеревоСтруктуры.Колонки.Добавить("Значение");
	Возврат ДеревоСтруктуры;
	
КонецФункции

Функция КопироватьПростуюСтруктуру(Структура)
	
	Возврат ЗначениеИзСтрокиВнутр(ЗначениеВСтрокуВнутр(Структура))
	
КонецФункции

Функция ПолучитьКаталогВременныхФайлов()
	
	ВременныйКаталог = КаталогВременныхФайлов();
	ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог);
	Возврат ВременныйКаталог;
	
КонецФункции

Функция ПараметрыАутентификацииКорректные(ПараметрыАутентификацииНаСайте, ОписаниеОшибки = "")
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте)
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте.Логин)
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте.Пароль) Тогда
		Результат = "НекорректноеИмяПользователяИлиПароль";
		Возврат Результат;
	КонецЕсли;
	
	Результат = "АутентификацияВыполнена";
	
	Возврат Результат;
	
КонецФункции

Функция ИмяСобытияВЖурналеРегистрации()
	
	Возврат НСтр("ru = 'Документооборот с Минобороны.'");
	
КонецФункции

#КонецОбласти