
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("РазделЗакупки", Истина);
	ОткрытьФорму("Обработка.ПанельОбменСЕГАИС.Форма.Форма",
	             ПараметрыФормы,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно, 
	             ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти