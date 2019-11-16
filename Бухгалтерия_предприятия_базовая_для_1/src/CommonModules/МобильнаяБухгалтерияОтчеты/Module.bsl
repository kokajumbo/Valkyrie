
Функция СформироватьОтчет(СтруктураПараметров, СообщениеОбОшибке) Экспорт
	
	СтруктураПараметров = СериализаторXDTO.ПрочитатьXDTO(СтруктураПараметров);
	
	ФорматФайла         = СтруктураПараметров.ФорматФайла;
	Если НРег(ФорматФайла) = ".pdf" Тогда
		ИмяФайла        = ПолучитьИмяВременногоФайла("pdf");
		ФорматПакета    = ТипФайлаПакетаОтображаемыхДокументов.PDF;
		ФорматДокумента = ТипФайлаТабличногоДокумента.PDF;
	ИначеЕсли НРег(ФорматФайла) = ".xlsx" Тогда
		ИмяФайла        = ПолучитьИмяВременногоФайла("xlsx");
		ФорматПакета    = ТипФайлаПакетаОтображаемыхДокументов.XLSX;
		ФорматДокумента = ТипФайлаТабличногоДокумента.XLSX;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	
	ИмяОтчета = СтруктураПараметров.ИмяОтчета;
	Представление = "";
	
	ПечатныеФормыОбъекта        = Неопределено;
	ПакетОтображаемыхДокументов = Новый ПакетОтображаемыхДокументов;
	
	Результат = Новый Структура;
	Результат.Вставить("Вложения"          ,Новый Массив);
	
	Если ИмяОтчета = "КнигаУчетаДоходовИРасходов" Тогда
		ПараметрыОтчета = СтруктураПараметров.ПараметрыОтчета;
		Период = ПараметрыОтчета.Период;
		Организация = МобильнаяБухгалтерия.ДесериализоватьСсылкуНаСправочник(ПараметрыОтчета.Организация, "Организации");
		
		Отчет = Новый Структура();
		Отчет.Вставить("ВыводитьРасшифровки",        Ложь);
		Отчет.Вставить("Организация",                Организация);
		Отчет.Вставить("НачалоПериода",              НачалоГода(Период));
		Отчет.Вставить("КонецПериода",               КонецГода(Период));
		Отчет.Вставить("Период",                     КонецГода(Период));
		Отчет.Вставить("РежимПечатиГраф4и6",         3);
		Отчет.Вставить("РежимПечатиНДС",             2);
		Отчет.Вставить("СписокСформированныхЛистов", Новый СписокЗначений);
		
		МенеджерОтчета = Отчеты.КнигаУчетаДоходовИРасходов;
		// Настройки отчета
		ОписаниеОбъекта = МенеджерОтчета.ОписаниеОбъекта(Отчет);
		МенеджерОтчета.ПолучитьНастройкиОтчета(ОписаниеОбъекта);
		МенеджерОтчета.ЗаполнитьСведенияОНалоговомПериоде(ОписаниеОбъекта);
		
		ПараметрыОтчета = МенеджерОтчета.ПодготовитьПараметрыОтчета(ОписаниеОбъекта);
		
		// Формируем отчет и возвращаем его в виде списка
		МенеджерОтчета.СформироватьОтчет(ПараметрыОтчета);
		ПечатныеФормы = ПараметрыОтчета.СписокСформированныхЛистов;
		Представление = СтрШаблон(НСтр("ru = 'Книга учета доходов и расходов за %1'"), Отчеты.КнигаУчетаДоходовИРасходов.ПолучитьПредставлениеПериода(Отчет.Период, Отчет.КонецПериода));
		
	ИначеЕсли ИмяОтчета = "КнигаУчетаДоходовПатент" Тогда
		ПараметрыОтчета = СтруктураПараметров.ПараметрыОтчета;
		Период = ПараметрыОтчета.Период;
		Организация = МобильнаяБухгалтерия.ДесериализоватьСсылкуНаСправочник(ПараметрыОтчета.Организация, "Организации");
		
		ПечатныеФормы  = Новый СписокЗначений;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Патенты.Ссылка КАК Патент,
		|	Патенты.ДатаНачала КАК НачалоПериода,
		|	КОНЕЦПЕРИОДА(Патенты.ДатаОкончания, ДЕНЬ) КАК КонецПериода
		|ИЗ
		|	Справочник.Патенты КАК Патенты
		|ГДЕ
		|	Патенты.Владелец = &Организация
		|	И НЕ Патенты.ПометкаУдаления
		|	И НАЧАЛОПЕРИОДА(Патенты.ДатаНачала, ГОД) = &Период";
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("Период", НачалоГода(Период));
		ДанныеПатента = Запрос.Выполнить().Выбрать();
		Пока ДанныеПатента.Следующий() Цикл
			Отчет = Новый Структура();
			Отчет.Вставить("Организация",                Организация);
			Отчет.Вставить("Патент",                     ДанныеПатента.Патент);
			Отчет.Вставить("НачалоПериода",              ДанныеПатента.НачалоПериода);
			Отчет.Вставить("КонецПериода",               ДанныеПатента.КонецПериода);
			Отчет.Вставить("СписокСформированныхЛистов", Новый СписокЗначений);
			
			МенеджерОтчета = Отчеты.КнигаУчетаДоходовПатент;
			МенеджерОтчета.СформироватьОтчет(Отчет);
			Для Каждого СформированныйЛист Из Отчет.СписокСформированныхЛистов Цикл
				ПечатныеФормы.Добавить(СформированныйЛист.Значение);
			КонецЦикла;
		КонецЦикла;
		
		Представление = СтрШаблон(НСтр("ru = 'Книга учета доходов по патентам за %1 год'"), Формат(Год(Период), "ЧГ="));
		
	ИначеЕсли ИмяОтчета = "ОборотноСальдоваяВедомостьПоСчету"
		ИЛИ ИмяОтчета = "ОборотноСальдоваяВедомость"
		ИЛИ ИмяОтчета = "Продажи"
		ИЛИ ИмяОтчета = "ПродажиПоМесяцам"
		ИЛИ ИмяОтчета = "ДоходыРасходы"
		ИЛИ ИмяОтчета = "ДвижениеТоваров"
		ИЛИ ИмяОтчета = "ЗадолженностьПокупателей"
		ИЛИ ИмяОтчета = "ЗадолженностьПоставщикам" Тогда
		
		ВходящиеПараметры = Новый Структура;
		ВходящиеПараметры.Вставить("ИмяОтчета",           ИмяОтчета);
		ВходящиеПараметры.Вставить("НачалоПериода",       НачалоМесяца(ТекущаяДата()));
		ВходящиеПараметры.Вставить("КонецПериода",        КонецМесяца(ТекущаяДата()));
		ВходящиеПараметры.Вставить("ПоДоговорам",         Ложь);
		ВходящиеПараметры.Вставить("ГруппСубконто",       1);
		ВходящиеПараметры.Вставить("ПоказательКоличество",Истина);
		ВходящиеПараметры.Вставить("ИмяВариантаНастроек", ""); //ПродажиПоНоменклатуре, ПродажиПоКонтрагентам
		ЗаполнитьЗначенияСвойств(ВходящиеПараметры, СтруктураПараметров);
		
		//Организация и счет
		ВходящиеПараметры.Вставить("Организация", МобильнаяБухгалтерия.ДесериализоватьСсылкуНаСправочник(СтруктураПараметров.Организация, "Организации"));
		Если СтруктураПараметров.Свойство("Счет")
			И ЗначениеЗаполнено(СтруктураПараметров.Счет) Тогда
			Счет = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(СтрШаблон("%1.%2", "ПланСчетов.Хозрасчетный", СтруктураПараметров.Счет));
			ВходящиеПараметры.Вставить("Счет", Счет);
		КонецЕсли;
		
		ПредставлениеПериодаОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			ВходящиеПараметры.НачалоПериода,
			ВходящиеПараметры.КонецПериода);
				
		Если ИмяОтчета = "ОборотноСальдоваяВедомостьПоСчету" Тогда
			ПараметрыОтчета = ПараметрыОСВпоСчету(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Оборотно-сальдовая ведомость по счету %1 %2'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПараметрыОтчета.Счет),
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "ОборотноСальдоваяВедомость" Тогда
			ПараметрыОтчета = ПараметрыОСВ(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Оборотно-сальдовая ведомость %1'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "Продажи" Тогда
			ПараметрыОтчета = ПараметрыПродажи(ВходящиеПараметры);
			Если СтрНайти(ВходящиеПараметры.ИмяВариантаНастроек, "ПоКонтрагентам") > 0 Тогда
				ТекстЗаголовкаОтчета = НСтр("ru = 'Продажи по контрагентам %1'");
			ИначеЕсли СтрНайти(ВходящиеПараметры.ИмяВариантаНастроек, "ПоНоменклатуре") > 0 Тогда
				ТекстЗаголовкаОтчета = НСтр("ru = 'Продажи по номенклатуре %1'");
			Иначе
				ТекстЗаголовкаОтчета = НСтр("ru = 'Продажи %1'");
			КонецЕсли;
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "ПродажиПоМесяцам" Тогда
			//ВходящиеПараметры.НачалоПериода = ДобавитьМесяц(ВходящиеПараметры.НачалоПериода, -12);
			ПараметрыОтчета = ПараметрыПродажиПоМесяцам(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Продажи по месяцам %1'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "ДоходыРасходы" Тогда
			ПараметрыОтчета = ПараметрыДоходыРасходы(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Доходы и расходы %1'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "ДвижениеТоваров" Тогда
			ПараметрыОтчета = ПараметрыДвижениеТоваров(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Движение товаров %1'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "ЗадолженностьПокупателей" Тогда
			ПараметрыОтчета = ПараметрыЗадолженностьПокупателей(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Задолженность покупателей %1'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		ИначеЕсли ИмяОтчета = "ЗадолженностьПоставщикам" Тогда
			ПараметрыОтчета = ПараметрыЗадолженностьПоставщикам(ВходящиеПараметры);
			ТекстЗаголовкаОтчета = НСтр("ru = 'Задолженность поставщикам %1'");
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
		КонецЕсли;
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
		
		ПечатныеФормы  = Новый СписокЗначений;
		ПечатныеФормы.Добавить(РезультатВыполнения.Результат);
		
	КонецЕсли;
	
	
	Для Каждого ПечатнаяФорма Из ПечатныеФормы Цикл
		ПакетОтображаемыхДокументов.Состав.Добавить().Данные = ПоместитьВоВременноеХранилище(ПечатнаяФорма.Значение);
	КонецЦикла;
	
	ПакетОтображаемыхДокументов.Записать(ИмяФайла, ФорматПакета);
	ДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
	УдалитьФайлы(ИмяФайла);
	
	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("Файл"         , ДанныеФайла);
	СтруктураЭлемента.Вставить("Представление", Представление);
	Результат.Вложения.Добавить(СтруктураЭлемента);
	
	Возврат Новый ХранилищеЗначения(Результат, Новый СжатиеДанных(9));
	
КонецФункции

Функция ПараметрыЗадолженностьПокупателей(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты.ЗадолженностьПокупателей.Создать();
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	НоваяСтрока = ТабГруппировка.Добавить();
	НоваяСтрока.Поле           = "Контрагент";
	НоваяСтрока.Использование  = Истина;
	НоваяСтрока.Представление  = "Покупатель";
	НоваяСтрока.ТипГруппировки = 0;
	
	Если ВходящиеПараметры.ПоДоговорам Тогда
		НоваяСтрока = ТабГруппировка.Добавить();
		НоваяСтрока.Поле           = "Договор";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = "Договор";
		НоваяСтрока.ТипГруппировки = 0;
	КонецЕсли;
	
	ИмяВариантаНастроек = ?(ВходящиеПараметры.Свойство("ИмяВариантаНастроек"), ВходящиеПараметры.ИмяВариантаНастроек, ИмяОтчета);
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Отчеты[ИмяОтчета].ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	ПараметрыОтчета.Группировка                       = ТабГруппировка;
	ПараметрыОтчета.ДополнительныеПоля                = ТабДополнительныеПоля;
	
	//ПараметрыОтчета.ВыводитьДиаграмму                 = Истина;
	ПараметрыОтчета.ВыводитьЗаголовок                 = Истина;
	ПараметрыОтчета.ВыводитьПодвал                    = Истина;
	ПараметрыОтчета.РежимРасшифровки                  = Истина;
	ПараметрыОтчета.МакетОформления                   = "МакетОформленияОтчетовЗеленый";
	ПараметрыОтчета.СхемаКомпоновкиДанных             = СхемаКомпоновкиДанных;
	ПараметрыОтчета.ИдентификаторОтчета               = ИмяОтчета;
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Настройки;
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыЗадолженностьПоставщикам(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты.ЗадолженностьПоставщикам.Создать();
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	НоваяСтрока = ТабГруппировка.Добавить();
	НоваяСтрока.Поле           = "Контрагент";
	НоваяСтрока.Использование  = Истина;
	НоваяСтрока.Представление  = "Поставщик";
	НоваяСтрока.ТипГруппировки = 0;
	
	Если ВходящиеПараметры.ПоДоговорам Тогда
		НоваяСтрока = ТабГруппировка.Добавить();
		НоваяСтрока.Поле           = "Договор";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = "Договор";
		НоваяСтрока.ТипГруппировки = 0;
	КонецЕсли;
	
	ИмяВариантаНастроек = ?(ВходящиеПараметры.Свойство("ИмяВариантаНастроек"), ВходящиеПараметры.ИмяВариантаНастроек, ИмяОтчета);
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Отчеты[ИмяОтчета].ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	ПараметрыОтчета.Группировка                       = ТабГруппировка;
	ПараметрыОтчета.ДополнительныеПоля                = ТабДополнительныеПоля;
	
	//ПараметрыОтчета.ВыводитьДиаграмму                 = Истина;
	ПараметрыОтчета.ВыводитьЗаголовок                 = Истина;
	ПараметрыОтчета.ВыводитьПодвал                    = Истина;
	ПараметрыОтчета.РежимРасшифровки                  = Истина;
	ПараметрыОтчета.МакетОформления                   = "МакетОформленияОтчетовЗеленый";
	ПараметрыОтчета.СхемаКомпоновкиДанных             = СхемаКомпоновкиДанных;
	ПараметрыОтчета.ИдентификаторОтчета               = ИмяОтчета;
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Настройки;
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыДвижениеТоваров(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты.ДвижениеТоваров.Создать();
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	НоваяСтрока = ТабГруппировка.Добавить();
	НоваяСтрока.Поле           = "Номенклатура";
	НоваяСтрока.Использование  = Истина;
	НоваяСтрока.Представление  = "Номенклатура";
	НоваяСтрока.ТипГруппировки = 0;
	
	НоваяСтрока = ТабДополнительныеПоля.Добавить();
	НоваяСтрока.Поле           = "Номенклатура.ЕдиницаИзмерения";
	НоваяСтрока.Использование  = Истина;
	НоваяСтрока.Представление  = "Номенклатура.Единица";
			
	ИмяВариантаНастроек = ?(ВходящиеПараметры.Свойство("ИмяВариантаНастроек"), ВходящиеПараметры.ИмяВариантаНастроек, ИмяОтчета);
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Отчеты[ИмяОтчета].ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	ПараметрыОтчета.Группировка                       = ТабГруппировка;
	ПараметрыОтчета.ДополнительныеПоля                = ТабДополнительныеПоля;
	ПараметрыОтчета.ПоказательСумма                   = Ложь;
	ПараметрыОтчета.ПоказательКоличество              = Истина;
	
	//ПараметрыОтчета.ВыводитьДиаграмму                 = Истина;
	ПараметрыОтчета.ВыводитьЗаголовок                 = Истина;
	ПараметрыОтчета.ВыводитьПодвал                    = Истина;
	ПараметрыОтчета.РежимРасшифровки                  = Истина;
	ПараметрыОтчета.МакетОформления                   = "МакетОформленияОтчетовЗеленый";
	ПараметрыОтчета.СхемаКомпоновкиДанных             = СхемаКомпоновкиДанных;
	ПараметрыОтчета.ИдентификаторОтчета               = ИмяОтчета;
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Настройки;
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыДоходыРасходы(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты.ДоходыРасходы.Создать();
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ИмяВариантаНастроек = ?(ВходящиеПараметры.Свойство("ИмяВариантаНастроек"), ВходящиеПараметры.ИмяВариантаНастроек, ИмяОтчета);
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Отчеты[ИмяОтчета].ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	ПараметрыОтчета.Группировка                       = ТабГруппировка;
	ПараметрыОтчета.ДополнительныеПоля                = ТабДополнительныеПоля;
	
	ПараметрыОтчета.ВыводитьДиаграмму                 = Истина;
	ПараметрыОтчета.ВыводитьЗаголовок                 = Истина;
	ПараметрыОтчета.ВыводитьПодвал                    = Истина;
	ПараметрыОтчета.РежимРасшифровки                  = Истина;
	ПараметрыОтчета.МакетОформления                   = "МакетОформленияОтчетовЗеленый";
	ПараметрыОтчета.СхемаКомпоновкиДанных             = СхемаКомпоновкиДанных;
	ПараметрыОтчета.ИдентификаторОтчета               = ИмяОтчета;
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Настройки;
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыПродажиПоМесяцам(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты.ПродажиПоМесяцам.Создать();
	ИмяВариантаНастроек = ?(ВходящиеПараметры.Свойство("ИмяВариантаНастроек"), ВходящиеПараметры.ИмяВариантаНастроек, ИмяОтчета);
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Отчеты[ИмяОтчета].ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	ПараметрыОтчета.ВыводитьДиаграмму                 = Истина;
	ПараметрыОтчета.ВыводитьЗаголовок                 = Истина;
	ПараметрыОтчета.ВыводитьПодвал                    = Истина;
	ПараметрыОтчета.РежимРасшифровки                  = Истина;
	ПараметрыОтчета.МакетОформления                   = "МакетОформленияОтчетовЗеленый";
	ПараметрыОтчета.СхемаКомпоновкиДанных             = СхемаКомпоновкиДанных;
	ПараметрыОтчета.ИдентификаторОтчета               = ИмяОтчета;
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Настройки;
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыПродажи(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты.Продажи.Создать();
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Если СтрНайти(ВходящиеПараметры.ИмяВариантаНастроек, "ПоКонтрагентам") > 0 Тогда
		НоваяСтрока = ТабГруппировка.Добавить();
		НоваяСтрока.Поле           = "Контрагент";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = "Контрагент";
		НоваяСтрока.ТипГруппировки = 0;
	ИначеЕсли СтрНайти(ВходящиеПараметры.ИмяВариантаНастроек, "ПоНоменклатуре") > 0 Тогда
		НоваяСтрока = ТабГруппировка.Добавить();
		НоваяСтрока.Поле           = "Номенклатура";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = "Номенклатура";
		НоваяСтрока.ТипГруппировки = 0;
	КонецЕсли;
			
	ИмяВариантаНастроек = ?(ВходящиеПараметры.Свойство("ИмяВариантаНастроек"), ВходящиеПараметры.ИмяВариантаНастроек, ИмяОтчета);
	
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("СхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Отчеты[ИмяОтчета].ПустыеПараметрыКомпоновкиОтчета();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	ПараметрыОтчета.ПоказательСумма                   = Истина;
	ПараметрыОтчета.Группировка                       = ТабГруппировка;
	ПараметрыОтчета.ДополнительныеПоля                = ТабДополнительныеПоля;
	
	ПараметрыОтчета.ВыводитьДиаграмму                 = Истина;
	ПараметрыОтчета.ВыводитьЗаголовок                 = Истина;
	ПараметрыОтчета.ВыводитьПодвал                    = Истина;
	ПараметрыОтчета.РежимРасшифровки                  = Истина;
	ПараметрыОтчета.МакетОформления                   = "МакетОформленияОтчетовЗеленый";
	ПараметрыОтчета.КлючТекущегоВарианта              = ИмяВариантаНастроек;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = СхемаКомпоновкиДанных;
	ПараметрыОтчета.ИдентификаторОтчета               = ИмяОтчета;
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Настройки;
	
	ПараметрыОтчета.Вставить("ПоказательОпределятьСуммуПоОплате", Ложь);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыОСВ(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Отчет     = Отчеты[ИмяОтчета].Создать();
	
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабРазвернутоеСальдо = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.РазвернутоеСальдо.Реквизиты Цикл
		ТабРазвернутоеСальдо.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("СхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяОтчета);
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , "");
	ПараметрыОтчета.Вставить("НачалоПериода"                    , "");
	ПараметрыОтчета.Вставить("КонецПериода"                     , "");
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Истина);
	ПараметрыОтчета.Вставить("ПоказательНУ"                     , Ложь);
	ПараметрыОтчета.Вставить("ПоказательПР"                     , Ложь);
	ПараметрыОтчета.Вставить("ПоказательВР"                     , Ложь);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Ложь);
	ПараметрыОтчета.Вставить("ПоказательКонтроль"               , Ложь);
	ПараметрыОтчета.Вставить("ВыводитьЗабалансовыеСчета"        , Истина);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , 0);
	ПараметрыОтчета.Вставить("ПоСубсчетам"                      , Истина);
	ПараметрыОтчета.Вставить("Группировка"                      , ТабГруппировка);
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , ТабДополнительныеПоля);
	ПараметрыОтчета.Вставить("РазвернутоеСальдо"                , ТабРазвернутоеСальдо);
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Истина);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , Истина);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , Истина);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , Неопределено);
	ПараметрыОтчета.Вставить("МакетОформления"                  , "ОформлениеОтчетовЗеленый");
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , СхемаКомпоновкиДанных);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , ИмяОтчета);
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Настройки);
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , Ложь);
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПараметрыОСВпоСчету(ВходящиеПараметры)
	
	ИмяОтчета = ВходящиеПараметры.ИмяОтчета;
	Схема = Отчеты[ИмяОтчета].ПолучитьМакет("СхемаКомпоновкиДанных");
	Отчет = Отчеты[ИмяОтчета].Создать();
	
	ЗаполнитьЗначенияСвойств(Отчет, ВходящиеПараметры);
	
	ТабГруппировка = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.Группировка.Реквизиты Цикл
		ТабГруппировка.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	ТабДополнительныеПоля = Новый ТаблицаЗначений;
	Для Каждого Реквизит Из Отчет.Метаданные().ТабличныеЧасти.ДополнительныеПоля.Реквизиты Цикл
		ТабДополнительныеПоля.Колонки.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ВходящиеПараметры.Счет) Тогда
		ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(ВходящиеПараметры.Счет);
		Если ДанныеСчета.КоличествоСубконто > 0 И ВходящиеПараметры.ГруппСубконто > 0 Тогда
			НоваяСтрока = ТабГруппировка.Добавить();
			НоваяСтрока.Поле           = "Субконто1";
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = ДанныеСчета.ВидСубконто1Наименование;
			НоваяСтрока.ТипГруппировки = 0;
		КонецЕсли;
		Если ДанныеСчета.КоличествоСубконто > 1 И ВходящиеПараметры.ГруппСубконто > 1 Тогда
			НоваяСтрока = ТабГруппировка.Добавить();
			НоваяСтрока.Поле           = "Субконто2";
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = ДанныеСчета.ВидСубконто2Наименование;
			НоваяСтрока.ТипГруппировки = 0;
		КонецЕсли;
		Если ДанныеСчета.КоличествоСубконто > 2 И ВходящиеПараметры.ГруппСубконто > 2 Тогда
			НоваяСтрока = ТабГруппировка.Добавить();
			НоваяСтрока.Поле           = "Субконто3";
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = ДанныеСчета.ВидСубконто3Наименование;
			НоваяСтрока.ТипГруппировки = 0;
		КонецЕсли;
		НоваяСтрока = ТабДополнительныеПоля.Добавить();
		НоваяСтрока.Поле           = "Счет.Наименование";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = "Счет.Наименование счета";
	КонецЕсли;
	
	СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
	КоличествоСубконто = СвойстваСчета.КоличествоСубконто;
	
	ИмяПоляПрефикс = "Субконто";
	ПараметрыОС      = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	ПараметрыНМА     = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	ПараметрыФизЛица = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Отчет.КомпоновщикНастроек, "Счет", Отчет.Счет);
	БухгалтерскиеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(Схема, "ДанныеОС"     , ПараметрыОС);
	БухгалтерскиеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(Схема, "ДанныеНМА"    , ПараметрыНМА);
	БухгалтерскиеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(Схема, "ДанныеФизЛица", ПараметрыФизЛица);
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	Настройки = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	ПараметрыОтчета.Вставить("НачалоПериода"                    , НачалоМесяца(ТекущаяДата()));
	ПараметрыОтчета.Вставить("КонецПериода"                     , КонецМесяца(ТекущаяДата()));
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Истина);
	ПараметрыОтчета.Вставить("ПоказательНУ"                     , Ложь);
	ПараметрыОтчета.Вставить("ПоказательПР"                     , Ложь);
	ПараметрыОтчета.Вставить("ПоказательВР"                     , Ложь);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Ложь);
	ПараметрыОтчета.Вставить("ПоказательКоличество"             , Истина);
	ПараметрыОтчета.Вставить("ПоказательКонтроль"               , Ложь);
	ПараметрыОтчета.Вставить("РазвернутоеСальдо"                , Ложь);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , 0);
	ПараметрыОтчета.Вставить("Периодичность"                    , 0);
	ПараметрыОтчета.Вставить("Счет"                             , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ПараметрыОтчета.Вставить("ПоСубсчетам"                      , Истина);
	ПараметрыОтчета.Вставить("Группировка"                      , ТабГруппировка);
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , ТабДополнительныеПоля);
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Ложь);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , Истина);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , Истина);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , Неопределено);
	ПараметрыОтчета.Вставить("МакетОформления"                  , "ОформлениеОтчетовЗеленый");
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , Схема);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , ИмяОтчета);
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Настройки);
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , Ложь);
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ВходящиеПараметры);
	
	Возврат ПараметрыОтчета;
		
КонецФункции
