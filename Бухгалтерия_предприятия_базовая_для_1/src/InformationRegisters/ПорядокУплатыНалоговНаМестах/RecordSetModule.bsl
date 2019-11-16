#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.СрокУплатыНалогаМесяцев = Макс(0, Запись.СрокУплатыНалогаМесяцев);
		РегистрыСведений.ПорядокУплатыНалоговНаМестах.УстановитьОписание(Запись);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли