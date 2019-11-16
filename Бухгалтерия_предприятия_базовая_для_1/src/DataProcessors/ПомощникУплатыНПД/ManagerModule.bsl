#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ДанныеЗаполненияПлатежногоДокументаВФоне(Параметры, АдресРезультата) Экспорт
	
	ДанныеЗаполнения = ДанныеЗаполненияПлатежногоДокумента(
		Параметры.ПараметрыСоздания,
		Параметры.ДанныеКвитанции,
		Параметры.НалоговыйПериод,
		Параметры.ВидОбязательства,
		Параметры.ПараметрыСоздания.Платежи);
	
	ПоместитьВоВременноеХранилище(ДанныеЗаполнения, АдресРезультата);
	
КонецФункции

Процедура СоздатьПлатежныеДокументыВФоне(ПараметрыСоздания, АдресРезультата) Экспорт
	
	СозданныеДокументы = Новый Массив;
	
	СписокКвитанций = ПараметрыСоздания.СписокКвитанций;
	ТаблицаЗадолженностей = ПараметрыСоздания.Задолженности;
	Если СписокКвитанций = Неопределено Или ТаблицаЗадолженностей = Неопределено Тогда
		ПоместитьВоВременноеХранилище(СозданныеДокументы, АдресРезультата);
		Возврат;
	КонецЕсли;
	
	ВсеПлатежи = ПараметрыСоздания.Платежи;
	
	Если ПараметрыСоздания.СпособОплаты = Перечисления.СпособыУплатыНалогов.НаличнымиПоКвитанции Тогда
		ВидПлатежногоДокумента = "РасходныйКассовыйОрдер";
	Иначе
		ВидПлатежногоДокумента = "ПлатежноеПоручение";
	КонецЕсли;
	
	Для Каждого Квитанция Из СписокКвитанций Цикл
		
		СтрокаЗадолженность = ТаблицаЗадолженностей.Найти(Квитанция.ИдентификаторПлатежа, "ИдентификаторПлатежа");
		Если СтрокаЗадолженность <> Неопределено Тогда
			ВидОбязательства = СтрокаЗадолженность.ВидНалоговогоОбязательства;
		Иначе
			ВидОбязательства = Перечисления.ВидыПлатежейВГосБюджет.Налог;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Квитанция.ДатаОплаты) Тогда
			НалоговыйПериод = НачалоМесяца(ДобавитьМесяц(Квитанция.ДатаОплаты, -1));
		Иначе
			НалоговыйПериод = ПараметрыСоздания.ПериодСобытия;
		КонецЕсли;
		
		ДанныеЗаполнения = ДанныеЗаполненияПлатежногоДокумента(ПараметрыСоздания, Квитанция, НалоговыйПериод, ВидОбязательства, ВсеПлатежи);
		Если ДанныеЗаполнения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйДокумент = Документы[ВидПлатежногоДокумента].СоздатьДокумент();
		НовыйДокумент.Заполнить(ДанныеЗаполнения);
		
		Если ЗначениеЗаполнено(ПараметрыСоздания.Правило) Тогда
			ВыполнениеЗадачБухгалтера.УстановитьСвойстваПлатежаПриРегистрации(НовыйДокумент, ПараметрыСоздания.Правило, НалоговыйПериод);
		КонецЕсли;
		
		Если НовыйДокумент.ПроверитьЗаполнение() Тогда
			НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		ИначеЕсли Не ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
			НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
		Если Не НовыйДокумент.Ссылка.Пустая() Тогда
			СозданныеДокументы.Добавить(НовыйДокумент.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(СозданныеДокументы, АдресРезультата);
	
КонецПроцедуры

Функция ДанныеЗаполненияПлатежногоДокумента(ПараметрыСоздания, Квитанция, НалоговыйПериод, ВидОбязательства, Платежи) Экспорт
	
	СуммаКУплате = СуммаКУплате(НалоговыйПериод, Квитанция.Сумма, ВидОбязательства, Платежи);
	Если СуммаКУплате = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Справочники.Организации.ЗаполнитьПустойЮридическийАдресОрганизации(ПараметрыСоздания.Организация, Квитанция.АдресМестаЖительства);
	УстановитьПривилегированныйРежим(Ложь);
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("СтатьяДвиженияДенежныхСредств", УчетДенежныхСредствБП.СтатьяДДСПоУмолчанию(ПараметрыСоздания.ВидОперации));
	
	ДанныеЗаполнения.Вставить("Дата",                 ПараметрыСоздания.Дата);
	ДанныеЗаполнения.Вставить("Организация",          ПараметрыСоздания.Организация);
	ДанныеЗаполнения.Вставить("СчетОрганизации",      ПараметрыСоздания.СчетОрганизации);
	ДанныеЗаполнения.Вставить("ВидОперации",          ПараметрыСоздания.ВидОперации);
	ДанныеЗаполнения.Вставить("Налог",                ПараметрыСоздания.Налог);
	ДанныеЗаполнения.Вставить("ВидНалоговогоОбязательства", ВидОбязательства);
	ДанныеЗаполнения.Вставить("НалоговыйПериод",      НалоговыйПериод);
	ДанныеЗаполнения.Вставить("КодБК",                Квитанция.КБК);
	ДанныеЗаполнения.Вставить("КодОКАТО",             Квитанция.КодТерритории);
	ДанныеЗаполнения.Вставить("СтатусСоставителя",    Квитанция.СтатусПлательщика);
	ДанныеЗаполнения.Вставить("ПоказательОснования",  Квитанция.ОснованиеПлатежа);
	ДанныеЗаполнения.Вставить("ПоказательТипа",       Квитанция.ТипПлатежа);
	Если ЗначениеЗаполнено(Квитанция.ПоказательПериода) Тогда
		ДанныеЗаполнения.Вставить("ПоказательПериода", Квитанция.ПоказательПериода);
	КонецЕсли;
	ДанныеЗаполнения.Вставить("ИдентификаторПлатежа", Квитанция.ИдентификаторПлатежа);
	ДанныеЗаполнения.Вставить("СчетУчета",            ПараметрыСоздания.СчетУчета);
	ДанныеЗаполнения.Вставить("Субконто1",            ДанныеЗаполнения.ВидНалоговогоОбязательства);
	
	ДанныеЗаполнения.Вставить("СуммаДокумента",       СуммаКУплате);
	
	ДанныеЗаполнения.Вставить("Контрагент",           ПолучательПлатежа(ПараметрыСоздания.Организация, Квитанция));
	ДанныеЗаполнения.Вставить("СчетКонтрагента",      БанковскийСчетПолучателяПлатежа(ДанныеЗаполнения.Контрагент, Квитанция));
	
	ДанныеЗаполнения.Вставить("ТекстПлательщика",     Квитанция.Плательщик);
	ДанныеЗаполнения.Вставить("ИННПлательщика",       Квитанция.ИНН);
	
	ДанныеЗаполнения.Вставить("ТекстПолучателя",      Квитанция.Получатель);
	ДанныеЗаполнения.Вставить("ИННПолучателя",        Квитанция.ИННПолучателя);
	ДанныеЗаполнения.Вставить("КПППолучателя",        Квитанция.КПППолучателя);
	
	ДанныеЗаполнения.Вставить("Правило",              ПараметрыСоздания.Правило);
	ДанныеЗаполнения.Вставить("ПериодСобытия",        НалоговыйПериод);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Подготавливает параметры для получения документов уплаты налогов.
//
// Параметры:
//		Организация - Справочники.Организация
//		Период - Дата - налоговый период.
//
// Возвращаемое значение:
//		ТаблицаЗначений - заполненная таблица уплаты налогов.
//
Функция ДокументыУплаты(Организация, НачалоПериода, КонецПериода) Экспорт
	
	ПараметрыУплатыНалогов = ПомощникиПоУплатеНалоговИВзносов.НовыеПараметрыУплатыНалогов();
	ПараметрыУплатыНалогов.КодыЗадач.Добавить("НалогНаПрофессиональныйДоход");
	
	ПараметрыУплатыНалогов.ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход);
	ПараметрыУплатыНалогов.ВидыНалоговыхОбязательств.Добавить(Перечисления.ВидыПлатежейВГосБюджет.Налог);
	ПараметрыУплатыНалогов.ВидыНалоговыхОбязательств.Добавить(Перечисления.ВидыПлатежейВГосБюджет.ПениАкт);
	ПараметрыУплатыНалогов.ВидыНалоговыхОбязательств.Добавить(Перечисления.ВидыПлатежейВГосБюджет.ПениСам);
	
	Возврат ПомощникиПоУплатеНалоговИВзносов.ДокументыУплатыНалогов(
		Организация, НачалоПериода, КонецПериода, ПараметрыУплатыНалогов);
	
КонецФункции

// Отменяет запущенные фоновые задания.
//
// Параметры:
//		ИдентификаторЗадания - УникальныйИдентификатор 
//
Процедура ОтменитьФоновоеЗадание(ИдентификаторЗадания) Экспорт
	
	СообщениеОбОшибке = Неопределено;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат ;
	КонецЕсли;
	
	Если НЕ ПроверитьВыполнениеЗадания(ИдентификаторЗадания, СообщениеОбОшибке) Тогда 
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет завершение длительной операции по идентификатору.
//
// Параметры:
//		ИдентификаторЗадания 	- УникальныйИдентификатор - идентификатор фонового задания.
//		СообщениеОбОшибке	  	- Строка - возвращает сообщение об ошибке.
//
// Возвращаемое значение:
//		Булево - Истина, если длительная операция завершена, в том числе с ошибками.
//
Функция ПроверитьВыполнениеЗадания(ИдентификаторЗадания, СообщениеОбОшибке)
	
	Если ИдентификаторЗадания = Неопределено Тогда		
	    Возврат Истина;	
	КонецЕсли;
	
	Попытка
		
		Выполнено = ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
		СообщениеОбОшибке = "";
		
	Исключение
	    // что-то произошло, нужно сообщить
		СообщениеОбОшибке = НСтр("ru = 'Не удалось выполнить данную операцию. 
		                    |Подробности см. в Журнале регистрации.
							|" + ОписаниеОшибки() + "'");
		Выполнено = Истина;
		
	КонецПопытки;
	
	Возврат Выполнено;
		
КонецФункции

Процедура УстановитьСтатусЗадачи(Организация, Правило, Период, Платежи, СуммаНалога) Экспорт

	ПараметрыЗадачи = Новый Структура("Организация, ПериодСобытия, Правило, РегистрацияВНалоговомОргане",
		Организация, Период, Правило, Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка());
	
	ВыполнениеЗадачБухгалтера.ПроверитьАктуальностьСтатуса(ПараметрыЗадачи, СтатусЗадачиПоОплате(СуммаНалога, Платежи));
	
КонецПроцедуры

Функция СтатусЗадачиПоОплате(НалогКУплате, Платежи)
	
	Статус = "";
	
	Если НалогКУплате <> 0 Тогда
		
		СуммаОплаты = ПомощникиПоУплатеНалоговИВзносов.СуммаОплаты(Платежи);
		
		Если СуммаОплаты >= НалогКУплате Тогда
			Статус = "Оплачено";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Статус;

КонецФункции

// Возвращает неоплаченную сумму квитанции.
//
// Параметры:
//   НалоговыйПериод - Дата - налоговый период уплаты.
//   СуммаПоКвитанции - Число - полная сумма налога к уплате.
//   ВидОбязательства - ПеречислениеСсылка.ВидыПлатежейВГосБюджет - вид налогового обязательства.
//   ВсеПлатежи - ТаблицаЗначений - оформленные платежи по налогу.
//
Функция СуммаКУплате(НалоговыйПериод, СуммаПоКвитанции, ВидОбязательства, ВсеПлатежи)
	
	Если ВсеПлатежи = Неопределено Тогда
		Возврат СуммаПоКвитанции;
	КонецЕсли;
	
	Если ВсеПлатежи.Количество() = 0 Тогда
		Возврат СуммаПоКвитанции;
	КонецЕсли;
	
	ФильтрПоиска = Новый Структура("ПоказательПериода, ВидНалоговогоОбязательства");
	
	ФильтрПоиска.ПоказательПериода = 
		ПлатежиВБюджетКлиентСервер.НалоговыйПериод(НалоговыйПериод, ПлатежиВБюджетКлиентСервер.ПериодичностьМесяц());
	
	ФильтрПоиска.ВидНалоговогоОбязательства = ВидОбязательства;
	
	НайденныеСтроки = ВсеПлатежи.НайтиСтроки(ФильтрПоиска);
	
	ВсегоНалогаОплачено = 0;
	
	Для Каждого ТекСтрокаПлатежей Из НайденныеСтроки Цикл
		ВсегоНалогаОплачено = ВсегоНалогаОплачено + ТекСтрокаПлатежей.Сумма;
	КонецЦикла;
	
	КУплате = Макс(СуммаПоКвитанции - ВсегоНалогаОплачено, 0);
	
	Возврат КУплате;
	
КонецФункции

Функция ПолучательПлатежа(Организация, Квитанция)
	
	ДанныеЗаполнения = Новый Структура;
	
	НаименованиеИнспекции = НаименованиеИнспекции(Квитанция.Получатель);
	
	ДанныеЗаполнения.Вставить("НаименованиеПолное", НаименованиеИнспекции);
	ДанныеЗаполнения.Вставить("Наименование", НаименованиеИнспекции);
	ДанныеЗаполнения.Вставить("ИНН", Квитанция.ИННПолучателя);
	ДанныеЗаполнения.Вставить("КПП", Квитанция.КПППолучателя);
	ДанныеЗаполнения.Вставить("ЮридическоеФизическоеЛицо", Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("АдресОрганизации", Квитанция.АдресМестаЖительства);
	
	Возврат Справочники.Контрагенты.НайтиСоздатьНалоговуюИнспекцию(ДанныеЗаполнения);
	
КонецФункции

Функция НаименованиеИнспекции(ПолноеНаименование)
	
	// Наименование из сервиса соответствует шаблону "[НаименованиеКазначейства] ([НаименованиеИнспекции])"
	КоличествоОткрывающихСкобок = СтрЧислоВхождений(ПолноеНаименование, "(");
	КоличествоЗакрывающихСкобок = СтрЧислоВхождений(ПолноеНаименование, ")");
	
	Если КоличествоОткрывающихСкобок <> КоличествоЗакрывающихСкобок Тогда
		Возврат ПолноеНаименование;
	КонецЕсли;
	
	Если КоличествоОткрывающихСкобок > 1 Или КоличествоЗакрывающихСкобок > 1 Тогда
		Возврат ПолноеНаименование;
	КонецЕсли;
	
	ОткрывающаяСкобка = СтрНайти(ПолноеНаименование, "(");
	ЗакрывающаяСкобка = СтрНайти(ПолноеНаименование, ")", НаправлениеПоиска.СКонца);
	
	Если ОткрывающаяСкобка = 0
		Или ЗакрывающаяСкобка = 0
		Или ОткрывающаяСкобка > ЗакрывающаяСкобка Тогда
		Возврат ПолноеНаименование;
	КонецЕсли;
	
	Возврат СокрЛП(Сред(ПолноеНаименование, ОткрывающаяСкобка + 1, ЗакрывающаяСкобка - 1));
	
КонецФункции

Функция БанковскийСчетПолучателяПлатежа(Контрагент, Квитанция)
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Справочники.БанковскиеСчета.ПустаяСсылка();
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ТекстКорреспондента", Квитанция.Получатель);
	
	БанковскийСчет = Справочники.БанковскиеСчета.ПолучитьЭлемент(
		Контрагент, Квитанция.СчетПолучателя, Квитанция.БИК, ДанныеЗаполнения);
	
	Возврат БанковскийСчет;
	
КонецФункции

#КонецОбласти

#КонецЕсли