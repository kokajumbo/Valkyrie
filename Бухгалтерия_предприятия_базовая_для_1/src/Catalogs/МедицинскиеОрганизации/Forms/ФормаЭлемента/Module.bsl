
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("ТолькоНациональныйАдрес",		Истина);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление",	Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",	Ложь);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АдресПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных.
		// Сбрасываем как представления, 
		// так и внутренние значения полей.
		Объект.Адрес = "";
		Объект.АдресВнутреннееПредставление = "";
		Возврат;
	КонецЕсли;

	// Формируем внутренние значения полей по тексту 
	// и параметрам.
	Объект.Адрес = Текст;
	Объект.АдресВнутреннееПредставление = ЗначенияПолейКонтактнойИнформацииСервер(Текст, ВидКонтактнойИнформацииАдреса);
	
	ЗаполнитьКодКЛАДРНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата
	// кнопка выбора, то необходимо привести данные в соответствие
	// и сбросить внутренние поля для повторного репарсинга.
	Если Элемент.ТекстРедактирования <> Объект.Адрес Тогда
		Объект.Адрес = Элемент.ТекстРедактирования;
		Объект.АдресВнутреннееПредставление = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформацииАдреса,
		Объект.АдресВнутреннееПредставление,
		Объект.Адрес, 
		НСтр("ru='Адрес медицинской организации'"));
		
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес медицинской организации'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура АдресОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Адрес = "";
	Объект.АдресВнутреннееПредставление = "";
	Объект.АдресКодПоКЛАДР = "";

КонецПроцедуры

&НаКлиенте
Процедура АдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны
		Возврат;
	КонецЕсли;
	
	Объект.Адрес = ВыбранноеЗначение.Представление;
	Объект.АдресВнутреннееПредставление = ВыбранноеЗначение.КонтактнаяИнформация;
	
	ЗаполнитьКодКЛАДРНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервереБезКонтекста
Функция ЗначенияПолейКонтактнойИнформацииСервер(Знач Представление, Знач ВидКонтактнойИнформации)
	
	// Создаем новый экземпляр по представлению.
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКодКЛАДРНаСервере()
	ОписаниеАдреса = УчетПособийСоциальногоСтрахования.ОписаниеАдреса(Объект.АдресВнутреннееПредставление, ВидКонтактнойИнформацииАдреса);
	Объект.АдресКодПоКЛАДР = ОписаниеАдреса.КодКЛАДР;
КонецПроцедуры

#КонецОбласти




