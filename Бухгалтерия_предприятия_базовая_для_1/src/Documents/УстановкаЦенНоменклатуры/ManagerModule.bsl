#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();
	Результат = Запрос.Выполнить();
	ПараметрыПроведения.Вставить("ТаблицаРеквизитов", Результат.Выгрузить());
	
	Реквизиты = ПараметрыПроведения.ТаблицаРеквизитов[0];
	
	Запрос.УстановитьПараметр("НеПроводитьНулевыеЗначения", Реквизиты.НеПроводитьНулевыеЗначения);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаУстановкаЦен(НомераТаблиц);
		
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции 

Функция ТекстЗапросаРеквизитыДокумента()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.НеПроводитьНулевыеЗначения КАК НеПроводитьНулевыеЗначения,
	|	Реквизиты.ТипЦен КАК ТипЦен
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции // ТекстЗапросаРеквизитыДокумента()

Функция ТекстЗапросаУстановкаЦен(НомераТаблиц)
	
	НомераТаблиц.Вставить("УстановкаЦен", НомераТаблиц.Количество());
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УстановкаЦенНоменклатурыТовары.Номенклатура КАК Номенклатура,
	|	УстановкаЦенНоменклатурыТовары.Цена КАК Цена,
	|	ВЫБОР
	|		КОГДА УстановкаЦенНоменклатурыТовары.Валюта <> ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|			ТОГДА УстановкаЦенНоменклатурыТовары.Валюта
	|		КОГДА УстановкаЦенНоменклатуры.ТипЦен.ВалютаЦены <> ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|			ТОГДА УстановкаЦенНоменклатуры.ТипЦен.ВалютаЦены
	|		ИНАЧЕ &ВалютаРегламентированногоУчета
	|	КОНЕЦ КАК Валюта
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры КАК УстановкаЦенНоменклатуры
	|		ПО УстановкаЦенНоменклатурыТовары.Ссылка = УстановкаЦенНоменклатуры.Ссылка
	|ГДЕ
	|	НЕ(&НеПроводитьНулевыеЗначения
	|				И УстановкаЦенНоменклатурыТовары.Цена = 0)
	|	И УстановкаЦенНоменклатурыТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	УстановкаЦенНоменклатурыТовары.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции // ТекстЗапросаРеквизитыДокумента()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ДВИЖЕНИЙ

Процедура СформироватьДвиженияУстановкаЦен(Таблица, ТаблицаРеквизитов, Движения, Отказ) Экспорт
	
	Если Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = ТаблицаРеквизитов[0];
	
	Дата   = Реквизиты.Период;
	ТипЦен = Реквизиты.ТипЦен;
	
	Для каждого СтрокаТовара Из Таблица Цикл

		Движение = Движения.ЦеныНоменклатуры.Добавить();
		
		Движение.Период 	  = Дата;
		Движение.ТипЦен       = ТипЦен;
		Движение.Номенклатура = СтрокаТовара.Номенклатура;
		Движение.Цена   	  = СтрокаТовара.Цена;
		Движение.Валюта 	  = СтрокаТовара.Валюта;
		
	КонецЦикла;
	
	Движения.ЦеныНоменклатуры.Записывать = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Изменение цен номенклатуры
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПереченьЦен";
	КомандаПечати.Представление = НСтр("ru = 'Изменение цен номенклатуры'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок       = 10;
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ПечатьЭтикеток) Тогда
		// Ценники
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "Ценники";
		КомандаПечати.Представление = НСтр("ru = 'Ценники'");
		КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Ценники'");
		КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиЦенников";
		КомандаПечати.Порядок       = 20;
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьЗаголовокДокумента(Документ, НазваниеДокумента)
	
	Если Документ = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	НомерОбъекта = Документ.Номер;
	
	// удаляем пользовательские префиксы из номера объекта
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(НомерОбъекта);
	
	// удаляем лидирующие нули из номера объекта
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(НомерОбъекта);
	
	// удаляем префикс организации и префикс информационной базы из номера объекта
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(НомерОбъекта, , Истина);
	
	Возврат ?(НЕ ЗначениеЗаполнено(НазваниеДокумента), Документ.Метаданные().Синоним, НазваниеДокумента) + " № "
		+ НомерОбъекта + " от " + Формат(Документ.Дата, "ДФ='дд ММММ гггг'") + " г.";

КонецФункции

// Формирует и возвращает текст запроса для выборки данных,
// необходимых для формирования печатной формы
Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыПеречняЦен()
	
 	ТекстЗапроса =
	"ВЫБРАТЬ
	|	УстановкаЦенНоменклатуры.НомерСтроки КАК НомерСтроки,
	|	УстановкаЦенНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул)
	|			ТОГДА УстановкаЦенНоменклатуры.Номенклатура.Артикул
	|		ИНАЧЕ УстановкаЦенНоменклатуры.Номенклатура.Код
	|	КОНЕЦ КАК КодАртикул,
	|	УстановкаЦенНоменклатуры.Номенклатура.НаименованиеПолное КАК Товар,
	|	УстановкаЦенНоменклатуры.Цена КАК Цена,
	|	УстановкаЦенНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияПредставление,
	|	УстановкаЦенНоменклатуры.Валюта КАК Валюта,
	|	УстановкаЦенНоменклатуры.Валюта.Представление КАК ВалютаПредставление,
	|	УстановкаЦенНоменклатуры.Ссылка КАК Ссылка,
	|	УстановкаЦенНоменклатуры.Ссылка.Номер,
	|	УстановкаЦенНоменклатуры.Ссылка.Дата КАК Дата,
	|	УстановкаЦенНоменклатуры.Ссылка.ТипЦен,
	|	УстановкаЦенНоменклатуры.Ссылка.Ответственный.Представление
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатуры
	|ГДЕ
	|	УстановкаЦенНоменклатуры.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка,
	|	НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПечатьПеречняЦен(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УстановкаЦенНоменклатуры_ИзменениеЦен";
	
	ДополнительнаяКолонкаПечатныхФормДокументов = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если НЕ ЗначениеЗаполнено(ДополнительнаяКолонкаПечатныхФормДокументов) Тогда
		ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	КонецЕсли;
	ВыводитьКоды = ДополнительнаяКолонкаПечатныхФормДокументов <> Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ДополнительнаяКолонкаПечатныхФормДокументов", ДополнительнаяКолонкаПечатныхФормДокументов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыПеречняЦен();
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УстановкаЦенНоменклатуры.ПФ_MXL_ИзменениеЦен");

		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка.Ссылка, "Изменение цен номенклатуры");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		Постфикс = ?(ВыводитьКоды, "СКодом", "");
		
		ОбластьШапкаНоменклатура  = Макет.ПолучитьОбласть("Шапка" + Постфикс + "|Номенклатура");
		ОбластьШапкаТипЦен        = Макет.ПолучитьОбласть("Шапка" + Постфикс + "|Цена");
		ОбластьСтрокаНоменклатура = Макет.ПолучитьОбласть("Строка" + Постфикс + "|Номенклатура");
		ОбластьСтрокаТипЦен       = Макет.ПолучитьОбласть("Строка" + Постфикс + "|Цена");
		ОбластьПодвалНоменклатура = Макет.ПолучитьОбласть("Подписи|Номенклатура");
		ОбластьПодвалТипЦен       = Макет.ПолучитьОбласть("Подписи|Цена");

		Если ВыводитьКоды Тогда
			Если ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
				ОбластьШапкаНоменклатура.Параметры.ИмяКодАртикул = "Артикул";
			ИначеЕсли ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
				ОбластьШапкаНоменклатура.Параметры.ИмяКодАртикул = "Код";
			КонецЕсли;
		КонецЕсли;
		
		// Выведем шапку
		ТабличныйДокумент.Вывести(ОбластьШапкаНоменклатура);
		
		ОбластьШапкаТипЦен.Параметры.ТипЦен = Шапка.ТипЦен;
		ТабличныйДокумент.Присоединить(ОбластьШапкаТипЦен);
		
		// Выведем таблицу
		Пока Шапка.Следующий() Цикл
			
			ОбластьСтрокаНоменклатура.Параметры.Заполнить(Шапка);
			ОбластьСтрокаНоменклатура.Параметры.Товар = Шапка.Товар;
			ТабличныйДокумент.Вывести(ОбластьСтрокаНоменклатура);
			ОбластьСтрокаТипЦен.Параметры.Заполнить(Шапка);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТипЦен);
			
		КонецЦикла;
		
		// Выведем подвал
		ОбластьПодвалНоменклатура.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьПодвалНоменклатура);
		ТабличныйДокумент.Присоединить(ОбластьПодвалТипЦен);

		ТекОбласть = ТабличныйДокумент.Области.ОтветственныйПредставление;

		ОбластьОтветственного = ТабличныйДокумент.Область(ТекОбласть.Низ, 14, ТекОбласть.Низ, Мин(ТабличныйДокумент.ШиринаТаблицы, 30));
		ОбластьОтветственного.Объединить();
		ОбластьОтветственного.ГраницаСнизу            = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
		ОбластьОтветственного.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;
		
	Если ПервыйДокумент Тогда 
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УстановкаЦенНоменклатуры.ПФ_MXL_ИзменениеЦен");

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		Постфикс = ?(ВыводитьКоды, "СКодом", "");
		
		ОбластьШапкаНоменклатура  = Макет.ПолучитьОбласть("Шапка" + Постфикс + "|Номенклатура");
		ОбластьШапкаТипЦен        = Макет.ПолучитьОбласть("Шапка" + Постфикс + "|Цена");
		ОбластьСтрокаНоменклатура = Макет.ПолучитьОбласть("Строка" + Постфикс + "|Номенклатура");
		ОбластьСтрокаТипЦен       = Макет.ПолучитьОбласть("Строка" + Постфикс + "|Цена");
		ОбластьПодвалНоменклатура = Макет.ПолучитьОбласть("Подписи|Номенклатура");
		ОбластьПодвалТипЦен       = Макет.ПолучитьОбласть("Подписи|Цена");
	
		ТабличныйДокумент.Вывести(ОбластьШапкаНоменклатура);
		ТабличныйДокумент.Присоединить(ОбластьШапкаТипЦен);
		ТабличныйДокумент.Вывести(ОбластьСтрокаНоменклатура);
		ТабличныйДокумент.Присоединить(ОбластьСтрокаТипЦен);
		ТабличныйДокумент.Вывести(ОбластьПодвалНоменклатура);
		ТабличныйДокумент.Присоединить(ОбластьПодвалТипЦен);
	КонецЕсли;

	Возврат ТабличныйДокумент;

КонецФункции // ПечатьДокумента()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета ПлатежноеПоручение формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПереченьЦен") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПереченьЦен", "Перечень цен", 
			ПечатьПеречняЦен(МассивОбъектов, ОбъектыПечати), , "Документ.УстановкаЦенНоменклатуры.ПФ_MXL_ИзменениеЦен");
		
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

#КонецЕсли