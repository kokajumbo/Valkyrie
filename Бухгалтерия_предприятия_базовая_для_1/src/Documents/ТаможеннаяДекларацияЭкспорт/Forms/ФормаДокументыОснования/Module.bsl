
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДанныеЗаполнения.Свойство("СписокДокументовОснований") Тогда
		
		Основания = Параметры.ДанныеЗаполнения.СписокДокументовОснований;
		
		Для Каждого Основание Из Основания Цикл
			СтрокаДокументОснование = ДокументыОснования.Добавить();
			СтрокаДокументОснование.ДокументОснование = Основание.Значение;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура") Тогда
		Параметры.Отбор.Свойство("Организация", Организация);
	КонецЕсли;
	
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросСохранитьИзмененияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросСохранитьИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиДанные();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиДанные()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	СписокДокументовОснований = Новый СписокЗначений;
	
	Для Индекс = 0 По ДокументыОснования.Количество() - 1 Цикл
		
		СтрокаТаблицы = ДокументыОснования[Индекс];
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументОснование) Тогда
			Текст = СтрШаблон(НСтр("ru = 'В строке %1 не выбран документ.'"), Индекс + 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"ДокументыОснования["+Индекс+"].ДокументОснование",
				,
				Отказ);
		КонецЕсли;
		
		Если СписокДокументовОснований.НайтиПоЗначению(СтрокаТаблицы.ДокументОснование) <> Неопределено
			И ЗначениеЗаполнено(СтрокаТаблицы.ДокументОснование) Тогда
			Текст = СтрШаблон(НСтр("ru = 'В строке %1 повторно указан документ %2.'"),
				Индекс + 1,
				СтрокаТаблицы.ДокументОснование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"ДокументыОснования["+Индекс+"].ДокументОснование",
				,
				Отказ);
		КонецЕсли;
		
		СписокДокументовОснований.Добавить(СтрокаТаблицы.ДокументОснование);
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(СписокДокументовОснований);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти