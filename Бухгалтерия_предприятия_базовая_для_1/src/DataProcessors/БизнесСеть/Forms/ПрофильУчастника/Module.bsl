
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ИНН",    ПрофильИНН);
	Параметры.Свойство("КПП",    ПрофильКПП);
	Параметры.Свойство("Ссылка", Ссылка);
	
	Если Параметры.Свойство("Реквизиты") Тогда
		ЗаполнитьРеквизитыПрофиля(Параметры.Реквизиты);
	Иначе
		ПолучитьДанныеСервиса(Отказ);
	КонецЕсли;
	
	Если ПрофильКПП = "0" Тогда
		ПрофильКПП = "";
	КонецЕсли;

	Если ЗначениеЗаполнено(ПрофильИНН) И НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Контрагенты", ПрофильИНН, ПрофильКПП, Ссылка);
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(ТипЗнч(Ссылка)) Тогда
		Элементы.Ссылка.Заголовок = НСтр("ru = 'Организация'");
	Иначе
		Элементы.Ссылка.Заголовок = НСтр("ru = 'Контрагент'");
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТорговыеПредложенияНажатие(Элемент)
	
	// Команда вызова метода доступна только при встраивании подсистемы "Торговые предложения".
	ОтборКонтрагент = Новый Структура();
	ОтборКонтрагент.Вставить("Ссылка",                          Ссылка);
	ОтборКонтрагент.Вставить("ИНН",                             ПрофильИНН);
	ОтборКонтрагент.Вставить("КПП",                             ПрофильКПП);
	ОтборКонтрагент.Вставить("Наименование",                    ПрофильНаименование);
	
	ПараметрыОткрытия = Новый Структура("Контрагент", ОтборКонтрагент);
	ПараметрыОткрытия.Вставить("РежимВыбораТорговогоПредложения", Истина);

	// Установка отбора по контрагенту, если форма уже открыта.
	Оповестить("ТорговыеПредложения_ПоискПоОтборам_Обновить", ПараметрыОткрытия, ЭтотОбъект);
	
	ИмяФормыПоиска = "Обработка.ТорговыеПредложения.Форма.ПоискПоОтборам";
	ОчиститьСообщения();
	ОткрытьФорму(ИмяФормыПоиска, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонтрагентаНажатие(Элемент)
	
	СоздатьКонтрагентаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьДанныеСервиса(Отказ)
	
	ДополнительныеПараметры = БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов();
	ДополнительныеПараметры.Ссылка = Ссылка;
	ДополнительныеПараметры.ИНН = ПрофильИНН;
	ДополнительныеПараметры.КПП = ПрофильКПП;
	Результат = БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(ДополнительныеПараметры, Отказ, Истина);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПрофиля(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПрофиля(Источник)
	
	Если Источник.Свойство("ДатаРегистрации") Тогда
		ПрофильДатаРегистрации = БизнесСетьКлиентСервер.ДатаИзUnixTime(Источник.ДатаРегистрации);
	КонецЕсли;
	
	Источник.Свойство("Наименование",     ПрофильНаименование);
	Источник.Свойство("ИНН",              ПрофильИНН);
	Источник.Свойство("КПП",              ПрофильКПП);
	Источник.Свойство("НаименованиеЕГРН", ПрофильНаименованиеЕГРН);
	Источник.Свойство("Адрес",            ПрофильАдрес);
	Источник.Свойство("ОГРН",             ПрофильОГРН);
	Источник.Свойство("Сайт",             ПрофильСайт);
	Источник.Свойство("Телефон",          ПрофильТелефон);
	Источник.Свойство("ЭлектроннаяПочта", ПрофильЭлектроннаяПочта);
	Источник.Свойство("КоличествоТорговыхПредложений", ПрофильКоличествоТорговыхПредложений);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.Ссылка.Видимость                   = ЗначениеЗаполнено(Ссылка);
	Элементы.ГруппаНовогоКонтрагента.Видимость  = Не ЗначениеЗаполнено(Ссылка);
	Элементы.ПрофильКПП.Видимость               = ЗначениеЗаполнено(ПрофильКПП);
	Элементы.ПрофильОГРН.Видимость              = ЗначениеЗаполнено(ПрофильОГРН);
	Элементы.ПрофильАдрес.Видимость             = ЗначениеЗаполнено(ПрофильАдрес);
	Элементы.ПрофильТелефон.Видимость           = ЗначениеЗаполнено(ПрофильТелефон);
	Элементы.ПрофильЭлектроннаяПочта.Видимость  = ЗначениеЗаполнено(ПрофильЭлектроннаяПочта);
	Элементы.ПрофильСайт.Видимость              = ЗначениеЗаполнено(ПрофильСайт);
	
	Заголовок = НСтр("ru = '%1 (профиль участника 1С:Бизнес-сеть)'");
	Заголовок = СтрШаблон(Заголовок, ПрофильНаименование);
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ЕстьТорговыеПредложения = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения");
	
	Элементы.ТорговыеПредложения.Видимость =
		ЗначениеЗаполнено(ПрофильКоличествоТорговыхПредложений) И ЕстьТорговыеПредложения;
	
	Если ПрофильКоличествоТорговыхПредложений <> 0 Тогда
		Элементы.ТорговыеПредложения.Заголовок =
			СтрШаблон(НСтр("ru = 'Открыть торговые предложения (%1)'"), ПрофильКоличествоТорговыхПредложений);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
КонецПроцедуры

&НаСервере
Процедура СоздатьКонтрагентаНаСервере()
	
	Отказ = Ложь;
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ИНН", ПрофильИНН);
	Реквизиты.Вставить("КПП", ПрофильКПП);
	Реквизиты.Вставить("Наименование", ПрофильНаименование);
	БизнесСетьПереопределяемый.СоздатьКонтрагентаПоРеквизитам(Реквизиты, Ссылка, Отказ);
	
	Если Не Отказ Тогда
		УстановитьВидимостьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
