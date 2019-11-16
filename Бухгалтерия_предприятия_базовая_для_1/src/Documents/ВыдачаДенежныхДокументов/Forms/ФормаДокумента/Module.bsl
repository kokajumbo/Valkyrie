#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		ЗаполнитьНовыйДокумент(Параметры.ЗначениеКопирования);
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность	= Истина;
		
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеВыдачаДенежныхДокументов";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВыдачаДенежныхДокументов", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата,
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетноеЛицоПриИзменении(Элемент)
	
	Объект.Выдано = ПолучитьТекстВыдано(Объект.Организация, Объект.Контрагент, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаРасчетовСКонтрагентомПрочееПриИзменении(Элемент)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыданоПрочееНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбора = ОткрытьФорму("Справочник.ФизическиеЛица.ФормаСписка",
		Новый Структура("РежимВыбора", Истина), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыданоПрочееОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Объект.Выдано = ПолучитьТекстВыдано(Объект.Организация, ВыбранноеЗначение, Объект.Дата);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ВидОперации",              Объект.ВидОперации);
	ПараметрыДокумента.Вставить("Организация",              Объект.Организация);
	ПараметрыДокумента.Вставить("Дата",                     Объект.Дата);
	ПараметрыДокумента.Вставить("ПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	ПараметрыДокумента.Вставить("Контрагент",               Объект.Контрагент);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента",       Объект.ДоговорКонтрагента);
	ПараметрыДокумента.Вставить("ВалютаДокумента",          Объект.ВалютаДокумента);
	ПараметрыДокумента.Вставить("СписокВидовДоговоров",     СписокВидовДоговоров);
	
	ПараметрыДокумента = ПолучитьДанныеВалютаПриИзменении(ПараметрыДокумента);
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	
	УстановитьПараметрыВыбора(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ВидОперации",              Объект.ВидОперации);
	ПараметрыДокумента.Вставить("Организация",              Объект.Организация);
	ПараметрыДокумента.Вставить("Дата",                     Объект.Дата);
	ПараметрыДокумента.Вставить("ПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	ПараметрыДокумента.Вставить("Контрагент",               Объект.Контрагент);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента",       Объект.ДоговорКонтрагента);
	ПараметрыДокумента.Вставить("ВалютаДокумента",          Объект.ВалютаДокумента);
	ПараметрыДокумента.Вставить("СписокВидовДоговоров",     СписокВидовДоговоров);
	
	ПараметрыДокумента = ПолучитьДанныеКонтрагентПриИзменении(ПараметрыДокумента);
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	
	УстановитьДоступностьСвязанныхЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ЕстьРазницы = Ложь;
	Для каждого СтрокаДенежногоДокумента Из Объект.ДенежныеДокументы Цикл
		Если СтрокаДенежногоДокумента.Стоимость <> СтрокаДенежногоДокумента.Сумма Тогда
			ЕстьРазницы = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаДенежныхДокументовПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если НЕ Элементы.ВалютаДокумента.Доступность Тогда
		Объект.ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		ВалютаДокументаПриИзменении(Элементы.ВалютаДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДенежныеДокументы

&НаКлиенте
Процедура ДенежныеДокументыДенежныйДокументПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ДенежныеДокументы.ТекущиеДанные;
	Если СтрокаТЧ.Количество = 0 Тогда
		СтрокаТЧ.Количество = 1;
	КонецЕсли;
	
	ПараметрыСтроки = Новый Структура("ВидОперации, ДенежныйДокумент, Стоимость, Сумма, Количество",
		Объект.ВидОперации, СтрокаТЧ.ДенежныйДокумент,
		СтрокаТЧ.Стоимость, СтрокаТЧ.Сумма, СтрокаТЧ.Количество);
	ЗаполнитьСуммы(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТЧ, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыКоличествоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ДенежныеДокументы.ТекущиеДанные;
	
	ПараметрыСтроки = Новый Структура("ВидОперации, ДенежныйДокумент, Стоимость, Сумма, Количество",
		Объект.ВидОперации, СтрокаТЧ.ДенежныйДокумент,
		СтрокаТЧ.Стоимость, СтрокаТЧ.Сумма, СтрокаТЧ.Количество);
	ЗаполнитьСуммы(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТЧ, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыСтоимостьПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ДенежныеДокументы.ТекущиеДанные;
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийВыдачаДенежныхДокументов.ВозвратПоставщику") Тогда
		СтрокаТЧ.Сумма = СтрокаТЧ.Стоимость;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// СтатьяДоходовИРасходов

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СтатьяДоходовИРасходов");

	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ЕстьРазницы", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"Объект.СтатьяДоходовИРасходов", ВидСравненияКомпоновкиДанных.Заполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);


	// СчетУчетаДоходов

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СчетУчетаДоходов");

	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ЕстьРазницы", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"Объект.СчетУчетаДоходов", ВидСравненияКомпоновкиДанных.Заполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);


	// СчетУчетаРасходов

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СчетУчетаРасходов");

	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ЕстьРазницы", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"Объект.СчетУчетаРасходов", ВидСравненияКомпоновкиДанных.Заполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийВыдачаДенежныхДокументов.ВозвратПоставщику") Тогда
		
		Элементы.ГруппаВозвратПоставщику.Видимость      = Истина;
		Элементы.ГруппаВыдачаПодотчетномуЛицу.Видимость = Ложь;
		Элементы.ГруппаПрочее.Видимость                 = Ложь;
		
		Элементы.ГруппаСчетаДоходовРасходов.Видимость   = Истина;
		Элементы.ДенежныеДокументыСумма.Видимость       = Истина;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийВыдачаДенежныхДокументов.ВыдачаПодотчетномуЛицу") Тогда
		
		Элементы.ГруппаВозвратПоставщику.Видимость      = Ложь;
		Элементы.ГруппаВыдачаПодотчетномуЛицу.Видимость = Истина;
		Элементы.ГруппаПрочее.Видимость                 = Ложь;
		
		Элементы.ГруппаСчетаДоходовРасходов.Видимость   = Ложь;
		Элементы.ДенежныеДокументыСумма.Видимость       = Ложь;
		
	Иначе
		
		Элементы.ГруппаВозвратПоставщику.Видимость      = Ложь;
		Элементы.ГруппаВыдачаПодотчетномуЛицу.Видимость = Ложь;
		Элементы.ГруппаПрочее.Видимость                 = Истина;
		
		Элементы.ГруппаСчетаДоходовРасходов.Видимость   = Ложь;
		Элементы.ДенежныеДокументыСумма.Видимость       = Ложь;
		
	КонецЕсли;
	
	УстановитьОграничениеТипаКонтрагента(Форма);
	
	Элементы.ВалютаДокумента.Доступность = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.СчетУчетаДенежныхДокументов).Валютный;
	
	УстановитьДоступностьСвязанныхЭлементов(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбора(Форма)
	
	Валютный = Форма.Объект.ВалютаДокумента <> Форма.ВалютаРегламентированногоУчета;
	
	НовыйМассивПараметров = Новый Массив();
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.Валютный", Валютный);
	НовыйМассивПараметров.Добавить(НовыйПараметр);
	
	Если Валютный Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВалютаВзаиморасчетов", Форма.Объект.ВалютаДокумента);
		НовыйМассивПараметров.Добавить(НовыйПараметр);
	КонецЕсли;
	
	ТекущиеПараметрыВыбора = Форма.Элементы.ДоговорКонтрагента.ПараметрыВыбора;
	Для каждого ПараметрВыбора Из ТекущиеПараметрыВыбора Цикл
		Если ПараметрВыбора.Имя <> "Отбор.Валютный" И ПараметрВыбора.Имя <> "Отбор.ВалютаВзаиморасчетов" Тогда
			НовыйМассивПараметров.Добавить(ПараметрВыбора);
		КонецЕсли;
	КонецЦикла;
	
	Форма.Элементы.ДоговорКонтрагента.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСвязанныхЭлементов(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);
	Элементы.ДоговорКонтрагента.Доступность       = ЗначениеЗаполнено(Объект.Контрагент);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОграничениеТипаКонтрагента(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийВыдачаДенежныхДокументов.ВозвратПоставщику") Тогда
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		Элементы.Контрагент.Заголовок = "Контрагент";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийВыдачаДенежныхДокументов.ВыдачаПодотчетномуЛицу") Тогда
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
		Элементы.Контрагент.Заголовок = "Подотчетное лицо";
	Иначе // .ПрочаяВыдача
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
		Элементы.Контрагент.Заголовок = "Контрагент";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСуммы(ПараметрыСтроки)
	
	Если ЗначениеЗаполнено(ПараметрыСтроки.ДенежныйДокумент) Тогда
		ПараметрыСтроки.Стоимость = ПараметрыСтроки.ДенежныйДокумент.Стоимость * ПараметрыСтроки.Количество;
	Иначе
		ПараметрыСтроки.Стоимость = 0;
	КонецЕсли;
	
	Если ПараметрыСтроки.ВидОперации = Перечисления.ВидыОперацийВыдачаДенежныхДокументов.ВозвратПоставщику Тогда
		ПараметрыСтроки.Сумма = ПараметрыСтроки.Стоимость;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстВыдано(Знач Организация, Знач ФизЛицо, Знач Дата)
	
	ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Организация, ФизЛицо, Дата, Ложь);
	
	Возврат ДанныеФизЛица.Представление;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеВалютаПриИзменении(ПараметрыДокумента)
	
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ПараметрыДокумента.ВалютаДокумента, ПараметрыДокумента.Дата);
	ПараметрыДокумента.Вставить("КурсВзаиморасчетов",      СтруктураКурса.Курс);
	ПараметрыДокумента.Вставить("КратностьВзаиморасчетов", СтруктураКурса.Кратность);
	
	Если (ПараметрыДокумента.ВидОперации = Перечисления.ВидыОперацийВыдачаДенежныхДокументов.ВозвратПоставщику)
		И ЗначениеЗаполнено(ПараметрыДокумента.ДоговорКонтрагента)
		И (ПараметрыДокумента.ДоговорКонтрагента.ВалютаВзаиморасчетов <> ПараметрыДокумента.ВалютаДокумента) Тогда
		ПараметрыДокумента.Вставить("ДоговорКонтрагента", Неопределено);
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ПараметрыДокумента.ДоговорКонтрагента,
		ПараметрыДокумента.Контрагент,
		ПараметрыДокумента.Организация,
		ПараметрыДокумента.СписокВидовДоговоров,
		Новый Структура("ВалютаВзаиморасчетов", Новый Структура("ЗначениеОтбора", ПараметрыДокумента.ВалютаДокумента)));
	
	Возврат ПараметрыДокумента;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеКонтрагентПриИзменении(ПараметрыДокумента)
	
	ПараметрыДокумента = ЗаполнениеДокументов.ПолучитьДанныеКонтрагентПриИзменении(
		ПараметрыДокумента,
		ПараметрыДокумента.СписокВидовДоговоров);
	
	СведенияОКонтрагенте = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыДокумента.Контрагент, ПараметрыДокумента.Дата);
	ПараметрыДокумента.Вставить("Выдано", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагенте, "НаименованиеДляПечатныхФорм,"));
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ПараметрыДокумента.ДоговорКонтрагента,
		ПараметрыДокумента.Контрагент,
		ПараметрыДокумента.Организация,
		ПараметрыДокумента.СписокВидовДоговоров,
		Новый Структура("ВалютаВзаиморасчетов", Новый Структура("ЗначениеОтбора", ПараметрыДокумента.ВалютаДокумента)));
	
	Возврат ПараметрыДокумента;
	
КонецФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента            = Объект.Дата;
	
	ВалютаРегламентированногоУчета  = Константы.ВалютаРегламентированногоУчета.Получить();
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ПолучитьСписокВидовДоговоров();
	
	Элементы.Контрагент.ОграничениеТипа      = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	Элементы.ПодотчетноеЛицо.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	
	ЗаполнитьСчетаДенежныхДокументов();
	
	УстановитьПараметрыВыбора(ЭтаФорма);
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовыйДокумент(ЗначениеКопирования)
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ВидОперации",              Объект.ВидОперации);
	ПараметрыДокумента.Вставить("Организация",              Объект.Организация);
	ПараметрыДокумента.Вставить("Дата",                     Объект.Дата);
	ПараметрыДокумента.Вставить("ПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	ПараметрыДокумента.Вставить("Контрагент",               Объект.Контрагент);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента",       Объект.ДоговорКонтрагента);
	ПараметрыДокумента.Вставить("ВалютаДокумента",          Объект.ВалютаДокумента);
	ПараметрыДокумента.Вставить("СписокВидовДоговоров",     СписокВидовДоговоров);
	
	ПараметрыДокумента = ПолучитьДанныеВалютаПриИзменении(ПараметрыДокумента);
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	
	Если НЕ ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		Если Объект.ВидОперации = Перечисления.ВидыОперацийВыдачаДенежныхДокументов.ВозвратПоставщику Тогда
			Объект.Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийВыдачаДенежныхДокументов.ВыдачаПодотчетномуЛицу Тогда
			Объект.Контрагент = Справочники.ФизическиеЛица.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокВидовДоговоров()
	
	СписокВидовДоговоров = Новый СписокЗначений;
	СписокВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("ВидОперации",              Объект.ВидОперации);
	ПараметрыДокумента.Вставить("Организация",              Объект.Организация);
	ПараметрыДокумента.Вставить("Дата",                     Объект.Дата);
	ПараметрыДокумента.Вставить("ПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	ПараметрыДокумента.Вставить("Контрагент",               Объект.Контрагент);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента",       Объект.ДоговорКонтрагента);
	ПараметрыДокумента.Вставить("ВалютаДокумента",          Объект.ВалютаДокумента);
	ПараметрыДокумента.Вставить("СписокВидовДоговоров",     СписокВидовДоговоров);
	
	ПараметрыДокумента = ЗаполнениеДокументов.ПолучитьДанныеОрганизацияПриИзменении(ПараметрыДокумента);
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ПараметрыДокумента.ДоговорКонтрагента,
		ПараметрыДокумента.Контрагент,
		ПараметрыДокумента.Организация,
		ПараметрыДокумента.СписокВидовДоговоров,
		Новый Структура("ВалютаВзаиморасчетов", Новый Структура("ЗначениеОтбора", ПараметрыДокумента.ВалютаДокумента)));
	
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	
	УстановитьФункциональныеОпцииФормы();
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииОрганизации(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаДенежныхДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланСчетов.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ПланСчетов
	|ГДЕ
	|	НЕ ПланСчетов.Ссылка.ЗапретитьИспользоватьВПроводках
	|	И ПланСчетов.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ДенежныеДокументы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПланСчетов.Ссылка.Код";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		МассивСчетов = Результат.Выгрузить().ВыгрузитьКолонку("Счет");
	Иначе
		МассивСчетов = Новый Массив;
	КонецЕсли;
	
	Если МассивСчетов.Количество() >0 Тогда
		НовыйМассивПараметров = Новый Массив();
		НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
		НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", Ложь));
		Элементы.СчетУчетаДенежныхДокументов.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	УстановитьФункциональныеОпцииФормы();
	
	Если (Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	Объект.ДоговорКонтрагента             = Неопределено;
	Объект.СчетУчетаРасчетовСКонтрагентом = Неопределено;
	Объект.Выдано                         = "";
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
		
	УправлениеФормой(ЭтаФорма);
	
	Если Элементы.Контрагент.ОграничениеТипа.Типы().Количество() = 0 Тогда
		Объект.Контрагент = Неопределено;
	Иначе
		Объект.Контрагент = Элементы.Контрагент.ОграничениеТипа.ПривестиЗначение(Объект.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
		ЭтотОбъект, Объект, НомерСубконто, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"СубконтоДт", "", "СубконтоДт", "", "СчетУчетаРасчетовСКонтрагентом");
		
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	
	Возврат Результат;

КонецФункции

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

#КонецОбласти

