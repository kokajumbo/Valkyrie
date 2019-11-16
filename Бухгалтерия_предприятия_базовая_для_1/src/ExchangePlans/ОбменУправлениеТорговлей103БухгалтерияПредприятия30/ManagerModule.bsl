#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = ОбщегоНазначенияБП.ИмяКонфигурацииИсточника();
	Настройки.ИмяКонфигурацииПриемника.Вставить("УправлениеТорговлей");
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
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
	ВариантНастройки.ИдентификаторНастройки        = "";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
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
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "УправлениеТорговлей";
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = "Настройки обмена для БП-УТ";
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Управление торговлей, ред. 10.3'");
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Управление торговлей, ред. 10.3'");
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();

КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеНастроек

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
	Возврат Результат;
	
КонецФункции

// Возвращает имена реквизитов и табличных частей плана обмена,
// перечисленных через запятую, которые являются общими для пары обменивающихся конфигураций.
// Например, если для плана обмена предусмотрено ограничение миграции данных по организациям в обе стороны,
// то табличная часть плана обмена, в которой перечислены разрешенные организации, считается общей.
// Возвращает пустую строку, если общие данные узлов не предусмотрены.
//
// Параметры:
//  ВерсияКорреспондента - Строка - версия конфигурации корреспондента, например, "2.1.5.1".
// 
Функция ОбщиеДанныеУзлов()
	
	возврат "ДатаНачалаВыгрузкиДокументов,ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю,ИспользоватьОтборПоОрганизациям,Организации,РежимВыгрузкиПриНеобходимости";
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные с программой 1С:Управление торговлей, редакция 10.3, 
	|В синхронизации участвуют следующие типы данных: справочники (например, Организации), документы (например, 
	|Реализация товаров), регистры сведений (например, Курсы валют).
	|
	|Синхронизация является двухсторонней и позволяет иметь актуальные данные в каждой из информационных баз.'");

	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	Возврат "ПланОбмена.ОбменУправлениеТорговлей103БухгалтерияПредприятия30.Форма.ПодробнаяИнформация";
	
КонецФункции

#КонецОбласти

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

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

Процедура ОбновитьСвойстваПредопределенногоУзла() Экспорт
	//см. процедуру СообщенияУдаленногоАдминистрированияРеализация.ОбновитьСвойстваПредопределенныхУзлов
	
	Если Не ОбщегоНазначения.ИспользованиеРазделителяСеанса() Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = Константы.ПредставлениеОбластиДанных.Получить();
	ИмяПланаОбмена = "ОбменУправлениеТорговлей103БухгалтерияПредприятия30";
	ЭтотУзел = ПланыОбмена[ИмяПланаОбмена].ЭтотУзел();
	СвойстваУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭтотУзел, "Код, Наименование");
			
	Если ПустаяСтрока(СвойстваУзла.Код) Тогда
				
		ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
		ЭтотУзелОбъект.Код = ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
		ЭтотУзелОбъект.Наименование = Наименование;
		ЭтотУзелОбъект.ДополнительныеСвойства.Вставить("Загрузка");
		ЭтотУзелОбъект.Записать();
				
	ИначеЕсли СвойстваУзла.Наименование <> Наименование Тогда
				
		ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
		ЭтотУзелОбъект.Наименование = Наименование;
		ЭтотУзелОбъект.ДополнительныеСвойства.Вставить("Загрузка");
		ЭтотУзелОбъект.Записать();
				
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли