#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СоздатьПлатежныеДокументы(Параметры, АктуализированыРеквизитыПлатежаВБюджет = Неопределено) Экспорт
	
	Перем Правило, ПериодСобытия, СчетОрганизации;
	
	СозданныеДокументы = Новый Массив;
	
	ТаблицаПлатежей = ПолучитьИзВременногоХранилища(Параметры.Платежи);
	
	Параметры.Свойство("Правило", Правило);
	Параметры.Свойство("ПериодСобытия", ПериодСобытия);
	
	Дата            = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Организация     = Параметры.Организация;
	
	Если Не Параметры.Свойство("СчетОрганизации", СчетОрганизации) Тогда
		УчетДенежныхСредствБП.УстановитьБанковскийСчет(
			СчетОрганизации, Организация, ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	КонецЕсли;
	
	Если Параметры.СпособОплаты = Перечисления.СпособыУплатыНалогов.НаличнымиПоКвитанции
		И Не ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация) Тогда
		
		ВидПлатежногоДокумента = "РасходныйКассовыйОрдер";
		ВидОперации = Перечисления.ВидыОперацийРКО.УплатаНалога;
		
	Иначе
		
		ВидПлатежногоДокумента = "ПлатежноеПоручение";
		ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога;
		
	КонецЕсли;
	
	ИндексЗавершающегоПлатежа = ТаблицаПлатежей.Количество() - 1;
	
	АктуализированыРеквизитыПлатежаВБюджет = Ложь;
	
	Для каждого Платеж Из ТаблицаПлатежей Цикл
		
		ДанныеЗаполнения = Новый Структура;
		
		НастройкаЗаполнения = РегистрыСведений.РеквизитыУплатыНалоговИПлатежейВБюджет.КлючНастройкиУплатыНалога(
			Платеж.Налог, Организация, Платеж.РегистрацияВНалоговомОргане);
		
		Если НастройкаЗаполнения <> Неопределено Тогда
			
			ИсходныеДанныеЗаполнения = РегистрыСведений.РеквизитыУплатыНалоговИПлатежейВБюджет.ДанныеЗаполнения(
				НастройкаЗаполнения, Дата, Организация, Платеж.ВидНалоговогоОбязательства,, Истина);
			
			Если ЗначениеЗаполнено(ИсходныеДанныеЗаполнения) Тогда
				Для каждого Реквизит Из ИсходныеДанныеЗаполнения Цикл
					Если ЗначениеЗаполнено(Реквизит.Значение) Тогда
						ДанныеЗаполнения.Вставить(Реквизит.Ключ, Реквизит.Значение);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Иначе
			КонтекстОперации = ВидОперации;
			ВидНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Платеж.Налог, "ВидНалога");
			Если ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет
				ИЛИ ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет Тогда
				КонтекстОперации = "НалогНаПрибыль";
			КонецЕсли;
			ДанныеЗаполнения.Вставить("СтатьяДвиженияДенежныхСредств", УчетДенежныхСредствБП.СтатьяДДСПоУмолчанию(КонтекстОперации));
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить("Дата",            Дата);
		ДанныеЗаполнения.Вставить("Организация",     Организация);
		ДанныеЗаполнения.Вставить("СчетОрганизации", СчетОрганизации);
		ДанныеЗаполнения.Вставить("ВидОперации",     ВидОперации);
		ДанныеЗаполнения.Вставить("Налог",           Платеж.Налог);
		
		Если Параметры.Свойство("НалоговыйПериод") Тогда
			ДанныеЗаполнения.Вставить("НалоговыйПериод", Параметры.НалоговыйПериод);
		ИначеЕсли Параметры.Свойство("НалоговыйПериодВТаблицеПлатежей") Тогда
			ДанныеЗаполнения.Вставить("НалоговыйПериод", Платеж.НалоговыйПериод);
			Если ДанныеЗаполнения.Свойство("ПоказательПериода") Тогда
				ДанныеЗаполнения.Удалить("ПоказательПериода");
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("НазначениеПлатежа") Тогда
				ДанныеЗаполнения.Удалить("НазначениеПлатежа");
			КонецЕсли;
		КонецЕсли;
		ДанныеЗаполнения.Вставить("ВидНалоговогоОбязательства", Платеж.ВидНалоговогоОбязательства);
		
		// Проверка актуальности реквизитов платежей в бюджет
		Если НЕ АктуализированыРеквизитыПлатежаВБюджет
			И НЕ Справочники.ВидыНалоговИПлатежейВБюджет.РеквизитыАктуальны(Платеж.Налог, Дата) Тогда
			Справочники.ВидыНалоговИПлатежейВБюджет.ОбновитьПоставляемыеДанныеИзКлассификатора();
			АктуализированыРеквизитыПлатежаВБюджет = Истина;
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить("СчетУчета", Платеж.СчетУчета);
		Для НомерСубконто = 1 По 3 Цикл
			ДанныеЗаполнения.Вставить("Субконто" + НомерСубконто, Платеж["Субконто" + НомерСубконто]);
		КонецЦикла;
		
		ДанныеЗаполнения.Вставить("СуммаДокумента", Платеж.Сумма);
		
		НовыйДокумент = Документы[ВидПлатежногоДокумента].СоздатьДокумент();
		НовыйДокумент.Заполнить(ДанныеЗаполнения);
		
		Если ЗначениеЗаполнено(Правило) Тогда
			ЭтоЗавершающийПлатеж = (ТаблицаПлатежей.Индекс(Платеж) = ИндексЗавершающегоПлатежа);
			ВыполнениеЗадачБухгалтера.УстановитьСвойстваПлатежаПриРегистрации(
				НовыйДокумент,
				Правило,
				ПериодСобытия,
				Не ЭтоЗавершающийПлатеж);
		КонецЕсли;
		
		Если НовыйДокумент.ПроверитьЗаполнение() Тогда
			НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		ИначеЕсли Не ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
			НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
		Если Не НовыйДокумент.Ссылка.Пустая() Тогда
			СозданныеДокументы.Добавить(НовыйДокумент.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СозданныеДокументы;
	
КонецФункции

Процедура ЗаполнитьВидыНалогов(ТаблицаПлатежей, Организация, ДатаОстатков) Экспорт
	
	Для каждого СтрокаТаблицы Из ТаблицаПлатежей Цикл
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);
		
		Если НалоговыйУчет.УчетВРазрезеНалоговыхОрганов() Тогда
			НомерСубконто = НомерВидаСубконтоНаСчете(СвойстваСчета, "РегистрацияВНалоговомОргане");
			СтрокаТаблицы.РегистрацияВНалоговомОргане = ?(НомерСубконто > 0, 
				СтрокаТаблицы["Субконто" + НомерСубконто], Неопределено);
		КонецЕсли;
		
		НомерСубконто  = НомерВидаСубконтоНаСчете(СвойстваСчета, "УровниБюджетов");
		УровеньБюджета = ?(НомерСубконто > 0, СтрокаТаблицы["Субконто" + НомерСубконто], Неопределено);
		СтрокаТаблицы.ВидНалога = РасчетыСБюджетом.ВидНалогаПоСчетуУчета(
			СтрокаТаблицы.СчетУчета, Организация, ДатаОстатков, УровеньБюджета);
		СтрокаТаблицы.Налог = Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(СтрокаТаблицы.ВидНалога);
		СтрокаТаблицы.ВидНалоговогоОбязательства = ВидНалоговогоОбязательстваПоАналитикеПлатежа(СтрокаТаблицы);
		
	КонецЦикла;
	
КонецПроцедуры

Функция НоваяТаблицаПлатежей() Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СчетУчета", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	Результат.Колонки.Добавить("Субконто1", Метаданные.ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Тип);
	Результат.Колонки.Добавить("Субконто2", Метаданные.ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Тип);
	Результат.Колонки.Добавить("Субконто3", Метаданные.ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Тип);
	Результат.Колонки.Добавить("ВидНалога", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыНалогов"));
	Результат.Колонки.Добавить("Налог",     Новый ОписаниеТипов("СправочникСсылка.ВидыНалоговИПлатежейВБюджет"));
	Результат.Колонки.Добавить("Сумма",     ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	Результат.Колонки.Добавить("РегистрацияВНалоговомОргане", Новый ОписаниеТипов("СправочникСсылка.РегистрацииВНалоговомОргане"));
	Результат.Колонки.Добавить("ВидНалоговогоОбязательства",  Новый ОписаниеТипов("ПеречислениеСсылка.ВидыПлатежейВГосБюджет"));
	Результат.Колонки.Добавить("НалоговыйПериод", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОстаткиНаСчетах68и69(Организация, НаДату) Экспорт
	
	Субсчета68и69 = Новый Массив;
	Субсчета68и69.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНалогам);                // 68
	Субсчета68и69.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоСоциальномуСтрахованию); // 69
	Субсчета68и69 = БухгалтерскийУчет.СформироватьМассивСубсчетов(Субсчета68и69);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГраницаОстатков", Новый Граница(КонецДня(НаДату), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",     Организация);
	Запрос.УстановитьПараметр("Субсчета68и69",   Субсчета68и69);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозрасчетныйОстатки.Счет КАК СчетУчета,
	|	ХозрасчетныйОстатки.Счет.Код КАК СчетКод,
	|	ХозрасчетныйОстатки.Субконто1,
	|	ХозрасчетныйОстатки.Субконто2,
	|	ХозрасчетныйОстатки.Субконто3,
	|	-ХозрасчетныйОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&ГраницаОстатков, Счет В (&Субсчета68и69), , Организация = &Организация) КАК ХозрасчетныйОстатки
	|ГДЕ
	|	ХозрасчетныйОстатки.СуммаОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетКод";
	
	Остатки = Запрос.Выполнить().Выгрузить();
	
	Платежи = НоваяТаблицаПлатежей();
	Для каждого СтрокаТаблицы Из Остатки Цикл
		НоваяСтрока = Платежи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;
	ЗаполнитьВидыНалогов(Платежи, Организация, НаДату);
	
	Возврат Платежи;
	
КонецФункции

Функция НомерВидаСубконтоНаСчете(СвойстваСчета, ИмяВидаСубконто)
	
	ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные[ИмяВидаСубконто];
	Если СвойстваСчета.ВидСубконто1 = ВидСубконто Тогда
		Возврат 1;
	ИначеЕсли СвойстваСчета.ВидСубконто2 = ВидСубконто Тогда
		Возврат 2;
	ИначеЕсли СвойстваСчета.ВидСубконто3 = ВидСубконто Тогда
		Возврат 3;
	Иначе
		Возврат 0;
	КонецЕсли;

КонецФункции

Функция ВидНалоговогоОбязательстваПоАналитикеПлатежа(СтрокаТаблицыПлатежей)
	
	НомерСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НомерСубконто(СтрокаТаблицыПлатежей.СчетУчета,
		ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет);
	Если НомерСубконто <> 0 Тогда
		ВидНалоговогоОбязательства = СтрокаТаблицыПлатежей["Субконто" + НомерСубконто]
	Иначе
		ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВидНалоговогоОбязательства;
	
КонецФункции

#КонецОбласти

#КонецЕсли