#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СсылкаНаЭД = "";
	Если Параметры.Свойство("ЭлектронныйДокумент",СсылкаНаЭД) Тогда
		
		ЗначениеВРеквизитФормы(СсылкаНаЭД.ПолучитьОбъект(),"ЭлектронныйДокумент");
		
		Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ЭДПрисоединенныеФайлы.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
				|ГДЕ
				|	ЭДПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
				|	И ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД = &ТипЭлементаВерсииЭД
				|	И ЭДПрисоединенныеФайлы.Расширение = ""xml""";
			Запрос.УстановитьПараметр("ВладелецФайла", ЭлектронныйДокумент.Ссылка);
			Запрос.УстановитьПараметр("ТипЭлементаВерсииЭД",ЭлектронныйДокумент.ТипЭлементаВерсииЭД);
			
			УстановитьПривилегированныйРежим(Истина);
			РезультатЗапроса = Запрос.Выполнить();
			УстановитьПривилегированныйРежим(Ложь);
			Если НЕ РезультатЗапроса.Пустой() Тогда
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				ДанныеФайлаXML = РаботаСФайлами.ДвоичныеДанныеФайла(Выборка.Ссылка);
				ПараметрыПроизвольногоДокумента = ОбменСКонтрагентамиСлужебный.ПараметрыФайлаПроизвольногоДокумента(ДанныеФайлаXML, Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.ПрикладнойЭД Тогда
			ВидЭлектронногоДокумента = ЭлектронныйДокумент.ПрикладнойВидЭД;
		ИначеЕсли ПараметрыПроизвольногоДокумента = Неопределено Тогда
			ВидЭлектронногоДокумента = ЭлектронныйДокумент.ВидЭД;
		ИначеЕсли ПараметрыПроизвольногоДокумента.Свойство("ВидЭДДляОтраженияВУчете") Тогда
			ВидЭлектронногоДокумента = ПараметрыПроизвольногоДокумента.ВидЭДДляОтраженияВУчете;
		Иначе
			ВидЭлектронногоДокумента = ЭлектронныйДокумент.ВидЭД;
		КонецЕсли;
		
		СписокТиповДокументов = ОбменСКонтрагентамиСлужебный.СписокОперацийВидаЭД(ВидЭлектронногоДокумента);
		
		Если СписокТиповДокументов.Количество() = 0 Тогда
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			
		ИначеЕсли ЭлектронныйДокумент.ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.СЧФДОПУПД Тогда
			СписокТиповДокументовТН = ОбменСКонтрагентамиСлужебный.СписокОперацийВидаЭД(Перечисления.ВидыЭД.ТОРГ12Продавец);
				
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			Элементы.ФормаСоздатьДокумент.Видимость = Ложь;
			
			Для Каждого ЭлементСпискаСФ Из СписокТиповДокументов Цикл
				Для Каждого ЭлементСпискаТН Из СписокТиповДокументовТН Цикл
					
					НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + ЭлементСпискаСФ.Значение + "_И_" + ЭлементСпискаТН.Значение);
					НоваяКоманда.Действие = "СоздатьДокументУчета";
					
					НоваяКнопка = Элементы.Добавить("Создать_" + ЭлементСпискаСФ.Значение + "_И_" + ЭлементСпискаТН.Значение,
						Тип("КнопкаФормы"), Элементы.ГруппаСоздать);
					НоваяКнопка.Заголовок = ЭлементСпискаСФ.Представление + "; " + ЭлементСпискаТН.Представление;
					НоваяКнопка.ИмяКоманды = "Создать_" + ЭлементСпискаСФ.Значение + "_И_" + ЭлементСпискаТН.Значение;
					
				КонецЦикла;
			КонецЦикла;
			
			Для Каждого ЭлементСпискаТН Из СписокТиповДокументовТН Цикл
				Если СписокТиповДокументов.НайтиПоЗначению(ЭлементСпискаТН.Значение) = Неопределено Тогда
					НовыйЭлементСписка = СписокТиповДокументов.Добавить();
					ЗаполнитьЗначенияСвойств(НовыйЭлементСписка, ЭлементСпискаТН);
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого ЭлементСписка Из СписокТиповДокументов Цикл
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "ПодобратьДокумент";
				
				НоваяКнопка = Элементы.Добавить("Прикрепить_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаПодобрать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;  
				НоваяКнопка.ИмяКоманды = "Прикрепить_" + ЭлементСписка.Значение;
			КонецЦикла;
			
		ИначеЕсли СписокТиповДокументов.Количество() = 1 Тогда
			
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			
			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "СоздатьДокументУчета";
			Элементы.ФормаСоздатьДокумент.ИмяКоманды = "Создать_" + СписокТиповДокументов[0].Значение;

			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "ПодобратьДокумент";
			Элементы.ФормаПодобратьДокумент.ИмяКоманды = "Прикрепить_" + СписокТиповДокументов[0].Значение;
			
		Иначе
			
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			Элементы.ФормаСоздатьДокумент.Видимость = Ложь;
			
			Для Каждого ЭлементСписка Из СписокТиповДокументов Цикл
				
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "СоздатьДокументУчета";
				
				НоваяКнопка = Элементы.Добавить("Создать_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаСоздать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;
				НоваяКнопка.ИмяКоманды = "Создать_" + ЭлементСписка.Значение;
				
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "ПодобратьДокумент";
				
				НоваяКнопка = Элементы.Добавить("Прикрепить_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаПодобрать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;  
				НоваяКнопка.ИмяКоманды = "Прикрепить_" + ЭлементСписка.Значение;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ВидЭлектронногоДокумента = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			Элементы.ГруппаСоздать.Видимость = Ложь;
			Элементы.ФормаПерезаполнитьТекущий.Видимость = Ложь;
		КонецЕсли;
		
		Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.ПрикладнойЭД Тогда
			АктуальныеВидыЭД = ОбменСКонтрагентамиСлужебный.ПрикладныеВидыЭлектронныхДокументов();
		Иначе
			СоответствиеАктуальныеВидыЭД = ОбменСКонтрагентамиПовтИсп.ПолучитьАктуальныеВидыЭД(Перечисления.НаправленияЭД.Входящий);
			АктуальныеВидыЭД = Новый Массив;
			Для каждого КлючИЗначение Из СоответствиеАктуальныеВидыЭД Цикл
				АктуальныеВидыЭД.Добавить(КлючИЗначение.Ключ);
			КонецЦикла;
		КонецЕсли;
		
		Если АктуальныеВидыЭД.Найти(ВидЭлектронногоДокумента) = Неопределено Тогда
			Элементы.ФормаСоздатьДокумент.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	ОтображениеГруппыНастройкиОтраженияВУчете();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностью();
	
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьНастройкаОтраженияВУчетеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Элементы.ГруппаНастройкиОтраженияВУчете.Видимость = Ложь;
	
	ЗапретитьСпрашиватьПроСохранениеНастроекУчета();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьТекущий(Команда)
	
	Модифицированность = Ложь;
	ТекСтрока = Элементы.ЭлектронныйДокументДокументыОснования.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Документ учета будет заполнены данными электронного документа. Продолжить?'");
		
		СпособОбработки = ТекСтрока.СпособОбработки;
		Если ЭлектронныйДокумент.ТипЭлементаВерсииЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.СЧФДОПУПД")
				ИЛИ ЭлектронныйДокумент.ТипЭлементаВерсииЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.КСЧФДИСУКД") Тогда
			
			СтруктураСпособовОбработки = Новый Структура("ПервичныйДокумент, СчетФактура");
			
			СпособОбработкиВторогоДокумента = "";
			Если ЭлектронныйДокумент.ДокументыОснования.Количество() = 2 Тогда
				Если ТекСтрока.НомерСтроки = 1 Тогда
					СпособОбработкиВторогоДокумента = ЭлектронныйДокумент.ДокументыОснования[1].СпособОбработки;
				Иначе
					СпособОбработкиВторогоДокумента = ЭлектронныйДокумент.ДокументыОснования[0].СпособОбработки;
				КонецЕсли;
			Иначе
				Если СписокТиповДокументов[0].Значение = ТекСтрока.СпособОбработки Тогда
					Если СписокТиповДокументов.Количество() > 1 Тогда
						СпособОбработкиВторогоДокумента = СписокТиповДокументов[1].Значение;
					КонецЕсли;
				Иначе
					СпособОбработкиВторогоДокумента = СписокТиповДокументов[0].Значение;
				КонецЕсли;
			КонецЕсли;
			
			Если СписокТиповДокументов[0].Значение = ТекСтрока.СпособОбработки Тогда
				СтруктураСпособовОбработки.СчетФактура = ТекСтрока.СпособОбработки;
				СтруктураСпособовОбработки.ПервичныйДокумент = СпособОбработкиВторогоДокумента;
			Иначе
				СтруктураСпособовОбработки.ПервичныйДокумент = ТекСтрока.СпособОбработки;
				СтруктураСпособовОбработки.СчетФактура = СпособОбработкиВторогоДокумента;
			КонецЕсли;
			
			СпособОбработки = СтруктураСпособовОбработки;
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура("ДокументОснование,СпособОбработки",ТекСтрока.ДокументОснование, СпособОбработки);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПерезаполнитьТекущийПродолжить", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьДокумент(Команда)
	
	Модифицированность = Ложь;
	
	СпособОбработки = СтрЗаменить(Команда.Имя,"Прикрепить_","");
	НастройкиПодбора = НастройкиПодбораУчетногоДокумента(СпособОбработки, ЭлектронныйДокумент);
	
	Если НастройкиПодбора <> Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодобратьДокументЗавершить", ЭтотОбъект, СпособОбработки);
		ОбменСКонтрагентамиСлужебныйКлиент.ПоказатьПодборУчетногоДокумента(НастройкиПодбора, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументУчета(Команда)
	
	СоздатьДокументУчетаНаСервере(СтрЗаменить(Команда.Имя,"Создать_",""));
	ОповеститьВладельца();
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязьСДокументом(Команда)
		
	ТекСтрока = Элементы.ЭлектронныйДокументДокументыОснования.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Связь между документами разорвется. Повторно связать документы возможно только в ручном режиме. Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьСвязьСДокументомЗавершить", ЭтотОбъект, ТекСтрока.ДокументОснование);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеДоступностью()

	Элементы.ФормаСоздатьДокумент.Доступность = ЭлектронныйДокумент.ДокументыОснования.Количество() = 0;
	Элементы.ГруппаСоздать.Доступность = ЭлектронныйДокумент.ДокументыОснования.Количество() = 0;

КонецПроцедуры

&НаКлиенте
Процедура ПодобратьДокументЗавершить(Знач Результат, Знач СпособОбработки) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ПерепривязатьЭлектронныйДокумент(Результат,СпособОбработки);
		ОповеститьВладельца();
		УправлениеДоступностью();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца()
	
	Оповестить("ЭлектронныйДокументВходящий_ПодборДокументаУчета",ЭлектронныйДокумент.Ссылка, ЭтотОбъект.ВладелецФормы);
	Оповестить("ОбновитьТекущиеДелаЭДО");
	
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументУчетаНаСервере(СпособОбработки)
	
	Если ЭлектронныйДокумент.ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.СЧФДОПУПД Тогда
		МассивСпособов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СпособОбработки, "_И_");
		Если МассивСпособов.Количество() = 2 Тогда
			СпособОбработки = Новый Структура("ПервичныйДокумент, СчетФактура", МассивСпособов[1], МассивСпособов[0]);
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭлектронныйДокумент", ЭлектронныйДокумент.Ссылка);
	ЭД = ОбменСКонтрагентамиСлужебный.ПрисоединенныйФайл(ЭлектронныйДокумент.Ссылка);
	Если ОбменСКонтрагентамиСлужебный.ЭтоОтветныйТитул(ЭД.ТипЭлементаВерсииЭД) Тогда
		ЭД = ЭД.ЭлектронныйДокументВладелец;
	КонецЕсли;
	СтруктураПараметров.Вставить("ФайлДанныхСсылка", ОбменСКонтрагентамиСлужебный.ПолучитьДанныеЭД(ЭД));
	
	Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		
		ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭД, "ВладелецФайла");
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВладелецФайла, "Организация, Контрагент, ДоговорКонтрагента");
		НастройкаЭДО = ОбменСКонтрагентамиСлужебный.СсылкаНаОбъектНастройкиЭДО(Реквизиты.Организация, Реквизиты.Контрагент, Реквизиты.ДоговорКонтрагента);
		
		ДокументыУчета = Новый Массив;
		ДокументыУчета.Добавить(НастройкаЭДО);
		
	ИначеЕсли ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.ПрикладнойЭД Тогда
		ДокументыУчета = ОбменСКонтрагентамиВнутренний.СохранитьДанныеОбъектаПрикладногоФормата(
			СтруктураПараметров, СпособОбработки);
	Иначе
		Если ПараметрыПроизвольногоДокумента <> Неопределено Тогда
			ДанныеXML = ПолучитьИзВременногоХранилища(СтруктураПараметров.ФайлДанныхСсылка);
			ДанныеCML = ОбменСКонтрагентамиСлужебный.ДанныеCMLПроизвольногоДокумента(
				ДанныеXML, ПараметрыПроизвольногоДокумента);
			Если ДанныеCML <> Неопределено Тогда
				СтруктураПараметров.Вставить("ФайлДанныхСсылка", ПоместитьВоВременноеХранилище(ДанныеCML));
			КонецЕсли;
		КонецЕсли;
		ДокументыУчета = ОбменСКонтрагентамиВнутренний.СохранитьДанныеОбъекта(СтруктураПараметров, СпособОбработки);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументыУчета) Тогда
		ДокументОбъект = РеквизитФормыВЗначение("ЭлектронныйДокумент",Тип("ДокументОбъект.ЭлектронныйДокументВходящий"));
		Для каждого Основание Из ДокументыУчета Цикл
			
			Если Не ДокументОбъект.ДокументыОснования.Найти(Основание, "ДокументОснование") = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ДокументОбъект.ДокументыОснования.Добавить();
			НоваяСтрока.ДокументОснование = Основание;
			
			Если ТипЗнч(СпособОбработки) = Тип("Структура") Тогда												
				Если ОбменСКонтрагентамиВнутренний.ДокументЯвляетсяСчетомФактурой(Основание) Тогда
					НоваяСтрока.СпособОбработки = СпособОбработки.СчетФактура;
				Иначе
					НоваяСтрока.СпособОбработки = СпособОбработки.ПервичныйДокумент;
				КонецЕсли;
			Иначе
				НоваяСтрока.СпособОбработки  = СпособОбработки;
			КонецЕсли;

			ОбменСКонтрагентамиСлужебный.УстановитьСсылкуДляВладельцаВРегистреСостояний(Основание, ЭлектронныйДокумент.Ссылка);
		КонецЦикла;
		ДокументОбъект.Записать();

		ЗначениеВРеквизитФормы(ДокументОбъект,"ЭлектронныйДокумент");
	КонецЕсли;
	
	Если Элементы.ГруппаНастройкиОтраженияВУчете.Видимость Тогда
			ТекущаяГранула = ОбменСКонтрагентамиСлужебный.ГранулаНастройкиОтраженияВУчете(
				ЭлектронныйДокумент.ИдентификаторОрганизации, ЭлектронныйДокумент.ИдентификаторКонтрагента,
				ЭлектронныйДокумент.Организация, ЭлектронныйДокумент.Контрагент,
				ЭлектронныйДокумент.ВидЭД, ЭлектронныйДокумент.ПрикладнойВидЭД);
			
			Отказ = Ложь;
			ОбменСКонтрагентамиСлужебный.ЗаписатьНастройкиПолученияДокументов(ТекущаяГранула, СпособОбработки, Истина, Отказ);
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			
			Элементы.ГруппаНастройкиОтраженияВУчете.Видимость = Ложь;
			
		КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязьСДокументомЗавершить(Результат, СсылкаНаОбъект) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект,ЭлектронныйДокумент.Ссылка);
		ОповеститьВладельца();
		УправлениеДоступностью();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект,ЭД)
	
	ОбработатьДокументыОснования(СсылкаНаОбъект,,Истина);
	Если ЭлектронныйДокумент.ВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
		ОбменСКонтрагентамиСлужебный.УдалитьСсылкуДляВладельцаВРегистреСостояний(СсылкаНаОбъект,ЭД);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиПодбораУчетногоДокумента(Знач СпособОбработки, Знач ЭлектронныйДокумент)
	
	Настройки = Новый Структура;
	
	ИмяТипа = ОбменСКонтрагентамиСлужебный.ИмяДокументаПоСпособуОбработки(СпособОбработки);
	
	Тип = Неопределено;
	Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено Тогда
		
		МетаданныеОбъекта = Метаданные.Справочники.Найти(ИмяТипа);
		Настройки.Вставить("ИмяОбъектаМетаданных", МетаданныеОбъекта.ПолноеИмя());
		Настройки.Вставить("ИмяТипаСсылки", "СправочникСсылка." + ИмяТипа);
		
	ИначеЕсли Метаданные.Документы.Найти(ИмяТипа) <> Неопределено Тогда
		
		МетаданныеОбъекта = Метаданные.Документы.Найти(ИмяТипа);
		Настройки.Вставить("ИмяОбъектаМетаданных", МетаданныеОбъекта.ПолноеИмя());
		Настройки.Вставить("ИмяТипаСсылки", "ДокументСсылка." + ИмяТипа);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Настройки.Вставить("Организация", ЭлектронныйДокумент.Организация);
	Настройки.Вставить("Контрагент" , ЭлектронныйДокумент.Контрагент);
	
	Возврат Настройки;
		
КонецФункции

&НаСервере
Процедура ПерепривязатьЭлектронныйДокумент(ВыбранноеЗначение, СпособОбработки)
	
	ОбработатьДокументыОснования(ВыбранноеЗначение,СпособОбработки);
	Если ЭлектронныйДокумент.ВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
		ОбменСКонтрагентамиСлужебный.УстановитьСсылкуДляВладельцаВРегистреСостояний(ВыбранноеЗначение,ЭлектронныйДокумент.Ссылка);
		
		Если Элементы.ГруппаНастройкиОтраженияВУчете.Видимость Тогда
			ТекущаяГранула = ОбменСКонтрагентамиСлужебный.ГранулаНастройкиОтраженияВУчете(
				ЭлектронныйДокумент.ИдентификаторОрганизации, ЭлектронныйДокумент.ИдентификаторКонтрагента,
				ЭлектронныйДокумент.Организация, ЭлектронныйДокумент.Контрагент,
				ЭлектронныйДокумент.ВидЭД, ЭлектронныйДокумент.ПрикладнойВидЭД);
			
			Отказ = Ложь;
			ОбменСКонтрагентамиСлужебный.ЗаписатьНастройкиПолученияДокументов(ТекущаяГранула, СпособОбработки, Истина, Отказ);
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			
			Элементы.ГруппаНастройкиОтраженияВУчете.Видимость = Ложь;
			
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьДокументыОснования(СсылкаНаДокумент,СпособОбработки = "",Удаление = Ложь)
	
	ДокументОбъект = РеквизитФормыВЗначение("ЭлектронныйДокумент",Тип("ДокументОбъект.ЭлектронныйДокументВходящий"));
	
	СтрокаОснования = ДокументОбъект.ДокументыОснования.Найти(СсылкаНаДокумент,"ДокументОснование");
	
	Если Удаление И СтрокаОснования <> Неопределено  Тогда
		ДокументОбъект.ДокументыОснования.Удалить(СтрокаОснования);
	КонецЕсли;
	
	Если НЕ Удаление И СтрокаОснования = Неопределено Тогда
		НоваяСтрока = ДокументОбъект.ДокументыОснования.Добавить();
		НоваяСтрока.ДокументОснование = СсылкаНаДокумент;
		НоваяСтрока.СпособОбработки = СпособОбработки;
	КонецЕсли;	
	
	ДокументОбъект.Записать();
	
	ЗначениеВРеквизитФормы(ДокументОбъект,"ЭлектронныйДокумент");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектронныйДокументДокументыОснованияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.ЭлектронныйДокументДокументыОснования.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ПоказатьЗначение(,ТекСтрока.ДокументОснование);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТекущийПродолжить(Результат, СтруктураПараметров) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОбменСКонтрагентамиКлиент.ПерезаполнитьДокумент(СтруктураПараметров.ДокументОснование, ЭлектронныйДокумент.Ссылка,
			СтруктураПараметров.СпособОбработки);

		ОповеститьВладельца();
		
		УправлениеДоступностью();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеГруппыНастройкиОтраженияВУчете()
	
	Элементы.НадписьНастройкаОтраженияВУчете.Заголовок =
		СтрШаблон(Элементы.НадписьНастройкаОтраженияВУчете.Заголовок, ЭлектронныйДокумент.Контрагент);
	
	СпрашиватьПроСохранениеНастроекУчета = ОбменСКонтрагентамиСлужебный.ПредложитьСохранитьНастройкуОтраженияВУчете(
		ЭлектронныйДокумент.Контрагент, ЭлектронныйДокумент.Организация,
		ЭлектронныйДокумент.ИдентификаторКонтрагента, ЭлектронныйДокумент.ИдентификаторОрганизации,
		ЭлектронныйДокумент.ВидЭД, ЭлектронныйДокумент.ПрикладнойВидЭД);
		
	ЕстьСвязанныеДокументы = ЭлектронныйДокумент.ДокументыОснования.Количество() > 0;
	Элементы.ГруппаНастройкиОтраженияВУчете.Видимость = СпрашиватьПроСохранениеНастроекУчета И Не ЕстьСвязанныеДокументы;
	
КонецПроцедуры

&НаСервере
Процедура ЗапретитьСпрашиватьПроСохранениеНастроекУчета()
	
	ТекущаяГранула = ОбменСКонтрагентамиСлужебный.ГранулаНастройкиОтраженияВУчете(
		ЭлектронныйДокумент.ИдентификаторОрганизации, ЭлектронныйДокумент.ИдентификаторКонтрагента,
		ЭлектронныйДокумент.Организация, ЭлектронныйДокумент.Контрагент,
		ЭлектронныйДокумент.ВидЭД, ЭлектронныйДокумент.ПрикладнойВидЭД);
	
	Отказ = Ложь;
	ОбменСКонтрагентамиСлужебный.ЗаписатьНастройкиПолученияДокументов(ТекущаяГранула, Неопределено, Истина, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаНастройкиОтраженияВУчете.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти


