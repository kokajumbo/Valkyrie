#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПринадлежностьТорговойТочкиОднойОрганизации(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПринадлежностьТорговойТочкиОднойОрганизации(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПараметрыТорговыхТочек.Организация,
	|	ПараметрыТорговыхТочек.ТорговаяТочка
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек КАК ПараметрыТорговыхТочек
	|ГДЕ
	|	ПараметрыТорговыхТочек.ТорговаяТочка В(&ТорговыеТочки)";
	Запрос.УстановитьПараметр("ТорговыеТочки", ВыгрузитьКолонку("ТорговаяТочка"));
	
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Индексы.Добавить("ТорговаяТочка");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		ИнформацияОТорговойТочке = Результат.Найти(Запись.ТорговаяТочка, "ТорговаяТочка");
		Если ИнформацияОТорговойТочке = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИнформацияОТорговойТочке.Организация <> Запись.Организация Тогда
			ТекстОшибки = НСтр("ru='Торговая точка не может быть зарегистрирована в нескольких организациях'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли






