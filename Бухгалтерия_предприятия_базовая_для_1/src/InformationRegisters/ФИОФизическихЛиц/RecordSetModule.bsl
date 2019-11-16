#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Не ПустаяСтрока(Запись.Имя) Тогда
			ИнициалыИмени = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ИнициалыИмени(Запись.Имя);
		Иначе
			ИнициалыИмени = "";
		КонецЕсли;
		
		Запись.ИнициалыИмени = ИнициалыИмени;
		Запись.ФИОСлужебные = ФизическиеЛицаЗарплатаКадры.НаименованиеСлужебноеПоЧастямИмени(
			Запись.Фамилия, Запись.Имя, Запись.Отчество);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ОбработатьЗаписьНабораФИО(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли