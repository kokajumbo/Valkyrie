
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		Если Запись.Организация.Пустая() Тогда
			Запись.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеПериода = Формат(Запись.Период, "ДФ='q ''квартал'' yyyy'");
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПредставлениеПериодаПриИзменении(Элемент)
	
	ПредставлениеПериода = Формат(Запись.Период, "ДФ='q ''квартал'' yyyy'");
		
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода, ВидПериода",
		НачалоКвартала(Запись.Период),
		КонецКвартала(Запись.Период),
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал"));
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, Элементы.ПредставлениеПериода, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОписаниеОповещений

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Период = РезультатВыбора.НачалоПериода;
	
	ПредставлениеПериода = Формат(Запись.Период, "ДФ='q ''квартал'' yyyy'");
	
КонецПроцедуры

#КонецОбласти
