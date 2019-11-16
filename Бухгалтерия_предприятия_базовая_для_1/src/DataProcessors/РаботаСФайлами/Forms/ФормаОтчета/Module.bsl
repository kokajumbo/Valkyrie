///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отчет = РаботаСФайламиСлужебный.ИмпортФайловСформироватьОтчет(Параметры.МассивИменФайловСОшибками);
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетВыбор(Элемент, Область, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	// Путь к файлу.
	Если СтрНайти(Область.Текст, ":\") > 0 ИЛИ СтрНайти(Область.Текст, ":/") > 0 Тогда
		РаботаСФайламиСлужебныйКлиент.ОткрытьПроводникСФайлом(Область.Текст);
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти
