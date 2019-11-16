#Область ПрограммныйИнтерфейс

// Процедура выполняет отправку регламентированного отчета в контролирующий орган не через "1С-Отчетность"
//
// Параметры
//  СсылкаНаОбъект - ДокументСсылка       - Документ, который отправляется в контролирующий орган
//
Функция ОтправитьОбъектРегламентированнойОтчетности(СсылкаНаОбъект, ДанныеОтчета) Экспорт
	
	Если Не ИнтеграцияСБанкамиПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьБП.Используется1СОтчетность() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = РегистрыСведений.ДокументыИнтеграцииСБанком.ЗарегистрироватьДанныеРегламентированногоОтчетаКОтправке(СсылкаНаОбъект, ДанныеОтчета);
	
	Если Не Результат.Ошибка Тогда
		
		СтатусВРаботе = ИнтерфейсыВзаимодействияБРОКлиентСервер.СтатусВРаботеСтрокой();
		СтатусПодготовлено = ИнтерфейсыВзаимодействияБРОКлиентСервер.СтатусПодготовленоСтрокой();
		
		ТекущийСтатус = СохраненныйСтатусОтправкиОбъектаРегламентированнойОтчетности(СсылкаНаОбъект);
		Если Не ЗначениеЗаполнено(ТекущийСтатус) Или ТекущийСтатус = СтатусВРаботе Тогда
			СохранитьСтатусОтправкиОбъектаРегламентированнойОтчетности(СсылкаНаОбъект, СтатусПодготовлено);
		КонецЕсли;
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.СообщениеОбОшибке);
	КонецЕсли;
	
	Возврат Не Результат.Ошибка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СохраненныйСтатусОтправкиОбъектаРегламентированнойОтчетности(СсылкаНаОбъект)
	
	ТипОбъекта = ТипЗнч(СсылкаНаОбъект);
	
	Если ТипОбъекта = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		Возврат РегламентированнаяОтчетность.СохраненныйСтатусОтправкиРеглОтчета(СсылкаНаОбъект);
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения") Тогда
		Возврат РегламентированнаяОтчетность.СохраненныйСтатусОтправкиУведомления(СсылкаНаОбъект);
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Отправка объекта типа %1 не поддерживается'"), ТипОбъекта);
	КонецЕсли;
	
КонецФункции

Функция СохранитьСтатусОтправкиОбъектаРегламентированнойОтчетности(СсылкаНаОбъект, Статус)
	
	ТипОбъекта = ТипЗнч(СсылкаНаОбъект);
	
	Если ТипОбъекта = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СсылкаНаОбъект", СсылкаНаОбъект);
		СтруктураПараметров.Вставить("Статус", Статус);
		
		ИнтерфейсыВзаимодействияБРО.СохранитьСтатусОтправки(СтруктураПараметров);
		
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения") Тогда
		
		ИнтерфейсыВзаимодействияБРО.СохранитьСтатусОтправкиУведомления(СсылкаНаОбъект, Статус);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти