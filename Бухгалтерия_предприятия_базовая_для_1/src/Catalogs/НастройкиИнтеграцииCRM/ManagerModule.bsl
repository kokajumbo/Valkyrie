#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейсБТС

// Возвращает двоичные данные и идентификатор обработчика объекта,
// которые будут переданы в составе zip-архива во внешнюю учетную систему.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных
//  ИдентификаторОбъекта - Строка(50) - идентификатор объекта. 
//  Обработчик - Строка(50) - обработчик данных объекта. 
// 
// Возвращаемое значение:
//   - ДвоичныеДанные - данные объекта. 
//
Функция ДанныеОбъекта(УчетнаяСистема, ИдентификаторОбъекта, Обработчик) Экспорт
	
	СсылкаНаОбъект = РегистрыСведений.ДокументыИнтеграцииCRM.ДокументПоИдентификатору(ИдентификаторОбъекта);
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru='По идентификатору %1 не найден объект'"), ИдентификаторОбъекта);
	КонецЕсли;
	Возврат РегистрыСведений.ДокументыИнтеграцииCRM.ДвоичныеДанныеДокументаДляОтправки(
		СсылкаНаОбъект, УчетнаяСистема, Обработчик);
	
КонецФункции

// Предназначен для обработки подтверждений, полученных от учетной системы после принятия файлов данных.
// В ней можно определить действия с интегрируемыми объектами, по которым пришли подтверждения.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных
//  Подтверждения - Соответствие
//                  * Ключ - Строка - это идентификатор объекта
//                  * Значение - Структура
//                      ** Версия - Строка - версия объекта
//                      ** Версия - Строка - версия объекта
//                      ** КодВозврата - Число - код возврата, определяется во внешней учетной системе.
//                         Рекомендуемые коды возврата см. в процедуре ИнтеграцияОбъектовОбластейДанныхПовтИсп.КодыВозврата
//                      ** Ошибка - Булево - признак ошибки (по умолчанию - Ложь)
//                      ** СообщениеОбОшибке - Строка - поднобности ошибки (по умолчанию не заполнено)
//  СтандартнаяОбработка - Булево - признак стандартной обработки. Если Ложь, то обработанные объекты 
//                       не будут удалены из списка объектов к отправке.
//
Процедура ОбработатьПодтверждения(УчетнаяСистема, Подтверждения, СтандартнаяОбработка) Экспорт
	
	Для Каждого Подтверждение Из Подтверждения Цикл
		
		СсылкаНаОбъект = РегистрыСведений.ДокументыИнтеграцииCRM.ДокументПоИдентификатору(Подтверждение.Ключ);
		
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Подтверждение.Значение.Ошибка Тогда
			РегистрыСведений.ДокументыИнтеграцииCRM.УстановитьСостояниеОшибкаПередачи(
				СсылкаНаОбъект, Подтверждение.Значение.СообщениеОбОшибке);
		Иначе
			РегистрыСведений.ДокументыИнтеграцииCRM.УстановитьСостояниеДокументСинхронизировано(
				СсылкаНаОбъект, УчетнаяСистема, Подтверждение.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Предназначена для обработки данных объектов, получаемых от внешней учетной системы.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система.
//  ИдентификаторОбъекта - Строка(50) - идентификатор объекта для обработка
//  ПотокДанных - ФайловыйПоток, ПотокВПамяти - данные объекта
//  Обработчик - Строка - идентификатор обработчика
//  КодВозврата - Число - код возврата обработчика (по умолчанию - 10200)
//  Ошибка - Булево - признак ошибки (по умолчанию - Ложь)
//  СообщениеОбОшибке - Строка - подробности ошибки (по умолчанию не заполнено).
//
Процедура ОбработатьДанные(УчетнаяСистема, ИдентификаторОбъекта, ПотокДанных, Обработчик, 
	КодВозврата, Ошибка, СообщениеОбОшибке) Экспорт
	
	РегистрыСведений.ДокументыИнтеграцииCRM.ОбработатьДанные(УчетнаяСистема, ИдентификаторОбъекта,
		ПотокДанных, Обработчик, КодВозврата, Ошибка, СообщениеОбОшибке);
	
КонецПроцедуры

// Предназначена для обработки устанавливаемых настроек учетной системы, 
// полученных от внешней учетной системы.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных 
//  ПотокДанных - ФайловыйПоток, ПотокВПамяти - данные настроек (передаются в формате json) 
//  КодВозврата - Число - код возврата обработчика установки настроек (по умолчанию - 10200).
//  Ошибка - Булево - признак ошибки (по умолчанию - Ложь) 
//  СообщениеОбОшибке - Строка - подробности ошибки (по умолчанию не заполнено).
//  СтандартнаяОбработка - Булево - признак стандартной обработки. 
//
Процедура УстановитьНастройки(УчетнаяСистема, ПотокДанных, КодВозврата, Ошибка, СообщениеОбОшибке) Экспорт
	
	Объект = УчетнаяСистема.ПолучитьОбъект();
	Данные = СтруктураИзПотокаJSON(ПотокДанных);
	
	Свойство = "version_ed";
	Если Данные.Свойство(Свойство) Тогда
		Объект.ВерсияФормата = Данные[Свойство];
	КонецЕсли;
	
	Объект.Записать();
	
	ВключитьИнтерфейсODATA();
	
	УстановитьПраваПользователяИнтеграции(УчетнаяСистема);
	
КонецПроцедуры

// Возвращает идентификатор типа учетной системы для определения менеджера объекта, 
// если ссылки на учетную систему с пользователем обратившейся внешней системы еще не существует.
//
Функция ТипУчетнойСистемы() Экспорт
	
	Возврат "crm";
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если в базе есть хотя бы одна действующая настройка интеграции c CRM.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ИнтеграцияВИнформационнойБазеВключена() Экспорт
	
	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиИнтеграцииCRM.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НастройкиИнтеграцииCRM КАК НастройкиИнтеграцииCRM
	|ГДЕ
	|	НастройкиИнтеграцииCRM.ПометкаУдаления = ЛОЖЬ";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкиИнтеграции

Процедура ВключитьИнтерфейсODATA()
	
	ОбъектыМетаданных = Новый Массив;
	
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Валюты);
	ОбъектыМетаданных.Добавить(Метаданные.Перечисления.СтавкиНДС);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.КлассификаторЕдиницИзмерения);
	
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Организации);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.НастройкиСистемыНалогообложения);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.БанковскиеСчета);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Банки);
	
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Контрагенты);
	
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Номенклатура);
	
	ОбъектыМетаданных.Добавить(Метаданные.Документы.СчетНаОплатуПокупателю);
	
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ТипыЦенНоменклатуры);
	ОбъектыМетаданных.Добавить(Метаданные.Перечисления.СпособыЗаполненияЦен);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.ЦеныНоменклатуры);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов);
	
	УстановитьСоставСтандартногоИнтерфейсаOData(ОбъектыМетаданных);
	
КонецПроцедуры

Процедура УстановитьПраваПользователяИнтеграции(НастройкиИнтеграции)
	
	Пользователь = ПользовательИнтеграцииCRM(НастройкиИнтеграции);
	Если ЗначениеЗаполнено(Пользователь) Тогда
		УправлениеДоступомБП.УстановитьПраваСлужебногоПользователяИнтеграцииCRM(Пользователь);
	КонецЕсли;
	
КонецПроцедуры

Функция ПользовательИнтеграцииCRM(НастройкиИнтеграции)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиУчетныхСистем.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.НастройкиУчетныхСистем КАК НастройкиУчетныхСистем
	|ГДЕ
	|	НастройкиУчетныхСистем.УчетнаяСистема = &УчетнаяСистема
	|	И НЕ НастройкиУчетныхСистем.УчетнаяСистема.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("УчетнаяСистема", НастройкиИнтеграции);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Пользователь;
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

Функция СтруктураИзПотокаJSON(ПотокДанных)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьПоток(ПотокДанных);
	Ответ = ПрочитатьJSON(ЧтениеJSON,,, ФорматДатыJSON.ISO);
	ЧтениеJSON.Закрыть();
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли