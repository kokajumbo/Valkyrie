
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОтправкаПочтовыхСообщений.ПриСозданииНаСервере(ЭтотОбъект);
	
	ОсновнаяОрганизация	= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ОсновнаяОрганизация", ОсновнаяОрганизация);
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеЮридическогоЛица", НСтр("ru='Юридическое лицо'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеИндивидуальногоПредпринимателя", НСтр("ru='Индивидуальный предприниматель'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеОбособленногоПодразделения", НСтр("ru='Обособленное подразделение'"));
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Организации);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	Элементы.ФормаИспользоватьОсновным.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьУсловноеОформление();
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Справочник.Организации",
		"ФормаСписка",
		НСтр("ru='Новости: Организации'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ЭлектронноеВзаимодействиеБП.КомандыЭДО_ФормаСпискаПриСоздании(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ЭлектронноеВзаимодействиеБПКлиент.КомандыЭДО_ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтаФорма Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		ОсновнаяОрганизация	= Параметр;
		Список.Параметры.УстановитьЗначениеПараметра("ОсновнаяОрганизация", ОсновнаяОрганизация);
		
		УправлениеФормойКлиент();
		
	ИначеЕсли ИмяСобытия = "ИзменениеОсновногоПодразделенияОрганизации" Тогда
		
		ОсновноеПодразделение	= Параметр;
		
	ИначеЕсли ИмяСобытия = "Запись_Организации" Тогда

		Если НЕ ИспользоватьНесколькоОрганизаций Тогда
			УстановитьФункциональныеОпцииФормы();
		КонецЕсли;
		
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ЭлектронноеВзаимодействиеБПКлиент.КомандыЭДО_ФормаСпискаОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УправлениеФормойКлиент();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОсновным(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.Ссылка = ОсновнаяОрганизация Тогда
		ОсновнаяОрганизация	= Неопределено;
	Иначе
		ОсновнаяОрганизация	= Элементы.Список.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ОбщегоНазначенияБПКлиент.УстановитьОсновнуюОрганизацию(ОсновнаяОрганизация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// Основная организация

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Основная");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ИспользоватьНесколькоОрганизаций", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// ГоловнаяОрганизация

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГоловнаяОрганизация");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ОбособленноеПодразделение", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормойКлиент()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаИспользоватьОсновным.Пометка = 
		Элементы.Список.ТекущиеДанные.Свойство("Ссылка") И Элементы.Список.ТекущиеДанные.Ссылка = ОсновнаяОрганизация;
	
	Элементы.ФормаИспользоватьОсновным.Доступность = Элементы.Список.ТекущиеДанные.Свойство("Ссылка");

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ИспользоватьНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область КомандыЭДО

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыЭДО()
	ОбменСКонтрагентамиКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
