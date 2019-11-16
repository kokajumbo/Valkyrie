#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
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

// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Документ.ПереоценкаТоваровВРознице КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("СинонимТовары", НСтр("ru = 'Товары'"));

	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРеквизиты(НомераТаблиц)
		+ ТекстЗапросаТаблицаТовары(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизиты(НомераТаблиц)

	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	""Переоценка товаров в рознице"" КАК Содержание,
	|	Реквизиты.Склад.ТипСклада КАК ТипСклада,
	|	ВЫБОР
	|		КОГДА Реквизиты.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НТТ,
	|	ВЫБОР
	|		КОГДА Реквизиты.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК АТТ
	|ИЗ
	|	Документ.ПереоценкаТоваровВРознице КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаТаблицаТовары(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаТовары", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	""Товары"" КАК ИмяСписка,
	|	&СинонимТовары КАК СинонимСписка,
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Ссылка.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахАТТ)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ)
	|	КОНЕЦ КАК СчетУчета,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Ссылка.Склад КАК Склад,
	|	ТаблицаТовары.Ссылка.Дата КАК Период,
	|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
	|	0 КАК Себестоимость,
	|	ТаблицаТовары.Количество,
	|	НЕОПРЕДЕЛЕНО КАК Комитент,
	|	НЕОПРЕДЕЛЕНО КАК ДоговорКомиссии,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетАвансовСКомитентом,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетРасчетовСКомитентом,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаРасчетовСКомитентом,
	|	0 КАК СуммаРасчетовСКомитентом,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Ссылка.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТорговаяНаценкаАТТ)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТорговаяНаценкаНТТ)
	|	КОНЕЦ КАК КорСчетСписания,
	|	НЕОПРЕДЕЛЕНО КАК КорСубконто1,
	|	НЕОПРЕДЕЛЕНО КАК КорСубконто2,
	|	НЕОПРЕДЕЛЕНО КАК КорСубконто3,
	|	НЕОПРЕДЕЛЕНО КАК ВидКорСубконто1,
	|	НЕОПРЕДЕЛЕНО КАК ВидКорСубконто2,
	|	НЕОПРЕДЕЛЕНО КАК ВидКорСубконто3,
	|	ТаблицаТовары.Ссылка.ПодразделениеОрганизации КАК КорПодразделение,
	|	ТаблицаТовары.ЦенаВРозницеСтарая,
	|	ТаблицаТовары.ЦенаВРознице,
	|	ТаблицаТовары.СтавкаНДСВРознице,
	|	ТаблицаТовары.СуммаПереоценки
	|ИЗ
	|	Документ.ПереоценкаТоваровВРознице.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаТовары.НомерСтроки";

	Возврат ТекстЗапроса;

КонецФункции

// ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ДВИЖЕНИЙ

Процедура СформироватьДвиженияПереоценкаТоваровНТТ(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ) Экспорт

	Реквизиты = ТаблицаРеквизиты[0];
	Если Не Реквизиты.НТТ Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыПереоценкаТоваровНТТ(ТаблицаТовары, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	ПроводкиБУ = Движения.Хозрасчетный;
	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаТовары Цикл

		СубконтоСтавкиНДС = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС;
		СчетУчета = СтрокаТаблицы.СчетУчета;
		РазделятьПоСтавкамНДС = СчетУчета.ВидыСубконто.Найти(СубконтоСтавкиНДС, "ВидСубконто") <> Неопределено;

		СуммаПереоценки = СтрокаТаблицы.СуммаПереоценки;

		Если СуммаПереоценки <> 0 Тогда

			Проводка = ПроводкиБУ.Добавить();
			Проводка.Период      = Реквизиты.Период;
			Проводка.Регистратор = Реквизиты.Регистратор;
			Проводка.Организация = Реквизиты.Организация;
			Проводка.Содержание  = Реквизиты.Содержание;

			Проводка.СчетДт      = СчетУчета;
			Проводка.СчетКт      = СтрокаТаблицы.КорСчетСписания;

			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Склады", СтрокаТаблицы.Склад);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Склады", СтрокаТаблицы.Склад);

			Если РазделятьПоСтавкамНДС Тогда
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт,
														"СтавкиНДС", СтрокаТаблицы.СтавкаНДСВРознице);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,
														"СтавкиНДС", СтрокаТаблицы.СтавкаНДСВРознице);
			КонецЕсли;

			Проводка.Сумма       = СуммаПереоценки;

			БухгалтерскийУчет.УстановитьПодразделенияПроводки(
				Проводка, Реквизиты.Подразделение, Реквизиты.Подразделение);

		КонецЕсли;

	КонецЦикла;

	Движения.Хозрасчетный.Записывать = Истина;

КонецПроцедуры

