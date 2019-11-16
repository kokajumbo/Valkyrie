#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Панель1СМаркировка

// Возвращает текст запроса для получения общего количества документов в работе
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОбИмпорте() Экспорт
	
	ТекстЗапросаУведомленияОбИмпорте = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаУведомленияОбИмпорте(ТекстЗапросаУведомленияОбИмпорте);
	Возврат ТекстЗапросаУведомленияОбИмпорте;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОбИмпортеОформите() Экспорт
	
	ТекстЗапросаУведомленияОбИмпортеОформите = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаУведомленияОбИмпортеОформите(ТекстЗапросаУведомленияОбИмпортеОформите);
	Возврат ТекстЗапросаУведомленияОбИмпортеОформите;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОбИмпортеОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ КАК УведомлениеОбИмпортеМаркированныхТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.ТекущееУведомление = УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен))
	|	И (УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОбИмпортеОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ КАК УведомлениеОбИмпортеМаркированныхТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.ТекущееУведомление = УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации))
	|	И (УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеГИСМ

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ");
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередаче;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.Передано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти 

#Область СообщенияГИСМ

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		Возврат УведомлениеОбИмпортеМаркированныхТоваровСXML(ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	КонецЕсли;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления библиотеки ГИСМ на версию 1.0.2
// В документе "Уведомление об импорте маркированных товаров" удаляет виды меха, не соответствующие новому классификатору.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТаблицаСоответствий = Справочники.ВидыМехаГИСМ.ТаблицаСоответствийВидовМехаПриПереходеНаФорматОбмена2_41();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаСоотвествий.КодНовый КАК КодНовый,
	|	ТаблицаСоотвествий.НаименованиеНовый КАК НаименованиеНовый,
	|	ТаблицаСоотвествий.КодСтарый КАК КодСтарый,
	|	ТаблицаСоотвествий.НаименованиеСтарый КАК НаименованиеСтарый
	|ПОМЕСТИТЬ ТаблицаСоответствий
	|ИЗ
	|	&ТаблицаСоотвествий КАК ТаблицаСоотвествий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыМехаГИСМ.Ссылка
	|ПОМЕСТИТЬ ЭлементыСтарогоКлассификатора
	|ИЗ
	|	Справочник.ВидыМехаГИСМ КАК ВидыМехаГИСМ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСоответствий КАК ТаблицаСоответствий
	|		ПО ВидыМехаГИСМ.Наименование = ТаблицаСоответствий.НаименованиеСтарый
	|			И ВидыМехаГИСМ.Код = ТаблицаСоответствий.КодСтарый
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыМехаГИСМ.Ссылка
	|ПОМЕСТИТЬ ПомечаемыеНаУдалениеВидыМеха
	|ИЗ
	|	Справочник.ВидыМехаГИСМ КАК ВидыМехаГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСоответствий КАК ТаблицаСоответствий
	|		ПО ВидыМехаГИСМ.Код = ТаблицаСоответствий.КодНовый
	|			И ВидыМехаГИСМ.Наименование = ТаблицаСоответствий.НаименованиеНовый
	|ГДЕ
	|	НЕ ВидыМехаГИСМ.Ссылка В
	|				(ВЫБРАТЬ
	|					ЭлементыСтарогоКлассификатора.Ссылка
	|				ИЗ
	|					ЭлементыСтарогоКлассификатора КАК ЭлементыСтарогоКлассификатора)
	|	И ТаблицаСоответствий.КодНовый ЕСТЬ NULL
	|	И (НЕ ВидыМехаГИСМ.ПометкаУдаления
	|			ИЛИ ВидыМехаГИСМ.Код = """")
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.Ссылка
	|ИЗ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Товары КАК УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары
	|ГДЕ
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.ВидМеха В
	|			(ВЫБРАТЬ
	|				ПомечаемыеНаУдалениеВидыМеха.Ссылка
	|			ИЗ
	|				ПомечаемыеНаУдалениеВидыМеха КАК ПомечаемыеНаУдалениеВидыМеха)";
	
	Запрос.УстановитьПараметр("ТаблицаСоотвествий", ТаблицаСоответствий);
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ";
	МетаданныеОбъекта = Метаданные.Документы.УведомлениеОбИмпортеМаркированныхТоваровГИСМ;
	ПустаяСсылкаВидМеха = Справочники.ВидыМехаГИСМ.ПустаяСсылка();
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТаблицаСоответствий = Справочники.ВидыМехаГИСМ.ТаблицаСоответствийВидовМехаПриПереходеНаФорматОбмена2_41();
	
	ТекстЗапроса= "
	|ВЫБРАТЬ
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.Ссылка КАК Ссылка,
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.Ссылка.ВерсияДанных КАК ВерсияДанных,
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.НомерСтроки
	|ИЗ
	|	&ВТДокументыДляОбработки КАК СсылкиДляОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Товары КАК УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары
	|		ПО СсылкиДляОбработки.Ссылка = УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.Ссылка
	|ГДЕ
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМТовары.ВидМеха.ПометкаУдаления
	|ИТОГИ ПО
	|	Ссылка
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТДокументыДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаСоотвествий", ТаблицаСоответствий);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИтоги.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаИтоги.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ЕстьИзменения = Ложь;
			УведомлениеОбИмпортеОбъект = ОбновлениеИнформационнойБазыГИСМ.ПроверитьПолучитьОбъект(ВыборкаИтоги.Ссылка,
			                                                                                    ВыборкаИтоги.ВерсияДанных,
			                                                                                    Параметры.Очередь);
			
			Если УведомлениеОбИмпортеОбъект = Неопределено Тогда
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВыборкаИтоги.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
				
			КонецЕсли;
			
			ВыборкаДетали = ВыборкаИтоги.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				СтрокаКИзменению = УведомлениеОбИмпортеОбъект.Товары.Найти(ВыборкаДетали.НомерСтроки, "НомерСтроки");
				Если СтрокаКИзменению <> Неопределено И ЗначениеЗаполнено(СтрокаКИзменению.ВидМеха) Тогда
					СтрокаКИзменению.ВидМеха = ПустаяСсылкаВидМеха;
					ЕстьИзменения = Истина;
				КонецЕсли
			КонецЦикла;
			
			Если ЕстьИзменения Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(УведомлениеОбИмпортеОбъект, Истина,,РежимЗаписиДокумента.Запись);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВыборкаИтоги.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Объект% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", ВыборкаИтоги.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         МетаданныеОбъекта,
			                         ВыборкаИтоги.Ссылка,
			                         ТекстСообщения);
			Продолжить;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	ИнтеграцияГИСМПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение,
		ОбщегоНазначения.ИмяТаблицыПоСсылке(ПустаяСсылка()));

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияГИСМ

Функция УведомлениеОбИмпортеМаркированныхТоваровСXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Дата            КАК Дата,
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Номер           КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0)           КАК ПоследнийНомерВерсии,
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Основание       КАК Основание,
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Организация     КАК Организация,
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Подразделение   КАК Подразделение
	|ИЗ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ КАК УведомлениеОбИмпортеМаркированныхТоваровГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки                 КАК НомерСтроки,
	|	Товары.Номенклатура                КАК Номенклатура,
	|	Товары.Характеристика              КАК Характеристика,
	|	&ПолеНоменклатураОписание          КАК НоменклатураОписание,
	|	Товары.КодТНВЭД                    КАК КодТНВЭД,
	|	Товары.ВидМеха.Код                         КАК КодВидМеха,
	|	ЕСТЬNULL(НомераКиЗ.НомерКиЗ, Неопределено) КАК НомерКиЗ
	|ИЗ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.НомераКиЗ КАК НомераКиЗ
	|		ПО НомераКиЗ.Ссылка = Товары.Ссылка
	|		И НомераКиЗ.КлючСвязи = Товары.КлючСвязи
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки");
	
	ПолеНоменклатураОписание = Неопределено;
	ИнтеграцияГИСМПереопределяемый.ОпределитьПолеОписанияНоменклатурыУведомленияОбИмпорте(ПолеНоменклатураОписание);
	Если ЗначениеЗаполнено(ПолеНоменклатураОписание) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолеНоменклатураОписание", ПолеНоменклатураОписание);
	Иначе
		Запрос.УстановитьПараметр("ПолеНоменклатураОписание", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить();
	Если Не Шапка.Следующий()
		Или Товары.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхИмпортМаркированнойПродукции, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхИмпортМаркированнойПродукции, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "sign_detail";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	УведомлениеОбИмпорте = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	УведомлениеОбИмпорте.action_id  = УведомлениеОбИмпорте.action_id;
	
	Попытка
		УведомлениеОбИмпорте.sender_gln = РеквизитыОгранизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
	КонецПопытки;
	
	УведомлениеОбИмпорте.import = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОбИмпорте, "import", Версия);
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		//ГИСМБП
		ПредставлениеНоменклатуры =СтрокаТЧ.НоменклатураОписание;
		//Конец ГИСМБП
		
		НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОбИмпорте.import, "signs", Версия);
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
			НоваяСтрока.sign_num = СтрокаТЧ.НомерКиЗ;
		Иначе
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'Не заполнены номера КиЗ для номенклатуры %1 в строке %2.'"), ПредставлениеНоменклатуры, СтрокаТЧ.НомерСтроки));
		КонецЕсли;
		
		Попытка
			НоваяСтрока.tnved_code = СтрокаТЧ.КодТНВЭД;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'Не заполнен Код ТНВЭД для номенклатуры %1 в строке %2.'"), ПредставлениеНоменклатуры, СтрокаТЧ.НомерСтроки));
		КонецПопытки;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.КодВидМеха) Тогда
			Попытка
				НоваяСтрока.fur_kind = СтрокаТЧ.КодВидМеха;
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'Не корректно заполнен Вид меха для номенклатуры %1 в строке %2.'"), ПредставлениеНоменклатуры, СтрокаТЧ.НомерСтроки));
			КонецПопытки;
		КонецЕсли;
		
		Попытка
			НоваяСтрока.goods_description = СтрЗаменить(СтрокаТЧ.НоменклатураОписание, Символы.ПС, " ");
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'Не заполнено Описание товара для номенклатуры %1 в строке %2.'"), ПредставлениеНоменклатуры, СтрокаТЧ.НомерСтроки));
		КонецПопытки;
		
		УведомлениеОбИмпорте.import.signs.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = УведомлениеОбИмпорте;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Основание    = Шапка.Основание;
	СообщениеXML.Версия       = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

