
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеПатента = Параметры.ДанныеПатента;
	НомерПлатежа = ДанныеПатента.НомерПлатежа;
	
	СписокПлатежей = Элементы.Платеж.СписокВыбора;
	Для каждого Платеж Из ДанныеПатента.СписокПлатежей Цикл
		ЗаполнитьЗначенияСвойств(СписокПлатежей.Добавить(), Платеж);
	КонецЦикла;
	
	Заголовок = СтрШаблон(Нстр("ru = 'Оплата патента: %1'"), ДанныеПатента.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ДанныеПатента.Вставить("НомерПлатежа", НомерПлатежа);
	Закрыть(ДанныеПатента);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры
