
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета",    "ДоходыРасходы");
	Вариант.Вставить("КлючВарианта", "ДоходыРасходы");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры
