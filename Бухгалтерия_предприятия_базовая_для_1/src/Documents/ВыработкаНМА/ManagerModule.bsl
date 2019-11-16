#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация
	|ИЗ
	|	Документ.ВыработкаНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаТаблицыДокумента(НомераТаблиц);
		
	Результат = Запрос.ВыполнитьПакет();
	
	Для Каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

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

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаТаблицыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаНМА",            НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаНМА.Ссылка,
	|	ТаблицаНМА.Ссылка.Дата КАК Период,
	|	ТаблицаНМА.Ссылка КАК Регистратор,
	|	ТаблицаНМА.Ссылка.Организация КАК Организация,
	|	ТаблицаНМА.НомерСтроки КАК НомерСтроки,
	|	ТаблицаНМА.НематериальныйАктив,
	|	ТаблицаНМА.Количество
	|ИЗ
	|	Документ.ВыработкаНМА.НМА КАК ТаблицаНМА
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли