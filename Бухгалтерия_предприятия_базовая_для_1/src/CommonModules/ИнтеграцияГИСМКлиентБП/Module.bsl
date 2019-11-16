
#Область ПрограммныйИнтерфейс

#Область РаботаСПрикладнымиДокументами

Процедура КомандаВыгрузитьВГИСМ(Форма) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Источник", Форма.Объект);
	
	Если (Форма.Объект.Ссылка.Пустая() Или Форма.Модифицированность) Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Выполнение обмена с ГИСМ возможно только после записи данных.
			|Данные будут записаны.'");
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьКоманадаВыгрузитьГИСМПодтверждениеЗаписи", ИнтеграцияГИСМКлиентБП, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Возврат;
	КонецЕсли;
	
	ВыполнитьКоманадаВыгрузитьГИСМПодтверждениеЗаписи(Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры КомандаВыгрузитьВГИСМ.
Процедура ВыполнитьКоманадаВыгрузитьГИСМПодтверждениеЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Источник = ДополнительныеПараметры.Источник;
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		Форма.Записать();
		Если Источник.Ссылка.Пустая() Или Форма.Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОснование = Источник.Ссылка;
	ОписаниеДействия = ИнтеграцияГИСМВызовСервераБП.ПолучитьКомандуВыгрузитьвГИСМ(ДокументОснование);
	Если ТипЗнч(ОписаниеДействия)= Тип("Строка") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеДействия);
	ИначеЕсли ОписаниеДействия.Действие = "ОткрытьПротоколОбмена" Тогда
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(ДокументОснование, Форма);
	ИначеЕсли ОписаниеДействия.Действие = "СоздатьУведомление" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ДокументОснование);
		ОткрытьФорму(ОписаниеДействия.ИмяФормы, ПараметрыФормы, Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. описание функции ИнтеграцияГИСМКлиентПереопределяемый.ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах
//
Функция ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах() Экспорт
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("ИмяФормы", "Документ.ОтчетОРозничныхПродажах.Форма.ФормаСпискаГИСМ");
	СтруктураВозврата.Вставить("ОткрытьРаспоряжения", Ложь);
	СтруктураВозврата.Вставить("ИмяПоляОтветственный", "Ответственный");
	СтруктураВозврата.Вставить("ИмяПоляОрганизация", "Организация");
	
	Возврат СтруктураВозврата;
	
КонецФункции

// См. описание функции ИнтеграцияГИСМКлиентПереопределяемый.ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов
//
Функция ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов() Экспорт
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("ИмяФормы", "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаСпискаГИСМ");
	СтруктураВозврата.Вставить("ДальнейшееДействиеГИСМ", ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	СтруктураВозврата.Вставить("ОткрытьРаспоряжения", Ложь);
	СтруктураВозврата.Вставить("ИмяПоляОтветственный", "Ответственный");
	СтруктураВозврата.Вставить("ИмяПоляОрганизация", "Организация");
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область СозданиеНовогоНомерКиЗПриВводе

Процедура Киз_ГИСМАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка) Экспорт
	
	Если НЕ ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ИнтеграцияГИСМВызовСервераБП.ДанныеВыбораНомераКиЗ(ПараметрыПолученияДанных, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура Киз_ГИСМОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка) Экспорт
	
	Если НЕ ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ИнтеграцияГИСМВызовСервераБП.ДанныеВыбораНомераКиЗ(ПараметрыПолученияДанных, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура Киз_ГИСМОбработкаВыбора(Элемент, ВыбранноеЗначение, Владелец, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") 
		И НЕ ПустаяСтрока(ВыбранноеЗначение) Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец", Владелец));
		ПараметрыФормы.Вставить("РежимВыбора",     Истина);
		ПараметрыФормы.Вставить("ТекстЗаполнения", ВыбранноеЗначение);
		ОткрытьФорму("Справочник.КонтрольныеЗнакиГИСМ.ФормаОбъекта", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти



