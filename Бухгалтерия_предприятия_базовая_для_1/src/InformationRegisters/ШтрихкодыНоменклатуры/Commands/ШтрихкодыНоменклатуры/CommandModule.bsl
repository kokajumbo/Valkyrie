
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура", ПараметрКоманды);

	ОткрытьФорму("РегистрСведений.ШтрихкодыНоменклатуры.ФормаСписка", Новый Структура("Отбор", Отбор), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры
