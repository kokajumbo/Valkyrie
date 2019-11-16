////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки интеграции с ВетИС.
// 
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииПодсистемы
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаИнтеграцииВЕТИС";
	Описание.Версия = "1.1.3.31";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	Описание.ТребуемыеПодсистемы.Добавить("БиблиотекаПодключаемогоОборудования");
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.4.19";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.ЗаписиСкладскогоЖурналаВРезервеВЕТИС.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ЗаписиСкладскогоЖурналаВРезервеВЕТИС.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("0ddb97cc-6af0-ae27-116e-2ccc97de6a10");
	Обработчик.Комментарий = НСтр("ru = 'Исправление резервов по исходящим транспортным операциям (ВетИС).'");
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ЧитаемыеОбъекты = "РегистрСведений.ЗаписиСкладскогоЖурналаВРезервеВЕТИС";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.ЗаписиСкладскогоЖурналаВРезервеВЕТИС";
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.3.27";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "Справочники.ПредприятияВЕТИС.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ПредприятияВЕТИС.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("0ddb97cc-6af0-ae27-116e-2ccb87d03310");
	Обработчик.Комментарий = НСтр("ru = 'Заполнение номеров маркировки и представления страны в адресе предприятий (ВетИС).'");
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ЧитаемыеОбъекты = "Справочник.ПредприятияВЕТИС";
	Обработчик.ИзменяемыеОбъекты = "Справочник.ПредприятияВЕТИС";
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.3.24";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегистрыСведений.ВидыПродукцииПоГруппамВЕТИС.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ВидыПродукцииПоГруппамВЕТИС.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("c5206e55-aa2e-4f1e-bc52-369cc0c72bc6");
	Обработчик.Комментарий = НСтр("ru = 'Заполнение перечня продукции по группам (ВетИС).'");
	Обработчик.ПроцедураПроверки = "РегистрыСведений.ВидыПродукцииПоГруппамВЕТИС.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ЧитаемыеОбъекты = "РегистрСведений.ВидыПродукцииПоГруппамВЕТИС";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.ВидыПродукцииПоГруппамВЕТИС";
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.3.24";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегистрыСведений.ДопустимыеЦелиПоГруппамВЕТИС.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ДопустимыеЦелиПоГруппамВЕТИС.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("14da3117-b035-45e6-b637-54db2fbbe0b6");
	Обработчик.Комментарий = НСтр("ru = 'Заполнение перечня продукции по целям (ВетИС).'");
	Обработчик.ПроцедураПроверки = "РегистрыСведений.ДопустимыеЦелиПоГруппамВЕТИС.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ЧитаемыеОбъекты = "РегистрСведений.ДопустимыеЦелиПоГруппамВЕТИС";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.ДопустимыеЦелиПоГруппамВЕТИС";
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПередОбновлениемИнформационнойБазы
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	ВерсияКонфигурации = ОбновлениеИнформационнойБазы.ВерсияИБ(Метаданные.Имя);
	Если ВерсияКонфигурации <> "0.0.0.0" Тогда
		
		ИдентификаторБиблиотекаИнтеграцииВЕТИС = "БиблиотекаИнтеграцииВЕТИС";
		ВерсияБиблиотекаИнтеграцииВЕТИС = ОбновлениеИнформационнойБазы.ВерсияИБ(ИдентификаторБиблиотекаИнтеграцииВЕТИС);
		Если ВерсияБиблиотекаИнтеграцииВЕТИС = "0.0.0.0" Тогда
			
			ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ("БиблиотекаИнтеграцииВЕТИС", "1.0.0.0", Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриПодготовкеМакетаОписанияОбновлений.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	

КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт

КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
