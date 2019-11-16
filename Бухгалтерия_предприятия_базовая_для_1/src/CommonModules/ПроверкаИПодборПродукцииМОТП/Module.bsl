#Область ПрограммныйИнтерфейс

#Область ВстраиваниеФормыПроверкиИПодбора

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции формы проверки и подбора
//   в прикладные документы конфигураци - потребителя библиотеки ГосИС. Если передана форма - сразу заполняет ее
//   специфику в переопределяемом модуле.
//
// Параметры:
//  Форма - УправляемаяФорма, Неопределено - форма для которой возвращаются параметры интеграции
//
// ВозвращаемоеЗначение:
//  ПараметрыИнтеграции - Структура - значения, используемые для интеграции формы проверки и подбора:
//   * ИспользоватьБезТабачнойПродукции           - Булево - признак показа гиперссылки в форме документа без табачной продукции
//   * БлокироватьТабличнуюЧастьТоварыПриПроверке - Булево - признак блокировки табличной части "Товары" для изменений после начала проверки в форме
//   * ИнформацияДляПользователяОБлокировке       - Строка - информационная надпись на форме над табличной частью "Товары" при БлокироватьТабличнуюЧастьТоварыПриПроверке = Истина
//   * ИнформацияДляПользователяОПроверке         - Строка - информационная надпись на форме над табличной частью "Товары" при БлокироватьТабличнуюЧастьТоварыПриПроверке = Ложь
//   * ИспользоватьСтатусПроверкаЗавершена        - Булево - признак допустимости у документа состояния завершения проверки. При значении Ложь проверку можно выполнять многократно.
//   * ИмяРеквизитаФормыОбъект                    - Строка - имя реквизита формы, содержащего объект документа
//   * ИмяТабличнойЧастиТовары                    - Строка - имя табличной части документа, содержащей номенклатуру
//   * ИмяРодительскойГруппыФормы                 - Строка - имя элемента-группы формы документа, в которую необходимо добавить гиперссылку для открытия формы проверки
//   * ИмяЭлементаФормыТовары                     - Строка - имя элемента формы документа, в котором выводится табличная часть с номенклатурой
//   * ИмяПоследующегоЭлементаФормы               - Строка - имя элемента формы, перед которым необходимо добавить гиперссылку для открытия формы проверки
//   * БлокируемыеЭлементы                        - Массив - имена элементов формы документа, которые необходимо заблокировать после начала работы с формой проверки
//   * ИспользоватьСтатусПроверкиПодбораДокумента - Булево - признак наличия у формы реквизита "СтатусПроверкиГосИС"
//   * ИспользоватьКолонкуСтатусаПроверкиПодбора  - Булево - признак использования специальной колонки в таблице товаров для отображения статуса проверки товара
//   * ИмяСледующейКолонки                        - Строка - имя колонки, перед которой необходимо вставить колонку для отображения статуса проверки товара
//   * ИмяТабличнойЧастиШтрихкодыУпаковок         - Строка - имя табличной части документа, содержащей штрихкоды упаковок номенклатуры
//   * ХарактеристикиИспользуются                 - Булево - общий признак использования характеристик
//   * СерииИспользуются                          - Булево - общий признак использования серий
Функция ПараметрыИнтеграцииФормыПроверкиИПодбора(Форма = Неопределено) Экспорт
	
	ПараметрыИнтеграции = Новый Структура();
	
	//  Показывать гиперссылку в документе без табачной продукции
	ПараметрыИнтеграции.Вставить("ИспользоватьБезТабачнойПродукции", Ложь);
	//  Сценарии работы с блокированием ТЧ Товары или без ее блокирования в процессе подбора в документ
	ПараметрыИнтеграции.Вставить("БлокироватьТабличнуюЧастьТоварыПриПроверке", Истина);
	ПараметрыИнтеграции.Вставить("ИнформацияДляПользователяОБлокировке", НСтр(
		"ru = 'До окончания работы в форме сканирования и проверки табачной продукции внесение изменений в данной форме недоступно.'"));
	ПараметрыИнтеграции.Вставить("ИнформацияДляПользователяОПроверке", НСтр(
		"ru = 'Выполняется проверка табачной продукции. При окончании работы в форме проверки табличная часть может быть изменена.'"));
	
	//  Сценарии работы "не проверялась -> проверяется <-> проверена" или "не проверяется <-> проверяется"
	ПараметрыИнтеграции.Вставить("ИспользоватьСтатусПроверкаЗавершена", Истина);
	
	ПараметрыИнтеграции.Вставить("ИмяРеквизитаФормыОбъект",      "Объект");
	ПараметрыИнтеграции.Вставить("ИмяТабличнойЧастиТовары",      "Товары");
	ПараметрыИнтеграции.Вставить("ИмяРодительскойГруппыФормы",   "СтраницаТовары");
	ПараметрыИнтеграции.Вставить("ИмяЭлементаФормыТовары",       "Товары");
	ПараметрыИнтеграции.Вставить("ИмяПоследующегоЭлементаФормы", "Товары");
	ПараметрыИнтеграции.Вставить("БлокируемыеЭлементы",          Новый Массив);
	
	ПараметрыИнтеграции.Вставить("ИспользоватьСтатусПроверкиПодбораДокумента", Ложь);
	ПараметрыИнтеграции.Вставить("ИспользоватьКолонкуСтатусаПроверкиПодбора",  Ложь);
	ПараметрыИнтеграции.Вставить("ИмяСледующейКолонки",                        "ТоварыНоменклатура");
	ПараметрыИнтеграции.Вставить("ИмяТабличнойЧастиШтрихкодыУпаковок",         "ШтрихкодыУпаковок");
	
	ПараметрыИнтеграции.Вставить("ХарактеристикиИспользуются", ИнтеграцияИС.ХарактеристикиИспользуются());
	ПараметрыИнтеграции.Вставить("СерииИспользуются",          ИнтеграцияИС.СерииИспользуются());
	
	Если НЕ(Форма = Неопределено) Тогда
		ПроверкаИПодборПродукцииМОТППереопределяемый.ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(
			Форма, ПараметрыИнтеграции);
	КонецЕсли;
	
	Возврат ПараметрыИнтеграции;
	
КонецФункции

// Вызывается при возникновении событий "ПриСозданииНаСервере" форм прикладных документов
// в конфигурации - потребителе библиотеки ГосИС.
//
// Параметры:
// 	 * Форма - УправляемаяФорма - форма прикладного документа, в который встраивается функциональность библиотеки ГосИС:
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	ПараметрыИнтеграцииФормыПроверки = ПараметрыИнтеграцииФормыПроверкиИПодбора(Форма);
	ДобавитьУдалитьЭлементыПроверкиИПодбораПриНеобходимости(Форма, ПараметрыИнтеграцииФормыПроверки, Истина);
	ЗаполнитьКешШтрихкодовУпаковок(Форма);
	
КонецПроцедуры

// Вызывается при возникновении событий "ПослеЗаписиНаСервере" форм прикладных документов
// в конфигурации - потребителе библиотеки ГосИС.
//
// Параметры:
//  Форма - УправляемаяФорма - форма прикладного документа, в который встраивается функциональность библиотеки ГосИС
//  ПараметрыИнтеграцииФормыПроверки - (Cм. ПроверкаИПодборПродукцииМОТПКлиентСервер.ПараметрыИнтеграцииФормыПроверкиИПодбора)
Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	ДобавитьУдалитьЭлементыПроверкиИПодбораПриНеобходимости(Форма, Форма.ПараметрыИнтеграцииФормыПроверкиГосИС.МОТП);
	ЗаполнитьКешШтрихкодовУпаковок(Форма);
	ПроверкаИПодборПродукцииМОТПВызовСервера.ПрименитьКешШтрихкодовУпаковок(Форма);
	
КонецПроцедуры

