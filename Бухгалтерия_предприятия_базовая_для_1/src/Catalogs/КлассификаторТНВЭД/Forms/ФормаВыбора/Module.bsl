
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.КлассификаторТНВЭД) Тогда
		Элементы.ПодборИзТНВЭД.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", Элемент.ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", Элемент.ТекущиеДанные.Наименование);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать товарную номенклатуру ВЭД из классификатора.
		|Подобрать?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзМакета(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.КлассификаторТНВЭД.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзМакета(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторТНВЭД.Форма.ДобавлениеЭлементовВКлассификатор", , ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти