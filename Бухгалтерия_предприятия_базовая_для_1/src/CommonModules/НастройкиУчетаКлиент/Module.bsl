
////////////////////////////////////////////////////////////////////////////////
// Универсальные методы для формы записи регистра и формы настройки налогов
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаНавигационнойСсылкиСистемаНалогообложения(Форма, Организация, Период) Экспорт
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Период) Тогда
		КлючЗаписиУчетнойПолитики = НастройкиУчетаВызовСервера.КлючЗаписиУчетнойПолитики("НастройкиСистемыНалогообложения", Организация, Период);
	КонецЕсли;
	
	Если КлючЗаписиУчетнойПолитики <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", КлючЗаписиУчетнойПолитики);
		
		ОткрытьФорму("РегистрСведений.НастройкиСистемыНалогообложения.ФормаЗаписи", ПараметрыФормы, Форма);
		
	Иначе
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Организация));
		
		ОткрытьФорму("РегистрСведений.НастройкиСистемыНалогообложения.ФормаСписка", ПараметрыФормы, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти