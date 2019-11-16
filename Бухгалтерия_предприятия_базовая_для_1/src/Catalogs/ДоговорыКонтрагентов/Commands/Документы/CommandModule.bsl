&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Документы по договору'"));
	ПараметрыФормы.Вставить("Отбор", Новый Структура("ДоговорКонтрагента", ПараметрКоманды));
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ДокументыПоДоговоруКонтрагента");
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.ИмяФормы = "ЖурналДокументов.ЖурналОпераций.ФормаСписка";
	ПараметрыОткрытия.Заголовок = ПараметрыФормы.Заголовок;
	ПараметрыОткрытия.ЗамерПроизводительности = Истина;
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);
	
КонецПроцедуры
