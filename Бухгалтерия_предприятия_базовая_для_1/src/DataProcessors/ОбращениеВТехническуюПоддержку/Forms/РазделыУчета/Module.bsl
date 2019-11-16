#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДеревоРазделыУчета = РеквизитФормыВЗначение("РазделыУчета");
	
	МакетРазделыУчета = Обработки.ОбращениеВТехническуюПоддержку.ПолучитьМакет("РазделыУчета");
	ОбластьВсеРазделы = МакетРазделыУчета.ПолучитьОбласть("ВсеРазделы");
	Верх              = ОбластьВсеРазделы.Область().Верх;
	Низ               = ОбластьВсеРазделы.Область().Низ;
	
	Для НомерСтроки = Верх По Низ Цикл
		Область = ОбластьВсеРазделы.Область(НомерСтроки, 1, НомерСтроки, 1);
		Если Область.Отступ = 0 Тогда
			СтрокаРазделыУчета = ДеревоРазделыУчета.Строки.Добавить();
			СтрокаВерхнийУровень = СтрокаРазделыУчета;
		Иначе
			СтрокаРазделыУчета = СтрокаВерхнийУровень.Строки.Добавить();
		КонецЕсли;
		СтрокаРазделыУчета.РазделУчета = Область.Текст;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоРазделыУчета, "РазделыУчета");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьРаздел();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыРазделыУчета

&НаКлиенте
Процедура РазделыУчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьРаздел();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьРаздел()
	
	ТекущиеДанные = Элементы.РазделыУчета.ТекущиеДанные;
	Если ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда
		Возврат;
	Иначе
		Закрыть(ТекущиеДанные.РазделУчета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти