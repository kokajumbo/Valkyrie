////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураНастроек = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ПодборНоменклатуры", "");
	
	ЗапрашиватьКоличество 	= Истина;
	ЗапрашиватьЦену 		= Истина;
	
	Если СтруктураНастроек <> Неопределено Тогда
		СтруктураНастроек.Свойство("ЗапрашиватьКоличество", ЗапрашиватьКоличество);
		СтруктураНастроек.Свойство("ЗапрашиватьЦену", ЗапрашиватьЦену);
	КонецЕсли;
	
	Элементы.ЗапрашиватьЦену.Доступность       = Параметры.ЕстьЦена;
	Элементы.ЗапрашиватьКоличество.Доступность = Параметры.ЕстьКоличество;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ЗапрашиватьКоличество", ЗапрашиватьКоличество);
	ПараметрыЗакрытия.Вставить("ЗапрашиватьЦену"      , ЗапрашиватьЦену);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ПодборНоменклатуры", "", ПараметрыЗакрытия);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры
