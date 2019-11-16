#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("АналитикаЗатрат") Тогда
			ЗаполнитьАналитикойЗатрат(ДанныеЗаполнения.АналитикаЗатрат);
			Возврат;
		КонецЕсли;
		
		ЗаполнениеДокументов.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьАналитикойЗатрат(АналитикаЗатрат)
	
	Счет = УчетЗатрат.ЗначениеАналитикиЗатрат(АналитикаЗатрат, Тип("ПланСчетовСсылка.Хозрасчетный"));
	
	ШаблонНаименования = НСтр("ru = 'Амортизация (счет %1)'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	АналитикаЗатратДляЗаписи      = УчетЗатрат.АналитикаЗатратДляЗаписи(АналитикаЗатрат);
	АналитикаЗатратНомераСубконто = УчетЗатрат.АналитикаЗатратНомераСубконто(АналитикаЗатратДляЗаписи);
	
	// Для однозначности прочтения, в коде непосредственного заполнения свойств явно указан ЭтотОбъект
	ЭтотОбъект.Наименование = СтрШаблон(ШаблонНаименования, Счет);
	ПравилоРаспределения = ЭтотОбъект.Способы.Добавить();
	ПравилоРаспределения.СчетЗатрат  = Счет;
	ЗаполнитьЗначенияСвойств(ПравилоРаспределения, АналитикаЗатратНомераСубконто); // Субконто
	// Подразделение здесь не заполняем, поскольку эти способы независимы от организации
	ПравилоРаспределения.Коэффициент = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли