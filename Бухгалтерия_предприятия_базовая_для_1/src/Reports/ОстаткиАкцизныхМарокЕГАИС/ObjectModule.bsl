
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - Настройки общей формы отчета (для изменения).
//       См. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры



// Возвращает индекс варианта отчета основной схемы компоновки данных, используемого для получения таблицы расхождений
//   для последующей обработки без вспомогательных колонок, иерархии и оформления
// 
// Возвращаемое значение:
//   Число - индекс варианта отчета для получения таблицы расхождений
//
Функция ИндексВариантаРасхождений() Экспорт
	
	Возврат 1;
	
КонецФункции

	
#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Булево - Признак отказа от создания формы.
//      См. описание одноименного параметра "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//   СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//      См. описание одноименного параметра "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
// См. также:
//   Процедура для вывода добавленных команд в форму: ОтчетыСервер.ВывестиКоманду().
//   Глобальный обработчик этого события: ОтчетыПереопределяемый.ПриСозданииНаСервере().
//
// Пример добавления команды:
//    Команда = Форма.Команды.Добавить("<ИмяКоманды>");
//    Команда.Действие  = "Подключаемый_Команда";
//    Команда.Заголовок = НСтр("ru = '<Представление команды...>'");
//    ОтчетыСервер.ВывестиКоманду(Форма, Команда, "<ВидГруппы>");
// Обработчик команды пишется в процедуре ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Команда = Форма.Команды.Добавить("ЗапроситьВыделенныеДанные");
	Команда.Действие  = "Подключаемый_Команда";
	Команда.Заголовок = НСтр("ru = 'Запросить из ЕГАИС'");
	
	Кнопка = Форма.Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), Форма.Элементы.ОтчетТабличныйДокументКонтекстноеМеню);
	Кнопка.ИмяКоманды = Команда.Имя;
	
	Форма.ПостоянныеКоманды.Добавить(Команда.Имя);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиОтчета.ДополнительныеСвойства.Вставить("ИмяОтчета", ЭтотОбъект.Метаданные().Имя);
	
	ВнешниеНаборыДанных = Неопределено;
	ОтчетыЕГАИС.ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли