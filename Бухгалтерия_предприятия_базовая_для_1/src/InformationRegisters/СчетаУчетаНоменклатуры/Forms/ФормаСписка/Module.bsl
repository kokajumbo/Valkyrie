
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем СкладОтбор;
	
	ПоказыватьСчетаУчетаВДокументах = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ПоказыватьСчетаУчетаВДокументах");
	
	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		
		ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда
			
			ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
			
			СписокОрганизаций = Новый СписокЗначений;
			СписокОрганизаций.Добавить(ОсновнаяОрганизация);
			СписокОрганизаций.Добавить(ПустаяОрганизация);
			
			ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, , , СписокОрганизаций);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Склад", СкладОтбор) Тогда
		ГруппаИЛИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы, 
			"ГруппаСклад", 
			ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			
		РеквизитыСклада = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СкладОтбор, "Ссылка, ТипСклада");
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаИЛИ, "Склад",     ВидСравненияКомпоновкиДанных.Равно, РеквизитыСклада.Ссылка,   ,Истина);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаИЛИ, "ТипСклада", ВидСравненияКомпоновкиДанных.Равно, РеквизитыСклада.ТипСклада,,Истина);
		
		Параметры.Отбор.Удалить("Склад");
	КонецЕсли; 
	
	ПодготовитьФормуНаСервере();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		СписокОрганизаций = Новый СписокЗначений;
				
		ПустаяОрганизация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		Если ЗначениеЗаполнено(Параметр) Тогда
			СписокОрганизаций.Добавить(Параметр);
			СписокОрганизаций.Добавить(ПустаяОрганизация);
		КонецЕсли;
		
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , СписокОрганизаций);
		
	ИначеЕсли ИмяСобытия = "ИзменениеПоказыватьСчетаУчетаВДокументах" Тогда
		
		ПоказыватьСчетаУчетаВДокументах = Параметр;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСчетаУчетаВДокументахНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("ПараметрыОткрытия",
		Новый Структура("АктивныйЭлемент", "ПоказыватьСчетаУчетаВДокументах"));
		
	ОткрытьФорму("ОбщаяФорма.ПерсональныеНастройки", ПараметрыОткрытия, ЭтаФорма, "");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// СпособУчетаНДС

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СпособУчетаНДС");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РаздельныйУчетНДСНаСчете19", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	РаздельныйУчетНДСНаСчете19 = УчетНДСРаздельный.ЕстьУчетнаяПолитикаСРаздельнымУчетомНДСНаСчете19();
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры
