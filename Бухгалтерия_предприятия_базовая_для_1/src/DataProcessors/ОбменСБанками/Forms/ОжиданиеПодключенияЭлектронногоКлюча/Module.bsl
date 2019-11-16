#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ИдентификаторКлюча = Параметры.ИдентификаторКлюча;
	
	Если Не ЗначениеЗаполнено(ИдентификаторКлюча) Тогда
		Элементы.ИдентификаторКлюча.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПодключениеЭлектронногоКлюча", 2);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПодключениеЭлектронногоКлюча");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьПодключениеЭлектронногоКлюча()
	
	ПараметрыПодсистемыОбменСБанками = ПараметрыПриложения["ЭлектронноеВзаимодействие.ОбменСБанками"];
	ПодключаемыйМодуль = ПараметрыПодсистемыОбменСБанками.Получить("ПодключаемыйМодуль");
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияИдентификаторовКлючей", ЭтотОбъект);
	ОбменСБанкамиСлужебныйКлиент.ПолучитьИдентификаторыПодключенныхКлючейЧерезВК(Оповещение, ПодключаемыйМодуль);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияИдентификаторовКлючей(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		Закрыть(Результат);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторКлюча) И Результат.Найти(ИдентификаторКлюча) <> Неопределено Тогда
		МассивВозврата = Новый Массив;
		МассивВозврата.Добавить(ИдентификаторКлюча);
		Закрыть(МассивВозврата);
	ИначеЕсли НЕ ЗначениеЗаполнено(ИдентификаторКлюча) И Результат.Количество() > 0 Тогда
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти