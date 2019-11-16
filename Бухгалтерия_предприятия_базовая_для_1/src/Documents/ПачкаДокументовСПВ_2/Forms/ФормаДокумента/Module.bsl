#Область ОписаниеПеременных

&НаКлиенте
Перем мНомерТекущейСтроиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПерсонифицированныйУчетФормы.ДокументыСЗВПриСозданииНаСервере(ЭтаФорма, ОписаниеДокумента());
	Если Параметры.Ключ.Пустая() Тогда
		ЗапрашиваемыеЗначенияПервоначальногоЗаполнения();
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
		ПриПолученииДанныхНаСервере();
	КонецЕсли;	
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечатьПереопределенная;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если Объект.ДокументПринятВПФР Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	УстановитьДоступностьДанныхФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПачкаДокументовСПВ_2", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		СтруктураОтбора = Новый Структура("Сотрудник", Источник);
		СтрокиПоСотруднику = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
		ЗарплатаКадрыКлиентСервер.ОбработкаИзмененияДанныхФизическогоЛица(Объект, Параметр, СтрокиПоСотруднику, Модифицированность);
	ИначеЕсли ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения("ОтчетныйПериодНачалоВыбораЗавершение", ЭтотОбъект);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ОтчетныйПериод", "ПериодСтрока", '20140101', , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодНачалоВыбораЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда 
		ПредупреждениеОНедопустимомОтчетномПериоде();
	Иначе	
		УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция РежимВыбораПериода(ВыбираемыйПериод) Экспорт
	Год = Год(ВыбираемыйПериод);
	Если Год < 2011 Тогда
		Возврат "Полугодие";
	Иначе
		Возврат "Квартал";
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура КорректируемыйПериодСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("КорректируемыйПериодСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.КорректируемыйПериод", "КорректируемыйПериодСтрока", '20140101', , Оповещение);	
	
КонецПроцедуры

&НаКлиенте
Процедура КорректируемыйПериодСтрокаНачалоВыбораЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Отказ = Ложь;
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(Объект.ОтчетныйПериод, ПериодСтрока, Направление, '20140101',,Отказ);
	
	Если Не Отказ Тогда	
		УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	ТипСведенийСЗВПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	СотрудникиСотрудникПриИзмененииНаСервере();		
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Сотрудники.ТекущийЭлемент = Элементы.СотрудникиФизическоеЛицо
		И Не ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.Сотрудник) Тогда
		
		Возврат;
	КонецЕсли;	
		
	ОткрытьФормуРедактированияКарточкиДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подбор(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(Элементы.Сотрудники, Объект.Организация, АдресСпискаПодобранныхСотрудников());
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеСотрудников(Команда)
	
	Если Не ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;

	Если Объект.Сотрудники.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьДанныеСотрудниковЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Данные о сотрудниках будут перезаполнены, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьДанныеСотрудниковЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеСотрудниковЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьДанныеФизЛицДокументаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РасположитьЗаписиСтажа(Команда)
	Если Элементы.Сотрудники.ТекущиеДанные <> Неопределено Тогда
		ПерсонифицированныйУчетКлиент.ДокументыСЗВВыполнитьНумерациюЗаписейОСтаже(Элементы.Сотрудники, Объект.ЗаписиОСтаже);
		РасположитьЗаписиСтажаНаСервере(Элементы.Сотрудники.ТекущиеДанные.Сотрудник);
		ПерсонифицированныйУчетКлиент.ДокументыСЗВВыполнитьНумерациюЗаписейОСтаже(Элементы.Сотрудники, Объект.ЗаписиОСтаже);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
	ПроверкаСтороннимиПрограммами(Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	ПараметрыОткрытия = Новый Структура;
	
	ПроверяемыеОбъекты = Новый Массив;
	ПроверяемыеОбъекты.Добавить(Объект.Ссылка);
	
	ПараметрыОткрытия.Вставить("СсылкиНаПроверяемыеОбъекты", ПроверяемыеОбъекты);
	
	ОткрытьФорму("ОбщаяФорма.ПроверкаФайловОтчетностиПерсУчетаПФР", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	Если ДанныеФайла <> Неопределено Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОткрытьФормуРедактированияКарточкиДокумента()
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	ДанныеШапкиТекущегоДокумента = Объект;
	
	Период = Объект.ОтчетныйПериод;
	
	Если ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ <> ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ") Тогда
		
		Период = ДанныеШапкиТекущегоДокумента.КорректируемыйПериод;
	КонецЕсли;	
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда	
		ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище();
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресВоВременномХранилище", АдресДанныхТекущегоДокументаВХранилище);
		ПараметрыОткрытияФормы.Вставить("РедактируемыйДокументСсылка", ДанныеШапкиТекущегоДокумента.Ссылка);
		ПараметрыОткрытияФормы.Вставить("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		ПараметрыОткрытияФормы.Вставить("ТипСведенийСЗВ", ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ);
		ПараметрыОткрытияФормы.Вставить("Организация", ДанныеШапкиТекущегоДокумента.Организация);
		ПараметрыОткрытияФормы.Вставить("Период", Период);
		ПараметрыОткрытияФормы.Вставить("ИсходныйНомерСтроки", 0);
		ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыОткрытияФормы.Вставить("НеОтображатьОшибки", Истина);
		
		ОткрытьФорму("Обработка.ПодготовкаКвартальнойОтчетностиВПФР.Форма.ФормаКарточкиСЗВ6", ПараметрыОткрытияФормы, ЭтаФорма);	
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище()
	Если Элементы.Сотрудники.ТекущаяСтрока = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;	
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;
	
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	ДанныеСотрудника.Вставить("ДатаСоставления", ДанныеТекущейСтрокиПоСотруднику.ДатаСоставления);
	ДанныеСотрудника.Вставить("СтраховойНомерПФР", ДанныеТекущейСтрокиПоСотруднику.СтраховойНомерПФР);
	ДанныеСотрудника.Вставить("Фамилия", ДанныеТекущейСтрокиПоСотруднику.Фамилия);
	ДанныеСотрудника.Вставить("Имя", ДанныеТекущейСтрокиПоСотруднику.Имя);
	ДанныеСотрудника.Вставить("Отчество", ДанныеТекущейСтрокиПоСотруднику.Отчество);
	ДанныеСотрудника.Вставить("НачисленоСтраховая",0);
	ДанныеСотрудника.Вставить("УплаченоСтраховая", 0);
	ДанныеСотрудника.Вставить("НачисленоНакопительная", 0);
	ДанныеСотрудника.Вставить("УплаченоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоначисленоСтраховая", 0);
	ДанныеСотрудника.Вставить("ДоначисленоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоУплаченоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоУплаченоСтраховая", 0);
	
	ДанныеСотрудника.Вставить("НачисленоНаОПС", ДанныеТекущейСтрокиПоСотруднику.НачисленоНаОПС);
	ДанныеСотрудника.Вставить("НачисленоПоДополнительнымТарифам", ДанныеТекущейСтрокиПоСотруднику.НачисленоПоДополнительнымТарифам);
	
	ДанныеСотрудника.Вставить("ФиксНачисленныеВзносы", Ложь);
	ДанныеСотрудника.Вставить("ФиксУплаченныеВзносы", Ложь);
	ДанныеСотрудника.Вставить("ФиксСтаж", Ложь);
	ДанныеСотрудника.Вставить("ФиксЗаработок", Ложь);
	ДанныеСотрудника.Вставить("СведенияОЗаработке", Новый Массив);
    ДанныеСотрудника.Вставить("ЗаписиОСтаже", Новый Массив);
	ДанныеСотрудника.Вставить("ИсходныйНомерСтроки", ДанныеТекущейСтрокиПоСотруднику.ИсходныйНомерСтроки);
	
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
				
	СтрокиЗаписиОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтаж Из СтрокиЗаписиОСтаже Цикл
		СтруктураПолейЗаписиОСтаже = СтруктураПолейЗаписиОСтаже();
		ЗаполнитьЗначенияСвойств(СтруктураПолейЗаписиОСтаже, СтрокаСтаж);
		СтруктураПолейЗаписиОСтаже.ИдентификаторИсходнойСтроки = СтрокаСтаж.ПолучитьИдентификатор(); 
				
		ДанныеСотрудника.ЗаписиОСтаже.Добавить(СтруктураПолейЗаписиОСтаже);
	КонецЦикла;	

	Если ЗначениеЗаполнено(АдресДанныхТекущегоДокументаВХранилище) Тогда
		ПоместитьВоВременноеХранилище(ДанныеСотрудника, АдресДанныхТекущегоДокументаВХранилище);	
	Иначе	
		АдресДанныхТекущегоДокументаВХранилище = ПоместитьВоВременноеХранилище(ДанныеСотрудника, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ДанныеТекущегоДокумента.Сотрудник));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
			
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
	КонецЦикла;
	
	СуществущиеСтрокиСтажа = Новый Массив;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
		СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
				
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
		
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
	
	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция СтруктураПолейЗаписиОСтаже()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НомерОсновнойЗаписи");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ДатаНачалаПериода");
	СтруктураПолей.Вставить("ДатаОкончанияПериода");
	СтруктураПолей.Вставить("ОсобыеУсловияТруда");
	СтруктураПолей.Вставить("КодПозицииСписка");
	СтруктураПолей.Вставить("ОснованиеИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ПервыйПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ВторойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ТретийПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ОснованиеВыслугиЛет");
	СтруктураПолей.Вставить("ПервыйПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ВторойПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТретийПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТерриториальныеУсловия");
	СтруктураПолей.Вставить("ПараметрТерриториальныхУсловий");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");

	Возврат СтруктураПолей;	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента()
	ОписаниеДокумента = ПерсонифицированныйУчетКлиентСервер.ОписаниеДокументаСЗВ();
	ОписаниеДокумента.ВариантОтчетногоПериода = "КВАРТАЛ";
	ОписаниеДокумента.ЕстьКорректируемыйПериод = Истина;
	ОписаниеДокумента.ИмяПоляКорректируемыйПериод = "КорректируемыйПериод";
	
	Возврат ОписаниеДокумента;
КонецФункции	

&НаСервере
Процедура ТипСведенийСЗВПриИзмененииНаСервере()
	УстановитьДоступностьПолейСтажаИВзносов();
	
	ПерсонифицированныйУчетКлиентСервер.ДокументыСведенийОВзносахИСтажеУстановитьКорректируемыйПериод(ЭтаФорма);
	
	Элементы.КорректируемыйПериодСтрока.Доступность = Объект.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ;
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()	
	ПерсонифицированныйУчетФормы.ДокументыСЗВПриПолученииДанныхНаСервере(ЭтаФорма, ОписаниеДокумента());
	
	ПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	
	УстановитьДоступностьПолейСтажаИВзносов();
		
	Для Каждого СтрокаСтажа Из Объект.ЗаписиОСтаже Цикл
		УстановитьЗаголовкиПолейСтрокиСтажа(СтрокаСтажа);
	КонецЦикла;	
	
	РуководительДолжностьПредставление = РуководительПредставление(Объект.Руководитель, Объект.ДолжностьРуководителя);
	
	Если Объект.ДокументПринятВПФР Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	КорректируемыйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.КорректируемыйПериод);
	
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;
	
	УстановитьДоступностьДанныхФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДокументСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервереБезКонтекста
Процедура УстановитьЗаголовкиПолейСтрокиСтажа(СтрокаСтажа)
	СтрокаСтажа.ТерриториальныеУсловияКодЗаголовок = НСтр("ru = 'Код:'");
	СтрокаСтажа.ТерриториальныеУсловияСтавкаЗаголовок = НСтр("ru = 'Ставка:'");
	СтрокаСтажа.ИсчисляемыйСтажОснованиеЗаголовок = НСтр("ru = 'Основание:'");
	СтрокаСтажа.ИсчисляемыйСтажТретийПараметрЗаголовок =  НСтр("ru = 'Отсутствие:'");
	СтрокаСтажа.ОснованиеВыслугиЛетЗаголовок = НСтр("ru = 'Основание:'");
	
	Если СтрокаСтажа.ОснованиеИсчисляемогоСтажа = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ОснованияИсчисляемогоСтраховогоСтажа.ВОДОЛАЗ") Тогда
		СтрокаСтажа.ПервыйПараметрВыслугиЛетЗаголовок = НСтр("ru = 'Часы:'");
		СтрокаСтажа.ВторойПараметрВыслугиЛетЗаголовок = НСтр("ru = 'Минуты:'");
	Иначе	
		СтрокаСтажа.ПервыйПараметрВыслугиЛетЗаголовок = НСтр("ru = 'Месяцы:'");
		СтрокаСтажа.ВторойПараметрВыслугиЛетЗаголовок = НСтр("ru = 'Дни:'");
	КонецЕсли;	

	СтрокаСтажа.ТретийПараметрВыслугиЛетЗаголовок =  НСтр("ru = 'Ставка:'");
	СтрокаСтажа.ПервыйПараметрИсчисляемогоСтажаЗаголовок = НСтр("ru = 'Месяцы:'");
	СтрокаСтажа.ВторойПараметрИсчисляемогоСтажаЗаголовок = НСтр("ru = 'Дни:'");
КонецПроцедуры	

&НаСервереБезКонтекста
Функция РуководительПредставление(Руководитель, Должность)
	Шаблон = НСтр("ru = 'Руководитель: %1, Должность: %2'");
	
	Если ЗначениеЗаполнено(Руководитель) Тогда
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, Руководитель, "ФамилияИО");
		Если КадровыеДанные.Количество() > 0  Тогда
			РуководительПредставление = КадровыеДанные[0].ФамилияИО;
		КонецЕсли;
		
	Иначе
		РуководительПредставление = НСтр("ru = 'не указан'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Должность) Тогда
		ДолжностьПредставление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Должность, "НаименованиеКраткое");
	Иначе
		ДолжностьПредставление = НСтр("ru = 'не указана'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, РуководительПредставление, ДолжностьПредставление);
	
КонецФункции	

&НаСервере
Процедура УстановитьДоступностьПолейСтажаИВзносов()
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		Элементы.СотрудникиВзносыНачислены.Видимость = Ложь;
		Элементы.СотрудникиДопВзносыНачислены.Видимость = Ложь;
		Объект.ЗаписиОСтаже.Очистить();
	Иначе
		Элементы.СотрудникиВзносыНачислены.Видимость = Истина;
		Элементы.СотрудникиДопВзносыНачислены.Видимость = Истина;
	КонецЕсли;	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("Квартал", "Объект.ОтчетныйПериод");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Объект.Ответственный");

	Возврат ЗапрашиваемыеЗначения;
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)	
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции	

&НаСервере
Процедура ЗаполнитьДанныеПоСотрудникам(ЗаполняемыеСтроки) 
	СписокФизическихЛиц = Новый Массив;
	 
	СтрокиПоСотрудникам = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из ЗаполняемыеСтроки Цикл 
		СтрокиПоСотрудникам.Вставить(СтрокаТаблицы.Сотрудник, СтрокаТаблицы);
	КонецЦикла;	
	
	ПериодПолученияДанных = ?(Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, Объект.ОтчетныйПериод, Объект.КорректируемыйПериод);
	
	ДанныеДляЗаполнения = Документы.ПачкаДокументовСПВ_2.ДанныеДляЗаполненияДокумента(
							Объект.Организация, 
							ПериодПолученияДанных, 
							ЗаполняемыеСтроки);
							
	Для Каждого ДанныеСотрудника Из ДанныеДляЗаполнения.Сотрудники Цикл 
		ЗаполняемаяСтрока = СтрокиПоСотрудникам[ДанныеСотрудника.Сотрудник];
		ЗаполнитьЗначенияСвойств(ЗаполняемаяСтрока, ДанныеСотрудника);
	КонецЦикла;							
	
	ОбрабатываемыйСотрудник = Неопределено;
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого ДанныеСтажа Из ДанныеДляЗаполнения.ЗаписиОСтаже Цикл 
		СтрокаСтажа = Объект.ЗаписиОСтаже.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаСтажа, ДанныеСтажа);
		УстановитьЗаголовкиПолейСтрокиСтажа(СтрокаСтажа);
		
		Если ОбрабатываемыйСотрудник <> СтрокаСтажа.Сотрудник Тогда 
			ОбрабатываемыйСотрудник = СтрокаСтажа.Сотрудник;	
			ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
			
			СтрокиСтажаПоСотруднику.Очистить();
		КонецЕсли;	
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажа);
	КонецЦикла;	
	
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДанныеФизЛицДокументаНаСервере() 
	Объект.ЗаписиОСтаже.Очистить();
	
	ЗаполнитьДанныеПоСотрудникам(Объект.Сотрудники);
КонецПроцедуры	

&НаСервере
Процедура ОбработкаПодбораНаСервере(МассивСотрудников)
	СтрокиТаблицыСотрудники = Новый Массив;
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл
		СтруктураПоиска = Новый Структура("Сотрудник", Сотрудник);
		
		Если Объект.Сотрудники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			СтрокаПоСотруднику = Объект.Сотрудники.Добавить();
			СтрокаПоСотруднику.Сотрудник = Сотрудник;
			СтрокиТаблицыСотрудники.Добавить(СтрокаПоСотруднику);
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьДанныеПоСотрудникам(СтрокиТаблицыСотрудники);
КонецПроцедуры

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	СтруктураПоиска = Новый Структура("Сотрудник", ТекущийСотрудник);

	УдаляемыеСтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(УдаляемаяСтрока));
	КонецЦикла;
	
	ДанныеТекущейСтроки = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	ТекущийСотрудник = ДанныеТекущейСтроки.Сотрудник;
	
	ЗаполняемыеСтроки = Новый Массив;
	ЗаполняемыеСтроки.Добавить(ДанныеТекущейСтроки);
	
	ЗаполнитьДанныеПоСотрудникам(ЗаполняемыеСтроки);
КонецПроцедуры	

&НаСервере
Процедура РасположитьЗаписиСтажаНаСервере(Сотрудник)
	ПерсонифицированныйУчет.РасположитьЗаписиСтажа(Сотрудник, Объект.ЗаписиОСтаже);	
КонецПроцедуры	

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	
	Объект.Сотрудники.Очистить();
	Объект.ЗаписиОСтаже.Очистить();
КонецПроцедуры

&НаСервере
Процедура УстановитьКатегориюЗастрахованныхЛицЗаПериод() Экспорт
	ПерсонифицированныйУчетФормы.ДокументыСЗВУстановитьКатегориюЗастрахованныхЛицЗаПериод(ЭтаФорма, ОписаниеДокумента());	
КонецПроцедуры	

&НаКлиенте
Процедура ПредупреждениеОНедопустимомОтчетномПериоде()
	
	Текст = НСтр("ru = 'Форма СПВ-2 предоставляется, начиная с 2014 г. За предыдущие периоды предоставляется форма СПВ-1.'");
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры	

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
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

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьДанныхФормы()
	Если Объект.ДокументПринятВПФР Тогда  
		ТолькоПросмотр = Истина;	
	КонецЕсли;		
КонецПроцедуры	

&НаСервере
Процедура ФлагБлокировкиДокументаПриИзмененииНаСервере()
	Модифицированность = Истина;
	Объект.ДокументПринятВПФР = ФлагБлокировкиДокумента;
	Если Не ФлагБлокировкиДокумента Тогда
		ТолькоПросмотр = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммами(Отказ)
	
	Если Отказ Тогда
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой обнаружены ошибки.
		|Выполнить проверку сторонними программами?'")
	Иначе	
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой ошибок не обнаружено.
		|Выполнить проверку сторонними программами?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСтороннимиПрограммамиЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ПроверитьСтороннимиПрограммами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтороннимиПрограммами()
	
	Записать();
	ПараметрыОткрытия = Новый Структура;
	
	ПроверяемыеОбъекты = Новый Массив;
	ПроверяемыеОбъекты.Добавить(Объект.Ссылка);
	
	ПараметрыОткрытия.Вставить("СсылкиНаПроверяемыеОбъекты", ПроверяемыеОбъекты);
	
	ОткрытьФорму("ОбщаяФорма.ПроверкаФайловОтчетностиПерсУчетаПФР", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаписатьНаДискЗавершение(Результат, Параметры) Экспорт
	
	Если Модифицированность Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	Записать();
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");	
КонецПроцедуры

#КонецОбласти
