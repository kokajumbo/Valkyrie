#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаУтратыПрава = ТекущаяДатаСеанса();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	Закрыть(ДатаУтратыПрава);
КонецПроцедуры

#КонецОбласти
