#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокДокументов = Параметры.СписокДокументов;
	
	КоличествоДокументов = СписокДокументов.Количество();
	Если КоличествоДокументов = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	КоллекцияСтатусов = РегистрыСведений.СтатусыДокументов.ПолучитьСтатусыДокументов(СписокДокументов.ВыгрузитьЗначения());
	
	СтатусыДокумента = КоллекцияСтатусов[СписокДокументов[0].Значение];
	СтатусОплаты   = СтатусыДокумента.Статус;
	СтатусПоступления = СтатусыДокумента.ДополнительныйСтатус;
	
	// Проверим совпадают ли статусы всех выбранных документов
	Для Индекс = 1 По КоллекцияСтатусов.Количество() - 1 Цикл
		СтатусыДокумента = КоллекцияСтатусов[СписокДокументов[Индекс].Значение];
		Если ЗначениеЗаполнено(СтатусОплаты) И СтатусОплаты <> СтатусыДокумента.Статус Тогда
			СтатусОплаты = Перечисления.СтатусОплатыСчета.ПустаяСсылка();
		КонецЕсли;
		Если ЗначениеЗаполнено(СтатусПоступления) И СтатусПоступления <> СтатусыДокумента.ДополнительныйСтатус Тогда
			СтатусПоступления = Перечисления.СтатусыОтгрузки.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И Не ЗавершениеРаботы Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Изменения не записаны. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если СохранитьИзменения() Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если СохранитьИзменения() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	СписокДокументов = Форма.СписокДокументов;
	
	КоличествоДокументов = СписокДокументов.Количество();
	
	Если КоличествоДокументов = 1 Тогда
		Форма.Заголовок = Строка(СписокДокументов[0].Значение);
	Иначе
		Форма.Заголовок = СтрШаблон(НСтр("ru = 'Изменить статусы документов (%1)'"), СписокДокументов.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СохранитьИзменения()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Если УстановитьСтатусДокументовНаСервере(СписокДокументов.ВыгрузитьЗначения(), СтатусОплаты, СтатусПоступления) Тогда
		
		ОповеститьОбИзменении(Тип("ДокументСсылка.СчетНаОплатуПоставщика"));
		Если Не ВладелецФормы.ОтображатьСтатусыДокументов Тогда
			ОбщегоНазначенияБПКлиент.ОповеститьОбИзмененииСтатусовДокументов(
				ВладелецФормы, СписокДокументов, СтатусОплаты, СтатусПоступления);
		КонецЕсли;
			
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьСтатусДокументовНаСервере(Знач МассивДокументов, Знач СтатусОплаты, Знач СтатусОтгрузки)
	
	СтатусИзменен = РегистрыСведений.СтатусыДокументов.УстановитьСтатусыДокументов(
		МассивДокументов, СтатусОплаты, СтатусОтгрузки);
	
	Возврат СтатусИзменен;
	
КонецФункции

#КонецОбласти