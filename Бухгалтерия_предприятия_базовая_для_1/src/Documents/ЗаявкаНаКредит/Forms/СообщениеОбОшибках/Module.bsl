
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	// Сформируем текст краткого сообщения о результатах отправки.
	Если Параметры.КоличествоУспешноОбработано > 0 Тогда
		Если Параметры.КоличествоУспешноОбработано > 1 Тогда
			КоличествоПрописью = " " + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru='; в %1 банк;; в %1 банка; в %1 банков; в банков %1'"), 
				Параметры.КоличествоУспешноОбработано);
		Иначе
			КоличествоПрописью = "";
		КонецЕсли;
		
		Если Параметры.ТипТранзакции = Перечисления.ТипыТранзакцийОбменаСБанкамиЗаявкиНаКредит.ЗаявкаНаКредит Тогда
			ШаблонТекста = НСтр("ru = 'Заявка на кредит успешно отправлена%1.'");
		ИначеЕсли Параметры.ТипТранзакции = Перечисления.ТипыТранзакцийОбменаСБанкамиЗаявкиНаКредит.АкцептЗаемщика Тогда
			ШаблонТекста = НСтр("ru = 'Согласие с условиями кредита успешно отправлено%1.'");
		Иначе
			ШаблонТекста = НСтр("ru = 'Сообщение успешно отправлено%1.'");
		КонецЕсли;
		Элементы.НадписьОшибка.Заголовок = СтрШаблон(ШаблонТекста, КоличествоПрописью);

	Иначе
		Элементы.НадписьОшибка.Заголовок = НСтр("ru = 'Возникли ошибки:'");
	КонецЕсли;

	Подстроки = Новый Массив;
	
	Если ЗначениеЗаполнено(Параметры.НеОтправленныеТранзакции) Тогда
		// Определим перечень банков, с которыми возникли проблемы.
		НаименованияБанков = НаименованияБанков(Параметры.НеОтправленныеТранзакции);
		Подстроки.Добавить(СтрШаблон(НСтр("ru = 'Не отправлено в %1'"), СтрСоединить(НаименованияБанков, ", ")));
	КонецЕсли;
	
	ПозицияСкобки = СтрНайти(Параметры.ОписаниеОшибки, "{");
	Если ПозицияСкобки = 0 Тогда
		
		Подстроки.Добавить(Параметры.ОписаниеОшибки);
		ОписаниеОшибки = СтрСоединить(Подстроки, Символы.ПС);
		Элементы.ГруппаПодробнее.Видимость = Ложь;
		
	Иначе
		
		Подстроки.Добавить(Лев(Параметры.ОписаниеОшибки, ПозицияСкобки - 1));
		ОписаниеОшибки = СтрСоединить(Подстроки, Символы.ПС);
		
		ПодробноеОписаниеОшибки = Сред(Параметры.ОписаниеОшибки, ПозицияСкобки + 1);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НаименованияБанков(Транзакции)
	
	РеквизитыТранзакций = УниверсальныйОбменСБанками.РеквизитыТранзакций(Транзакции);
	
	Банки = РеквизитыТранзакций.ВыгрузитьКолонку("Банк");
	
	РеквизитыБанков = УниверсальныйОбменСБанками.РеквизитыБанков(Банки, "Наименование");
	
	Результат = Новый Массив;
	Для каждого РеквизитБанка Из РеквизитыБанков Цикл
		Результат.Добавить(РеквизитБанка.Наименование);
	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти