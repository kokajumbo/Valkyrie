#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим", Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Задолженность поставщикам по срокам долга на " + Формат(ПараметрыОтчета.Период, "ДФ=dd.MM.yyyy; ДП=...");
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	Перем ПросроченнаяЗадолженность;
	
	ПросроченнаяЗадолженность = СрокиОплатыДокументов.ПросроченнаяЗадолженностьПоставщикам(
									ПараметрыОтчета.Организация,
									ПараметрыОтчета.Период,
									ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	
	ВнешниеНаборыДанных = Новый Структура("ПросроченнаяЗадолженность", ПросроченнаяЗадолженность);
	
	Возврат ВнешниеНаборыДанных;

КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПоставщиков();

	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаСДокументомРасчетов", СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаБезДокументаРасчетов", СчетаУчетаРасчетов.СчетаБезДокументаРасчетов);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыДоговоров", БухгалтерскиеОтчеты.ВидыДоговоровПоставщиков());
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период", КонецДня(ПараметрыОтчета.Период) + 1);

	ВыводитьДиаграмму = Неопределено;
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			ЭлементСтруктуры.Использование = ВыводитьДиаграмму;
		КонецЕсли;		
	КонецЦикла;	
	
	КоличествоИнтервалов = ПараметрыОтчета.Интервалы.Количество();
	
	// Доработка схемы под заданные интервалы
	Схема.НаборыДанных.ОсновнойНабор.Запрос = ПолучитьТекстЗапроса(КоличествоИнтервалов);
	
	УстановитьПараметры(ПараметрыОтчета, Схема, КомпоновщикНастроек);
	
	ЗаполнитьПоляВСоответствииСоСпискомИнтервалов(ПараметрыОтчета, Схема, КомпоновщикНастроек);
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	ВывестиПримечания(ПараметрыОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамПоСрокамДолга").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПоставщиками, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","ЗадолженностьПоставщикамПоСрокамДолга", "Задолженность поставщикам по срокам долга"));
	
	Возврат Массив;
	
КонецФункции

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список мунктов меню
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
		СоответствиеПолей.Вставить(Группировка.Поле);
	КонецЦикла;
	
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки", 					Истина);
	ДополнительныеСвойства.Вставить("Организация", 							ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("Период", 								ДанныеОтчета.Объект.Период);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",					ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьДиаграмму",					Ложь);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",						ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",						ДанныеОтчета.Объект.МакетОформления);
	ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения",	ДанныеОтчета.Объект.ВключатьОбособленныеПодразделения);
	
	// Получаем соответствие полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	Договор = Данные_Расшифровки.Получить("Договор");
	
	Если ЗначениеЗаполнено(Договор) Тогда
		
		ДополнительныеСвойства.Вставить("Организация", Договор.Организация);
		
	КонецЕсли;
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		
	КонецЦикла;
	
	Группировка = Новый Массив();
	ЕстьГруппировкаПоДокументу = Ложь;
	Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
			Группировка.Добавить(СтрокаДляРасшифровки);
			
			Если СтрокаГруппировки.Поле = "Документ" Тогда
				
				ЕстьГруппировкаПоДокументу = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЕстьГруппировкаПоДокументу Тогда
		
		СтрокаДляРасшифровки = Новый Структура();
		СтрокаДляРасшифровки.Вставить("Использование", 	Истина);
		СтрокаДляРасшифровки.Вставить("Поле", 			"Документ");
		СтрокаДляРасшифровки.Вставить("Представление", 	"Документ");
		СтрокаДляРасшифровки.Вставить("ТипГруппировки", 0);
		
		Группировка.Добавить(СтрокаДляРасшифровки);
		
	КонецЕсли;
	ДополнительныеСвойства.Вставить("Группировка", Группировка);
	
	Интервалы = Новый Массив();
	
	Для Каждого Интервал Из ДанныеОтчета.Объект.Интервалы Цикл
		
		СтрокаИнтервал = Новый Структура("Значение, Представление");
		ЗаполнитьЗначенияСвойств(СтрокаИнтервал, Интервал);
		Интервалы.Добавить(СтрокаИнтервал);
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("Интервалы", Интервалы);
	
	СписокПунктовМеню.Добавить("ЗадолженностьПоставщикамПоСрокамДолга", "Задолженность поставщикам по срокам долга");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("ЗадолженностьПоставщикамПоСрокамДолга", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

// Формирует таблицу данных для монитора руководителя по организации на дату
// Параметры
//   Организация - СправочникСсылка.Организации - Организация по которой нужны данные
//   ДатаЗадолженности - Дата - дата на которую нужны остатки
//   ВыводитьАналитику - Булево - Признак, нужно ли выводить трех самых крупных должников
// Возвращаемое значение:
//   ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПросроченнаяЗадолженностьДляМонитораРуководителя(Организация, ДатаЗадолженности, ВыводитьАналитику) Экспорт
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	ПросроченнаяЗадолженность = СрокиОплатыДокументов.ПросроченнаяЗадолженностьПоставщикам(Организация, ДатаЗадолженности, , Истина);
	
	Если ВыводитьАналитику Тогда
		
		ПросроченнаяЗадолженность = ПросроченнаяЗадолженность.Скопировать(,"Контрагент, ПросроченнаяЗадолженность");
		ПросроченнаяЗадолженность.Свернуть("Контрагент", "ПросроченнаяЗадолженность");
		ПросроченнаяЗадолженность.Сортировать("ПросроченнаяЗадолженность Убыв");
		
		Для ИндексСтроки = 0 По Мин(2, ПросроченнаяЗадолженность.Количество() - 1) Цикл
			
			СтрокаРезультата = ПросроченнаяЗадолженность[ИндексСтроки];
			
			Если СтрокаРезультата.ПросроченнаяЗадолженность = 0 Тогда
				Прервать;
			КонецЕсли;
			
			СтрокаДанных = ТаблицаДанных.Добавить();
			СтрокаДанных.Представление     = СтрокаРезультата.Контрагент;
			СтрокаДанных.ДанныеРасшифровки = СтрокаРезультата.Контрагент;
			СтрокаДанных.Порядок           = ПорядокЗадолженностейВМониторе();
			СтрокаДанных.Сумма             = СтрокаРезультата.ПросроченнаяЗадолженность;
			
		КонецЦикла;
	КонецЕсли;
	
	// Добавляем итог по разделу
	СтрокаДанных = ТаблицаДанных.Добавить();
	СтрокаДанных.Представление = НСтр("ru = 'Итого'");
	СтрокаДанных.Порядок       = ПорядокИтоговВМониторе();
	СтрокаДанных.Сумма         = ПросроченнаяЗадолженность.Итог("ПросроченнаяЗадолженность");
	
	Возврат ТаблицаДанных;
	
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
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Интервалы"                        , Неопределено);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПримечания"               , Ложь);
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
	ПараметрыОтчета.Вставить("Период"               , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоляВСоответствииСоСпискомИнтервалов(ПараметрыОтчета, Схема, КомпоновщикНастроек)
	
	КоличествоПолейПериодов = Схема.НаборыДанных.ОсновнойНабор.Поля.Количество() - 5;
	Для Индекс = 1 По КоличествоПолейПериодов Цикл
		ПолеДляУдаления = Схема.НаборыДанных.ОсновнойНабор.Поля.Найти("ОстатокПериода" + Индекс);
		Если ПолеДляУдаления <> Неопределено Тогда
			Схема.НаборыДанных.ОсновнойНабор.Поля.Удалить(ПолеДляУдаления);
		КонецЕсли; 
	КонецЦикла;
	
	Схема.ПоляИтога.Очистить();
	ПолеИтога = Схема.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным = "ОстатокДолга";
	ПолеИтога.Выражение   = "Сумма(ОстатокДолга)";
	
	ПолеИтога = Схема.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным = "ПросроченнаяЗадолженность";
	ПолеИтога.Выражение   = "Сумма(ПросроченнаяЗадолженность)";	
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ОстатокДолга");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ПросроченнаяЗадолженность");
	                                                                            
	ПапкаСПолями = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ПапкаСПолями.Заголовок = НСтр("ru = 'Общая задолженность по срокам долга'");
	Индекс = 1;
	ЗначениеПоследнего = 0;
	Для Каждого Интервал Из ПараметрыОтчета.Интервалы Цикл
		ИмяПоля = "ОстатокПериода" + Индекс;
		Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Найти(ИмяПоля);
		Если Поле = Неопределено Тогда
			Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		КонецЕсли;
		Поле.Поле        = ИмяПоля;
		Поле.ПутьКДанным = ИмяПоля;
		Поле.Заголовок   = Интервал.Представление;
		Поле.ТипЗначения = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "Формат", "ЧЦ=15; ЧДЦ=0");
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МинимальнаяШирина", 15);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МаксимальнаяШирина", 15);
		Поле.ОграничениеИспользования.Группировка = Ложь;
		Поле.ОграничениеИспользованияРеквизитов.Группировка = Ложь;
		
		ПолеИтога = Схема.ПоляИтога.Добавить();
		ПолеИтога.ПутьКДанным = ИмяПоля;
		ПолеИтога.Выражение   = "Сумма(" + ИмяПоля + ")";
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПапкаСПолями, ИмяПоля);
		Индекс = Индекс + 1;
		ЗначениеПоследнего = Интервал.Значение;
	КонецЦикла;
	
	ИмяПоля = "ОстатокПериода" + Индекс;
	Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Найти(ИмяПоля);
	Если Поле = Неопределено Тогда
		Поле = Схема.НаборыДанных.ОсновнойНабор.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	КонецЕсли;
	Поле.Поле        = ИмяПоля;
	Поле.ПутьКДанным = ИмяПоля;	
	Поле.Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Свыше %1 дней'"), ЗначениеПоследнего);
	Поле.ТипЗначения = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "Формат", "ЧЦ=15; ЧДЦ=0");
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МинимальнаяШирина", 15);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Поле.Оформление, "МаксимальнаяШирина", 15);
	
	ПолеИтога = Схема.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным = ИмяПоля;
	ПолеИтога.Выражение   = "Сумма(" + ИмяПоля + ")";
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПапкаСПолями, ИмяПоля);
	
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
		Если ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			ЭлементСтруктуры.Выбор.Элементы.Очистить();
			Для Каждого ВыбранноеПоле Из ПапкаСПолями.Элементы Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ЭлементСтруктуры.Выбор, ВыбранноеПоле.Поле);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТекстЗапроса(КоличествоИнтервалов)
	
	ПолныйТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВзаиморасчетыОстатки.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
	|	ВзаиморасчетыОстатки.Счет КАК Счет,
	|	ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокКт КАК ОстатокДолга0,
	|	ЕстьNULL(ВзаиморасчетыОстатки.Подразделение, Неопределено) КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК Документ
	|ПОМЕСТИТЬ ВзаиморасчетыОстатки
	|{ВЫБРАТЬ
	|	Организация.*,
	|	Контрагент.*,
	|	Договор.*}
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В (&СчетаБезДокументаРасчетов),
	|			&ВидыСубконтоКД,
	|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
	|			{(Организация).*, (Подразделение).*, (Субконто1).* КАК Контрагент, (Субконто2).* КАК Договор}) КАК ВзаиморасчетыОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВзаиморасчетыОстатки.Организация,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто1 КАК Справочник.Контрагенты),
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов),
	|	ВзаиморасчетыОстатки.Счет,
	|	ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокКт,
	|	ЕстьNULL(ВзаиморасчетыОстатки.Подразделение, Неопределено),
	|	ВзаиморасчетыОстатки.Субконто3
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В (&СчетаСДокументомРасчетов),
	|			&ВидыСубконтоКДД,
	|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
	|			{(Организация).*, (Подразделение).*, (Субконто1).* КАК Контрагент, (Субконто2).* КАК Договор, (Субконто3).* КАК Документ}) КАК ВзаиморасчетыОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Договор,
	|	Документ";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВзаиморасчетыОбороты.Организация КАК Организация,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОбороты.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОбороты.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
		|	НЕОПРЕДЕЛЕНО КАК Документ,
		|	ВЫБОР
		|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт > 0
		|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|		ИНАЧЕ 0
		|	КОНЕЦ - ВЫБОР
		|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
		|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК УвеличениеДолга" + Индекс + ",
		|	ЕстьNULL(ВзаиморасчетыОбороты.Подразделение, Неопределено) КАК Подразделение
		|ПОМЕСТИТЬ Обороты" + Индекс + "
		|{ВЫБРАТЬ
		|	Организация.*,
		|	Контрагент.*,
		|	Договор.*}
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&НачалоИнтервала" + Индекс + ",
		|			&КонецИнтервала" + Индекс + ",
		|			,
		|			Счет В (&СчетаБезДокументаРасчетов),
		|			&ВидыСубконтоКД,
		|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
		|			{(Организация).*, (Подразделение).*, (Субконто1).* КАК Контрагент, (Субконто2).* КАК Договор},
		|			,
		|			) КАК ВзаиморасчетыОбороты
		
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВзаиморасчетыОбороты.Организация,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОбороты.Субконто1 КАК Справочник.Контрагенты),
		|	ВЫРАЗИТЬ(ВзаиморасчетыОбороты.Субконто2 КАК Справочник.ДоговорыКонтрагентов),
		|	ВзаиморасчетыОбороты.Субконто3,
		|	ВЫБОР
		|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт > 0
		|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|		ИНАЧЕ 0
		|	КОНЕЦ - ВЫБОР
		|		КОГДА ВзаиморасчетыОбороты.СуммаОборотКт < 0
		|			ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ЕстьNULL(ВзаиморасчетыОбороты.Подразделение, Неопределено)
		|
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&НачалоИнтервала" + Индекс + ",
		|			&КонецИнтервала" + Индекс + ",
		|			,
		|			Счет В (&СчетаСДокументомРасчетов),
		|			&ВидыСубконтоКДД,
		|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
		|			{(Организация).*, (Подразделение).*, (Субконто1).* КАК Контрагент, (Субконто2).* КАК Договор, (Субконто3).* КАК Документ},
		|			,
		|			) КАК ВзаиморасчетыОбороты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	Контрагент,
		|	Договор,
		|	Документ
		|";
	КонецЦикла;
	
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|;
    |////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВзаиморасчетыОстатки.Счет,
	|	ВзаиморасчетыОстатки.Организация,
	|	ВзаиморасчетыОстатки.Подразделение,
	|	ВзаиморасчетыОстатки.Контрагент,
	|	ВзаиморасчетыОстатки.Договор,
	|	ВзаиморасчетыОстатки.Документ,
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|	ЕСТЬNULL(Обороты" + Индекс + ".УвеличениеДолга" + Индекс + ", 0) КАК УвеличениеДолга" + Индекс + ",
		|";
	КонецЦикла;
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|	ВзаиморасчетыОстатки.ОстатокДолга0
	|ПОМЕСТИТЬ ОстатокИОбороты
	|ИЗ
	|	ВзаиморасчетыОстатки КАК ВзаиморасчетыОстатки
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|		ЛЕВОЕ СОЕДИНЕНИЕ Обороты" + Индекс + " КАК Обороты" + Индекс + "
		|		ПО ВзаиморасчетыОстатки.Организация = Обороты" + Индекс + ".Организация
		|			И ВзаиморасчетыОстатки.Контрагент = Обороты" + Индекс + ".Контрагент
		|			И ВзаиморасчетыОстатки.Договор = Обороты" + Индекс + ".Договор
		|			И ВзаиморасчетыОстатки.Документ = Обороты" + Индекс + ".Документ
		|			И ВзаиморасчетыОстатки.Подразделение = Обороты" + Индекс + ".Подразделение
		|";
	КонецЦикла;
	
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстатокИОбороты.Организация,
	|	ОстатокИОбороты.Подразделение,
	|	ОстатокИОбороты.Контрагент,
	|	ОстатокИОбороты.Договор,
	|	ОстатокИОбороты.Документ,
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ТекстПоля = "ОстатокИОбороты.ОстатокДолга0";
		Для ПодИндекс = 1 По Индекс Цикл
			ТекстПоля = ТекстПоля + " - ОстатокИОбороты.УвеличениеДолга" + ПодИндекс;
		КонецЦикла;
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
		"
		|	ВЫБОР
		|		КОГДА " + ТекстПоля + " > 0
		|			ТОГДА " + ТекстПоля + "
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ОстатокДолга" + Индекс + ",
		|";
	КонецЦикла;

	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|	
	|	ОстатокИОбороты.ОстатокДолга0
	|ПОМЕСТИТЬ ОстаткиПоПериодам
	|ИЗ
	|	ОстатокИОбороты КАК ОстатокИОбороты
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиПоПериодам.Организация КАК Организация,
	|	ОстаткиПоПериодам.Подразделение КАК Подразделение,
	|	ОстаткиПоПериодам.Контрагент КАК Контрагент,
	|	ОстаткиПоПериодам.Договор КАК Договор,
	|	ОстаткиПоПериодам.Документ КАК Документ,
	|";
	Для Индекс = 1 По КоличествоИнтервалов Цикл
		ТекстПоля = "	ОстаткиПоПериодам.ОстатокДолга" + (Индекс - 1) + " - ОстаткиПоПериодам.ОстатокДолга" + Индекс + " КАК ОстатокПериода" + Индекс + ",";
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + Символы.ПС + ТекстПоля + Символы.ПС;
	КонецЦикла;
		
	ПолныйТекстЗапроса = ПолныйТекстЗапроса + 
	"
	|	ОстаткиПоПериодам.ОстатокДолга" + КоличествоИнтервалов + " КАК ОстатокПериода" + (КоличествоИнтервалов + 1) + ", 
	|	ОстаткиПоПериодам.ОстатокДолга0 КАК ОстатокДолга
	|{ВЫБРАТЬ
	|	Организация.*,
	|	Подразделение.*,
	|	Контрагент.*,
	|	Договор.*,
	|	Документ.*,
	|";
	Для Индекс = 1 По КоличествоИнтервалов + 1 Цикл
		ПолныйТекстЗапроса = ПолныйТекстЗапроса + Символы.ПС + "	ОстатокПериода" + Индекс + ",";
	КонецЦикла;
	ПолныйТекстЗапроса = ПолныйТекстЗапроса +
	"
	|	ОстатокДолга}
	|ИЗ
	|	ОстаткиПоПериодам КАК ОстаткиПоПериодам
	|{ГДЕ
	|	ОстаткиПоПериодам.Организация.*,
	|	ОстаткиПоПериодам.Подразделение.*,
	|	ОстаткиПоПериодам.Контрагент.*,
	|	ОстаткиПоПериодам.Договор.*,
	|	ОстаткиПоПериодам.Документ.*}";
	
	Возврат ПолныйТекстЗапроса;
	
КонецФункции

Процедура УстановитьПараметры(ПараметрыОтчета, Схема, КомпоновщикНастроек)

	Сутки = 60 * 60 * 24;
	
	ТабИнтервалы = Новый ТаблицаЗначений;
	ТабИнтервалы.Колонки.Добавить("ИмяИнтервала");
	ТабИнтервалы.Колонки.Добавить("НомерИнтервала");
	ТабИнтервалы.Колонки.Добавить("НачалоИнтервала");
	ТабИнтервалы.Колонки.Добавить("КонецИнтервала");
	
	ДатаКон = ?(ПараметрыОтчета.Период = '00010101', ТекущаяДатаСеанса(), ПараметрыОтчета.Период);
	ПараметрыОтчета.Интервалы.Сортировать("Значение Возр");
	Индекс = 1;
	Первый = Истина;
	ПредыдущееЗначение = 0;
	Для Каждого Интервал Из ПараметрыОтчета.Интервалы Цикл
		НоваяСтрока = ТабИнтервалы.Добавить();
		НоваяСтрока.ИмяИнтервала    = Интервал.Представление;
		НоваяСтрока.НомерИнтервала  = Индекс;
		Если Первый Тогда  
			НоваяСтрока.НачалоИнтервала = НачалоДня(ДатаКон) - Интервал.Значение * Сутки;
			НоваяСтрока.КонецИнтервала  = КонецДня(ДатаКон);
			ПредыдущееЗначение = Интервал.Значение;
			Первый = Ложь;
		Иначе
			НоваяСтрока.НачалоИнтервала = НачалоДня(ДатаКон) - Интервал.Значение * Сутки;
			НоваяСтрока.КонецИнтервала  = КонецДня(ДатаКон)  - (ПредыдущееЗначение + 1) * Сутки;
			ПредыдущееЗначение = Интервал.Значение;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Для каждого СтрокаИнтервала из ТабИнтервалы Цикл
		ИмяПараметра = "НачалоИнтервала" + СтрокаИнтервала.НомерИнтервала;
		Параметр = Схема.Параметры.Найти(ИмяПараметра);
		Если Параметр = Неопределено Тогда
			Параметр = Схема.Параметры.Добавить();
			Параметр.Имя = ИмяПараметра;
		КонецЕсли;
		
		ИмяПараметра = "КонецИнтервала" + СтрокаИнтервала.НомерИнтервала;
		Параметр = Схема.Параметры.Найти(ИмяПараметра);
		Если Параметр = Неопределено Тогда
			Параметр = Схема.Параметры.Добавить();
			Параметр.Имя = ИмяПараметра;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	
	Для каждого СтрокаИнтервала из ТабИнтервалы Цикл
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоИнтервала" + СтрокаИнтервала.НомерИнтервала, СтрокаИнтервала.НачалоИнтервала);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецИнтервала" + СтрокаИнтервала.НомерИнтервала, СтрокаИнтервала.КонецИнтервала);
	КонецЦикла;
	
КонецПроцедуры

Функция ПорядокИтоговВМониторе() Экспорт
	
	Возврат 0;
	
КонецФункции

Функция ПорядокЗадолженностейВМониторе() Экспорт
	
	Возврат 1;
	
КонецФункции

Процедура ВывестиПримечания(ПараметрыОтчета, Результат)
	
	Если НЕ ПараметрыОтчета.ВыводитьПримечания Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОтчета.ВыводитьПодвал Тогда
		ОбластьПодписи = Результат.Области.Найти("Подписи");
		ЗавершениеТаблицы = ОбластьПодписи.Верх;
	Иначе
		ЗавершениеТаблицы = Результат.ВысотаТаблицы;
	КонецЕсли;
	
	СрокОплаты = Константы.СрокОплатыПоставщикам.Получить();
	
	Примечания = ПолучитьМакет("Примечания");
	Примечания.Параметры.СрокОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 дн.'"), СрокОплаты);
	Примечания.Параметры.Ссылка = "e1cib/command/ОбщаяКоманда.СрокОплатыПоставщикам";
	
	Примечание = Примечания.Область(?(СрокОплаты = 0, "СрокОплатыНеУстановлен", "УстановленСрокОплаты"));
		
	Результат.ВставитьОбласть(Примечание, Результат.Область("R" + Строка(ЗавершениеТаблицы)),, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли