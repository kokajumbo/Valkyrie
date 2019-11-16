
#Область СлужебныеПроцедурыИФункции

// Предназначена для использования в ОбщегоНазначенияПереопределяемый.ЗаполнитьТаблицуПереименованияОбъектовМетаданных.
//
// Заполняет переименования тех объектов метаданных, которые невозможно
// автоматически найти по типу, но ссылки на которые требуется сохранять
// в базе данных (например: подсистемы, роли).
//
// Подробнее: см. ОбщегоНазначения.ДобавитьПереименование().
//
Процедура ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог) Экспорт
	
	ЗарплатаКадрыБазовый.ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог);
	
КонецПроцедуры

Функция ОтветственныеЛицаОрганизации(Организация, Сведения, ДатаСведений) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ОтветственныеЛицаОрганизации(Организация, Сведения, ДатаСведений);
	
КонецФункции

Функция УсловияЗапросаПроверкиНеобходимостиЗаполненияПодчиненныхПодразделений(Запрос, ИсточникДанных) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.УсловияЗапросаПроверкиНеобходимостиЗаполненияПодчиненныхПодразделений(Запрос, ИсточникДанных);

КонецФункции

Процедура ЗаполнитьПодчиненноеПодразделение(ПодразделениеОбъект, ИсточникДанных) Экспорт
	
	ЗарплатаКадрыБазовый.ЗаполнитьПодчиненноеПодразделение(ПодразделениеОбъект, ИсточникДанных);
		
КонецПроцедуры

Функция ЭтоОбъектЗарплатноКадровойБиблиотеки(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ЭтоОбъектЗарплатноКадровойБиблиотеки(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

Функция ЭтоБазоваяВерсияКонфигурации() Экспорт
	Возврат ЗарплатаКадрыБазовый.ЭтоБазоваяВерсияКонфигурации();
КонецФункции

// См. ЗарплатаКадры.ИспользуетсяУчетХозрасчетныхОрганизаций.
Функция ИспользуетсяУчетХозрасчетныхОрганизаций() Экспорт
	Возврат ЗарплатаКадрыБазовый.ИспользуетсяУчетХозрасчетныхОрганизаций();
КонецФункции

// См. ЗарплатаКадры.ИспользуютсяДокументыОплатыВедомостей.
Функция ИспользуютсяДокументыОплатыВедомостей() Экспорт
	Возврат ЗарплатаКадрыБазовый.ИспользуютсяДокументыОплатыВедомостей();
КонецФункции

Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
КонецПроцедуры

// Получает информацию о виде расчета.
Функция ПолучитьИнформациюОВидеРасчета(ВидРасчета) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
	
КонецФункции

// Формирует таблицу значений с параметрами отпусков сотрудника для расчета оценочных обязательств
//	Параметры
//		МассивСотрудников
//		Период - месяц, для которого рассчитываются обязательства
//	Возвращаемое значение Таблица значений
//			* Сотрудник
//			* ОстатокОтпусков
//			* ОтпускАвансом
//			* СреднийЗаработок
//
Функция СведенияОбОтпускахСотрудниковДляРасчетаОценочныхОбязательств(МассивСотрудников, Период) Экспорт

	Возврат ЗарплатаКадрыБазовый.СведенияОбОтпускахСотрудниковДляРасчетаОценочныхОбязательств(МассивСотрудников, Период);

КонецФункции

// См. ЗарплатаКадры.ЗарегистрироватьОплатуВедомостей.
Процедура ЗарегистрироватьОплатуВедомостей(ПлатежныйДокумент, Организация, Ведомости, ФизическиеЛица = Неопределено, ДатаОперации = Неопределено, Отказ = Ложь) Экспорт
	ЗарплатаКадрыБазовый.ЗарегистрироватьОплатуВедомостей(ПлатежныйДокумент, Организация, Ведомости, ФизическиеЛица, ДатаОперации, Отказ);	
КонецПроцедуры

#Область БлокФункцийПолученияЗначенийПоУмолчанию

Процедура ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ДатаЗначений) Экспорт
	ЗарплатаКадрыБазовый.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ДатаЗначений);
КонецПроцедуры

// Массив поддерживаемых идентификаторов значений по умолчанию.
Функция СписокДоступныхЗначенийПоУмолчанию() Экспорт
	Возврат ЗарплатаКадрыБазовый.СписокДоступныхЗначенийПоУмолчанию();
КонецФункции

#КонецОбласти

#Область Пользователи

Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииНазначенияРолей(НазначениеРолей)
КонецПроцедуры

#КонецОбласти

#Область ПрофилиБезопасности

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзмененияДанных

// См. ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения.
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииРазделовДатЗапретаИзменения(Разделы);
КонецПроцедуры

// См. ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
КонецПроцедуры

#КонецОбласти

#Область ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты)
КонецПроцедуры

#КонецОбласти

#Область ПрефиксацияСправочниковПоОрганизации

Процедура ПолучитьПрефиксообразующиеРеквизиты(Объекты) Экспорт
	ЗарплатаКадрыБазовый.ПолучитьПрефиксообразующиеРеквизиты(Объекты);
КонецПроцедуры

#КонецОбласти

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	ЗарплатаКадрыБазовый.ПриПолученииПредопределенныхНаборовСвойств(Наборы);
КонецПроцедуры

#КонецОбласти

#Область ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений);
КонецПроцедуры

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьОбластиПерсональныхДанных.
Процедура ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных);
КонецПроцедуры

// См. ЗащитаПерсональныхДанныхПереопределяемый.ПередСкрытиемПерсональныхДанныхСубъектов.
Процедура ПередСкрытиемПерсональныхДанныхСубъектов(Субъекты, ТаблицаИсключений, Отказ) Экспорт
	ЗарплатаКадрыБазовый.ПередСкрытиемПерсональныхДанныхСубъектов(Субъекты, ТаблицаИсключений, Отказ);
КонецПроцедуры

#КонецОбласти

#Область НастройкиПрограммы

// См. НастройкиПрограммыПереопределяемый.НастройкиПользователейИПравПриСозданииНаСервере.
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
	ЗарплатаКадрыБазовый.НастройкиПользователейИПравПриСозданииНаСервере(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаЗагрузкаДанных

// Заполняет массив типов неразделенных данных, для которых поддерживается сопоставление ссылок
// при загрузке данных в другую информационную базу.
//
// Параметры:
//  Типы - Массив(ОбъектМетаданных).
//
Процедура ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
КонецПроцедуры

// Заполняет массив типов неразделенных данных, для которых не требуется сопоставление ссылок
// при загрузке данных в другую информационную базу, т.к. корректное сопоставление ссылок
// гарантируется с помощью других механизмов.
//
// Параметры:
//  Типы - Массив(ОбъектМетаданных).
//
Процедура ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
КонецПроцедуры

#КонецОбласти

#Область ОчередьЗаданий

// См. ЗарплатаКадры.ПриПолученииСпискаШаблонов.
//
Процедура ПриПолученииСпискаШаблоновОчередиЗаданий(Шаблоны) Экспорт
	
КонецПроцедуры

// См. ЗарплатаКадры.ПриПолученииСпискаШаблонов.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// См. ШаблоныСообщенийПереопределяемый.ПриОпределенииНастроек
Процедура ПриОпределенииНастроекШаблоновСообщений(Настройки) Экспорт
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриЗаполненииПочтыПолучателейВСообщении
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, НазначениеШаблона, ПредметСообщения) Экспорт

КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриЗаполненииТелефоновПолучателейВСообщении
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, НазначениеШаблона, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РегламентированнаяОтчетность
//

// Функция возвращает сведения об организации.
//
// Параметры:
//  Организация			- ссылка на элемент справочника "Организации";
//  ДатаЗначения		- дата, на которую нужно получить сведения;
//  СписокПоказателей	- список показателей, значения которых нужно вернуть.
//  
// Возвращаемое значение:
//  Структура с ключами из списка показателей и возвращаемыми значениями.
//
Функция ПолучитьСведенияОбОрганизации(Знач Организация, Знач ДатаЗначения = Неопределено, Знач СписокПоказателей = Неопределено) Экспорт
	Возврат ЗарплатаКадрыБазовый.ПолучитьСведенияОбОрганизации(Организация, ДатаЗначения, СписокПоказателей);
КонецФункции

// Процедура заполняет список используемых регламентированных отчетов.
//
Процедура ЗаполнитьСписокРегламентированныхОтчетов(СписокРегламентированныхОтчетов) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьСписокРегламентированныхОтчетов(СписокРегламентированныхОтчетов);
КонецПроцедуры

// Процедура заполняет структуру показателей.
// Ключ структуры - идентификатор показателя.
// Значение структуры - массив из двух элементов:
// 	- признак автозаполнения показателя,
//	- признак расшифровки показателя.
//
// Параметры:
// 	ПоказателиОтчета - структура показателей отчета,
// 	ИДОтчета         - идентификатор отчета,
//	ИДРедакцииОтчета - идентификатор редакции формы отчета.
//  ПараметрыОтчета  - Структура - структура параметров отчета.
//
Процедура ЗаполнитьПоказателиРегламентированногоОтчета(ПоказателиОтчета, ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета = Неопределено) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьПоказателиРегламентированногоОтчета(ПоказателиОтчета, ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета);
КонецПроцедуры

// Процедура заполняет переданную в виде контейнера структуру данных отчета.
//
Процедура ЗаполнитьРегламентированныйОтчет(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьРегламентированныйОтчет(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер);
КонецПроцедуры

// Функция возвращает имя справочника обособленных подразделений,
// используемого для автоматического заполнения статистической отчетности.
//
// Пример:
//  Возврат "ПодразделенияОрганизаций";
//
Функция ИмяСправочникаОбособленныхПодразделений() Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ИмяСправочникаОбособленныхПодразделений();
	
КонецФункции

// Функция возвращает имя реквизита справочника подразделений, который
// определяет, является ли подразделение обособленным (в трактовке Росстата).
// Используется для автоматического заполнения статистической отчетности.
//
// Тип реквизита - Булево.
// Если значение реквизита равно Истина - подразделение является обособленным.
// Если значение реквизита равно Ложь - подразделение не является обособленным.
//
// Пример:
//  Возврат "ИмеетНомерТерриториальногоОрганаРосстата";
//
Функция ИмяРеквизитаПризнакаОбособленногоПодразделения() Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ИмяРеквизитаПризнакаОбособленногоПодразделения();
	
КонецФункции

// Процедура переопределяет свойства объекта, с которыми он будет отображен в форме Отчетность.
// Параметры:
//  СвойстваОбъектов  - ТаблицаЗначений - (см. РегламентированнаяОтчетностьПереопределяемый.ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность).
Процедура ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность(СвойстваОбъектов) Экспорт
	ЗарплатаКадрыБазовый.ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность(СвойстваОбъектов);		
КонецПроцедуры

// Определяет свойства, касающиеся общих свойств объектов конфигураций-потребителей для отображения в форме Отчетность
// и возможности создания новый объектов из формы Отчетность.
//
// Параметры:
//  ТаблицаОписания  - ТаблицаЗначений -  (см. РегламентированнаяОтчетностьПереопределяемый.ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности).
//
Процедура ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности(ТаблицаОписания) Экспорт
	ЗарплатаКадрыБазовый.ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности(ТаблицаОписания);	
КонецПроцедуры

// Процедура переопределяет обработчик подписки на событие "ЗаписьОбъектовРегламентированнойОтчетности*".
//
// Параметры: - (см. РегламентированнаяОтчетностьПереопределяемый.ЗаписьОбъектовРегламентированнойОтчетности).
//
Процедура ЗаписьОбъектовРегламентированнойОтчетности(Ссылка, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Получает код ОКПО обособленного подразделения
// 
// Параметры:
//   Подразделение - СправочникСсылка.ПодразделенияОрганизаций
//   КодОКПО       - Строка(14) - код ОКПО обособленного подразделения.
Процедура ПолучитьКодОКПОПодразделения(Знач Подразделение, КодОКПО) Экспорт 
	ЗарплатаКадрыБазовый.ПолучитьКодОКПОПодразделения(Подразделение, КодОКПО);
КонецПроцедуры

// Получает код органа ФСГС обособленного подразделения
// 
// Параметры:
//   Подразделение - СправочникСсылка.ПодразделенияОрганизаций
//   КодФСГС       - Строка(5) - код органа ФСГС для подразделения (например, "23-45").
//
Процедура ПолучитьКодОрганаФСГСПодразделения(Подразделение, КодФСГС) Экспорт 
	ЗарплатаКадрыБазовый.ПолучитьКодОрганаФСГСПодразделения(Подразделение, КодФСГС);
КонецПроцедуры

#КонецОбласти

#Область Печать

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
// Подробнее см. УправлениеПечатьюПереопределяемый.
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
КонецПроцедуры

// Дополнительные настройки списка команд печати.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Значение по умолчанию: Истина.
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	ЗарплатаКадрыБазовый.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
	
КонецПроцедуры

#КонецОбласти

#Область ЭлектронноеВзаимодействие

// См. ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеСправочников.
Процедура ЭлектронноеВзаимодействиеПриОпределенииСоответствияСправочников(СоответствиеСправочников) Экспорт
	
	ЗарплатаКадрыБазовый.ЭлектронноеВзаимодействиеПриОпределенииСоответствияСправочников(СоответствиеСправочников);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Список, Ограничение) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииОграниченияДоступа(Список, Ограничение);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовДоступа.
Процедура УправлениеДоступомЗаполнитьСвойстваВидаДоступа(ВидыДоступа) Экспорт
	
	ЗарплатаКадрыБазовый.УправлениеДоступомЗаполнитьСвойстваВидаДоступа(ВидыДоступа);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииИспользованияВидаДоступа.
Процедура УправлениеДоступомЗаполнитьИспользованиеВидаДоступа(ИмяВидаДоступа, Использование) Экспорт
	
	ЗарплатаКадрыБазовый.УправлениеДоступомЗаполнитьИспользованиеВидаДоступа(ИмяВидаДоступа, Использование);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	
КонецПроцедуры

#КонецОбласти

// См. ЗарплатаКадры.ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений.
Процедура ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений(Форма, КоманднаяПанельФормы) Экспорт
	ЗарплатаКадрыБазовый.ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений(Форма, КоманднаяПанельФормы);
КонецПроцедуры

Функция РегистраторыПереносаДанных() Экспорт
	Возврат ЗарплатаКадрыБазовый.РегистраторыПереносаДанных();
КонецФункции

#Область УправлениеОтборамиВФормахСДинамическимСписком

Процедура НастроитьМодифицирующийПараметрОтбора(СтрокаПараметра, Список, МетаданныеОбъекта, Элементы) Экспорт
	
КонецПроцедуры

Процедура ДополнитьОписаниеМодифицирующегоПараметраОтбора(ИмяПараметра, ОписаниеПараметра, ИмяМодификации) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Выполняет начальное заполнение справочников и регистров сведений. Поддерживаются
// следующие имена объектов метаданных:
//
// Подсистема РасчетЗарплаты:
//		РегистрСведений.МинимальнаяОплатаТрудаРФ
//
// Подсистема УчетНДФЛ:
//		Справочник.ВидыВычетовНДФЛ
//		Справочник.ВидыДоходовНДФЛ
//		Справочник.СтатусыНалогоплательщиковПоНДФЛ
//		РегистрСведений.ВычетыПоДоходамНДФЛ
//		РегистрСведений.РазмерВычетовНДФЛ.
//
// Подсистема УчетСтраховыхВзносов:
//		Справочник.ВидыДоходовПоСтраховымВзносам
//		Справочник.ВидыТарифовСтраховыхВзносов
//		РегистрСведений.ПредельнаяВеличинаБазыСтраховыхВзносов
//		РегистрСведений.СтраховыеВзносыСкидкиКДоходам
//		РегистрСведений.ТарифыВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией
//		РегистрСведений.ТарифыВзносовПоРезультатамСпециальнойОценкиУсловийТруда
//		РегистрСведений.ТарифыСтраховыхВзносов.
//
// Подсистема ПерсонифицированныйУчет;
//		Справочник.ВидыОбщественноПолезнойДеятельностиСЗВК
//		Справочник.ОснованияДосрочногоНазначенияПенсии
//		Справочник.ОснованияДосрочногоНазначенияПенсииДляСЗВК
//		Справочник.ПараметрыИсчисляемогоСтраховогоСтажа
//		Справочник.ТерриториальныеУсловияПФР
//		РегистрСведений.ДопустимыеСочетанияКодовГруппСтажа.
//
// Подсистема ПособияСоциальногоСтрахования:
//		РегистрСведений.МаксимальныйРазмерЕжемесячнойСтраховойВыплаты
//
Процедура УстановитьНачальныеЗначения(ИменаОбъектовМетаданных) Экспорт
	
	ЗарплатаКадрыБазовый.УстановитьНачальныеЗначения(ИменаОбъектовМетаданных);
	
КонецПроцедуры

Процедура ПроверитьВозможностьСменыГоловнойОрганизации(Организация, Отказ) Экспорт
	
	ЗарплатаКадрыБазовый.ПроверитьВозможностьСменыГоловнойОрганизации(Организация, Отказ);
	
КонецПроцедуры

Функция ОписанияРегистровСодержащихРегистрацииВНалоговомОргане() Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ОписанияРегистровСодержащихРегистрацииВНалоговомОргане();
	
КонецФункции

Процедура ОтменитьЗаявлениеНаВычеты(Регистратор, Сотрудник) Экспорт
	
	ЗарплатаКадрыБазовый.ОтменитьЗаявлениеНаВычеты(Регистратор, Сотрудник);
	
КонецПроцедуры

// ЗарплатаКадрыПодсистемы.ПодписиДокументов

// См. ПодписиДокументовПереопределяемый.ПриОпределенииРолейПодписантов.
Процедура ПриОпределенииРолейПодписантов(РолиПодписантов) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииРолейПодписантов(РолиПодписантов);
КонецПроцедуры


Процедура ОбработкаПолученияФормыСтатьиРасходовЗарплата(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	// в базовой реализации не переопределяется
	
КонецПроцедуры

// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

Процедура ПриОпределенииИмениКлиентскогоПриложения(ИмяПриложения) Экспорт
	
КонецПроцедуры

Процедура ПроверитьИсключенияПроверкиЗапретаИзменения(Объект, ПроверкаЗапретаИзменения, УзелПроверкиЗапретаЗагрузки, ВерсияОбъекта) Экспорт
	
КонецПроцедуры

#КонецОбласти
