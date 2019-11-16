
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Таблица = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыВоеннаяСлужба);
	ЗначениеВРеквизитФормы(Таблица, "ВоеннаяСлужба");
	
	// Работа с этими реквизитами идет в ОМ
	ВидПенсииОсновной = Параметры.ВидПенсииОсновной;
	ВидПенсииВторой   = Параметры.ВидПенсииВторой;
	НовыйВидПенсии    = Параметры.НовыйВидПенсии;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
		
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВоеннаяСлужбаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ВыбратьПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ВоеннаяСлужбаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьПериод();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	ДанныеКорректны = Истина;
	
	ВоеннаяСлужбаУказаныКорректно(ЭтотОбъект, ДанныеКорректны);
	
	Если ДанныеКорректны Тогда

		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("АдресТаблицыВоеннаяСлужба", АдресТаблицыВоеннаяСлужба());
		ДополнительныеПараметры.Вставить("Модифицированность", Модифицированность);
		
		Модифицированность = Ложь;
		
		Закрыть(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресТаблицыВоеннаяСлужба()
	
	Возврат ПоместитьВоВременноеХранилище(ВоеннаяСлужба.Выгрузить(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВоеннаяСлужбаУказаныКорректно(Форма, МастерДалее = Истина)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ВоеннаяСлужбаУказаныКорректно(Форма, МастерДалее, Истина);
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПериод()
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Если Элементы.ВоеннаяСлужба.ТекущаяСтрока <> Неопределено Тогда
		Диалог.Период.ДатаНачала    = Элементы.ВоеннаяСлужба.ТекущиеДанные.ДатаНачала;
		Диалог.Период.ДатаОкончания = Элементы.ВоеннаяСлужба.ТекущиеДанные.ДатаОкончания;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("Диалог", Диалог);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьПериод_Завершение", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод_Завершение(Период, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если Период <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		Если Элементы.ВоеннаяСлужба.ТекущаяСтрока <> Неопределено Тогда
			Элементы.ВоеннаяСлужба.ТекущиеДанные.ДатаНачала    = Диалог.Период.ДатаНачала;
			Элементы.ВоеннаяСлужба.ТекущиеДанные.ДатаОкончания = Диалог.Период.ДатаОкончания;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

