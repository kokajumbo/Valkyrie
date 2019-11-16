
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнициализироватьТабличныйДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Закрыть(Идентификаторы());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьТабличныйДокумент()
	
	Макет = Справочники.ВетеринарноСопроводительныйДокументВЕТИС.ПолучитьМакет("ЗагрузкаИдентификаторовВСДИзВнешнихФайлов");
	
	ТабличныйДокумент.Очистить();
	
	ОбластьТовар = Макет.ПолучитьОбласть("КодыВСД");
	ТабличныйДокумент.Присоединить(ОбластьТовар);
	
	ТабличныйДокумент.ФиксацияСверху = 1;
	
КонецПроцедуры

&НаСервере
Функция Идентификаторы()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Идентификатор", Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	
	КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		Идентификатор = НРег(СтрЗаменить(СокрЛП(ТабличныйДокумент.Область("R" + НомерСтроки + "C2").Текст), "-", ""));
		
		Если СтрДлина(Идентификатор) = 32 Тогда
			// Приведение к шаблону "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
			Идентификатор = Лев(Идентификатор, 8)
				+ "-" + Сред(Идентификатор, 9, 4)+ "-" + Сред(Идентификатор, 13, 4)+ "-" + Сред(Идентификатор, 17, 4)
				+ "-" + Прав(Идентификатор, 12);
			
		КонецЕсли;
		
		Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Идентификатор) Тогда
			
			НоваяСтрока = Таблица.Добавить();
			НоваяСтрока.Идентификатор = Идентификатор;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Таблица.ВыгрузитьКолонку("Идентификатор");
	
КонецФункции

#КонецОбласти
