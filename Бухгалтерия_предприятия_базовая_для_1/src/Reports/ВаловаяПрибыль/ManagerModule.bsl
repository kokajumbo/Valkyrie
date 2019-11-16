#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;
	
КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  ОрганизацияВНачале - Булево - флаг, используемый для вывода представления организации в начале текста,
//                                если организацию нужно выводить в тексте заголовка.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учётом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Валовая прибыль%1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	#Область УстановкаПараметровСхемыКомпоновки
	
	ПредставлениеПериода = СтрЗаменить(
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода),
		"за",
		"");
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"ПредставлениеПериода",
		СОкрЛП(ПредставлениеПериода));
	
	// Счета расчетов с розничными покупателями.
	СчетаКассы = Новый Массив;
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.Касса);                          // 50
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСРозничнымиПокупателями); // 62.Р
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам);       //57.03
	СчетаКассы = БухгалтерскийУчет.СформироватьМассивСубсчетов(СчетаКассы);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаКассы", СчетаКассы);
	
	// Счета выручки.
	СчетаВыручкиЕНВД = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ВыручкаЕНВД);
	СчетаВыручки     = Новый Массив(БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.Выручка));
	СчетаВыручки     = ОбщегоНазначенияКлиентСервер.РазностьМассивов(СчетаВыручки, СчетаВыручкиЕНВД);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетаВыручкиЕНВД",
		СчетаВыручкиЕНВД);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетаВыручки",
		СчетаВыручки);
		
	// Счета себестоимости.
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетаСебестоимости",
		БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.СебестоимостьПродаж));
		
	// Счета расчетов с покупателями, в том числе и розничными.
	СчетаРасчетовСПокупателями = БухгалтерскиеОтчеты.СчетаРасчетовСПокупателямиССубсчетами();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаРасчетовСПокупателями, СчетаКассы);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетаРасчетовСПокупателями",
		СчетаРасчетовСПокупателями);
	
	// Счета учета номенклатуры.
	СчетаУчетаНоменклатуры = СчетаУчетаТоваров();
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетУчетаНоменклатурыСПартиями",
		СчетаУчетаНоменклатуры.СчетаСПартионнымУчетом);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетУчетаНоменклатурыБезПартии",
		СчетаУчетаНоменклатуры.СчетаБезПартионногоУчета);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетУчетаНоменклатурыСПартиямиБезСклада",
		СчетаУчетаНоменклатуры.СчетаСПартионнымУчетомБезСклада);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетУчетаНоменклатурыБезСкладаБезПартии",
		СчетаУчетаНоменклатуры.СчетаБезПартионногоУчетаБезСклада);
		
	// Счета учета торговой наценки.
	СчетаУчетаТорговойНаценки = СчетаУчетаТорговойНаценки();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетТорговойНаценкиСПартиями",
		СчетаУчетаТорговойНаценки.СчетаСПартионнымУчетом);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетТорговойНаценкиБезПартии",
		СчетаУчетаТорговойНаценки.СчетаБезПартионногоУчета);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетТорговойНаценкиБезСкладаСПартиями",
		СчетаУчетаТорговойНаценки.СчетаСПартионнымУчетомБезСклада);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"СчетТорговойНаценкиБезСкладаБезПартии",
		СчетаУчетаТорговойНаценки.СчетаБезПартионногоУчетаБезСклада);
		
	// Периодичность.
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"Периодичность",
		ПараметрыОтчета.Периодичность);
	
	СхемаЭталон = ПолучитьМакет("СхемаКомпоновкиДанных");
	
	ПериодичностьОтчета = Новый Соответствие;
	ПериодичностьОтчета.Вставить(6, "ДЕНЬ");
	ПериодичностьОтчета.Вставить(9, "МЕСЯЦ");
	ПериодичностьОтчета.Вставить(10, "КВАРТАЛ");
	ПериодичностьОтчета.Вставить(11, "ПОЛУГОДИЕ");
	ПериодичностьОтчета.Вставить(12, "ГОД");
	
	Периодичность = ПериодичностьОтчета.Получить(ПараметрыОтчета.Периодичность);
	
	// Скорректируем текст запроса для выбранной периодичности.
	Если Периодичность <> Неопределено Тогда
		ТекстЗапроса = СхемаЭталон.НаборыДанных.ВаловаяПрибыль.Запрос;
		Схема.НаборыДанных.ВаловаяПрибыль.Запрос = СтрЗаменить(
			ТекстЗапроса,
			".ПериодДень",
			".Период" + Периодичность);
		
	КонецЕсли;
	
	// Начало периода.
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек,
			"НачалоПериода",
			НачалоДня(ПараметрыОтчета.НачалоПериода));
			
	КонецЕсли;
	
	// Конец периода.
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек,
			"КонецПериода",
			КонецДня(ПараметрыОтчета.КонецПериода));
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек,
			"ПараметрПериод",
			КонецДня(ПараметрыОтчета.КонецПериода));
			
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	// Если отключен суммовой учет по складам на счетах учета товаров,
	// то расчет себестоимости выполняется без детализации по складам.
	// Проверяем 41 счет: если на нем включен суммовой учет по складам, 
	// то считаем, что на всех остальных товарных счетах также включен.
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"ВедетсяСуммовойУчетПоСкладам",
		БухгалтерскийУчет.ВедетсяСуммовойУчетПоСкладам(ПланыСчетов.Хозрасчетный.Товары));
	
	#КонецОбласти
	
	#Область ФормированиеСтруктурыОтчета
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Диаграмма = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
		Если ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			Диаграмма = ЭлементСтруктуры;
		КонецЕсли;
	КонецЦикла;
	
	// Настройка диаграммы.
	Если Диаграмма <> Неопределено Тогда
		
		Если ВыводитьДиаграмму Тогда
			
			// Группировка.
			Диаграмма.Использование = Ложь;
			Диаграмма.Точки.Очистить();
			Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
				Если ПолеВыбраннойГруппировки.Использование Тогда
					
					Группировка = Диаграмма.Точки.Добавить();
					
					БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
					
					Группировка.Выбор.Элементы.Очистить();
					ЭлементВыбора = Группировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
					ЭлементВыбора.Поле = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
					
					Диаграмма.Использование = Истина;
					
					// Диаграмма группируется по самой первой группировке.
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			
			Диаграмма.Использование = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	#КонецОбласти
	
	// Дополнительные данные.
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Ресурс Валовая прибыль есть в отчете всегда.
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ВаловаяПрибыльБезНДС");
	
	// Отбор по организации.
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
			Рисунок.Объект.ОбластьПостроения.ШкалаТочек.ОриентацияПодписей = ОриентацияПодписейДиаграммы.Горизонтально;
			Рисунок.Объект.ПоложениеПодписей = ПоложениеПодписейКДиаграмме.КрайАвто;
			Рисунок.Объект.ОбластьПостроения.ШкалаЗначений.ПоложениеПодписейШкалы = ПоложениеПодписейШкалыДиаграммы.Нет;
		КонецЕсли;
	КонецЦикла;
	
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ВаловаяПрибыль");
	
	ОписаниеВарианта.Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.Продажи, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

// Заполняет описание настроек отчета в коллекции Настройки
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя, Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет параметры расшифровки ячейки отчета.
//
// Параметры:
//	Адрес - Строка - Адрес временного хранилища с данными расшифровки отчета.
//	Расшифровка - Произвольный - Значения полей расшифровки.
//	ПараметрыРасшифровки - Структура - Коллеккция параметров расшифроки, которую требуется заполнить. 
//		Подробнее см. БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки()
//
Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список пунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполниим соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Соответствие;
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки ИЗ ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Прежде всего интересны данные группировочных полей
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		
		Если Группировка.Использование Тогда
			
			СоответствиеПолей.Вставить(Группировка.Поле);
			
		КонецЕсли;
		
	КонецЦикла;
	
	СоответствиеПолей.Вставить("Период");
		
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки",          Истина);
	ДополнительныеСвойства.Вставить("Организация",               ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода",             ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода",              ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",         ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",            ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",           ДанныеОтчета.Объект.МакетОформления);
	ДополнительныеСвойства.Вставить("Периодичность",             ДанныеОтчета.Объект.Периодичность);
	ДополнительныеСвойства.Вставить("ВыводитьДиаграмму",         Ложь);
	ДополнительныеСвойства.Вставить("КлючТекущегоВарианта",      ДанныеОтчета.Объект.КлючТекущегоВарианта);
	ДополнительныеСвойства.Вставить("ОчищатьТаблицуГруппировок", Истина);
	ДополнительныеСвойства.Вставить("ОчищатьДополнительныеПоля", Истина);
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	// Получаем структуру полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	// Если в отчете уже есть регистратор, то дальше не расшифровываем, а открываем документ.
	Регистратор = Данные_Расшифровки.Получить("Регистратор");

	Если Регистратор <> Неопределено Тогда
		ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
		ПараметрыРасшифровки.Вставить("Значение", Регистратор);
		Возврат;
	КонецЕсли;
	
	// Расшифрвку розничного покупателя или розничной продажи преобразовываем в отбор по полю - "Розница".
	Договор = Данные_Расшифровки.Получить("Договор");
	
	Контрагент = Данные_Расшифровки.Получить("Контрагент");
	Если Контрагент <> Неопределено И Контрагент = "Розничные покупатели" Тогда
		
		Данные_Расшифровки.Вставить("Розница", Истина);
		Данные_Расшифровки.Удалить("Контрагент");
		
	КонецЕсли;
	
	Если Договор <> Неопределено И Договор <> "Розничная продажа" Тогда
		
		ДополнительныеСвойства.Вставить("Организация", Договор.Организация);
		
	ИначеЕсли Договор = "Розничная продажа" Тогда
		
		Данные_Расшифровки.Вставить("Розница", Истина);
		Данные_Расшифровки.Удалить("Договор");
		
	КонецЕсли;
	
	// Периодичность преобразовываем в другой период.
	Период = Данные_Расшифровки.Получить("Период");
	
	Если Период <> Неопределено Тогда
		
		Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ДанныеОтчета.Объект.Периодичность, ДанныеОтчета.Объект.НачалоПериода, ДанныеОтчета.Объект.КонецПериода);
		ДополнительныеСвойства.Вставить("Периодичность", Периодичность);
		ДополнительныеСвойства.Вставить("КонецПериода",  КонецДня(БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность)));
		ДополнительныеСвойства.Вставить("НачалоПериода", НачалоДня(БухгалтерскиеОтчетыКлиентСервер.НачалоПериода(Период, Периодичность)));

	КонецЕсли;
	
	// Формируем отборы нового отчета.
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		Если ЗначениеРасшифровки.Ключ <> "Период" Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Формируем группировки нового отчета.
	Группировка = Новый Массив();
	ЕстьГруппировкаПоДокументу = Ложь;
	Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
			Группировка.Добавить(СтрокаДляРасшифровки);
			
			Если СтрокаГруппировки.Поле = "Регистратор" Тогда
				ЕстьГруппировкаПоДокументу = Истина;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЕстьГруппировкаПоДокументу Тогда
		
		СтрокаДляРасшифровки = Новый Структура();
		СтрокаДляРасшифровки.Вставить("Использование", 	Истина);
		СтрокаДляРасшифровки.Вставить("Поле", 			"Регистратор");
		СтрокаДляРасшифровки.Вставить("Представление", 	"Документ");
		СтрокаДляРасшифровки.Вставить("ТипГруппировки", 0);
		
		Группировка.Добавить(СтрокаДляРасшифровки);
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Группировка", Группировка);
	
	// Формируем дополнительные поля.
	ДополнительныеПоля = Новый Массив();
	
	Для Каждого ДополнительноеПоле Из ДанныеОтчета.Объект.ДополнительныеПоля Цикл
		Если ДополнительноеПоле.Использование Тогда
			
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, ДополнительноеПоле);
			ДополнительныеПоля.Добавить(СтрокаДляРасшифровки);
			
		КонецЕсли;
	КонецЦикла;

	ДополнительныеСвойства.Вставить("ДополнительныеПоля", ДополнительныеПоля);
	
	СписокПунктовМеню.Добавить("ВаловаяПрибыль", "Валовая прибыль");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("ВаловаяПрибыль", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

// Возвращает коллекцию вариантов настроек отчета
//
Функция ВариантыНастроек() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура(
		"Имя, Представление",
		"ВаловаяПрибыль",
		НСтр("ru = 'Валовая прибыль'")));
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("Периодичность"                    , 0);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	ПараметрыОтчета.Вставить("КлючТекущегоВарианта" , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СчетаУчетаТоваров()
	
	Счета_1011 = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.СпецоснасткаИСпецодеждаВЭксплуатации);
	СчетаИсключаемые = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Счета_1011);
	СчетаИсключаемые.Добавить(ПланыСчетов.Хозрасчетный.МатериалыПереданныеВПереработку);            // 10.07
	СчетаИсключаемые.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ); // 41.12
	СчетаИсключаемые.Добавить(ПланыСчетов.Хозрасчетный.КорректировкаТоваровПрошлогоПериода);        // 41.К
	
	СчетаУчетаТоваров = БухгалтерскиеОтчеты.СчетаУчетаТоваров(СчетаИсключаемые);
	
	СчетаСПартионнымУчетом            = Новый Массив;
	СчетаБезПартионногоУчета          = Новый Массив;
	СчетаСПартионнымУчетомБезСклада   = Новый Массив;
	СчетаБезПартионногоУчетаБезСклада = Новый Массив;
	
	
	Для Каждого Счет Из СчетаУчетаТоваров Цикл
		Если БухгалтерскийУчет.НаСчетеВедетсяПартионныйУчет(Счет) Тогда
			Если БухгалтерскийУчет.ВедетсяУчетПоСкладам(Счет) Тогда
				СчетаСПартионнымУчетом.Добавить(Счет);
			Иначе
				СчетаСПартионнымУчетомБезСклада.Добавить(Счет);
			КонецЕсли;
		Иначе
			Если БухгалтерскийУчет.ВедетсяУчетПоСкладам(Счет) Тогда
				СчетаБезПартионногоУчета.Добавить(Счет);
			Иначе
				СчетаБезПартионногоУчетаБезСклада.Добавить(Счет);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("СчетаСПартионнымУчетом",            СчетаСПартионнымУчетом);
	Результат.Вставить("СчетаБезПартионногоУчета",          СчетаБезПартионногоУчета);
	Результат.Вставить("СчетаСПартионнымУчетомБезСклада",   СчетаСПартионнымУчетомБезСклада);
	Результат.Вставить("СчетаБезПартионногоУчетаБезСклада", СчетаБезПартионногоУчетаБезСклада);
	
	Возврат Результат;
	
КонецФункции

Функция СчетаУчетаТорговойНаценки()
	
	СчетаУчета = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ТорговаяНаценка);

	СчетаСПартионнымУчетом            = Новый Массив;
	СчетаБезПартионногоУчета          = Новый Массив;
	СчетаСПартионнымУчетомБезСклада   = Новый Массив;
	СчетаБезПартионногоУчетаБезСклада = Новый Массив;
	
	
	Для Каждого Счет Из СчетаУчета Цикл
		Если БухгалтерскийУчет.НаСчетеВедетсяПартионныйУчет(Счет) Тогда
			Если БухгалтерскийУчет.ВедетсяУчетПоСкладам(Счет) Тогда
				СчетаСПартионнымУчетом.Добавить(Счет);
			Иначе
				СчетаСПартионнымУчетомБезСклада.Добавить(Счет);
			КонецЕсли;
		Иначе
			Если БухгалтерскийУчет.ВедетсяУчетПоСкладам(Счет) Тогда
				СчетаБезПартионногоУчета.Добавить(Счет);
			Иначе
				СчетаБезПартионногоУчетаБезСклада.Добавить(Счет);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("СчетаСПартионнымУчетом",            СчетаСПартионнымУчетом);
	Результат.Вставить("СчетаБезПартионногоУчета",          СчетаБезПартионногоУчета);
	Результат.Вставить("СчетаСПартионнымУчетомБезСклада",   СчетаСПартионнымУчетомБезСклада);
	Результат.Вставить("СчетаБезПартионногоУчетаБезСклада", СчетаБезПартионногоУчетаБезСклада);
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти

#КонецЕсли