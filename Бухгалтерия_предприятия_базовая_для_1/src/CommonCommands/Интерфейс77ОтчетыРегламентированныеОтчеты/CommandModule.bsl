
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючеваяОперация = "СозданиеФормыРегламентированнаяОтчетность";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Отчеты"));
	
	ФормаУправлениеОтчетностью = ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыОткрытия, 
		ПараметрыВыполненияКоманды.Источник, 
		"1С-Отчетность", 
		ПараметрыВыполненияКоманды.Окно);
	
	Оповестить("Открытие формы 1С-Отчетность", ПараметрыОткрытия);
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("ПоказыватьКнопки", Истина);
	
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ПредложениеОформитьЗаявлениеНаПодключение", ПараметрыСообщения,
		ФормаУправлениеОтчетностью,
		Истина,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

