
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.Заголовок = НСтр("ru='Складские документы'");
	ПараметрыОткрытия.ИмяФормы  = "ЖурналДокументов.СкладскиеДокументы.ФормаСписка";

	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия);
	
КонецПроцедуры
