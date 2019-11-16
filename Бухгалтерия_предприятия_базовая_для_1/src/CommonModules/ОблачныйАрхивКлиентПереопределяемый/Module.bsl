///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивКлиентПереопределяемый.
//
// Все переопределяемые клиентские процедуры и функции для работы с "Облачным архивом".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура переопределяет время отсрочки первого заполнения параметров клиента.
//
// Параметры:
//  ИнтервалСекунд - Число - Время отсрочки в секундах, через которое необходимо запустить проверку параметров клиента после старта.
//
Процедура ПереопределитьВремяПервогоЗаполненияПараметровКлиента(ИнтервалСекунд) Экспорт
	
	ИнтервалСекунд = 10; // Через 10 секунд
	
КонецПроцедуры

// Процедура переопределяет интервал регулярного заполнения параметров клиента.
//
// Параметры:
//  ИнтервалСекунд - Число - Время в секундах, через которое необходимо регулярно запускать проверку параметров клиента.
//
Процедура ПереопределитьВремяРегулярногоЗаполненияПараметровКлиента(ИнтервалСекунд) Экспорт

КонецПроцедуры

#КонецОбласти
