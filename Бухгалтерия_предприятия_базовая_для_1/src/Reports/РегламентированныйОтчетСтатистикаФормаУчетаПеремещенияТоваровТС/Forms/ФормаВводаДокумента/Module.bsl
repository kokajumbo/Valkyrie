
&НаКлиенте
Перем СтруктураРеквизитов;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДокВыбор = Параметры.ДокВыбор;
	ДокНомер = Параметры.ДокНомер;
	ДокДата  = Параметры.ДокДата;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОКНажатие(Команда)
	    	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеПродолжение", ЭтотОбъект);
	ПрименитьИзменения(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
		
			ТекстПредупреждения = НСтр("ru='Данные были изменены.
											|Перед завершением работы рекомендуется сохранить измененные данные,
											|иначе изменения будут утеряны.'");
			
			Возврат;
		
		КонецЕсли;
				
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Применить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,  РежимДиалогаВопрос.ДаНетОтмена);
				
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеПродолжение", ЭтотОбъект);
		ПрименитьИзменения(ОписаниеОповещения);
				
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершениеПродолжение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Истина Тогда
		
		Модифицированность = Ложь;
		Закрыть(СтруктураРеквизитов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьИзменения(ВыполняемоеОповещение)
		
	РеквСтрокаСообщения	= "";
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ДокВыбор", ДокВыбор);
	СтруктураРеквизитов.Вставить("ДокНомер", ДокНомер);
	СтруктураРеквизитов.Вставить("ДокДата", ДокДата);

	Если НЕ ЗначениеЗаполнено(ДокНомер) Тогда
		РеквСтрокаСообщения = """" + "Номер документа" + """";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокДата) Тогда
		РеквСтрокаСообщения = РеквСтрокаСообщения + ?(ПустаяСтрока(РеквСтрокаСообщения), "", "," + Символы.ПС) + """" + "Дата документа" + """";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(РеквСтрокаСообщения) Тогда 
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не заполнены поля, обязательные к заполнению: %1 %1%2. %1 %1 Продолжить редактирование ?'"), Символы.ПС, РеквСтрокаСообщения);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПрименитьИзмененияЗавершение", ЭтотОбъект, ВыполняемоеОповещение);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;		

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьИзмененияЗавершение(Ответ, ВыполняемоеОповещение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокВыборПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокНомерПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокДатаПриИзменении(Элемент)
	
	Модифицированность = Истина;
		
КонецПроцедуры

#КонецОбласти