
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
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
	
	УстановитьДоступностьДанныхФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_РеестрДСВ_3", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		СтруктураОтбора = Новый Структура("Сотрудник", Источник);
		СтрокиПоСотруднику = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
		ЗарплатаКадрыКлиентСервер.ОбработкаИзмененияДанныхФизическогоЛица(Объект, Параметр, СтрокиПоСотруднику,  Модифицированность);
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
Процедура ОтчетныйПериодПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ОтчетныйПериод", "ПериодСтрока", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ОтчетныйПериод", "ПериодСтрока");
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ОтчетныйПериод", "ПериодСтрока", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписантов();		
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьРуководителяПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписантов();
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписантов();
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере();
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
Процедура Заполнить(Команда)
	
	Если Не ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;

	Если Объект.Сотрудники.Количество() > 0 Тогда
	    ТекстВопроса = НСтр("ru = 'Табличная часть будет очищена, продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ЗаполнитьЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
	Если Объект.Сотрудники.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для заполнения документа.'");
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Внимание.'"));
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);
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
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(Элементы.Сотрудники, Объект.Организация, АдресСпискаПодобранныхСотрудников());
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
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

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("ПредыдущийКвартал", "Объект.ОтчетныйПериод");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Объект.Ответственный");

	Возврат ЗапрашиваемыеЗначения;
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	ЗапрашиваемыеЗначения.Вставить("ГлавныйБухгалтер", "Объект.ГлавныйБухгалтер");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции	

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДатаПолученияДанных = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(Объект.ОтчетныйПериод);
	
	ФизическиеЛицаРаботавшиеВОрганизации = КадровыйУчет.ФизическиеЛицаРаботавшиеВОрганизации(Истина, Объект.Организация, НачалоМесяца(Объект.ОтчетныйПериод), ДатаПолученияДанных);
	
	МассивНеобходимыхКадровыхДанных = Новый Массив;
	МассивНеобходимыхКадровыхДанных.Добавить("Наименование");
	МассивНеобходимыхКадровыхДанных.Добавить("Фамилия");
	МассивНеобходимыхКадровыхДанных.Добавить("Имя");
	МассивНеобходимыхКадровыхДанных.Добавить("Отчество");
	МассивНеобходимыхКадровыхДанных.Добавить("СтраховойНомерПФР");
	
	КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ФизическиеЛицаРаботавшиеВОрганизации.ВыгрузитьКолонку("ФизическоеЛицо"), МассивНеобходимыхКадровыхДанных, ДатаПолученияДанных);
	
	ПерсонифицированныйУчет.СформироватьВТДанныеОДопВзносах(Объект.ОтчетныйПериод, "ВТКадровыеДанныеФизическихЛиц", Запрос.МенеджерВременныхТаблиц); 
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТКадровыеДанныеФизЛиц.ФизическоеЛицо КАК Сотрудник,
	|	ВТКадровыеДанныеФизЛиц.Фамилия КАК Фамилия,
	|	ВТКадровыеДанныеФизЛиц.Имя,
	|	ВТКадровыеДанныеФизЛиц.Отчество,
	|	ВТКадровыеДанныеФизЛиц.СтраховойНомерПФР,
	|	ВТДанныеОДопВзносах.СуммаВзносов КАК ВзносыРаботника
	|ИЗ
	|	ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеОДопВзносах КАК ВТДанныеОДопВзносах
	|		ПО ВТКадровыеДанныеФизЛиц.ФизическоеЛицо = ВТДанныеОДопВзносах.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТКадровыеДанныеФизЛиц.Наименование";
	
	Объект.Сотрудники.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры	

&НаСервере
Процедура ОбработкаПодбораНаСервере(ВыбранныеФизЛица)
	
	СтруктураПоиска = Новый Структура("Сотрудник");
		
	ДанныеСотрудников = ПолучитьДанныеФизическихЛицНаСервере(ВыбранныеФизЛица);
	
	Для Каждого СтрокаДанныеСотрудников Из ДанныеСотрудников Цикл
		СтруктураПоиска.Сотрудник = СтрокаДанныеСотрудников.Сотрудник;
		Если Объект.Сотрудники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда 
			НоваяСтрокаСотрудник = Объект.Сотрудники.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаСотрудник, СтрокаДанныеСотрудников);
		КонецЕсли;	
	КонецЦикла;	

КонецПроцедуры	

&НаСервере
Функция ПолучитьДанныеФизическихЛицНаСервере(ФизическиеЛица)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	МассивНеобходимыхДанных = Новый Массив;
	МассивНеобходимыхДанных.Добавить("Наименование");
	МассивНеобходимыхДанных.Добавить("Фамилия");
	МассивНеобходимыхДанных.Добавить("Имя");
	МассивНеобходимыхДанных.Добавить("Отчество");
	МассивНеобходимыхДанных.Добавить("СтраховойНомерПФР");
	
	КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ФизическиеЛица, МассивНеобходимыхДанных, Объект.ОтчетныйПериод);
	
	ПерсонифицированныйУчет.СформироватьВТДанныеОДопВзносах(Объект.ОтчетныйПериод, "ВТКадровыеДанныеФизическихЛиц", Запрос.МенеджерВременныхТаблиц);  
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТКадровыеДанныеФизЛиц.ФизическоеЛицо КАК Сотрудник,
	|	ВТКадровыеДанныеФизЛиц.Фамилия КАК Фамилия,
	|	ВТКадровыеДанныеФизЛиц.Имя,
	|	ВТКадровыеДанныеФизЛиц.Отчество,
	|	ВТКадровыеДанныеФизЛиц.СтраховойНомерПФР,
	|	ВТДанныеОДопВзносах.СуммаВзносов КАК ВзносыРаботника
	|ИЗ
	|	ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОДопВзносах КАК ВТДанныеОДопВзносах
	|		ПО ВТКадровыеДанныеФизЛиц.ФизическоеЛицо = ВТДанныеОДопВзносах.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТКадровыеДанныеФизЛиц.Наименование";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	СтрокаТаблицы = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	ДанныеСотрудника = ПолучитьДанныеФизическихЛицНаСервере(СтрокаТаблицы.Сотрудник);
	Если ДанныеСотрудника.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеСотрудника[0]);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ОтчетныйПериод", "ПериодСтрока");
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;
	УстановитьДоступностьДанныхФормы();
	НастроитьОтображениеГруппыПодписантов();
КонецПроцедуры

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
Процедура НастроитьОтображениеГруппыПодписантов()
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер");	
КонецПроцедуры	

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
КонецПроцедуры	

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
	ПроверкаСтороннимиПрограммами(Отказ)
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
	
	Если Модифицированность Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");	
КонецПроцедуры

#КонецОбласти
