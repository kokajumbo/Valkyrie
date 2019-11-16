////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьТекстСообщенияОНеобходимостиРеформации(Период, Организация)
	
	Возврат ЗакрытиеМесяца.ПолучитьТекстСообщенияОНеобходимостиРеформации(Период, Организация);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыводитсяПредупреждение = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Флаг предупреждения сбрасывается в процедуре ПередЗакрытием, а не в обработчике ПослеЗаписиЗавершение,
	// чтобы в обработчике по тому, что флаг сброшен, было понятно, что нужно закрыть форму.
	
    Если ВыводитсяПредупреждение Тогда  
        Отказ = Истина;
		ВыводитсяПредупреждение = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ТекстПредупреждения = ПолучитьТекстСообщенияОНеобходимостиРеформации(Запись.Период, Запись.Организация);
	
	Если НЕ ПустаяСтрока(ТекстПредупреждения) Тогда
		ВыводитсяПредупреждение = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат) Экспорт
	
	// В данный обработчик мы можем попасть и при выполнении команды "Записать", и при выполнении команды "Записать и закрыть".
	// Необходимо, чтобы обработчик по-разному отрабатывал в этих ситуациях,
	// т.е. нам необходимо понять, нужно ли закрывать форму. 
	// Для этого используется следующий прием:
	// т.к. при выполнении команды "Записать и закрыть" в процедуру ПередЗакрытием мы попадаем раньше, 
	// чем в обработчик оповещения, то мы можем сбрасывать флаг предупреждения в ней, а не в обработчике.
	// А в обработчике по тому, что флаг сброшен, мы понимаем, что отработало ПередЗакрытием и нужно закрыть форму.
	
	Если НЕ ВыводитсяПредупреждение Тогда
		Закрыть();
	Иначе
		ВыводитсяПредупреждение = Ложь;
	КонецЕсли;
	
КонецПроцедуры
