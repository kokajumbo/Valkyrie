
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", ПолучитьПараметрыОткрытиФормы(),
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОткрытиФормы()
	
	Возврат Новый Структура("Ключ", Справочники.Организации.ОрганизацияПоУмолчанию());
	
КонецФункции
