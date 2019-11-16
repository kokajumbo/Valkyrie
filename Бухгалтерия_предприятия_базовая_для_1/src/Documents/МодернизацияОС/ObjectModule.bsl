#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	// Специфические для конкретного документа действия
	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.Модернизация);
	КонецЕсли;

	СчетаУчета = БухгалтерскийУчетПереопределяемый.СчетаУчетаОбъектовСтроительства(Организация, ОбъектСтроительства);
	Если НЕ ЗначениеЗаполнено(СчетУчетаВнеоборотногоАктива) Тогда
		СчетУчетаВнеоборотногоАктива = СчетаУчета.СчетУчета;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ,РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.МодернизацияОС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ

	УчетОС.ПроверитьСоответствиеОСОрганизации(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС,
		Отказ);

	УчетОС.ПроверитьСостояниеОСПринятоКУчету(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС,
		Отказ);

	УчетОС.ПроверитьСоответствиеМестонахожденияОС(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС,
		Отказ);

	УчетОС.ПроверитьЗаполнениеСчетаУчетаОС(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС,
		Отказ);

	ТаблицыИзмененияПараметровАмортизацииОС = УчетОС.ПодготовитьТаблицыИзмененияПараметровАмортизацииОС(
		ПараметрыПроведения.ПараметрыАмортизацииОСТаблица,
		ПараметрыПроведения.ПараметрыАмортизацииОС,
		Отказ);
		
	ТаблицаОплатОСДляУСН = Документы.МодернизацияОС.ПодготовитьТаблицуОплатДляУСН(
		ПараметрыПроведения.ТаблицаОСДляУСН,
		ПараметрыПроведения.ОплатыОСдляУСНСвернутая,
		Отказ);
		
	// Учет доходов и расходов ИП
	ТаблицаМодернизацииОСИП	= УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуМодернизацииОС(
		ПараметрыПроведения.МодернизацияОСТаблица,
		ПараметрыПроведения.МодернизацияОС);

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	УчетОС.СформироватьДвиженияРегистрацияСобытияОС(
		ПараметрыПроведения.СобытияОСТаблица,
		ПараметрыПроведения.СобытияОС,
		Движения, Отказ);

	УчетОС.СформироватьДвиженияИзмененияПараметровАмортизацииОСБУ(
		ТаблицыИзмененияПараметровАмортизацииОС.БухгалтерскийУчет,
		ПараметрыПроведения.ПараметрыАмортизацииОС,
		Движения, Отказ);
		
	УчетОС.СформироватьДвиженияИзменениеПараметровАмортизацииОСНУ(
		ТаблицыИзмененияПараметровАмортизацииОС.НалоговыйУчет,
		ПараметрыПроведения.ПараметрыАмортизацииОС,
		Движения, Отказ);
	
	УчетОС.СформироватьДвиженияМодернизацияОС(
		ПараметрыПроведения.МодернизацияОСТаблица,
		ПараметрыПроведения.МодернизацияОС,
		Движения, Отказ);

	УчетОС.СформироватьДвиженияОплатыОСДляУСН(
		ТаблицаОплатОСДляУСН,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);
		
	//Учет НДС
	УчетНДСРаздельный.СформироватьДвиженияМодернизацияОС(
		ПараметрыПроведения.ОбъектыСтроительстваНДС,
		ПараметрыПроведения.ТаблицаСписанныеОбъектыСтроительстваНДС,
		ПараметрыПроведения.РеквизитыНДС,
		Движения, Отказ);
		
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияМодернизацияОС(
		ТаблицаМодернизацииОСИП,
		ПараметрыПроведения.МодернизацияОС, Движения, Отказ);
		
	УчетДоходовИРасходовПредпринимателя.РегистрацияСведенийОбОплатеОСиНМА(
		ТаблицаМодернизацииОСИП,
		ПараметрыПроведения.МодернизацияОС, Движения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если ОС.Итог("СуммаКапитальныхВложенийВключаемыхВРасходыНУ") = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаЗатратПоАмортизационнойПремии");
	КонецЕсли;

	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

	// Проверим что суммы модернизации относимые на каждый объект ОС в сумме равны данным из шапки документа
	Если ОС.Итог("СуммаМодернизацииБУ") <> СтоимостьБУ Тогда
		МетаданныеТабличнойЧасти = Метаданные().ТабличныеЧасти.ОС;
		ШаблонСообщения = НСтр("ru = 'Итог по колонке ""%1"" отличается от значения поля ""%2""!'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			МетаданныеТабличнойЧасти.Реквизиты.СуммаМодернизацииБУ.Представление(),
			Метаданные().Реквизиты.СтоимостьБУ.Представление());
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("СПИСОК", "КОРРЕКТНОСТЬ", , ,
			МетаданныеТабличнойЧасти.Представление(), ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОС", , Отказ);
	КонецЕсли;

	УСН = УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, Дата);
	УСНДоходы = УчетнаяПолитика.ПрименяетсяУСНДоходы(Организация, Дата);

	Если УСН Тогда
		Если НЕ УСНДоходы Тогда
			// Проверим что суммы модернизации относимые на каждый объект ОС в сумме равны данным из шапки документа
			Если ОС.Итог("СуммаМодернизацииУСН") <> СтоимостьУСН Тогда
				МетаданныеТабличнойЧасти = Метаданные().ТабличныеЧасти.ОС;
				ШаблонСообщения = НСтр("ru = 'Итог по колонке ""%1"" (%2) отличается от значения поля ""%3"" (%4)!'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
					МетаданныеТабличнойЧасти.Реквизиты.СуммаМодернизацииУСН.Представление(),
					Формат(ОС.Итог("СуммаМодернизацииУСН"), "ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=' '; ЧГ=3,0"),
					Метаданные().Реквизиты.СтоимостьУСН.Представление(),
					Формат(СтоимостьУСН, "ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=' '; ЧГ=3,0"));
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("СПИСОК", "КОРРЕКТНОСТЬ", , ,
					МетаданныеТабличнойЧасти.Представление(), ТекстСообщения);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОС", , Отказ);
			КонецЕсли;
		КонецЕсли;
	Иначе
		// Проверим что суммы модернизации относимые на каждый объект ОС в сумме равны данным из шапки документа
		// Не забыть, что колонка СуммаМодернизацииНУ не всегда видна
		Если УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата)
			Или УчетнаяПолитика.ПлательщикНДФЛ(Организация, Дата) Тогда
			Если ОС.Итог("СуммаМодернизацииНУ") <> СтоимостьНУ Тогда
				МетаданныеТабличнойЧасти = Метаданные().ТабличныеЧасти.ОС;
				ШаблонСообщения = НСтр("ru = 'Итог по колонке ""%1"" отличается от значения поля ""%2""!'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
					МетаданныеТабличнойЧасти.Реквизиты.СуммаМодернизацииНУ.Представление(),
					Метаданные().Реквизиты.СтоимостьНУ.Представление());
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("СПИСОК", "КОРРЕКТНОСТЬ", , ,
					МетаданныеТабличнойЧасти.Представление(), ТекстСообщения);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОС", , Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	РаздельныйУчетНДСНаСчете19	= УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата);
	Если НЕ РаздельныйУчетНДСНаСчете19 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СпособУчетаНДС");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если Дата < '20080101' Тогда
		Оплата.Очистить();
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда

		Если Основание.ЭтоГруппа Тогда

			ТекстСообщения = НСтр("ru = 'Ввод Модернизации ОС на основании группы ОС невозможен!
				|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз'");
			ВызватьИсключение(ТекстСообщения);

		КонецЕсли;

		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЕСТЬNULL(ПервоначальныеСведенияОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация
			|ИЗ
			|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
			|		&Дата,
			|		ОсновноеСредство = &ОсновноеСредство
			|	) КАК ПервоначальныеСведенияОС
			|";
		Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДатаСеанса()));
		Запрос.УстановитьПараметр("ОсновноеСредство", Основание);
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Организация = Выборка.Организация;
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли