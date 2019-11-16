
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКлассификатор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныйЭлемент = Классификатор.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ВыбранныйЭлемент <> Неопределено И НЕ ПустаяСтрока(ВыбранныйЭлемент.Код) Тогда
		ОповеститьОВыборе(ВыбранныйЭлемент.Код);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныйЭлемент = Классификатор.НайтиПоИдентификатору(Значение);
	Если ВыбранныйЭлемент <> Неопределено И НЕ ПустаяСтрока(ВыбранныйЭлемент.Код) Тогда
		ОповеститьОВыборе(ВыбранныйЭлемент.Код);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКлассификатор()
	
	Классификатор.ПолучитьЭлементы().Очистить();
	
	// Получаем полную таблицу элементов классификатора
	// в таблице содержатся Код, Наименование, ВидМарки.
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	ЭлементыДерева = Классификатор.ПолучитьЭлементы();
	
	СтрокаАМ = ЭлементыДерева.Добавить();
	СтрокаАМ.Наименование = НСтр("ru='Акцизные марки (импортная продукция)'");
	
	ЭлементыДереваАМ = СтрокаАМ.ПолучитьЭлементы();
	
	СтрокаФСМ = ЭлементыДерева.Добавить();
	СтрокаФСМ.Наименование = НСтр("ru='Федеральные специальные марки (продукция РФ)'");
	
	ЭлементыДереваФСМ = СтрокаФСМ.ПолучитьЭлементы();
	
	ТекущийКод = "";
	Если Параметры.Свойство("ТипМарки") И НЕ ПустаяСтрока(Параметры.ТипМарки) Тогда
		ТекущийКод = Параметры.ТипМарки;
	КонецЕсли;
	
	Сч = ЭлементыДерева.Количество() - 1;
	ТекущаяСтрока = 0;
	
	Для Каждого СтрокаТаблицы Из ТаблицаКлассификатора Цикл
		
		Если СтрокаТаблицы.ВидМарки = "ФСМ" Тогда
			СтрокаДерева = ЭлементыДереваФСМ.Добавить();
		Иначе
			СтрокаДерева = ЭлементыДереваАМ.Добавить();
		КонецЕсли;
		
		Сч = Сч + 1;
		
		СтрокаДерева.Код = СтрокаТаблицы.Код;
		СтрокаДерева.Наименование = СтрокаТаблицы.Наименование;
		
		Если СтрокаДерева.Код = ТекущийКод Тогда
			ТекущаяСтрока = Сч;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущаяСтрока <> 0 Тогда
		Элементы.Классификатор.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
