#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 20, 0);
	
КонецФункции

#Область СчетаУчета

Процедура УстановитьПравилаЗаполненияСчетовУчета(Правила) Экспорт
	// Шапка
	СчетаУчетаВДокументах.ДобавитьПравилоЗаполнения(Правила, "", "СчетУчетаРасчетовСКонтрагентом", "РасчетыПоПретензиям");
	
	// Данные заполнения
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "Дата");
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "Организация");
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "Контрагент");
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "ДоговорКонтрагента");
	
КонецПроцедуры

#КонецОбласти

// Заполняет документ остатками взаиморасчетов по контрагенту
//
Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	СтруктураДанныхЗаполнения = Новый Структура();
	СтруктураДанныхЗаполнения.Вставить("Успешно", Истина);
	
	Если НЕ ПроверитьОтложенныеРасчеты(СтруктураПараметров) Тогда
		СтруктураДанныхЗаполнения.Успешно = Ложь;
		ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПокупателей();
	
	СчетаРасчетовБезАналитикиПоДокументам = СчетаУчетаРасчетов.СчетаБезДокументаРасчетов;
	СчетаРасчетовСАналитикойПоДокументам  = СчетаУчетаРасчетов.СчетаСДокументомРасчетов;
	
	СписокВалютыРеглУчета = Новый СписокЗначений;
	СписокВалютыРеглУчета.Добавить(СтруктураПараметров.ВалютаРегламентированногоУчета);
	СписокВалютыРеглУчета.Добавить(Справочники.Валюты.ПустаяСсылка());
	
	ЧастиЗапроса = Новый Массив;
	Если СчетаРасчетовСАналитикойПоДокументам.Количество() <> 0 Тогда
		ЧастиЗапроса.Добавить(ТекстЗапросаПоДокументам());
	КонецЕсли;
	Если СчетаРасчетовБезАналитикиПоДокументам.Количество() <> 0 Тогда
		ЧастиЗапроса.Добавить(ТекстЗапросаБезДокументов());
	КонецЕсли;
	ТекстЗапроса = СтрСоединить(ЧастиЗапроса, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	ТекстЗапроса = ТекстЗапроса + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Номер";
	
	ДокументВВалюте = ЗначениеЗаполнено(СтруктураПараметров.ВалютаДокумента)
					И СтруктураПараметров.ВалютаДокумента <> СтруктураПараметров.ВалютаРегламентированногоУчета;
	
	Если ДокументВВалюте Тогда
		
		ВалютаДокумента = СтруктураПараметров.ВалютаДокумента;
		Условие_ВалютаДоговора =
			"НЕ ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВалютаВзаиморасчетов В (&ВалютаРеглУчета)
		|	И ХозрасчетныйОстатки.ВалютнаяСуммаОстатокДт > 0";
		Условие_ВалютаОстатков = "И Валюта = &ВалютаДокумента";
		
	Иначе
		
		ВалютаДокумента = СтруктураПараметров.ВалютаРегламентированногоУчета;
		Условие_ВалютаДоговора =
			"(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).РасчетыВУсловныхЕдиницах
		|			ИЛИ ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВалютаВзаиморасчетов В (&ВалютаРеглУчета))
		|	И ХозрасчетныйОстатки.СуммаОстатокДт > 0";
		Условие_ВалютаОстатков = "";
		
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Условие_ВалютаДоговора", Условие_ВалютаДоговора);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &Условие_ВалютаОстатков", Условие_ВалютаОстатков);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Период", СтруктураПараметров.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("Контрагент",  СтруктураПараметров.Контрагент);
	Запрос.УстановитьПараметр("Договор",     СтруктураПараметров.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ВалютаРеглУчета",  СписокВалютыРеглУчета);
	
	Запрос.УстановитьПараметр("СчетаРасчетовБезАналитикиПоДокументам", СчетаРасчетовБезАналитикиПоДокументам);
	Запрос.УстановитьПараметр("СчетаРасчетовСАналитикойПоДокументам",  СчетаРасчетовСАналитикойПоДокументам);
	Запрос.УстановитьПараметр("ВалютаДокумента",                       ВалютаДокумента);
	
	ТабличнаяЧастьМетаданные = Метаданные.Документы.НачислениеПеней.ТабличныеЧасти.Задолженность.Реквизиты;
	Запрос.УстановитьПараметр("ТипыДокументовРасчетов", ТабличнаяЧастьМетаданные.Сделка.Тип.Типы());
	
	Запрос.УстановитьПараметр("ВидыСубконтоБезДокументов", СтруктураПараметров.АналитикаРасчетов);
	ВидыСубконтоСДокументами = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(СтруктураПараметров.АналитикаРасчетов);
	ВидыСубконтоСДокументами.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
	Запрос.УстановитьПараметр("ВидыСубконтоСДокументами", ВидыСубконтоСДокументами);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	Если ДокументВВалюте Тогда
		ТаблицаРезультата.Колонки.ВалютнаяСуммаОстаток.Имя = "Задолженность";
	Иначе
		ТаблицаРезультата.Колонки.СуммаОстаток.Имя = "Задолженность";
	КонецЕсли;
	ТаблицаРезультата.Колонки.Добавить("Представление", ТабличнаяЧастьМетаданные.Представление.Тип);
	
	// Сформируем строку представления
	Для каждого СтрокаОстатков Из ТаблицаРезультата Цикл
		
		ПредставлениеВида = ВидДокументаОстатка(СтрокаОстатков);
		Если СтрокаОстатков.НомерВходящегоДокумента = Неопределено
			И ЗначениеЗаполнено(СтрокаОстатков.Номер)
			И ЗначениеЗаполнено(СтрокаОстатков.Дата) Тогда
			
			ДатаДокументаОстатки = ФорматДата(СтрокаОстатков.Дата);
			Если ПредставлениеВида = "Продажа" И ТипЗнч(СтрокаОстатков.ДокументРасчетов) <> Тип("ДокументСсылка.ОперацияБух") Тогда
				СтрокаОстатков.Представление = СтрШаблон("%1 (%2 от %3)",
					ПредставлениеВида,
					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СтрокаОстатков.Номер, Истина, Ложь), 
					ДатаДокументаОстатки);
			Иначе
				СтрокаОстатков.Представление = СтрШаблон("%1 (%2)", 
					ПредставлениеВида,
					ДатаДокументаОстатки);
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(СтрокаОстатков.НомерВходящегоДокумента) Тогда
				НомерВходящегоДокумента = СтрокаОстатков.НомерВходящегоДокумента;
			Иначе
				НомерВходящегоДокумента = "_______";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаОстатков.ДатаВходящегоДокумента) Тогда
				ДатаВходящегоДокумента = ФорматДата(СтрокаОстатков.ДатаВходящегоДокумента);
			Иначе
				ДатаВходящегоДокумента = "'  .  .    '";
			КонецЕсли;
			
			СтрокаОстатков.Представление = СтрШаблон("%1 (%2 от %3)",
				ПредставлениеВида,
				НомерВходящегоДокумента,
				ДатаВходящегоДокумента);
		КонецЕсли;
		
	КонецЦикла;
	
	// В ТаблицаРезультата должны остаться только те же колонки, которые есть в документе в табличной части Задолженность:
	// Сделка, Представление, Просрочка и Задолженность. Колонка Сумма будет рассчитана при загрузке в табличную часть.
	КолонкиРезультата = ТаблицаРезультата.Колонки;
	КоличествоКолонок = КолонкиРезультата.Количество();
	Для Инд = 1 По КоличествоКолонок Цикл
		ИмяКолонки = КолонкиРезультата[КоличествоКолонок - Инд].Имя;
		Если ИмяКолонки <> "Сделка" И ИмяКолонки <> "Просрочка"
			И ИмяКолонки <> "Задолженность" И ИмяКолонки <> "Представление" Тогда
			КолонкиРезультата.Удалить(КоличествоКолонок - Инд);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураДанныхЗаполнения.Вставить("ТаблицаРезультата", ТаблицаРезультата);
	
	ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, АдресХранилища);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеДокумента

Функция ТекстЗапросаБезДокументов()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Счет,
	|	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	|	ХозрасчетныйОстатки.Субконто2 КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК Сделка,
	|	ХозрасчетныйОстатки.СуммаОстатокДт КАК СуммаОстаток,
	|	ХозрасчетныйОстатки.ВалютнаяСуммаОстатокДт КАК ВалютнаяСуммаОстаток,
	|	НЕОПРЕДЕЛЕНО КАК НомерВходящегоДокумента,
	|	НЕОПРЕДЕЛЕНО КАК ДатаВходящегоДокумента,
	|	НЕОПРЕДЕЛЕНО КАК Номер,
	|	НЕОПРЕДЕЛЕНО КАК Дата,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора КАК ВидДоговора,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).РасчетыВУсловныхЕдиницах КАК РасчетыВУсловныхЕдиницах,
	|	0 КАК Просрочка
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В (&СчетаРасчетовБезАналитикиПоДокументам),
	|			&ВидыСубконтоБезДокументов,
	|			Организация = &Организация
	|				И &Условие_ВалютаОстатков
	|				И Субконто1 = &Контрагент
	|				И Субконто2 = &Договор) КАК ХозрасчетныйОстатки
	|ГДЕ
	|	&Условие_ВалютаДоговора";
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаПоДокументам()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Счет КАК Счет,
	|	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
	|	ХозрасчетныйОстатки.Субконто3 КАК Сделка,
	|	ХозрасчетныйОстатки.СуммаОстатокДт КАК СуммаОстаток,
	|	ХозрасчетныйОстатки.ВалютнаяСуммаОстатокДт КАК ВалютнаяСуммаОстаток
	|ПОМЕСТИТЬ ОстаткиПоДокументам
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В (&СчетаРасчетовСАналитикойПоДокументам),
	|			&ВидыСубконтоСДокументами,
	|			Организация = &Организация
	|				И &Условие_ВалютаОстатков
	|				И Субконто1 = &Контрагент
	|				И Субконто2 = &Договор
	|				И ТИПЗНАЧЕНИЯ(Субконто3) В (&ТипыДокументовРасчетов)) КАК ХозрасчетныйОстатки
	|ГДЕ
	|	&Условие_ВалютаДоговора
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сделка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиПоДокументам.Счет КАК Счет,
	|	ОстаткиПоДокументам.Контрагент КАК Контрагент,
	|	ОстаткиПоДокументам.Договор КАК Договор,
	|	ОстаткиПоДокументам.Сделка КАК Сделка,
	|	ОстаткиПоДокументам.СуммаОстаток КАК СуммаОстаток,
	|	ОстаткиПоДокументам.ВалютнаяСуммаОстаток КАК ВалютнаяСуммаОстаток,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.Номер, НЕОПРЕДЕЛЕНО) КАК НомерВходящегоДокумента,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.Дата, НЕОПРЕДЕЛЕНО) КАК ДатаВходящегоДокумента,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.НомерРегистратора, НЕОПРЕДЕЛЕНО) КАК Номер,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.ДатаРегистратора, НЕОПРЕДЕЛЕНО) КАК Дата,
	|	ОстаткиПоДокументам.Договор.ВидДоговора КАК ВидДоговора,
	|	ОстаткиПоДокументам.Договор.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ОстаткиПоДокументам.Договор.РасчетыВУсловныхЕдиницах КАК РасчетыВУсловныхЕдиницах,
	|	ВЫБОР
	|		КОГДА НЕ СрокиОплатыДокументов.СрокОплаты ЕСТЬ NULL
	|			ТОГДА РАЗНОСТЬДАТ(СрокиОплатыДокументов.СрокОплаты, &Период, ДЕНЬ)
	|		ИНАЧЕ РАЗНОСТЬДАТ(ЕСТЬNULL(ДанныеПервичныхДокументов.Дата, &Период), &Период, ДЕНЬ) - ЕСТЬNULL(ДоговорыКонтрагентов.СрокОплаты, СрокОплатыПокупателей.Значение)
	|	КОНЕЦ КАК Просрочка
	|ИЗ
	|	ОстаткиПоДокументам КАК ОстаткиПоДокументам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО (ДанныеПервичныхДокументов.Организация = &Организация)
	|			И ОстаткиПоДокументам.Сделка = ДанныеПервичныхДокументов.Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО ОстаткиПоДокументам.Договор = ДоговорыКонтрагентов.Ссылка
	|			И (ДоговорыКонтрагентов.УстановленСрокОплаты)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиОплатыДокументов КАК СрокиОплатыДокументов
	|		ПО ОстаткиПоДокументам.Сделка = СрокиОплатыДокументов.Документ
	|			И (СрокиОплатыДокументов.Организация = &Организация),
	|	Константа.СрокОплатыПокупателей КАК СрокОплатыПокупателей
	|ГДЕ
	|	ВЫБОР
	|			КОГДА НЕ СрокиОплатыДокументов.СрокОплаты ЕСТЬ NULL
	|				ТОГДА РАЗНОСТЬДАТ(СрокиОплатыДокументов.СрокОплаты, &Период, ДЕНЬ)
	|			ИНАЧЕ РАЗНОСТЬДАТ(ЕСТЬNULL(ДанныеПервичныхДокументов.Дата, &Период), &Период, ДЕНЬ) - ЕСТЬNULL(ДоговорыКонтрагентов.СрокОплаты, СрокОплатыПокупателей.Значение)
	|		КОНЕЦ > 0";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВидДокументаОстатка(СтрокаОстатков)

	Если БухгалтерскийУчетПовтИсп.СчетВИерархии(СтрокаОстатков.Счет, ПланыСчетов.Хозрасчетный.РасчетыПоПретензиям) 
		ИЛИ БухгалтерскийУчетПовтИсп.СчетВИерархии(СтрокаОстатков.Счет, ПланыСчетов.Хозрасчетный.РасчетыПоПретензиямВал) 
		ИЛИ БухгалтерскийУчетПовтИсп.СчетВИерархии(СтрокаОстатков.Счет, ПланыСчетов.Хозрасчетный.РасчетыПоПретензиямУЕ) Тогда
		ПредставлениеВида = НСтр("ru='Претензия'");
	ИначеЕсли ТипЗнч(СтрокаОстатков.Сделка) = Тип("ДокументСсылка.КорректировкаПоступления") Тогда
		ПредставлениеВида = НСтр("ru = 'Корректировка прихода'");
	ИначеЕсли ТипЗнч(СтрокаОстатков.Сделка) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		ПредставлениеВида = НСтр("ru = 'Корректировка продажи'");
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СтрокаОстатков.Счет, ПланыСчетов.Хозрасчетный.РасчетыСРазнымиДебиторамиИКредиторами) Тогда
		ПредставлениеВида = НСтр("ru = 'Прочие расчеты'");
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СтрокаОстатков.Счет, ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками)
		И ТипЗнч(СтрокаОстатков.Сделка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		ПредставлениеВида = НСтр("ru = 'Продажа'");
	ИначеЕсли ЗначениеЗаполнено(СтрокаОстатков.Сделка) Тогда
		ПредставлениеВида = СтрокаОстатков.Сделка.Метаданные().Синоним;
	Иначе
		ПредставлениеВида = "";
	КонецЕсли;
	
	Возврат ПредставлениеВида;
КонецФункции

Функция ФорматДата(Дата)
	Возврат Формат(Дата, "ДФ=dd.MM.yyyy");
КонецФункции

Функция ПроверитьОтложенныеРасчеты(СтруктураПараметров)

	УстановитьПривилегированныйРежим(Истина);

	ПараметрыРасчета = УчетВзаиморасчетовОтложенноеПроведение.НовыеПараметрыРасчета();
	ПараметрыРасчета.Организация             = СтруктураПараметров.Организация;
	ПараметрыРасчета.ДатаОкончания           = СтруктураПараметров.Дата;
	ПараметрыРасчета.Контрагент              = СтруктураПараметров.Контрагент;
	ПараметрыРасчета.ДоговорКонтрагента      = СтруктураПараметров.ДоговорКонтрагента;
	ПараметрыРасчета.АдресХранилищаСОшибками = СтруктураПараметров.АдресХранилищаСОшибками;
	
	Результат = УчетВзаиморасчетовОтложенноеПроведение.ВыполнитьОтложенныеРасчеты(ПараметрыРасчета);
	
	Возврат Результат.КоличествоДоговоровСОшибками = 0;

КонецФункции

#КонецОбласти

#Область ПроцедурыФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СправкаРасчет";
	КомандаПечати.Представление = НСтр("ru = 'Расчет пеней'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок       = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Начисление пеней""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

// Заполняет список команд отправки по электронной почте.
// 
// Параметры:
//   КомандыОтправки - ТаблицаЗначений - состав полей см. в функции ОтправкаПочтовыхСообщений.КомандыОтправки
//
Процедура ДобавитьКомандыОтправки(КомандыОтправки) Экспорт
	
	КомандаОтправки = КомандыОтправки.Добавить();
	КомандаОтправки.Идентификатор               = "СправкаРасчет";
	КомандаОтправки.Представление               = НСтр("ru='Расчет пеней'");
	КомандаОтправки.Порядок                     = 10;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СправкаРасчет") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СправкаРасчет", "Расчет пеней",
			ПечатьСправкаРасчет(МассивОбъектов, ОбъектыПечати),, "Документ.НачислениеПеней.ПФ_MXL_РасчетПени");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
КонецПроцедуры

Функция ПечатьСправкаРасчет(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб         = Истина;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасчетПени_СправкаРасчет";
	
	ДанныеШапки = Новый Структура;
	ДанныеПодвал = Новый Структура;
	ДанныеСтроки = Новый Структура;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.НачислениеПеней.ПФ_MXL_РасчетПени");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеПеней.Ссылка,
	|	НачислениеПеней.Организация,
	|	НачислениеПеней.Контрагент,
	|	ПРЕДСТАВЛЕНИЕ(НачислениеПеней.ДоговорКонтрагента) КАК Основание,
	|	НачислениеПеней.СтавкаПени,
	|	ПРЕДСТАВЛЕНИЕ(НачислениеПеней.ПериодРасчета) КАК ПериодРасчета,
	|	НачислениеПеней.Дата,
	|	НачислениеПеней.ПодразделениеОрганизации,
	|	СУММА(ЕСТЬNULL(НачислениеПенейЗадолженность.Сумма, 0)) КАК СуммаПени,
	|	СУММА(ЕСТЬNULL(НачислениеПенейЗадолженность.Задолженность, 0)) КАК Задолженность,
	|	НачислениеПеней.ВалютаДокумента
	|ИЗ
	|	Документ.НачислениеПеней КАК НачислениеПеней
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеПеней.Задолженность КАК НачислениеПенейЗадолженность
	|		ПО (НачислениеПенейЗадолженность.Ссылка = НачислениеПеней.Ссылка)
	|ГДЕ
	|	НачислениеПеней.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	НачислениеПеней.Ссылка,
	|	НачислениеПеней.Организация,
	|	НачислениеПеней.Контрагент,
	|	НачислениеПеней.СтавкаПени,
	|	Представление(НачислениеПеней.ПериодРасчета),
	|	НачислениеПеней.Дата,
	|	НачислениеПеней.ПодразделениеОрганизации,
	|	НачислениеПеней.ВалютаДокумента,
	|	ПРЕДСТАВЛЕНИЕ(НачислениеПеней.ДоговорКонтрагента)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачислениеПеней.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеПенейЗадолженность.Ссылка,
	|	НачислениеПенейЗадолженность.Сделка КАК ДокументРасчетов,
	|	НачислениеПенейЗадолженность.Задолженность,
	|	НачислениеПенейЗадолженность.Просрочка,
	|	НачислениеПенейЗадолженность.Сумма КАК СуммаПени,
	|	НачислениеПенейЗадолженность.Представление
	|ИЗ
	|	Документ.НачислениеПеней.Задолженность КАК НачислениеПенейЗадолженность
	|ГДЕ
	|	НачислениеПенейЗадолженность.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаДокументов = Результат[0].Выгрузить();
	ТаблицаРасчетПени = Результат[1].Выгрузить();
	
	ТаблицаРасчетПени.Индексы.Добавить("Ссылка");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьИтогоПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
	
	ЭтоПерваяСтраница = Истина;
	
	Для каждого СведенияОДокументе Из ТаблицаДокументов Цикл
	
		Если НЕ ЭтоПерваяСтраница Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ЭтоПерваяСтраница = Ложь;
		
		СведенияОбОрганизации    = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(СведенияОДокументе.Организация, СведенияОДокументе.Дата);
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Расчет пеней на %1'"), 
			Формат(СведенияОДокументе.Дата, "ДЛФ=DD"));
			
		ДанныеШапки.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеШапки.Вставить("ПредставлениеОрганизации", ПредставлениеОрганизации);
		
		СведенияОКонтрагенте    = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(СведенияОДокументе.Контрагент, СведенияОДокументе.Дата);
		ПредставлениеКонтрагента = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагенте, "НаименованиеДляПечатныхФорм,");
		
		СтавкаПениПредставление = СтрШаблон(
			НСтр("ru='%1 %% в %2'"), 
			СведенияОДокументе.СтавкаПени, 
			НРег(СведенияОДокументе.ПериодРасчета));
		
		ДанныеШапки.Вставить("Контрагент",               СведенияОДокументе.Контрагент);
		ДанныеШапки.Вставить("ПредставлениеКонтрагента", ПредставлениеКонтрагента);
		ДанныеШапки.Вставить("Основание",                СведенияОДокументе.Основание);
		ДанныеШапки.Вставить("СтавкаПени",               СтавкаПениПредставление);
		
		ОбластьШапка.Параметры.Заполнить(ДанныеШапки);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
		
		ТаблицаРасчетПениПоДокументу = ТаблицаРасчетПени.НайтиСтроки(Новый Структура("Ссылка", СведенияОДокументе.Ссылка));
		
		НомерСтроки = 1;
		КоличествоСтрок = ТаблицаРасчетПениПоДокументу.Количество();
		
		Для каждого СтрокаРасчета Из ТаблицаРасчетПениПоДокументу Цикл
			
			ДанныеСтроки.Вставить("НомерСтроки", НомерСтроки);
			ДанныеСтроки.Вставить("Задолженность", ОбщегоНазначенияБПВызовСервера.ФорматСумм(СтрокаРасчета.Задолженность));
			ДанныеСтроки.Вставить("Просрочка",           Формат(СтрокаРасчета.Просрочка, "ЧДЦ="));
			ДанныеСтроки.Вставить("СуммаПени",           ОбщегоНазначенияБПВызовСервера.ФорматСумм(СтрокаРасчета.СуммаПени));
			Если ЗначениеЗаполнено(СтрокаРасчета.Представление) Тогда
				ДанныеСтроки.Вставить("ДокументРасчетов", СтрокаРасчета.Представление);
			Иначе
				ДанныеСтроки.Вставить("ДокументРасчетов", ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(СтрокаРасчета.ДокументРасчетов));
			КонецЕсли; 
			
			ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
			
			СтрокаСПодвалом = Новый Массив;
			СтрокаСПодвалом.Добавить(ОбластьСтрока);
			СтрокаСПодвалом.Добавить(ОбластьИтогоПоСтранице);
			Если НомерСтроки = КоличествоСтрок Тогда
				СтрокаСПодвалом.Добавить(ОбластьПодвал);
			КонецЕсли; 
			
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, СтрокаСПодвалом) Тогда
				ТабличныйДокумент.Вывести(ОбластьИтогоПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
			НомерСтроки = НомерСтроки + 1;
		
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьИтогоПоСтранице);
		
		ДанныеПодвал.Вставить("ПредставлениеОрганизации", ПредставлениеОрганизации);
		ДанныеПодвал.Вставить("ПредставлениеКонтрагента", ПредставлениеКонтрагента);
		ДанныеПодвал.Вставить("ИтогоПени", ОбщегоНазначенияБПВызовСервера.ФорматСумм(СведенияОДокументе.СуммаПени));
		ДанныеПодвал.Вставить("СуммаПрописью", 
			РаботаСКурсамиВалют.СформироватьСуммуПрописью(СведенияОДокументе.СуммаПени, СведенияОДокументе.ВалютаДокумента));
		
		ОбластьПодвал.Параметры.Заполнить(ДанныеПодвал);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, СведенияОДокументе.Ссылка);
	
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ПодготовкаПараметровПроведения

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ВалютаРеглУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Запрос.УстановитьПараметр("СтатьяПрочиеДоходыИРасходы", Справочники.ПрочиеДоходыИРасходы.ПредопределенныйЭлемент("ШтрафыПениНеустойки"));

	НомераТаблиц = Новый Структура;

	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);

	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);

	Если Реквизиты.РасчетыВВалюте Тогда
		ПодготовитьТаблицыДокументаРасчетыВВалюте(Запрос, Реквизиты);
	Иначе
		Запрос.Текст = ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц);
		Результат    = Запрос.ВыполнитьПакет();
	КонецЕсли;
	Запрос.УстановитьПараметр("РасчетыВВалюте", 		Реквизиты.РасчетыВВалюте);
	Запрос.УстановитьПараметр("ПустоеПодразделение",	БухгалтерскийУчетПереопределяемый.ПустоеПодразделение());
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаНачислениеПени(НомераТаблиц)
		+ ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты);
		
	Результат = Запрос.ВыполнитьПакет();
	
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Для Каждого НомерТаблицы Из НомераТаблиц Цикл
			ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПараметрыПроведения;
КонецФункции 

Функция ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
	НомераТаблиц.Вставить("ВременнаяТаблицаЗадолженность", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НачислениеПенейЗадолженность.Сумма КАК СуммаВзаиморасчетов,
	|	НачислениеПенейЗадолженность.Сумма КАК СуммаРуб
	|ПОМЕСТИТЬ ТаблицаЗадолженность
	|ИЗ
	|	Документ.НачислениеПеней.Задолженность КАК НачислениеПенейЗадолженность
	|ГДЕ
	|	НачислениеПенейЗадолженность.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
КонецФункции 

Функция ТекстЗапросаВременныеТаблицыДокументаРасчетыВВалюте(НомераТаблиц, Реквизиты);

	ТекстЗапроса = ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ТаблицаЗадолженность", "ПОМЕСТИТЬ ВременнаяТаблицаЗадолженность");
	
	НомераТаблиц.Вставить("СуммыТаблицыЗадолженность", НомераТаблиц.Количество());
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ВременнаяТаблицаЗадолженность.СуммаВзаиморасчетов,
	|	ВременнаяТаблицаЗадолженность.СуммаРуб
	|ИЗ
	|	ВременнаяТаблицаЗадолженность КАК ВременнаяТаблицаЗадолженность"
	+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаРасчетыВВалютеЗадолженность()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СуммыТаблицыЗадолженность.СуммаВзаиморасчетов,
	|	СуммыТаблицыЗадолженность.СуммаРуб
	|ПОМЕСТИТЬ ТаблицаЗадолженность
	|ИЗ
	|	&СуммыТаблицыЗадолженность КАК СуммыТаблицыЗадолженность";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
КонецФункции

Процедура ПодготовитьТаблицыДокументаРасчетыВВалюте(Запрос, Реквизиты)
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаВременныеТаблицыДокументаРасчетыВВалюте(НомераТаблиц, Реквизиты);
	Результат    = Запрос.ВыполнитьПакет();
	
	СуммыТаблицыЗадолженность = Результат[НомераТаблиц["СуммыТаблицыЗадолженность"]].Выгрузить();
	УчетВзаиморасчетов.ПодготовитьТаблицуДокументаРасчетыВВалюте(СуммыТаблицыЗадолженность, Реквизиты);
	Запрос.УстановитьПараметр("СуммыТаблицыЗадолженность", СуммыТаблицыЗадолженность);
	Запрос.Текст = ТекстЗапросаРасчетыВВалютеЗадолженность();
	
	Результат = Запрос.ВыполнитьПакет();
КонецПроцедуры

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НачислениеПеней.Ссылка КАК Регистратор,
	|	НачислениеПеней.Дата КАК Период,
	|	НачислениеПеней.Организация,
	|	НачислениеПеней.Контрагент,
	|	НачислениеПеней.ДоговорКонтрагента,
	|	НачислениеПеней.ПодразделениеОрганизации,
	|	НачислениеПеней.ВалютаДокумента,
	|	НачислениеПеней.КурсВзаиморасчетов,
	|	НачислениеПеней.КратностьВзаиморасчетов,
	|	НачислениеПеней.СчетУчетаРасчетовСКонтрагентом КАК СчетРасчетов,
	|	&ВалютаРеглУчета КАК ВалютаРеглУчета,
	|	&СтатьяПрочиеДоходыИРасходы КАК СтатьяПрочиеДоходыИРасходы,
	|	ЕСТЬNULL(ДоговорыКонтрагентов.ВалютаВзаиморасчетов, &ВалютаРеглУчета) КАК ВалютаВзаиморасчетов
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.НачислениеПеней КАК НачислениеПеней
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО НачислениеПеней.ДоговорКонтрагента = ДоговорыКонтрагентов.Ссылка
	|ГДЕ
	|	НачислениеПеней.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Регистратор,
	|	Реквизиты.Период,
	|	Реквизиты.Организация,
	|	Реквизиты.Контрагент,
	|	Реквизиты.ДоговорКонтрагента,
	|	Реквизиты.ПодразделениеОрганизации,
	|	Реквизиты.ВалютаДокумента,
	|	Реквизиты.КурсВзаиморасчетов,
	|	Реквизиты.КратностьВзаиморасчетов,
	|	Реквизиты.СчетРасчетов,
	|	Реквизиты.ВалютаРеглУчета,
	|	Реквизиты.СтатьяПрочиеДоходыИРасходы,
	|	Реквизиты.ВалютаВзаиморасчетов,
	|	Реквизиты.ВалютаВзаиморасчетов <> Реквизиты.ВалютаРеглУчета КАК РасчетыВВалюте
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаНачислениеПени(НомераТаблиц)
	
	НомераТаблиц.Вставить("НачислениеПени", НомераТаблиц.Количество());
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СУММА(ТаблицаЗадолженность.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
	|	СУММА(ТаблицаЗадолженность.СуммаРуб) КАК СуммаРуб
	|ИЗ
	|	ТаблицаЗадолженность КАК ТаблицаЗадолженность";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
КонецФункции

#КонецОбласти

#Область ОтложенноеПроведение

Функция ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	Если НЕ ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Реквизиты.Организация, Реквизиты.Период) Тогда
		ПараметрыПроведения.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", Неопределено);
		Возврат "";
	КонецЕсли;

	НомераТаблиц.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Реквизиты.ДоговорКонтрагента.ВидДоговора КАК ВидДоговора,
	|	Реквизиты.Период КАК Дата
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#Область ФормированиеДвижений

Функция ПодготовитьПараметрыНачислениеПени(ТаблицаРасчетПени, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы шапки документа.
	СписокОбязательныхКолонок = ""
	+ "Период,"         	// <Дата> - дата докумета, записывающего движения
	+ "Регистратор,"    	// <Регистратор> - документ, записывающий движения в регистры
	+ "Организация,"		// <СправочникСсылка.Организации> - организация документа
	+ "Контрагент,"			// <СправочникСсылка.Контрагенты> - контрагент которому начисляются пени
	+ "ДоговорКонтрагента," // // <СправочникСсылка.Договора> - договор контрагента по кооторму начисляются пени
	+ "ПодразделениеОрганизации," // <Ссылка на справочник подразделений>
	+ "СчетРасчетов,"		// <ПланСчетов.Хозрасчетный> - счет расчетов по пени
	+ "ВалютаВзаиморасчетов,"		// <СправочникСсылки.Валюты> - валюта расчетов по договору
	+ "СтатьяПрочиеДоходыИРасходы" // <СправочникСсылка.ПрочиеДоходыРасходы> - статья доходов/расходов для расчета пеней
	;
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты,
																		СписокОбязательныхКолонок));

	// Подготовка таблицы товаров документа, по которым проводится переоценка.
	СписокОбязательныхКолонок = ""
	+ "СуммаВзаиморасчетов,"	// 	<Число(15,2)> - сумма начисленных пени в валюте расчетов
	+ "СуммаРуб"	// 	<Число(15,2)> - сумма начисленных пени в валюте регламентированного учета
	;
	Параметры.Вставить("ТаблицаРасчетПени", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРасчетПени,
																		СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

Процедура СформироватьДвиженияНачислениеПени(ТаблицаРасчетПени, ТаблицаРеквизиты, Движения, Отказ) Экспорт
	
	Параметры = ПодготовитьПараметрыНачислениеПени(ТаблицаРасчетПени, ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Параметры.Реквизиты[0]);
	
	Для каждого СтрокаТаблицы Из Параметры.ТаблицаРасчетПени Цикл

		Проводка = Движения.Хозрасчетный.Добавить();
		
		Проводка.Период       = Реквизиты.Период;
		Проводка.Организация  = Реквизиты.Организация;
		Проводка.Содержание   = НСтр("ru = 'Начисление пеней'");
		
		Проводка.СчетДт = Реквизиты.СчетРасчетов;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Реквизиты.Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Договоры", Реквизиты.ДоговорКонтрагента);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ДокументыРасчетовСКонтрагентами", Реквизиты.Регистратор);
		
		СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
		Если СвойстваСчетаДт.Валютный Тогда
			Проводка.ВалютаДт        = Реквизиты.ВалютаВзаиморасчетов;
			Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.СуммаВзаиморасчетов;
		КонецЕсли;
		
		Если СвойстваСчетаДт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеДт = Реквизиты.ПодразделениеОрганизации;
		КонецЕсли;
		
		Проводка.СчетКт = ПланыСчетов.Хозрасчетный.ПрочиеДоходы;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ПрочиеДоходыИРасходы", Реквизиты.СтатьяПрочиеДоходыИРасходы);
		
		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
		Если СвойстваСчетаКт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеКт = Реквизиты.ПодразделениеОрганизации;
		КонецЕсли;
		
		Проводка.Сумма = СтрокаТаблицы.СуммаРуб;
		
	КонецЦикла;
	
	Движения.Хозрасчетный.Записывать = Истина;
КонецПроцедуры

Функция ПодготовитьПараметрыДвиженияНДС(ТаблицаРасчетПени, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы шапки документа.
	СписокОбязательныхКолонок = ""
	+ "Период,"         	// <Дата> - дата докумета, записывающего движения
	+ "Регистратор,"    	// <Регистратор> - документ, записывающий движения в регистры
	+ "Организация,"		// <СправочникСсылка.Организации> - организация документа
	+ "Контрагент,"			// <СправочникСсылка.Контрагенты> - контрагент которому начисляются пени
	+ "ДоговорКонтрагента" // // <СправочникСсылка.Договора> - договор контрагента по кооторму начисляются пени
	;
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты,
																		СписокОбязательныхКолонок));

	// Подготовка таблицы товаров документа, по которым проводится переоценка.
	СписокОбязательныхКолонок = ""
	+ "СуммаРуб"	// 	<Число(15,2)> - сумма начисленных пени в валюте регламентированного учета
	;
	Параметры.Вставить("ТаблицаРасчетПени", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРасчетПени,
																		СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

Процедура СформироватьДвиженияНДСЗаписиКнигиПродаж(ТаблицаРасчетПени, ТаблицаРеквизиты, Движения, Отказ) Экспорт 
	
	Реквизиты = ТаблицаРеквизиты[0];
	Если Не УчетнаяПолитика.ПлательщикНДС(Реквизиты.Организация, Реквизиты.Период) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыДвиженияНДС(ТаблицаРасчетПени, ТаблицаРеквизиты);
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Параметры.Реквизиты[0]);
	
	Для каждого СтрокаТаблицы Из ТаблицаРасчетПени Цикл
		Движение = Движения.НДСЗаписиКнигиПродаж.Добавить();
		
		ЗаполнитьЗначенияСвойств(Движение, Реквизиты);
		
		Движение.Покупатель    = Реквизиты.Контрагент;

		Движение.СчетФактура    = Реквизиты.Регистратор;
		Движение.СтавкаНДС      = Перечисления.СтавкиНДС.БезНДС;

		Движение.ДатаОплаты     = Реквизиты.Период;
		Движение.ДатаСобытия    = Реквизиты.Период;

		Движение.ВидЦенности    = Перечисления.ВидыЦенностей.ПрочиеРаботыИУслуги;
		Движение.Событие        = Перечисления.СобытияПоНДСПродажи.Реализация;
		
		Движение.СуммаБезНДС    = СтрокаТаблицы.СуммаРуб;
	КонецЦикла;

	Движения.НДСЗаписиКнигиПродаж.Записывать = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли