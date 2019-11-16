#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область БСП

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	МассивРеквизитов = Новый Массив();
	МассивРеквизитов.Добавить("УдалитьАдресМестонахождения");
	Возврат МассивРеквизитов;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ПроставитьТипОСПриОбновлении() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустойТип", Перечисления.ТипыОС.ПустаяСсылка());
	Запрос.Текст =  "ВЫБРАТЬ
		|	ОсновныеСредства.Ссылка КАК Ссылка,
		|	ОсновныеСредства.ГруппаОС КАК ГруппаОС
		|ИЗ
		|	Справочник.ОсновныеСредства КАК ОсновныеСредства
		|ГДЕ
		|	ОсновныеСредства.ТипОС = &ПустойТип
		|	И НЕ ОсновныеСредства.Предопределенный
		|	И НЕ ОсновныеСредства.ЭтоГруппа";
	
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из Результат Цикл
		
		ОСОбъект = Строка.Ссылка.ПолучитьОбъект();
		
		Если Строка.ГруппаОС = Перечисления.ГруппыОС.КапитальныеВложенияВАрендованноеИмущество Тогда 
			ОСОбъект.ТипОС = Перечисления.ТипыОС.КапитальноеВложение;
		Иначе
			ОСОбъект.ТипОС = Перечисления.ТипыОС.ОбъектОС;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОСОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПризнакНедвижимоеИмущество() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НедвижимоеИмущество = Новый Массив;
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.Здания);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.Сооружения);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.МноголетниеНасаждения);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.ЗемельныеУчастки);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.ОбъектыПриродопользования);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.ПрочееИмуществоТребующееГосударственнойРегистрации);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НедвижимоеИмущество", НедвижимоеИмущество);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеСредства.Ссылка КАК Ссылка,
	|	ОсновныеСредства.ГруппаОС КАК ГруппаОС
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|ГДЕ
	|	ОсновныеСредства.ГруппаОС В(&НедвижимоеИмущество)
	|	И НЕ ОсновныеСредства.НедвижимоеИмущество
	|	И НЕ ОсновныеСредства.ЭтоГруппа";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из Результат Цикл
		
		Объект = Строка.Ссылка.ПолучитьОбъект();
		Объект.НедвижимоеИмущество = Истина;
		
		Если Строка.ГруппаОС = Перечисления.ГруппыОС.ПрочееИмуществоТребующееГосударственнойРегистрации Тогда
			Объект.ГруппаОС = Перечисления.ГруппыОС.ДругиеВидыОсновныхСредств;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Инвентарная карточка ОС (ОС-6)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОС6";
	КомандаПечати.Представление = НСтр("ru = 'Инвентарная карточка ОС (ОС-6)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиКарточкиОС";
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой инвентарной карточки ОС (форма ОС-6)
// Утверждена постановлением Госкомстата России от 21.01.2003 № 7
// Возвращаемое значение:
//  Табличный документ - печатная форма инвентарной карточки ОС
Функция ПечатьОС6_2003(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.АвтоМасштаб			= Истина;
	ТабДок.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДок.ПолеСнизу			= 0;
	ТабДок.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ОсновныеСредства_ОС6";
	СисИнфо = Новый СистемнаяИнформация;
	Если ПустаяСтрока(СисИнфо.ИнформацияПрограммыПросмотра) Тогда 
		ТабДок.ПолеСверху          = 0;
	Иначе
		ТабДок.ПолеСверху          = 10;
	КонецЕсли;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ОсновныеСредства.ОС6");
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ШапкаРазделов1и2  = Макет.ПолучитьОбласть("ШапкаРазделов1и2");
	ШапкаРаздела3     = Макет.ПолучитьОбласть("ШапкаРаздела3");
	СтрокиРаздела3    = Макет.ПолучитьОбласть("СтрокиРаздела3");
	ШапкаРаздела4     = Макет.ПолучитьОбласть("ШапкаРаздела4");
	СтрокаРаздела4    = Макет.ПолучитьОбласть("СтрокаРаздела4");
	ПодвалСтраницы1   = Макет.ПолучитьОбласть("ПодвалСтраницы1");
	ШапкаРазделов5и6  = Макет.ПолучитьОбласть("ШапкаРазделов5и6");
	СтрокаРазделов5и6 = Макет.ПолучитьОбласть("СтрокаРазделов5и6");
	ШапкаРаздела7_1   = Макет.ПолучитьОбласть("ШапкаРаздела7_1");
	ШапкаРаздела7_2   = Макет.ПолучитьОбласть("ШапкаРаздела7_2");
	ПодвалСтраницы2   = Макет.ПолучитьОбласть("ПодвалСтраницы2");
	
	// Карточка выводится на дату заданную в форме элемента, при печати из других мест используем рабочую дату пользователя.
	Если ПараметрыПечати.Свойство("ДатаСведений") Тогда
		ДатаСведений = ПараметрыПечати.ДатаСведений;
	Иначе
		ДатаСведений = ОбщегоНазначения.ТекущаяДатаПользователя();
	КонецЕсли;
	
	ТаблицаОбъектов = Новый ТаблицаЗначений;
	ТаблицаОбъектов.Колонки.Добавить("ОС", Новый ОписаниеТипов("СправочникСсылка.ОсновныеСредства"));
	ТаблицаОбъектов.Колонки.Добавить("Номер", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	НомерСтроки = 1;
	Для каждого ОС Из МассивОбъектов Цикл
		СтрокаТаблицы = ТаблицаОбъектов.Добавить();
		СтрокаТаблицы.ОС = ОС;
		СтрокаТаблицы.Номер = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОбъектов", ТаблицаОбъектов);
	Запрос.УстановитьПараметр("ДатаСведений", ДатаСведений);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаОС.ОС КАК ОС,
	|	ТаблицаОС.Номер КАК Порядок
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОбъектов КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СведенияПоОрганизации.ОсновноеСредство КАК ОС,
	|	СведенияПоОрганизации.Организация КАК Организация
	|ПОМЕСТИТЬ СведенияПоОрганизации
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, ОсновноеСредство В (&МассивОбъектов)) КАК СведенияПоОрганизации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОсновныеСредства.Ссылка КАК Ссылка,
	|	ОсновныеСредства.Код КАК Код,
	|	ОсновныеСредства.Наименование КАК Наименование,
	|	ОсновныеСредства.АмортизационнаяГруппа КАК АмортизационнаяГруппа,
	|	ОсновныеСредства.ГруппаОС КАК ГруппаОС,
	|	ОсновныеСредства.ДатаВыпуска КАК ДатаВыпуска,
	|	ОсновныеСредства.ЗаводскойНомер КАК ЗаводскойНомер,
	|	ОсновныеСредства.Изготовитель КАК Изготовитель,
	|	ОсновныеСредства.КодПоОКОФ КАК КодПоОКОФСсылка,
	|	ОсновныеСредства.КодПоОКОФ.Код КАК КодПоОКОФ,
	|	ОсновныеСредства.НаименованиеПолное КАК НаименованиеПолное,
	|	ОсновныеСредства.НомерПаспорта КАК НомерПаспорта,
	|	ОсновныеСредства.ШифрПоЕНАОФ КАК ШифрПоЕНАОФ,
	|	ЕСТЬNULL(СведенияПоОрганизации.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
	|	ЕСТЬNULL(СведенияПоОрганизации.Организация.КодПоОКПО, """") КАК КодПоОКПО,
	|	ТаблицаОС.Порядок КАК Порядок
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОсновныеСредства КАК ОсновныеСредства
	|		ПО ТаблицаОС.ОС = ОсновныеСредства.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ СведенияПоОрганизации КАК СведенияПоОрганизации
	|		ПО ТаблицаОС.ОС = СведенияПоОрганизации.ОС
	|ГДЕ
	|	ОсновныеСредства.ЭтоГруппа = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	РезультатЗапрос = Запрос.Выполнить();
	
	Если РезультатЗапрос.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Печатная форма № ОС-6 может быть сформирована только для элементов справочника.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ВыборкаОбъектов = РезультатЗапрос.Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаОбъектов.Следующий() Цикл
		
		//Последние сведения об ОС
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Организация", ВыборкаОбъектов.Организация);
		Запрос.УстановитьПараметр("ДатаСведений", ДатаСведений);
		Запрос.УстановитьПараметр("ОсновноеСредство", ВыборкаОбъектов.Ссылка);
		Запрос.УстановитьПараметр("СубконтоОС", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.СтоимостьДляВычисленияАмортизации,
		|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ОбъемПродукцииРаботДляВычисленияАмортизации,
		|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.КоэффициентАмортизации,
		|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.КоэффициентУскорения,
		|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.Период,
		|	СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних.СчетУчета,
		|	СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних.СчетНачисленияАмортизации,
		|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.СпособНачисленияАмортизации,
		|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ПервоначальнаяСтоимость,
		|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.СрокПолезногоИспользования,
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ,
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение.Наименование,
		|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство,
		|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ИнвентарныйНомер
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, Организация = &Организация И ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, Организация = &Организация И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних
		|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(&ДатаСведений, Организация = &Организация И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних
		|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, Организация = &Организация И ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
		|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
		|
		|ГДЕ
		|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.Организация = &Организация";
		ТекущиеСведенияОС = Запрос.Выполнить().Выбрать();
		ТекущиеСведенияОС.Следующий();
		
		Если НЕ ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
			
		СчетУчетаСтоимостиБУ = ТекущиеСведенияОС.СчетУчета;
		СрокИспользования   = ТекущиеСведенияОС.СрокПолезногоИспользования;
		
		Отбор  = Новый Структура( "ОсновноеСредство", ВыборкаОбъектов.Ссылка);
		Подразделение  = ТекущиеСведенияОС.МестонахождениеНаименование;
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаОбъектов.Организация, ДатаСведений);
		
		Шапка.Параметры.Организация       = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм");
		Шапка.Параметры.КодПоОКПО         = ВыборкаОбъектов.КодПоОКПО;
		Шапка.Параметры.Подразделение     = Подразделение;
		Шапка.Параметры.НаименованиеОС     = ?(НЕ ЗначениеЗаполнено(ВыборкаОбъектов.НаименованиеПолное),
			ВыборкаОбъектов.Наименование, ВыборкаОбъектов.НаименованиеПолное);
		
		Шапка.Параметры.НомерДок          = ТекущиеСведенияОС.ИнвентарныйНомер;
		Шапка.Параметры.ДатаДок           = Формат(ДатаСведений,"ДФ=dd.MM.yyyy");
		Шапка.Параметры.МестоНахождениеОС = Подразделение;
		Шапка.Параметры.ИзготовительОС    = ВыборкаОбъектов.Изготовитель;
		Шапка.Параметры.КодПоОКОФ         = ВыборкаОбъектов.КодПоОКОФ;
		Шапка.Параметры.НомерГруппы       = ВыборкаОбъектов.АмортизационнаяГруппа;
		Шапка.Параметры.НомерПаспорта     = ВыборкаОбъектов.НомерПаспорта;
		Шапка.Параметры.ЗаводскойНомер    = ВыборкаОбъектов.ЗаводскойНомер;
		Шапка.Параметры.ИнвентарныйНомер  = ТекущиеСведенияОС.ИнвентарныйНомер;
		Шапка.Параметры.СубСчет           = Строка(СчетУчетаСтоимостиБУ);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияОСОрганизаций.Состояние,
		|	СостоянияОСОрганизаций.ДатаСостояния,
		|	СобытияОСОрганизаций.НазваниеДокумента,
		|	СобытияОСОрганизаций.НомерДокумента,
		|	СобытияОСОрганизаций.Событие,
		|	СостоянияОСОрганизаций.Регистратор
		|ИЗ
		|	РегистрСведений.СобытияОСОрганизаций КАК СобытияОСОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
		|		ПО СобытияОСОрганизаций.Период = СостоянияОСОрганизаций.ДатаСостояния
		|			И СобытияОСОрганизаций.Регистратор = СостоянияОСОрганизаций.Регистратор
		|ГДЕ
		|	СобытияОСОрганизаций.Организация = &Организация
		|	И СостоянияОСОрганизаций.Организация = &Организация
		|	И СобытияОСОрганизаций.ОсновноеСредство = &ОсновноеСредство
		|	И СостоянияОСОрганизаций.ОсновноеСредство = &ОсновноеСредство
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	СобытияОСОрганизацийСрезПоследних.Период,
		|	СобытияОСОрганизацийСрезПоследних.НазваниеДокумента,
		|	СобытияОСОрганизацийСрезПоследних.НомерДокумента,
		|	СобытияОСОрганизацийСрезПоследних.Событие,
		|	СобытияОСОрганизацийСрезПоследних.Регистратор
		|ИЗ
		|	РегистрСведений.СобытияОСОрганизаций.СрезПоследних(
		|			&ДатаСведений,
		|			ОсновноеСредство = &ОсновноеСредство
		|				И Организация = &Организация
		|				И Событие.ВидСобытияОС В (&МодернизацияИКапРемонт)) КАК СобытияОСОрганизацийСрезПоследних";
		
		Запрос.УстановитьПараметр("Организация", ВыборкаОбъектов.Организация);
		Запрос.УстановитьПараметр("ОсновноеСредство", ВыборкаОбъектов.Ссылка);
		Запрос.УстановитьПараметр("ДатаСведений", ДатаСведений);
		
		ВидыСобытий = Новый СписокЗначений;
		ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.РаспределениеНДС);
		ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Модернизация);
		ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Достройка);
		ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.Дооборудование);
		ВидыСобытий.Добавить(Перечисления.ВидыСобытийОС.КапитальныйРемонт);
		
		Запрос.УстановитьПараметр("МодернизацияИКапРемонт", ВидыСобытий);
		Выборка = Запрос.Выполнить().Выбрать();
		
		ДатаПринятия     = '00010101';
		ДокументПринятия = "";
		
		ДатаВвода     = '00010101';
		ДокументВвода = "";
		ДокументВводаНомер = "";
		
		ДатаСписания       = '00010101';
		ДокументСписания   = "";
		РегистраторСписания = Неопределено;
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.Состояние   = Перечисления.СостоянияОС.ПринятоКУчету Тогда
				 ДатаПринятия        = Выборка.ДатаСостояния;
				 ДокументПринятия    = Выборка.НазваниеДокумента;
			ИначеЕсли Выборка.Состояние = Перечисления.СостоянияОС.СнятоСУчета Тогда
				 ДатаСписания        = Выборка.ДатаСостояния;
				 ДокументСписания    = Выборка.НазваниеДокумента;
				 РегистраторСписания = Выборка.Регистратор;
			Иначе
				ДатаПоследнейМодернизации     = Выборка.ДатаСостояния;
				ДокументПоследнейМодернизации = Выборка.НазваниеДокумента;
			КонецЕсли; 
		КонецЦикла;

		Шапка.Параметры.ДатаВвода    = ДатаПринятия;
		Шапка.Параметры.ДатаСписания = ДатаСписания;

		ТабДок.Вывести(Шапка);

		// Балансовая стоимость ОС на момент поступления и первоначально принятый срок полезного использования
		ШапкаРазделов1и2.Параметры.ПервоначальнаяСтоимость    = ТекущиеСведенияОС.ПервоначальнаяСтоимость;
		ШапкаРазделов1и2.Параметры.СрокПолезногоИспользования = СрокИспользования;

		ТабДок.Вывести(ШапкаРазделов1и2);
		ТабДок.Вывести(ШапкаРаздела3);
		ТабДок.Вывести(СтрокиРаздела3);

		// Сведения о приемке, внутренних перемещениях и выбытии	
		ТабДок.Вывести(ШапкаРаздела4);

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Период",           ДатаСведений);
		Запрос.УстановитьПараметр("Организация",      ВыборкаОбъектов.Организация);
		Запрос.УстановитьПараметр("ОсновноеСредство", ВыборкаОбъектов.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СобытияОСОрганизаций.НазваниеДокумента,
		|	СобытияОСОрганизаций.НомерДокумента,
		|	ВЫБОР
		|		КОГДА СобытияОСОрганизаций.Событие.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчету)
		|			ТОГДА ЕСТЬNULL(СостоянияОСОрганизаций.ДатаСостояния, СобытияОСОрганизаций.Период)
		|		ИНАЧЕ СобытияОСОрганизаций.Период
		|	КОНЕЦ КАК Период,
		|	ВЫБОР
		|		КОГДА СобытияОСОрганизаций.Регистратор ССЫЛКА Документ.ПередачаОС
		|				И ВЫРАЗИТЬ(СобытияОСОрганизаций.Регистратор КАК Документ.ПередачаОС).ДокПодготовкаКПередачеОС <> ЗНАЧЕНИЕ(Документ.ПодготовкаКПередачеОС.ПустаяСсылка)
		|			ТОГДА ВЫРАЗИТЬ(СобытияОСОрганизаций.Регистратор КАК Документ.ПередачаОС).ДокПодготовкаКПередачеОС.Дата
		|		ИНАЧЕ СобытияОСОрганизаций.Период
		|	КОНЕЦ КАК ПериодОстатков,
		|	СобытияОСОрганизаций.Событие,
		|	СобытияОСОрганизаций.Событие.ВидСобытияОС КАК ВидСобытияОС,
		|	СобытияОСОрганизаций.Регистратор
		|ПОМЕСТИТЬ СобытияОС
		|ИЗ
		|	РегистрСведений.СобытияОСОрганизаций КАК СобытияОСОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
		|		ПО СобытияОСОрганизаций.ОсновноеСредство = СостоянияОСОрганизаций.ОсновноеСредство
		|			И СобытияОСОрганизаций.Организация = СостоянияОСОрганизаций.Организация
		|			И (СостоянияОСОрганизаций.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету))
		|ГДЕ
		|	СобытияОСОрганизаций.ОсновноеСредство = &ОсновноеСредство
		|	И СобытияОСОрганизаций.Период < &Период
		|	И СобытияОСОрганизаций.Организация = &Организация
		|	И СобытияОСОрганизаций.Событие.ВидСобытияОС В (ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчету), ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчетуСВводомВЭксплуатацию), ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ВнутреннееПеремещение), ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Списание), ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Передача))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МестонахождениеОСБухгалтерскийУчет.Период,
		|	МестонахождениеОСБухгалтерскийУчет.МОЛ,
		|	МестонахождениеОСБухгалтерскийУчет.Местонахождение
		|ПОМЕСТИТЬ МестонахождениеОСБухгалтерскийУчет
		|ИЗ
		|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК МестонахождениеОСБухгалтерскийУчет
		|ГДЕ
		|	МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство = &ОсновноеСредство
		|	И МестонахождениеОСБухгалтерскийУчет.Организация = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СобытияОС.Период,
		|	МАКСИМУМ(МестонахождениеОСБухгалтерскийУчет.Период) КАК ПоследнийПериод
		|ПОМЕСТИТЬ МестонахождениеОСБухгалтерскийУчетСрезПоследнихПериодов
		|ИЗ
		|	СобытияОС КАК СобытияОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ МестонахождениеОСБухгалтерскийУчет КАК МестонахождениеОСБухгалтерскийУчет
		|		ПО СобытияОС.Период >= МестонахождениеОСБухгалтерскийУчет.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	СобытияОС.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследнихПериодов.Период,
		|	МестонахождениеОСБухгалтерскийУчет.МОЛ,
		|	МестонахождениеОСБухгалтерскийУчет.Местонахождение
		|ПОМЕСТИТЬ МестонахождениеОСБухгалтерскийУчетСрезПоследних
		|ИЗ
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследнихПериодов КАК МестонахождениеОСБухгалтерскийУчетСрезПоследнихПериодов
		|		ЛЕВОЕ СОЕДИНЕНИЕ МестонахождениеОСБухгалтерскийУчет КАК МестонахождениеОСБухгалтерскийУчет
		|		ПО МестонахождениеОСБухгалтерскийУчетСрезПоследнихПериодов.ПоследнийПериод = МестонахождениеОСБухгалтерскийУчет.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетаБухгалтерскогоУчетаОС.Период,
		|	СчетаБухгалтерскогоУчетаОС.СчетУчета,
		|	СчетаБухгалтерскогоУчетаОС.СчетНачисленияАмортизации
		|ПОМЕСТИТЬ СчетаБухгалтерскогоУчетаОС
		|ИЗ
		|	РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК СчетаБухгалтерскогоУчетаОС
		|ГДЕ
		|	СчетаБухгалтерскогоУчетаОС.ОсновноеСредство = &ОсновноеСредство
		|	И СчетаБухгалтерскогоУчетаОС.Организация = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СобытияОС.ПериодОстатков,
		|	МАКСИМУМ(СчетаБухгалтерскогоУчетаОС.Период) КАК ПоследнийПериод
		|ПОМЕСТИТЬ СчетаБухгалтерскогоУчетаОССрезПоследнихПериодов
		|ИЗ
		|	СобытияОС КАК СобытияОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ СчетаБухгалтерскогоУчетаОС КАК СчетаБухгалтерскогоУчетаОС
		|		ПО СобытияОС.ПериодОстатков >= СчетаБухгалтерскогоУчетаОС.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	СобытияОС.ПериодОстатков
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетаБухгалтерскогоУчетаОССрезПоследнихПериодов.ПериодОстатков,
		|	СчетаБухгалтерскогоУчетаОС.СчетУчета,
		|	СчетаБухгалтерскогоУчетаОС.СчетНачисленияАмортизации
		|ПОМЕСТИТЬ СчетаБухгалтерскогоУчетаОССрезПоследних
		|ИЗ
		|	СчетаБухгалтерскогоУчетаОССрезПоследнихПериодов КАК СчетаБухгалтерскогоУчетаОССрезПоследнихПериодов
		|		ЛЕВОЕ СОЕДИНЕНИЕ СчетаБухгалтерскогоУчетаОС КАК СчетаБухгалтерскогоУчетаОС
		|		ПО СчетаБухгалтерскогоУчетаОССрезПоследнихПериодов.ПоследнийПериод = СчетаБухгалтерскогоУчетаОС.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Период,
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт
		|ПОМЕСТИТЬ ХозрасчетныйОстаткиИОбороты
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
		|			,
		|			&Период,
		|			Регистратор,
		|			,
		|			Счет В
		|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета
		|				ИЗ
		|					СчетаБухгалтерскогоУчетаОССрезПоследних
		|			
		|				ОБЪЕДИНИТЬ
		|			
		|				ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации
		|				ИЗ
		|					СчетаБухгалтерскогоУчетаОССрезПоследних),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстаткиИОбороты
		|ГДЕ
		|	НЕ ХозрасчетныйОстаткиИОбороты.Регистратор = НЕОПРЕДЕЛЕНО
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СобытияОС.ПериодОстатков,
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	МАКСИМУМ(ХозрасчетныйОстаткиИОбороты.Период) КАК ПоследнийПериод
		|ПОМЕСТИТЬ ХозрасчетныйОстаткиИОборотыСрезПоследнихПериодов
		|ИЗ
		|	СобытияОС КАК СобытияОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиИОбороты КАК ХозрасчетныйОстаткиИОбороты
		|		ПО СобытияОС.ПериодОстатков >= ХозрасчетныйОстаткиИОбороты.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	СобытияОС.ПериодОстатков,
		|	ХозрасчетныйОстаткиИОбороты.Счет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОборотыСрезПоследнихПериодов.ПериодОстатков,
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт
		|ПОМЕСТИТЬ ХозрасчетныйОстаткиИОборотыСрезПоследних
		|ИЗ
		|	ХозрасчетныйОстаткиИОборотыСрезПоследнихПериодов КАК ХозрасчетныйОстаткиИОборотыСрезПоследнихПериодов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиИОбороты КАК ХозрасчетныйОстаткиИОбороты
		|		ПО ХозрасчетныйОстаткиИОборотыСрезПоследнихПериодов.ПоследнийПериод = ХозрасчетныйОстаткиИОбороты.Период
		|			И ХозрасчетныйОстаткиИОборотыСрезПоследнихПериодов.Счет = ХозрасчетныйОстаткиИОбороты.Счет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СобытияОС.НазваниеДокумента,
		|	СобытияОС.НомерДокумента,
		|	СобытияОС.Период,
		|	СобытияОС.Событие,
		|	СобытияОС.Регистратор,
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ,
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
		|	СтоимостьОС.СуммаОборотКт КАК СтоимостьОборот,
		|	АмортизацияОС.СуммаОборотДт КАК АмортизацияОборот,
		|	ВЫБОР
		|		КОГДА СобытияОС.ВидСобытияОС В (ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Списание), ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Передача))
		|			ТОГДА ЕСТЬNULL(СтоимостьОС.СуммаОборотКт, 0) - ЕСТЬNULL(АмортизацияОС.СуммаОборотДт, 0)
		|		ИНАЧЕ ЕСТЬNULL(СтоимостьОС.СуммаКонечныйОстатокДт, 0) - ЕСТЬNULL(АмортизацияОС.СуммаКонечныйОстатокКт, 0)
		|	КОНЕЦ КАК ОстаточнаяСтоимость
		|ИЗ
		|	СобытияОС КАК СобытияОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ МестонахождениеОСБухгалтерскийУчетСрезПоследних КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
		|		ПО СобытияОС.Период = МестонахождениеОСБухгалтерскийУчетСрезПоследних.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ СчетаБухгалтерскогоУчетаОССрезПоследних КАК СчетаБухгалтерскогоУчетаОССрезПоследних
		|		ПО СобытияОС.ПериодОстатков = СчетаБухгалтерскогоУчетаОССрезПоследних.ПериодОстатков
		|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиИОборотыСрезПоследних КАК СтоимостьОС
		|		ПО (СчетаБухгалтерскогоУчетаОССрезПоследних.ПериодОстатков = СтоимостьОС.ПериодОстатков)
		|			И (СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета = СтоимостьОС.Счет)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ХозрасчетныйОстаткиИОборотыСрезПоследних КАК АмортизацияОС
		|		ПО (СчетаБухгалтерскогоУчетаОССрезПоследних.ПериодОстатков = АмортизацияОС.ПериодОстатков)
		|			И (СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации = АмортизацияОС.Счет)";
		ВыборкаЗаписей = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаЗаписей.Следующий() Цикл
			
			ТекущаяОперация = ВыборкаЗаписей.Событие;
			
			СтрокаРаздела4.Параметры.ДатаНомерДокумента = ВыборкаЗаписей.НазваниеДокумента + " № "+ВыборкаЗаписей.НомерДокумента+" от "+Формат(ВыборкаЗаписей.Период,"ДФ=dd.MM.yyyy");
			СтрокаРаздела4.Параметры.ВидОперации        = ТекущаяОперация;
			СтрокаРаздела4.Параметры.ФИОМОЛДвижения     = ВыборкаЗаписей.МОЛ;
			СтрокаРаздела4.Параметры.Подразделение      = ВыборкаЗаписей.Местонахождение;
				
			Если ВыборкаЗаписей.СтоимостьОборот = NULL И ВыборкаЗаписей.АмортизацияОборот = NULL Тогда // ввод начальных остатков
				
				СтрокаРаздела4.Параметры.ОстаточнаяСтоимость = ТекущиеСведенияОС.ПервоначальнаяСтоимость;
				
			Иначе
				
				СтрокаРаздела4.Параметры.ОстаточнаяСтоимость = ВыборкаЗаписей.ОстаточнаяСтоимость;
				
			КонецЕсли;
			
			ТабДок.Вывести(СтрокаРаздела4);
			
		КонецЦикла;
		
		ТабДок.Вывести(ПодвалСтраницы1);
		
		// модернизация ос и ремонт
		ТаблицаМодернизаций = Новый ТаблицаЗначений;
		ТаблицаМодернизаций.Колонки.Добавить("ВидОперации");
		ТаблицаМодернизаций.Колонки.Добавить("Название");
		ТаблицаМодернизаций.Колонки.Добавить("Дата");
		ТаблицаМодернизаций.Колонки.Добавить("Номер");
		ТаблицаМодернизаций.Колонки.Добавить("Сумма");
		
		ТаблицаРемонтов = Новый ТаблицаЗначений;
		ТаблицаРемонтов.Колонки.Добавить("ВидОперации");
		ТаблицаРемонтов.Колонки.Добавить("Название");
		ТаблицаРемонтов.Колонки.Добавить("Дата");
		ТаблицаРемонтов.Колонки.Добавить("Номер");
		ТаблицаРемонтов.Колонки.Добавить("Сумма");
		
		ТабДок.Вывести(ШапкаРазделов5и6);
		
		СписокМодернизаций = Новый Массив;
		СписокМодернизаций.Добавить(Перечисления.ВидыСобытийОС.РаспределениеНДС);
		СписокМодернизаций.Добавить(Перечисления.ВидыСобытийОС.Модернизация);
		СписокМодернизаций.Добавить(Перечисления.ВидыСобытийОС.Достройка);
		СписокМодернизаций.Добавить(Перечисления.ВидыСобытийОС.Реконструкция);
		СписокМодернизаций.Добавить(Перечисления.ВидыСобытийОС.Дооборудование);
		СписокМодернизаций.Добавить(Перечисления.ВидыСобытийОС.ЧастичнаяЛиквидация);
		
		СписокРемонтов = Новый Массив;
		СписокРемонтов.Добавить(Перечисления.ВидыСобытийОС.СреднийРемонт);
		СписокРемонтов.Добавить(Перечисления.ВидыСобытийОС.ТекущийРемонт);
		СписокРемонтов.Добавить(Перечисления.ВидыСобытийОС.КапитальныйРемонт);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", ВыборкаОбъектов.Организация);
		Запрос.УстановитьПараметр("ОсновноеСредство", ВыборкаОбъектов.Ссылка);
		Запрос.УстановитьПараметр("УсловиеМодернизаций",СписокМодернизаций);
		Запрос.УстановитьПараметр("УсловиеРемонтов", СписокРемонтов);
		Запрос.УстановитьПараметр("ВидСобытияОС", Перечисления.ВидыСобытийОС.ПринятиеКУчету);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР КОГДА СобытияОСОрганизаций.Событие.ВидСобытияОС В (&УсловиеМодернизаций) ТОГДА СобытияОСОрганизаций.СуммаЗатратБУ ИНАЧЕ 0 КОНЕЦ КАК СуммаЗатратБУМодернизаций,
		|	ВЫБОР КОГДА СобытияОСОрганизаций.Событие.ВидСобытияОС В (&УсловиеРемонтов) ТОГДА СобытияОСОрганизаций.СуммаЗатратБУ ИНАЧЕ 0 КОНЕЦ КАК СуммаЗатратБУРемонтов,
		|	СобытияОСОрганизаций.Регистратор КАК Регистратор,
		|	СобытияОСОрганизаций.Период КАК Период,
		|	СобытияОСОрганизаций.Событие КАК Операция,
		|	СобытияОСОрганизаций.НомерДокумента КАК НомерДокумента,
		|	ВЫРАЗИТЬ(СобытияОСОрганизаций.НазваниеДокумента КАК СТРОКА(200)) КАК НазваниеДокумента
		|ИЗ
		|	РегистрСведений.СобытияОСОрганизаций КАК СобытияОСОрганизаций
		|
		|ГДЕ
		|	СобытияОСОрганизаций.Организация = &Организация И
		|	СобытияОСОрганизаций.Событие.ВидСобытияОС <> &ВидСобытияОС И
		|	СобытияОСОрганизаций.ОсновноеСредство = &ОсновноеСредство
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период,
		|	Регистратор";
		
		Результат = Запрос.Выполнить();
		
		СпособВыборки = ОбходРезультатаЗапроса.Прямой;
		ВыборкаРегистраторов = Результат.Выбрать(СпособВыборки);
		Пока ВыборкаРегистраторов.Следующий() Цикл
			
			СуммаМодернизаций = ?(ВыборкаРегистраторов.СуммаЗатратБУМодернизаций = NULL, 0, ВыборкаРегистраторов.СуммаЗатратБУМодернизаций);
			СуммаРемонтов = ?(ВыборкаРегистраторов.СуммаЗатратБУРемонтов = NULL, 0, ВыборкаРегистраторов.СуммаЗатратБУРемонтов);
			
			Если СуммаМодернизаций <> 0 Тогда
				СтрокаТаблицыМодернизаций = ТаблицаМодернизаций.Добавить();
				СтрокаТаблицыМодернизаций.ВидОперации = ВыборкаРегистраторов.Операция;
				СтрокаТаблицыМодернизаций.Название    = ВыборкаРегистраторов.НазваниеДокумента;
				СтрокаТаблицыМодернизаций.Номер       = ВыборкаРегистраторов.НомерДокумента;
				СтрокаТаблицыМодернизаций.Дата        = ВыборкаРегистраторов.Период;
				СтрокаТаблицыМодернизаций.Сумма       = СуммаМодернизаций;
			КонецЕсли;
			
			Если СуммаРемонтов <> 0 Тогда
				СтрокаТаблицыРемонтов = ТаблицаРемонтов.Добавить();
				СтрокаТаблицыРемонтов.ВидОперации      = ВыборкаРегистраторов.Операция;
				СтрокаТаблицыРемонтов.Название         = ВыборкаРегистраторов.НазваниеДокумента;
				СтрокаТаблицыРемонтов.Номер            = ВыборкаРегистраторов.НомерДокумента;
				СтрокаТаблицыРемонтов.Дата             = ВыборкаРегистраторов.Период;
				СтрокаТаблицыРемонтов.Сумма            = СуммаРемонтов;
			КонецЕсли;
			
		КонецЦикла;
		
		КоличествоСтрок = Макс(ТаблицаМодернизаций.Количество(),ТаблицаРемонтов.Количество(),1); 
		Для СчетСтрок = 1 По КоличествоСтрок Цикл
			Если СчетСтрок <= ТаблицаМодернизаций.Количество() Тогда
				СтрокаТаблицы = ТаблицаМодернизаций.Получить(СчетСтрок - 1);
				СтрокаРазделов5и6.Параметры.Модернизация          = СтрокаТаблицы.ВидОперации;
				СтрокаРазделов5и6.Параметры.ДокМодернизации       = СтрокаТаблицы.Название;
				СтрокаРазделов5и6.Параметры.ДокМодернизацииДата   = СтрокаТаблицы.Дата;
				СтрокаРазделов5и6.Параметры.ДокМодернизацииНомер  = СтрокаТаблицы.Номер;
				СтрокаРазделов5и6.Параметры.ЗатратыНаМодернизацию = СтрокаТаблицы.Сумма; 
			Иначе
				СтрокаРазделов5и6.Параметры.Модернизация          = "";
				СтрокаРазделов5и6.Параметры.ДокМодернизации       = "";
				СтрокаРазделов5и6.Параметры.ДокМодернизацииДата   = "";
				СтрокаРазделов5и6.Параметры.ДокМодернизацииНомер  = "";
				СтрокаРазделов5и6.Параметры.ЗатратыНаМодернизацию = ""; 
			КонецЕсли;
			
			Если СчетСтрок <= ТаблицаРемонтов.Количество() Тогда
				СтрокаТаблицыРемонтов = ТаблицаРемонтов.Получить(СчетСтрок - 1);
				СтрокаРазделов5и6.Параметры.Ремонт          = СтрокаТаблицыРемонтов.ВидОперации;
				СтрокаРазделов5и6.Параметры.ДокРемонта      = СтрокаТаблицыРемонтов.Название;
				СтрокаРазделов5и6.Параметры.ДокРемонтаДата  = СтрокаТаблицыРемонтов.Дата;
				СтрокаРазделов5и6.Параметры.ДокРемонтаНомер = СтрокаТаблицыРемонтов.Номер;
				СтрокаРазделов5и6.Параметры.ЗатратыНаРемонт = СтрокаТаблицыРемонтов.Сумма;
			Иначе
				СтрокаРазделов5и6.Параметры.Ремонт          = "";
				СтрокаРазделов5и6.Параметры.ДокРемонта      = "";
				СтрокаРазделов5и6.Параметры.ДокРемонтаДата  = "";
				СтрокаРазделов5и6.Параметры.ДокРемонтаНомер = "";
				СтрокаРазделов5и6.Параметры.ЗатратыНаРемонт = "";
			КонецЕсли;
			
			ТабДок.Вывести(СтрокаРазделов5и6);
		КонецЦикла;
		
		ТабДок.Вывести(ШапкаРаздела7_1);
		ТабДок.Вывести(ШапкаРаздела7_2);
		ТабДок.Вывести(ПодвалСтраницы2);
		
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаОбъектов.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС6") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ОС6", НСтр("ru = 'Инвентарная карточка ОС (ОС-6)'"), ПечатьОС6_2003(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли