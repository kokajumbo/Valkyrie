
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
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
	ЗаполнитьИнфоНадписиОДокументахУдостоверяющихЛичность(Объект.Сотрудники, Объект.Дата);
	
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
	
	ПриПолученииДанныхНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПачкаДокументовАДВ_2", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ПерсонифицированныйУчетКлиент.ДокументыАДВОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПризнакИзмененияПриИзменении(Элемент)
	ПерсонифицированныйУчетКлиент.ДокументыАДВПризнакИзмененияПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПризнакОтменыПриИзменении(Элемент)
	ПерсонифицированныйУчетКлиент.ДокументыАДВПризнакОтменыПриИзменении(ЭтаФорма, Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	ПерсонифицированныйУчетКлиент.ДокументыАДВОтобразитьДанныеФизическогоЛица(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		ИнфоКартинкаОДокументе = Новый Картинка;
	Иначе
		
		Если ПустаяСтрока(ДанныеТекущейСтроки.ИнфоОДокументеУдостоверяющемЛичностьНадпись) Тогда
			ИнфоКартинкаОДокументе = Новый Картинка;
		Иначе
			ИнфоКартинкаОДокументе = БиблиотекаКартинок.Предупреждение;
		КонецЕсли;
		
	КонецЕсли;	
	
	ИнфоОДокументеУдостоверяющемЛичностьКартинка = ИнфоКартинкаОДокументе;
	
	ПерсонифицированныйУчетКлиент.ДокументыАДВОтобразитьДанныеФизическогоЛица(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	ЗаполнитьДанныеСотрудникаНаСервере();	
	ПерсонифицированныйУчетКлиент.ДокументыАДВОтобразитьДанныеФизическогоЛица(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПоляНадписиАдресаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СотрудникиКлиент.ПояснениеНажатие(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	Оповещение = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	Если ДанныеФайла <> Неопределено Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(Элементы.Сотрудники, Объект.Организация,  АдресСпискаПодобранныхСотрудников());
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДанныеФизическогоЛица(Команда)
	ПерсонифицированныйУчетКлиент.РедактироватьДанныеФизическогоЛица(Элементы.Сотрудники);	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьДанныеФизическогоЛица(Команда)
	ПерсонифицированныйУчетКлиент.ДокументыАДВПрочитатьДанныеФизическогоЛица(ЭтаФорма);		
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
	ПроверкаСтороннимиПрограммами(Отказ);
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
Процедура ПриПолученииДанныхНаСервере()
	ПерсонифицированныйУчет.ДокументыАДВЗаполнитьТекущиеДанныеФизическихЛиц(Объект);
	НастроитьОтображениеГруппыПодписантов();
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;
	УстановитьДоступностьДанныхФормы();
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
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

&НаСервере
Процедура ЗаполнитьДанныеСотрудникаНаСервере()
	ДанныеТекущейСтроки = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	МассивСотрудников = Новый Массив;
	МассивСотрудников.Добавить(ДанныеТекущейСтроки.Сотрудник);
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПоместитьСписокСотрудниковВоВременнуюТаблицу(МассивСотрудников, МенеджерВременныхТаблиц);
	
	ДанныеЗаполнения = Документы.ПачкаДокументовАДВ_2.СформироватьЗапросПоДаннымФизЛицДокумента(Объект.Ссылка, Объект.Дата, МенеджерВременныхТаблиц).Выбрать();
	
	СтрокиПоСотрудникам = Новый Массив;
	Если ДанныеЗаполнения.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеТекущейСтроки, ДанныеЗаполнения);
	    ДанныеТекущейСтроки.МестоРожденияПредставление = ПерсонифицированныйУчетКлиентСервер.ПредставлениеМестаРождения(ДанныеТекущейСтроки.МестоРождения);
		ДанныеТекущейСтроки.ДанныеФизЛицаМестоРожденияПредставление = ПерсонифицированныйУчетКлиентСервер.ПредставлениеМестаРождения(ДанныеТекущейСтроки.ДанныеФизЛицаМестоРождения);
		СтрокиПоСотрудникам.Добавить(ДанныеТекущейСтроки);
	КонецЕсли;
	
	ЗаполнитьИнфоНадписиОДокументахУдостоверяющихЛичность(СтрокиПоСотрудникам, Объект.Дата);
	
КонецПроцедуры	

&НаСервере
Процедура ПоместитьСписокСотрудниковВоВременнуюТаблицу(МассивСотрудников, МенеджерВременныхТаблиц)
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаСотрудников.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));

	СчСотрудников =1;
	Для Каждого Сотрудник Из МассивСотрудников Цикл
		СтрокаТаблицы = ТаблицаСотрудников.Добавить();
		СтрокаТаблицы.Сотрудник = Сотрудник;
		СтрокаТаблицы.НомерСтроки = СчСотрудников;
		СчСотрудников = СчСотрудников + 1;
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаСотрудники", ТаблицаСотрудников);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник КАК ФизическоеЛицо,
	|	&Организация КАК Организация,
	|	&Ссылка КАК ДокументСсылка,
	|	&Дата КАК УточненнаяДатаПолученияСвидетельства,
	|	&Дата КАК Период
	|ПОМЕСТИТЬ ВТСписокФизлицДокумента
	|ИЗ
	|	&ТаблицаСотрудники КАК ТаблицаСотрудники";
	
	Запрос.Выполнить();
	
КонецПроцедуры	

&НаСервере
Процедура ОбработкаПодбораНаСервере(ВыбранныеФизЛица)
	МассивФизЛиц = Новый Массив;		
	СтруктураПоиска = Новый Структура("Сотрудник");
	Для Каждого Сотрудник Из ВыбранныеФизЛица Цикл
		СтруктураПоиска.Сотрудник = Сотрудник;
		Если Объект.Сотрудники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			МассивФизЛиц.Добавить(Сотрудник);	
		КонецЕсли;
	КонецЦикла;	

	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПоместитьСписокСотрудниковВоВременнуюТаблицу(МассивФизЛиц, МенеджерВременныхТаблиц);
	
	ДанныеЗаполнения = Документы.ПачкаДокументовАДВ_2.СформироватьЗапросПоДаннымФизЛицДокумента(Объект.Ссылка, Объект.Дата, МенеджерВременныхТаблиц).Выбрать();
	
	СтрокиПоСотрудникам = Новый Массив;
	ИдентификаторТекущейСтроки = Неопределено;
	Пока ДанныеЗаполнения.Следующий() Цикл
		НоваяСтрокаСотрудник = Объект.Сотрудники.Добавить();
		ИдентификаторТекущейСтроки = НоваяСтрокаСотрудник.ПолучитьИдентификатор();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаСотрудник, ДанныеЗаполнения);
	    НоваяСтрокаСотрудник.МестоРожденияПредставление = ПерсонифицированныйУчетКлиентСервер.ПредставлениеМестаРождения(НоваяСтрокаСотрудник.МестоРождения);
		НоваяСтрокаСотрудник.ДанныеФизЛицаМестоРожденияПредставление = ПерсонифицированныйУчетКлиентСервер.ПредставлениеМестаРождения(НоваяСтрокаСотрудник.ДанныеФизЛицаМестоРождения);
		СтрокиПоСотрудникам.Добавить(НоваяСтрокаСотрудник);
	КонецЦикла;

	ЗаполнитьИнфоНадписиОДокументахУдостоверяющихЛичность(СтрокиПоСотрудникам, Объект.Дата);
	
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		Элементы.Сотрудники.ТекущаяСтрока = ИдентификаторТекущейСтроки;
	КонецЕсли;	
КонецПроцедуры		

&НаКлиенте
Функция ПолучитьСоответствиеДанныхФормыПолямТабличнойЧасти(ТипДанных) Экспорт 
	СтруктураСоответствия = Новый Структура();
	
	Если ТипДанных = "ИзменившиесяДанныеСПризнаком" Тогда 	
		СтруктураСоответствия.Вставить("Фамилия", "Фамилия");
		СтруктураСоответствия.Вставить("Имя", "Имя");
		СтруктураСоответствия.Вставить("Отчество", "Отчество");	
		СтруктураСоответствия.Вставить("ПризнакОтменыОтчества", "ПризнакОтменыОтчества");
		СтруктураСоответствия.Вставить("ПризнакОтменыМестаРождения", "ПризнакОтменыМестаРождения");
		СтруктураСоответствия.Вставить("Пол", "Пол");
		СтруктураСоответствия.Вставить("ДатаРождения", "ДатаРождения");
		СтруктураСоответствия.Вставить("МестоРожденияПредставление", "МестоРожденияПредставление");
		СтруктураСоответствия.Вставить("Гражданство", "Гражданство");
		СтруктураСоответствия.Вставить("АдресФактическийПредставление", "АдресФактическийПредставление");
		СтруктураСоответствия.Вставить("АдресРегистрацииПредставление", "АдресРегистрацииПредставление");
		СтруктураСоответствия.Вставить("Телефоны", "Телефоны");
	ИначеЕсли ТипДанных = "ПризнакиИзменения" Тогда 	
		СтруктураСоответствия.Вставить("ФамилияПризнакИзменения", "Фамилия");
		СтруктураСоответствия.Вставить("ИмяПризнакИзменения", "Имя");
		СтруктураСоответствия.Вставить("ОтчествоПризнакИзменения", "Отчество");	
		СтруктураСоответствия.Вставить("ПолПризнакИзменения", "Пол");
		СтруктураСоответствия.Вставить("ДатаРожденияПризнакИзменения", "ДатаРождения");
		СтруктураСоответствия.Вставить("МестоРожденияПредставлениеПризнакИзменения", "МестоРожденияПредставление");
		СтруктураСоответствия.Вставить("ГражданствоПризнакИзменения", "Гражданство");
		СтруктураСоответствия.Вставить("АдресФактическийПредставлениеПризнакИзменения", "АдресФактическийПредставление");
		СтруктураСоответствия.Вставить("АдресРегистрацииПредставлениеПризнакИзменения", "АдресРегистрацииПредставление");
		СтруктураСоответствия.Вставить("ТелефоныПризнакИзменения", "Телефоны");
	КонецЕсли;	
	
	Возврат СтруктураСоответствия;
КонецФункции	

&НаКлиенте 
Функция ПолучитьСоответствиеДанныхФормыПризнакамИзменения() Экспорт
    СтруктураСоответствия = Новый Структура;
	СтруктураСоответствия.Вставить("Фамилия", "ФамилияПризнакИзменения");
	СтруктураСоответствия.Вставить("Имя", "ИмяПризнакИзменения");
	СтруктураСоответствия.Вставить("Отчество", "ОтчествоПризнакИзменения");	
	СтруктураСоответствия.Вставить("Пол", "ПолПризнакИзменения");
	СтруктураСоответствия.Вставить("ДатаРождения", "ДатаРожденияПризнакИзменения");
	СтруктураСоответствия.Вставить("МестоРожденияПредставление", "МестоРожденияПредставлениеПризнакИзменения");
	СтруктураСоответствия.Вставить("Гражданство", "ГражданствоПризнакИзменения");
	СтруктураСоответствия.Вставить("АдресФактическийПредставление", "АдресФактическийПредставлениеПризнакИзменения");
	СтруктураСоответствия.Вставить("АдресРегистрацииПредставление", "АдресРегистрацииПредставлениеПризнакИзменения");
	СтруктураСоответствия.Вставить("Телефоны", "ТелефоныПризнакИзменения");	
	
	Возврат СтруктураСоответствия;
КонецФункции	

&НаКлиенте 
Функция ПолучитьСоответствиеИзменившихсяДанныхДаннымФизЛица() Экспорт
    СтруктураСоответствия = Новый Структура;
	СтруктураСоответствия.Вставить("Фамилия", "ДанныеФизЛицаФамилия");
	СтруктураСоответствия.Вставить("Имя", "ДанныеФизЛицаИмя");
	СтруктураСоответствия.Вставить("Отчество", "ДанныеФизЛицаОтчество");	
	СтруктураСоответствия.Вставить("Пол", "ДанныеФизЛицаПол");
	СтруктураСоответствия.Вставить("ДатаРождения", "ДанныеФизЛицаДатаРождения");
	СтруктураСоответствия.Вставить("МестоРожденияПредставление", "ДанныеФизЛицаМестоРожденияПредставление");
	СтруктураСоответствия.Вставить("МестоРождения", "ДанныеФизЛицаМестоРождения");
	СтруктураСоответствия.Вставить("Гражданство", "ДанныеФизЛицаГражданство");
	СтруктураСоответствия.Вставить("АдресФактическийПредставление", "ДанныеФизЛицаАдресФактическийПредставление");
	СтруктураСоответствия.Вставить("АдресФактический", "ДанныеФизЛицаАдресФактический");
	СтруктураСоответствия.Вставить("АдресРегистрацииПредставление", "ДанныеФизЛицаАдресРегистрацииПредставление");
	СтруктураСоответствия.Вставить("АдресРегистрации", "ДанныеФизЛицаАдресРегистрации");
	СтруктураСоответствия.Вставить("Телефоны", "ДанныеФизЛицаТелефоны");	
	СтруктураСоответствия.Вставить("ПризнакОтменыОтчества", "ПризнакОтменыОтчества");
	СтруктураСоответствия.Вставить("ПризнакОтменыМестаРождения", "ПризнакОтменыМестаРождения");	

	Возврат СтруктураСоответствия;
КонецФункции	

&НаКлиенте 
Функция ПолучитьСоответствиеЭлементовУправленияДаннымФормы() Экспорт
    СтруктураСоответствия = Новый Структура;
	СтруктураСоответствия.Вставить("Фамилия", "Фамилия");
	СтруктураСоответствия.Вставить("Имя", "Имя");
	СтруктураСоответствия.Вставить("Отчество", "Отчество");	
	СтруктураСоответствия.Вставить("Пол", "Пол");
	СтруктураСоответствия.Вставить("ДатаРождения", "ДатаРождения");
	СтруктураСоответствия.Вставить("МестоРожденияПредставление", "МестоРожденияПредставление");
	СтруктураСоответствия.Вставить("Гражданство", "Гражданство");
	СтруктураСоответствия.Вставить("АдресФактическийПредставление", "АдресФактическийПредставление");
	СтруктураСоответствия.Вставить("АдресРегистрацииПредставление", "АдресРегистрацииПредставление");
	СтруктураСоответствия.Вставить("Телефоны", "Телефоны");	
	СтруктураСоответствия.Вставить("ПризнакОтменыОтчества", "ПризнакОтменыОтчества");
	СтруктураСоответствия.Вставить("ПризнакОтменыМестаРождения", "ПризнакОтменыМестаРождения");
	
	СтруктураСоответствия.Вставить("ФамилияПризнакИзменения", "ФамилияПризнакИзменения");
	СтруктураСоответствия.Вставить("ИмяПризнакИзменения", "ИмяПризнакИзменения");
	СтруктураСоответствия.Вставить("ОтчествоПризнакИзменения", "ОтчествоПризнакИзменения");	
	СтруктураСоответствия.Вставить("ПолПризнакИзменения", "ПолПризнакИзменения");
	СтруктураСоответствия.Вставить("ДатаРожденияПризнакИзменения", "ДатаРожденияПризнакИзменения");
	СтруктураСоответствия.Вставить("МестоРожденияПредставлениеПризнакИзменения", "МестоРожденияПредставлениеПризнакИзменения");
	СтруктураСоответствия.Вставить("ГражданствоПризнакИзменения", "ГражданствоПризнакИзменения");
	СтруктураСоответствия.Вставить("АдресФактическийПредставлениеПризнакИзменения", "АдресФактическийПредставлениеПризнакИзменения");
	СтруктураСоответствия.Вставить("АдресРегистрацииПредставлениеПризнакИзменения", "АдресРегистрацииПредставлениеПризнакИзменения");
	СтруктураСоответствия.Вставить("ТелефоныПризнакИзменения", "ТелефоныПризнакИзменения");	

	Возврат СтруктураСоответствия;
КонецФункции	

&НаКлиенте
Процедура ОбработатьИзменениеДанныхФизическогоЛица(СтрокиПоСотруднику) Экспорт 
	Для Каждого СтрокаСотрудника Из СтрокиПоСотруднику Цикл
		Если ЗначениеЗаполнено(СтрокаСотрудника.Пол) Тогда
			СтрокаСотрудника.Пол = СтрокаСотрудника.ДанныеФизЛицаПол;
		КонецЕсли;	
		Если ЗначениеЗаполнено(СтрокаСотрудника.ДатаРождения) Тогда
			СтрокаСотрудника.ДатаРождения = СтрокаСотрудника.ДанныеФизЛицаДатаРождения;
		КонецЕсли;	
		Если ЗначениеЗаполнено(СтрокаСотрудника.МестоРождения) Тогда
			СтрокаСотрудника.МестоРождения = СтрокаСотрудника.ДанныеФизЛицаМестоРождения;
			СтрокаСотрудника.МестоРожденияПредставление = СтрокаСотрудника.ДанныеФизЛицаМестоРожденияПредставление;
		КонецЕсли;		
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции	

&НаСервереБезКонтекста
Процедура ЗаполнитьИнфоНадписиОДокументахУдостоверяющихЛичность(СтрокиПоСотрудникам, ДатаСведений)
	
	Если ТипЗнч(СтрокиПоСотрудникам) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокиПоСотрудникам.Сотрудник);
		СтрокиПоСотрудникам = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокиПоСотрудникам);
	ИначеЕсли ТипЗнч(СтрокиПоСотрудникам) = Тип("Массив") Тогда
		МассивСотрудников = Новый Массив;
		Для каждого СтрокаПоСотруднику Из СтрокиПоСотрудникам Цикл
			МассивСотрудников.Добавить(СтрокаПоСотруднику.Сотрудник);
		КонецЦикла;
	Иначе
		МассивСотрудников = СтрокиПоСотрудникам.Выгрузить(, "Сотрудник").ВыгрузитьКолонку("Сотрудник");
	КонецЕсли;
	
	ТекущиеУдостоверенияЛичности = КадровыйУчетФормы.ТекущиеУдостоверенияЛичностиФизическихЛиц(
		МассивСотрудников, ДатаСведений);

	Для каждого СтрокаСотрудника Из СтрокиПоСотрудникам Цикл
		СтрокаСотрудника.ИнфоОДокументеУдостоверяющемЛичностьНадпись = КадровыйУчетФормы.ИнфоНадписьОДокументеУдостоверяющемЛичность(
			ТекущиеУдостоверенияЛичности, СтрокаСотрудника.Сотрудник, СтрокаСотрудника.ВидДокумента, СтрокаСотрудника.СерияДокумента, СтрокаСотрудника.НомерДокумента);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура НастроитьОтображениеГруппыПодписантов()
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.Исполнитель");	
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
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");	
КонецПроцедуры

#КонецОбласти