Функция ПодготовитьПараметрыПереоценкаТоваровНТТ(ТаблицаТовары, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы шапки документа.
	СписокОбязательныхКолонок = ""
	+ "Период,"         	// <Дата> - дата докумета, записывающего движения
	+ "Регистратор,"    	// <Регистратор...> - документ, записывающий движения в регистры
	+ "Организация,"		// <СправочникСсылка.Организации> - организация документа
	+ "Подразделение,"		// <Ссылка на справочник подразделений>
	+ "Содержание,"			// <Строка> - содержание проводки
	+ "НТТ"                 // <Булево> - признак того, что вид склада документа является НТТ
	;
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты,
																		СписокОбязательныхКолонок));

	// Подготовка таблицы товаров документа, по которым проводится переоценка.
	СписокОбязательныхКолонок = ""
	+ "Склад,"				// <СправочникСсылка.Склады> - склад из шапки документа
	+ "СчетУчета,"          // <ПланСчетовСсылка.Хозрасчетный> - счет учета, с которого списывается номенклатура
	+ "КорСчетСписания,"    // <ПланСчетовСсылка.Хозрасчетный> - счет учета, на который списывается номенклатура
	+ "СуммаПереоценки,"	// 	<Число(15,2)> - сумма переоценки
	+ "СтавкаНДСВРознице"	//	<ПеречислениеСсылка.СтавкиНДС> - ставка НДС в рознице
	;
	Параметры.Вставить("ТаблицаТовары", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаТовары,
																		СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

Процедура СформироватьДвиженияПереоценкаТоваровАТТ(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ) Экспорт

	Реквизиты = ТаблицаРеквизиты[0];
	Если Не Реквизиты.АТТ Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыПереоценкаТоваровAТТ(ТаблицаТовары, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	// Таблица списанных товаров.
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары,
		ТаблицаРеквизиты , Отказ);

	Для каждого СтрокаТаблицыТоваров Из ТаблицаТовары Цикл

		СтруктраОтбора = Новый Структура("Номенклатура", СтрокаТаблицыТоваров.Номенклатура);
		СтрокиПартий = ТаблицаСписанныеТовары.НайтиСтроки(СтруктраОтбора);

		Для каждого СтрокаПартии Из СтрокиПартий Цикл

			Если СтрокаПартии.СуммаСписания = 0 Тогда
				// Это строка с товарами, которые не списались.
				Продолжить;
			КонецЕсли;

			СуммаПереоценки = СтрокаПартии.Количество*СтрокаТаблицыТоваров.ЦенаВРознице
							- СтрокаПартии.СуммаСписания; // (Стоимость)

			Если СуммаПереоценки = 0 Тогда
				// Нет наценки.
				Продолжить;
			КонецЕсли;

			Проводка = Движения.Хозрасчетный.Добавить();
			Проводка.Период      = Реквизиты.Период;
			Проводка.Организация = Реквизиты.Организация;
			Проводка.Содержание  = Реквизиты.Содержание;

			Проводка.СчетДт      = СтрокаПартии.СчетУчета;
			Проводка.СчетКт      = СтрокаПартии.КорСчетСписания;

			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Склады",  СтрокаПартии.Склад);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Склады",  СтрокаПартии.Склад);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт,
																	"Номенклатура",  СтрокаПартии.Номенклатура);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,
																	"Номенклатура",  СтрокаПартии.Номенклатура);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Партии",  СтрокаПартии.Партия);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Партии",  СтрокаПартии.Партия);

			БухгалтерскийУчет.УстановитьПодразделенияПроводки(
					Проводка, Реквизиты.Подразделение, Реквизиты.Подразделение);

			Проводка.Сумма       = СуммаПереоценки;

			НалоговыйУчет.ЗаполнитьНалоговыеСуммыПроводки(,СуммаПереоценки,,,,,Проводка);

		КонецЦикла;

	КонецЦикла;

	Движения.Хозрасчетный.Записывать = Истина;

КонецПроцедуры

