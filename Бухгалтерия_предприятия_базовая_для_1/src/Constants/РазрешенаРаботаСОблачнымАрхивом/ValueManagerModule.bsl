///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Нельзя установить константу в ИСТИНА, если запрещена работа с облачным архивом.
	Если НЕ ОблачныйАрхивПовтИсп.ВозможнаРаботаСОблачнымАрхивом() Тогда
		Если Значение = Истина Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// В зависимости от текущего значения константы отключить или включить использование регламентного задания "ВсеОбновленияНовостей".
	ОблачныйАрхив.ИзменитьИспользованиеРегламентныхЗаданий(Значение);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
