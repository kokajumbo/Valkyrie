
#Область ПрограммныйИнтерфейс

// Функция получает параметры устройства.
//
Функция ПолучитьПараметрыУстройства(Устройство, СообщениеОбОшибке = Неопределено) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОборудованиеПоОрганизациям.УзелОбмена КАК УзелИнформационнойБазы,
	|	ОборудованиеПоОрганизациям.Организация КАК Организация,
	|	ОборудованиеПоОрганизациям.Склад КАК Склад,
	|	Склады.ТипЦенРозничнойТорговли КАК ТипЦен
	|ИЗ
	|	РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ОборудованиеПоОрганизациям.Склад = Склады.Ссылка
	|ГДЕ
	|	ОборудованиеПоОрганизациям.Оборудование = &Устройство
	|	И НЕ ОборудованиеПоОрганизациям.УзелОбмена.Ссылка ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Устройство", Устройство);
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	Если Не Выборка.Следующий() Тогда
		СообщениеОбОшибке = НСтр("ru = 'Оборудование не настроено. Выполните настройку в разделе ""Администрирование""'");
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("УзелИнформационнойБазы",         Выборка.УзелИнформационнойБазы);
	ВозвращаемоеЗначение.Вставить("Склад",                          Выборка.Склад);
	ВозвращаемоеЗначение.Вставить("Организация",                    Выборка.Организация);
	ВозвращаемоеЗначение.Вставить("ТипЦен",                         Выборка.ТипЦен);
	
	Возврат ВозвращаемоеЗначение;
КонецФункции

// Процедура вызывается при очистке товаров в устройстве.
// Выполняет запись информации в узел плана обмена.
//
// Параметры:
//  Устройство       - <СправочникСсылка.ПодключаемоеОборудование>
//  ВыполненоУспешно - <Булево> Признак успешного выполнения операции.
//
// Возвращаемое значение:
//  Нет
//
Процедура ПриОчисткеТоваровВУстройстве(Устройство, ВыполненоУспешно = Истина) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыУстройства = ПолучитьПараметрыУстройства(Устройство);
	Если ПараметрыУстройства = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелОбъект = ПараметрыУстройства.УзелИнформационнойБазы.ПолучитьОбъект();
	
	УзелОбъект.ДатаВыгрузки      = ТекущаяДатаСеанса();
	УзелОбъект.ВыгрузкаВыполнена = ВыполненоУспешно;
	УзелОбъект.Записать();
	
	ПараметрыОбъекта = Новый Структура("УзелОбмена, Склад", УзелОбъект.Ссылка, ПараметрыУстройства.Склад);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
	
	ДлительныеОперации.ВыполнитьВФоне("ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.ОбновитьРегистрКодовНоменклатуры",
			ПараметрыОбъекта, ПараметрыВыполнения);
КонецПроцедуры

// Процедура вызывается при выгрузке товаров в устройство.
// Выполняет запись информации в узел плана обмена.
//
// Параметры:
//  Устройство       - <СправочникСсылка.ПодключаемоеОборудование>
//  ВыполненоУспешно - <Булево> Признак успешного выполнения операции.
//
// Возвращаемое значение:
//  Нет
//
Процедура ПриВыгрузкеТоваровВУстройство(Устройство) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыУстройства = ПолучитьПараметрыУстройства(Устройство);
	Если ПараметрыУстройства = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ПланыОбмена.УдалитьРегистрациюИзменений(ПараметрыУстройства.УзелИнформационнойБазы);
	
	УзелОбъект = ПараметрыУстройства.УзелИнформационнойБазы.ПолучитьОбъект();
	УзелОбъект.ДатаВыгрузки      = ТекущаяДата();
	УзелОбъект.ВыгрузкаВыполнена = Истина;
	УзелОбъект.Записать();
	
КонецПроцедуры

Функция СведенияОСпискеНоменклатуры(СписокКодов)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокКодов", СписокКодов);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СправочникНоменклатура.Ссылка КАК Ссылка,
	|	СправочникНоменклатура.Услуга КАК Услуга,
	|	СправочникНоменклатура.ВидСтавкиНДС КАК ВидСтавкиНДС,
	|	СправочникНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код
	|ИЗ
	|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	КодыТоваровПодключаемогоОборудованияOffline.Код В(&СписокКодов)";
	Результат = Новый Соответствие;
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Для каждого СтрокаРезультата Из РезультатЗапроса Цикл
		Результат.Вставить(СтрокаРезультата.Код, ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаРезультата));
	КонецЦикла; 
	
	Возврат Результат;
КонецФункции

// Процедура вызывается при загрузке отчета о розничных продажах с устройства.
// Выполняет запись информации в узел плана обмена. Создает отчет о розничных продажах.
//
// Параметры:
//  Устройство       - <СправочникСсылка.ПодключаемоеОборудование>
//  ВыполненоУспешно - <Булево> Признак успешного выполнения операции.
//
// Возвращаемое значение:
//  Нет
//
Функция ПриЗагрузкеОтчетаОРозничныхПродажах(Устройство, ДанныеОПродажах, Отказ, СообщениеОбОшибке) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоответствиеСтавкиНДС = Новый Соответствие;
	СоответствиеСтавкиНДС.Вставить(МенеджерОфлайнОборудования.ПолучитьСтавкуБезНДС(), Перечисления.СтавкиНДС.БезНДС);
	СоответствиеСтавкиНДС.Вставить(МенеджерОфлайнОборудования.ПолучитьСтавкуНДС0(), Перечисления.СтавкиНДС.НДС0);
	СоответствиеСтавкиНДС.Вставить(МенеджерОфлайнОборудования.ПолучитьСтавкуНДС10(), Перечисления.СтавкиНДС.НДС10);
	СоответствиеСтавкиНДС.Вставить(МенеджерОфлайнОборудования.ПолучитьСтавкуНДС18(), Перечисления.СтавкиНДС.НДС18);
	СоответствиеСтавкиНДС.Вставить(МенеджерОфлайнОборудования.ПолучитьСтавкуНДС20(), Перечисления.СтавкиНДС.НДС20);
	
	МассивСозданныхДокументов = Новый Массив;
	
	ПараметрыУстройства = ПолучитьПараметрыУстройства(Устройство, СообщениеОбОшибке);
	Если ПараметрыУстройства = Неопределено Тогда
		Отказ = Истина;
		
		Возврат Неопределено;
	КонецЕсли; 
	
	ИдентификаторыДокументовПоСменам = Новый Соответствие;
	
	ТаблицаТоваров = НовыйТаблицаТоваров();
	ТаблицаОплат   = НовыйТаблицаОплат();
	
	ТаблицаВидовОплат = ПолучитьТаблицуВидовОплат(Устройство);
	
	Для Каждого ОтчетОПродажах Из ДанныеОПродажах Цикл
		
		// Для формирования ОРП используем данные только закрытых кассовых смен
		Если ЗначениеЗаполнено(ОтчетОПродажах.СтатусСмены) И ОтчетОПродажах.СтатусСмены <> Перечисления.СтатусыКассовойСмены.Закрыта Тогда
			Продолжить;
		КонецЕсли; 
		
		ТаблицаТоваров.Очистить();
		ТаблицаОплат.Очистить();
		
		Для Каждого ЧекиПродажи Из ОтчетОПродажах.Чеки Цикл
			// Перебираем товары из каждого чека
			Для Каждого СтрокаТЧ Из ЧекиПродажи.Товары Цикл
				Если ЧекиПродажи.ТипРасчета <> Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств 
					И ЧекиПродажи.ТипРасчета <> Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств Тогда
					Продолжить;
				КонецЕсли; 
				
				НоменклатураСсылка = ?(
					ЗначениеЗаполнено(СтрокаТЧ.УникальныйИдентификаторНоменклатуры), 
					Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаТЧ.УникальныйИдентификаторНоменклатуры)), 
					Справочники.Номенклатура.ПустаяСсылка());
					
				НоваяСтрока = ТаблицаТоваров.Добавить();
				НоваяСтрока.ИдентификаторДокумента           = ЧекиПродажи.УникальныйИдентификатор;
				НоваяСтрока.ИдентификаторСвязанногоДокумента = ЧекиПродажи.УникальныйИдентификаторСвязанногоДокументаККМ;
				НоваяСтрока.ЭтоВозврат                       = (ЧекиПродажи.ТипРасчета =  Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств);
				НоваяСтрока.НомерФискальногоЧека             = Формат(ЧекиПродажи.НомерЧека, "ЧГ=0");
				
				НоваяСтрока.Код                              = СтрокаТЧ.Код;
				НоваяСтрока.Номенклатура                     = НоменклатураСсылка;
				НоваяСтрока.СтавкаНДС                        = СоответствиеСтавкиНДС[СтрокаТЧ.СтавкаНДС];
				НоваяСтрока.Количество                       = СтрокаТЧ.Количество;
				НоваяСтрока.Сумма                            = СтрокаТЧ.Сумма;
			КонецЦикла;
			
			Для каждого СтрокаОплаты Из ЧекиПродажи.Оплаты Цикл
				Если СтрокаОплаты.СуммаЭлектроннойОплаты > 0 Тогда
					ВидОплатыСсылка = ?(
						ЗначениеЗаполнено(СтрокаОплаты.УникальныйИдентификаторВидаЭлектроннойОплаты), 
						Справочники.ВидыОплатОрганизаций.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаОплаты.УникальныйИдентификаторВидаЭлектроннойОплаты)),
						Справочники.ВидыОплатОрганизаций.ПустаяСсылка());
						
					Если ВидОплатыСсылка.Пустая() Тогда
						Если ЗначениеЗаполнено(СтрокаОплаты.КодВидаЭлектроннойОплаты) Тогда
							СтрокаТаблицыОплаты = ТаблицаВидовОплат.Найти(Число(СтрокаОплаты.КодВидаЭлектроннойОплаты), "Код");
						Иначе
							СтрокаТаблицыОплаты = ТаблицаВидовОплат.Найти(Перечисления.ТипыОплат.ПлатежнаяКарта, "ТипОплаты");
						КонецЕсли;
						
						ВидОплатыСсылка = ?(
							СтрокаТаблицыОплаты <> Неопределено, 
							СтрокаТаблицыОплаты.Ссылка, 
							ВидОплатыСсылка);
					КонецЕсли; 
					
					НоваяСтрока = ТаблицаОплат.Добавить();
					НоваяСтрока.ИдентификаторДокумента = ЧекиПродажи.УникальныйИдентификатор;
					НоваяСтрока.ЭтоВозврат             = (ЧекиПродажи.ТипРасчета =  Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств);
					
					НоваяСтрока.ВидОплаты              = ВидОплатыСсылка;
					НоваяСтрока.Сумма                  = СтрокаОплаты.СуммаЭлектроннойОплаты;
				КонецЕсли; 
			КонецЦикла; 
		КонецЦикла;
		
		// Удаляем неподдерживаемый функционал - возвраты услуг.
		СведенияОСпискеНоменклатурыПоКоду   = СведенияОСпискеНоменклатуры(ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Код", Истина));
		СведенияОСпискеНоменклатурыПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
			ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), 
			"Ссылка, Услуга, ВидСтавкиНДС");
		
		ИдентификаторыДокументов    = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "ИдентификаторДокумента", Истина);
		ИтогиПродажПоДокументам     = ТаблицаТоваров.Скопировать(,"ИдентификаторДокумента, Сумма");
		ИтогиОплатПоДокументам      = ТаблицаОплат.Скопировать(,"ИдентификаторДокумента, Сумма");
		
		КоличествоСтрок = ТаблицаТоваров.Количество();
		Для Позиция = 1 По КоличествоСтрок Цикл
			СтрокаТовары = ТаблицаТоваров[КоличествоСтрок - Позиция];
			Если НЕ СтрокаТовары.Номенклатура.Пустая() Тогда
				СведенияОНоменклатуре = СведенияОСпискеНоменклатурыПоСсылке[СтрокаТовары.Номенклатура];
			Иначе
				СведенияОНоменклатуре = СведенияОСпискеНоменклатурыПоКоду[СтрокаТовары.Код];
			КонецЕсли; 
			
			Если СведенияОНоменклатуре = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			
			СтрокаТовары.Номенклатура = СведенияОНоменклатуре.Ссылка;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТовары.СтавкаНДС) Тогда
				СтрокаТовары.СтавкаНДС = Перечисления.СтавкиНДС.СтавкаНДС(СведенияОНоменклатуре.ВидСтавкиНДС, ОтчетОПродажах.ДатаЗакрытияСмены);
			КонецЕсли; 
			
			// Для реализации и возврвта товаров ничего не делаем
			Если НЕ СтрокаТовары.ЭтоВозврат Тогда
				Продолжить;
			КонецЕсли;
			
			ЭтоВозвратТекущейСмены = (ИдентификаторыДокументов.Найти(СтрокаТовары.ИдентификаторСвязанногоДокумента) <> Неопределено);
			
			Если ЭтоВозвратТекущейСмены Тогда
				СтрокаТовары.ДатаРеализации = ОтчетОПродажах.ДатаЗакрытияСмены;
			Иначе
				// Поищем связанный документ в уже загруженных кассовых сменах
				Для каждого ИдентификаторыСмены Из ИдентификаторыДокументовПоСменам Цикл
					Если ИдентификаторыСмены.Значение.Найти(СтрокаТовары.ИдентификаторСвязанногоДокумента) <> Неопределено Тогда
						СтрокаТовары.ДатаРеализации = ИдентификаторыСмены.Ключ;
						Прервать;
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли;
			
			Если НЕ СведенияОНоменклатуре.Услуга Тогда
				Продолжить;
				
			ИначеЕсли ЭтоВозвратТекущейСмены Тогда
				// Возврат услуг текущей смены переносим в ТЧ Товары
				СтрокаТовары.ЭтоВозврат = Ложь;
				
				СтрокаТовары.Количество = -СтрокаТовары.Количество;
				СтрокаТовары.Сумма      = -СтрокаТовары.Сумма;
			Иначе
				// Возврат услуг из предыдущих смен не поддерживаем. Но перед тем как их удалить, удалим их оплаты.
				Отбор = Новый Структура("ИдентификаторДокумента", СтрокаТовары.ИдентификаторДокумента);
				СтрокиОплаты = ТаблицаОплат.НайтиСтроки(Отбор);
				
				ВсегоПродажПоДокументу = ИтогиПродажПоДокументам.Скопировать(Отбор).Итог("Сумма");
				ВсегоОплатПоДокументу  = ИтогиОплатПоДокументам.Скопировать(Отбор).Итог("Сумма");
				
				// Смешанные оплаты (например карта и сертификат) не поддерживаем. В этом случае не удаляем ничего.
				Если СтрокиОплаты.Количество() = 1 И (ВсегоПродажПоДокументу = ВсегоОплатПоДокументу) Тогда
					Если СтрокиОплаты[0].Сумма > СтрокаТовары.Сумма Тогда
						СтрокиОплаты[0].Сумма = СтрокиОплаты[0].Сумма - СтрокаТовары.Сумма;
					Иначе 
						ТаблицаОплат.Удалить(СтрокиОплаты[0]);
					КонецЕсли; 
				КонецЕсли;
				
				ТаблицаТоваров.Удалить(СтрокаТовары);
			КонецЕсли;
		КонецЦикла;
		
		ИдентификаторыДокументовПоСменам.Вставить(ОтчетОПродажах.ДатаЗакрытияСмены, ИдентификаторыДокументов);
		
		ПродажиТоваров = ТаблицаТоваров.Скопировать(Новый Структура("ЭтоВозврат", Ложь), "Номенклатура, СтавкаНДС, Количество, Сумма");
		ПродажиТоваров.Свернуть("Номенклатура, СтавкаНДС", "Количество, Сумма");
		
		ВозвратТоваров = ТаблицаТоваров.Скопировать(Новый Структура("ЭтоВозврат", Истина), "Номенклатура, СтавкаНДС, НомерФискальногоЧека, ДатаРеализации, Количество, Сумма");
		ВозвратТоваров.Свернуть("Номенклатура, СтавкаНДС, НомерФискальногоЧека, ДатаРеализации", "Количество, Сумма");
		
		ОплатаТоваров = ТаблицаОплат.Скопировать(Новый Структура("ЭтоВозврат", Ложь), "ВидОплаты, Сумма");
		ОплатаТоваров.Свернуть("ВидОплаты", "Сумма");
		
		ВозвратОплаты = ТаблицаОплат.Скопировать(Новый Структура("ЭтоВозврат", Истина), "ВидОплаты, Сумма");
		ВозвратОплаты.Свернуть("ВидОплаты", "Сумма");
		
		Комментарий = СформироватьКомментарий(Устройство);
		
		ТаблицыДанных = Новый Структура;
		ТаблицыДанных.Вставить("УникальныйИдентификатор", ОтчетОПродажах.УникальныйИдентификатор);
		ТаблицыДанных.Вставить("ДатаЗакрытияСмены",       ОтчетОПродажах.ДатаЗакрытияСмены);
		ТаблицыДанных.Вставить("Товары",                  ПродажиТоваров);
		ТаблицыДанных.Вставить("Оплаты",                  ОплатаТоваров);
		ТаблицыДанных.Вставить("ВозвратыТоваров",         ВозвратТоваров);
		ТаблицыДанных.Вставить("ВозвратыОплат",           ВозвратОплаты);
		
		СоздатьИЗаполнитьОтчетОПродажах(МассивСозданныхДокументов, ПараметрыУстройства, ТаблицыДанных, Комментарий);
	КонецЦикла;
		
	Возврат МассивСозданныхДокументов;
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейсВыгрузкаТоваров

// Функция возвращает таблицу товаров с данными к выгрузке в устройство.
//
// Параметры:
//  Устройство - <СправочникСсылка.ПодключаемоеОборудование> - Устройство для которого необходимо получить данные.
//  Параметры - <Структура> - Параметры формирования данныъ.
//  ПолнаяВыгрузка - <Булево> - выгружать все товары.
//
// Возвращаемое значение:
//  <Массив> результаты запроса для заполнения .
//
Функция ТаблицыДанныхДляВыгрузки(Устройство, Параметры, ПолнаяВыгрузка)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка КАК Ссылка,
	|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
	|	СправочникНоменклатура.Наименование КАК Наименование,
	|	СправочникНоменклатура.НаименованиеПолное КАК НаименованиеПолное,
	|	СправочникНоменклатура.Артикул КАК Артикул,
	|	СправочникНоменклатура.ВидСтавкиНДС КАК ВидСтавкиНДС,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК Цена,
	|	ЕСТЬNULL(СправочникНоменклатура.ЕдиницаИзмерения.Ссылка, ЗНАЧЕНИЕ(Справочник.КлассификаторЕдиницИзмерения.ПустаяСсылка)) КАК ЕдиницаИзмеренияСсылка,
	|	ЕСТЬNULL(СправочникНоменклатура.ЕдиницаИзмерения.Наименование, """") КАК ЕдиницаИзмеренияНаименование,
	|	ЕСТЬNULL(СправочникНоменклатура.ЕдиницаИзмерения.Код, """") КАК ЕдиницаИзмеренияКод,
	|	КодыТоваровПодключаемогоОборудованияOffline.Используется КАК Используется,
	|	СправочникНоменклатура.Услуга КАК Услуга,
	|	СправочникНоменклатура.Родитель КАК Родитель
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline.Изменения КАК КодыТоваровПодключаемогоОборудованияOfflineИзменения
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Код = КодыТоваровПодключаемогоОборудованияOfflineИзменения.Код
	|			И (КодыТоваровПодключаемогоОборудованияOfflineИзменения.Узел = &УзелИнформационнойБазы)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ПериодЦен, ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|ГДЕ
	|	НЕ СправочникНоменклатура.Ссылка ЕСТЬ NULL
	|	И &СписокУсловий
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Товары.Ссылка КАК Ссылка,
	|	ВТ_Товары.Код КАК Код,
	|	ВТ_Товары.Наименование КАК Наименование,
	|	ВТ_Товары.НаименованиеПолное КАК НаименованиеПолное,
	|	ВТ_Товары.Артикул КАК Артикул,
	|	ВТ_Товары.Родитель КАК Группа,
	|	ВТ_Товары.ВидСтавкиНДС КАК ВидСтавкиНДС,
	|	ВТ_Товары.Цена КАК Цена,
	|	ВТ_Товары.ЕдиницаИзмеренияНаименование КАК ЕдиницаИзмеренияНаименование,
	|	ВТ_Товары.ЕдиницаИзмеренияКод КАК ЕдиницаИзмеренияКод,
	|	ВТ_Товары.ЕдиницаИзмеренияСсылка КАК ЕдиницаИзмеренияСсылка,
	|	ВТ_Товары.Услуга КАК Услуга
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
	|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ВТ_Товары.Ссылка = ШтрихкодыНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Товары.ЕдиницаИзмеренияСсылка КАК Ссылка,
	|	ВТ_Товары.ЕдиницаИзмеренияКод КАК Код,
	|	ВТ_Товары.ЕдиницаИзмеренияНаименование КАК Наименование
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Товары.Родитель КАК Ссылка,
	|	ВТ_Товары.Родитель.Наименование КАК Наименование
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|ГДЕ
	|	НЕ ВТ_Товары.Родитель.Ссылка ЕСТЬ NULL"; 
	
	СписокУсловий = Новый Массив;
	СписокУсловий.Добавить("НЕ СправочникНоменклатура.ЭтоГруппа");
	
	Если НЕ ПолнаяВыгрузка Тогда
		СписокУсловий.Добавить("КодыТоваровПодключаемогоОборудованияOfflineИзменения.Узел = &УзелИнформационнойБазы");
	Иначе
		СписокУсловий.Добавить("ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) <> 0");
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&СписокУсловий", СтрСоединить(СписокУсловий, " И "));
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", Параметры.УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("ТипЦен",                 Параметры.ТипЦен);
	Запрос.УстановитьПараметр("ПериодЦен",              КонецДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Результаты = Новый Структура();
	Результаты.Вставить("ТаблицаТовары",             РезультатЗапроса[1].Выгрузить());
	Результаты.Вставить("ТаблицаШтрихкоды",          РезультатЗапроса[2].Выгрузить());
	Результаты.Вставить("ТаблицаЕдиницыИзмерения",   РезультатЗапроса[3].Выгрузить());
	Результаты.Вставить("ТаблицаГруппыНоменклатуры", РезультатЗапроса[4].Выгрузить());
	
	Возврат Результаты;
КонецФункции

Функция СтавкаНДСОфлайнОборудование(Знач СтавкаНДС)
	
	Если Не ЗначениеЗаполнено(СтавкаНДС) Тогда
		СтавкаНДС = УчетНДСКлиентСервер.СтавкаНДСПоУмолчанию(ТекущаяДата());
	КонецЕсли;
	
	Если СтавкаНДС = Перечисления.СтавкиНДС.БезНДС Тогда
		Возврат МенеджерОфлайнОборудования.ПолучитьСтавкуБезНДС();
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС0 Тогда 
		Возврат МенеджерОфлайнОборудования.ПолучитьСтавкуНДС0();
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС10 Тогда 
		Возврат МенеджерОфлайнОборудования.ПолучитьСтавкуНДС10();
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС18 Тогда
		Возврат МенеджерОфлайнОборудования.ПолучитьСтавкуНДС18();
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС20 Тогда
		Возврат МенеджерОфлайнОборудования.ПолучитьСтавкуНДС20();
	КонецЕсли;
	
КонецФункции

// Функция возвращает структуру с данными в формате, необходимом для выгрузки списка товаров в ККМ Offline.
//
// Параметры:
//  Устройство - <СправочникСсылка.ПодключаемоеОборудование> - Устройство для которого необходимо получить данные.
//  ТолькоИзмененные - <Булево> - Флаг получения только измененных данных.
//
// Возвращаемое значение:
//  <Структура> с массивом структур для выгрузки и количеством не выгруженных строк.
//
Функция ПолучитьДанныеДляКассы(Устройство, ПрайсЛист, ПолнаяВыгрузка) Экспорт
	
	Параметры = ПолучитьПараметрыУстройства(Устройство);
	Если Параметры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РабочаяДата = ОбщегоНазначения.РабочаяДатаПользователя();
	
	ДанныеДляКассы = ТаблицыДанныхДляВыгрузки(Устройство, Параметры, ПолнаяВыгрузка);
	ДанныеДляКассы.ТаблицаШтрихкоды.Индексы.Добавить("Номенклатура");
	
	Для каждого СтрокаТовара Из ДанныеДляКассы.ТаблицаТовары Цикл
		ЗаписьТовара = МенеджерОфлайнОборудования.ПолучитьЗаписьТовара();
		
		ЗаписьТовара.Код                     = СтрокаТовара.Код;
		ЗаписьТовара.Цена                    = СтрокаТовара.Цена;
		ЗаписьТовара.Остаток                 = 0;
		ЗаписьТовара.УникальныйИдентификатор = СтрокаТовара.Ссылка.УникальныйИдентификатор();
		ЗаписьТовара.Наименование            = СтрокаТовара.Наименование;
		ЗаписьТовара.СтавкаНДС               = СтавкаНДСОфлайнОборудование(Перечисления.СтавкиНДС.СтавкаНДС(СтрокаТовара.ВидСтавкиНДС, РабочаяДата));
		
		Если СтрокаТовара.Услуга Тогда
			ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Услуга;
		Иначе
			ПризнакПредметаРасчета = ?(Справочники.Номенклатура.ЭтоМаркируемаяАлкогольнаяПродукция(СтрокаТовара.Ссылка), 
				Перечисления.ПризнакиПредметаРасчета.ПодакцизныйТовар, 
				Перечисления.ПризнакиПредметаРасчета.Товар);
		КонецЕсли;
		
		Если НЕ СтрокаТовара.Группа.Пустая() Тогда
			УникальныйИдентификаторГруппы = СтрокаТовара.Группа.УникальныйИдентификатор();
			
			ЗаписьТовара.КодГруппы = СтрЗаменить(Строка(УникальныйИдентификаторГруппы), "-", "");
			ЗаписьТовара.УникальныйИдентификаторГруппы = УникальныйИдентификаторГруппы;
		КонецЕсли; 

		ЗаписьТовара.ПризнакПредметаРасчета  = ПризнакПредметаРасчета;
		
		ЗаписьТовара.Артикул                 = СтрокаТовара.Артикул;
		ЗаписьТовара.Описание                = СтрокаТовара.НаименованиеПолное;
		ЗаписьТовара.ЭтоВесовойТовар         = Ложь;
		ЗаписьТовара.НомерСекции             = 1;
		
		ЗаписьТовара.КодЕдиницыИзмерения                     = СтрокаТовара.ЕдиницаИзмеренияКод; 
		ЗаписьТовара.УникальныйИдентификаторЕдиницыИзмерения = СтрокаТовара.ЕдиницаИзмеренияСсылка.УникальныйИдентификатор();
		
		ТаблицаШтрихкоды = ДанныеДляКассы.ТаблицаШтрихкоды.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовара.Ссылка));
		Для каждого СтрокаШтрихкода Из ТаблицаШтрихкоды Цикл
			// Штрихкод
			ЗаписьШтрихкода = МенеджерОфлайнОборудования.ПолучитьЗаписьШтрихкода();
			ЗаписьШтрихкода.Штрихкод = СтрокаШтрихкода.Штрихкод;
			ЗаписьТовара.Штрихкоды.Добавить(ЗаписьШтрихкода);
		КонецЦикла;
		
		ПрайсЛист.Товары.Добавить(ЗаписьТовара);
	КонецЦикла;
	
	Для каждого СтрокаЕдиницаИзмерения Из ДанныеДляКассы.ТаблицаЕдиницыИзмерения Цикл
		ЗаписьЕИ = МенеджерОфлайнОборудования.ПолучитьЗаписьЕдиницыИзмерения();
		
		ЗаписьЕИ.Код                     = СтрокаЕдиницаИзмерения.Код;
		ЗаписьЕИ.Наименование            = СтрокаЕдиницаИзмерения.Наименование;
		ЗаписьЕИ.УникальныйИдентификатор = СтрокаЕдиницаИзмерения.Ссылка.УникальныйИдентификатор();
		ЗаписьЕИ.КодОКЕИ                 = СтрокаЕдиницаИзмерения.Код;
		
		ПрайсЛист.ЕдиницыИзмерения.Добавить(ЗаписьЕИ);
	КонецЦикла;
	
	Для каждого СтрокаГруппыТоваров Из ДанныеДляКассы.ТаблицаГруппыНоменклатуры Цикл
		ЗаписьГруппаТоваров = МенеджерОфлайнОборудования.ПолучитьЗаписьГруппыТоваров();
		
		УникальныйИдентификаторГруппы = СтрокаГруппыТоваров.Ссылка.УникальныйИдентификатор();
		
		ЗаписьГруппаТоваров.Код                     = СтрЗаменить(Строка(УникальныйИдентификаторГруппы), "-", "");
		ЗаписьГруппаТоваров.Наименование            = СтрокаГруппыТоваров.Наименование;
		ЗаписьГруппаТоваров.УникальныйИдентификатор = УникальныйИдентификаторГруппы;
		
		ПрайсЛист.ГруппыТоваров.Добавить(ЗаписьГруппаТоваров);
	КонецЦикла; 
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейсВыгрузкаНастроек

// Функция возвращает настройки для экземпляра оборудования.
//
Функция ПолучитьНастройкиДляККМОффлайн(Устройство, СтруктураНастроек) Экспорт
	
	Параметры = ПолучитьПараметрыУстройства(Устройство);
	Если Параметры = Неопределено Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация, ТекущаяДатаСеанса());
	
	СтруктураНастроек.НаименованиеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	СтруктураНастроек.ИНН                     = СведенияОбОрганизации.ИНН;
	СтруктураНастроек.КПП                     = СведенияОбОрганизации.КПП;
	СтруктураНастроек.АдресТочкиПродажи       = СведенияОбОрганизации.ЮридическийАдрес;
	
	Дата = ТекущаяДатаСеанса();
	
	Если УчетнаяПолитика.ПрименяетсяУСНДоходы(Организация, Дата) Тогда
		СтруктураНастроек.СистемыНалогообложения.Добавить(Перечисления.ТипыСистемНалогообложенияККТ.УСНДоход);
	ИначеЕсли УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, Дата) Тогда 
		СтруктураНастроек.СистемыНалогообложения.Добавить(Перечисления.ТипыСистемНалогообложенияККТ.УСНДоходРасход);
	ИначеЕсли УчетнаяПолитика.СистемаНалогообложения(Организация, Дата) = Перечисления.СистемыНалогообложения.Общая Тогда 
		СтруктураНастроек.СистемыНалогообложения.Добавить(Перечисления.ТипыСистемНалогообложенияККТ.ОСН);
	КонецЕсли;
	
	Если УчетнаяПолитика.ПлательщикЕНВД(Организация, Дата) Тогда
		СтруктураНастроек.СистемыНалогообложения.Добавить(Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД);
	КонецЕсли; 
	
	Если УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, Дата) Тогда
		СтруктураНастроек.СистемыНалогообложения.Добавить(Перечисления.ТипыСистемНалогообложенияККТ.Патент);
	КонецЕсли; 
	
	ТаблицаВидовОплат = ПолучитьТаблицуВидовОплат(Устройство);
	ВидыОплаты = Новый Массив;
	
	Для Каждого СтрокаВидаОплаты Из ТаблицаВидовОплат Цикл
		
		ВидЭлектроннойОплаты = МенеджерОфлайнОборудования.ПолучитьЗаписьВидЭлектроннойОплаты();
		ВидЭлектроннойОплаты.Код = СтрокаВидаОплаты.Код;
		ВидЭлектроннойОплаты.Наименование = СтрокаВидаОплаты.Наименование;
		Если СтрокаВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.ПлатежнаяКарта Тогда
			ВидЭлектроннойОплаты.ТипЭлектроннойОплаты = МенеджерОфлайнОборудования.ТипЭлектроннойОплатыПлатежнаяКарта();
		ИначеЕсли СтрокаВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.БанковскийКредит Тогда 
			ВидЭлектроннойОплаты.ТипЭлектроннойОплаты = МенеджерОфлайнОборудования.ТипЭлектроннойОплатыБанковскийКредит();
		ИначеЕсли СтрокаВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСобственный 
			ИЛИ СтрокаВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСторонний Тогда 
			ВидЭлектроннойОплаты.ТипЭлектроннойОплаты = МенеджерОфлайнОборудования.ТипЭлектроннойОплатыПодарочныйСертификат();
		КонецЕсли;
		
		ВидЭлектроннойОплаты.УникальныйИдентификатор = СтрокаВидаОплаты.Ссылка.УникальныйИдентификатор();
		
		СтруктураНастроек.ВидыЭлектроннойОплаты.Добавить(ВидЭлектроннойОплаты);
	КонецЦикла;
	
	Возврат СтруктураНастроек;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьИЗаполнитьОтчетОПродажах(МассивСозданныхДокументов, ПараметрыУстройства, ТаблицыДанных, Комментарий = "")
	
	СтруктураПараметровДокумента = Новый Структура();
	СтруктураПараметровДокумента.Вставить("Организация", 	ПараметрыУстройства.Организация);
	СтруктураПараметровДокумента.Вставить("Склад", 			ПараметрыУстройства.Склад);
	СтруктураПараметровДокумента.Вставить("ВидОперации",	Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах);
	СтруктураПараметровДокумента.Вставить("Ответственный", 	Пользователи.ТекущийПользователь());
	
	СсылкаДокумента = ?(
		ЗначениеЗаполнено(ТаблицыДанных.УникальныйИдентификатор), 
		Документы.ОтчетОРозничныхПродажах.ПолучитьСсылку(ТаблицыДанных.УникальныйИдентификатор), 
		Документы.ОтчетОРозничныхПродажах.ПолучитьСсылку());
	
	ОтчетОРозничныхПродажахОбъект =  СсылкаДокумента.ПолучитьОбъект();
	
	// Такого документа еще нет
	Если ОтчетОРозничныхПродажахОбъект = Неопределено Тогда
		ОтчетОРозничныхПродажахОбъект = Документы.ОтчетОРозничныхПродажах.СоздатьДокумент();
		ОтчетОРозничныхПродажахОбъект.УстановитьСсылкуНового(СсылкаДокумента);
	Иначе
		ОтчетОРозничныхПродажахОбъект.Товары.Очистить();
		ОтчетОРозничныхПродажахОбъект.Возвраты.Очистить();
		ОтчетОРозничныхПродажахОбъект.Оплата.Очистить();
		ОтчетОРозничныхПродажахОбъект.ВозвратОплаты.Очистить();
	КонецЕсли; 
	
	ОтчетОРозничныхПродажахОбъект.Заполнить(СтруктураПараметровДокумента);
	ОтчетОРозничныхПродажахОбъект.Дата = ТаблицыДанных.ДатаЗакрытияСмены;
	ОтчетОРозничныхПродажахОбъект.Комментарий = Комментарий;
	
	Для каждого СтрокаТовары Из ТаблицыДанных.Товары Цикл
		Если СтрокаТовары.Сумма = 0 
			И СтрокаТовары.Количество = 0 Тогда
			
			Продолжить;
		КонецЕсли; 
		НоваяСтрока = ОтчетОРозничныхПродажахОбъект.Товары.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары, "Номенклатура, СтавкаНДС, Количество, Сумма");
		
		НоваяСтрока.Цена = ?(НоваяСтрока.Количество = 0, НоваяСтрока.Сумма, НоваяСтрока.Сумма / НоваяСтрока.Количество);
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ОтчетОРозничныхПродажахОбъект.СуммаВключаетНДС);
	КонецЦикла; 
	
	Для каждого СтрокаВозвраты Из ТаблицыДанных.ВозвратыТоваров Цикл
		НоваяСтрока = ОтчетОРозничныхПродажахОбъект.Возвраты.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВозвраты, "Номенклатура, СтавкаНДС, Количество, Сумма, НомерФискальногоЧека, ДатаРеализации");
		
		НоваяСтрока.Цена = ?(НоваяСтрока.Количество = 0, НоваяСтрока.Сумма, НоваяСтрока.Сумма / НоваяСтрока.Количество);
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ОтчетОРозничныхПродажахОбъект.СуммаВключаетНДС);
	КонецЦикла; 
	
	Для Каждого Оплата ИЗ ТаблицыДанных.Оплаты Цикл
		ОплатаПлатежнойКартой             = ОтчетОРозничныхПродажахОбъект.Оплата.Добавить();
		ОплатаПлатежнойКартой.СуммаОплаты = Оплата.Сумма;
		ОплатаПлатежнойКартой.ВидОплаты   = Оплата.ВидОплаты;
	КонецЦикла;
	
	Для Каждого Оплата ИЗ ТаблицыДанных.ВозвратыОплат Цикл
		ОплатаПлатежнойКартой             = ОтчетОРозничныхПродажахОбъект.ВозвратОплаты.Добавить();
		ОплатаПлатежнойКартой.СуммаОплаты = Оплата.Сумма;
		ОплатаПлатежнойКартой.ВидОплаты   = Оплата.ВидОплаты;
	КонецЦикла;
	
	ОтчетОРозничныхПродажахОбъект.ДополнительныеСвойства.Вставить("ЗаполнитьСчетаУчетаПередЗаписью", Истина);
	
	Если ОтчетОРозничныхПродажахОбъект.Товары.Итог("СуммаНДС") <> 0 
		ИЛИ ОтчетОРозничныхПродажахОбъект.Возвраты.Итог("СуммаНДС") <> 0 Тогда
		
		ОтчетОРозничныхПродажахОбъект.ДокументБезНДС = Ложь;
	КонецЕсли; 
	
	Попытка
		// Проводим в попытке, чтобы при ошибке в процелуре проведения (например нет остатка товара) не останавливалась вся загрузка.
		ОтчетОРозничныхПродажахОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ОтчетОРозничныхПродажахОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;
	
	УзелОбъект = ПараметрыУстройства.УзелИнформационнойБазы.ПолучитьОбъект();
	УзелОбъект.ДатаЗагрузки = ТекущаяДатаСеанса();
	УзелОбъект.Записать();
	
	МассивСозданныхДокументов.Добавить(ОтчетОРозничныхПродажахОбъект.Ссылка);
КонецПроцедуры

Функция СформироватьКомментарий(Устройство)
	
	Комментарий = СтрШаблон(НСтр("ru = 'Загружено из %1:%2'"), Устройство.ТипОборудования, Устройство);
	
	Возврат Комментарий;
	
КонецФункции

Функция НовыйТаблицаТоваров()
	ТаблицаТоваров = Новый ТаблицаЗначений;
	
	ТаблицаТоваров.Колонки.Добавить("ИдентификаторДокумента",           Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("ИдентификаторСвязанногоДокумента", Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("ЭтоВозврат",                       Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить("ДатаРеализации",                   Новый ОписаниеТипов("Дата"));
	ТаблицаТоваров.Колонки.Добавить("Код",                              Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Номенклатура",                     Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("СтавкаНДС",                        Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
	ТаблицаТоваров.Колонки.Добавить("Количество",                       Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Сумма",                            Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("НомерФискальногоЧека",             Новый ОписаниеТипов("Строка"));
	
	Возврат ТаблицаТоваров;
КонецФункции

Функция НовыйТаблицаОплат()
	ТаблицаОплат = Новый ТаблицаЗначений;
	
	ТаблицаОплат.Колонки.Добавить("ИдентификаторДокумента", Новый ОписаниеТипов("Строка"));
	ТаблицаОплат.Колонки.Добавить("ЭтоВозврат",             Новый ОписаниеТипов("Булево"));
	ТаблицаОплат.Колонки.Добавить("ВидОплаты",              Новый ОписаниеТипов("СправочникСсылка.ВидыОплатОрганизаций"));
	ТаблицаОплат.Колонки.Добавить("Сумма",                  Новый ОписаниеТипов("Число"));
	
	Возврат ТаблицаОплат;
КонецФункции
 

Функция ПолучитьТаблицуВидовОплат(Устройство)
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КодыВидовОплатыКММ.ВидОплаты КАК Ссылка,
	|	КодыВидовОплатыКММ.ВидОплаты.Наименование КАК Наименование,
	|	КодыВидовОплатыКММ.Код КАК Код,
	|	КодыВидовОплатыКММ.ВидОплаты.ТипОплаты КАК ТипОплаты
	|ИЗ
	|	РегистрСведений.КодыВидовОплатыКММ КАК КодыВидовОплатыКММ
	|ГДЕ
	|	КодыВидовОплатыКММ.Оборудование = &Оборудование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	
	Запрос.УстановитьПараметр("Оборудование", Устройство);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти
