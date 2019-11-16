#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ

Процедура УстановитьПроведен(ПараметрыОтложенногоОбновления = Неопределено) Экспорт
	
	ОбновлениеСПредыдущейРедакции.УстановитьПроведен(Метаданные.Документы.ПлатежноеТребование, ПараметрыОтложенногоОбновления);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Платежное требование
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПлатежноеТребование";
	КомандаПечати.Представление = НСтр("ru = 'Платежное требование'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Платежное требование""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

// Формирует и возвращает текст запроса для выборки данных,
// необходимых для формирования печатной формы
Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыПлатежногоТребования()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПлатежноеТребование.Ссылка,
	|	ПлатежноеТребование.Номер,
	|	ПлатежноеТребование.Дата КАК ДатаВыписки,
	|	ПлатежноеТребование.Организация,
	|	ПлатежноеТребование.СчетОрганизации,
	|	ПлатежноеТребование.СчетОрганизации.МесяцПрописью КАК МесяцПрописью,
	|	ПлатежноеТребование.СчетОрганизации.СуммаБезКопеек КАК СуммаБезКопеек,
	|	ПлатежноеТребование.Контрагент,
	|	ПлатежноеТребование.СчетКонтрагента,
	|	ПлатежноеТребование.СуммаДокумента,
	|	ПлатежноеТребование.ДатаОтсылкиДокументов,
	|	ПлатежноеТребование.ВалютаДокумента,
	|	ПлатежноеТребование.ВидПлатежа,
	|	ПлатежноеТребование.ОчередностьПлатежа,
	|	ПлатежноеТребование.СрокДляАкцепта,
	|	ВЫБОР ПлатежноеТребование.ВидАкцепта
	|		КОГДА 1
	|			ТОГДА ""1""
	|		ИНАЧЕ ""2""
	|	КОНЕЦ КАК УсловиеОплаты,
	|	ПлатежноеТребование.НазначениеПлатежа КАК НазначениеПлатежа
	|ИЗ
	|	Документ.ПлатежноеТребование КАК ПлатежноеТребование
	|ГДЕ
	|	ПлатежноеТребование.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПлатежноеТребование.Дата,
	|	ПлатежноеТребование.Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Формирует печатную форму 
// платежного требования
//
// Параметры:
//  ТабДок - табличный документ
//
Функция ПечатьПлатежногоТребования(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеТребование_ПлатежноеТребование";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыПлатежногоТребования();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		ЕстьОшибки = Ложь;
		НомерПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер, Истина, Истина);
		
		Если Прав(НомерПечать, 3) = "000" И Выборка.ДатаВыписки < '20120709' Тогда
			ТекстСообщения = НСтр("ru = 'Номер платежного требования не может оканчиваться на ""000""!
				|(Приложение 12 к Положению Банка России ""О безналичных расчетах в Российской Федерации""
				|от 3 октября 2002 г. No. 2-П в ред. Указания ЦБ РФ от 03.03.2003 No. 1256-У)'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Выборка.Ссылка);
			Возврат Неопределено;
		КонецЕсли;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПлатежноеТребование.ПФ_MXL_ПлатежноеТребование");
		Обл = Макет.ПолучитьОбласть();
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Обл.Параметры.Заполнить(Выборка);
		
		АвтоЗначенияРеквизитов = УчетДенежныхСредствБП.СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(
			Выборка.Контрагент, Выборка.СчетКонтрагента, Выборка.Организация, Выборка.СчетОрганизации, Ложь);
		Обл.Параметры.Заполнить(АвтоЗначенияРеквизитов);
		
		Обл.Параметры.НаименованиеНомер = "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № " + НомерПечать;
		
		МесяцПрописью = Выборка.МесяцПрописью;
		ФорматДаты    = "ДФ=" + ?(ЗначениеЗаполнено(МесяцПрописью) И МесяцПрописью, "'дд ММММ гггг'", "'дд.ММ.гггг'");
		
		Обл.Параметры.ДатаДокумента = Формат(Выборка.ДатаВыписки, ФорматДаты);
		
		// Сумма платежного документа
		
		СуммаБезКопеек  = ЗначениеЗаполнено(Выборка.СуммаБезКопеек) И Выборка.СуммаБезКопеек;
		Обл.Параметры.СуммаЧислом   = УчетДенежныхСредствБП.ФорматироватьСуммуПлатежногоДокумента(
			Выборка.СуммаДокумента, СуммаБезКопеек);
		Обл.Параметры.СуммаПрописью = УчетДенежныхСредствБП.ФорматироватьСуммуПрописьюПлатежногоДокумента(
			Выборка.СуммаДокумента, Выборка.ВалютаДокумента, СуммаБезКопеек);
		
		Обл.Параметры.ИННПлательщика = "ИНН " + Обл.Параметры.ИННПлательщика;
		Обл.Параметры.ИННПолучателя  = "ИНН " + Обл.Параметры.ИННПолучателя;
		
		ТабличныйДокумент.Вывести(Обл);
		
		// В табличном документе зададим имя области, в которую был
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатьПлатежногоПоручения()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета ПлатежноеПоручение формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПлатежноеТребование") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПлатежноеТребование", "Платежное требование",
			ПечатьПлатежногоТребования(МассивОбъектов, ОбъектыПечати),, "Документ.ПлатежноеТребование.ПФ_MXL_ПлатежноеТребование");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
	
	ПолеЗапросаНазначениеПлатежа =
	"ВЫБОР
	|		КОГДА Таб.НазначениеПлатежа = """"
	|			ТОГДА Таб.Контрагент
	|		КОГДА Таб.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА Таб.НазначениеПлатежа
	|		ИНАЧЕ ПОДСТРОКА(Таб.Контрагент.Наименование, 1, 100) + "" / "" + ПОДСТРОКА(Таб.НазначениеПлатежа, 1, 210)
	|	КОНЕЦ";
	
	Результат.Вставить("Информация", ПолеЗапросаНазначениеПлатежа);
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
