
#Область ОписаниеПеременных

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ИнтервалПроверкиРезультата;

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	РежимРасшифровки = Параметры.РежимРасшифровки;
	
	Если РежимРасшифровки Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	// Установка настроек печати по умолчанию.
	// Если настройки были изменены, они будут загружены при формировании отчета.
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Результат.АвтоМасштаб        = Истина;
	
	ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);
	
	УчетНДСПереопределяемый.ФормаОтчетаПриСозданииНаСервере(ЭтотОбъект);
	
	ОбщегоНазначенияБПВызовСервера.ЗаполнитьСписокОрганизаций(Элементы.ПолеОрганизация, СоответствиеОрганизаций);
	
	УправлениеФормой(ЭтаФорма);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереОтчет(ЭтотОбъект, Истина);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Отчет.КнигаПокупок",
		"ФормаОтчета",
		НСтр("ru='Новости: книга покупок'"),
		ИдентификаторыСобытийПриОткрытии);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если ОбщегоНазначенияБПКлиент.ПроверитьНаличиеОрганизаций() Тогда
		
		// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
		ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
		// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОтчетПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	Если РежимРасшифровки Тогда
		СформироватьОтчетНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)

	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)

	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);

	ОбновитьТекстЗаголовка(ЭтаФорма);
	ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);
	
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьДополнительныеЛистыПриИзменении(Элемент)

	Если НЕ Отчет.ФормироватьДополнительныеЛисты И Отчет.ВыводитьТолькоДопЛисты Тогда
		Отчет.ВыводитьТолькоДопЛисты = Ложь;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбораЛистаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ЭлементСписка = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	Если ЭлементСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбораЛиста = ЭлементСписка.Представление;

	ПоказатьВыбранныйЛист(ЭлементСписка.Значение);

	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаИспользуетсяВРазделеОтчета = НомераРазделовДопЛистов.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено;
	ПроверкаКонтрагентовКлиентСервер.ВывестиНужнуюПанельПроверкиКонтрагентовВОтчете(ЭтотОбъект, ПроверкаИспользуетсяВРазделеОтчета);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЛистыЗаТекущийПериодПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьТолькоДопЛистыПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПокупателейПоАвансамПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентДляОтбораПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппироватьПоКонтрагентамПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		Оповещение = Новый ОписаниеОповещения("ВыборСчетФактурыЗавершение", ЭтотОбъект);
		Расшифровка.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите счет-фактуру'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетНаКлиенте()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	ИначеЕсли НЕ РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда 
		// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВОтчете(ЭтотОбъект);
		// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		БухгалтерскийУчетКлиентПереопределяемый.ПодключитьПроверкуАктуальности(ЭтотОбъект);
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе
		СкрытьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
		
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода,ВыборКварталов",
		Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц",
		ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.Актуализировать(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОтменитьАктуализацию(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНажатие(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПараметрыАктуализации = ЗакрытиеМесяцаКлиентСервер.НовыйПараметрыАктуализацииОтчета();
	ПараметрыАктуализации.Вставить("Организация",                       Отчет.Организация);
	ПараметрыАктуализации.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыАктуализации.Вставить("ДатаАктуальности",                  ДатаАктуальности);
	ПараметрыАктуализации.Вставить("ДатаОкончанияАктуализации",         Отчет.КонецПериода);

	ЗакрытиеМесяцаКлиент.ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтотОбъект,
		ПараметрыАктуализации);
	
	КонецПроцедуры
	
&НаКлиенте
Процедура Выгрузить(Команда)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НалоговыйПериод",                 Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("Организация",                     Отчет.Организация);
	ПараметрыОтчета.Вставить("ФормироватьКнигуПокупок",         Истина);
	ПараметрыОтчета.Вставить("ФормироватьДопЛистыКнигиПокупок", Истина);
	
	ВыгружаемыеДанные = ВыгрузитьНаСервере(ПараметрыОтчета);
	
	УчетНДСКлиент.СохранитьФайлВыгрузкиНаКлиенте(ВыгружаемыеДанные);
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)

	Отчет = Форма.Отчет;

	ЗаголовокОтчета = НСтр("ru='Книга покупок'")
					+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода,
																				 Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета
						+ " "
						+ БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация,
																			Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;

	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;

	Элементы.ДополнительныеЛистыЗаТекущийПериод.Доступность = Отчет.ФормироватьДополнительныеЛисты;
	Элементы.ВыводитьТолькоДопЛисты.Доступность             = Отчет.ФормироватьДополнительныеЛисты;

КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере()

	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередФормированиемОтчета(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(Истина);
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		УчетНДСПереопределяемый.ПодготовитьПараметрыКнигиПокупок(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"УчетНДСПереопределяемый.ПодготовитьПараметрыКнигиПокупок",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ЗапомнитьРезультатФормированияОтчета(ЭтотОбъект, РезультатВыполнения, АдресХранилища);
	РазделыОтчета = ПроверкаКонтрагентов.РазделыОтчетаВФорме(ЭтотОбъект, РезультатВыполнения, Ложь);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	Элементы.СписокВыбораЛиста.СписокВыбора.Очистить();
	НомераРазделовДопЛистов.Очистить();
	
	Если РазделыОтчета.Количество() > 0 Тогда
		Для Каждого СтрокаРаздела Из РазделыОтчета Цикл
			Элементы.СписокВыбораЛиста.СписокВыбора.Добавить(СтрокаРаздела.НомерРаздела, СтрокаРаздела.НазваниеРаздела);
			
			// Запомним номера разделов, в которых расположены доп.листы.
			// Для них не выполняется проверка контрагентов и не показываются соответствующие элементы на форме.
			Если ТипЗнч(СтрокаРаздела.ДополнительныеПараметры) = Тип("Структура")
				И СтрокаРаздела.ДополнительныеПараметры.ЭтоДопЛист Тогда
				НомераРазделовДопЛистов.Добавить(СтрокаРаздела.НомерРаздела);
			КонецЕсли;
		КонецЦикла;

		СписокВыбораЛиста = РазделыОтчета[0].НазваниеРаздела;
		Если РазделыОтчета.Количество() = 1 Тогда
			Элементы.СписокВыбораЛиста.Видимость = Ложь;
		Иначе
			Элементы.СписокВыбораЛиста.Видимость = Истина;
		КонецЕсли;
		
		ПоказатьВыбранныйЛист(РазделыОтчета[0].НомерРаздела);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("СписокСообщений") Тогда
		Для Каждого Сообщение Из РезультатВыполнения.СписокСообщений Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение.Значение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьВыбранныйЛист(НомерРаздела)

	Результат.Очистить();

	ТекущийНомерРаздела = НомерРаздела;

	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ВывестиРазделОтчета(ЭтотОбъект, Результат, ТекущийНомерРаздела);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		
	Результат.ЧерноБелаяПечать = Истина;
	
	РассчитатьОбластьПечати();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ИдентификаторЗадания = Неопределено;
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
			
			// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
			ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВОтчете(ЭтотОбъект);
			// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
			БухгалтерскийУчетКлиентПереопределяемый.ПодключитьПроверкуАктуальности(ЭтотОбъект);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыИзПараметровФормы(Форма)
	
	ПараметрыЗаполненияФормы = Неопределено;
	
	Если Форма.Параметры.Свойство("ПараметрыЗаполненияФормы",ПараметрыЗаполненияФормы) Тогда
		ЗаполнитьЗначенияСвойств(Форма.Отчет,ПараметрыЗаполненияФормы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыборСчетФактурыЗавершение(ЭлементВыбора, ДополнительныеПараметры) Экспорт
	
	Если ЭлементВыбора <> Неопределено Тогда
		ПоказатьЗначение( , ЭлементВыбора.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбработатьВыборПериодаНаСервере();
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПроверкаКонтрагентовКлиентСервер.СброситьАктуальностьОтчета(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборПериодаНаСервере()
	
	УчетНДСПереопределяемый.ФормаОтчетаОбработатьВыборПериода(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолеОрганизация <> "" Тогда
		Если НЕ СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", НСтр("ru = 'Организация'"), , ,);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПолеОрганизация", , Отказ);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета(ЭтоПервоеФормированиеОтчета) Экспорт

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                       , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                     , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                      , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ФормироватьДополнительныеЛисты"    , Отчет.ФормироватьДополнительныеЛисты);
	ПараметрыОтчета.Вставить("ДополнительныеЛистыЗаТекущийПериод", Отчет.ДополнительныеЛистыЗаТекущийПериод);
	ПараметрыОтчета.Вставить("ГруппироватьПоКонтрагентам"        , Отчет.ГруппироватьПоКонтрагентам);
	ПараметрыОтчета.Вставить("КонтрагентДляОтбора"               , Отчет.КонтрагентДляОтбора);
	ПараметрыОтчета.Вставить("ВыводитьТолькоДопЛисты"            , Отчет.ВыводитьТолькоДопЛисты);
	ПараметрыОтчета.Вставить("ВыводитьПокупателейПоАвансам"      , Отчет.ВыводитьПокупателейПоАвансам);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения" , Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("СформироватьОтчетПоСтандартнойФорме");
	ПараметрыОтчета.Вставить("ОтбиратьПоКонтрагенту", ЗначениеЗаполнено(Отчет.КонтрагентДляОтбора));
	ПараметрыОтчета.Вставить("СписокОрганизаций");
	ПараметрыОтчета.Вставить("ДатаФормированияДопЛиста"); 
	ПараметрыОтчета.Вставить("ЗаполнениеДокумента",  Ложь);
	ПараметрыОтчета.Вставить("ЗаполнениеДекларации", Ложь);
	ПараметрыОтчета.Вставить("ФормироватьТабличныйДокумент", Истина);
	ПараметрыОтчета.Вставить("ЭтоКнигаПокупок", Истина);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ДобавитьПараметрыДляПроверкиКонтрагентов(ЭтотОбъект, ПараметрыОтчета, 
		ЭтоПервоеФормированиеОтчета);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура РассчитатьОбластьПечати()

	ПерваяСтрока = 1;
	
	Результат.ОбластьПечати = Результат.Область(ПерваяСтрока,1,Результат.ВысотаТаблицы, Результат.ШиринаТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьАктуальность()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьАктуальность(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "СформироватьОтчет" Тогда
		
		БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
		Активизировать();
		СформироватьОтчет("");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыгрузитьНаСервере(ПараметрыОтчета)
	
	Результат = УчетНДС.СформироватьДокументыОтчетности(ПараметрыОтчета);
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЭлектронныеКниги = Результат.СозданныеДокументы;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЭлектронныеКниги, Результат.ПерезаполненныеДокументы);
	
	ВыгружаемыеДанные = Новый Массив;
	
	Для каждого ЭлектроннаяКнига Из ЭлектронныеКниги Цикл
		
		КнигаОбъект = ЭлектроннаяКнига.ПолучитьОбъект();
		ФайлыВыгрузки = КнигаОбъект.ВыгрузитьДокумент();
		ВыгружаемыеДанные.Добавить(ФайлыВыгрузки[0]);
		
	КонецЦикла;
	
	Возврат ВыгружаемыеДанные;
	
КонецФункции

#Область ПроверкаКонтрагентов

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ПроверитьКонтрагентов() Экспорт
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(Ложь);
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВОтчете(ЭтотОбъект, ПараметрыОтчета);
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВОтчете(ЭтотОбъект, Результат, Неопределено, ТекущийНомерРаздела);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура ПереключательРежимаОтображенияПриИзменении(Элемент)
	ПереключитьРежимОтображенияОтчета();
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

&НаСервере
Процедура ПереключитьРежимОтображенияОтчета()
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПереключитьРежимОтображенияРазделаОтчета(ЭтотОбъект, Результат, ТекущийНомерРаздела);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

#КонецОбласти
