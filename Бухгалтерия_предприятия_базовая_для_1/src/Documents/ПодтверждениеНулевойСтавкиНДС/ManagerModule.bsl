#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 22, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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

////////////////////////////////////////////////////////////////////////////////
// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();
	Результат    = Запрос.Выполнить();

	Реквизиты = ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(Результат);
 
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	
	ПараметрыПроведения.Вставить("ТаблицаРеквизиты", Результат.Выгрузить());
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаТаблицыДокумента(НомераТаблиц)
		+ ТекстЗапросаСтавкаПодтверждена(НомераТаблиц)
		+ ТекстЗапросаСтавкаНеПодтверждена(НомераТаблиц)
		+ ТекстЗапросаПоФормированиюРегламентнойОперации(НомераТаблиц);
					
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
		
КонецФункции

Функция ТекстЗапросаРеквизитыДокумента()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.СтатьяПрочихРасходов КАК СтатьяПрочихРасходов
	|ИЗ
	|	Документ.ПодтверждениеНулевойСтавкиНДС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаСостав", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Состав.НомерСтроки,
	|	ВЫБОР
	|		КОГДА Состав.ВидЦенности = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.Товары)
	|		ИНАЧЕ
	|			Состав.ВидЦенности
	|	КОНЕЦ КАК ВидЦенности,
	|	Состав.Покупатель,
	|	Состав.ДокументОтгрузки КАК СчетФактура,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.Дата, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаРеализации,
	|	Состав.Событие,
	|	Состав.Ссылка.Дата КАК ДатаСобытия,
	|	Состав.ПродажиСНДС0 КАК СуммаБезНДС,
	|	Состав.СтавкаНДС,
	|	Состав.СуммаНДС КАК НДС,
	|	Состав.КурсоваяРазница,
	|	Состав.СчетФактураВыданный
	|ПОМЕСТИТЬ ВременнаяТаблицаСостав
	|ИЗ
	|	Документ.ПодтверждениеНулевойСтавкиНДС.Состав КАК Состав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО Состав.ДокументОтгрузки = ДанныеПервичныхДокументов.Документ
	|ГДЕ
	|	Состав.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаСтавкаПодтверждена(НомераТаблиц)
	
	НомераТаблиц.Вставить("ТаблицаСтавкаПодтвержденаРеализация0",	НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаСтавкаПодтверждена",				НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ОжидаетсяПодтверждение) КАК Состояние,
	|	Состав.СчетФактура,
	|	Состав.ВидЦенности,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0) КАК СтавкаНДС,
	|	Состав.Покупатель,
	|	Состав.СуммаБезНДС КАК СуммаБезНДС,
	|	0 КАК НДС,
	|	Состав.КурсоваяРазница,
	|	Состав.ДатаСобытия,
	|	Состав.Событие
	|ИЗ
	|	ВременнаяТаблицаСостав КАК Состав
	|ГДЕ
	|	Состав.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПродажи.ПодтвержденаСтавка0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Состав.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Состав.СчетФактура,
	|	ЕСТЬNULL(РеквизитыДокументовРасчетов.ДатаРегистратора, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаРеализации,
	|	Состав.ВидЦенности,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0) КАК СтавкаНДС,
	|	Состав.Покупатель,
	|	ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0) КАК Состояние,
	|	ЗНАЧЕНИЕ(Перечисление.НДСВидНачисления.Реализация0) КАК ВидНачисления,
	|	Состав.СуммаБезНДС КАК СуммаБезНДС,
	|	Состав.КурсоваяРазница КАК КурсоваяРазница,
	|	0 КАК НДС,
	|	Состав.ДатаСобытия,
	|	Состав.Событие,
	|	""Подтвержден НДС 0% по реализации"" КАК Содержание
	|ИЗ
	|	ВременнаяТаблицаСостав КАК Состав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК РеквизитыДокументовРасчетов
	|		ПО (РеквизитыДокументовРасчетов.Организация = &Организация)
	|			И Состав.СчетФактура = РеквизитыДокументовРасчетов.Документ
	|ГДЕ
	|	Состав.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПродажи.ПодтвержденаСтавка0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Состав.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаСтавкаНеПодтверждена(НомераТаблиц)
	
	НомераТаблиц.Вставить("ТаблицаСтавкаНеПодтвержденаРеализация0",	НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаСтавкаНеПодтверждена",			НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ОжидаетсяПодтверждение) КАК Состояние,
	|	Состав.СчетФактура,
	|	Состав.ВидЦенности,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0) КАК СтавкаНДС,
	|	Состав.Покупатель,
	|	Состав.СуммаБезНДС КАК СуммаБезНДС,
	|	0 КАК НДС,
	|	Состав.КурсоваяРазница,
	|	Состав.ДатаСобытия,
	|	Состав.Событие
	|ИЗ
	|	ВременнаяТаблицаСостав КАК Состав
	|ГДЕ
	|	Состав.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПродажи.НеПодтвержденаСтавка0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Состав.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.НеПодтвержденаРеализация0) КАК Состояние,
	|	Состав.СчетФактура,
	|	Состав.ВидЦенности,
	|	Состав.СтавкаНДС,
	|	Состав.Покупатель,
	|	ЗНАЧЕНИЕ(Перечисление.НДСВидНачисления.Реализация0) КАК ВидНачисления,
	|	Состав.СуммаБезНДС,
	|	Состав.НДС,
	|	Состав.ДатаСобытия,
	|	Состав.Событие,
	|	""Не подтвержден НДС 0% по реализации"" КАК Содержание,
	|	ВЫБОР
	|		КОГДА КОНЕЦПЕРИОДА(Состав.ДатаРеализации, КВАРТАЛ) <> КОНЕЦПЕРИОДА(&Период, КВАРТАЛ)
	|			ТОГДА НАЧАЛОПЕРИОДА(Состав.ДатаРеализации, КВАРТАЛ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК КорректируемыйПериод,
	|	ВЫБОР
	|		КОГДА КОНЕЦПЕРИОДА(Состав.ДатаРеализации, КВАРТАЛ) <> КОНЕЦПЕРИОДА(&Период, КВАРТАЛ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗаписьДополнительногоЛиста,
	|	Состав.СчетФактураВыданный
	|ИЗ
	|	ВременнаяТаблицаСостав КАК Состав
	|ГДЕ
	|	Состав.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияПоНДСПродажи.НеПодтвержденаСтавка0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Состав.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПоФормированиюРегламентнойОперации(НомераТаблиц)

	НомераТаблиц.Вставить("ДанныеРегламентнойОперации", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Реквизиты.Дата, КВАРТАЛ) КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.РегламентныеОперации.ПодтверждениеНулевойСтавкиНДС) КАК РегламентнаяОперация
	|ИЗ
	|	Документ.ПодтверждениеНулевойСтавкиНДС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Счета-фактуры
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СчетФактура";
	КомандаПечати.Представление = НСтр("ru = 'Счета-фактуры'");
	КомандаПечати.Обработчик    = "УчетНДСКлиент.ВыполнитьКомандуПечатиСчетовФактур";

КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетФактура") Тогда
		МассивСчетовФактур = ПолучитьМассивСчетовФактурОбъктов(МассивОбъектов);
		Документы.СчетФактураВыданный.Печать(МассивСчетовФактур, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

Функция ПолучитьМассивСчетовФактурОбъктов(МассивОбъектов)
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПодтверждениеНулевойСтавкиСостав.СчетФактураВыданный
	|ИЗ
	|	Документ.ПодтверждениеНулевойСтавкиНДС.Состав КАК ПодтверждениеНулевойСтавкиСостав
	|ГДЕ
	|	ПодтверждениеНулевойСтавкиСостав.Ссылка В (&МассивОбъектов)
	|	И ПодтверждениеНулевойСтавкиСостав.СчетФактураВыданный <> ЗНАЧЕНИЕ(Документ.СчетФактураВыданный.ПустаяСсылка)";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат (Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СчетФактура"));
	
КонецФункции


#КонецЕсли