Функция ПодготовитьПараметрыПереоценкаТоваровAТТ(ТаблицаТовары, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы шапки документа.
	СписокОбязательныхКолонок = ""
	+ "Регистратор,"    	// <Регистратор...> - документ, записывающий движения в регистры
	+ "Период,"         	// <Дата> - дата докумета, записывающего движения
	+ "Организация,"		// <СправочникСсылка.Организации> - организация документа
	+ "Подразделение,"		// <Ссылка на справочник подразделений>
	+ "Содержание,"			// <Строка> - содержание проводки
	+ "АТТ"                 // <Булево> - признак того, что вид склада документа является розничным
	;
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты,
																		СписокОбязательныхКолонок));

	СписокОбязательныхКолонок = ""
	+ "ИмяСписка,"             // <Строка,0> - имя списка в документе
	+ "СинонимСписка,"         // <Строка,0> - синоним списка
	+ "НомерСтроки,"           // <Число> - номер строки в списке
	+ "СчетУчета,"             // <ПланСчетовСсылка.Хозрасчетный> - счет учета, с которого списывается номенклатура
	+ "Номенклатура,"          // <СправочникСсылка.Номенклатура> - списываемая номенклатура
	+ "Склад,"                 // <СправочникСсылка.Склад> - склад, с которого списывается номенклатура
	+ "ДокументОприходования," // <ДокументСсылка.*> - документ поступления номенклатуры (партия),
							   // указанный в документе списания
	+ "Себестоимость,"         // <Число,15,2> - сумма списываемой номенклатуры, указанная в документе списания
	+ "Количество,"            // <Число,15,3> - количество списываемой номенклатуры
	+ "ЦенаВРознице,"          // <Число,15,2> - цена товара в рознице
	+ "КорСчетСписания,"       // <ПланСчетовСсылка.Хозрасчетный> - счет учета, на который списывается номенклатура
	+ "ВидКорСубконто1,"       // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> -
							   // вид субконто счета, на который списывается номенклатура
	+ "ВидКорСубконто2,"       // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> -
							   // вид субконто счета, на который списывается номенклатура
	+ "ВидКорСубконто3,"       // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> -
							   // вид субконто счета, на который списывается номенклатура
	+ "КорСубконто1,"          // - значение субконто счета, на который списывается номенклатура
	+ "КорСубконто2,"          // - значение субконто счета, на который списывается номенклатура
	+ "КорСубконто3,"          // - значение субконто счета, на который списывается номенклатура
	+ "КорПодразделение";      // <Ссылка на справочник подразделений> - подразделение, в которое списывается номенклатура

	Параметры.Вставить("ТаблицаТовары",
		ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаТовары, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Переоценка товаров в рознице
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПереоценкаТоваровВНТТ";
	КомандаПечати.Представление = НСтр("ru = 'Переоценка товаров в рознице'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Переоценка товаров в рознице""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьПереоценкиТоваровВРознице(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПереоценкаТоваровВРознице_ПереоценкаТоваровВРознице";

	ДополнительнаяКолонкаПечатныхФормДокументов = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если НЕ ЗначениеЗаполнено(ДополнительнаяКолонкаПечатныхФормДокументов) Тогда
		ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	КонецЕсли;
 	ВыводитьКоды = ДополнительнаяКолонкаПечатныхФормДокументов <> Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ДополнительнаяКолонкаПечатныхФормДокументов", ДополнительнаяКолонкаПечатныхФормДокументов);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПереоценкаТоваровВНТТ.Ссылка,
	|	ПереоценкаТоваровВНТТ.Номер,
	|	ПереоценкаТоваровВНТТ.Дата,
	|	ПереоценкаТоваровВНТТ.Организация,
	|	ПереоценкаТоваровВНТТ.Организация КАК Поставщик,
	|	ПереоценкаТоваровВНТТ.Склад КАК Получатель,
	|	ПереоценкаТоваровВНТТ.Склад.Представление КАК ПредставлениеПолучателя,
	|	ПереоценкаТоваровВНТТ.Товары.(
	|		НомерСтроки,
	|		Количество,
	|		Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		ВЫБОР
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул)
	|				ТОГДА ПереоценкаТоваровВНТТ.Товары.Номенклатура.Артикул
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Код)
	|				ТОГДА ПереоценкаТоваровВНТТ.Товары.Номенклатура.Код
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить)
	|				ТОГДА """"
	|		КОНЕЦ КАК КодАртикул,
	|		Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|		ЦенаВРозницеСтарая,
	|		ЦенаВРознице
	|	)
	|ИЗ
	|	Документ.ПереоценкаТоваровВРознице КАК ПереоценкаТоваровВНТТ
	|ГДЕ
	|	ПереоценкаТоваровВНТТ.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПереоценкаТоваровВНТТ.Дата,
	|	ПереоценкаТоваровВНТТ.Ссылка,
	|	ПереоценкаТоваровВНТТ.Товары.НомерСтроки";

	Шапка = Запрос.Выполнить().Выбрать();

	ПервыйДокумент = Истина;

	Пока Шапка.Следующий() Цикл

		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

  		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПереоценкаТоваровВРознице.ПФ_MXL_ПереоценкаТоваровВРознице");


		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка,
																					"Переоценка товаров в рознице");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);

		СведенияОбОрганизации 	 = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата);
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,
																					"НаименованиеДляПечатныхФорм,");
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеОрганизации;
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьШапки = ?(ВыводитьКоды, "ШапкаСКодом", "ШапкаТаблицы");
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = "Артикул";
		ИначеЕсли ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = "Код";
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьСтроки = ?(ВыводитьКоды,	"СтрокаСКодом", "Строка");
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);

		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
		Пока ВыборкаСтрокТовары.Следующий() Цикл

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.Товар = ВыборкаСтрокТовары.Товар;
			ТабличныйДокумент.Вывести(ОбластьМакета);

		КонецЦикла;

		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		// В табличном документе зададим имя области, в которую был
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции // ПечатьПереоценкиТоваровВРознице()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,ОбъектыПечати, ПараметрыВывода) Экспорт

	// Проверяем, нужно ли для макета ПереоценкаТоваровВНТТ формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПереоценкаТоваровВНТТ") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПереоценкаТоваровВНТТ", "Переоценка товаров в рознице",
			ПечатьПереоценкиТоваровВРознице(МассивОбъектов, ОбъектыПечати), , "Документ.ПереоценкаТоваровВРознице.ПФ_MXL_ПереоценкаТоваровВРознице");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Склад");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли