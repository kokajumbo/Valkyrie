#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при сканировании штрихкода в форме объекта.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая при завершении обработки,
//  Форма - УправляемаяФорма - форма, в которой отсканирован штрихкод,
//  Источник - Строка - источник внешнего события,
//  Событие - Строка - наименование события,
//  Данные - Строка - данные для события,
//  ПараметрыСканирования - Структура - параметры сканирования акцизных марок.
//
Процедура ВнешнееСобытиеПолученыШтрихкоды(ОповещениеПриЗавершении, Форма, Источник, Событие, Данные, ПараметрыСканирования = Неопределено) Экспорт
	
	Если Не Форма.ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(Форма.ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0 Тогда
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
			Истина, "ОбщийМодуль.СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды");
		
		ДанныеШтрихкода = ПреобразоватьДанныеСоСканераВСтруктуру(Результат.Параметр);
		
		ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
			ОповещениеПриЗавершении, Форма, ДанныеШтрихкода, ПараметрыСканирования);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при сканировании штрихкода в форме объекта.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой отсканирован штрихкод,
//  Источник - Строка - источник внешнего события,
//  Событие - Строка - наименование события,
//  Данные - Строка - данные для события,
//  КэшированныеЗначения - Структура - кэш формы документа.
//
Процедура ВнешнееСобытиеОбработатьВводШтрихкода(Форма, Источник, Событие, Данные, КэшированныеЗначения) Экспорт
	
	Если Не Форма.ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(Форма.ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0 Тогда
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
			Истина, "ОбщийМодуль.СобытияФормИСКлиент.ВнешнееСобытиеОбработатьВводШтрихкода");
		
		ДанныеШтрихкода = ПреобразоватьДанныеСоСканераВСтруктуру(Результат.Параметр);
		
		ШтрихкодированиеИСКлиент.ОбработатьВводШтрихкода(Форма, ДанныеШтрихкода, КэшированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм преобразования данных из подсистемы подключаемого оборудования.
//
// Параметры:
//  Параметр - Массив - входящие данные.
//
// Возвращаемое значение:
//  Массив - Массив структур со свойствами:
//   * Штрихкод
//   * Количество
Функция ПреобразоватьДанныеСоСканераВМассив(Параметр) Экспорт
	
	Результат = Новый Массив;
	СобытияФормИСКлиентПереопределяемый.ПреобразоватьДанныеСоСканераВМассив(Результат, Параметр);
	Возврат Результат;
	
КонецФункции

// В процедуре нужно реализовать алгоритм преобразования данных из подсистемы подключаемого оборудования.
//
// Параметры:
//  Параметр - Массив - входящие данные.
//
// Возвращаемое значение:
//  Структура - структура со свойствами:
//   * Штрихкод
//   * Количество
Функция ПреобразоватьДанныеСоСканераВСтруктуру(Параметр) Экспорт
	
	Результат = Новый Структура("Штрихкод,Количество");
	СобытияФормИСКлиентПереопределяемый.ПреобразоватьДанныеСоСканераВСтруктуру(Результат, Параметр);
	Возврат Результат;
	
КонецФункции

Процедура СообщитьОбОшибке(РезультатВыполнения) Экспорт
	
	ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти
