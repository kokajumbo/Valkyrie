
#Область СлужебныйПрограммныйИнтерфейс

// Заполняет объекты прикладных метаданных, в которых возможна
//   интеграция с ВетИС (в формах объектов)
// Параметры:
//   Результат - Массив - объекты прикладных метаданных
//
Процедура ЗаполнитьОбъектыМетаданныхИнтеграции(Результат) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет реквизит 'ЕдиницаИзмерения' справочника 'ЕдиницыИзмеренияВЕТИС' по ОКЕИ.
//
// Параметры:
//	СправочникОбъект - СправочникОбъект.ЕдиницыИзмеренияВЕТИС - Единица измерения ВЕТИС.
//
Процедура ЗаполнитьЕдиницуИзмеренияПоКлассификаторам(СправочникОбъект) Экспорт
	
	Если СправочникОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеКлассификатораВЕТИС = ИнтеграцияВЕТИСПовтИсп.ДанныеКлассификатораЕдиницИзмеренияВЕТИС();
	СтрокаКлассификатораВЕТИС = ДанныеКлассификатораВЕТИС.Найти(СправочникОбъект.Идентификатор, "ЕдиницаИзмеренияGUID");
	
	Если ЗначениеЗаполнено(СтрокаКлассификатораВЕТИС)
		И ЗначениеЗаполнено(СтрокаКлассификатораВЕТИС.КодОКЕИ) Тогда
		
		КодОКЕИ = СтрокаКлассификатораВЕТИС.КодОКЕИ;
		ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду(КодОКЕИ);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийДокументов

