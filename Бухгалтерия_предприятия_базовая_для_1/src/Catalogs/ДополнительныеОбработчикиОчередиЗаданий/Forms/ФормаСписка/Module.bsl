
#Область ОбработчикиСобытийЭлементовФормы

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого СтрокаСписка Из Строки Цикл
		
		РегламентноеЗадание = Справочники.ДополнительныеОбработчикиОчередиЗаданий.РегламентноеЗадание(СтрокаСписка.Ключ);
	
		Если РегламентноеЗадание = Неопределено Тогда
			ПредставлениеРасписания = НСтр("ru = 'Не задано'");
			Использование = Ложь;
		Иначе
			Расписание = РегламентноеЗадание.Расписание;
			ПредставлениеРасписания = Строка(Расписание);
			Использование = РегламентноеЗадание.Использование;
		КонецЕсли;
		
		Оформление = СтрокаСписка.Значение.Оформление.Получить("ПредставлениеРасписания");
		Если Оформление <> Неопределено Тогда
			Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеРасписания);
		КонецЕсли;
		
		Если Не Использование Тогда
			Для Каждого ОФормление Из СтрокаСписка.Значение.Оформление Цикл
				ОФормление.Значение.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
