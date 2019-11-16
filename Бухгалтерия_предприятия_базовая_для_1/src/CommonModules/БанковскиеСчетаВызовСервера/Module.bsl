
////////////////////////////////////////////////////////////////////////////////
// Получение, обработка и проверка реквизитов банковских счета с сервера
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс 

// Возвращает структуру реквизитов банка из справочника Банки.
//
// Параметры:
//  СсылкаНаБанк - СправочникСсылка.Банки - ссылка на банк, для которого требуется получить реквизиты.
// 
// Возвращаемое значение:
//  Структура - см. описание возвращаемого значения в функции НоваяСтруктураРеквизитовБанка()
//
Функция ПолучитьРеквизитыБанкаИзСправочника(СсылкаНаБанк) Экспорт
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаБанк,"Код,СВИФТБИК,Наименование,РучноеИзменение,Страна");
	
	РеквизитыБанка = НоваяСтруктураРеквизитовБанка();
	РеквизитыБанка.Ссылка = СсылкаНаБанк;
	РеквизитыБанка.Код = ЗначенияРеквизитов.Код;
	РеквизитыБанка.СВИФТБИК = ЗначенияРеквизитов.СВИФТБИК;
	РеквизитыБанка.Наименование = ЗначенияРеквизитов.Наименование;
	РеквизитыБанка.ДеятельностьПрекращена = ДеятельностьБанкаПрекращена(ЗначенияРеквизитов.РучноеИзменение);
	РеквизитыБанка.ЯвляетсяБанкомРФ = (ЗначенияРеквизитов.Страна = Справочники.СтраныМира.Россия);
	
	Возврат РеквизитыБанка;
	
КонецФункции

// Возвращает структуру реквизитов банка из справочника Классификатор банков РФ.
//
// Параметры:
//  СсылкаНаБанк - СправочникСсылка.КлассификаторБанков - ссылка на банк, для которого требуется получить реквизиты.
// 
// Возвращаемое значение:
//  Структура - см. описание возвращаемого значения в функции НоваяСтруктураРеквизитовБанка().
//
Функция ПолучитьРеквизитыБанкаИзКлассификатора(СсылкаНаБанк) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	БанкиИзКлассификатора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СсылкаНаБанк);
	БанкиИзСправочника = РаботаСБанкамиБП.ПодобратьБанкИзКлассификатора(БанкиИзКлассификатора);
	
	РеквизитыБанковИзСправочника =
		ОбщегоНазначения.ЗначенияРеквизитовОбъектов(БанкиИзСправочника, "Код,Наименование,ЭтоГруппа,РучноеИзменение");
	
	БИКБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаБанк,"Код");
	
	Для каждого ЭлементБанка Из РеквизитыБанковИзСправочника Цикл
		
		Если ЭлементБанка.Значение.Код = БИКБанка И Не ЭлементБанка.Значение.ЭтоГруппа Тогда
			
			РеквизитыБанка = НоваяСтруктураРеквизитовБанка();
			РеквизитыБанка.Ссылка = ЭлементБанка.Ключ;
			РеквизитыБанка.Код = ЭлементБанка.Значение.Код;
			РеквизитыБанка.Наименование = ЭлементБанка.Значение.Наименование;
			РеквизитыБанка.ДеятельностьПрекращена = ДеятельностьБанкаПрекращена(ЭлементБанка.Значение.РучноеИзменение);
			РеквизитыБанка.ЯвляетсяБанкомРФ = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если РеквизитыБанка.Ссылка = Справочники.Банки.ПустаяСсылка() Тогда
		ВызватьИсключение НСтр("ru = 'Выбранный банк был изменен или удален из классификатора.
			|Проверьте его наличие в справочнике Классификатор банков РФ'");
	КонецЕсли;
	
	Возврат РеквизитыБанка;
	
КонецФункции

Функция ПроверитьКонтрольныйКлючВНомереБанковскогоСчета(НомерСчета, БИК) Экспорт
	
	Возврат БанковскиеПравила.ПроверитьКонтрольныйКлючВНомереБанковскогоСчета(НомерСчета, БИК)
	
КонецФункции

Процедура ВключитьВалютныйУчет() Экспорт
	
	Константы.ИспользоватьВалютныйУчет.Установить(Истина);
	
КонецПроцедуры

// Возвращает ссылку на валюту на основании данных справочника и классификатора валют.
//
// Параметры:
//  КодВалюты - Строка - код валюты по классифкатору валют.
// 
// Возвращаемое значение:
//  СправочникСсылка.Валюты - ссылка на валюту или пустая ссылка, если валюта не найдена.
//
Функция ПолучитьВалютуПоКоду(КодВалюты) Экспорт
	
	ВалютаСчета = Справочники.Валюты.НайтиПоКоду(КодВалюты);
	Если ЗначениеЗаполнено(ВалютаСчета) Тогда
		Возврат ВалютаСчета;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	КодыВалют = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КодВалюты);
	ВалютыПоКлассификатору = РаботаСКурсамиВалют.ДобавитьВалютыПоКоду(КодыВалют);
	
	Если ВалютыПоКлассификатору.Количество() > 0 Тогда
		ВалютаСчета = ВалютыПоКлассификатору[0];
	Иначе
		ВалютаСчета = Справочники.Валюты.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВалютаСчета;
	
КонецФункции

// Проверяет и включает функциональную опцию "ИспользуетсяНесколькоБанковскихСчетовОрганизации"
//
// Параметры:
//  Организация - СправочникСсылка.Организации
//
Процедура ПроверитьИспользованиеНесколькоБанковскихСчетов(Знач Организация) Экспорт
	
	Если Не Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация) Тогда
		Справочники.БанковскиеСчета.ВключитьИспользованиеНесколькоБанковскихСчетов(Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НоваяСтруктураРеквизитовБанка()
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Код", "");
	СтруктураРеквизитов.Вставить("СВИФТБИК", "");
	СтруктураРеквизитов.Вставить("Наименование", "");
	СтруктураРеквизитов.Вставить("Ссылка", Справочники.Банки.ПустаяСсылка());
	СтруктураРеквизитов.Вставить("ДеятельностьПрекращена", Ложь);
	СтруктураРеквизитов.Вставить("ЯвляетсяБанкомРФ", Ложь);

	Возврат СтруктураРеквизитов;
	
КонецФункции

// Возвращает признак недействующего банка по реквизиту банка РучноеИзменение.
//
// Параметры:
//  РучноеИзменение - Число - если 3, то деятельность прекращена.
// 
// Возвращаемое значение:
//  Булево -  признак недействующего банка.
//
Функция ДеятельностьБанкаПрекращена(РучноеИзменение)
	
	Возврат ?(РучноеИзменение = 3, Истина, Ложь);
	
КонецФункции

// Возвращает структуру со сведениями о валютном учете. 
// 
// Возвращаемое значение:
//  Структура - содержит следующие свойства:
//   *УчетПоДоговорамИспользуется      - Булево - признак использования функциональности учет по договорам. От этой функциональности зависит "Валютный учет".
//   *ВалютныйУчетИспользуется         - Булево - признак использования функциональности валютного учета.
//   *ИзменениеВалютногоУчетаРазрешено - Булево - признак наличия прав на изменение функциональности валютного учета.
//
Функция СведенияОВалютномУчете() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВалютныйУчетИспользуется",         БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет());
	Результат.Вставить("ИзменениеВалютногоУчетаРазрешено", ПравоДоступа("Редактирование", Метаданные.Константы.ИспользоватьВалютныйУчет)); // См. ВключитьВалютныйУчет()
	
	Возврат Результат;
	
КонецФункции

// Возвращает список выбора с банками по реквизитам поиска: код, SWIFT или наименование.
//
// Параметры:
//  Параметры - Структура - см. описание параметра обработчика Автоподбор
// 
// Возвращаемое значение:
//  СписокЗначений - список с выбранными банками.
//
Функция ДанныеВыбораБанка(Параметры) Экспорт
	
	// Для числовой строки использует поиск по коду банка, в остальных случаях поиск идет по коду, SWIFT и наименованию банка.
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Параметры.СтрокаПоиска) Тогда
		
		СтрокаПоиска = Параметры.СтрокаПоиска + "%";
		
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка КАК Ссылка,
		|	Банки.Код КАК ПолеПоиска,
		|	Банки.Наименование КАК ПолеРасшифровки,
		|	0 КАК Сортировка,
		|	0 КАК Упорядочивание
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Код ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.Код,
		|	Банки.Наименование,
		|	0,
		|	1
		|ИЗ
		|	Справочник.КлассификаторБанков КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Код ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	Упорядочивание,
		|	ПолеПоиска";

	Иначе
		
		// Для повышения производительности в файловом режиме используем индексируемый поиск по началу строки.
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			СтрокаПоиска = Параметры.СтрокаПоиска + "%";
		Иначе
			СтрокаПоиска = "%" + Параметры.СтрокаПоиска + "%";
		КонецЕсли;
		
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка КАК Ссылка,
		|	Банки.Код КАК ПолеПоиска,
		|	Банки.Наименование КАК ПолеРасшифровки,
		|	0 КАК Сортировка
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Код ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.СВИФТБИК,
		|	Банки.Наименование,
		|	0
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.СВИФТБИК ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.Наименование,
		|	ВЫБОР
		|		КОГДА Банки.Страна = &СтранаРФ
		|			ТОГДА Банки.Код
		|		ИНАЧЕ Банки.СВИФТБИК
		|	КОНЕЦ,
		|	1
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Наименование ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Банки.Ссылка,
		|	Банки.Наименование,
		|	Банки.Код,
		|	2
		|ИЗ
		|	Справочник.КлассификаторБанков КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа = ЛОЖЬ
		|	И Банки.Наименование ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сортировка,
		|	ПолеПоиска";
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СтрокаПоиска",СтрокаПоиска);
	Запрос.УстановитьПараметр("СтранаРФ", Справочники.СтраныМира.Россия);
	
	Результат = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Результат.Пустой() Тогда
		Возврат ДанныеВыбора;
	КонецЕсли;
	
	МаксКоличествоВыбранных = 20;
	
	РезультатыОтбора = Новый Соответствие;
	РезультатыОтбора.Вставить("ПолеПоиска");
	
	ШрифтВыделения = Новый Шрифт(,,Истина);
	ЦветВыделения  = ЦветаСтиля.ЦветУспешногоПоиска;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если РезультатыОтбора.Количество() >= МаксКоличествоВыбранных Тогда
			Прервать;
		КонецЕсли;
		
		Если ТипЗнч(Выборка.Ссылка) <> Тип("СправочникСсылка.Банки")
			И РезультатыОтбора.Получить(Выборка.ПолеПоиска) <> Неопределено Тогда
			
			Продолжить;
		КонецЕсли;
		
		РезультатыОтбора.Вставить(Выборка.ПолеПоиска, Выборка.ПолеПоиска);
		
		// Для каждой строки результата формируем представление, аналогично платформенному.
		ПредставлениеСтроки = Новый Массив;
		ИсходнаяСтрока = СокрЛП(Выборка.ПолеПоиска);
		ВыделяемаяЧасть = Параметры.СтрокаПоиска;
		ПолеРасшифровки = СокрЛП(Выборка.ПолеРасшифровки);
		
		// Находим и выделяем цветом часть строки, которая была введена пользователем.
		Поз = СтрНайти(ВРег(ИсходнаяСтрока), ВРег(Параметры.СтрокаПоиска),, 1);
		ВыделяемаяПодстрока = Сред(ИсходнаяСтрока, Поз, СтрДлина(ВыделяемаяЧасть));
		ФорматВыделяемаяСтрока = Новый ФорматированнаяСтрока(ВыделяемаяПодстрока, ШрифтВыделения, ЦветВыделения);
		
		// Находим оставшуюся часть строки и формируем массив из введенной пользователем строки и оставшейся части.
		Если Поз = 1 Тогда
			// Часть введенной пользователем строки находится в начале, значит оставшуюся строку нужно искать с конца.
			ПредставлениеСтроки.Добавить(ФорматВыделяемаяСтрока);
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Прав(ИсходнаяСтрока, СтрДлина(ИсходнаяСтрока) - СтрДлина(ВыделяемаяЧасть))));
		ИначеЕсли Поз = СтрДлина(ИсходнаяСтрока) Тогда
			// Часть введенной пользователем строки находится в конце, значит оставшуюся строку  искать с начала.
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Лев(ИсходнаяСтрока, Поз-1)));
			ПредставлениеСтроки.Добавить(ФорматВыделяемаяСтрока);
		Иначе
			// Часть введенной пользователем строки находится в середине, значит оставшуюся строку нужно искать в начале и в конце.
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Лев(ИсходнаяСтрока, Поз-1)));
			ПредставлениеСтроки.Добавить(ФорматВыделяемаяСтрока);
			ПредставлениеСтроки.Добавить(Новый ФорматированнаяСтрока(Сред(ИсходнаяСтрока, Поз + СтрДлина(ВыделяемаяЧасть))));
		КонецЕсли;
		
		КодЯвляетсяРасшифровкой = ?(Выборка.Сортировка = 0, Истина, Ложь);
		
		Если КодЯвляетсяРасшифровкой Тогда
			ДанныеВыбора.Добавить(Выборка.Ссылка, Новый ФорматированнаяСтрока(ПредставлениеСтроки, " ", ПолеРасшифровки));
		Иначе
			ДанныеВыбора.Добавить(Выборка.Ссылка, Новый ФорматированнаяСтрока(ПолеРасшифровки, " ", ПредставлениеСтроки));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

Функция СтранаПоSWIFT(СВИФТБИК) Экспорт
	
	Возврат Справочники.Банки.СтранаПоSWIFT(СВИФТБИК);
	
КонецФункции

#КонецОбласти