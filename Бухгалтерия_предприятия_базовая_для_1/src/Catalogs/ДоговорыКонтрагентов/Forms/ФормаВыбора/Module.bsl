#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Отбор по полю "Организация" всегда выполняется по головной организации.
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
			Параметры.Отбор.Организация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Параметры.Отбор.Организация);
		КонецЕсли;
	КонецЕсли;
	
	// Для отбора по полю "Владелец", если передана группа или список значений, устанавливаем особый вид сравнения. 
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ПараметрВладелец = Параметры.Отбор.Владелец;
	
		ВидСравненияПоВладельцу = ВидСравненияКомпоновкиДанных.Равно;
		Если ТипЗнч(ПараметрВладелец) = Тип("СписокЗначений") Тогда
			ВидСравненияПоВладельцу = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			
		ИначеЕсли ТипЗнч(ПараметрВладелец) = Тип("СправочникСсылка.Контрагенты") И ЗначениеЗаполнено(ПараметрВладелец) Тогда
			ВладелецЭтоГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрВладелец, "ЭтоГруппа");
			Если ВладелецЭтоГруппа Тогда
				ВидСравненияПоВладельцу = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
		КонецЕсли;
		
		Если ВидСравненияПоВладельцу <> ВидСравненияКомпоновкиДанных.Равно Тогда
			// Установим собственный отбор.
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Владелец",
			                                                        ПараметрВладелец,
			                                                        ВидСравненияПоВладельцу);
			// Исключим стандартный отбор.
			Параметры.Отбор.Удалить("Владелец");
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ВалютаВзаиморасчетовНеРавно") Тогда
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ВалютаВзаиморасчетов",
		                                                        Параметры.ВалютаВзаиморасчетовНеРавно,
		                                                        ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;
	
	ОткрытИзПлатежки = Параметры.Свойство("ОткрытИзПлатежки");
	
	ДоступноИспользоватьОсновным = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ОсновныеДоговорыКонтрагента);
	Если Не ДоступноИспользоватьОсновным Тогда
		Элементы.ФормаИспользоватьОсновным.Видимость = Ложь;
	КонецЕсли;
	Если Не ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		Элементы.Основной.Видимость = Ложь;
	КонецЕсли;
	
	Справочники.ДоговорыКонтрагентов.УстановитьДоступныеВидыДоговора(Параметры.Отбор);
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.Справочник.ДоговорыКонтрагентов",
		"ФормаВыбора",
		НСтр("ru = 'Новости: Договор'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Группа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	ИначеЕсли ОткрытИзПлатежки Тогда
		ПараметрыФормы.Вставить("ОткрытИзПлатежки");
	КонецЕсли;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("Родитель", Родитель);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	СписокПуст = Элементы.Список.ТекущиеДанные = Неопределено;
	
	Если СписокПуст или Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	НастроитьКомандуИспользоватьОсновным(ТекущиеДанные);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьОсновным(Команда)
	
	ТекущиеДанные = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ФормаИспользоватьОсновным.Пометка Тогда
		НеИспользоватьКакОсновнойДоговор(ТекущиеДанные.Ссылка);
	Иначе
		ИспользоватьКакОсновнойДоговор(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
	Элементы.ФормаИспользоватьОсновным.Пометка = Не Элементы.ФормаИспользоватьОсновным.Пометка;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ИспользоватьКакОсновнойДоговор(Знач Договор)
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьОсновнойДоговорКонтрагента(Договор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НеИспользоватьКакОсновнойДоговор(Знач Договор)
	
	СтруктураПараметров = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Организация, ВидДоговора, Владелец");
	МенеджерЗаписи = РегистрыСведений.ОсновныеДоговорыКонтрагента.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация = СтруктураПараметров.Организация;
	МенеджерЗаписи.ВидДоговора = СтруктураПараметров.ВидДоговора;
	МенеджерЗаписи.Контрагент  = СтруктураПараметров.Владелец;
	МенеджерЗаписи.Договор     = Договор;
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКомандуИспользоватьОсновным(ТекущиеДанные)
	
	Если Не ДоступноИспользоватьОсновным Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		Элементы.ФормаИспользоватьОсновным.Пометка     = Ложь;
		Элементы.ФормаИспользоватьОсновным.Доступность = Ложь;
	Иначе
		Элементы.ФормаИспользоватьОсновным.Пометка     = ТекущиеДанные.Основной;
		Элементы.ФормаИспользоватьОсновным.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураОтборовСписка()
	
	СтруктураОтборов = Новый Структура;
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			СтруктураОтборов.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
		ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			СтруктураОтборов.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЦикла;
	Возврат СтруктураОтборов;
	
КонецФункции

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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

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
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);
	
КонецПроцедуры

#КонецОбласти