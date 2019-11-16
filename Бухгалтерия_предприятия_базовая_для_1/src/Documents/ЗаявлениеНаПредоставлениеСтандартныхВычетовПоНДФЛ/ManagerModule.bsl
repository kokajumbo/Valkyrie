#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

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
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Сотрудник)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке("Сотрудник", "");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Функция КонфликтующиеРегистраторы(Регистратор, Месяц, Сотрудник, МассивВычетов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПрименениеСтандартныхВычетовПоНДФЛ.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПрименениеСтандартныхВычетовПоНДФЛ.Регистратор) КАК ПредставлениеРегистратора
		|ИЗ
		|	РегистрСведений.ПрименениеСтандартныхВычетовПоНДФЛ КАК ПрименениеСтандартныхВычетовПоНДФЛ
		|ГДЕ
		|	ПрименениеСтандартныхВычетовПоНДФЛ.Период = &Период
		|	И ПрименениеСтандартныхВычетовПоНДФЛ.ФизическоеЛицо = &ФизическоеЛицо
		|	И ПрименениеСтандартныхВычетовПоНДФЛ.Регистратор <> &Регистратор
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтандартныеВычетыНаДетейНДФЛ.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СтандартныеВычетыНаДетейНДФЛ.Регистратор)
		|ИЗ
		|	РегистрСведений.СтандартныеВычетыНаДетейНДФЛ КАК СтандартныеВычетыНаДетейНДФЛ
		|ГДЕ
		|	СтандартныеВычетыНаДетейНДФЛ.МесяцРегистрации = &Период
		|	И СтандартныеВычетыНаДетейНДФЛ.ФизическоеЛицо = &ФизическоеЛицо
		|	И СтандартныеВычетыНаДетейНДФЛ.КодВычета В(&КодыВычетов)
		|	И СтандартныеВычетыНаДетейНДФЛ.Регистратор <> &Регистратор
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтандартныеВычетыФизическихЛицНДФЛ.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СтандартныеВычетыФизическихЛицНДФЛ.Регистратор)
		|ИЗ
		|	РегистрСведений.СтандартныеВычетыФизическихЛицНДФЛ КАК СтандартныеВычетыФизическихЛицНДФЛ
		|ГДЕ
		|	СтандартныеВычетыФизическихЛицНДФЛ.ФизическоеЛицо = &ФизическоеЛицо
		|	И СтандартныеВычетыФизическихЛицНДФЛ.Период = &Период
		|	И СтандартныеВычетыФизическихЛицНДФЛ.Регистратор <> &Регистратор";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо",	Сотрудник);
	Запрос.УстановитьПараметр("Период",			Месяц);
	Запрос.УстановитьПараметр("Регистратор",	Регистратор);
	Запрос.УстановитьПараметр("КодыВычетов",	МассивВычетов);
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти

#КонецЕсли