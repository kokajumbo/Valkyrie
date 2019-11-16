#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	Док.Ссылка      КАК Регистратор,
		|	Док.Организация КАК Организация,
		|	Док.Дата        КАК Период
		|ИЗ
		|	Документ.ВыработкаОС КАК Док
		|ГДЕ
		|	Док.Ссылка = &Ссылка
		|";

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Если НЕ Выборка.Следующий() ИЛИ НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, Выборка.Регистратор) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;

	НомераТаблиц = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);

	Запрос.Текст = ТекстЗапросаОС(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Процедура ДвиженияПоРегистрам(ТаблицаОС, Движения) Экспорт

	Для Каждого ТекущаяСтрока из ТаблицаОС Цикл
		Движение = Движения.ВыработкаОС.Добавить();
		Движение.Период            = ТекущаяСтрока.Период;
		Движение.Организация       = ТекущаяСтрока.Организация;
		Движение.ОсновноеСредство  = ТекущаяСтрока.ОсновноеСредство;
		Движение.ПараметрВыработки = ТекущаяСтрока.ПараметрВыработки;
		Движение.Количество        = ТекущаяСтрока.Количество;
	КонецЦикла;

	Движения.ВыработкаОС.Записывать = Истина;

КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

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

Функция ТекстЗапросаОС(НомераТаблиц)

	НомераТаблиц.Вставить("ТабличнаяЧасть", НомераТаблиц.Количество());

	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Док.Ссылка             КАК Регистратор,
		|	Док.Ссылка.Организация КАК Организация,
		|	Док.Ссылка.Дата        КАК Период,
		|	Док.НомерСтроки        КАК НомерСтроки,
		|	Док.ОсновноеСредство   КАК ОсновноеСредство,
		|	Док.ПараметрВыработки  КАК ПараметрВыработки,
		|	Док.Количество         КАК Количество
		|ИЗ
		|	Документ.ВыработкаОС.ОС КАК Док
		|ГДЕ
		|	Док.Ссылка = &Ссылка
		|УПОРЯДОЧИТЬ ПО
		|	Док.Ссылка.Дата,
		|	Док.Ссылка,
		|	Док.НомерСтроки
		|";

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#КонецЕсли