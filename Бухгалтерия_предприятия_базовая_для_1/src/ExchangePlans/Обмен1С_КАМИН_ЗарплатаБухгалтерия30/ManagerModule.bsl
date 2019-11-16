#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт

	Настройки.ИмяКонфигурацииИсточника = ОбщегоНазначенияБП.ИмяКонфигурацииИсточника();
	Настройки.ИмяКонфигурацииПриемника.Вставить("КаминЗарплата");
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
	Настройки.Алгоритмы.ОбработчикПроверкиПараметровУчета = Истина;
	Настройки.Алгоритмы.ПриПолученииДанныхОтправителя = Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "Двухсторонний";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт

	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "КаминЗарплата";
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = НСтр("ru = 'Данная настройка позволит синхронизировать данные между программами ""Бухгалтерия предприятия, редакция 3.0""
		|и ""1С-КАМИН:Зарплата 5.0"". Из программы Зарплата в программу Бухгалтерия предприятия переносятся справочники
		|и все необходимые документы, а из программы Бухгалтерия предприятия в программу Зарплата - справочники.'");
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.Обмен1С_КАМИН_ЗарплатаБухгалтерия30.Форма.ФормаПодробнойИнформацииПоОбмену";

	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = '1С-КАМИН: Зарплата, ред. 5.0'");
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника      = НСтр("ru = 'Настройки обмена для Зарплаты 5.0 (Бухгалтерии предприятия 3.0)'");

	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена  = НСтр("ru = 'Настройка обмена данными с программой 1С-КАМИН:Зарплата 5.0'");;

	ЗаголовокФормыУзла = НСтр("ru='Синхронизация данных с 1С-КАМИН:Зарплата 5.0'");

	ОписаниеВарианта.Вставить("ЗаголовокУзлаПланаОбмена", ЗаголовокФормыУзла);

	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();

КонецПроцедуры

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = '1С-КАМИН: Зарплата, ред. 5.0'");
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Константы и проверка параметров учета

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая настройка дополнения выгрузки

////////////////////////////////////////////////////////////////////////////////
//Дополнение к функционалу БСП

//Возвращает режим запуска, в случае интерактивного инициирования синхронизации
//Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
//На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает сценарий работы помощника интерактивного сопостовления
//НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

// Возвращает имена реквизитов и табличных частей плана обмена, перечисленных через запятую,
// которые являются общими для пары обменивающихся конфигураций.
//
// Возвращаемое значение:
//	Строка - Список имен реквизитов.
//
Функция ОбщиеДанныеУзлов()
	
	Возврат "ДатаНачалаВыгрузкиДокументов, Организации, Сотрудник, РежимВыгрузкиПриНеобходимости, ЗагружатьСправочникиИзБухгалтерииПредприятия, РучнойОбмен";
	
КонецФункции

// Возвращает строку с кратким описанием обмена данными, 
// которое выводится на первой станице Помощника создания обмена данными.
// 
// Испрользуется начиная с БСП 2.1.2
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru = '	Позволяет синхронизировать данные между приложениями 1С-КАМИН: Зарплата, ред. 5.0 и 1С: Бухгалтерия предприятия, ред. 3.0. Из приложения Зарплата в приложение Бухгалтерия предприятия переносятся справочники и все необходимые документы, а из приложения Бухгалтерия предприятия в приложение Зарплата - справочники. Для получения более подробной информации нажмите на ссылку Подробное описание.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции // КраткаяИнформацияПоОбмену()

// Вовзращает ссылку на веб-страницу или полный путь к форме внутри конфигурации строкой
// 
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПутьКИнформацииПоОбмену = "ПланОбмена.Обмен1С_КАМИН_ЗарплатаБухгалтерия30.Форма.ПодробнаяИнформация";
	
	Возврат ПутьКИнформацииПоОбмену;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает сокращенное строковое представление коллекции значений.
// 
// Параметры:
//  Коллекция 						- массив или список значений.
//  МаксимальноеКоличествоЭлементов - число, максимальное количество элементов включаемое в представление.
//
// Возвращаемое значение:
//  Строка.
//
Функция СокращенноеПредставлениеКоллекцииЗначений(Коллекция, МаксимальноеКоличествоЭлементов = 3) Экспорт
	
	СтрокаПредставления = "";
	
	КоличествоЗначений			 = Коллекция.Количество();
	КоличествоВыводимыхЭлементов = Мин(КоличествоЗначений, МаксимальноеКоличествоЭлементов);
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Для НомерЗначения = 1 По КоличествоВыводимыхЭлементов Цикл
			
			СтрокаПредставления = СтрокаПредставления + Коллекция.Получить(НомерЗначения - 1) + ", ";	
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		Если КоличествоЗначений > КоличествоВыводимыхЭлементов Тогда
			СтрокаПредставления = СтрокаПредставления + ", ... ";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для работы через внешнее соединение

// Возвращает версию подсистемы обмена данными
// Для вновь создаваемых планов обмена функция должна
// возвращать значение Перечисления.ВерсииПодсистемыОбменаДанными.Версия30
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ВерсииПодсистемыОбменаДанными
//
Функция ВерсияОбменаДанными() Экспорт
	
	Возврат Перечисления.ВерсииПодсистемыОбменаДанными.Версия30;
	
КонецФункции

// Процедура предназначена для получения дополнительных данных, используемых при настройке обмена в базе-корреспонденте.
//
//  Параметры:
// ДополнительныеДанные – Структура. Дополнительные данные, которые будут использованы
// в базе-корреспонденте при настройке обмена.
// В качестве значений структуры применимы только значения, поддерживающие XDTO-сериализацию.
//
Процедура ПолучитьДополнительныеДанныеДляКорреспондента(ДополнительныеДанные) Экспорт
	
КонецПроцедуры

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
	Если ТипЗнч(Отправитель.Сотрудник) = Тип("Строка") Тогда
		GUID = Новый УникальныйИдентификатор(Отправитель.Сотрудник);
		Отправитель.Сотрудник = ?(ЗначениеЗаполнено(GUID),
		Справочники.ФизическиеЛица.ПолучитьСсылку(GUID),
		Справочники.ФизическиеЛица.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли