#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПередЗаписью(ЭтотОбъект);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблицПередЗаписью", МенеджерВременныхТаблиц);
	ЗарплатаКадрыПериодическиеРегистры.СоздатьВТСтарыйНаборЗаписей(ЭтотОбъект, МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПриЗаписи(ЭтотОбъект);
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблицПередЗаписью;
	
	ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
	ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
	ПараметрыПостроения.ПараметрыРесурсов = РегистрыСведений.ВидыЗанятостиСотрудников.ПараметрыНаследованияРесурсов();
	
	ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистраПоИзменениям(
		"ВидыЗанятостиСотрудников", 
		ЭтотОбъект, 
		МенеджерВременныхТаблиц, 
		ПараметрыПостроения);
	
	КадровыйУчет.ОбновитьОсновныхСотрудниковФизическихЛицПоТрудовымДоговорам(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли