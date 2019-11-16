#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьДанныеРегистра();
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыКонтрагентов

&НаКлиенте
Процедура ГруппыКонтрагентовПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ГруппыКонтрагентов.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ГруппаКонтрагентов) Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ ДанныеРегистраЗаписаны() Тогда
		ТекстПредупреждения = НСтр("ru='Не удалось записать данные.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыКонтрагентовГруппаКонтрагентовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ГруппыКонтрагентов.ТекущаяСтрока;
	
	Для каждого СтрокаТаблицы Из ГруппыКонтрагентов Цикл
		Если СтрокаТаблицы.ПолучитьИдентификатор() <> ТекущаяСтрока
			И СтрокаТаблицы.ГруппаКонтрагентов = ВыбранноеЗначение Тогда
			ТекстПредупреждения = СтрШаблон(НСтр("ru='Группа ""%1"" уже есть в списке.'"), ВыбранноеЗначение);
			СтандартнаяОбработка = Ложь;
			ПоказатьПредупреждение(, ТекстПредупреждения);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыКонтрагентовПередУдалением(Элемент, Отказ)
	
	УдаляемыеГруппы = Новый Массив;
	Для каждого ИндентификаторСтроки Из Элементы.ГруппыКонтрагентов.ВыделенныеСтроки Цикл
		УдаляемыеГруппы.Добавить(ГруппыКонтрагентов.НайтиПоИдентификатору(ИндентификаторСтроки).ГруппаКонтрагентов);
	КонецЦикла;
	
	Если НЕ ДанныеРегистраЗаписаны(УдаляемыеГруппы) Тогда
		ТекстПредупреждения = НСтр("ru='Не удалось удалить данные.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыКонтрагентовГруппаКонтрагентовОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьДанныеРегистра()

	НаборЗаписей = РегистрыСведений.ГруппыКонтрагентовФизическихЛиц.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	ГруппыКонтрагентов.Загрузить(НаборЗаписей.Выгрузить());

КонецПроцедуры

&НаСервере
Функция ДанныеРегистраЗаписаны(УдаляемыеГруппы = Неопределено)
	
	Попытка
		НачатьТранзакцию();
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ГруппыКонтрагентовФизическихЛиц");
		Блокировка.Заблокировать();
		НаборЗаписей = РегистрыСведений.ГруппыКонтрагентовФизическихЛиц.СоздатьНаборЗаписей();
		ТаблицаГрупп = ГруппыКонтрагентов.Выгрузить();
		Если УдаляемыеГруппы <> Неопределено Тогда
			Для каждого УдаляемаяГруппа Из УдаляемыеГруппы Цикл
				УдаляемаяСтрока = ТаблицаГрупп.Найти(УдаляемаяГруппа);
				Если УдаляемаяСтрока <> Неопределено Тогда
					ТаблицаГрупп.Удалить(УдаляемаяСтрока);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		НаборЗаписей.Загрузить(ТаблицаГрупп);
		НаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
	    Возврат Истина;
	Исключение
	    Возврат Ложь;
	КонецПопытки;

КонецФункции

#КонецОбласти