// Вызывается при вводе документа на основании, при выполнении метода Заполнить или при интерактивном вводе нового.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - заполняемый документ,
//  ДанныеЗаполнения - Произвольный - значение, которое используется как основание для заполнения,
//  ТекстЗаполнения - Строка, Неопределено - текст, используемый для заполнения документа,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполненияДокумента(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
	ИнтеграцияВЕТИСБП.ЗаполнениеДокументовВЕТИС(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

// Вызывается расширением формы при необходимости проверки заполнения реквизитов при записи или при проведении документа в форме,
// а также при выполнении метода ПроверитьЗаполнение.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - проверяемый документ,
//  Отказ - Булево - признак отказа от проведения документа,
//  ПроверяемыеРеквизиты - Массив - массив путей к реквизитам, для которых будет выполнена проверка заполнения,
//  МассивНепроверяемыхРеквизитов - Массив - массив путей к реквизитам, для которых не будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	Если ПроверяемыеРеквизиты.Найти("Товары.ТипПроисхождения") <> Неопределено Тогда
		ИнтеграцияВЕТИС.ПроверитьЗаполнениеТипаПроисхождения(ДокументОбъект, Отказ, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
	Если ПроверяемыеРеквизиты.Найти("Товары.Серия") <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Серия");
	КонецЕсли;
	
	Если ПроверяемыеРеквизиты.Найти("Товары.Характеристика") <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	КонецЕсли;
	
	Если ПроверяемыеРеквизиты.Найти("Товары.ИдентификаторПартии") <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ИдентификаторПартии");
	КонецЕсли;
	
	Если ПроверяемыеРеквизиты.Найти("Сырье.Серия") <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Сырье.Серия");
	КонецЕсли;
	
	Если ПроверяемыеРеквизиты.Найти("Сырье.Характеристика") <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Сырье.Характеристика");
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при проведении документа. Выполняется в транзакции записи.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - проводимый документ,
//  Отказ - Булево - признак отказа от проведения документа,
//  РежимПроведения - РежимПроведенияДокумента - текущий режим проведения.
//
Процедура ОбработкаПроведения(ДокументОбъект, Отказ, РежимПроведения) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Возникает перед выполнением записи документа. Вызывается после начала транзакции записи, но до начала записи документа.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - записываемый документ,
//  Отказ - Булево - признак отказа от записи,
//  РежимЗаписи - РежимЗаписиДокумента - текущий режим записи документа,
//  РежимПроведения - РежимПроведенияДокумента - текущий режим проведения документа.
//
Процедура ПередЗаписью(ДокументОбъект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ИнвентаризацияПродукцииВЕТИС") Тогда
		
		ИнтеграцияВЕТИСБП.ЗаписатьКоэффициентЕдиницИзмерения(ДокументОбъект, , "КоличествоИзменение");
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда		
		
		//Исходящие
		ИнтеграцияВЕТИСБП.ЗаписатьКоэффициентЕдиницИзмерения(ДокументОбъект);
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
		
		ИнтеграцияВЕТИСБП.ЗаписатьКоэффициентЕдиницИзмерения(ДокументОбъект);
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПроизводственнаяОперацияВЕТИС") Тогда
		
		ИнтеграцияВЕТИСБП.ЗаписатьКоэффициентЕдиницИзмерения(ДокументОбъект);
		//Исходящие
		ИнтеграцияВЕТИСБП.ЗаписатьКоэффициентЕдиницИзмерения(ДокументОбъект, "Сырье");

	КонецЕсли;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - форма, из обработчика события которой происходит вызов процедуры.
//	см. справочную информацию по событиям управляемой формы.
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Создает временную таблицу "ДокументыИнформационнойБазы", для дальнейшего использования в методе
//	ЗаполнениеДокументовВЕТИС.ДокументОснованиеПоДаннымСвязанныхДокументов.
//	Содержит колонки:
//		* ТипДокумента - ПеречислениеСсылка.ТипыДокументовВЕТИС - тип документа ВЕТИС, служит для определения типа связи со связанными документами;
//		* ПоказательУпорядочивания - ПроизвольныйТип - при определении документа основания, служит для определения приоритета найденных документов;
//		* Документ - ДокументСсылка - документ, который будет определяться как документ-основание;
//		* Дата - Дата - дата входящего документа, по которой будут сопоставляться данные документов ИБ и данные связанных документов;
//		* Номер - Строка - номер входящего документа, по которому будут сопоставляться данные документов ИБ и данные связанных документов;
//	Параметры:
//		ВременныеТаблицы - МенеджерВременныхТаблиц - менеджер временных таблиц запроса, в который будет добавлена создаваемая временная таблица.
//
Процедура ЗаполнитьВременнуюТаблицуСвязанныхДокументовИнформационнойБазы(ВременныеТаблицы) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДокументовВЕТИС.ПустаяСсылка) КАК ТипДокумента,
	|	НЕОПРЕДЕЛЕНО КАК ПоказательУпорядочивания,
	|	НЕОПРЕДЕЛЕНО КАК Документ,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК Дата,
	|	"""" КАК Номер
	|ПОМЕСТИТЬ ДокументыИнформационнойБазы
	|ГДЕ
	|	ЛОЖЬ";
	
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОрганизацииИКонтрагенты

// Определяет заданы ли настройки подключения к сервису интернет поддержки пользователей.
//
Процедура НастройкиПодключенияКСервисуИППЗаданы(НастройкиЗаданы) Экспорт

	Если ОбщегоНазначения.РазделениеВключено() Тогда
		НастройкиЗаданы = Истина;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		НастройкиЗаданы = ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	
КонецПроцедуры

// Заполняет параметры поиска хозяйствующего субъекта по элементу справочника конфигурации
// 
// Параметры:
// 	ДанныеКонтрагента - (см. ИнтеграцияВЕТИС.ДанныеКонтрагентаДляПоискаХозяйствующегоСубъекта) - параметры поиска
// 	Контрагент        - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - ссылка на контрагента информационной базы
//
Процедура ЗаполнитьДанныеКонтрагентаДляПоискаХозяйствующегоСубъекта(ДанныеКонтрагента, Контрагент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Контрагенты.ИНН          КАК ИНН,
	|	Контрагенты.КПП          КАК КПП,
	|	""""                     КАК ОГРН,
	|	Контрагенты.Наименование КАК Наименование,
	|	""""                     КАК НаименованиеПолное,
	|	ВЫБОР
	|		КОГДА Контрагенты.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыХозяйствующихСубъектовВЕТИС.ЮридическоеЛицо)
	|		КОГДА Контрагенты.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыХозяйствующихСубъектовВЕТИС.ИндивидуальныйПредприниматель)
	|	КОНЕЦ КАК Тип
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеКонтрагента, Выборка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ФизическиеЛица

// Заполняет значения реквизитов из справочника физических лиц используемые для создания пользователя ВетИС
// 
// Параметры:
// 	ДанныеФизЛица  - (см. ИнтеграцияВЕТИС.ДанныеФизическогоЛица) - структура реквизитов для заполнения
// 	ФизическоеЛицо - ОпределяемыйТип.ФизическоеЛицо - ссылка на физическое лицо информационной базы
//
Процедура ЗаполнитьДанныеФизическогоЛица(ДанныеФизЛица, ФизическоеЛицо) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ФИОФизическихЛицСрезПоследних.ФизическоеЛицо ЕСТЬ NULL ТОГДА ФизическиеЛица.Фамилия
	|		ИНАЧЕ ФИОФизическихЛицСрезПоследних.Фамилия
	|	КОНЕЦ КАК Фамилия,
	|	ВЫБОР
	|		КОГДА ФИОФизическихЛицСрезПоследних.ФизическоеЛицо ЕСТЬ NULL ТОГДА ФизическиеЛица.Имя
	|		ИНАЧЕ ФИОФизическихЛицСрезПоследних.Имя
	|	КОНЕЦ КАК Имя,
	|	ВЫБОР
	|		КОГДА ФИОФизическихЛицСрезПоследних.ФизическоеЛицо ЕСТЬ NULL ТОГДА ФизическиеЛица.Отчество
	|		ИНАЧЕ ФИОФизическихЛицСрезПоследних.Отчество
	|	КОНЕЦ КАК Отчество,
	|	ФизическиеЛица.ДатаРождения                      КАК ДатаРождения,
	|	ДокументыФизическихЛицСрезПоследних.ВидДокумента КАК ДокументВид,
	|	ДокументыФизическихЛицСрезПоследних.Серия        КАК ДокументСерия,
	|	ДокументыФизическихЛицСрезПоследних.Номер        КАК ДокументНомер,
	|	ГражданствоФизическихЛицСрезПоследних.Страна     КАК ГражданствоСтрана
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
	|		ПО ФИОФизическихЛицСрезПоследних.ФизическоеЛицо = ФизическиеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних КАК ДокументыФизическихЛицСрезПоследних
	|		ПО ДокументыФизическихЛицСрезПоследних.Физлицо = ФизическиеЛица.Ссылка
	|		 И ДокументыФизическихЛицСрезПоследних.ЯвляетсяДокументомУдостоверяющимЛичность
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних КАК ГражданствоФизическихЛицСрезПоследних
	|		ПО ГражданствоФизическихЛицСрезПоследних.ФизическоеЛицо = ФизическиеЛица.Ссылка
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ФизическоеЛицо
	|";
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ДанныеФизЛица, Выборка);
	КонецЕсли;
	
	Если ДанныеФизЛица.ДокументВид = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ Тогда
		ДанныеФизЛица.ДокументТип = Перечисления.ТипыДокументовВЕТИС.ПаспортГражданинаРФ;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Процедура вызывается при изменении статуса обработки документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - ссылка на документ,
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработки* - предыдущий статус обработки,
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработки* - новый статус обработки.
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса = Неопределено) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо определить значения по умолчанию, которые будут подставляться в
// реквизиты не сопоставленных элементов справочника.
//
// Параметры:
//  СобственнаяОрганизация - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - значение по умолчанию для собственной организации,
//  СторонняяОрганизация - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - значение по умолчанию для сторонней организации.
//
Процедура ЗначенияПоУмолчаниюНеСопоставленныхОбъектов(СобственнаяОрганизация,
		                                              СобственныйТорговыйОбъект,
		                                              СобственныйПроизводственныйОбъект,
		                                              СторонняяОрганизация,
		                                              СтороннийТорговыйОбъект) Экспорт
	
	СобственнаяОрганизация            = Справочники.Организации.ПустаяСсылка();
	СобственныйТорговыйОбъект         = Справочники.Склады.ПустаяСсылка();
	СобственныйПроизводственныйОбъект = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	СторонняяОрганизация              = Справочники.Контрагенты.ПустаяСсылка();
	СтороннийТорговыйОбъект           = Справочники.Контрагенты.ПустаяСсылка();
	
КонецПроцедуры

// Заполняет структуру данных транспортной накладной для входящей или исходящей транспортной операции по документу-основанию:
//  * Номер - Строка, Неопределено - номер транспортной накладной. Неопределено, если транспортная накладная не найдена.
//  * Дата - Дата, Неопределено - дата транспортной накладной. Неопределено, если транспортная накладная не найдена.
//
// Параметры:
//   ДанныеТТН         - Структура      - Заполняемые поля.
//   ДокументОснование - ДокументСсылка - Ссылка на документ-основание транспортной операции.
// 
Процедура ЗаполнитьДанныеТТНДляТранспортнойОперацииПоОснованию(ДанныеТТН, ДокументОснование) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область Отчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Процедура ДобавитьКомандуАнализРасхожденийПриПоступленииПродукцииВЕТИС(КомандыОтчетов) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Процедура ДобавитьКомандуАнализРасхожденийПриИнвентаризацииПродукцииВЕТИС(КомандыОтчетов) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ТабличнаяЧастьТовары

// Устанавливает параметры выбора номенклатуры.
//
// Параметры:
//	Форма			- УправляемаяФорма	- Форма, в которой нужно установить параметры выбора.
//	ИмяПоляВвода	- Строка			- Имя поля ввода номенклатуры.
//
Процедура УстановитьПараметрыВыбораНоменклатуры(Форма, ИмяПоляВвода = "ТоварыНоменклатура") Экспорт
	
	ПараметрыВыбора = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора);
	
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Услуга", Ложь));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ПодконтрольнаяПродукцияВЕТИС", Истина));
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецПроцедуры

// Заполняет количество номенклатуры по количеству ВЕТИС.
//
// Параметры:
//	ТекущаяСтрока	- ДанныеФормыЭлементКоллекции	- Строка табличной части объекта.
//	Суффикс			- Строка						- Окончание наименования колонки, содержащей количество по данным ВЕТИС.
//
Процедура ЗаполнитьКоличествоНоменклатурыПоКоличествуВЕТИС(ТекущаяСтрока, Суффикс = "") Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Номенклатура");
	СтруктураРеквизитов.Вставить("Количество" + Суффикс);
	СтруктураРеквизитов.Вставить("ЕдиницаИзмеренияВЕТИС");
	
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ТекущаяСтрока);
	
	Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов.Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	Количество = ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПересчитатьКоличествоЕдиниц(
		СтруктураРеквизитов["Количество" + Суффикс], 
		СтруктураРеквизитов.Номенклатура, 
		СтруктураРеквизитов.ЕдиницаИзмеренияВЕТИС, 
		Неопределено, ТекстОшибки);
		
	СтруктураРезультата = Новый Структура("Количество", Количество);
	
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураРезультата);
	
КонецПроцедуры

// Заполняет статус указания серий и проверяет серию в строке табличной части объекта.
//
// Параметры:
//	ДокументОбъект	- ДокументОбъект - Документ, для которого необходимо заполнить статус указания серии.
//	ТекущаяСтрока	- ДанныеФормыЭлементКоллекции - Строка табличной части объекта.
//
Процедура ПроверитьСериюРассчитатьСтатус(ДокументОбъект, ТекущаяСтрока) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Заполняет идентификатор партии по данным серии в строке табличной части объекта.
//
// Параметры:
//	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка табличной части объекта.
//	Серия - СправочникСсылка - Ссылка на справочник серий, в которой определен реквизит ИдентификаторПартииВЕТИС
//
Процедура ЗаполнитьИдентификаторПартии(ТекущаяСтрока, Серия) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Устанавливает служебный признак необходимости заполнения идентификатора партии в строке табличной части объекта.
//
// Параметры:
// - ТабличнаяЧастьТовары - ДанныеФормыКоллекция - Товарная табличная часть объекта.
//
Процедура ЗаполнитьИспользованиеИдентификаторовПартий(ТабличнаяЧастьТовары) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Серии

// Возвращает текст запроса для движений по регистру накопления СерииНоменклатуры.
//
// Возвращаемое значение:
//	Строка - текст запроса.
//
Процедура ЗаполнитьТекстЗапросаДвижениеСерийТоваров(ТекстЗапроса, МетаданныеДокумента) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура                                     КАК Номенклатура,
	|	ТаблицаСерии.Характеристика                                   КАК Характеристика,
	|	ТаблицаСерии.Серия                                            КАК Серия
	|ИЗ
	|	Документ.%ИмяДокумента%.Товары КАК ТаблицаСерии
	|
	|ГДЕ
	|	ТаблицаСерии.Ссылка = &Ссылка";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИмяДокумента%", МетаданныеДокумента.Имя);
	
КонецПроцедуры


// Заполняет, при необходимости создает серии в документе ВетИС или его выделенных строках
// 
// Параметры:
// 	Контекст  - (см. ИнтеграцияВЕТИС.СгенерироватьСерии) - структура входящих данных для заполнения/генерации серий 
// 	Результат - (см. ИнтеграцияВЕТИС.СтруктураРезультатЗаполненияСерий) - результат заполнения серий
//
Процедура ЗаполнитьСгенерироватьСерии(Контекст, Результат) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет, при необходимости создает серии в документе ВетИС или его выделенных строках
//
// Параметры:
// 	Объект - ДанныеФормыСтруктура - объект для заполнения
// 	Товары - ДанныеФормыКоллекция, ТаблицаЗначений - ТЧ документа
// 	ВыделенныеСтроки - Массив - выделенные строки документа
// 	ПараметрыУказанияСерий - (См. ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий)
// 	ТоварыУточнение - Неопределено, ДанныеФормыКоллекция - Дополнительная ТЧ, содержащая расшифровку строк товаров
// 	РезультатЗаполненияСерий - (См. ИнтеграцияВетис.СтруктураРезультатЗаполненияСерий)
//
Процедура ПриГенерацииСерий(Объект, Товары, ВыделенныеСтроки, ПараметрыУказанияСерий, ТоварыУточнение, РезультатЗаполненияСерий) Экспорт

	Возврат;

КонецПроцедуры

#КонецОбласти

#Область ДокументОснованиеПроизводственнойОперации


// Возникает при изменении документа-основания производственной операции ВетИС в форме документа.
// 
// Параметры:
//   Объект - ДанныеФормыСтруктура - редактируемый документ "производственная операция ВетИС"
//
Процедура ПриИзмененииДокументаОснованияПроизводственнойОперации(Объект) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Процедура заполняет признак использования комиссии при закупках или производства из давальческого сырья.
//
// Параметры:
//   Используется - Булево - Признак использования комиссии при закупках или производства из давальческого сырья.
//
Процедура ИспользуетсяКомиссияПриЗакупкахИлиПереработкаДавальческогоСырья(Используется) Экспорт
	
	Используется = Ложь;
	
КонецПроцедуры

// Процедура заполняет признак использования производства на стороне.
//
// Параметры:
//   Используется - Булево - Признак использования производства на стороне.
//
Процедура ИспользуетсяПереработкаНаСтороне(Используется) Экспорт
	
	Используется = Ложь;
	
КонецПроцедуры

// Процедура заполняет использование идентификатора партии в сериях в разрезе номенклатуры.
//
// Параметры:
//   Требуется    - Булево                       - Признак использования идентификатора партии в сериях номенклатуры.
//   Номенклатура - ОпределяемыйТип.Номенклатура - элемент номенклатуры.
//
Процедура ТребуетсяУказаниеИдентификатораПартииНоменклатуры(Требуется, Номенклатура) Экспорт
	
	Требуется = Ложь;
	
КонецПроцедуры

// Процедура определяет использование транспортных средств
//
// Параметры:
//   Указывается - Булево - Признак использования транспортных средств.
//
Процедура УказываетсяТранспортноеСредство(Указывается) Экспорт
	
	Указывается = Истина;
	
КонецПроцедуры


// Заполняет данные реквизитов пункта маршрута ВетИС получаемые из транспортного средства
// 
// Параметры:
//   Реквизиты - Структура - возможные реквизиты пункта маршрута ВетИС с данными транспортного средства
//   ТранспортноеСредство - ОпределяемыйТип.ТранспортныеСредстваВЕТИС - транспортное средство
//
Процедура ПриОпределенииРеквизитовТранспортногоСредства(Реквизиты, ТранспортноеСредство) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать запись сопоставления хозяйствующих субъектов и предприятий с прикладными
//   справочниками конфигурации
//
// Параметры:
//  ДокументОснование - ДокументСсылка, ДокументОбъект - прикладной документ конфигурации,
//  ДокументОбъект    - ДокументСсылка, ДокументОбъект - связанный с ним документ библиотеки.
//
Процедура ЗаполнитьСоответствиеШапкиОбъектов(ДокументОснование, ДокументОбъект) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Используется для тестирования проблемы рассинхронизации данных между информационной базой и ФГИС Меркурий
// при получении ошибки 408 (Таймаут)
//
// Пример кода:
// РезультатОтправкиЗапроса = Новый Структура;
// РезультатОтправкиЗапроса.Вставить("ТекстСообщенияXMLОтправлен",  Ложь);
// РезультатОтправкиЗапроса.Вставить("ТекстСообщенияXMLПолучен",    Ложь);
// РезультатОтправкиЗапроса.Вставить("КодСостояния",                408);
// РезультатОтправкиЗапроса.Вставить("ТекстОшибки",                 НСтр("ru = 'Эмуляция ошибки HTTP 408: Таймаут'"));
// РезультатОтправкиЗапроса.Вставить("ТекстВходящегоСообщенияSOAP", "");
//
// Параметры:
//  ТекстСообщенияXML - Строка - Сообщение XML.
//  Операция - ПеречислениеСсылка - Операция.
//  ПараметрыЗапроса - Структура - Параметры запроса.
//  ПараметрыОбмена - Структура - Параметры обмена.
//  РезультатОтправкиЗапроса - Структура - Возвращаемое значение.
Процедура ПередОтправкойЗапроса(ТекстСообщенияXML, Операция, ПараметрыЗапроса, ПараметрыОбмена, РезультатОтправкиЗапроса) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Используется для тестирования проблемы рассинхронизации данных между информационной базой и ФГИС Меркурий
// при получении ошибок APLM и т.п.
//
// Пример кода:
// Если Операция = Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхЗаписейСкладскогоЖурнала
//	Или Операция = Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхВСД Тогда
//		Если СтрНайти(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияSOAP, "COMPLETED") > 0
//			Или СтрНайти(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияSOAP, "REJECTED") > 0 Тогда
//		Тестирование_ПолучитьAPLM0012(РезультатОтправкиЗапроса, ПараметрыЗапроса, Операция, ПараметрыОбмена);
//		КонецЕсли;
//	КонецЕсли;
// 
// Параметры:
//  ТекстСообщенияXML - Строка - Сообщение XML.
//  Операция - ПеречислениеСсылка - Операция.
//  ПараметрыЗапроса - Структура - Параметры запроса.
//  ПараметрыОбмена - Структура - Параметры обмена.
//  РезультатОтправкиЗапроса - Структура - Возвращаемое значение.
Процедура ПослеОтправкиЗапроса(ТекстСообщенияXML, Операция, ПараметрыЗапроса, ПараметрыОбмена, РезультатОтправкиЗапроса) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
