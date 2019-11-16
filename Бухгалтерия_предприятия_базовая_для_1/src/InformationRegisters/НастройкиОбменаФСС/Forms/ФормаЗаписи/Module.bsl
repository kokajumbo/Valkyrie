&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияСсылка) Тогда
		
		ЗаписьПоОрганизации = РегистрыСведений.НастройкиОбменаФСС.СоздатьМенеджерЗаписи();
		ЗаписьПоОрганизации.Организация = Параметры.ОрганизацияСсылка;
		ЗаписьПоОрганизации.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
			ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);
		Иначе
			Запись.Организация = Параметры.ОрганизацияСсылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса(Запись.Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "НадписьОрганизация");
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	СвойстваОрганизацииИУчетнойЗаписи = Неопределено;
	Если КонтекстЭДОСервер <> Неопределено Тогда
		СвойстваОрганизацииИУчетнойЗаписи = КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(
			Запись.Организация, Истина);
	КонецЕсли;
	
	Элементы.ГруппаАвтонастройка.Видимость =
		(СвойстваОрганизацииИУчетнойЗаписи <> Неопределено
		И СвойстваОрганизацииИУчетнойЗаписи.ЕстьВозможностьАвтонастройкиВУниверсальномФормате);
	Элементы.ГруппаИнформация1СОтчетностьНеИспользуется.Видимость =
		(СвойстваОрганизацииИУчетнойЗаписи = Неопределено
		ИЛИ СвойстваОрганизацииИУчетнойЗаписи.ВидОбменаСКонтролирующимиОрганами <>
			ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате")
		ИЛИ НЕ ЗначениеЗаполнено(СвойстваОрганизацииИУчетнойЗаписи.УчетнаяЗаписьОбмена));
	
	КлючСохраненияПоложенияОкна = "НастройкиФСС" + ?(Элементы.ГруппаАвтонастройка.Видимость, "Автонастройка", "")
		+ ?(Элементы.ГруппаИнформация1СОтчетностьНеИспользуется.Видимость, "Подключение", "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоНовый = Ложь;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеНастроекЭДООрганизации", Запись.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатСтрахователяПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатСтрахователяОтпечаток, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатФССПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатФССОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатФССЭЛНПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатФССЭЛНОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатСтрахователяОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатФССОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатФССЭЛНОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатСтрахователяОтпечаток = "";
	СертификатСтрахователяПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатСтрахователяОтпечаток,
		ЭтотОбъект,
		"СертификатСтрахователяПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатФССОтпечаток = "";
	СертификатФССПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатФССОтпечаток,
		ЭтотОбъект,
		"СертификатФССПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатФССЭЛНОтпечаток = "";
	СертификатФССЭЛНПредставление = "";
	Запись.ТестовыйСерверФССЭЛН = Ложь;
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатФССЭЛНОтпечаток,
		ЭтотОбъект,
		"СертификатФССЭЛНПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьсяК1СОтчетности(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(Запись.Организация, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ОбновитьДоступностьЭлементов();
	
	КонтекстЭДО.УправлениеОтображениемОрганизации(ЭтаФорма, Запись.Организация);
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатСтрахователяПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатСтрахователяОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатСтрахователяПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатФССПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатФССОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатФССПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатФССЭЛНПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатФССЭЛНОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатФССЭЛНПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	КриптографияЭДКОКлиент.ОтобразитьПредставленияСертификатов(ПараметрыОтображенияСертификатов, ЭтотОбъект, ЭтоЭлектроннаяПодписьВМоделиСервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатСтрахователяОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		ВыбранныйСертификатСтрахователя = Результат.ВыбранноеЗначение;
		Если ЭтоЭлектроннаяПодписьВМоделиСервиса Тогда
			ВыбранныйСертификатСтрахователя = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(
				ВыбранныйСертификатСтрахователя);
			ВыбранныйСертификатСтрахователя.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса",
				ЭтоЭлектроннаяПодписьВМоделиСервиса);
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СертификатСтрахователя", 				ВыбранныйСертификатСтрахователя);
		ДополнительныеПараметры.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", ЭтоЭлектроннаяПодписьВМоделиСервиса);
		Оповещение = Новый ОписаниеОповещения("СертификатСтрахователяПредставлениеНачалоВыбораПослеОтображения",
			ЭтотОбъект, ДополнительныеПараметры);
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент, 
			Результат.ВыбранноеЗначение.Отпечаток, 
			ЭтотОбъект,
			"СертификатСтрахователяПредставление",
			Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораПослеОтображения(Результат, ВходящийКонтекст) Экспорт
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатСтрахователяПредставлениеНачалоВыбораПослеОпределенияСертификатовФСС", ЭтотОбъект, ВходящийКонтекст);
	
	КонтекстЭДО.ОпределитьЗадаваемыеСертификатыФСС(
		Оповещение,
		ВходящийКонтекст.СертификатСтрахователя,
		Запись.СертификатФССОтпечаток,
		Запись.СертификатФССЭЛНОтпечаток,
		ВходящийКонтекст.ЭтоЭлектроннаяПодписьВМоделиСервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораПослеОпределенияСертификатовФСС(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.СертификатФССОтпечаток) Тогда
		Запись.СертификатФССОтпечаток = Результат.СертификатФССОтпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элементы.СертификатФССПредставление,
			Результат.СертификатФССОтпечаток,
			ЭтотОбъект,
			"СертификатФССПредставление");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.СертификатФССЭЛНОтпечаток) Тогда
		Запись.СертификатФССЭЛНОтпечаток = Результат.СертификатФССЭЛНОтпечаток;
		Запись.ТестовыйСерверФССЭЛН = Ложь;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элементы.СертификатФССЭЛНПредставление,
			Результат.СертификатФССЭЛНОтпечаток,
			ЭтотОбъект,
			"СертификатФССЭЛНПредставление");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатФССОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатФССПредставление"
			);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатФССЭЛНОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		Запись.ТестовыйСерверФССЭЛН = (СтрНайти(Результат.ВыбранноеЗначение.Владелец, "ТЕСТОВЫЙ") > 0);
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатФССЭЛНПредставление"
			);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	
	Элементы.НадписьСертификатСтрахователя.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатСтрахователяПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатФСС.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатФССПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатФССЭЛН.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатФССЭЛНПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ТестовыйСерверФССЭЛН.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьАвтонастройка.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ИспользоватьАвтонастройку.Доступность = Запись.ИспользоватьОбмен;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Элементы.ГруппаАвтонастройка.Видимость = (КонтекстЭДОСервер <> Неопределено И КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(Запись.Организация));
	
КонецПроцедуры

#КонецОбласти

