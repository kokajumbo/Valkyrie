

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Иммунизация") Тогда
		Для каждого Строка Из Параметры.Иммунизация Цикл
			ЗаполнитьЗначенияСвойств(Иммунизация.Добавить(), Строка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИммунизация

&НаКлиенте
Процедура ИммунизацияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "Иммунизация");
	
КонецПроцедуры

&НаКлиенте
Процедура ИммунизацияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	СформироватьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ИммунизацияПослеУдаления(Элемент)
	СформироватьЗаголовокФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьИзменения();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения()
	
	СтруктураПроверяемыхПолей = Новый Структура;
	СтруктураПроверяемыхПолей.Вставить("ТипИммунизации", НСтр("ru='Тип'"));
	СтруктураПроверяемыхПолей.Вставить("НаименованиеБолезниПаразита", НСтр("ru='Наименование болезни / паразита'"));
	СтруктураПроверяемыхПолей.Вставить("ДатаПроведенияИммунизацииОбработки", НСтр("ru='Дата проведения'"));
	
	Если ИнтеграцияВЕТИСКлиент.ПроверитьЗаполнениеТаблицы(ЭтаФорма, "Иммунизация", СтруктураПроверяемыхПолей) Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(Иммунизация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Иммунизация'")
		+ ?(Иммунизация.Количество()," ("+Иммунизация.Количество()+")","");
	
КонецПроцедуры

#КонецОбласти