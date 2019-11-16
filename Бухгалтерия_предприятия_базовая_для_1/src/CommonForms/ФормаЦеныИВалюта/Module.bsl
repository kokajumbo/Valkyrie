
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ВалютаУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ЗаполнитьТаблицуКурсовВалют();
	ПолучитьЗначенияПараметровФормы();

	СписокКурсовВалют = ПолучитьСписокКурсовВалют();
	 
	Валюты = ?(ВалютаДокумента = ВалютаРасчетов, 0, 1); 
	
	Если ДоговорЕстьРеквизит И НЕ КурсДокументаЕстьРеквизит Тогда	
		
		Если РасчетыВУЕ И ВалютаУчета <> ВалютаРасчетов Тогда // у.е.
			
			Элементы.ГруппаКурсВалюты.Видимость		 = Ложь;
			Элементы.ГруппаУЕ.Видимость				 = Истина;
			Элементы.ГруппаПрочее.Видимость			 = Ложь;
			
			Элементы.ВалютыУЕПоступление.СписокВыбора.Добавить(0, ВалютаРасчетов);
			Элементы.ВалютыУЕПоступление.СписокВыбора.Добавить(1, ВалютаУчета);
			
			Элементы.ГруппаВалютаРасчетов.Видимость = Истина;
			
			Если ЭтоПоступление Тогда 
				СтрокаДляПодстановки = НСтр("ru = 'Оприходовать по курсу %1%2 ='");
			Иначе
				СтрокаДляПодстановки = НСтр("ru = 'Реализовать по курсу %1%2 = '");
			КонецЕсли;
				
			Элементы.НадписьВалютаРасчетов1.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СтрокаДляПодстановки, ?(КратностьРасчетов = 1, "", КратностьРасчетов), ВалютаРасчетов);
				
			Элементы.НадписьВалютаРасчетов2.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1'"), ВалютаУчета);
				
			Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
				Элементы.КурсРасчетов.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
			КонецЦикла;
			
		ИначеЕсли ВалютаУчета <> ВалютаРасчетов Тогда // валюта
			
			Элементы.ГруппаВалютаРасчетов.Видимость = Ложь;
			
			Элементы.ГруппаКурсВалюты.Видимость		 = Истина;
			Элементы.ГруппаУЕ.Видимость				 = Ложь;
			Элементы.ГруппаПрочее.Видимость			 = Ложь;
			
			Элементы.НадписьВалюта1.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1%2 = '"), ?(КратностьРасчетов = 1, "", КратностьРасчетов), ВалютаРасчетов);
			Элементы.НадписьВалюта2.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1'"), ВалютаУчета);	
			Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
				Элементы.КурсВалютаПоступление.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
			КонецЦикла;	
			
		КонецЕсли;
		
	ИначеЕсли КурсДокументаЕстьРеквизит Тогда
		
		Элементы.ГруппаКурсВалюты.Видимость		 = Ложь;
		Элементы.ГруппаУЕ.Видимость				 = Ложь;
		Элементы.ГруппаПрочее.Видимость			 = Истина;
		
		Элементы.ГруппаВалютаРасчетов.Видимость 	= Ложь;
		Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
			Элементы.Курс.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	//Для "Перезаполнения"
	Если Не ПерезаполнитьЦены Тогда
		ПерезаполнитьЦены = Истина;
	КонецЕсли;
	
	Если НЕ (ДокументБезНДС или НДСНеВыделять) И ЗначениеЗаполнено(ТипЦен) Тогда
		
		ДанныеОбъекта = Новый Структура("ТипЦен, СуммаВключаетНДС, ВариантРасчетаНДС");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
		ТипЦенПриИзмененииНаСервере(ДанныеОбъекта);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)

	Элементы.Курс.СписокВыбора.Очистить();
	
	ЗаполнитьКурсКратностьВалютыДокумента(Истина);
	
	СписокКурсовВалют = ПолучитьСписокКурсовВалют();

	Для Каждого КурсНаДату Из СписокКурсовВалют Цикл
		Элементы.Курс.СписокВыбора.Добавить(КурсНаДату.Значение, КурсНаДату.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовПриИзменении(Элемент)

	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры

&НаКлиенте
Процедура КурсВалютаПоступлениеПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры

&НаКлиенте
Процедура ВариантРасчетаНДСПриИзменении(Элемент)
	
	Если ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.ДокументБезНДС") Тогда 
		ДокументБезНДС 		= Истина;
		НДСНеВыделять 		= Ложь;
		СуммаВключаетНДС 	= Истина;
	ИначеЕсли ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСНеВыделять") Тогда 
		ДокументБезНДС 		= Ложь;
		НДСНеВыделять 		= Истина;
		СуммаВключаетНДС 	= Истина;
	ИначеЕсли ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСВСумме") Тогда 
		ДокументБезНДС 		= Ложь;
		НДСНеВыделять 		= Ложь;
		СуммаВключаетНДС 	= Истина;
	Иначе
		ДокументБезНДС 		= Ложь;
		НДСНеВыделять 		= Ложь;
		СуммаВключаетНДС 	= Ложь;
	КонецЕсли;
	
	Элементы.НДСВключенВСтоимость.Доступность = Не (ДокументБезНДС ИЛИ НДСНеВыделять);	
	
КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсРасчетовОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, "Укажите дату курса валюты", ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, "Укажите дату курса валюты", ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсВалютаПоступлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсРасчетовОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, "Укажите дату курса валюты", ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютыУЕПоступлениеПриИзменении(Элемент)
	
	ПриИзмененииВалюты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчитатьИЗакрыть(Команда)

	Отказ = Ложь;

	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
		
	Если НЕ Отказ Тогда

		ПересчитатьЦены = ЗначениеЗаполнено(ВалютаДокумента)
			И ВалютаДокументаПриОткрытии <> ВалютаДокумента;
			
		ПересчитатьНДС = СуммаВключаетНДС <> СуммаВключаетНДСПриОткрытии
			ИЛИ ДокументБезНДСПриОткрытии <> ДокументБезНДС;
	
		СтруктураРеквизитовФормы = Новый Структура;

		СтруктураРеквизитовФормы.Вставить("БылиВнесеныИзменения", ЭтаФорма.Модифицированность);
		СтруктураРеквизитовФормы.Вставить("ТипЦен",               ТипЦен);
		СтруктураРеквизитовФормы.Вставить("ВалютаДокумента",      ВалютаДокумента);
		СтруктураРеквизитовФормы.Вставить("СуммаВключаетНДС",     СуммаВключаетНДС);
		СтруктураРеквизитовФормы.Вставить("НДСВключенВСтоимость", НДСВключенВСтоимость);
		СтруктураРеквизитовФормы.Вставить("ВалютаРасчетов",       ВалютаРасчетов);
		СтруктураРеквизитовФормы.Вставить("Курс",                 Курс);
		СтруктураРеквизитовФормы.Вставить("КурсРасчетов",         КурсРасчетов);
		СтруктураРеквизитовФормы.Вставить("Кратность",            Кратность);
		СтруктураРеквизитовФормы.Вставить("КратностьРасчетов",    КратностьРасчетов);
		СтруктураРеквизитовФормы.Вставить("ПредВалютаДокумента",  ВалютаДокументаПриОткрытии);
		СтруктураРеквизитовФормы.Вставить("ИмяФормы",             "ОбщаяФорма.ФормаВалюта");
		СтруктураРеквизитовФормы.Вставить("ДокументБезНДС",       ДокументБезНДС);
		СтруктураРеквизитовФормы.Вставить("НДСНеВыделять",        НДСНеВыделять);
		СтруктураРеквизитовФормы.Вставить("ПерезаполнитьЦены",    ПерезаполнитьЦены);
		СтруктураРеквизитовФормы.Вставить("ПересчитатьЦены",      ПересчитатьЦены);
		СтруктураРеквизитовФормы.Вставить("ПересчитатьНДС",       ПересчитатьНДС);
		
		Закрыть(СтруктураРеквизитовФормы);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КурсРасчетовОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсРасчетовОбработкаВыбораНаСервере(ДатаКурса);
		ЗаполнитьКурсКратностьВалютыДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КурсРасчетовОбработкаВыбораНаСервере(ДатаКурса)
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаКурса);
	ЭтаФорма.КурсРасчетов = КурсНаДату.Курс;
	ЭтаФорма.КратностьРасчетов = КурсНаДату.Кратность;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсОбработкаВыбораНаСервере(ДатаКурса);
		ЗаполнитьКурсКратностьВалютыДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КурсОбработкаВыбораНаСервере(ДатаКурса)
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаКурса);
	ЭтаФорма.Курс = КурсНаДату.Курс;
	ЭтаФорма.Кратность = КурсНаДату.Кратность;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТипЦенПриИзмененииНаСервере(ДанныеОбъекта)
	
	ДанныеОбъекта.СуммаВключаетНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеОбъекта.ТипЦен, "ЦенаВключаетНДС");
	
	Если ДанныеОбъекта.СуммаВключаетНДС Тогда
		ДанныеОбъекта.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСВСумме;
	Иначе
		ДанныеОбъекта.ВариантРасчетаНДС =  Перечисления.ВариантыРасчетаНДС.НДССверху;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗначенияПараметровФормы()

	ЕстьВалютныйУчет = БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет();
	
	// Тип цен.
	Если Параметры.Свойство("ТипЦен") И ПравоДоступа("Просмотр", Метаданные.Справочники.ТипыЦенНоменклатуры) Тогда
		ТипЦен = Параметры.ТипЦен;
		ТипЦенПриОткрытии = Параметры.ТипЦен;
	Иначе
		Элементы.ТипЦен.Видимость = Ложь;
	КонецЕсли;

	// НДС в сумме.
	СписокВыбораВариантовРасчетаНДС = Элементы.ВариантРасчетаНДС.СписокВыбора;
	
	ПлательщикНДС = Ложь;
	Если Параметры.Свойство("Организация") И Параметры.Свойство("ДатаДокумента") Тогда
		ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Параметры.Организация, Параметры.ДатаДокумента);
	КонецЕсли;
		
	Если Параметры.Свойство("ДокументБезНДС") И Не ПлательщикНДС Тогда
		ДокументБезНДС = Параметры.ДокументБезНДС;
		ДокументБезНДСПриОткрытии = Параметры.ДокументБезНДС;
		СписокВыбораВариантовРасчетаНДС.Добавить(Перечисления.ВариантыРасчетаНДС.ДокументБезНДС);
	КонецЕсли;
	
	Если Параметры.Свойство("НДСНеВыделять") И Не ПлательщикНДС Тогда
		НДСНеВыделять = Параметры.НДСНеВыделять;
		НДСНеВыделятьПриОткрытии = Параметры.НДСНеВыделять;
		СписокВыбораВариантовРасчетаНДС.Добавить(Перечисления.ВариантыРасчетаНДС.НДСНеВыделять);
	КонецЕсли;
	
	СписокВыбораВариантовРасчетаНДС.Добавить(Перечисления.ВариантыРасчетаНДС.НДСВСумме);
	СписокВыбораВариантовРасчетаНДС.Добавить(Перечисления.ВариантыРасчетаНДС.НДССверху);
			
	Если Параметры.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСЕстьРеквизит = Истина;
		СуммаВключаетНДСПриОткрытии = Параметры.СуммаВключаетНДС;
	Иначе
		Элементы.ВариантРасчетаНДС.Видимость = Ложь;
	КонецЕсли;
		
	Если Параметры.Свойство("ДокументБезНДС") 
		И ДокументБезНДС Тогда 
		ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.ДокументБезНДС;
	ИначеЕсли Параметры.Свойство("НДСНеВыделять") 
		И НДСНеВыделять Тогда 
		ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСНеВыделять;
	ИначеЕсли Параметры.Свойство("СуммаВключаетНДС") Тогда
		ВариантРасчетаНДС = ?(СуммаВключаетНДС, Перечисления.ВариантыРасчетаНДС.НДСВСумме, Перечисления.ВариантыРасчетаНДС.НДССверху);
	Иначе
		Элементы.ВариантРасчетаНДС.Видимость = Ложь;
	КонецЕсли;	

	// НДС включать в стоимость.
	РаздельныйУчетНДСНаСчете19 = Ложь;
	Если Параметры.Свойство("Организация") И Параметры.Свойство("ДатаДокумента") Тогда
		РаздельныйУчетНДСНаСчете19 = УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Параметры.Организация, Параметры.ДатаДокумента);
	КонецЕсли;
	
	Если Параметры.Свойство("НДСВключенВСтоимость") 
		И НЕ РаздельныйУчетНДСНаСчете19 Тогда
		НДСВключенВСтоимость = Параметры.НДСВключенВСтоимость;
		Если ДокументБезНДС ИЛИ НДСНеВыделять Тогда 
			Элементы.НДСВключенВСтоимость.Доступность = Ложь;	
		КонецЕсли;
	Иначе
		Элементы.НДСВключенВСтоимость.Видимость = Ложь;
	КонецЕсли;

	// Валюта.
	Если Параметры.Свойство("ВалютаДокумента") Тогда
		ВалютаДокумента = Параметры.ВалютаДокумента;
		ВалютаДокументаПриОткрытии = Параметры.ВалютаДокумента;
		ВалютаДокументаЕстьРеквизит = Истина;
		
		ВалютаРасчетов = ВалютаДокумента;
	КонецЕсли;

	// Валюта. Курс/кратность валюты расчетов.
	КурсДокументаЕстьРеквизит = Параметры.Свойство("КурсДокумента");
	
	Если Параметры.Свойство("ЭтоПоступление") Тогда
		ЭтоПоступление = Параметры.ЭтоПоступление;
	КонецЕсли;
	
	Если Параметры.Свойство("Договор")
		И ЗначениеЗаполнено(Параметры.Договор) Тогда

		РеквизитыДоговор	= БухгалтерскийУчетПереопределяемый.ПолучитьРеквизитыДоговораКонтрагента(Параметры.Договор);
		ВалютаРасчетов 		= РеквизитыДоговор.ВалютаВзаиморасчетов;
		РасчетыВУЕ    		= РеквизитыДоговор.РасчетыВУсловныхЕдиницах;
		ВидДоговора			= РеквизитыДоговор.ВидДоговора;
		
		Если НЕ Параметры.Свойство("ЭтоПоступление") Тогда
			ЭтоПоступление = (ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком
				ИЛИ ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом
				ИЛИ ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СФакторинговойКомпанией);
		КонецЕсли;
			
		// Если есть параметр "валюта документа" и он равен валюте из договора.
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаРасчетов));

		Если (ВалютаРасчетов <> ВалютаУчета) Тогда
			
			Элементы.ГруппаВалюта.Видимость = ЕстьВалютныйУчет;
			
			Если Параметры.Свойство("Курс") Тогда
				КурсРасчетов = Параметры.Курс;
				Если КурсРасчетов = 1 Тогда
					Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
						КурсРасчетов = МассивКурсКратность[0].Курс;
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
					КурсРасчетов = МассивКурсКратность[0].Курс;
				Иначе
					КурсРасчетов = 1;
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("Кратность") Тогда
				КратностьРасчетов = Параметры.Кратность;
			Иначе
				Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
					КратностьРасчетов = МассивКурсКратность[0].Кратность;
				Иначе
					КратностьРасчетов = 1;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Элементы.ГруппаВалюта.Видимость = Ложь;
			
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				КурсРасчетов = МассивКурсКратность[0].Курс;
				КратностьРасчетов = МассивКурсКратность[0].Кратность;
			Иначе
				КурсРасчетов = 1;
				КратностьРасчетов = 1;
			КонецЕсли;
			
		КонецЕсли;

		ДоговорЕстьРеквизит = Истина;
		
	ИначеЕсли Не КурсДокументаЕстьРеквизит Тогда
		
		Элементы.ГруппаВалюта.Видимость = Ложь;
		ДоговорЕстьРеквизит = Ложь;
	
	КонецЕсли;
	
	// Валюта. Курс/кратность валюты документа.
	Если ЗначениеЗаполнено(ВалютаДокумента)  Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 
		   И (НЕ КурсДокументаЕстьРеквизит) Тогда
		   
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
			
		ИначеЕсли КурсДокументаЕстьРеквизит Тогда
			
			Курс = Параметры.КурсДокумента;
			Кратность = Параметры.КратностьДокумента;
			
			Если Курс = 0 
			   И Кратность = 0 
			   И ЗначениеЗаполнено(МассивКурсКратность) Тогда
			
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
				
			КонецЕсли;
			
		Иначе
			
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
				
			Иначе
				
				Курс = 0;
				Кратность = 0;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	ДатаДокумента = Параметры.ДатаДокумента;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКурсовВалют()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", Параметры.ДатаДокумента);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта,
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсыВалютСрезПоследних";

	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	КурсыВалют.Загрузить(ТаблицаРезультатаЗапроса);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)

	Если СуммаВключаетНДСЕстьРеквизит И
		Не ЗначениеЗаполнено(ВариантРасчетаНДС) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен вариант расчета НДС!'");
		Поле = "ВариантРасчетаНДС";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
	КонецЕсли;	
	
	// Расчеты.
	Если ДоговорЕстьРеквизит И НЕ КурсДокументаЕстьРеквизит Тогда	
		
		Если РасчетыВУЕ И ВалютаУчета <> ВалютаРасчетов Тогда // у.е.
			Если ЭтоПоступление Тогда 
				Если НЕ ЗначениеЗаполнено(КурсРасчетов) Тогда
					ТекстСообщения = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов!'");
					Поле = "КурсРасчетов";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
                КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ВалютаУчета <> ВалютаРасчетов Тогда // валюта
			Если ЭтоПоступление Тогда
				Если НЕ ЗначениеЗаполнено(КурсРасчетов) Тогда 
					ТекстСообщения = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов!'");
					Поле = "КурсВалютаПоступление";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли КурсДокументаЕстьРеквизит Тогда // прочее
		
		Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда 
			ТекстСообщения = НСтр("ru = 'Не заполнена валюта документа!'");
			Поле = "Валюта";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
		КонецЕсли;	
		
		Если НЕ ЗначениеЗаполнено(Курс) Тогда 
			ТекстСообщения = НСтр("ru = 'Не заполнен курс!'");
			Поле = "Курс";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКурсКратностьВалютыДокумента(ПересчитатьВалютуДокумента = Ложь)

	Если ЗначениеЗаполнено(ВалютаДокумента) И (НЕ КурсДокументаЕстьРеквизит ИЛИ ПересчитатьВалютуДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
			И НЕ КурсДокументаЕстьРеквизит
			И КурсРасчетов <> 0
			И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьСписокКурсовВалют()
	
	СписокКурсовВалют = Новый СписокЗначений;
	
	Если РасчетыВУЕ Тогда
		ВалютаДляОпределенияКурса = ВалютаРасчетов;
	Иначе
		ВалютаДляОпределенияКурса = ВалютаДокумента;
	КонецЕсли;
	
	Если ВалютаУчета <> ВалютаДляОпределенияКурса Тогда 
		
		КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДляОпределенияКурса, ДатаДокумента);
		СписокКурсовВалют.Добавить(КурсНаДату.Курс, Строка(КурсНаДату.Курс) + " (на " + Формат(ДатаДокумента, "ДФ = дд.ММ.гг") + ")");
		Для ДеньМинус = 1 По 5 Цикл
			ДатаКурса = ДатаДокумента - (ДеньМинус * 86400);
			КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДляОпределенияКурса, ДатаКурса);
			СписокКурсовВалют.Добавить(КурсНаДату.Курс, Строка(КурсНаДату.Курс) + " (на " + Формат(ДатаКурса, "ДФ = дд.ММ.гг") + ")");
		КонецЦикла;
		СписокКурсовВалют.Добавить(0, "<Выбрать другую дату>");
		
	КонецЕсли;
	
	Возврат СписокКурсовВалют;
	
КонецФункции	

&НаКлиенте
Процедура ПриИзмененииВалюты()
	
	Если Валюты = 0 Тогда 
		ВалютаДокумента = ВалютаРасчетов;
	Иначе
		ВалютаДокумента = ВалютаУчета;
	КонецЕсли;
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

#КонецОбласти 
