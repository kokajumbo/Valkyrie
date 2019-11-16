#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Элементы.Телефон.Видимость = ЗначениеЗаполнено(Параметры.Телефон);
	Элементы.ИдентификаторСессии.Видимость = ЗначениеЗаполнено(Параметры.ИдентификаторСессии);
	Телефон = Параметры.Телефон;
	ИдентификаторСессии = Параметры.ИдентификаторСессии;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если ПустаяСтрока(Пароль) Тогда
		ТекстСообщения = НСтр("ru = 'Для продолжения укажите одноразовый пароль.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Пароль");
		Возврат;
	КонецЕсли;
	
	Закрыть(Пароль);
	
КонецПроцедуры

#КонецОбласти
