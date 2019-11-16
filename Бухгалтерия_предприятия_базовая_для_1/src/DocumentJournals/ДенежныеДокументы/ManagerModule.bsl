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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

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
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр денежных документов'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
	
	ПолеЗапросаСумма =
	"	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ВыдачаДенежныхДокументов)
	|			ТОГДА Таб.Выдача
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПоступлениеДенежныхДокументов)
	|			ТОГДА Таб.Поступление
	|		ИНАЧЕ 0
	|	КОНЕЦ";
	
	Результат.Вставить("НомерВходящегоДокумента", "НомерВходящегоДокумента");
	Результат.Вставить("ДатаВходящегоДокумента",  "ДатаВходящегоДокумента");
	Результат.Вставить("Информация",     "Контрагент");
	Результат.Вставить("СуммаДокумента",  ПолеЗапросаСумма);
	Результат.Вставить("ВалютаДокумента", "Валюта");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
