#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;
	
	ИзмеренияЗаполняемыеИзОтбора = Новый Структура;
	Для Каждого ИмяИзмерения Из ИзмеренияЗаполняемыеИзОтбора() Цикл
		ЗначениеОтбора = ЗначениеОтбора(ИмяИзмерения);
		Если ЗначениеОтбора <> Неопределено Тогда
			ИзмеренияЗаполняемыеИзОтбора.Вставить(ИмяИзмерения, ЗначениеОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ДанныеСтроки Из ЭтотОбъект Цикл
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, ИзмеренияЗаполняемыеИзОтбора);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	АвтоматическиЗаполняемыеРеквизиты = Новый Массив;
	
	Для Каждого ИмяИзмерения Из ИзмеренияЗаполняемыеИзОтбора() Цикл
		Если ЗначениеОтбора(ИмяИзмерения) <> Неопределено Тогда
			АвтоматическиЗаполняемыеРеквизиты.Добавить(ИмяИзмерения);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты, 
		АвтоматическиЗаполняемыеРеквизиты);
	
КонецПроцедуры

Функция ЗначениеОтбора(ИмяОтбора)
	
	ЭлементОтбора = Отбор.Найти(ИмяОтбора);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЭлементОтбора.Использование Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЭлементОтбора.ВидСравнения <> ВидСравнения.Равно Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЭлементОтбора.Значение) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ЭлементОтбора.Значение;
	
КонецФункции

Функция ИзмеренияЗаполняемыеИзОтбора()
	
	Измерения = Новый Массив;
	Измерения.Добавить("Организация");
	Измерения.Добавить("ОбъектНаблюдения");
	
	Возврат Измерения;
	
КонецФункции

#КонецЕсли