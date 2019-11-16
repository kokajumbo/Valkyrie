///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполнение полей формы
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	ФормированиеФормы(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(,
		НСтр("ru = 'В веб-клиенте некоторые ссылки могут работать неправильно.
			|Приносим извинения за неудобства.'"),
		,
		НСтр("ru = 'Интернет-поддержка пользователей'"));
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ПрограммноеЗакрытие
		И Не Подключение1СТакскомКлиент.ФормаОткрыта(
			КонтекстВзаимодействия,
			"Обработка.Подключение1СТакском.Форма.УникальныйИдентификаторАбонента") Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

// В обработчике события нажатия на элемент ЛичныйКабинет выполняется проверка
// нажатого элемента и выполнение в зависимости от типа нажатого элемента
// специфических действий обработки или стандартных действий обозревателя.
//
&НаКлиенте
Процедура ЛичныйКабинетПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ДанныеАктивногоЭлемента = ДанныеСобытия.Element;
	Если ДанныеАктивногоЭлемента = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ИмяКласса = "";
	Попытка
		ИмяКласса = ДанныеАктивногоЭлемента.className;
		КлассАктивногоЭлемента = ДанныеАктивногоЭлемента.HRef;
	Исключение
		Возврат;
	КонецПопытки;
	
	Попытка
		ТаргетЭлемента = ДанныеАктивногоЭлемента.target;
	Исключение
		ТаргетЭлемента = Неопределено;
	КонецПопытки;
	
	Попытка
		ЗаголовокЭлемента = ДанныеАктивногоЭлемента.innerHTML;
	Исключение
		ЗаголовокЭлемента = Неопределено;
	КонецПопытки;
	
	Если ТаргетЭлемента <> Неопределено Тогда 
		Если НРег(СокрЛП(ТаргетЭлемента)) = "_blank" Тогда 
			ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
				КлассАктивногоЭлемента,
				ЗаголовокЭлемента);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	
	Если    СтрНайти(НРег(СокрЛП(ИмяКласса)), "createrequest")      <> 0
		ИЛИ СтрНайти(НРег(СокрЛП(ИмяКласса)), "openrequest")        <> 0
		ИЛИ СтрНайти(НРег(СокрЛП(ИмяКласса)), "changetarif")        <> 0
		ИЛИ СтрНайти(НРег(СокрЛП(ИмяКласса)), "createtarifrequest") <> 0
		ИЛИ СтрНайти(НРег(СокрЛП(ИмяКласса)), "opentarifrequest")   <> 0 Тогда
		// Создание новой заявки
		// Открытие существующей заявки
		// Изменение тарифа
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыЗапроса = Новый Массив;
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "className", ИмяКласса));
		ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "HRef"     , КлассАктивногоЭлемента));
		
		// Отправить параметры на сервер
		Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
			КонтекстВзаимодействия,
			Неопределено,
			ПараметрыЗапроса);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет заполнение адреса страницы обозревателя
&НаСервере
Процедура ФормированиеФормы(ПараметрыФормы)
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УРЛ = Неопределено;
	ПараметрыФормы.Свойство("УРЛ", УРЛ);
	
	Если УРЛ <> Неопределено Тогда 
		ЛичныйКабинет = УРЛ;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти