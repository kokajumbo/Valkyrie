
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.ОбработчикОткрытияФормы = Новый ОписаниеОповещения("ОбработчикОткрытияФормы",
		ЭтотОбъект, ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.Заголовок = НСтр("ru = 'Сверки'");
	ПараметрыОткрытия.ЗамерПроизводительности = "СозданиеФормыРегламентированнаяОтчетность";
	
	ПараметрыФормы = Новый Структура;

	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОткрытияФормы(ПараметрыФормы, ПараметрыВыполненияКоманды) Экспорт

	ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Сверки"));
	
	ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"1С-Отчетность",
		ПараметрыВыполненияКоманды.Окно);
	
	Оповестить("Открытие формы 1С-Отчетность", ПараметрыФормы);
	
КонецПроцедуры
