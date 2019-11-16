#Область ПрограммныйИнтерфейс

// Выделяет из переданного массива штрихкодов упаковок элементы, в составе которых
// (на любом уровне вложенности, в т.ч. частично) находится продукция требуемого вида.
//
// Параметры:
//  ШтрихкодыДляПроверки - Массив - проверяемые элементы типа СправочникСсылка.ШтрихкодыУпаковокТоваров.
//  ВидыПродукции - Массив, ПеречислениеСсылка.ВидыПродукцииИС, Неопределено - Вид отбираемой продукции.
//
// Возвращаемое значение:
//  Массив - Массив - подходящие элементы типа СправочникСсылка.ШтрихкодыУпаковокТоваров.
Процедура ВыделитьШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет соответствие штрихкодов данными по номенклатуре, характеристике, маркируемой продукции.
//
// Параметры:
//  Штрихкоды            - Соответствие - Список штрихкодов.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
Процедура ЗаполнитьИнформациюПоШтрихкодам(Штрихкоды, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеШтрихкодов - Массив - полученные штрихкоды,
//  ПараметрыЗаполнения - (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//
// Возвращаемое значение:
//  Структура - подготовленные данные.
//
Процедура ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий) Экспорт
	
	ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
	Если ШтрихкодированиеИСКлиентСервер.ДопустимаАлкогольнаяПродукция(ПараметрыСканирования) Тогда
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("Штрихкоды",                    ДанныеШтрихкодов);
		СтруктураДействий.Вставить("МассивСтрокСАкцизнымиМарками", Новый Массив);
		СтруктураДействий.Вставить("ШтрихкодыТабачнойПродукции",   Новый Массив);
		СтруктураДействий.Вставить("ТекущаяСтрока",                Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать обработку штрихкодов.
// Параметры:
//   Форма - УправляемаяФорма - форма для которой будут обработаны введенные штрихкоды.
//   ДанныеДляОбработки - Структура - структура параметров обработки штрихкодов.
//									   и заполняется данными из формы.
//   КэшированныеЗначения - Структура - кэш формы.
//
Процедура ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	Перем ДанныеКИЗ_ГИСМ;
	
	Объект = Форма.Объект;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад, ТипЦен, СуммаВключаетНДС, ДокументБезНДС");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	Если Не ЗначениеЗаполнено(ДанныеОбъекта.ТипЦен) Тогда
		ДанныеОбъекта.Вставить("СпособЗаполненияЦены", Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам);
	КонецЕсли;
			
	ДанныеОбъекта.Вставить("Реализация", Истина);
	
	Для каждого ДанныеШтрихкода Из ДанныеДляОбработки.Штрихкоды Цикл
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ИспользоватьКонтрольныеЗнакиГИСМ")
			И Форма.ИспользоватьКонтрольныеЗнакиГИСМ
			И ИнтеграцияГИСМКлиентСервер.ЭтоНомерКиЗ(ДанныеШтрихкода.Штрихкод) Тогда
			ДанныеКИЗ_ГИСМ = Справочники.КонтрольныеЗнакиГИСМ.ДанныеКИЗ_ГИСМПоНомеру(ДанныеШтрихкода.Штрихкод);
		КонецЕсли;
		
		НоменклатураПоШтрихкоду = РегистрыСведений.ШтрихкодыНоменклатуры.Получить(Новый Структура("Штрихкод", ДанныеШтрихкода.Штрихкод)).Номенклатура;
		Если НЕ ЗначениеЗаполнено(НоменклатураПоШтрихкоду) Тогда
			Если ЗначениеЗаполнено(ДанныеКИЗ_ГИСМ) Тогда
				НоменклатураПоШтрихкоду = ДанныеКИЗ_ГИСМ.Владелец;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НоменклатураПоШтрихкоду) Тогда
			СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(НоменклатураПоШтрихкоду, ДанныеОбъекта, Ложь, Истина);
			
			Если СведенияОНоменклатуре.ТабачнаяПродукция Тогда
				ДанныеДляОбработки.ШтрихкодыТабачнойПродукции.Добавить(НоменклатураПоШтрихкоду);
				Продолжить;
			КонецЕсли;
			
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("Номенклатура", НоменклатураПоШтрихкоду);
			ДанныеСтроки.Вставить("Количество", ДанныеШтрихкода.Количество);
			
			Если СведенияОНоменклатуре <> Неопределено Тогда
				ДанныеСтроки.Вставить("Цена",      СведенияОНоменклатуре.Цена);
				ДанныеСтроки.Вставить("СтавкаНДС", СведенияОНоменклатуре.СтавкаНДС);
			Иначе
				ДанныеСтроки.Вставить("Цена",      0);
				ДанныеСтроки.Вставить("СтавкаНДС", Перечисления.СтавкиНДС.БезНДС);
			КонецЕсли;
			
			ДанныеСтроки.Вставить("КиЗ_ГИСМ", ?(ЗначениеЗаполнено(ДанныеКИЗ_ГИСМ),ДанныеКИЗ_ГИСМ.КиЗ_ГИСМ, Справочники.КонтрольныеЗнакиГИСМ.ПустаяСсылка()));
			ДанныеСтроки.Вставить("Штрихкод", ДанныеШтрихкода.Штрихкод);
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("Номенклатура", ДанныеСтроки.Номенклатура);
			СтруктураОтбора.Вставить("Цена",         Окр(ДанныеСтроки.Цена,2,1));
			Если Объект.Товары.Выгрузить().Колонки.Найти("КиЗ_ГИСМ") <> Неопределено Тогда
				СтруктураОтбора.Вставить("КиЗ_ГИСМ", ДанныеСтроки.КиЗ_ГИСМ);
			КонецЕсли; 
				
			СтрокиТабличнойЧасти = Объект.Товары.НайтиСтроки(СтруктураОтбора);
			Если НЕ СведенияОНоменклатуре.АлкогольнаяПродукция 
				И НЕ СведенияОНоменклатуре.ТабачнаяПродукция 
				И СтрокиТабличнойЧасти.Количество() > 0 Тогда
				
				// Нашли - увеличиваем количество.
				СтрокаТабличнойЧасти = СтрокиТабличнойЧасти[0];
				СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + ДанныеСтроки.Количество;
			Иначе
				СтрокаТабличнойЧасти = Объект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеСтроки);
			КонецЕсли;
			
			ИдентификаторСтроки = СтрокаТабличнойЧасти.ПолучитьИдентификатор();
			
			ДанныеДляОбработки.ТекущаяСтрока = ИдентификаторСтроки;
			
			Если СведенияОНоменклатуре.АлкогольнаяПродукция Тогда
				ДанныеДляОбработки.МассивСтрокСАкцизнымиМарками.Добавить(ИдентификаторСтроки);
			КонецЕсли;
			
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов из ТСД.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ОбработатьДанныеИзТСД(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо определить вычисление вида продукции для текста запроса.
//
// Параметры:
//  ТекстЗапроса - Строка - исходящий, дополняемый текст запроса.
//
Процедура ОпределитьВидПродукцииТекстаЗапроса(ТекстЗапроса) Экспорт
	
	ОпределениеВидаПродукции =
	"	Выбор
	|		Когда Номенклатура В (ВЫБРАТЬ РАЗЛИЧНЫЕ Номенклатура ИЗ РегистрСведений.СоответствиеНоменклатурыЕГАИС)
	|			Тогда Значение(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		Когда Номенклатура.ТабачнаяПродукция
	|			Тогда Значение(Перечисление.ВидыПродукцииИС.Табачная)
	|		Иначе Значение(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	Конец ";
	
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОпределениеВидаПродукции", ОпределениеВидаПродукции);
	
КонецПроцедуры

// В процедуре необходимо определить вычисление вида продукции для текста запроса построения дерева.
//
// Параметры:
//  ТекстЗапроса    - Строка - исходящий, дополняемый текст запроса.
//  УровнейВЗапросе - Число - количество уровней вложений.
//
Процедура ОпределитьВидПродукцииТекстаЗапросаДереваУпаковок(ТекстЗапроса, УровнейВЗапросе) Экспорт
	
	
	Для Уровень = 0 По УровнейВЗапросе Цикл
		
		ОпределениеВидаПродукции = 
		"ВЫБОР
		|	КОГДА ДанныеУпаковок.УпаковкаУровень"+Уровень+".Номенклатура <> НЕОПРЕДЕЛЕНО
		|		ТОГДА ВЫБОР
		|			КОГДА ДанныеУпаковок.УпаковкаУровень"+Уровень+".Номенклатура В (ВЫБРАТЬ Номенклатура ИЗ РегистрСведений.СоответствиеНоменклатурыЕГАИС ГДЕ Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
		|				ТОГДА Значение(Перечисление.ВидыПродукцииИС.Алкогольная)
		|			КОГДА ДанныеУпаковок.УпаковкаУровень"+Уровень+".Номенклатура.ТабачнаяПродукция
		|				ТОГДА Значение(Перечисление.ВидыПродукцииИС.Табачная)
		|			КОНЕЦ
		|	КОНЕЦ"; 
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОпределениеВидаПродукции" + Уровень , ОпределениеВидаПродукции);
		
	КонецЦикла;
	
КонецПроцедуры

// В процедуре необходимо сформировать соответствие по коллекции ИНН. Ключ - ИНН, значение - Контрагент.
//
// Параметры:
//  КоллекцияИНН - Массив - Список ИНН.
//  Соответствие - Соответствие - Соответсвие вида:
//   * ИНН
//   * Контрагент
//
Процедура ЗаполнитьСоответствиеИННКонтрагентам(КоллекцияИНН, Соответствие) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ИНН    КАК ИНН
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН В (&КоллекцияИНН)");
	Запрос.УстановитьПараметр("КоллекцияИНН", КоллекцияИНН);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(Выборка.ИНН, Выборка.Контрагент);
	КонецЦикла;
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение таблицы ДанныеПоEAN на основании заполненной колонки ЗначениеШтрихкодаEAN.
// 
// Параметры:
//	ДанныеПоШтрихкодамEAN - ТаблицаЗначений - передается с обязательной колонкой ШтрихкодEAN, возвращает:
//	* Номенклатура
//	* Характеристика
//	* ШтрихкодEAN
//	* ПредставлениеНоменклатуры
//	* ВидПродукции
Процедура ЗаполнитьДанныеПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN) Экспорт
	
	Если ДанныеПоШтрихкодамEAN.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеПоШтрихкодамEAN.ШтрихкодEAN КАК ШтрихкодEAN
	|ПОМЕСТИТЬ ВТ_ШтрихкодыEAN
	|ИЗ
	|	&ДанныеПоШтрихкодамEAN КАК ДанныеПоШтрихкодамEAN
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_АлкогольнаяПродукция
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Номенклатура.НаименованиеПолное, """") КАК ПредставлениеНоменклатуры,
	|	ВТ_ШтрихкодыEAN.ШтрихкодEAN КАК ШтрихкодEAN,
	|	ВЫБОР
	|		КОГДА ШтрихкодыНоменклатуры.Номенклатура ЕСТЬ NULL
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|		КОГДА НЕ ВТ_АлкогольнаяПродукция.Номенклатура ЕСТЬ NULL
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА ШтрихкодыНоменклатуры.Номенклатура.ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ КАК ВидПродукции
	|ИЗ
	|	ВТ_ШтрихкодыEAN КАК ВТ_ШтрихкодыEAN
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ((ВЫРАЗИТЬ(ВТ_ШтрихкодыEAN.ШтрихкодEAN КАК СТРОКА(200))) = ШтрихкодыНоменклатуры.Штрихкод)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_АлкогольнаяПродукция КАК ВТ_АлкогольнаяПродукция
	|		ПО (ШтрихкодыНоменклатуры.Номенклатура = ВТ_АлкогольнаяПродукция.Номенклатура)";
	
	Запрос.УстановитьПараметр("ДанныеПоШтрихкодамEAN", ДанныеПоШтрихкодамEAN);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	ДанныеПоШтрихкодамEAN.Очистить();
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапроса, ДанныеПоШтрихкодамEAN);
	
КонецПроцедуры

// В процедуре необходимо реализовать проверку необходимости выбора серии для данных по штрихкодам.
// 
// Параметры:
// 	ДанныеШтрихкода       - Структура - данные штрихкода.
// 	ПараметрыСканирования - Структура - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
// 	ТребуетсяВыбор        - Булево - исходящий, признак необходимости выбора серии.
//
Процедура ОпределитьНеобходимостьВыбораСерииДляДанныхШтрихкода(ДанныеШтрихкода, ПараметрыСканирования, ТребуетсяВыбор) Экспорт
	
	ТребуетсяВыбор = Ложь;
	
КонецПроцедуры

// Выполняет заполнение параметра "ШтрихкодыУпаковок" значениями штрихкодов документа.
// 
// Параметры:
//  Документ - ДокументСсылка - Документ, для которого выполняется обработка штрихкодов.
//  ШтрихкодыУпаковок - Массив из Строка - Коллекция значений штрихкодов.
Процедура ЗаполнитьШтрихкодыУпаковокДокумента(Документ, ШтрихкодыУпаковок) Экспорт
	
	ШтрихкодыУпаковок = Документ.ШтрихкодыУпаковок.ВыгрузитьКолонку("ЗначениеШтрихкода");
	
КонецПроцедуры

// Собирает данные из документа основания.
// 
// Параметры:
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
//  ТаблицаДанных - ТаблицаЗначений - Данные из документа основания.
Процедура СформироватьДанныеДокументаОснования(ПараметрыСканирования, ТаблицаДанных) Экспорт
	
	
КонецПроцедуры

// В процедуре необходимо реализовать обработку данных штрихкода для общей формы. результат обработки штрихкода следует
// вернуть в параметре РезультатОбработки.
// 
// Параметры:
//  Форма - УправляемаяФорма - Общая форма.
//  ДанныеШтрихкода - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьДанныеШтрихкода).
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
//  ВложенныеШтрихкоды - (См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода).
//  РезультатОброботки - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Процедура ОбработатьДанныеШтрихкодаДляОбщейФормы(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды, РезультатОброботки) Экспорт
	
	
КонецПроцедуры

// Добавляет в текст запроса определение признака "Маркируемая продукция".
// 
// Параметры:
// 	ТекстЗапроса - Строка - Текст запроса.
// 	ПутьКПолюНоменклатура - Строка - Путь к полю номенклатуры в тексте запроса.
// 	Параметр - Строка - параметр запроса, который будет заменен на фрагмент определения признака "Маркиремая продукция".
Процедура ОпределитьПризнакМаркируемаяПродукцияТекстаЗапроса(ТекстЗапроса, ПутьКПолюНоменклатура, Параметр) Экспорт
	
	
КонецПроцедуры

// В этой процедуре при необходимости следует реализовать дополнительные проверки на ошибки данных по штрихкодам.
// 
// Параметры:
//  Форма - УправляемаяФорма - Форма, для которой выполняется обработка штрихкодов.
//  ДанныеПоШтрихкодам - (См. ШтрихкодированиеИС.ИнициализацияДанныхПоШтрихкодам). 
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования).
//  ЕстьОшибки - Булево - Истина, если выявлена ошибка.
Процедура ПриПроверкеДанныхПоШтрихкодам(ДанныеПоШтрихкодам, ПараметрыСканирования, ЕстьОшибки) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать замену значений неопределено на пустые ссылки в строке дерева.
// 
// Параметры:
// 	СтрокаДерева - СтрокаДереваЗначений - строка дерева значений для заполнения.
//
Процедура ЗаменитьЗначенияНеопределеноНаПустыеСсылкиВСтрокеДерева(СтрокаДерева) Экспорт
	
	Если СтрокаДерева.Номенклатура = Неопределено Тогда
		СтрокаДерева.Номенклатура = Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли;
	
	Если СтрокаДерева.Характеристика = Неопределено Тогда
		СтрокаДерева.Характеристика = "";
	КонецЕсли;
	
	Если СтрокаДерева.Серия = Неопределено Тогда
		СтрокаДерева.Серия = "";
	КонецЕсли;
	
КонецПроцедуры

// В данной процедуре требуется переопределить текст запроса, определяющий свойства маркируемой продукции.
// Номенклатура для запроса лежить во временной таблице "ДанныеШтрихкодовУпаковок". (ДанныеШтрихкодовУпаковок.Номенклатура).
// "ВидПродукции". Поле "Номенклатура" желательно индексировать.
//   Колонки временной таблицы "ДанныеШтрихкодовУпаковок":
//    * Номенклатура   - ОпределяемыйТип.Номенклатура
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры
//    * Серия          - ОпределяемыйТип.СерияНоменклатуры
//   Ожидаемые действия:
//   * Создание временной таблицы "СвойстваМаркируемойПродукции" с колонками:
//     ** Номенклатура         - ОпределяемыйТип.Номенклатура
//     ** МаркируемаяПродукция - Булево
//     ** ВидПродукции         - ПеречислениеСсылка.ВидыПродукцииИС
// Параметры:
//  ТекстЗапросаСвойстваМаркируемойПродукции - Строка - Переопределяемый текст запроса.
Процедура ПриОпределенииТекстаЗапросаСвойствМаркируемойПродукции(ТекстЗапросаСвойстваМаркируемойПродукции) Экспорт
	
	ТекстЗапросаСвойстваМаркируемойПродукции =
	"ВЫБРАТЬ
	|	ДанныеШтрихкодовУпаковок.Номенклатура               КАК Номенклатура,
	|	ДанныеШтрихкодовУпаковок.Характеристика             КАК Характеристика,
	|	ДанныеШтрихкодовУпаковок.Серия                      КАК Серия,
	|	МАКСИМУМ(ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
	|		ИЛИ ДанныеШтрихкодовУпаковок.Номенклатура.ТабачнаяПродукция) КАК МаркируемаяПродукция,
	|	ВЫБОР
	|		КОГДА НЕ ВидыАлкогольнойПродукции.Ссылка ЕСТЬ NULL
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА ДанныеШтрихкодовУпаковок.Номенклатура.ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ КАК ВидПродукции
	|ПОМЕСТИТЬ СвойстваМаркируемойПродукции
	|ИЗ
	|	ДанныеШтрихкодовУпаковок КАК ДанныеШтрихкодовУпаковок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбАлкогольнойПродукции КАК СведенияОбАлкогольнойПродукции
	|		ПО ДанныеШтрихкодовУпаковок.Номенклатура = СведенияОбАлкогольнойПродукции.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО (СведенияОбАлкогольнойПродукции.КодВида169 = ВидыАлкогольнойПродукции.Код)
	|СГРУППИРОВАТЬ ПО
	|	ДанныеШтрихкодовУпаковок.Номенклатура,
	|	ДанныеШтрихкодовУпаковок.Характеристика,
	|	ДанныеШтрихкодовУпаковок.Серия,
	|	ВЫБОР
	|		КОГДА НЕ ВидыАлкогольнойПродукции.Ссылка ЕСТЬ NULL
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА ДанныеШтрихкодовУпаковок.Номенклатура.ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура";
	
КонецПроцедуры

// В данной процедуре требуется переопределить сочетание клавиш для команды "Добавить без маркировки" в форме сканирования.
// 
// Параметры:
//  СочетаниеКлавиш - СочетаниеКлавиш - По умолчанию "Ctr + Z".
Процедура ПриОпределенииСочетанияКлавишДобавитьБезМаркировкиВФормеСканирования(СочетаниеКлавиш) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
