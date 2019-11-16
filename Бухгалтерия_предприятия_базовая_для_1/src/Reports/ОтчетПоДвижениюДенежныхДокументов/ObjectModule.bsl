#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НачалоПериода > КонецПериода 
		И Не КонецПериода = '00010101' Тогда
		ТекстСообщения = НСтр("ru = 'Неправильно задан период формирования отчета!
		                             |Дата начала больше даты окончания периода.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Отчет.НачалоПериода",, Отказ);	
	КонецЕсли;
	
КонецПроцедуры
#КонецЕсли