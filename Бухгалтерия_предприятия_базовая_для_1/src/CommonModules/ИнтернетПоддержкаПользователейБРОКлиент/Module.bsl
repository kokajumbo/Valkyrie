
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей (БРО)".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет разрешение на выполнение операции.
//
// Параметры:
//  ОповещениеОЗавершении   - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат,
//                                       иначе - была ошибка при выполнении проверки.
//      * ВыполнениеРазрешено - Булево - если Истина, то продолжение выполнения разрешено.
//
//  ВладелецФормы           - УправляемаяФорма - форма, которая будет использования в качестве 
//                                               владельца открываемых служебных окон.
//
//  ПараметрыАутентификации - Структура - параметры доступа к сайту поддержки пользователей.
//    * Логин  - Строка - логин пользователя.
//    * пароль - Строка - пароль пользователя.
//
Процедура ПроверитьВозможностьВыполненияОперации(ОповещениеОЗавершении, ВладелецФормы = Неопределено, ПараметрыАутентификации = Неопределено) Экспорт
	
	Результат = ИнтернетПоддержкаПользователейБРОСлужебныйВызовСервера.ПроверитьВозможностьВыполненияОперацииНаСервере(ПараметрыАутентификации);
	
	Если Результат = "ПараметрыАутентификацииНеЗаполнены"
		ИЛИ Результат = "ПараметрыАутентификацииУказаныНеВерно" Тогда
		Контекст = Новый Структура;
		Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		Контекст.Вставить("ВладелецФормы", ВладелецФормы);
		Оповещение = Новый ОписаниеОповещения("ПроверитьВозможностьВыполненияОперацииПослеВводаПараметровАутентификации", ЭтотОбъект, Контекст);
		АвторизоватьНаСайтеПоддержкиПользователей(ВладелецФормы, Оповещение);
	ИначеЕсли Результат = "ВыполнениеРазрешено" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Новый Структура("Выполнено, ВыполнениеРазрешено", Истина, Истина));
	ИначеЕсли Результат = "ВыполнениеЗапрещено" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Новый Структура("Выполнено, ВыполнениеРазрешено", Истина, Ложь));		
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Новый Структура("Выполнено, ВыполнениеРазрешено", Ложь, Ложь));		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьВозможностьВыполненияОперацииПослеВводаПараметровАутентификации(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ПроверитьВозможностьВыполненияОперации(ВходящийКонтекст.ОповещениеОЗавершении, 
			ВходящийКонтекст.Владелецформы, Результат);
	Иначе
		ВыполнитьОбработкуОповещения(
			ВходящийКонтекст.ОповещениеОЗавершении, 
			Новый Структура("Выполнено, ВыполнениеРазрешено", Истина, Ложь));
	КонецЕсли;
	
КонецПроцедуры

Процедура АвторизоватьНаСайтеПоддержкиПользователей(ВладелецФормы = Неопределено, ОповещениеОЗакрытии = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОповещениеОЗакрытии);
	Иначе
		ВызватьИсключение НСтр("ru = 'Сервис интернет-поддержки пользователей не подключен.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
