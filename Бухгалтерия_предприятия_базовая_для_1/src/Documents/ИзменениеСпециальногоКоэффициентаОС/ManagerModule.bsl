#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();

	Результат = Запрос.Выполнить();
	Реквизиты = ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(Результат);

	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;

	НомераТаблиц = Новый Структура;

	Запрос.УстановитьПараметр("ПлательщикНалогаНаПрибыль", УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Реквизиты.Организация, Реквизиты.Период));

	Запрос.Текст =
		ТекстЗапросаТаблицаОС(НомераТаблиц)
		+ ТекстЗапросаНачислениеАмортизацииОССпециальныйКоэффициентНУ(НомераТаблиц)
		+ ТекстЗапросаПроверкиПоОС(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
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

Функция ТекстЗапросаРеквизитыДокумента()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Документ.ИзменениеСпециальногоКоэффициентаОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции // ТекстЗапросаРеквизитыДокумента()

Функция ТекстЗапросаТаблицаОС(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаОС", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ОсновныеСредства", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка                 КАК Регистратор,
	|	ТаблицаОС.НомерСтроки            КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство       КАК ОсновноеСредство,
	|	ТаблицаОС.СпециальныйКоэффициент КАК СпециальныйКоэффициент
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Документ.ИзменениеСпециальногоКоэффициентаОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.Регистратор      КАК Регистратор,
	|	ТаблицаОС.НомерСтроки      КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	ТаблицаОС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции // ТекстЗапросаТаблицыДокумента()

Функция ТекстЗапросаНачислениеАмортизацииОССпециальныйКоэффициентНУ(НомераТаблиц)

	НомераТаблиц.Вставить("НачислениеАмортизацииОССпециальныйКоэффициентНУ", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("НачислениеАмортизацииОССпециальныйКоэффициентНУТаблица", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка           КАК Регистратор,
	|	Реквизиты.Дата             КАК Период,
	|	Реквизиты.Номер            КАК Номер,
	|	Реквизиты.Организация      КАК Организация,
	|	&ПлательщикНалогаНаПрибыль КАК ПлательщикНалогаНаПрибыль
	|ИЗ
	|	Документ.ИзменениеСпециальногоКоэффициентаОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.Регистратор            КАК Регистратор,
	|	ТаблицаОС.НомерСтроки            КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство       КАК ОсновноеСредство,
	|	ТаблицаОС.СпециальныйКоэффициент КАК СпециальныйКоэффициент
	|ИЗ
	|	ТаблицаОС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПроверкиПоОС(НомераТаблиц)

	НомераТаблиц.Вставить("ПроверкиПоОС", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка      КАК Регистратор,
	|	Реквизиты.Дата        КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	""ОС""                КАК ИмяСписка
	|ИЗ
	|	Документ.ИзменениеСпециальногоКоэффициентаОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#КонецЕсли