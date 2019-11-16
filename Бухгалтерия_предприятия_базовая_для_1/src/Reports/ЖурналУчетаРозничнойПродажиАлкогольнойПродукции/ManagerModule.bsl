#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 

	Возврат НСтр("ru = 'Журнал учета розничной продажи алкогольной продукции'");
	
КонецФункции

Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Макет = Отчеты.ЖурналУчетаРозничнойПродажиАлкогольнойПродукции.ПолучитьМакет("Макет164");

	// Выведем шапку
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Если ПараметрыОтчета.НачалоПериода < '20160101' Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Предупреждение");
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
		
	Если ПараметрыОтчета.ВыводитьЗаголовок Тогда
		ВывестиТитульныйЛист(ПараметрыОтчета, ТабличныйДокумент, Макет);
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");

	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	МассивСчетов41 = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.Товары);
	
	ВедетсяУчетПоСкладам = БухгалтерскийУчет.ВедетсяУчетПоСкладам(ПланыСчетов.Хозрасчетный.Товары);
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ЗначениеЗаполнено(ПараметрыОтчета.Склад) И ВедетсяУчетПоСкладам Тогда
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет41", 		МассивСчетов41);
	Запрос.УстановитьПараметр("ВидыСубконто", 	ВидыСубконто);
	Запрос.УстановитьПараметр("Организация", 	ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("Склад", 			ПараметрыОтчета.Склад);
	Запрос.УстановитьПараметр("Подразделение", 	ПараметрыОтчета.Подразделение);
	Запрос.УстановитьПараметр("Дата169", 		'20150824');
	Запрос.УстановитьПараметр("ДатаНач", 		НачалоДня(ПараметрыОтчета.НачалоПериода));
	Запрос.УстановитьПараметр("ДатаКон", 		Новый Граница(КонецДня(ПараметрыОтчета.КонецПериода), ВидГраницы.Включая));
	Текст =
		"ВЫБРАТЬ
		|	СведенияОбАлкогольнойПродукции.Номенклатура КАК Номенклатура,
		|	СведенияОбАлкогольнойПродукции.Номенклатура.НаименованиеПолное КАК ТоварНаименование,
		|	СведенияОбАлкогольнойПродукции.КоэффПересчетаДал * 10 КАК Емкость,
		|	СведенияОбАлкогольнойПродукции.КоэффПересчетаДал КАК КоэффПересчетаДал,
		|	СведенияОбАлкогольнойПродукции.НаименованиеВида169 КАК ВидПродукции169,
		|	СведенияОбАлкогольнойПродукции.КодВида169 КАК КодВидаПродукции169
		|ПОМЕСТИТЬ АлкогольнаяПродукция
		|ИЗ
		|	РегистрСведений.СведенияОбАлкогольнойПродукции КАК СведенияОбАлкогольнойПродукции
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОбороты.Субконто1 КАК Номенклатура,
		|	НАЧАЛОПЕРИОДА(ХозрасчетныйОбороты.Период, ДЕНЬ) КАК ДатаПродажи,
		|	СУММА(ХозрасчетныйОбороты.КоличествоОборотКт) КАК Количество
		|ПОМЕСТИТЬ Продажи
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&ДатаНач,
		|			&ДатаКон,
		|			Регистратор,
		|			Счет В (&Счет41),
		|			&ВидыСубконто,
		|			&Условие
		|				И Субконто1 В
		|					(ВЫБРАТЬ
		|						АлкогольнаяПродукция.Номенклатура
		|					ИЗ
		|						АлкогольнаяПродукция),
		|			,
		|			) КАК ХозрасчетныйОбороты
		|ГДЕ
		|	ХозрасчетныйОбороты.КоличествоОборотКт > 0
		|	И ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйОбороты.Субконто1,
		|	НАЧАЛОПЕРИОДА(ХозрасчетныйОбороты.Период, ДЕНЬ)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АлкогольнаяПродукция.КодВидаПродукции169 КАК КодВидаПродукции,
		|	АлкогольнаяПродукция.ТоварНаименование КАК Наименование,
		|	АлкогольнаяПродукция.Номенклатура КАК Номенклатура,
		|	АлкогольнаяПродукция.Емкость КАК Емкость,
		|	Продажи.ДатаПродажи КАК ДатаПродажи,
		|	Продажи.Количество КАК Количество
		|ПОМЕСТИТЬ ВТ_ЖурналПродажАлкогольнойПродукции
		|ИЗ
		|	Продажи КАК Продажи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукция КАК АлкогольнаяПродукция
		|		ПО (АлкогольнаяПродукция.Номенклатура = Продажи.Номенклатура)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ЖурналПродажАлкогольнойПродукции.ДатаПродажи КАК ДатаПродажи,
		|	ВТ_ЖурналПродажАлкогольнойПродукции.КодВидаПродукции КАК КодВидаПродукции,
		|	СУММА(ВТ_ЖурналПродажАлкогольнойПродукции.Количество) КАК Количество
		|ИЗ
		|	ВТ_ЖурналПродажАлкогольнойПродукции КАК ВТ_ЖурналПродажАлкогольнойПродукции
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ЖурналПродажАлкогольнойПродукции.КодВидаПродукции,
		|	ВТ_ЖурналПродажАлкогольнойПродукции.ДатаПродажи
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПродажи,
		|	КодВидаПродукции
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ЖурналПродажАлкогольнойПродукции.ДатаПродажи КАК ДатаПродажи,
		|	ВТ_ЖурналПродажАлкогольнойПродукции.Наименование КАК НаименованиеПродукции,
		|	СУММА(ВТ_ЖурналПродажАлкогольнойПродукции.Количество) КАК Количество
		|ИЗ
		|	ВТ_ЖурналПродажАлкогольнойПродукции КАК ВТ_ЖурналПродажАлкогольнойПродукции
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ЖурналПродажАлкогольнойПродукции.Наименование,
		|	ВТ_ЖурналПродажАлкогольнойПродукции.ДатаПродажи
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПродажи,
		|	НаименованиеПродукции
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЖурналПродажАлкогольнойПродукции.КодВидаПродукции,
		|	ЖурналПродажАлкогольнойПродукции.Наименование КАК Наименование,
		|	ЖурналПродажАлкогольнойПродукции.Номенклатура,
		|	ЖурналПродажАлкогольнойПродукции.Емкость КАК Емкость,
		|	ЖурналПродажАлкогольнойПродукции.ДатаПродажи КАК ДатаПродажи,
		|	ЖурналПродажАлкогольнойПродукции.Количество КАК Количество
		|ИЗ
		|	ВТ_ЖурналПродажАлкогольнойПродукции КАК ЖурналПродажАлкогольнойПродукции
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПродажи,
		|	Наименование,
		|	Емкость
		|ИТОГИ
		|	СУММА(Количество)
		|ПО
		|	ДатаПродажи";
	
		
	СтрокаУсловия = "Организация = &Организация";
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Склад) И ВедетсяУчетПоСкладам Тогда
		СтрокаУсловия = СтрокаУсловия + " И Субконто2 = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Подразделение) Тогда
		СтрокаУсловия = СтрокаУсловия + " И Подразделение = &Подразделение";
	КонецЕсли;
	
	Текст = СтрЗаменить(Текст, "&Условие", СтрокаУсловия);
	
	Запрос.Текст = Текст;
	РезультатЗапроса = Запрос.ВыполнитьПакет();

	РезультатПоДням      = РезультатЗапроса[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ИтогиПоКодам         = РезультатЗапроса[3].Выбрать();
	ИтогиПоНаименованиям = РезультатЗапроса[4].Выбрать();
	
	
	НомерСтроки = Макс(ПараметрыОтчета.НомерНачальнойСтроки, 1) - 1;
		
	ОбластьМакета              = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал              = Макет.ПолучитьОбласть("Подвал");
	ОбластьИтогоПоКоду         = Макет.ПолучитьОбласть("ИтогоПоКоду");
	ОбластьИтогоПоНаименованию = Макет.ПолучитьОбласть("ИтогоПоНаименованию");
	ОбластьИтогоПоКоличеству   = Макет.ПолучитьОбласть("ИтогоПоКоличеству");

	Пока РезультатПоДням.Следующий() Цикл
		
		ДвиженияЗаДень = РезультатПоДням.Выбрать();
		Пока ДвиженияЗаДень.Следующий() Цикл
			НомерСтроки 			= НомерСтроки + 1;
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			ОбластьМакета.Параметры.Заполнить(ДвиженияЗаДень);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОтборПоДате = Новый Структура("ДатаПродажи",РезультатПоДням.ДатаПродажи);
		
		ИтогиПоКодам.Сбросить();
		Пока ИтогиПоКодам.НайтиСледующий(ОтборПоДате) Цикл
			ОбластьИтогоПоКоду.Параметры.Заполнить(ИтогиПоКодам);
			ТабличныйДокумент.Вывести(ОбластьИтогоПоКоду);
		КонецЦикла;
		
		ИтогиПоНаименованиям.Сбросить();
		Пока ИтогиПоНаименованиям.НайтиСледующий(ОтборПоДате) Цикл
			ОбластьИтогоПоНаименованию.Параметры.Заполнить(ИтогиПоНаименованиям);
			ТабличныйДокумент.Вывести(ОбластьИтогоПоНаименованию);
		КонецЦикла;
		
		ОбластьИтогоПоКоличеству.Параметры.Заполнить(РезультатПоДням);
		ТабличныйДокумент.Вывести(ОбластьИтогоПоКоличеству);
		
	КонецЦикла;
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Область("СтрокиДляПовтора");
	
	Если ПараметрыОтчета.НачалоПериода < '20160101' Тогда
		НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
		ТабличныйДокумент.ОбластьПечати = ТабличныйДокумент.Область(2, , НомерСтрокиОкончание, );
		ТабличныйДокумент.ФиксацияСверху = 1;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура("ТабличныйДокумент, НомерПоследнейСтроки", ТабличныйДокумент, НомерСтроки);
	
	ПоместитьВоВременноеХранилище(СтруктураВозврата, АдресХранилища);
		
КонецПроцедуры

Процедура ВывестиТитульныйЛист(ПараметрыОтчета, Результат, Макет)
	
	ОбластьОрганизация      = Макет.ПолучитьОбласть("ТитульныйЛист");
	
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	ТекстИНН = СведенияОбОрганизации.Инн;
	
	Если СведенияОбОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо 
		И ЗначениеЗаполнено(ПараметрыОтчета.Подразделение) Тогда
		ОбластьОрганизация.Параметры.ИНН = ТекстИНН + "/" + Справочники.ПодразделенияОрганизаций.КППНаДату(ПараметрыОтчета.Подразделение, ПараметрыОтчета.КонецПериода);		
	ИначеЕсли СведенияОбОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		ОбластьОрганизация.Параметры.ИНН = ТекстИНН + "/" + Справочники.Организации.КППНаДату(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	Иначе
		ОбластьОрганизация.Параметры.ИНН = ТекстИНН;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Подразделение) Тогда
		ОбластьОрганизация.Параметры.Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ПараметрыОтчета.Подразделение, Справочники.ВидыКонтактнойИнформации.ФактическийАдресПодразделенияОрганизаций);
	Иначе
		ОбластьОрганизация.Параметры.Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ПараметрыОтчета.Организация, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	КонецЕсли;
	
	Результат.Вывести(ОбластьОрганизация);		
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "ТитульныйЛист";
	
КонецПроцедуры

#КонецЕсли