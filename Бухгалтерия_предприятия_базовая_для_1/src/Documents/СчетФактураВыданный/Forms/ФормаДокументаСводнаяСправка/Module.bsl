&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Объект.КодВидаОперации <> "26" Тогда
		Объект.КодВидаОперации = "26";
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);
		Объект.Дата = НачалоДня(КонецКвартала(Объект.Дата));
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Документ.СчетФактураВыданный",
		"ФормаДокументаСводнаяСправка",
		НСтр("ru='Новости: Счет-фактура выданный'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаДокументыОснования" Тогда
		Модифицированность	= Истина;
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Модифицированность	= Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеСчетФактураВыданныйСводнаяСправка";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПредставлениеДокумента = Документы.СчетФактураВыданный.ПолучитьПредставлениеДокумента(Объект.Ссылка, Объект.ВидСчетаФактуры);

	УстановитьЗаголовокФормы(ЭтаФорма, ПредставлениеДокумента);
	
	УчетНДСКлиентСервер.ДополнитьПараметрыСобытияЗаписьСчетаФактуры(ПараметрыЗаписи);
	ПараметрыЗаписи.ДокументыОснования = ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект.ДокументыОснования, "ДокументОснование", Истина);
	ПараметрыЗаписи.РеквизитыСФ        = УчетНДСВызовСервера.РеквизитыДляНадписиОСчетеФактуреВыданном(ТекущийОбъект.Ссылка);
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УчетНДСКлиентСервер.ДополнитьПараметрыСобытияЗаписьСчетаФактуры(ПараметрыЗаписи); // На 8.2 в web-клиенте ПараметрыЗаписи могут быть не инициализированы
	
	// Обновляем информацию о счете-фактуре в открытых формах документов-оснований
	Оповестить("Запись_СчетФактураВыданный", ПараметрыЗаписи, Объект.Ссылка);
	
	Оповестить("СостояниеРегламентнойОперации", 
		?(Объект.Проведен, ПредопределенноеЗначение("Перечисление.ВидыСостоянийРегламентныхОпераций.Выполнено"), 
						   ПредопределенноеЗначение("Перечисление.ВидыСостоянийРегламентныхОпераций.НеВыполнено")));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Идет актуализация.
	Если ДлительнаяОперация <> Неопределено Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОжидатьАктуализацию", 0.1, Истина);
	КонецЕсли;

	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Проверка на изменение ответственных лиц.
	Если НЕ ТребуетсяВызовСервера Тогда
		Если ТипЗнч(ДатыИзмененияОтветственныхЛиц) = Тип("ФиксированныйМассив") Тогда
		 	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиентСервер.ДатыПринадлежатРазнымИнтервалам(Объект.Дата, 
		 		ТекущаяДатаДокумента, ДатыИзмененияОтветственныхЛиц);
		КонецЕсли;
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОтветственныйПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыОснования

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ДокументыОснования.Количество() <> 0 Тогда
		Если Объект.Проведен Тогда
			ТекстВопроса = НСтр("ru = 'Перед заполнением проведение документа будет отменено, а список документов-основанией будет очищен. Заполнить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Список документов-основанией будет очищен. Заполнить?'");
		КонецЕсли;
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьДокументЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьДокумент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОснование(Команда)
	
	ВыбратьОснование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыИзПараметровФормы(Форма)
	
	ПараметрыЗаполненияФормы = Неопределено;
	
	Если Форма.Параметры.Свойство("ПараметрыЗаполненияФормы", ПараметрыЗаполненияФормы) Тогда
	
		ЗаполнитьЗначенияСвойств(Форма.Объект,ПараметрыЗаполненияФормы);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	ДатыИзмененияОтветственныхЛиц = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Объект.Организация);
	
	ЗаполнитьСписокКодовОпераций();
	
	ПредставлениеДокумента = Документы.СчетФактураВыданный.ПолучитьПредставлениеДокумента(Объект.Ссылка, Объект.ВидСчетаФактуры);
	УстановитьЗаголовокФормы(ЭтаФорма, ПредставлениеДокумента);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	КоличествоОснований = Объект.ДокументыОснования.Количество();
	
	Если КоличествоОснований = 0 Тогда
		Форма.НадписьВыбор = НСтр("ru = 'Выбор'");
	ИначеЕсли КоличествоОснований > 1 Тогда
		Предмет = "документ,документа,документов,м,,,,0";
		Форма.НадписьДокументыОснования = ОбщегоНазначенияБПКлиентСервер.ПредставлениеСсылкиПредмета(
			Предмет, "док", Объект.ДокументыОснования[0].ДокументОснование, КоличествоОснований);
	КонецЕсли;
	
	Элементы.НадписьВыбор.Видимость               = КоличествоОснований = 0;
	Элементы.ГруппаНадписьОдноОснование.Видимость = КоличествоОснований = 1;
	Элементы.НадписьДокументыОснования.Видимость  = КоличествоОснований > 1;
	
	ТекущийКод = Элементы.КодВидаОперации.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда 
		Форма.НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		Форма.НадписьВидОперации = "";
	КонецЕсли;
	
	ЭтоЮрЛицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Объект.Организация);
	
	Элементы.Руководитель.Видимость = Истина;
	Если ЭтоЮрЛицо Тогда
		Элементы.Руководитель.Заголовок = НСтр("ru = 'Руководитель'");
		Элементы.ГлавныйБухгалтер.Видимость = Истина;
	Иначе
		Элементы.Руководитель.Заголовок = НСтр("ru = 'Предприниматель'");
		Элементы.ГлавныйБухгалтер.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
	Объект.Исправление             = Ложь;
	Объект.НомерИсправления        = 0;
	Объект.НомерИсходногоДокумента = "";
	Объект.ДатаИсходногоДокумента  = '00010101';
	Объект.Продавец                = Неопределено;
	
	ЗаполнитьСписокКодовОпераций();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
		Элементы.КодВидаОперации.СписокВыбора,
		Объект.Дата);
		
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	Объект.ДокументОснование	= Неопределено;
	Объект.ДокументыОснования.Очистить();
	Объект.ПлатежноРасчетныеДокументы.Очистить();
	
	УстановитьФункциональныеОпцииФормы();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
	ДатыИзмененияОтветственныхЛиц = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Объект.Организация);
	
	Объект.СуммаДокумента		= 0;
	Объект.СуммаНДСДокумента	= 0;
	Объект.СуммаУвеличение		= 0;
	Объект.СуммаУменьшение		= 0;
	Объект.СуммаНДСУвеличение	= 0;
	Объект.СуммаНДСУменьшение	= 0;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОтветственныйПриИзмененииНаСервере()
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОпределениеПараметровСводнойСправкиСервер()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ОпределениеПараметровСводнойИКорректировочнойСправки();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, ПредставлениеДокумента)
	
	Форма.Заголовок = ПредставлениеДокумента.СчетФактураПредставление;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснование()
	
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
		
	Если ЕстьОшибкиЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПолучитьСтруктуруПараметровФормы();
		
	ОткрытьФорму("Документ.СчетФактураВыданный.Форма.ФормаДокументыОснования",
			ПараметрыФормы,
			ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы()
	
	СтруктураПараметров = Новый Структура();
	ЗначенияЗаполнения 	= Новый Структура();
	ЗначениеОтбора 		= Новый Структура();
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда 
		ЗначенияЗаполнения.Вставить("СписокДокументовОснований", Новый СписокЗначений);
		Для Каждого СтрокаТаблицы Из Объект.ДокументыОснования Цикл
			ЗначенияЗаполнения.СписокДокументовОснований.Добавить(СтрокаТаблицы.ДокументОснование)
		КонецЦикла;
	КонецЕсли;
	
	ЗначенияЗаполнения.Вставить("ТипСчетаФактуры", "Выданный");
	ЗначенияЗаполнения.Вставить("ВидСчетаФактуры",  Объект.ВидСчетаФактуры);
	ЗначенияЗаполнения.Вставить("Исправление",      Объект.Исправление);
	ЗначенияЗаполнения.Вставить("СчетФактура",      Объект.Ссылка);
	ЗначенияЗаполнения.Вставить("ДатаСчетаФактуры", Объект.Дата);
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения); 
	
	ЗначениеОтбора.Вставить("Организация", Объект.Организация);
	ЗначениеОтбора.Вставить("Контрагент",  Неопределено);
	ЗначениеОтбора.Вставить("Договор",     Неопределено);
	ЗначениеОтбора.Вставить("Валюта",      Объект.ВалютаДокумента);
		
	СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)

	Объект.ДокументыОснования.Очистить();
	
	Если ВыбранноеЗначение.Количество() = 0 Тогда
		
		Объект.ДоговорКонтрагента 	= Неопределено;
		Объект.СуммаДокумента 		= 0;
		Объект.СуммаНДСДокумента 	= 0;
		Объект.ПлатежноРасчетныеДокументы.Очистить();
		
	Иначе
		
		Для Каждого СтрокаСписка Из ВыбранноеЗначение Цикл
			Если СтрокаСписка.Значение.Пустая() Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТаблицы = Объект.ДокументыОснования.Добавить();
			СтрокаТаблицы.ДокументОснование = СтрокаСписка.Значение;
		КонецЦикла;
		ОпределениеПараметровСводнойСправкиСервер();
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументыОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПолучитьРежимЗаписи();
	
	Если ЭтаФорма.Записать(Новый Структура("РежимЗаписи", РежимЗаписи)) Тогда 
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРежимЗаписи()
	
	Проводить = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Проводить
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	|ГДЕ
	|	СчетФактураВыданныйДокументыОснования.Ссылка = &Ссылка
	|	И СчетФактураВыданныйДокументыОснования.ДокументОснование <> НЕОПРЕДЕЛЕНО
	|	И НЕ СчетФактураВыданныйДокументыОснования.ДокументОснование ССЫЛКА Документ.ДокументРасчетовСКонтрагентом
	|	И НЕ СчетФактураВыданныйДокументыОснования.ДокументОснование.Проведен";
	
	Проводить = Запрос.Выполнить().Пустой();
	
	Если Проводить Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	Иначе
		РежимЗаписи = РежимЗаписиДокумента.Запись;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура НадписьВыборНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

#Область ЗаполнениеДокумента

&НаКлиенте
Процедура ВопросЗаполнитьДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьДокумент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокумент()

	Результат = ЗаполнитьДокументНаСервере();

	Если Результат.ЗаданиеВыполнено Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
	Иначе
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДокументНаСервере()
	
	Если Объект.Проведен Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
	КонецЕсли;
	
	Объект.ДокументыОснования.Очистить();
	
	СтруктураПараметров = Новый Структура("Дата,Организация,Ссылка",
		Объект.Дата, Объект.Организация, Объект.Ссылка);

	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.СчетФактураВыданный.ПодготовитьДанныеДляЗаполненияСводнойСправки(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);

	Иначе
		
		НаименованиеЗадания = НСтр("ru = 'Заполнение документа ""Сводная справка по розничным продажам""'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Документы.СчетФактураВыданный.ПодготовитьДанныеДляЗаполненияСводнойСправки",
			СтруктураПараметров,
			НаименованиеЗадания);

		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;

	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ЗагрузитьПодготовленныеДанные();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ДокументыОснования") Тогда
		Объект.ДокументыОснования.Загрузить(СтруктураДанных.ДокументыОснования);
	КонецЕсли;
	
	ОпределениеПараметровСводнойСправкиСервер();
	
	УправлениеФормой(ЭтаФорма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


