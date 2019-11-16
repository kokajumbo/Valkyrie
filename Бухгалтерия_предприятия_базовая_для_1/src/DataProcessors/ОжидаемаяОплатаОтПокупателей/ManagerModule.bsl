#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подготавливает таблицу, содержащую планируемые платежи.
// Параметры:
//   Параметры - Структура - структура параметров фонового задания. Ключи структуры:
//     * Организация - СправочникСсылка.Организации
//   АдресХранилища- Строка - адрес временного хранилища, в которое помещается таблица планируемых платежей.
//
Процедура ЗаполнитьПланируемыеПлатежи(Параметры, АдресХранилища) Экспорт
	
	ПланируемыеПлатежи = ОстаткиПоДокументам(Параметры.Организация);
	
	ПоместитьВоВременноеХранилище(ПланируемыеПлатежи, АдресХранилища);
	
КонецПроцедуры

// Возвращает таблицу планируемых платежей, формируется по остатку кредиторской задолженности и неоплаченным счетам.
// Параметры
//   Организация - СправочникСсылка.Организации
//   ДатаОстатков - Дата
// 
// Возвращаемое значение:
//   ТаблицаПлатежей - ТаблицаЗначений - Таблица планируемых платежей.
//    * ДатаПлатежа
//    * Документ
//    * Расшифровка
//    * Контрагент
//    * ДоговорКонтрагента
//    * Сумма
Функция ПланируемыеПлатежи(Организация, ДатаОстатков) Экспорт
	
	Возврат ОстаткиПоДокументам(Организация, ДатаОстатков, Истина);
	
КонецФункции

