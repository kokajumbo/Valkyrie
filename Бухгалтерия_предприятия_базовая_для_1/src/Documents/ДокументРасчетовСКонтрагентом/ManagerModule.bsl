#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции

Функция ТекстЗапросаСчетФактураВыданныйНалоговыйАгентРасшифровкаПлатежа(НомераТаблиц) Экспорт
	
	НомераТаблиц.Вставить("ВТ_РасшифровкаПлатежа", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	NULL КАК Дата,
	|	NULL КАК ДокументОснование,
	|	NULL КАК Организация,
	|	NULL КАК Контрагент,
	|	NULL КАК ДоговорКонтрагента,
	|	NULL КАК Номенклатура,
	|	NULL КАК СчетАвансов,
	|	NULL КАК СуммаБезНДС
	|ПОМЕСТИТЬ РасшифровкаПлатежа";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаСчетФактураПолученныйНаАвансРасшифровкаПлатежа(НомераТаблиц) Экспорт
	
	НомераТаблиц.Вставить("ВТ_РасшифровкаПлатежа", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Ссылка КАК ДокументОснование,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетАвансов,
	|	&РасчетнаяСтавкаНДСПоУмолчанию КАК СтавкаНДС,
	|	Реквизиты.СуммаДокумента КАК Сумма,
	|	Реквизиты.СуммаДокумента * &ЗначениеСтавкиНДС / (100 + &ЗначениеСтавкиНДС) КАК СуммаНДС
	|ПОМЕСТИТЬ РасшифровкаПлатежа
	|ИЗ
	|	Документ.ДокументРасчетовСКонтрагентом КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &ДокументОснование";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаСчетФактураВыданныйНаАвансРасшифровкаПлатежа(НомераТаблиц) Экспорт
	
	НомераТаблиц.Вставить("ВТ_РасшифровкаПлатежа", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Ссылка КАК ДокументОснование,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	"""" КАК ИдентификаторГосКонтракта,
	|	Реквизиты.ДоговорКонтрагента.НаименованиеДляСчетаФактурыНаАванс КАК Номенклатура,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетАвансов,
	|	ЗНАЧЕНИЕ(Документ.СчетНаОплатуПокупателю.ПустаяСсылка) КАК СчетНаОплату,
	|	&РасчетнаяСтавкаНДСПоУмолчанию КАК СтавкаНДС,
	|	Реквизиты.СуммаДокумента КАК Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.СпособыПогашенияЗадолженности.ПустаяСсылка) КАК СпособПогашенияЗадолженности
	|ПОМЕСТИТЬ РасшифровкаПлатежа
	|ИЗ
	|	Документ.ДокументРасчетовСКонтрагентом КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &ДокументОснование";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаДанныеДляПечатиСчетовФактур(НомераТаблиц) Экспорт
	
	НомераТаблиц.Вставить("Реквизиты",                 НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ВременнаяТаблицаДокумента", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК ДатаОснования,
	|	Реквизиты.Организация КАК Организация,
	|	&ПустоеПодразделение КАК Подразделение,
	|	"""" КАК ЦифровойИндексОбособленногоПодразделения,
	|	Реквизиты.Организация КАК Поставщик,
	|	Реквизиты.Организация.ИНН КАК ИННпоставщика,
	|	Реквизиты.Организация КАК ОбособленноеПодразделениеПоставщика,
	|	НЕОПРЕДЕЛЕНО КАК Грузополучатель,
	|	Реквизиты.Организация КАК Покупатель,
	|	Реквизиты.Организация.ИНН КАК ИННпокупателя,
	|	Реквизиты.Организация КАК ОбособленноеПодразделениеПокупателя,
	|	НЕОПРЕДЕЛЕНО КАК Грузоотправитель,
	|	Реквизиты.ВалютаДокумента КАК Валюта,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаВзаиморасчетов,
	|	ЛОЖЬ КАК РасчетыВУсловныхЕдиницах,
	|	НЕОПРЕДЕЛЕНО КАК ВидДоговора,
	|	НЕОПРЕДЕЛЕНО КАК Основание,
	|	НЕОПРЕДЕЛЕНО КАК ОснованиеДата,
	|	НЕОПРЕДЕЛЕНО КАК ОснованиеНомер,
	|	ЛОЖЬ КАК ЕстьТовары,
	|	"""" КАК АдресДоставки,
	|	"""" КАК СведенияОТранспортировкеИГрузе,
	|	НЕОПРЕДЕЛЕНО КАК ОтветственныйЗаОформление,
	|	"""" КАК СопроводительныеДокументы,
	|	НЕОПРЕДЕЛЕНО КАК Перевозчик,
	|	ЛОЖЬ КАК ПеревозкаАвтотранспортом
	|ИЗ
	|	Документ.ДокументРасчетовСКонтрагентом КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК НомерТабЧасти,
	|	1 КАК НомерСтроки,
	|	"""" КАК Товар,
	|	"""" КАК ТоварКод,
	|	"""" КАК ТоварАртикул,
	|	"""" КАК ТоварНаименование,
	|	"""" КАК СтранаПроисхождения,
	|	"""" КАК ПредставлениеСтраны,
	|	"""" КАК НомерГТД,
	|	"""" КАК ПредставлениеГТД,
	|	"""" КАК РегистрационныйНомерТД,
	|	"""" КАК ЕдиницаИзмерения,
	|	0 КАК Количество,
	|	0 КАК Цена,
	|	0 КАК Сумма,
	|	0 КАК СуммаНДС,
	|	0 КАК СтавкаНДС,
	|	ЛОЖЬ КАК ЭтоУслуга,
	|	ИСТИНА КАК СуммаВключаетНДС,
	|	Таблица.Ссылка КАК Ссылка,
	|	ЛОЖЬ КАК ЭтоКомиссия,
	|	0 КАК ВсегоРуб,
	|	0 КАК НДСРуб,
	|	0 КАК СуммаБезНДСРуб,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК КонтрагентСводныйСФ,
	|	НЕОПРЕДЕЛЕНО КАК ПериодичностьУслуги,
	|	ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка) КАК ТоварКодТНВЭД
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.ДокументРасчетовСКонтрагентом КАК Таблица
	|ГДЕ
	|	ЛОЖЬ";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаДанныеДляПечатиКорректировочныхСчетовФактур(НомераТаблиц) Экспорт
	
	НомераТаблиц.Вставить("Реквизиты",						НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ВременнаяТаблицаДокумента",		НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК ДатаОснования,
	|	Реквизиты.Организация КАК Организация,
	|	&ПустоеПодразделение КАК Подразделение,
	|	"""" КАК ЦифровойИндексОбособленногоПодразделения,
	|	Реквизиты.Организация КАК Поставщик,
	|	Реквизиты.Организация.ИНН КАК ИННпоставщика,
	|	Реквизиты.Организация КАК ОбособленноеПодразделениеПоставщика,
	|	НЕОПРЕДЕЛЕНО КАК Грузополучатель,
	|	Реквизиты.Организация КАК Покупатель,
	|	Реквизиты.Организация.ИНН КАК ИННпокупателя,
	|	Реквизиты.Организация КАК ОбособленноеПодразделениеПокупателя,
	|	НЕОПРЕДЕЛЕНО КАК Грузоотправитель,
	|	Реквизиты.ВалютаДокумента КАК Валюта,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаВзаиморасчетов,
	|	ЛОЖЬ КАК РасчетыВУсловныхЕдиницах,
	|	ЛОЖЬ КАК ЕстьТовары
	|ИЗ
	|	Документ.ДокументРасчетовСКонтрагентом КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК НомерТабЧасти,
	|	1 КАК НомерСтроки,
	|	"""" КАК Товар,
	|	"""" КАК ТоварКод,
	|	"""" КАК ТоварАртикул,
	|	"""" КАК ТоварНаименование,
	|	"""" КАК СтранаПроисхождения,
	|	"""" КАК ПредставлениеСтраны,
	|	"""" КАК НомерГТД,
	|	"""" КАК ПредставлениеГТД,
	|	"""" КАК ЕдиницаИзмерения,
	|	0 КАК КоличествоДоИзменения,
	|	0 КАК КоличествоПослеИзменения,
	|	0 КАК ЦенаДоИзменения,
	|	0 КАК ЦенаПослеИзменения,
	|	0 КАК СтоимостьБезНДСДоИзменения,
	|	0 КАК СтоимостьБезНДСПослеИзменения,
	|	0 КАК СуммаНДСПослеИзменения,
	|	0 КАК СуммаНДСДоИзменения,
	|	0 КАК СтоимостьСНДСДоИзменения,
	|	0 КАК СтоимостьСНДСПослеИзменения,
	|	0 КАК РазницаБезНДСУменьшение,
	|	0 КАК РазницаБезНДСУвеличение,
	|	0 КАК РазницаНДСУменьшение,
	|	0 КАК РазницаНДСУвеличение,
	|	0 КАК РазницаСНДСУменьшение,
	|	0 КАК РазницаСНДСУвеличение,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДСДоИзменения,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДСПослеИзменения,
	|	ИСТИНА КАК ЭтоУслуга,
	|	Таблица.Ссылка КАК Ссылка,
	|	"""" КАК АдресПоставщика,
	|	"""" КАК ИННКПППоставщика,
	|	ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка) КАК ТоварКодТНВЭД,
	|	ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка) КАК ТоварКодТНВЭДДоИзменения
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.ДокументРасчетовСКонтрагентом КАК Таблица
	|ГДЕ
	|	ЛОЖЬ";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции	

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

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли