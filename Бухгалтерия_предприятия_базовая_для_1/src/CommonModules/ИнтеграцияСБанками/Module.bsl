
#Область ПрограммныйИнтерфейс

// Преобразует полученные данные в строку формата JSON.
// Для значений с типом, не поддерживаемым при сериализации, будет вызвана функция преобразования ПривестиЗначениеПриЗаписиJSON.
// Перед обработкой значений новых типов следует модифицировать функцию преобразования.
//
// Параметры:
//  Данные - Произвольный - данные для сериализации.
//
// Возвращаемое значение:
//   Строка - сериализованные данные в формате JSON.
//
Функция СериализоватьВСтрокуJSON(Данные) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	ЗаписатьJSON(ЗаписьJSON, Данные, , "ПривестиЗначениеПриЗаписиJSON", ИнтеграцияСБанками);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

// Формирует описание ссылки для вызова извне внешнего программного интерфейса (endpoint).
// Описание предназначено для передачи вызывающей стороне. Сериализуется в JSON.
//
// Параметры:
//  Идентификатор     - Строка - идентификатор ссылки для распознавания на принимающей стороне.
//                               Должен удовлетворять требованиям, предъявляемым к ключам структуры.
//  Представление     - Строка - представление ссылки для пользователя;
//  АдресСервиса      - Строка - относительный адрес публикуемого сервиса в приложении, без адреса сервера и базы.
//  ВходящиеПараметры - Произвольный - ожидаемые входящие параметры для http-запросов вида POST.
//
// Возвращаемое значение:
//   Структура - описание публикуемой ссылки, сериализуемое в JSON.
//
Функция ОписаниеПубликуемойСсылкиНаСервис(Идентификатор, Представление, АдресСервиса, ВходящиеПараметры = Неопределено) Экспорт
	
	ОписаниеСсылки = НовыйОписаниеПубликуемойСсылки();
	
	ОписаниеСсылки.name     = Идентификатор;
	ОписаниеСсылки.type     = ВидыПубликуемыхСсылок().ПубликуемыйСервис;
	ОписаниеСсылки.title    = Представление;
	ОписаниеСсылки.address  = АдресСервиса;
	ОписаниеСсылки.settings = ВходящиеПараметры;
	
	УдалитьПустыеЭлементыСтруктуры(ОписаниеСсылки);
	
	Возврат ОписаниеСсылки;
	
КонецФункции

// Формирует описание ссылки для перехода в приложение извне (anchor).
// Описание предназначено для передачи вызывающей стороне. Сериализуется в JSON.
//
// Параметры:
//  Идентификатор       - Строка - идентификатор ссылки для распознавания на принимающей стороне.
//                               Должен удовлетворять требованиям, предъявляемым к ключам структуры.
//  Представление       - Строка - представление ссылки для пользователя;
//  НавигационнаяСсылка - Строка - навигационная ссылка в приложении, без адреса сервера и базы.
//
// Возвращаемое значение:
//   Структура - описание публикуемой ссылки, сериализуемое в JSON.
//
Функция ОписаниеПубликуемойНавигационнойСсылки(Идентификатор, Представление, НавигационнаяСсылка) Экспорт
	
	ОписаниеСсылки = НовыйОписаниеПубликуемойСсылки();
	
	ОписаниеСсылки.name     = Идентификатор;
	ОписаниеСсылки.type     = ВидыПубликуемыхСсылок().НавигационнаяСсылка;
	ОписаниеСсылки.title    = Представление;
	ОписаниеСсылки.address  = НавигационнаяСсылка;
	
	УдалитьПустыеЭлементыСтруктуры(ОписаниеСсылки);
	
	Возврат ОписаниеСсылки;
	
КонецФункции

// Возвращает URL публикуемого сервиса (без адреса приложения и базы) для получения данных отчетов и помощников.
//
// Возвращаемое значение:
//   Строка - URL для обращения к сервису.
//
Функция АдресСервисаПубликацияОтчетов() Экспорт
	
	Возврат СтрШаблон("hs/dt/storage/%1", АсинхронноеПолучениеДанных.ИдентификаторХранилища());
	
КонецФункции

// Имя метода-обработчика фонового задания актуализации данных при синхронизации с банком.
//
Функция ИмяМетодаФоновойАктуализации() Экспорт
	
	Возврат "Обработки.ЗакрытиеМесяца.АктуализироватьВФоне";
	
КонецФункции

// Актуализирует учет (перепроводит документы и выполняет регламентные операции) по переданным организациям на текущую дату.
// Задания актуализации добавляются в очередь заданий с обычным приоритетом без планируемого момента запуска - 
// будут выполнены в порядке "живой очереди".
//
// Параметры:
//  Организации  - Массив - организации, в которых требуется проверить и восстановить актуальность учета.
//
Процедура ЗапланироватьАктуализациюУчетаПоОрганизациям(Организации) Экспорт
	
	Если НЕ ТипЗнч(Организации) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийДень = ТекущаяДатаСеанса();
	
	Для Каждого Организация Из Организации Цикл
		
		СообщениеОбОшибке = "";
		
		РезультатПроверки = ПроверитьАктуальностьУчета(Организация, ТекущийДень, Ложь);
		
		Если РезультатПроверки.ДанныеАктуальны Тогда
			Продолжить;
		КонецЕсли;
		
		Если РезультатПроверки.АктуализацияВозможна Тогда
			
			ЗапланироватьВосстановлениеАктуальностиУчета(Организация, Истина);
			
		Иначе
			
			// Сохраним выявленную ошибку в журнале регистрации.
			ИмяСобытия = ЗакрытиеМесяцаКлиентСервер.СобытиеЖурналаРегистрации(
				НСтр("ru = 'Ошибка при проверке актуальности'", ОбщегоНазначения.КодОсновногоЯзыка())); // Строка записывается в журнал
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Обработки.ЗакрытиеМесяца, ,
				СообщениеОбОшибке,
				РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Запускает перевыполнение регламентных операций, влияющих на расчет налогов, перед публикацией помощников и отчетов.
// Запуск производится синхронно.
// Перед запуском проверяется наличие запущенной актуализации в других сеансах данной области.
// Если найдена выполняющаяся актуализация - ожидает ее завершения в течение времени, указанном в ВремяОжиданияАктуализации().
// Если за указанное время параллельная актуализация не завершена - ожидание повторяется.
// При достижении количества повторов ожидания, указанного в КоличествоПовторовОжиданияАктуализации(),
// попытки дождаться прекращаются и пользователю сообщается о необходимости запросить данные позже.
//
// Параметры:
//  Организация  - СправочникСсылка.Организации - организация публикуемых данных
//  Период       - Дата - дата, по которую требуются актуальные данные
//  СообщениеОбОшибке - Строка - заполняется при выполнении функции, если возникли ошибки.
//
// Возвращаемое значение:
//   Булево   - если Истина, актуальность учета обеспечена
//
Функция ОбеспечитьАктуальностьПубликуемыхДанных(Организация, Период, СообщениеОбОшибке) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Ошибка при проверке актуальности данных: не указана организация'");
		Возврат Ложь;
	КонецЕсли;
	
	РезультатПроверки = ПроверитьАктуальностьУчета(Организация, Период, Истина);
	
	Если РезультатПроверки.ДанныеАктуальны Тогда
		Возврат Истина; // Данные актуальны.
	ИначеЕсли НЕ РезультатПроверки.АктуализацияВозможна Тогда
		СообщениеОбОшибке = РезультатПроверки.ТекстОшибки;
		Возврат Ложь; // Привести данные в актуальное состояние невозможно.
	КонецЕсли;
	
	// Запланируем полное восстановление актуальности, если данные "устарели" более чем на месяц.
	
	ТекущийДень = ТекущаяДатаСеанса();
	
	Если НачалоМесяца(РезультатПроверки.ДатаАктуальности) < НачалоМесяца(ТекущийДень) Тогда
		ЗапланироватьВосстановлениеАктуальностиУчета(Организация);
	КонецЕсли;
	
	// Пытаемся привести данные о налогах за квартал в актуальное состояние за приемлемое время.
	
	ГраницаАктуальности = КонецКвартала(Период);
	
	Возврат ВыполнитьАктуализациюПередПубликациейДанных(Организация, ГраницаАктуальности, СообщениеОбОшибке);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Конструктор структуры-описания для передачи вызывающей стороне ссылок на сервисы и объекты информационной базы.
//
// Возвращаемое значение:
//   Структура - описание публикуемой ссылки.
//   Все содержащиеся значения должны сериализоваться в JSON. Состав:
//     * name     - Строка - идентификатор ссылки для принимающей стороны;
//     * title    - Строка - представление ссылки для пользователя;
//     * type     - Строка - тип передаваемой ссылки, допустимо 2 варианта:
//                             "anchor"   - это навигационная ссылка для перехода в приложение 1С;
//                             "endpoint" - это ссылка для вызова внешнего программного интерфейса приложения (метода http-сервиса);
//     * address   - Строка - относительный адрес ссылки (без адреса сервера и информационной базы):
//                             для ссылок типа "anchor" - навигационная ссылка в 1С;
//                             для ссылок типа "endpoint" - относительный URL публикуемого http-сервиса;
//     * settings - Произвольный - ожидаемые входящие параметры для методов вида POST http-сервисов. Необязательный.
//
Функция НовыйОписаниеПубликуемойСсылки()
	
	ОписаниеСсылки = Новый Структура;
	
	ОписаниеСсылки.Вставить("name", "");
	ОписаниеСсылки.Вставить("type", "");
	ОписаниеСсылки.Вставить("title", "");
	ОписаниеСсылки.Вставить("address", "");
	ОписаниеСсылки.Вставить("settings", Неопределено);
	
	Возврат ОписаниеСсылки;
	
КонецФункции

// Функция преобразования значений неподдерживаемых типов при записи данных в JSON.
// См. СериализоватьВСтрокуJSON().
// При необходимости - добавить обработку новых несериализуемых типов в новую ветку ИначеЕсли.
//
Функция ПривестиЗначениеПриЗаписиJSON(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
	
	Если ТипЗнч(Значение) = Тип("УникальныйИдентификатор") Тогда
		Возврат Строка(Значение);
	ИначеЕсли ТипЗнч(Значение) = Тип("ФорматированнаяСтрока") Тогда
		Возврат Строка(Значение);
	КонецЕсли;
	
	Отказ = Истина;
	
КонецФункции

Процедура УдалитьПустыеЭлементыСтруктуры(ОбрабатываемаяСтруктура)
	
	КлючиПустыхЭлементов = Новый Массив;
	
	Для Каждого Элемент Из ОбрабатываемаяСтруктура Цикл
		Если НЕ ЗначениеЗаполнено(Элемент.Значение) Тогда
			КлючиПустыхЭлементов.Добавить(Элемент.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Ключ Из КлючиПустыхЭлементов Цикл
		ОбрабатываемаяСтруктура.Удалить(Ключ);
	КонецЦикла;
	
КонецПроцедуры

Функция ВидыПубликуемыхСсылок()
	
	ВидыСсылок = Новый Структура;
	
	ВидыСсылок.Вставить("ПубликуемыйСервис",   "endpoint");
	ВидыСсылок.Вставить("НавигационнаяСсылка", "anchor");
	
	Возврат ВидыСсылок;
	
КонецФункции

#Область АктуальностьУчета

Функция ПроверитьАктуальностьУчета(Организация, Период, ПроверятьВесьПериод)
	
	Перем АктуализацияДоступна, АктуализацияВозможна, ДатаАктуальности;
	
	Результат = НовыйРезультатПроверкиАктуальностиУчета();
	
	УИДЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("АктуализацияДанныхТребуетсяАктуализацияЗаПериод");
	
	ПараметрыПроверки = ЗакрытиеМесяцаКлиентСервер.НовыеПараметрыПроверкиАктуальности();
	
	ПараметрыПроверки.Организация = Организация;
	ПараметрыПроверки.Период = Период;
	ПараметрыПроверки.ПроверятьКонстантуАктуальностиДанныхУчета = Ложь; // Актуальность проверяем вне зависимости от настройки приложения.
	ПараметрыПроверки.ТребуетсяПолнаяАктуализация = Истина; // Отложенные расчеты не проверяем, даже если они по какой-либо причине включены.
	
	// Для актуальности первичного учета имеет смысл проверка только по текущую дату.
	// Для публикации помощников и отчетов требуется проверять актуальность по конец периода, даже если он "в будущем".
	ПараметрыПроверки.АктуализироватьВесьПериод = ПроверятьВесьПериод;
	
	РезультатПроверки = Обработки.ЗакрытиеМесяца.ПроверитьАктуальность(ПараметрыПроверки);
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(УИДЗамера, 1);
	
	Результат.ДанныеАктуальны      = НЕ РезультатПроверки.ТребуетсяАктуализация;
	Результат.АктуализацияВозможна = Истина; // Считаем, что возможна, если проверка не нашла иное.
	Результат.ДатаАктуальности     = ТекущаяДатаСеанса(); // Считаем текущий день актуальным, если проверка не определила иное.
	
	// Проверка актуальности может вернуть результат без некоторых свойств.
	РезультатПроверки.Свойство("ДатаАктуальности",     ДатаАктуальности);
	РезультатПроверки.Свойство("АктуализацияДоступна", АктуализацияДоступна);
	РезультатПроверки.Свойство("АктуализацияВозможна", АктуализацияВозможна);
	
	Если ЗначениеЗаполнено(ДатаАктуальности) Тогда
		Результат.ДатаАктуальности = ДатаАктуальности;
	КонецЕсли;
	
	Если АктуализацияДоступна = Ложь Тогда // Может быть Неопределено
		Результат.АктуализацияВозможна = Ложь;
		Результат.ТекстОшибки = НСтр("ru = 'Данные неактуальны. У пользователя нет прав на закрытие месяца.'");
	ИначеЕсли АктуализацияВозможна = Ложь Тогда // Может быть Неопределено
		Результат.АктуализацияВозможна = Ложь;
		Результат.ТекстОшибки = НСтр("ru = 'Данные неактуальны. Требуется выполнить операции закрытия месяца в приложении 1С.'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ВыполнитьАктуализациюПередПубликациейДанных(Организация, Период, СообщениеОбОшибке)
	
	Для НомерПопытки = 1 По КоличествоПовторовОжиданияАктуализации() Цикл
		
		Если ДанныеУжеАктуализируются(Организация) Тогда
			
			ОбщегоНазначенияБТС.Пауза(ВремяОжиданияАктуализации());
			
		Иначе
			
			Возврат ЗакрытиеМесяцаВызовСервера.АктуализироватьДанныеПередПубликацией(Организация, Период, СообщениеОбОшибке);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Обеспечить актуальность данных за приемлемое время не удалось. Вызывающей стороне требуется подождать.
	СообщениеОбОшибке = НСтр("ru = 'Выполняется восстановление актуальности данных учета в приложении 1С. Пожалуйста, подождите.'");
	Возврат Ложь;
	
КонецФункции

Процедура ЗапланироватьВосстановлениеАктуальностиУчета(Организация, Немедленно = Ложь)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаданиеАктуализацииВыполняется(Организация) Тогда
		// Незачем планировать повторно.
		Возврат;
	КонецЕсли;
	
	КлючЗадания = КлючЗаданияАктуализацияУчета(Организация);
	
	ПараметрыАктуализации = ЗакрытиеМесяцаКлиентСервер.НовыеПараметрыАктуализации();
	ПараметрыАктуализации.Организация = Организация;
	ПараметрыАктуализации.Период = ТекущаяДатаСеанса();
	ПараметрыАктуализации.АктуализацияДляРасчетаНалога = Ложь; // Полное восстановление актуальности - перепроведение документов и регламентных операций.
	
	// Параметры метода Обработки.ЗакрытиеМесяца.АктуализироватьВФоне(ПараметрыЗадания, АдресХранилища):
	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(ПараметрыАктуализации);
	ПараметрыЗапуска.Добавить("");
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("ЭксклюзивноеВыполнение", Ложь);
	ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетодаФоновойАктуализации());
	ПараметрыЗадания.Вставить("Параметры", ПараметрыЗапуска);
	ПараметрыЗадания.Вставить("Ключ", КлючЗадания);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 0);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 0);
	
	ЗапланированноеЗадание = ЗапланированноеЗаданиеАктуализации(Организация);
	
	Если Немедленно Тогда
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяДатаСеанса());
	Иначе
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска",
			(КонецДня(ТекущаяДатаСеанса()) + 1) + (ВремяЗапускаПолнойАктуализации() - Дата(1, 1, 1)));
	КонецЕсли;
	
	Если ЗапланированноеЗадание <> Неопределено Тогда
		
		Если ЗапланированноеЗадание.ЗапланированныйМоментЗапуска > ПараметрыЗадания.ЗапланированныйМоментЗапуска Тогда
			// Передвинем запланированное "слишком поздно" задание на нужное время.
			ОчередьЗаданий.ИзменитьЗадание(ЗапланированноеЗадание.Идентификатор, ПараметрыЗадания);
		Иначе
			// Искомое задание запланировано на требуемое время или раньше - ничего делать не нужно.
		КонецЕсли;
		
	Иначе
		
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбщегоНазначения.ЗначениеРазделителяСеанса());
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеУжеАктуализируются(Организация)
	
	// Проверяем блокировку, наложенную выполняющейся актуализацией.
	// Эта проверка самая быстрая - выполним в первую очередь.
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Организация); // Блокировка установится, если параллельных актуализаций нет.
	Исключение
		// Блокировка уже наложена - актуализация выполняется.
		Возврат Истина;
	КонецПопытки;
	
	// Установленную блокировку нужно снять, чтобы не мешать старту запланированной актуализации из очереди заданий.
	РазблокироватьДанныеДляРедактирования(Организация);
	
	// Ищем только что стартовавшие задания полной актуализации в очереди заданий.
	// Запланированное задание может быть запущено обработчиком очереди прямо сейчас - его тоже необходимо отловить.
	
	Если ЗаданиеАктуализацииВыполняется(Организация) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// В режиме интеграции любая запущенная актуализация накладывает объектную блокировку на организацию.
	// Поэтому Фоновые задания, запущенные "без очереди" в пользовательском сеансе работы с приложением, искать не требуется.
	// Если такое задание запущено - оно уже "поймано" в начале проверки при попытке наложить блокировку.
	
	Возврат Ложь;
	
КонецФункции

Функция ЗаданиеАктуализацииВыполняется(Организация)
	
	ИскомыеСостояния = Новый Массив;
	ИскомыеСостояния.Добавить(Перечисления.СостоянияЗаданий.Выполняется);
	ИскомыеСостояния.Добавить(Перечисления.СостоянияЗаданий.ОбработкаОшибкиПриАварийномЗавершении); // Задание выполнено с ошибками и ожидает исполнения обработчика ошибки.
	ИскомыеСостояния.Добавить(Перечисления.СостоянияЗаданий.ОшибкаВыполнения); // Заданию выполнено с ошибками и ожидает повторного запуска при КоличествоПовторовПриАварийномЗавершении > 0.
	
	ОписаниеОтбора = Новый Структура;
	ОписаниеОтбора.Вставить("ВидСравнения", ВидСравнения.ВСписке);
	ОписаниеОтбора.Вставить("Значение",     ИскомыеСостояния);
	
	ОтборСостояниеЗадания = Новый Массив;
	ОтборСостояниеЗадания.Добавить(ОписаниеОтбора);
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("СостояниеЗадания", ОтборСостояниеЗадания);
	ОтборЗаданий.Вставить("ОбластьДанных",    ОбщегоНазначения.ЗначениеРазделителяСеанса());
	ОтборЗаданий.Вставить("ИмяМетода",        ИмяМетодаФоновойАктуализации());
	ОтборЗаданий.Вставить("Ключ",             КлючЗаданияАктуализацияУчета(Организация));
	ОтборЗаданий.Вставить("Использование",    Истина);
	
	Задания = ОчередьЗаданий.ПолучитьЗадания(ОтборЗаданий);
	
	Если Задания.Количество() > 0 Тогда
		Возврат Истина;// Задание актуализации зарегистрировано в очереди заданий.
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ЗапланированноеЗаданиеАктуализации(Организация)
	
	ИсключаемыеСостояния = Новый Массив;
	ИсключаемыеСостояния.Добавить(Перечисления.СостоянияЗаданий.Выполняется);
	ИсключаемыеСостояния.Добавить(Перечисления.СостоянияЗаданий.Завершено);
	
	ОписаниеОтбора = Новый Структура;
	ОписаниеОтбора.Вставить("ВидСравнения", ВидСравнения.НеВСписке);
	ОписаниеОтбора.Вставить("Значение",     ИсключаемыеСостояния);
	
	ОтборСостояниеЗадания = Новый Массив;
	ОтборСостояниеЗадания.Добавить(ОписаниеОтбора);
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("СостояниеЗадания", ОтборСостояниеЗадания);
	ОтборЗаданий.Вставить("ОбластьДанных",    ОбщегоНазначения.ЗначениеРазделителяСеанса());
	ОтборЗаданий.Вставить("ИмяМетода",        ИмяМетодаФоновойАктуализации());
	ОтборЗаданий.Вставить("Ключ",             КлючЗаданияАктуализацияУчета(Организация));
	ОтборЗаданий.Вставить("Использование",    Истина);
	
	Задания = ОчередьЗаданий.ПолучитьЗадания(ОтборЗаданий);
	
	Если Задания.Количество() > 0 Тогда
		Возврат Задания[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Количество попыток дождаться завершения актуализации, запущенной в параллельном сеансе,
// перед возвратом пользователю сообщения о невозможности выполнить актуализацию в текущем сеансе.
//
Функция КоличествоПовторовОжиданияАктуализации()
	
	Возврат 5;
	
КонецФункции

// Интервал ожидания (в секундах) между проверками завершения актуализации, запущенной в параллельном сеансе.
//
Функция ВремяОжиданияАктуализации()
	
	Возврат 3;
	
КонецФункции

Функция КлючЗаданияАктуализацияУчета(Организация)
	
	Возврат СтрШаблон("%1:%2",
		ЗакрытиеМесяцаКлиентСервер.ПрефиксКлючаЗаданияАктуализации(),
		Организация.УникальныйИдентификатор());
	
КонецФункции

Функция ВремяЗапускаПолнойАктуализации()
	
	Возврат Дата(1, 1, 1, 2, 0, 0);
	
КонецФункции

Функция НовыйРезультатПроверкиАктуальностиУчета()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ДанныеАктуальны", Ложь);          // ИСТИНА, если данные актуальны.
	Результат.Вставить("ДатаАктуальности", '00010101');   // Дата актуальности: более ранняя из дат границы последовательности или границы актуальности регламентных операций.
	Результат.Вставить("АктуализацияВозможна", Ложь);     // ИСТИНА, если возможно выполнить автоматическую актуализацию данных.
	Результат.Вставить("ТекстОшибки", "");                // Описание причины, по которой невозможна актуализация.
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

