////////////////////////////////////////////////////////////////////////////////
// ДополнительныеВнешниеКомпонентыВызовСервера: Механизм для работы с внешними компонентами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текст ссылки на внешнюю компоненту
//
// Параметры:
//  ИмяКомпоненты - Строка - уникальное название внешней компоненты
//  Версия - Строка - (возвращаемое значение) текущая версия внешней компоненты.
//
// Возвращаемое значение:
//  Строка - текст ссылки
//  Неопределено - внешняя компонента не найдена в информационной базе.
//
Функция АдресВК(Знач ИмяКомпоненты, Версия = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СсылкаНаСправочник = Справочники.ДополнительныеВнешниеКомпоненты.НайтиПоРеквизиту("Идентификатор", ИмяКомпоненты);
	Если ЗначениеЗаполнено(СсылкаНаСправочник) Тогда
		РеквизитыВК = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаСправочник, "ДанныеВК, Версия");
		Версия = РеквизитыВК.Версия;
		Возврат ПоместитьВоВременноеХранилище(РеквизитыВК.ДанныеВК.Получить(), Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

// Обновляет внешнюю компоненту в фоне без вывода ошибок.
//
// Параметры:
//  ИмяМодуля - Строка - идентификатор внешней компоненты.
//
Процедура ОбновитьВнешнююКомпоненту(Знач ИмяМодуля) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление внешней компоненты.'");
	
	ДлительныеОперации.ВыполнитьВФоне(
		"Справочники.ДополнительныеВнешниеКомпоненты.ОбновитьВнешниеКомпоненты", Новый Структура(ИмяМодуля), ПараметрыВыполнения);

КонецПроцедуры

// Получает информация о внешней компоненте в файле
//
// Параметры:
//  АдресВнешнейКомпоненты - Строка - адрес временного хранилища с двоичными данными файла внешней компоненты.
// 
// Возвращаемое значение:
//  Структура - информация о ВК. Содержит следующие поля:
//     * ИмяМодуля - Строка - регистрируемое название модуля в ОС
//     * Название - Строка - название модуля для вывода пользователю
//     * Версия - Строка - версия модуля
//     * URLВК - Строка - адрес в интернете для скачивания компоненты
//     * URLИнфо - Строка - адрес в интернете для скачивания информационного файла.
//  Неопределено - не найден информационный файл в архиве внешней компоненты.
//
Функция ИнформацияОВнешнейКомпоненте(АдресВнешнейКомпоненты) Экспорт
	
	ДвоичныеДанныеВК = ПолучитьИзВременногоХранилища(АдресВнешнейКомпоненты);
	ВремФайл = ПолучитьИмяВременногоФайла("zip");
	ДвоичныеДанныеВК.Записать(ВремФайл);
	
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВременныйКаталог);
	
	ЧтениеФайла = Новый ЧтениеZipФайла(ВремФайл);
	НайденаИнформация = Ложь;
	
	Для Каждого Элемент Из ЧтениеФайла.Элементы Цикл
		Если ВРег(Элемент.Имя) = "INFO.XML" Тогда
			НайденаИнформация = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не НайденаИнформация Тогда
		Операция = НСтр("ru = 'Чтение информации о файле внешнего модуля.'");
		ТекстОшибки = НСтр("ru = 'В архиве внешней компоненты отсутствует файл INFO.XML'");
		ТекстСообщения = НСтр("ru = 'При чтении данных внешней компоненты произошла ошибка.'");
		ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения);
		УдалитьФайлы(ВременныйКаталог);
		УдалитьФайлы(ВремФайл);
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеФайла.Извлечь(Элемент, ВременныйКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог);
	
	ФайлИнформации = ВременныйКаталог + Элемент.Имя;
	
	СтруктураВозврата = Справочники.ДополнительныеВнешниеКомпоненты.ПараметрыВК(ФайлИнформации);
	
	ЧтениеФайла.Закрыть();
	УдалитьФайлы(ВременныйКаталог);
	УдалитьФайлы(ВремФайл);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Возвращает параметры внешней компоненты.
//
// Параметры:
//  ИмяМодуля - Строка - уникальное название внешнего модуля.
// 
// Возвращаемое значение:
//  Структура - параметры внешней компоненты. Содержит следующие поля:
//    * Версия - Строка - текущая версия внешней компоненты.
//    * Наименование - Строка - полное наименование внешней компоненты.
//  Неопределено - компонента отсутствует в информационной базе.
//
Функция ПараметрыВнешнейКомпоненты(Знач ИмяМодуля) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ВнешниеКомпоненты.Версия,
	               |	ВнешниеКомпоненты.Наименование
	               |ИЗ
	               |	Справочник.ДополнительныеВнешниеКомпоненты КАК ВнешниеКомпоненты
	               |ГДЕ
	               |	ВнешниеКомпоненты.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", ИмяМодуля);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураВозврата = Новый Структура("Версия, Наименование");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
		Возврат СтруктураВозврата;
	КонецЕсли;

КонецФункции

// Получает список внешних компонент информационной базы
// 
// Возвращаемое значение:
//  СписокЗначений - список внешних компонент, где:
//    * Представление - Строка - представление внешней компоненты;
//    * Значение - Строка - идентификатор внешней компоненты.
//
Функция СписокВнешнихКомпонент() Экспорт
	
	СписокВозврата = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВнешниеКомпоненты.Наименование КАК Представление,
	               |	ВнешниеКомпоненты.Идентификатор КАК Значение
	               |ИЗ
	               |	Справочник.ДополнительныеВнешниеКомпоненты КАК ВнешниеКомпоненты
	               |ГДЕ
	               |	НЕ ВнешниеКомпоненты.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовЗапись = СписокВозврата.Добавить();
		ЗаполнитьЗначенияСвойств(НовЗапись, Выборка);
	КонецЦикла;
	
	Возврат СписокВозврата;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выводит текст ошибки в виде сообщения и производит запись в журнал регистрации.
//
// Параметры:
//  ВидОперации - Строка - выполняемая операция
//  ПодробныйТекстОшибки - Строка - подробная информация об ошибке
//  ТекстСообщения - Строка - текст сообщения, выводимый пользователю.
//
Процедура ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения = "") Экспорт
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь( , , Ложь);
	
	Если ЭтоПолноправныйПользователь И ЗначениеЗаполнено(ПодробныйТекстОшибки) И НЕ ПустаяСтрока(ТекстСообщения)
		И ПодробныйТекстОшибки <> ТекстСообщения Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС
			+ НСтр("ru ='Подробности см. в журнале регистрации.'");
	КонецЕсли;

	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	Если Прав(ВидОперации, 1) <> "." Тогда
		ВидОперации = ВидОперации + ".";
	КонецЕсли;
	ТекстОшибки = СтрШаблон(НСтр("ru = 'Выполнение операции: %1
		|%2'"), ВидОперации, ПодробныйТекстОшибки);
	
	ВыполнитьЗаписьСобытияВЖурналРегистрации(ТекстОшибки);
	
КонецПроцедуры

// Проверяет необходимость скачивания внешней компоненты.
//
// Параметры:
//  ПараметрыВК - Структура - параметры внешней компоненты. Содержит поля:
//    * ИмяМодуля - Строка - уникальное название внешнего модуля
//    * Версия - Строка - версия внешней компоненты на ресурсе в интернет.
//  РазделениеВключено - Булево - возвращает режим работы информационной базы.
//  ТребуетсяСкачатьВК - Булево - возвращает Истина, если ВК нужно обновить или закачать.
//
Процедура ПроверитьНеобходимостьСкачиванияВК(Знач ПараметрыВК, РазделениеВключено, ТребуетсяСкачатьВК) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	ПараметрыВнешнейКомпоненты = ПараметрыВнешнейКомпоненты(ПараметрыВК.ИмяМодуля);
	
	Если ПараметрыВнешнейКомпоненты = Неопределено Тогда
		ТребуетсяСкачатьВК = Истина;
	Иначе
		Если РазделениеВключено Тогда
			// Компонента обновляется с помощью поставляемых данных, поэтому используется существующая версия.
			ТребуетсяСкачатьВК = Ложь;
		Иначе
			ТребуетсяСкачатьВК = ПараметрыВнешнейКомпоненты.Версия <> ПараметрыВК.Версия;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Запускает фоновое задание по получению информации о внешней компоненте.
//
// Параметры:
//  URLИнфоФайла - Строка - адрес информационного файла в интернете.
// 
// Возвращаемое значение:
// Структура - см. описание в ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗапускЗаданияПоПолучениюИнформацииОВнешнейКомпоненте(URLИнфоФайла) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Скачивание информационного файла внешней компоненты с интернет.'");
	
	ПараметрыПроцедуры = Новый Структура("URLИнфоФайла", URLИнфоФайла);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Справочники.ДополнительныеВнешниеКомпоненты.ПолучитьИнформациюОВнешнейКомпоненте", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

Функция ЗапускЗаданияПоСкачиваниюВнешнейКомпоненты(URLВК) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Скачивание внешней компоненты с интернет.'");
	
	ПараметрыПроцедуры = Новый Структура("URLВК", URLВК);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Справочники.ДополнительныеВнешниеКомпоненты.СкачатьВнешнююКомпонентуПоПрямойСсылке", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьЗаписьСобытияВЖурналРегистрации(ОписаниеСобытия, УровеньВажности = Неопределено, РежимТранзакции = Неопределено)
	
	ИмяСобытия = НСтр("ru = 'Внешние компоненты'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	УровеньВажностиСобытия = ?(ТипЗнч(УровеньВажности) = Тип("УровеньЖурналаРегистрации"),
		УровеньВажности, УровеньЖурналаРегистрации.Ошибка);
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньВажностиСобытия, , , ОписаниеСобытия, РежимТранзакции);
	
КонецПроцедуры

#КонецОбласти
