#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
							
	Возврат Результат;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	НаборыДанных = ПараметрыОтчета.СхемаКомпоновкиДанных.НаборыДанных;
	Если НаборыДанных.Найти("ВнешнийИсточник") = Неопределено
	 Или НаборыДанных.ВнешнийИсточник.ИмяОбъекта <> "ТаблицаКоэффициентов" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СписокДоступныхОрганизаций = ОбщегоНазначенияБП.СписокДоступныхОрганизаций(
									ПараметрыОтчета.Организация,
									ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	Если СписокДоступныхОрганизаций.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КонецПериодаОтчета = КонецДня(ПараметрыОтчета.КонецПериода);
	
	МетодРаспределения = УчетнаяПолитика.МетодРаспределенияРасходовУСНПоВидамДеятельности(ПараметрыОтчета.Организация, КонецПериодаОтчета);
	Метод = ?(МетодРаспределения = Перечисления.МетодыРаспределенияРасходовУСНПоВидамДеятельности.НарастающимИтогомСНачалаГода, "Год", "Квартал");
	
	БазаРаспределения  = УчетнаяПолитика.БазаРаспределенияРасходовУСНПоВидамДеятельности(ПараметрыОтчета.Организация, КонецПериодаОтчета);
	Если БазаРаспределения = Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыВсегоНУ Тогда
		База = "НВ";
	ИначеЕсли БазаРаспределения = Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыПринимаемыеНУ Тогда
		База = "НУ";
	Иначе
		База = "БУ";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",     ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",      КонецПериодаОтчета);
	Запрос.УстановитьПараметр("СписокОрганизаций", СписокДоступныхОрганизаций);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегламентнаяОперация.Ссылка КАК Документ,
	|	РегламентнаяОперация.Дата КАК ДатаДокумента
	|ИЗ
	|	Документ.РегламентнаяОперация КАК РегламентнаяОперация
	|ГДЕ
	|	РегламентнаяОперация.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыРегламентныхОпераций.РаспределениеРасходовПоВидамДеятельностиДляУСН)
	|	И РегламентнаяОперация.Организация В(&СписокОрганизаций)
	|	И РегламентнаяОперация.Дата МЕЖДУ &НачалоПериода И &КонецПериода";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаКоэффициентов = Запрос.Выполнить().Выгрузить();
	КолонкиТаблицыКоэффициентов = ТаблицаКоэффициентов.Колонки;
	КолонкиТаблицыКоэффициентов.Добавить("Коэфф", Новый ОписаниеТипов("Число"));
	
	Для Каждого Строка Из ТаблицаКоэффициентов Цикл				
		Строка.Коэфф = ПолучитьКоэффРаспределенияЕНВД(СписокДоступныхОрганизаций, Строка.ДатаДокумента, Метод, База);				
	КонецЦикла;
	
	КолонкиТаблицыКоэффициентов.Удалить("ДатаДокумента");
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаКоэффициентов", ТаблицаКоэффициентов);
	
	Возврат ВнешниеНаборыДанных;			
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьПараметрОрганизация(КомпоновщикНастроек, ПараметрыОтчета.Организация);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "ДатаИзмененияУПпоНДС", ПараметрыОтчета.ДатаИзмененияУПпоНДС);
	
	Если НЕ ПараметрыОтчета.КоллекцияНастроек.ЗначениеРасшифровки = Неопределено 
		И НЕ КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ПараметрыОтчета.КоллекцияНастроек.ЗначениеРасшифровки.ИмяПараметра) = Неопределено Тогда		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек,
			ПараметрыОтчета.КоллекцияНастроек.ЗначениеРасшифровки.ИмяПараметра,
			ПараметрыОтчета.КоллекцияНастроек.ЗначениеРасшифровки.ЗначениеПараметра);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт 
	
	Макет = Отчеты.АнализСостоянияНалоговогоУчетаПоУСН.ПолучитьМакет("МакетЗаголовкаРасшифровки");
	
	ОбластьОтчета = Макет.ПолучитьОбласть("Заголовок");
	
	НаименованиеОрганизации                = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОтчета.Параметры.ТекстЗаголовка = НаименованиеОрганизации + ", " + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	Результат.Вывести(ОбластьОтчета);
	
	Если СтрНайти(ПараметрыОтчета.КоллекцияНастроек.ИмяФормируемогоМакета, "МакетРасшифровкиНоменклатурыПоДокументам") Тогда
		
		ЗначениеПараметраРасшифровки = ПараметрыОтчета.КоллекцияНастроек.ЗначениеРасшифровки.ЗначениеПараметра;
		
		Если ЗначениеЗаполнено(ЗначениеПараметраРасшифровки) Тогда
			
			НоменклатураНаименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеПараметраРасшифровки, "Наименование");
			
			ОбластьОтчета = Макет.ПолучитьОбласть("Заголовок");
			ОбластьОтчета.Параметры.ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Номенклатура: ""%1""'"),
				НоменклатураНаименование);
			
			Результат.Вывести(ОбластьОтчета);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСхемуНалоговойБазы(Знач ПараметрыОтчета, АдресХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяМакетаКарты = "МакетКарты";
	НастройкиКлиента = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения");
	Если ТипЗнч(НастройкиКлиента) = Тип("НастройкиКлиентскогоПриложения") 
		И НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		ИмяМакетаКарты = "МакетКарты82";
	КонецЕсли;
	РезультатСхема = Отчеты.АнализСостоянияНалоговогоУчетаПоУСН.ПолучитьМакет(ИмяМакетаКарты);
	
	ВыделятьНДСУСН = ВыделятьНДСУСН(ПараметрыОтчета);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",      ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("НачалоПериода",    ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",     КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("РозничнаяВыручка", Перечисления.ВидыОперацийПКО.РозничнаяВыручка);
	Запрос.УстановитьПараметр("КартыИКредиты",    Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам);
	Запрос.УстановитьПараметр("СПокупателем",     Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	Запрос.УстановитьПараметр("СКомиссионером",   Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);
	Запрос.УстановитьПараметр("СКомитентом",      Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
	Запрос.УстановитьПараметр("СКомитентомНаЗакупку",      Перечисления.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(КнигаУчетаДоходовИРасходов.Графа5) КАК Графа5,
	|	ВЫБОР
	|		КОГДА КнигаУчетаДоходовИРасходов.ЭтапПроведения = -1
	|			ТОГДА ""Курсовая разница""
	|		КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|				ИЛИ ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВидОперации = &РозничнаяВыручка
	|			ТОГДА ""Розничная выручка""
	|		КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.СписаниеСРасчетногоСчета
	|			ТОГДА ""Сторно доходов при возврате аванса покупателю""
	|		КОГДА ПриходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СПокупателем
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СПокупателем
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Ссылка.ВидОперации = &КартыИКредиты
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РеализацияОтгруженныхТоваров
	|			ТОГДА ""Поступления от покупателей""
	|		КОГДА ПриходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СКомиссионером
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СКомиссионером
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетКомиссионераОПродажах
	|			ТОГДА ""Поступления от комиссионеров""
	|		КОГДА ПриходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора В (&СКомитентом, &СКомитентомНаЗакупку)
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора В (&СКомитентом, &СКомитентомНаЗакупку)
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетКомитентуОПродажах
	|			ТОГДА ""Комиссионное вознаграждение""
	|		ИНАЧЕ ""Доходы, отраженные вручную""
	|	КОНЕЦ КАК Содержание
	|ИЗ
	|	РегистрНакопления.КнигаУчетаДоходовИРасходов КАК КнигаУчетаДоходовИРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеНаРасчетныйСчет.РасшифровкаПлатежа КАК ПлатежноеПоручениеВходящееРасшифровкаПлатежа
	|		ПО КнигаУчетаДоходовИРасходов.Регистратор = ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Ссылка
	|			И (ПлатежноеПоручениеВходящееРасшифровкаПлатежа.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеСРасчетногоСчета.РасшифровкаПлатежа КАК ПлатежноеПоручениеИсходящееРасшифровкаПлатежа
	|		ПО КнигаУчетаДоходовИРасходов.Регистратор = ПлатежноеПоручениеИсходящееРасшифровкаПлатежа.Ссылка
	|			И (ПлатежноеПоручениеИсходящееРасшифровкаПлатежа.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
	|		ПО КнигаУчетаДоходовИРасходов.Регистратор = РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка
	|			И (РасходныйКассовыйОрдерРасшифровкаПлатежа.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ПриходныйКассовыйОрдерРасшифровкаПлатежа
	|		ПО КнигаУчетаДоходовИРасходов.Регистратор = ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка
	|			И (ПриходныйКассовыйОрдерРасшифровкаПлатежа.НомерСтроки = 1)
	|ГДЕ
	|	КнигаУчетаДоходовИРасходов.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И КнигаУчетаДоходовИРасходов.Организация = &Организация
	|	И КнигаУчетаДоходовИРасходов.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА КнигаУчетаДоходовИРасходов.ЭтапПроведения = -1
	|			ТОГДА ""Курсовая разница""
	|		КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|				ИЛИ ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВидОперации = &РозничнаяВыручка
	|			ТОГДА ""Розничная выручка""
	|		КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.СписаниеСРасчетногоСчета
	|			ТОГДА ""Сторно доходов при возврате аванса покупателю""
	|		КОГДА ПриходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СПокупателем
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СПокупателем
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Ссылка.ВидОперации = &КартыИКредиты
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РеализацияОтгруженныхТоваров
	|			ТОГДА ""Поступления от покупателей""
	|		КОГДА ПриходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СКомиссионером
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора = &СКомиссионером
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетКомиссионераОПродажах
	|			ТОГДА ""Поступления от комиссионеров""
	|		КОГДА ПриходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора В (&СКомитентом, &СКомитентомНаЗакупку)
	|				ИЛИ ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента.ВидДоговора В (&СКомитентом, &СКомитентомНаЗакупку)
	|				ИЛИ КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ОтчетКомитентуОПродажах
	|			ТОГДА ""Комиссионное вознаграждение""
	|		ИНАЧЕ ""Доходы, отраженные вручную""
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	СУММА(КнигаУчетаДоходовИРасходов.Графа5) <> 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЭлементыСхемы = РезультатСхема.ЭлементыГрафическойСхемы;
	
	ВсегоДоходов = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ВсегоДоходов = ВсегоДоходов + Выборка.Графа5;
		
		Если СокрЛП(Выборка.Содержание) = "Розничная выручка" Тогда
			
			ЭлементыСхемы.РозничнаяВыручка.Наименование = Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		ИначеЕсли СокрЛП(Выборка.Содержание) = "Сторно доходов при возврате аванса покупателю" Тогда
			
			ЭлементыСхемы.ВозвратАвансов.Наименование = Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		ИначеЕсли СокрЛП(Выборка.Содержание) = "Поступления от покупателей" Тогда
			
			ЭлементыСхемы.ПоступленияОтПокупателей.Наименование	= Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		ИначеЕсли СокрЛП(Выборка.Содержание) = "Поступления от комиссионеров" Тогда
			
			ЭлементыСхемы.ПоступленияОтКомиссионеров.Наименование = Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		ИначеЕсли СокрЛП(Выборка.Содержание) = "Комиссионное вознаграждение" Тогда
			
			ЭлементыСхемы.КомиссионноеВознаграждение.Наименование = Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		ИначеЕсли СокрЛП(Выборка.Содержание) = "Курсовая разница" Тогда
			
			ЭлементыСхемы.КурсовыеРазницы.Наименование = Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		ИначеЕсли СокрЛП(Выборка.Содержание) = "Доходы, отраженные вручную" Тогда
			
			ЭлементыСхемы.ДоходыВручную.Наименование = Формат(Выборка.Графа5, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЭлементыСхемы.ДоходыВсего.Наименование = Формат(ВсегоДоходов, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
	
	ЭлементыСхемы.ТекстНДС.Наименование = ?(ВыделятьНДСУСН, "НДС, предъявленный поставщиком", "Сторно НДС прошлых периодов");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",      ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("НачалоПериода",    ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",     КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("ПустойВидРасхода", Перечисления.ВидыРасходовУСН.ПустаяСсылка());
	Запрос.УстановитьПараметр("Номенклатура",     Перечисления.ВидыРасходовУСН.Номенклатура);
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	СУММА(КнигаУчетаДоходовИРасходов.Графа7) КАК Графа7,
	|	СУММА(КнигаУчетаДоходовИРасходов.НДС) КАК НДС,
	|	ВЫБОР
	|		КОГДА КнигаУчетаДоходовИРасходов.ВидРасхода = &ПустойВидРасхода
	|			ТОГДА ВЫБОР
	|					КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|						ТОГДА &Номенклатура
	|					КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РегламентнаяОперация
	|							И КнигаУчетаДоходовИРасходов.ЭтапПроведения = 2
	|						ТОГДА ""Распределение по видам деятельности""
	|					ИНАЧЕ ""Прочее""
	|				КОНЕЦ
	|		ИНАЧЕ КнигаУчетаДоходовИРасходов.ВидРасхода
	|	КОНЕЦ КАК ВидРасхода
	|ИЗ
	|	РегистрНакопления.КнигаУчетаДоходовИРасходов КАК КнигаУчетаДоходовИРасходов
	|ГДЕ
	|	КнигаУчетаДоходовИРасходов.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И КнигаУчетаДоходовИРасходов.Организация = &Организация
	|	И КнигаУчетаДоходовИРасходов.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА КнигаУчетаДоходовИРасходов.ВидРасхода = &ПустойВидРасхода
	|			ТОГДА ВЫБОР
	|					КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|						ТОГДА &Номенклатура
	|					КОГДА КнигаУчетаДоходовИРасходов.Регистратор ССЫЛКА Документ.РегламентнаяОперация
	|							И КнигаУчетаДоходовИРасходов.ЭтапПроведения = 2
	|						ТОГДА ""Распределение по видам деятельности""
	|					ИНАЧЕ ""Прочее""
	|				КОНЕЦ
	|		ИНАЧЕ КнигаУчетаДоходовИРасходов.ВидРасхода
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	(СУММА(КнигаУчетаДоходовИРасходов.Графа7) <> 0
	|		ИЛИ СУММА(КнигаУчетаДоходовИРасходов.НДС) <> 0)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВсегоРасходов = 0;
	Пока Выборка.Следующий() Цикл
		ВсегоРасходов = ВсегоРасходов + Выборка.Графа7;
		
		Если ТипЗнч(Выборка.ВидРасхода) = Тип("ПеречислениеСсылка.ВидыРасходовУСН") Тогда
			
			Если Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.Номенклатура Тогда
				
				ЭлементыСхемы.Номенклатура.Наименование    = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				ЭлементыСхемы.НДСНоменклатура.Наименование = ?(ВыделятьНДСУСН или Выборка.НДС = 0, "", "в т.ч. НДС: " + Формат(Выборка.НДС, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '"));
				
			ИначеЕсли Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.ДопРасходы Тогда
				
				ЭлементыСхемы.ДопРасходы.Наименование    = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				ЭлементыСхемы.НДСДопРасходы.Наименование = ?(ВыделятьНДСУСН или Выборка.НДС = 0, "", "в т.ч. НДС: " + Формат(Выборка.НДС, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '"));
				
			ИначеЕсли Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.Услуги Тогда
				
				ЭлементыСхемы.Услуги.Наименование    = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				ЭлементыСхемы.НДСУслуги.Наименование = ?(ВыделятьНДСУСН или Выборка.НДС = 0, "", "в т.ч. НДС: " + Формат(Выборка.НДС, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '"));
				
			ИначеЕсли Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.РБП Тогда
				
				ЭлементыСхемы.РБП.Наименование    = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				ЭлементыСхемы.НДСРБП.Наименование = ?(ВыделятьНДСУСН или Выборка.НДС = 0, "", "в т.ч. НДС: " + Формат(Выборка.НДС, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '"));
				
			ИначеЕсли Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.НДС Тогда
				
				ЭлементыСхемы.НДС.Наименование = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				
			ИначеЕсли Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.Зарплата Тогда
				
				ЭлементыСхемы.Зарплата.Наименование = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				
			ИначеЕсли Выборка.ВидРасхода = Перечисления.ВидыРасходовУСН.Налоги Тогда
				
				ЭлементыСхемы.Налоги.Наименование = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Выборка.ВидРасхода) = Тип("Строка") Тогда
			
			Если СокрЛП(Выборка.ВидРасхода) = "Распределение по видам деятельности" Тогда
				
				ЭлементыСхемы.Распределение.Наименование	= Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				ЭлементыСхемы.НДСРаспределение.Наименование	= ?(ВыделятьНДСУСН или Выборка.НДС = 0, "", "в т.ч. НДС: " + Формат(Выборка.НДС, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '"));
				
			ИначеЕсли СокрЛП(Выборка.ВидРасхода) = "Прочее" Тогда
				
				ЭлементыСхемы.Прочее.Наименование    = Формат(Выборка.Графа7, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
				ЭлементыСхемы.НДСПрочее.Наименование = ?(ВыделятьНДСУСН или Выборка.НДС = 0, "", "в т.ч. НДС: " + Формат(Выборка.НДС, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '"));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЭлементыСхемы.РасходыВсего.Наименование = Формат(ВсегоРасходов, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
	ЭлементыСхемы.УсловнаяБаза.Наименование = Формат(ВсегоДоходов - ВсегоРасходов, "ЧЦ=20; ЧДЦ=2; ЧРГ=' '");
	
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("РезультатСхема", РезультатСхема);
	
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура СформироватьРасшифровку(Знач ПараметрыОтчета, АдресХранилища) Экспорт
	
	ЗначениеРасшифровки = ?(ТипЗнч(ПараметрыОтчета.Расшифровка) = Тип("Структура"), ПараметрыОтчета.Расшифровка, Неопределено);
			
	ПараметрыОтчета.КоллекцияНастроек.Вставить("ИмяФормируемогоМакета",	ПараметрыОтчета.ИмяМакета);
	ПараметрыОтчета.КоллекцияНастроек.Вставить("ЗначениеРасшифровки",	ЗначениеРасшифровки);
	
	СхемаКомпоновкиДанных = Отчеты.АнализСостоянияНалоговогоУчетаПоУСН.ПолучитьМакет(ПараметрыОтчета.ИмяМакета);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ПолучитьНастройкуМакета(ПараметрыОтчета, СхемаКомпоновкиДанных));
	
	ПараметрыОтчета.КоллекцияНастроек.Вставить("ИдентификаторМакета", ПараметрыОтчета.ИмяМакета);
	
	ОтключениеТаблиц(КомпоновщикНастроек, ПараметрыОтчета.ОтключитьТаблицы, ПараметрыОтчета.Расшифровка);
	
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок");
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал");
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВыводитьЗаголовок = Истина;
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВыводитьПодвал	   = Ложь;
	
	
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"        , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"    , СхемаКомпоновкиДанных);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "АнализСостоянияНалоговогоУчетаПоУСН");
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных", КомпоновщикНастроек.ПолучитьНастройки());
	
	АдресПромежуточногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресПромежуточногоХранилища);
	ПромежуточныйРезультатВыполнения = ПолучитьИзВременногоХранилища(АдресПромежуточногоХранилища);
	ДокументРезультат = ПромежуточныйРезультатВыполнения.Результат;
	
	РезультатВыполнения = Новый Структура;
	КэшОтчетов = ПараметрыОтчета.КэшОтчетов;
	Если СтрНайти(ПараметрыОтчета.ИмяМакета, "МакетРасшифровкиПоНоменклатуре") Тогда		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Вывести(ДокументРезультат);
		Структура = Новый Структура;
		Структура.Вставить("Результат", 	 	ТабличныйДокумент);
		Структура.Вставить("ФиксацияСверху",   	ДокументРезультат.ФиксацияСверху);
		ДанныеРасшифровкиОбъект = ПолучитьИзВременногоХранилища(ПромежуточныйРезультатВыполнения.ДанныеРасшифровки);
		ДанныеРасшифровкиОбъект.Объект.Вставить("КэшОтчетов", Неопределено);
		Структура.Вставить("ДанныеРасшифровки", ПоместитьВоВременноеХранилище(ДанныеРасшифровкиОбъект, Новый УникальныйИдентификатор));
		КэшОтчетов.Вставить(ПараметрыОтчета.ИмяМакета, Структура);		
		
		РезультатВыполнения.Вставить("ИмяМакета", ПараметрыОтчета.ИмяМакета);
	КонецЕсли;
	
	
	РезультатВыполнения.Вставить("Результат", ДокументРезультат);
	РезультатВыполнения.Вставить("ИмяМакета", ПараметрыОтчета.ИмяМакета);
	РезультатВыполнения.Вставить("КэшОтчетов", КэшОтчетов);
	РезультатВыполнения.Вставить("ДанныеРасшифровки", ПолучитьИзВременногоХранилища(ПромежуточныйРезультатВыполнения.ДанныеРасшифровки));
	
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Функция ПолучитьНастройкуМакета(ПараметрыОтчета, СхемаКомпоновкиДанных = Неопределено) Экспорт
	
	Если ПараметрыОтчета.КоллекцияНастроек <> Неопределено 
		И ПараметрыОтчета.КоллекцияНастроек.Свойство(ПараметрыОтчета.ИмяМакета) Тогда				
		Возврат ПараметрыОтчета.КоллекцияНастроек[ПараметрыОтчета.ИмяМакета];
	ИначеЕсли СхемаКомпоновкиДанных = Неопределено Тогда		
		Возврат Отчеты.АнализСостоянияНалоговогоУчетаПоУСН.ПолучитьМакет(ПараметрыОтчета.ИмяМакета).НастройкиПоУмолчанию;
	Иначе		
		Возврат СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;

КонецФункции

Функция ВыделятьНДСУСН(ПараметрыОтчета) Экспорт
	
	Возврат УчетнаяПолитика.ПорядокПризнанияРасходовПоНДС(ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода)) = Перечисления.ПорядокПризнанияРасходовПоНДС.ПоОплатеПоставщику;
	
КонецФункции

Функция ДатаИзмененияУчетнойПолитикиПоНДС(Организация, ДатаОкончанияПериода) Экспорт

	ДатаИзмененияУПпоНДС = '00010101';
	
	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(ДатаОкончанияПериода) Тогда
		Возврат ДатаИзмененияУПпоНДС;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период",      ДатаОкончанияПериода);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиУчетаУСН.Период КАК Период,
	|	НастройкиУчетаУСН.ПорядокПризнанияРасходовПоНДС
	|ИЗ
	|	РегистрСведений.НастройкиУчетаУСН КАК НастройкиУчетаУСН
	|ГДЕ
	|	НастройкиУчетаУСН.Организация = &Организация
	|	И НастройкиУчетаУСН.Период < &Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекущийРежимНДС = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		Если ТекущийРежимНДС = Неопределено Тогда
			ТекущийРежимНДС    = Выборка.ПорядокПризнанияРасходовПоНДС;
			ДатаТекущегоРежима = Выборка.Период;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ПорядокПризнанияРасходовПоНДС) 
			И ТекущийРежимНДС <> Выборка.ПорядокПризнанияРасходовПоНДС Тогда
			ДатаИзмененияУПпоНДС = ДатаТекущегоРежима;
			Прервать;
		Иначе
			ДатаТекущегоРежима = Выборка.Период;
		КонецЕсли;
	КонецЦикла;

	Возврат ДатаИзмененияУПпоНДС;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьКоэффРаспределенияЕНВД(СписокОрганизаций, Дата, Период = "Квартал", Способ = "БУ")
	
	Коэфф = 0;
	НачальнаяДата = ?(Период = "Квартал", НачалоКвартала(Дата), НачалоГода(Дата));
	
	Если Способ = "БУ" Тогда
		
		Коэфф = НалоговыйУчет.КоэффициентРаспределенияРасходовПоВидамДеятельности(СписокОрганизаций, НачальнаяДата, Дата);
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НачДата",           НачальнаяДата);
		Запрос.УстановитьПараметр("КонДата",           КонецМесяца(Дата));
		Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
		Запрос.Текст =
		
		"ВЫБРАТЬ
		|	СУММА(КнигаУчетаДоходовИРасходовОбороты.Графа5Оборот) КАК Графа5Оборот,
		|	СУММА(КнигаУчетаДоходовИРасходовОбороты.ДоходЕНВДОборот) КАК ДоходЕНВДОборот,
		|	СУММА(КнигаУчетаДоходовИРасходовОбороты.Графа4Оборот) КАК Графа4Оборот
		|ИЗ
		|	РегистрНакопления.КнигаУчетаДоходовИРасходов.Обороты(&НачДата, &КонДата, , Организация В (&СписокОрганизаций)) КАК КнигаУчетаДоходовИРасходовОбороты";
		
		Результат = Запрос.Выполнить().Выбрать();
		
		Если Результат.Следующий() Тогда
			
			ДоходЕНВДОборот = ?(НЕ ЗначениеЗаполнено(Результат.ДоходЕНВДОборот), 0, Результат.ДоходЕНВДОборот);
			Графа4Оборот 	= ?(НЕ ЗначениеЗаполнено(Результат.Графа4Оборот), 0, Результат.Графа4Оборот);
			Графа5Оборот 	= ?(НЕ ЗначениеЗаполнено(Результат.Графа5Оборот), 0, Результат.Графа5Оборот);
			
			Если Способ = "НУ" Тогда
				
				Коэфф = ?(ДоходЕНВДОборот + Графа5Оборот = 0, 0, Результат.ДоходЕНВДОборот / (ДоходЕНВДОборот + Графа5Оборот));
				
			Иначе
				
				Коэфф = ?(Графа4Оборот = 0, 0, Результат.ДоходЕНВДОборот / Графа4Оборот);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Коэфф;
	
КонецФункции

Процедура ОтключениеТаблиц(КомпоновщикНастроек, ОтключитьТаблицы, Расшифровка)
	
	Если ОтключитьТаблицы Тогда                                                          		
		Для Каждого Таблица Из КомпоновщикНастроек.Настройки.Структура Цикл			
			Таблица.Использование = Таблица.Имя = Строка(Расшифровка);			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли