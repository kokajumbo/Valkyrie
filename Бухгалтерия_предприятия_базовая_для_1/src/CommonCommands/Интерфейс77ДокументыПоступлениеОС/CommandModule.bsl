
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УсловияЗаполнения = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ОбъектыСтроительства"));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", УсловияЗаполнения);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры 