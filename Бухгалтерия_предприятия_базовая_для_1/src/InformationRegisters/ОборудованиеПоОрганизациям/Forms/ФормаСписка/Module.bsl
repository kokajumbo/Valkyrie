#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Элементы.Склад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		ПараметрыОткрытияФормы = Новый Структура();
		Оборудование = Элемент.ТекущиеДанные.Оборудование;
		ПараметрыОткрытияФормы.Вставить("Ключ", Оборудование);
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗавершениеРедактирования", ЭтотОбъект);
		ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОповещениеОЗакрытии); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыОткрытияФормы = ПараметрыОткрытияФормыОборудования(Склад);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗавершениеРедактирования", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФискальныйРегистратор(Команда)
	
	НовыйЭкземплярОборудования(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ФискальныйРегистратор"));
	
КонецПроцедуры

&НаКлиенте
Процедура МобильнаяКасса(Команда)
	
	НовыйЭкземплярОборудования(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн"));
	
КонецПроцедуры

&НаКлиенте
Процедура СканерШтрихкода(Команда)
	
	НовыйЭкземплярОборудования(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.СканерШтрихкода"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПринтерЧеков(Команда)
	
	НовыйЭкземплярОборудования(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ПринтерЧеков"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЭквайринговыйТерминал(Команда)
	
	НовыйЭкземплярОборудования(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал"));
	
КонецПроцедуры

&НаКлиенте
Процедура ККМOffline(Команда)
	
	НовыйЭкземплярОборудования(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НовыйЭкземплярОборудования(ТипОборудования)
	
	ПараметрыОткрытияФормы = ПараметрыОткрытияФормыОборудования(Склад);
	ПараметрыОткрытияФормы.Вставить("ТипОборудования", ТипОборудования);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗавершениеРедактирования", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыОткрытияФормыОборудования(Склад)
	
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Склад", Склад);
	ПараметрыОткрытияФормы.Вставить("РабочееМесто", ПараметрыСеанса.РабочееМестоКлиента);
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеРедактирования(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ЭтаФорма.Элементы.Список.Обновить();
	
КонецПРоцедуры

#КонецОбласти