// Вызывается при закрытии формы проверки и подбора табачной продукции из форм прикладных документов
//   в конфигурации - потребителе библиотеки ГосИС.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма прикладного документа, в который встраивается функциональность библиотеки ГосИС
//  ПараметрыИнтеграцииФормыПроверки - (Cм. ПроверкаИПодборПродукцииМОТПКлиентСервер.ПараметрыИнтеграцииФормыПроверкиИПодбора)
Процедура УправлениеЭлементамиОткрытияФормыПроверкиИПодбора(Форма) Экспорт
	
	Если НЕ СуществуютЭлементыПроверкиИПодбораПродукцииМОТП(Форма) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыИнтеграцииФормыПроверки = Форма.ПараметрыИнтеграцииФормыПроверкиГосИС.МОТП;
	
	ЭлементыФормы = Форма.Элементы;
	ЭлементыФормы.ГруппаСканированиеИПроверкаТабачнойПродукции.Видимость = Истина;

	Объект = Форма[ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект];
	
	МенеджерОбъекта    = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Форма.ИмяФормы);
	ЕстьПравоИзменение = ПравоДоступа("Изменение", МенеджерОбъекта.ПустаяСсылка().Метаданные());
	
	ЭтоДокументПриобретения = ПроверкаИПодборПродукцииМОТПКлиентСервер.ЭтоДокументПриобретения(МенеджерОбъекта.ПустаяСсылка());
	СтатусПроверкиИПодбора  = СтатусПроверкиИПодбораДокумента(Объект.Ссылка);
	
	Если ПараметрыИнтеграцииФормыПроверки.ИспользоватьСтатусПроверкиПодбораДокумента Тогда
		Форма.СтатусПроверкиГосИС = СтатусПроверкиИПодбора;
	КонецЕсли;
	
	Если СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.Выполняется Тогда
		
		Если ЕстьПравоИзменение Тогда
			ЭлементыФормы.ГруппаИнформацияОСканированииВДругойФорме.Видимость = Истина;
			Если ЭтоДокументПриобретения Тогда
				ЗаголовокСсылки = НСтр("ru = 'Продолжить проверку поступившей табачной продукции'");
			Иначе
				ЗаголовокСсылки = НСтр("ru = 'Продолжить подбор и проверку табачной продукции'");
			КонецЕсли;
		Иначе
			ЭлементыФормы.ГруппаИнформацияОСканированииВДругойФорме.Видимость = Ложь;
			Если ЭтоДокументПриобретения Тогда
				ЗаголовокСсылки = НСтр("ru = 'Промежуточные результаты проверки табачной продукции'");
			Иначе
				ЗаголовокСсылки = НСтр("ru = 'Промежуточные результаты подбора табачной продукции'");
			КонецЕсли;
		КонецЕсли;
	
		УстановитьТолькоПросмотрЭлементов(
			Форма,
			ПараметрыИнтеграцииФормыПроверки,
			Истина);
		
	ИначеЕсли СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.Завершено
		И ПараметрыИнтеграцииФормыПроверки.ИспользоватьСтатусПроверкаЗавершена Тогда
		
		ЭлементыФормы.ГруппаИнформацияОСканированииВДругойФорме.Видимость = Ложь;
		Если ЭтоДокументПриобретения Тогда
			ЗаголовокСсылки = НСтр("ru = 'Результаты проверки табачной продукции'");
		Иначе
			ЗаголовокСсылки = НСтр("ru = 'Результаты подбора табачной продукции'");
		КонецЕсли;
		
		УстановитьТолькоПросмотрЭлементов(
			Форма,
			ПараметрыИнтеграцииФормыПроверки,
			Ложь);
		
	ИначеЕсли СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.НеВыполнялось
		ИЛИ СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.Завершено Тогда
	
		Если ЕстьПравоИзменение Тогда
			ЭлементыФормы.ГруппаИнформацияОСканированииВДругойФорме.Видимость = Ложь;
			Если ЭтоДокументПриобретения Тогда
				ЗаголовокСсылки = НСтр("ru = 'Проверить поступившую табачную продукцию'");
			Иначе
				ЗаголовокСсылки = НСтр("ru = 'Подобрать и проверить табачную продукцию'");
			КонецЕсли;
		Иначе
			ЭлементыФормы.ГруппаСканированиеИПроверкаТабачнойПродукции.Видимость = Ложь;
		КонецЕсли;
		
		УстановитьТолькоПросмотрЭлементов(
			Форма,
			ПараметрыИнтеграцииФормыПроверки,
			Ложь);
	
	Иначе
		
		ЭлементыФормы.ГруппаСканированиеИПроверкаТабачнойПродукции.Видимость = Ложь;
		
		УстановитьТолькоПросмотрЭлементов(
			Форма,
			ПараметрыИнтеграцииФормыПроверки,
			Ложь);
		
	КонецЕсли;
	
	Если ПараметрыИнтеграцииФормыПроверки.ИспользоватьСтатусПроверкаЗавершена Тогда
		ЭлементыФормы.ВозобновитьПроверкуПродукцииМОТП.Доступность = СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.Завершено;
	КонецЕсли;
	
	Если ЭлементыФормы.ГруппаСканированиеИПроверкаТабачнойПродукции.Видимость Тогда
		ЭлементыФормы.ДекорацияСканироватьПроверитьТовары.Заголовок = Новый ФорматированнаяСтрока(
			ЗаголовокСсылки, ,
			ЦветаСтиля.ЦветГиперссылкиГосИС, ,
			ПроверкаИПодборПродукцииМОТПКлиентСервер.НавигационнаяСсылкаОткрытьФормуПроверкиИПодбора());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Фиксирует результаты сканирования в форме проверки и подбора в документе, из которого она была вызвана.
// 
// Параметры:
// 	ПараметрыОкончанияСканирования - Структура - содержит следующие поля:
//  СоздаватьАктОРасхождениях       - Булево - признак, того что требуется создания документа "Акт о расхождениях".
//  СозданныйАктОРасхождениях       - ДокументСсылка - в данный параметр требуется поместить созданный документ "Акт о расхождениях".
//  ПроверяемыйДокумент             - ДокументСсылка - документ, для которого выполнялась проверка и подбор.
//  ТаблицаШтрихкодовВерхнегоУровня - ТаблицаЗначений - содержит следующие колонки:
//   ШтрихкодУпаковки - СправочникСсылка.ШтрихкодыУпаковокТоваров 
//   Штрихкод - Строка
//  ТаблицаПодобраннойПровереннойПродукции - ТаблицаЗначений - содержит следующие колонки:
//   Номенклатура        - ОпределяемыйТип.Номекнлатура
//   Характеристика      - ОпределяемыйТип.ХарактеристикаНоменклатуры
//   Серия               - ОпределяемыйТип.СерияНоменклатуры
//   Количество          - Число - количество по документу
//   КоличествоПодобрано - Число - фактическое количество по результатам проверки и подбора
//	
Процедура ЗафиксироватьРезультатПроверкиИПодбора(ПараметрыОкончанияСканирования) Экспорт
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияСканирования);
	
КонецПроцедуры

// Возвращает сформированный ранее Акт о расхождениях для переданного документа.
// 
// Параметры:
// 	Документ - ДокументСсылка - ссылка на документ, для которого необходимо получить Акт о расхождениях:
//	
Функция СформированныйАктОРасхождениях(Документ) Экспорт
	
	АктОРасхождениях = Неопределено;
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.ПолучитьСформированныйАктОРасхождениях(Документ, АктОРасхождениях);
	
	Возврат АктОРасхождениях;
	
КонецФункции

// Возвращает для переданного документа таблицу его товаров, являющихся табачной продукцией.
// 
// Параметры:
//	* Контекст - УправляемаяФорма, ДокументСсылка - документ, табачную продукцию которого необходимо получить.
// ВозвращаемоеЗначение:
//	* ТаблицаТабачнойПродукции - ТаблицаЗначений - таблица с табачной продукцией переданного документа:
//		* GTIN           - ОпределяемыйТип.GTIN                       - штрихкод
//		* Номенклатура   - ОпределяемыйТип.Номенклатура               - номенклатура
//		* Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика
//		* Серия          - ОпределяемыйТип.СерияНоменклатуры          - серия
//		* Количество     - Число                                      - количество
//
Функция ТаблицаТабачнойПродукцииДокумента(Контекст) Экспорт
	
	ТаблицаТабачнойПродукции = Новый ТаблицаЗначений();
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.ПриОпределенииТабачнойПродукцииДокумента(Контекст, ТаблицаТабачнойПродукции);
	
	Возврат ТаблицаТабачнойПродукции;
	
КонецФункции

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм

// Пересчитывает хеш-суммы всех упаковок формы и проверяется необходимость перемаркировки.
//
// Параметры:
//	Форма - УправляемаяФорма - форма проверки и подбора маркируемой продкуции.
//
Процедура ПересчитатьХешСуммыВсехУпаковок(Форма) Экспорт

	Если НЕ Форма.ПроверятьНеобходимостьПеремаркировки Тогда
		Возврат;
	КонецЕсли;

	Если Форма.ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияТабачнойПродукцииМОТП.Пачки Тогда
		Форма.КоличествоУпаковокКоторыеНеобходимоПеремаркировать = 0;
		ПроверкаИПодборПродукцииМОТПКлиентСервер.ОтобразитьИнформациюОНеобходимостиПеремаркировки(Форма);
		Возврат;
	КонецЕсли;
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из Форма.ДеревоМаркированнойПродукции.ПолучитьЭлементы() Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки)
		 Или СтрокаДерева.ТипУпаковки = Перечисления.ПрочиеЗоныПересчетаТабачнойПродукцииМОТП.БлокиБезКоробки Тогда
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСумм, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм);
	
	ПроверкаИПодборПродукцииМОТПКлиентСервер.ПроверитьНеобходимостьПеремаркировки(Форма, ТаблицаПеремаркировки, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОкончаниеПроверкиИПодбора

// Формирует пустую таблицу о штриховых кодах верхнего уровня, для дальнейшего наполнения информацией из форрмы проверки и подбора.
// 
// Параметры:
// Возвращаемое значение:
//  ТаблицаЗначений - Описание:
//   ШтрихкодУпаковки - СправочникСсылка.ШтрихкодыУпаковокТоваров 
//   Штрихкод - Строка 
//
Функция ПустаяТаблицаШтрихкодовВерхнегоУровня() Экспорт
	
	ТаблицаШтрихкодовВерхнегоУровня = Новый ТаблицаЗначений;
	
	ТаблицаШтрихкодовВерхнегоУровня.Колонки.Добавить("ШтрихкодУпаковки", Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров"));
	ТаблицаШтрихкодовВерхнегоУровня.Колонки.Добавить("Штрихкод", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	
	Возврат ТаблицаШтрихкодовВерхнегоУровня;
	
КонецФункции

// Формирует пустую таблицу информации о проверенных и под, сформированную в форме проверки и подбора.
// 
// Параметры:
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * Номенклатура        - ОпределяемыеТипы.Номенклатура
// * Характеристика      - ОпределяемыеТипы.ХарактеристикаНоменклатуры
// * Серия               - ОпределяемыеТипы.СерияНоменклатуры
// * Количество          - Число
// * КоличествоПодобрано - Число 
Функция ПустаяТаблицаПодобраннойПровереннойПродукции() Экспорт
	
	ТаблицаПодобраннойПровереннойПродукции = Новый ТаблицаЗначений;
	
	ТаблицаПодобраннойПровереннойПродукции.Колонки.Добавить("Номенклатура",        Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаПодобраннойПровереннойПродукции.Колонки.Добавить("Характеристика",      Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ТаблицаПодобраннойПровереннойПродукции.Колонки.Добавить("Серия",               Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ТаблицаПодобраннойПровереннойПродукции.Колонки.Добавить("Количество",          ОбщегоНазначения.ОписаниеТипаЧисло(15) );
	ТаблицаПодобраннойПровереннойПродукции.Колонки.Добавить("КоличествоПодобрано", ОбщегоНазначения.ОписаниеТипаЧисло(15));
	
	Возврат ТаблицаПодобраннойПровереннойПродукции;
	
КонецФункции 

#КонецОбласти

#Область СерииНоменклатуры

// Возвращает параметры указания серий для товаров, указанных в форме.
//
// Параметры:
//		Форма	- УправляемаяФорма - форма с товарами, для которой необходимо определить параметры указания серий.
//
// Возвращаемое значение:
//		Структура - состав полей структуры задается в процедуре ПроверкаИПодборПродукцииМОТППереопределяемый.ЗаполнитьПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Форма) Экспорт
	
	ПараметрыУказанияСерий = Новый Структура();
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", Ложь);
	
	Если Форма.ИспользоватьСерииНоменклатуры Тогда
		ПроверкаИПодборПродукцииМОТППереопределяемый.ЗаполнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий);
	КонецЕсли;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	0 КАК СтатусУказанияСерий
	|ИЗ
	|	&Товары КАК Товары
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.СформироватьТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий, ТекстЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ЕстьПравоДобавлениеСерий() Экспорт
	
	ПравоДобавлениеСерий = Ложь;
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий);
	
	Возврат ПравоДобавлениеСерий;
	
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ВстраиваниеФормыПроверкиИПодбора

Функция СуществуютЭлементыПроверкиИПодбораПродукцииМОТП(Форма)
	
	ЭлементыФормы = Форма.Элементы;
	
	Возврат ЭлементыФормы.Найти("ГруппаСканированиеИПроверкаТабачнойПродукции") <> Неопределено;
	
КонецФункции

Процедура ДобавитьУдалитьЭлементыПроверкиИПодбораПриНеобходимости(Форма, ПараметрыИнтеграцииФормыПроверки, ТолькоДобавить = Ложь)
	
	Объект = Форма[ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект];
	ТабличнаяЧастьТовары = Объект[ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиТовары];
	
	ОтображатьВИнтерфейсе = ПолучитьФункциональнуюОпцию("ВестиУчетТабачнойПродукцииМОТП")
		И (ПараметрыИнтеграцииФормыПроверки.ИспользоватьБезТабачнойПродукции
			Или ЕстьТабачнаяПродукцияВКоллекции(ТабличнаяЧастьТовары));
	
	Если ТолькоДобавить Тогда
		ДобавитьКешПараметровИнтеграции(Форма, ПараметрыИнтеграцииФормыПроверки);
		ДобавитьЭлементыСтатусаПроверки(Форма, ПараметрыИнтеграцииФормыПроверки);
		Если ОтображатьВИнтерфейсе Тогда
			ДобавитьЭлементыПроверкиИПодбора(Форма, ПараметрыИнтеграцииФормыПроверки);
		КонецЕсли;
	ИначеЕсли СуществуютЭлементыПроверкиИПодбораПродукцииМОТП(Форма) Тогда
		Если Не ОтображатьВИнтерфейсе Тогда
			УдалитьЭлементыПроверкиИПодбора(Форма);
		КонецЕсли;
	ИначеЕсли ОтображатьВИнтерфейсе Тогда
		ДобавитьЭлементыПроверкиИПодбора(Форма, ПараметрыИнтеграцииФормыПроверки);
	КонецЕсли;
	УправлениеЭлементамиОткрытияФормыПроверкиИПодбора(Форма);
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма);
	
КонецПроцедуры

Процедура ДобавитьКешПараметровИнтеграции(Форма, ПараметрыИнтеграцииФормыПроверки)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыИнтеграцииФормыПроверкиГосИС") Тогда
		ПараметрыИнтеграцииФормыПроверкиГосИС = Новый Структура(Форма.ПараметрыИнтеграцииФормыПроверкиГосИС);
		ПараметрыИнтеграцииФормыПроверкиГосИС.Вставить("МОТП", ПараметрыИнтеграцииФормыПроверки);
	Иначе
		ДобавляемыеРеквизиты = Новый Массив;
		КешНастроек = Новый РеквизитФормы(
			"ПараметрыИнтеграцииФормыПроверкиГосИС",
			Новый ОписаниеТипов);
		ДобавляемыеРеквизиты.Добавить(КешНастроек);
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		ПараметрыИнтеграцииФормыПроверкиГосИС = Новый Структура("МОТП", ПараметрыИнтеграцииФормыПроверки);
	КонецЕсли;
	Форма.ПараметрыИнтеграцииФормыПроверкиГосИС = Новый ФиксированнаяСтруктура(ПараметрыИнтеграцииФормыПроверкиГосИС);
	
КонецПроцедуры


Процедура ДобавитьЭлементыПроверкиИПодбора(Форма, ПараметрыИнтеграцииФормыПроверки)
	
	Если СуществуютЭлементыПроверкиИПодбораПродукцииМОТП(Форма) Тогда
		Возврат;
	ИначеЕсли НЕ ПравоДоступа("Использование", Метаданные.Обработки.ПроверкаИПодборТабачнойПродукцииМОТП) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавляемыеРеквизиты = Новый Массив();

	Если ПараметрыИнтеграцииФормыПроверки.ИспользоватьСтатусПроверкиПодбораДокумента
		И НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СтатусПроверкиГосИС") Тогда
		РеквизитСтатус = Новый РеквизитФормы(
			"СтатусПроверкиГосИС",
			Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыПроверкиИПодбораИС"));
		ДобавляемыеРеквизиты.Добавить(РеквизитСтатус);
	КонецЕсли;

	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
	ЭлементыФормы = Форма.Элементы;
	
	ГруппаСканированиеИПроверка = ЭлементыФормы.Добавить(
		"ГруппаСканированиеИПроверкаТабачнойПродукции",
		Тип("ГруппаФормы"),
		ЭлементыФормы[ПараметрыИнтеграцииФормыПроверки.ИмяРодительскойГруппыФормы]);
	
	ЭлементыФормы.Переместить(ГруппаСканированиеИПроверка,
		ЭлементыФормы[ПараметрыИнтеграцииФормыПроверки.ИмяРодительскойГруппыФормы],
		ЭлементыФормы[ПараметрыИнтеграцииФормыПроверки.ИмяПоследующегоЭлементаФормы]);
	
	ГруппаСканированиеИПроверка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСканированиеИПроверка.ОтображатьЗаголовок = Ложь;
	ГруппаСканированиеИПроверка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаСканированиеИПроверка.РастягиватьПоВертикали = Ложь;
	ГруппаСканированиеИПроверка.РастягиватьПоГоризонтали = Истина;
	
	ДекорацияСканироватьПроверить = ЭлементыФормы.Добавить("ДекорацияСканироватьПроверитьТовары",
		Тип("ДекорацияФормы"), ГруппаСканированиеИПроверка);
	
	ДекорацияСканироватьПроверить.Вид = ВидДекорацииФормы.Надпись;
	ДекорацияСканироватьПроверить.УстановитьДействие("ОбработкаНавигационнойСсылки",
		"Подключаемый_ДекорацияСканироватьПроверитьТоварыОбработкаНавигационнойСсылки");
	
	ГруппаИнформацияОСканировании = ЭлементыФормы.Добавить("ГруппаИнформацияОСканированииВДругойФорме",
		Тип("ГруппаФормы"), ГруппаСканированиеИПроверка);
	
	ГруппаИнформацияОСканировании.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаИнформацияОСканировании.ОтображатьЗаголовок = Ложь;
	ГруппаИнформацияОСканировании.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаИнформацияОСканировании.РастягиватьПоВертикали = Ложь;
	ГруппаИнформацияОСканировании.РастягиватьПоГоризонтали = Истина;
	
	КартинкаИнформацияОСканировании = ЭлементыФормы.Добавить("КартинкаИнформацияОСканированииВДругойФорме",
		Тип("ДекорацияФормы"), ГруппаИнформацияОСканировании);
	
	КартинкаИнформацияОСканировании.Вид = ВидДекорацииФормы.Картинка;
	КартинкаИнформацияОСканировании.Картинка = БиблиотекаКартинок.ИнформацияГосИС;
	
	НадписьИнформацияОСканировании = ЭлементыФормы.Добавить("НадписьИнформацияОСканированииВДругойФорме",
		Тип("ДекорацияФормы"), ГруппаИнформацияОСканировании);
	
	НадписьИнформацияОСканировании.Вид = ВидДекорацииФормы.Надпись;
	НадписьИнформацияОСканировании.АвтоМаксимальнаяШирина = Ложь;
	Если ПараметрыИнтеграцииФормыПроверки.БлокироватьТабличнуюЧастьТоварыПриПроверке Тогда
		НадписьИнформацияОСканировании.Заголовок = ПараметрыИнтеграцииФормыПроверки.ИнформацияДляПользователяОБлокировке;
	Иначе
		НадписьИнформацияОСканировании.Заголовок = ПараметрыИнтеграцииФормыПроверки.ИнформацияДляПользователяОПроверке;
	КонецЕсли;
	
	Если ПараметрыИнтеграцииФормыПроверки.ИспользоватьСтатусПроверкаЗавершена Тогда
		
		ИмяКомандыВозобновитьПроверку = "ВозобновитьПроверкуПродукцииМОТП";
		КомандаФормы = Форма.Команды.Добавить(ИмяКомандыВозобновитьПроверку);
		КомандаФормы.Действие  = "Подключаемый_ВозобновитьПроверкуПродукцииМОТП";
		КомандаФормы.Заголовок = НСтр("ru = 'Возобновить проверку и подбор табачной продукции'");
		
		Кнопка = ЭлементыФормы.Добавить(
			ИмяКомандыВозобновитьПроверку,
			Тип("КнопкаФормы"),
			ЭлементыФормы[ПараметрыИнтеграцииФормыПроверки.ИмяЭлементаФормыТовары].КоманднаяПанель);
		Кнопка.ИмяКоманды = ИмяКомандыВозобновитьПроверку;
		Кнопка.ТолькоВоВсехДействиях = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЭлементыСтатусаПроверки(Форма, ПараметрыИнтеграцииФормыПроверки)
	
	Если НЕ ПараметрыИнтеграцииФормыПроверки.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
		Возврат;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ДанныеШтрихкодовУпаковокГосИС") Тогда
		Возврат;
	КонецЕсли;
	
	ДобавляемыеРеквизиты = Новый Массив;

	//Реквизиты
	ПутьКРеквизиту = ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект+"."+ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиТовары;
	//общая
	Колонка = Новый РеквизитФормы(
		"МаркируемаяПродукцияГосИС",
		Новый ОписаниеТипов("Булево"),
		ПутьКРеквизиту,
		НСтр("ru = 'Маркируемая продукция'"));
	ДобавляемыеРеквизиты.Добавить(Колонка);
		Колонка = Новый РеквизитФормы(
		"СтатусПроверкиГосИС",
		Новый ОписаниеТипов("Число"),
		ПутьКРеквизиту,
		НСтр("ru = 'Статус проверки подбора'"));
	ДобавляемыеРеквизиты.Добавить(Колонка);
	//кеш штрихкодов упаковок
	Таблица = Новый РеквизитФормы(
		"ДанныеШтрихкодовУпаковокГосИС",
		Новый ОписаниеТипов("ТаблицаЗначений"));
	ДобавляемыеРеквизиты.Добавить(Таблица);
	Колонка = Новый РеквизитФормы(
		"Номенклатура",
		Метаданные.ОпределяемыеТипы.Номенклатура.Тип,
		"ДанныеШтрихкодовУпаковокГосИС");
	ДобавляемыеРеквизиты.Добавить(Колонка);
	Колонка = Новый РеквизитФормы(
		"Характеристика",
		Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип,
		"ДанныеШтрихкодовУпаковокГосИС");
	ДобавляемыеРеквизиты.Добавить(Колонка);
	Колонка = Новый РеквизитФормы(
		"Серия",
		Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип,
		"ДанныеШтрихкодовУпаковокГосИС");
	ДобавляемыеРеквизиты.Добавить(Колонка);
	Колонка = Новый РеквизитФормы(
		"Количество",
		Новый ОписаниеТипов("Число"),
		"ДанныеШтрихкодовУпаковокГосИС");
	ДобавляемыеРеквизиты.Добавить(Колонка);
	Колонка = Новый РеквизитФормы(
		"ШтрихкодыУпаковок",
		Новый ОписаниеТипов("СписокЗначений"),
		"ДанныеШтрихкодовУпаковокГосИС");
	//кеш настроек
	ДобавляемыеРеквизиты.Добавить(Колонка);
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	//Интерфейс
	ПутьКРеквизиту = ПутьКРеквизиту + ".СтатусПроверкиГосИС";
	КолонкаИнтерфейса = Форма.Элементы.Вставить(
	СтрШаблон("%1СтатусПроверкиГосИС",ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиТовары),
	Тип("ПолеФормы"),
	Форма.Элементы[ПараметрыИнтеграцииФормыПроверки.ИмяЭлементаФормыТовары],
		Форма.Элементы[ПараметрыИнтеграцииФормыПроверки.ИмяСледующейКолонки]);
	КолонкаИнтерфейса.ПутьКДанным = ПутьКРеквизиту;
	КолонкаИнтерфейса.Вид = ВидПоляФормы.ПолеКартинки;
	КолонкаИнтерфейса.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КолонкаИнтерфейса.КартинкаЗначений = БиблиотекаКартинок.МаркируемаяАлкогольнаяПродукцияТЧ;
	КолонкаИнтерфейса.КартинкаШапки = БиблиотекаКартинок.МаркируемаяАлкогольнаяПродукцияШапка;
	
КонецПроцедуры

Процедура УдалитьЭлементыПроверкиИПодбора(Форма)
	
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементыФормы.Удалить(ЭлементыФормы.ГруппаСканированиеИПроверкаТабачнойПродукции);
	
	Если ЭлементыФормы.Найти("ВозобновитьПроверкуПродукцииМОТП") <> Неопределено Тогда
		
		Форма.Команды.Удалить(Форма.Команды["ВозобновитьПроверкуПродукцииМОТП"]);
		ЭлементыФормы.Удалить(ЭлементыФормы.ВозобновитьПроверкуПродукцииМОТП);
		
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьТолькоПросмотрЭлементов(Форма, ПараметрыИнтеграцииФормыПроверки, ЗаблокироватьДляРедактирования)
	
	Если НЕ ПараметрыИнтеграцииФормыПроверки.БлокироватьТабличнуюЧастьТоварыПриПроверке Тогда
		Возврат;
	КонецЕсли;

	БлокируемыеЭлементы = ПараметрыИнтеграцииФормыПроверки.БлокируемыеЭлементы;
	
	ЭлементТабличнаяЧасть = БлокируемыеЭлементы.Найти(ПараметрыИнтеграцииФормыПроверки.ИмяЭлементаФормыТовары);
	Если ЭлементТабличнаяЧасть <> Неопределено Тогда
		Форма.Элементы[ПараметрыИнтеграцииФормыПроверки.ИмяЭлементаФормыТовары].ИзменятьСоставСтрок = НЕ ЗаблокироватьДляРедактирования;
		БлокируемыеЭлементы.Удалить(ЭлементТабличнаяЧасть);
	КонецЕсли;
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.УстановитьТолькоПросмотрЭлементов(
		Форма,
		БлокируемыеЭлементы,
		ЗаблокироватьДляРедактирования);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСоСтатусамиПроверкиПодбораСтрок

Процедура ЗаполнитьКешШтрихкодовУпаковок(Форма) Экспорт
	
	ПараметрыИнтеграцииФормыПроверки = Форма.ПараметрыИнтеграцииФормыПроверкиГосИС.МОТП;
	
	Если НЕ ПараметрыИнтеграцииФормыПроверки.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
		Возврат;
	КонецЕсли;
	Форма.ДанныеШтрихкодовУпаковокГосИС.Очистить();
	ДанныеШтрихкодовУпаковокГосИС = Форма.ДанныеШтрихкодовУпаковокГосИС.Выгрузить();
	ДанныеШтрихкодовУпаковокГосИС.Индексы.Добавить("Номенклатура,Характеристика,Серия");
	
	Объект = ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект;
	ШтрихкодыУпаковок = Форма[Объект][ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиШтрихкодыУпаковок].Выгрузить();
	ШтрихкодыУпаковок = ШтрихкодыУпаковок.ВыгрузитьКолонку("ШтрихкодУпаковки");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыУпаковок.Ссылка КАК Штрихкод,
	|	ШтрихкодыУпаковок.Номенклатура,
	|	ШтрихкодыУпаковок.Характеристика,
	|	ШтрихкодыУпаковок.Серия,
	|	ШтрихкодыУпаковок.Количество
	|ИЗ
	|	Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковок
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров.ВложенныеШтрихкоды КАК ЕстьВложенныеШтрихкоды
	|		ПО ЕстьВложенныеШтрихкоды.Ссылка = ШтрихкодыУпаковок.Ссылка
	|	ГДЕ ШтрихкодыУпаковок.Ссылка В (&ШтрихкодУпаковки)
	|	И ЕстьВложенныеШтрихкоды.Ссылка ЕСТЬ NULL
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ШтрихкодыУпаковок.Ссылка КАК Родитель,
	|	ШтрихкодыУпаковок.Штрихкод
	|ИЗ
	|	Справочник.ШтрихкодыУпаковокТоваров.ВложенныеШтрихкоды КАК ШтрихкодыУпаковок
	|	ГДЕ ШтрихкодыУпаковок.Ссылка В (&ШтрихкодУпаковки)";
	
	
	КешВложенности = Новый Соответствие;
	СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Серия");
	
	ОбходТаблицы = Истина;
	
	Пока ОбходТаблицы Цикл
		
		Запрос.УстановитьПараметр("ШтрихкодУпаковки", ШтрихкодыУпаковок);
		МассивРезультатов = Запрос.ВыполнитьПакет();
		СоставУпаковки = МассивРезультатов[0].Выбрать();
		ВложенныеЗаписи = МассивРезультатов[1].Выбрать();
		НуженОбходДочерних = ВложенныеЗаписи.Количество();
	
		Пока СоставУпаковки.Следующий() Цикл
			ИсходныйШтрихкод = КешВложенности.Получить(СоставУпаковки.Штрихкод);
			Если ИсходныйШтрихкод = Неопределено Тогда
				ИсходныйШтрихкод = СоставУпаковки.Штрихкод;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СоставУпаковки);
			СтрокиКеша = ДанныеШтрихкодовУпаковокГосИС.НайтиСтроки(СтруктураПоиска);
			Если СтрокиКеша.Количество() Тогда
				СтрокиКеша[0].Количество = СтрокиКеша[0].Количество + ?(СоставУпаковки.Количество=0,1,СоставУпаковки.Количество);
				СтрокиКеша[0].ШтрихкодыУпаковок.Добавить(ИсходныйШтрихкод);
			Иначе
				НоваяСтрока = ДанныеШтрихкодовУпаковокГосИС.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СоставУпаковки);
				Если (НоваяСтрока.Количество=0) Тогда
					НоваяСтрока.Количество=1;
				КонецЕсли;
				НоваяСтрока.ШтрихкодыУпаковок = Новый СписокЗначений;
				НоваяСтрока.ШтрихкодыУпаковок.Добавить(ИсходныйШтрихкод);
			КонецЕсли;
		КонецЦикла;
		
		Если НуженОбходДочерних Тогда
			ШтрихкодыУпаковок = Новый Массив;
			Пока ВложенныеЗаписи.Следующий() Цикл
				ИсходныйШтрихкод = КешВложенности.Получить(ВложенныеЗаписи.Родитель);
				Если ИсходныйШтрихкод = Неопределено Тогда
					ИсходныйШтрихкод = ВложенныеЗаписи.Родитель;
				КонецЕсли;
				КешВложенности.Вставить(ВложенныеЗаписи.Штрихкод, ИсходныйШтрихкод);
				ШтрихкодыУпаковок.Добавить(ВложенныеЗаписи.Штрихкод);
			КонецЦикла;
		Иначе
			ОбходТаблицы = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Форма.ДанныеШтрихкодовУпаковокГосИС.Загрузить(ДанныеШтрихкодовУпаковокГосИС);
	
КонецПроцедуры

#КонецОбласти

Функция ЕстьТабачнаяПродукцияВКоллекции(ТабличнаяЧастьТовары)
	
	ЕстьТабачнаяПродукция = Ложь;
	
	ПроверкаИПодборПродукцииМОТППереопределяемый.ЕстьТабачнаяПродукцияВКоллекции(ТабличнаяЧастьТовары, ЕстьТабачнаяПродукция);
	
	Возврат ЕстьТабачнаяПродукция;
	
КонецФункции

Функция СтатусПроверкиИПодбораДокумента(Документ)
	
	СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.НеВыполнялось;

	Если ЗначениеЗаполнено(Документ) Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Документ", Документ);
		Запрос.Текст = "
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтатусыПроверкиИПодбораДокументовМОТП.СтатусПроверкиИПодбора КАК СтатусПроверкиИПодбора
		|ИЗ
		|	РегистрСведений.СтатусыПроверкиИПодбораДокументовМОТП КАК СтатусыПроверкиИПодбораДокументовМОТП
		|ГДЕ
		|	СтатусыПроверкиИПодбораДокументовМОТП.Документ = &Документ
		|";
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			СтатусПроверкиИПодбора = Выборка.СтатусПроверкиИПодбора;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтатусПроверкиИПодбора;
	
КонецФункции

#КонецОбласти