// Возвращает массив типов документов для которых доступно планирование платежей от покупателей
// Возвращаемое значение:
//   Массив - Массив типов
//
Функция ТипыДокументовРасчетов() Экспорт
	
	ТипыДокументовРасчетов = Новый Массив;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РеализацияТоваровУслуг) тогда
		ТипыДокументовРасчетов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.АктОбОказанииПроизводственныхУслуг) тогда
		ТипыДокументовРасчетов.Добавить(Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг"));
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПередачаОС) тогда
		ТипыДокументовРасчетов.Добавить(Тип("ДокументСсылка.ПередачаОС"));
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПередачаНМА) тогда
		ТипыДокументовРасчетов.Добавить(Тип("ДокументСсылка.ПередачаНМА"));
	КонецЕсли;
	
	Возврат ТипыДокументовРасчетов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОстаткиПоДокументам(Организация = Неопределено, ДатаОстатков = Неопределено, ДляКалендаря = Ложь)
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ОрганизацииДанныеКоторыхДоступныПользователю();
	
	Если ЗначениеЗаполнено(Организация) И СписокДоступныхОрганизаций.Найти(Организация) <> Неопределено Тогда
		СписокОрганизаций = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организация);
	ИначеЕсли СписокДоступныхОрганизаций.Количество() <> 0 Тогда
		СписокОрганизаций = СписокДоступныхОрганизаций;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	ТипыДокументовРасчетов              = ТипыДокументовРасчетов();
	ДоступныОстаткиПоДокументамРасчетов = (ТипыДокументовРасчетов.Количество() > 0);
	ДоступныОстаткиПоСчетамПокупателя   = ПравоДоступа("Чтение", Метаданные.Документы.СчетНаОплатуПокупателю);
	
	Если НЕ ДоступныОстаткиПоДокументамРасчетов И НЕ ДоступныОстаткиПоСчетамПокупателя Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДатаОстатков = Неопределено Тогда
		ДатаОстатков = ОбщегоНазначенияБП.ПолучитьРабочуюДату();
	КонецЕсли;
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТекстЗапроса = ТекстЗапросаПлатежи(ДляКалендаря, ДоступныОстаткиПоДокументамРасчетов, ДоступныОстаткиПоСчетамПокупателя);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПокупателей();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РабочаяДата",             ДатаОстатков);
	Запрос.УстановитьПараметр("СписокОрганизаций",       СписокОрганизаций);
	Запрос.УстановитьПараметр("ВидыДоговоров",           БухгалтерскиеОтчеты.ВидыДоговоровПокупателей());
	Запрос.УстановитьПараметр("ГраницаОстатков",         Новый Граница(КонецДня(ДатаОстатков), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ВидыСубконтоРасчетов",    ВидыСубконтоРасчетов());
	Запрос.УстановитьПараметр("СрокОплатыПоУмолчанию",   Константы.СрокОплатыПокупателей.Получить());
	Запрос.УстановитьПараметр("ТипыДокументовРасчетов",  ТипыДокументовРасчетов);
	Запрос.УстановитьПараметр("СчетаДолговПоДокументам", СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	Запрос.УстановитьПараметр("ВалютаРеглУчета",         ВалютаРегламентированногоУчета);
	
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция ТекстЗапросаПлатежи(ДляКалендаря, ДоступныОстаткиПоДокументамРасчетов, ДоступныОстаткиПоСчетамПокупателя)
	
	// Запрос состоит из нескольких частей, которые могут использоваться в зависимости от прав пользователя:
	// 1. Получение остатков по документам расчетов. Типы документов расчетов см в ТипыДокументовРасчетов();
	// 2. Получение остатков по неоплаченным счетам;
	// 3. Объединение таблиц полученных на шагах 1 и 2;
	// 4. Компоновка результата для того, кто запросил эти данные.
	
	ТекстЗапроса = "";
	
	Если ДоступныОстаткиПоДокументамРасчетов Тогда
		// Получим остатки по документам расчетов.
		// Типы документов расчетов ограничены в функции ТипыДокументовРасчетов().
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
		|	ХозрасчетныйОстатки.Субконто2 КАК Договор,
		|	ХозрасчетныйОстатки.Субконто3 КАК ДокументРасчетов,
		|	ХозрасчетныйОстатки.СуммаОстатокДт КАК Сумма,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстатокДт КАК ВалютнаяСумма,
		|	ХозрасчетныйОстатки.Организация КАК Организация,
		|	ХозрасчетныйОстатки.Валюта,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ХозрасчетныйОстатки.Субконто3) = ТИП(Документ.РеализацияТоваровУслуг)
		|				И ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.РеализацияТоваровУслуг).СчетНаОплатуПокупателю <> ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|				И ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.РеализацияТоваровУслуг).СчетНаОплатуПокупателю.Проведен
		|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.РеализацияТоваровУслуг).СчетНаОплатуПокупателю
		|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|	КОНЕЦ КАК СчетНаОплату
		|ПОМЕСТИТЬ ОстаткиПоДокументамРасчетов
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ГраницаОстатков,
		|			Счет В (&СчетаДолговПоДокументам),
		|			&ВидыСубконтоРасчетов,
		|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
		|				И ТИПЗНАЧЕНИЯ(Субконто3) В (&ТипыДокументовРасчетов)
		|				И Организация В (&СписокОрганизаций)) КАК ХозрасчетныйОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	ДокументРасчетов";
		
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов();
		
	КонецЕсли;
	
	Если ДоступныОстаткиПоСчетамПокупателя Тогда
		// Получим остатки по неоплаченным счетам покупателей
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	СтатусыДокументов.Статус,
		|	ЕСТЬNULL(СрокиОплатыДокументов.СрокОплаты, ДАТАВРЕМЯ(1, 1, 1)) КАК СрокОплаты,
		|	СчетНаОплатуПокупателю.Организация,
		|	СчетНаОплатуПокупателю.Контрагент КАК Контрагент,
		|	СчетНаОплатуПокупателю.Ссылка КАК СчетНаОплату,
		|	СчетНаОплатуПокупателю.СуммаДокумента КАК СуммаВВалюте,
		|	СчетНаОплатуПокупателю.ДоговорКонтрагента,
		|	СчетНаОплатуПокупателю.ВалютаДокумента КАК Валюта,
		|	СчетНаОплатуПокупателю.ВалютаДокумента = &ВалютаРеглУчета КАК ВалютаСоответствуетРеглУчету
		|ПОМЕСТИТЬ НеоплаченныеСчетаВВалюте
		|ИЗ
		|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументов КАК СтатусыДокументов
		|		ПО (СтатусыДокументов.Документ = СчетНаОплатуПокупателю.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиОплатыДокументов КАК СрокиОплатыДокументов
		|		ПО СчетНаОплатуПокупателю.Организация = СрокиОплатыДокументов.Организация
		|			И СчетНаОплатуПокупателю.Ссылка = СрокиОплатыДокументов.Документ
		|ГДЕ
		|	СчетНаОплатуПокупателю.Проведен
		|	И СчетНаОплатуПокупателю.Организация В(&СписокОрганизаций)
		|	И ЕСТЬNULL(СтатусыДокументов.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусОплатыСчета.НеОплачен)) В (ЗНАЧЕНИЕ(Перечисление.СтатусОплатыСчета.НеОплачен), ЗНАЧЕНИЕ(Перечисление.СтатусОплатыСчета.ОплаченЧастично))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СчетНаОплатуПокупателю.Организация,
		|	СчетНаОплату,
		|	Валюта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
		|	КурсыВалютСрезПоследних.Курс,
		|	КурсыВалютСрезПоследних.Кратность
		|ПОМЕСТИТЬ КурсыВалютДляСчетов
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&ГраницаОстатков, ) КАК КурсыВалютСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Валюта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НеоплаченныеСчетаВВалюте.СчетНаОплату
		|ПОМЕСТИТЬ ЧастичноОплаченныеСчета
		|ИЗ
		|	НеоплаченныеСчетаВВалюте КАК НеоплаченныеСчетаВВалюте
		|ГДЕ
		|	НеоплаченныеСчетаВВалюте.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусОплатыСчета.ОплаченЧастично)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОплатаСчетовОбороты.Организация КАК Организация,
		|	ОплатаСчетовОбороты.СчетНаОплату КАК СчетНаОплату,
		|	ОплатаСчетовОбороты.СуммаОборот
		|ПОМЕСТИТЬ ОплатаСчетов
		|ИЗ
		|	РегистрНакопления.ОплатаСчетов.Обороты(
		|			,
		|			&ГраницаОстатков,
		|			,
		|			Организация В (&СписокОрганизаций)
		|				И СчетНаОплату В
		|					(ВЫБРАТЬ
		|						ЧастичноОплаченныеСчета.СчетНаОплату
		|					ИЗ
		|						ЧастичноОплаченныеСчета КАК ЧастичноОплаченныеСчета)) КАК ОплатаСчетовОбороты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	СчетНаОплату
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НеоплаченныеСчетаВВалюте.СчетНаОплату,
		|	НеоплаченныеСчетаВВалюте.СрокОплаты КАК СрокОплаты,
		|	НеоплаченныеСчетаВВалюте.Организация,
		|	НеоплаченныеСчетаВВалюте.Контрагент КАК Контрагент,
		|	НеоплаченныеСчетаВВалюте.ДоговорКонтрагента,
		|	НеоплаченныеСчетаВВалюте.ВалютаСоответствуетРеглУчету,
		|	ВЫБОР
		|		КОГДА НеоплаченныеСчетаВВалюте.СуммаВВалюте - ЕСТЬNULL(ОплатаСчетов.СуммаОборот, 0) < 0
		|			ТОГДА 0
		|		ИНАЧЕ НеоплаченныеСчетаВВалюте.СуммаВВалюте - ЕСТЬNULL(ОплатаСчетов.СуммаОборот, 0)
		|	КОНЕЦ КАК ОсталосьОплатить,
		|	НеоплаченныеСчетаВВалюте.Валюта КАК Валюта,
		|	НеоплаченныеСчетаВВалюте.СуммаВВалюте КАК СуммаСчета
		|ПОМЕСТИТЬ НеоплаченныеСчетаСОплатой
		|ИЗ
		|	НеоплаченныеСчетаВВалюте КАК НеоплаченныеСчетаВВалюте
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОплатаСчетов КАК ОплатаСчетов
		|		ПО НеоплаченныеСчетаВВалюте.Организация = ОплатаСчетов.Организация
		|			И НеоплаченныеСчетаВВалюте.СчетНаОплату = ОплатаСчетов.СчетНаОплату
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НеоплаченныеСчетаВВалюте.СчетНаОплату,
		|	НеоплаченныеСчетаВВалюте.СрокОплаты КАК СрокОплаты,
		|	НеоплаченныеСчетаВВалюте.Организация,
		|	НеоплаченныеСчетаВВалюте.Контрагент КАК Контрагент,
		|	НеоплаченныеСчетаВВалюте.ДоговорКонтрагента,
		|	НеоплаченныеСчетаВВалюте.ОсталосьОплатить КАК ВалютнаяСумма,
		|	ВЫБОР
		|		КОГДА НеоплаченныеСчетаВВалюте.ВалютаСоответствуетРеглУчету
		|			ТОГДА НеоплаченныеСчетаВВалюте.ОсталосьОплатить
		|		КОГДА НЕ КурсыВалютДляСчетов.Курс ЕСТЬ NULL 
		|				И НЕ КурсыВалютДляСчетов.Кратность ЕСТЬ NULL 
		|				И КурсыВалютДляСчетов.Кратность <> 0
		|			ТОГДА НеоплаченныеСчетаВВалюте.ОсталосьОплатить * КурсыВалютДляСчетов.Курс / КурсыВалютДляСчетов.Кратность
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Сумма,
		|	НеоплаченныеСчетаВВалюте.Валюта КАК Валюта,
		|	НеоплаченныеСчетаВВалюте.СуммаСчета КАК СуммаСчета
		|ПОМЕСТИТЬ НеоплаченныеСчета
		|ИЗ
		|	НеоплаченныеСчетаСОплатой КАК НеоплаченныеСчетаВВалюте
		|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалютДляСчетов КАК КурсыВалютДляСчетов
		|		ПО НеоплаченныеСчетаВВалюте.Валюта = КурсыВалютДляСчетов.Валюта";
		
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов();
		
	КонецЕсли;
	
	// Подготовим остатки по счетам покупателей к объединению с остатками по документам расчетов
	Если ДоступныОстаткиПоСчетамПокупателя Тогда
		
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	НеоплаченныеСчета.СрокОплаты КАК СрокОплатыСчета,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК СрокОплатыДокументаРасчетов,
		|	НеоплаченныеСчета.СчетНаОплату,
		|	НЕОПРЕДЕЛЕНО КАК ДокументРасчетов,
		|	НеоплаченныеСчета.Организация,
		|	НеоплаченныеСчета.Контрагент,
		|	НеоплаченныеСчета.ДоговорКонтрагента,
		|	НеоплаченныеСчета.ВалютнаяСумма КАК ВалютнаяСуммаПредоплата,
		|	НеоплаченныеСчета.Сумма КАК СуммаПредоплата,
		|	0 КАК ВалютнаяСуммаДолг,
		|	0 КАК СуммаДолг,
		|	НеоплаченныеСчета.Валюта,
		|	НеоплаченныеСчета.СуммаСчета
		|ПОМЕСТИТЬ СписокСделокОбъединение
		|ИЗ
		|	НеоплаченныеСчета КАК НеоплаченныеСчета";
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	ДАТАВРЕМЯ(1, 1, 1) КАК СрокОплатыСчета,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК СрокОплатыДокументаРасчетов,
		|	НЕОПРЕДЕЛЕНО КАК СчетНаОплату,
		|	НЕОПРЕДЕЛЕНО КАК ДокументРасчетов,
		|	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация,
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
		|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК ДоговорКонтрагента,
		|	0 КАК ВалютнаяСуммаПредоплата,
		|	0 КАК СуммаПредоплата,
		|	0 КАК ВалютнаяСуммаДолг,
		|	0 КАК СуммаДолг,
		|	НЕОПРЕДЕЛЕНО КАК Валюта,
		|	0 КАК СуммаСчета
		|ПОМЕСТИТЬ СписокСделокОбъединение";
		
	КонецЕсли;
	
	Если ДоступныОстаткиПоДокументамРасчетов Тогда
		
		ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС +
			"ВЫБРАТЬ
			|	ДАТАВРЕМЯ(1, 1, 1) КАК СрокОплатыСчета,
			|	ВЫБОР
			|		КОГДА НЕ СрокиОплатыДокументов.СрокОплаты ЕСТЬ NULL 
			|			ТОГДА СрокиОплатыДокументов.СрокОплаты
			|		ИНАЧЕ ВЫБОР
			|				КОГДА ОстаткиПоДокументамРасчетов.Договор.УстановленСрокОплаты
			|					ТОГДА ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ДанныеПервичныхДокументов.ДатаРегистратора, ДЕНЬ), ДЕНЬ, ОстаткиПоДокументамРасчетов.Договор.СрокОплаты)
			|				ИНАЧЕ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ДанныеПервичныхДокументов.ДатаРегистратора, ДЕНЬ), ДЕНЬ, &СрокОплатыПоУмолчанию)
			|			КОНЕЦ
			|	КОНЕЦ КАК СрокОплатыДокументаРасчетов,
			|	ОстаткиПоДокументамРасчетов.СчетНаОплату,
			|	ОстаткиПоДокументамРасчетов.ДокументРасчетов,
			|	ОстаткиПоДокументамРасчетов.Организация,
			|	ОстаткиПоДокументамРасчетов.Контрагент,
			|	ОстаткиПоДокументамРасчетов.Договор,
			|	0 КАК ВалютнаяСуммаПредоплата,
			|	0 КАК СуммаПредоплата,
			|	ОстаткиПоДокументамРасчетов.ВалютнаяСумма,
			|	ОстаткиПоДокументамРасчетов.Сумма,
			|	ЕСТЬNULL(ОстаткиПоДокументамРасчетов.Валюта, ОстаткиПоДокументамРасчетов.ДокументРасчетов.ВалютаДокумента) КАК Валюта,
			|	0 КАК СуммаСчета
			|ИЗ
			|	ОстаткиПоДокументамРасчетов КАК ОстаткиПоДокументамРасчетов
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиОплатыДокументов КАК СрокиОплатыДокументов
			|		ПО ОстаткиПоДокументамРасчетов.Организация = СрокиОплатыДокументов.Организация
			|			И ОстаткиПоДокументамРасчетов.ДокументРасчетов = СрокиОплатыДокументов.Документ
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
			|		ПО ОстаткиПоДокументамРасчетов.Организация = ДанныеПервичныхДокументов.Организация
			|			И ОстаткиПоДокументамРасчетов.ДокументРасчетов = ДанныеПервичныхДокументов.Документ
			|ГДЕ
			|	(СрокиОплатыДокументов.СрокОплаты ЕСТЬ NULL 
			|			ИЛИ СрокиОплатыДокументов.СрокОплаты <> ДАТАВРЕМЯ(1, 1, 1))";
	КонецЕсли;
	
	// Сгруппируем полученный список документов
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов() +
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА СписокСделокОбъединение.СчетНаОплату = ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
	|				ТОГДА СписокСделокОбъединение.СрокОплатыДокументаРасчетов
	|			ИНАЧЕ СписокСделокОбъединение.СрокОплатыСчета
	|		КОНЕЦ) КАК СрокОплаты,
	|	ВЫБОР
	|		КОГДА СписокСделокОбъединение.СчетНаОплату = ЗНАЧЕНИЕ(документ.СчетНаОплатуПокупателю.ПустаяСсылка)
	|			ТОГДА СписокСделокОбъединение.ДокументРасчетов
	|		ИНАЧЕ СписокСделокОбъединение.СчетНаОплату
	|	КОНЕЦ КАК ГруппировкаПоДокументу,
	|	МАКСИМУМ(СписокСделокОбъединение.СчетНаОплату) КАК СчетНаОплату,
	|	МАКСИМУМ(СписокСделокОбъединение.ДокументРасчетов) КАК ДокументРасчетов,
	|	СписокСделокОбъединение.Организация,
	|	СписокСделокОбъединение.Контрагент,
	|	СписокСделокОбъединение.ДоговорКонтрагента,
	|	СУММА(СписокСделокОбъединение.ВалютнаяСуммаПредоплата) КАК ВалютнаяСуммаПредоплата,
	|	СУММА(СписокСделокОбъединение.СуммаПредоплата) КАК СуммаПредоплата,
	|	СУММА(СписокСделокОбъединение.ВалютнаяСуммаДолг) КАК ВалютнаяСуммаДолг,
	|	СУММА(СписокСделокОбъединение.СуммаДолг) КАК СуммаДолг,
	|	СписокСделокОбъединение.Валюта,
	|	СУММА(СписокСделокОбъединение.СуммаСчета) КАК СуммаСчета
	|ПОМЕСТИТЬ Результат
	|ИЗ
	|	СписокСделокОбъединение КАК СписокСделокОбъединение
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокСделокОбъединение.Контрагент,
	|	СписокСделокОбъединение.ДоговорКонтрагента,
	|	СписокСделокОбъединение.Организация,
	|	СписокСделокОбъединение.Валюта,
	|	ВЫБОР
	|		КОГДА СписокСделокОбъединение.СчетНаОплату = ЗНАЧЕНИЕ(документ.СчетНаОплатуПокупателю.ПустаяСсылка)
	|			ТОГДА СписокСделокОбъединение.ДокументРасчетов
	|		ИНАЧЕ СписокСделокОбъединение.СчетНаОплату
	|	КОНЕЦ";
	
	Если ДляКалендаря Тогда 
		
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов() +
		"ВЫБРАТЬ
		|	Результат.Организация КАК Организация,
		|	Результат.СрокОплаты КАК ДатаПлатежа,
		|	ВЫБОР
		|		КОГДА Результат.СчетНаОплату <> ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|			ТОГДА Результат.СчетНаОплату
		|		ИНАЧЕ Результат.ДокументРасчетов
		|	КОНЕЦ КАК Документ,
		|	ВЫБОР
		|		КОГДА Результат.СчетНаОплату <> ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОплатаПоСчету,
		|	Результат.СуммаСчета КАК СуммаСчета,
		|	Результат.Контрагент,
		|	Результат.ДоговорКонтрагента,
		|	Результат.Контрагент КАК Расшифровка,
		|	ВЫБОР
		|		КОГДА Результат.СчетНаОплату <> ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|			ТОГДА Результат.СуммаПредоплата
		|		ИНАЧЕ Результат.СуммаДолг
		|	КОНЕЦ КАК Сумма,
		|	ВЫБОР
		|		КОГДА Результат.СчетНаОплату <> ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|			ТОГДА Результат.СуммаПредоплата
		|		ИНАЧЕ Результат.СуммаДолг
		|	КОНЕЦ КАК СуммаПриход,
		|	0 КАК НомерРаздела,
		|	Результат.СрокОплаты < &РабочаяДата КАК Просрочен
		|ИЗ
		|	Результат КАК Результат";
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов() +
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Результат.Контрагент КАК Контрагент
		|ПОМЕСТИТЬ Контрагенты
		|ИЗ
		|	Результат КАК Результат
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтрагентыКонтактнаяИнформация.Представление
		|ПОМЕСТИТЬ АдресаЭлектроннойПочты
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка В
		|			(ВЫБРАТЬ
		|				Контрагенты.Контрагент
		|			ИЗ
		|				Контрагенты КАК Контрагенты)
		|	И КонтрагентыКонтактнаяИнформация.ВидДляСписка = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailКонтрагенты)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтрагентыКонтактнаяИнформация.Представление
		|ПОМЕСТИТЬ НомераТелефонов
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка В
		|			(ВЫБРАТЬ
		|				Контрагенты.Контрагент
		|			ИЗ
		|				Контрагенты КАК Контрагенты)
		|	И КонтрагентыКонтактнаяИнформация.ВидДляСписка = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонКонтрагента)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЛОЖЬ КАК НапоминаниеОтправлено,
		|	НомераТелефонов.Представление КАК НомерТелефона,
		|	АдресаЭлектроннойПочты.Представление КАК ЭлектроннаяПочта,
		|	Результат.СрокОплаты КАК СрокОплаты,
		|	РАЗНОСТЬДАТ(&РабочаяДата, Результат.СрокОплаты, ДЕНЬ) КАК ОсталосьДней,
		|	Результат.СчетНаОплату,
		|	Результат.СуммаСчета,
		|	Результат.ДокументРасчетов,
		|	Результат.Организация,
		|	Результат.Контрагент,
		|	Результат.ДоговорКонтрагента,
		|	ВЫБОР
		|		КОГДА Результат.СчетНаОплату = ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка)
		|			ТОГДА Результат.СуммаДолг
		|		ИНАЧЕ Результат.СуммаПредоплата
		|	КОНЕЦ КАК Сумма,
		|	ВЫБОР
		|		КОГДА Результат.Валюта = &ВалютаРеглУчета
		|			ТОГДА Результат.СуммаДолг
		|		ИНАЧЕ Результат.ВалютнаяСуммаДолг
		|	КОНЕЦ КАК СуммаДолг,
		|	ВЫБОР
		|		КОГДА Результат.Валюта = &ВалютаРеглУчета
		|			ТОГДА Результат.СуммаПредоплата
		|		ИНАЧЕ Результат.ВалютнаяСуммаПредоплата
		|	КОНЕЦ КАК СуммаПредоплата,
		|	Результат.Валюта,
		|	Результат.СрокОплаты = ДАТАВРЕМЯ(1, 1, 1) КАК НеЗаполненСрокОплаты
		|ИЗ
		|	Результат КАК Результат
		|		ЛЕВОЕ СОЕДИНЕНИЕ АдресаЭлектроннойПочты КАК АдресаЭлектроннойПочты
		|		ПО Результат.Контрагент = АдресаЭлектроннойПочты.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ НомераТелефонов КАК НомераТелефонов
		|		ПО Результат.Контрагент = НомераТелефонов.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НеЗаполненСрокОплаты,
		|	СрокОплаты";
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВидыСубконтоРасчетов()

	ВидыСубконтоРасчетов = Новый Массив;
	ВидыСубконтоРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	ВидыСубконтоРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);

	Возврат ВидыСубконтоРасчетов;

КонецФункции

#КонецОбласти

#КонецЕсли