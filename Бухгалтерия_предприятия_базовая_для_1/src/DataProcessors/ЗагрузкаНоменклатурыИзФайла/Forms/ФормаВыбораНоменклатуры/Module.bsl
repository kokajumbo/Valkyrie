#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = Параметры.ОтборДублей;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Ложь;
	ЭлементОтбора.Использование = Истина;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ТекущаяДатаПользователя = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	Для Каждого ВидСтавки Из Перечисления.ВидыСтавокНДС Цикл
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();

		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВидСтавкиНДС");

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Список.ВидСтавкиНДС", ВидСравненияКомпоновкиДанных.Равно, ВидСтавки);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст",
			Строка(Перечисления.СтавкиНДС.СтавкаНДС(ВидСтавки, ТекущаяДатаПользователя)));
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти