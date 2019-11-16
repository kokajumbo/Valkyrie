#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ИнтерфейсТаксиПростой") Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидФормы = "ФормаСписка" И Параметры.Свойство("ТекущаяСтрока") И ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		СтандартнаяОбработка = Ложь;
		Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("ДокументСсылка.СписаниеСРасчетногоСчета")
			ИЛИ ТипЗнч(Параметры.ТекущаяСтрока) = Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет") Тогда
			ВыбраннаяФорма = "БанковскиеВыписки";
		Иначе
			ВыбраннаяФорма = "КассовыеДокументы";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр банковских документов'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "БанковскиеВыписки";
	КомандаПечати.Порядок        = 100;
	
	// Печать кассовых ордеров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КассовыйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Кассовый ордер'");
	КомандаПечати.Обработчик    = "УчетДенежныхСредствКлиент.ВыполнитьКомандуПечатиКассовыйОрдер";
	КомандаПечати.СписокФорм    = "КассовыеДокументы";
	КомандаПечати.ФункциональныеОпции = "ИспользуетсяКассоваяКнига";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр кассовых документов'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "КассовыеДокументы";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
	
	ПолеЗапросаСумма =
	"	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПоступлениеНаРасчетныйСчет)
	|			ТОГДА Таб.Доход
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.СписаниеСРасчетногоСчета)
	|			ТОГДА Таб.Расход
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПриходныйКассовыйОрдер)
	|			ТОГДА Таб.Доход
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.РасходныйКассовыйОрдер)
	|			ТОГДА Таб.Расход
	|		ИНАЧЕ 0
	|	КОНЕЦ";
	
	ПолеЗапросаИнформация =
	"ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПриходныйКассовыйОрдер)
	|			ИЛИ ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.РасходныйКассовыйОрдер)
	|			ТОГДА Таб.Контрагент
	|		КОГДА Таб.НазначениеПлатежа = """"
	|			ТОГДА Таб.Контрагент
	|		КОГДА Таб.Контрагент = НЕОПРЕДЕЛЕНО
	|			ТОГДА Таб.НазначениеПлатежа
	|		КОГДА Таб.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА Таб.НазначениеПлатежа
	|		ИНАЧЕ ПОДСТРОКА(Таб.Контрагент.Наименование, 1, 100) + "" / "" + ПОДСТРОКА(Таб.НазначениеПлатежа, 1, 210)
	|	КОНЕЦ";
	
	Результат.Вставить("Информация",      ПолеЗапросаИнформация);
	Результат.Вставить("СуммаДокумента",  ПолеЗапросаСумма);
	Результат.Вставить("ВалютаДокумента", "Валюта");
	
	Возврат Результат;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Не УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Реестр");
	
	// Проверяем, нужно ли для макета ПКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Реестр") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		ВызватьИсключение "Попытка распечатать реестр в комплекте.";
	КонецЕсли;
	
	// Проверяем, нужно ли для макета ПКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПКО") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		Документы.ПриходныйКассовыйОрдер.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РКО") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		Документы.РасходныйКассовыйОрдер.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
