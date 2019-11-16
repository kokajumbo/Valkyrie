#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ЗначениеЯвляетсяДолжностьюЛетногоЭкипажа = 
		ПолучитьФункциональнуюОпцию("ИспользуетсяТрудЧленовЛетныхЭкипажей") И ЯвляетсяДолжностьюЛетногоЭкипажа;
		
	ЗначениеЯвляетсяШахтерскойДолжностью =
		ПолучитьФункциональнуюОпцию("ИспользуетсяТрудШахтеров") И ЯвляетсяШахтерскойДолжностью;
		
	ЗначениеЯвляетсяФармацевтическойДолжностью = 
		ПолучитьФункциональнуюОпцию("ИспользуетсяТрудФармацевтов") И ЯвляетсяФармацевтическойДолжностью;
		
	ТекстСообщения = "";
	
	Если ЗначениеЯвляетсяДолжностьюЛетногоЭкипажа И ЗначениеЯвляетсяШахтерскойДолжностью Тогда
		ТекстСообщения = НСтр("ru='члена летного экипажа и шахтера'");
	КонецЕсли;
	
	Если ЗначениеЯвляетсяДолжностьюЛетногоЭкипажа И ЗначениеЯвляетсяФармацевтическойДолжностью Тогда
		Если ПустаяСтрока(ТекстСообщения) Тогда
			ТекстСообщения = НСтр("ru='члена летного экипажа и фармацевта'");
		Иначе
			ТекстСообщения = СтрЗаменить(ТекстСообщения, " " + НСтр("ru='и'") + " ", ", ");
			ТекстСообщения = ТекстСообщения + " " + НСтр("ru='и фармацевта'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЯвляетсяШахтерскойДолжностью И ЗначениеЯвляетсяФармацевтическойДолжностью Тогда
		Если ПустаяСтрока(ТекстСообщения) Тогда
			ТекстСообщения = НСтр("ru='шахтера и фармацевта'");
		ИначеЕсли НЕ ЗначениеЯвляетсяДолжностьюЛетногоЭкипажа И ЗначениеЯвляетсяФармацевтическойДолжностью Тогда
			ТекстСообщения = СтрЗаменить(ТекстСообщения, " " + НСтр("ru='и'") + " ", ", ");
			ТекстСообщения = ТекстСообщения + " " + НСтр("ru='и фармацевта'");
		КонецЕсли;
	КонецЕсли;
		
	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		
		ТекстСообщения = НСТр("ru='Должность не может одновременно являться должностью'") + " " + ТекстСообщения + ".";
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(НаименованиеКраткое) Тогда
		НаименованиеКраткое = Наименование;
	КонецЕсли; 
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли