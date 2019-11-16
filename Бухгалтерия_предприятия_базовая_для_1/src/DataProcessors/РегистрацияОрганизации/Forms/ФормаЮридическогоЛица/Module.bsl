// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьЗаполнениеПоИНН;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	РазместитьКонтактнуюИнформацию();
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		ЗаполнитьРеквизитыПоТекстуЗаполнения(Параметры.ТекстЗаполнения);
		// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	Элементы.ГруппаЗаполнениеПоДаннымЕГР.Видимость      = ОтобразитьЗаполнениеПоДаннымЕГР;
	Элементы.ЗаполнитьРеквизитыПоИНН.Видимость          = НЕ ОтобразитьЗаполнениеПоДаннымЕГР;
	Элементы.ЗаполнитьРеквизитыПоНаименованию.Видимость = НЕ ОтобразитьЗаполнениеПоДаннымЕГР;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ПропуститьПроверку") 
		И ПараметрыЗаписи.ПропуститьПроверку Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИНН) И Объект.ИННВведенКорректно И Объект.КППВведенКорректно Тогда
		
		КоличествоЭлементовДублей = ВыполнитьПоискДублейСервер(Объект.ИНН, Объект.КПП, Объект.Ссылка);
		
		ЕстьДубли = КоличествоЭлементовДублей > 0; 
		
		Если ЕстьДубли Тогда
			
			Отказ = Истина;
			
			ТекстВопроса = НСтр("ru = 'Уже есть элементы с таким ИНН и КПП. Записать?'");
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("КоличествоЭлементовДублей", КоличествоЭлементовДублей);
			ДополнительныеПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
			
			Оповещение = Новый ОписаниеОповещения("ВопросЗаписатьЭлементСНеуникальнымИННЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьЗаголовокФормы();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Полное наименование'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Объект.НаименованиеПолное" , , Отказ);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'ИНН'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Объект.ИНН" , , Отказ);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.КПП) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'КПП'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Объект.КПП" , , Отказ);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.РегистрационныйНомер) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'ОГРН'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Объект.РегистрационныйНомер" , , Отказ);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ДатаРегистрации) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Дата регистрации'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Объект.ДатаРегистрации" , , Отказ);
	КонецЕсли;
	Если КонтактнаяИнформацияПолеЮрАдресКонтрагента = УправлениеКонтактнойИнформациейКлиентСервер.ТекстПустогоАдресаВВидеГиперссылки() Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Юридический адрес'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КонтактнаяИнформацияПолеЮрАдресКонтрагента", , Отказ);
	КонецЕсли;
	Если Отказ Тогда
		// Не выполняем проверку объекта, если нашли ошибки в модуле.
		// В объекте проверяются реквизиты, которые не выведены на эту форму и должны заполнится автоматически.
		ПроверяемыеРеквизиты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГРЮЛ(Команда)
	
	ЗаполнитьРеквизитыПоДаннымЕГРЮЛНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованию(Команда)
	
	Если ЗначениеЗаполнено(Объект.ИНН) 
		ИЛИ (ЗначениеЗаполнено(КонтактнаяИнформацияПолеЮрАдресКонтрагента) 
		И ЭтоПустойАдрес(КонтактнаяИнформацияПолеЮрАдресКонтрагента)) Тогда
		ТекстВопроса = НСтр("ru='Перезаполнить текущие реквизиты?'");
		ДопПараметры = Новый Структура("ЗаполнениеПоИНН", Ложь);
		ДопПараметры.Вставить("СтрокаПоиска", Объект.Наименование);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыПоДаннымЕГРЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(Объект.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоИНН(Команда)
	
	Если ОтключитьЗаполнениеПоИНН <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	ИначеЕсли НЕ ОшибокПоИННнет Тогда
		ПоказатьПредупреждение(, Строка(РезультатПроверкиИНН));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	ВыполнитьЗаполнениеРеквизитовПоИНН(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПолеПоискаИНННаименование)
		И НЕ ЗначениеЗаполнено(Объект.ИНН)
		И НЕ ЗначениеЗаполнено(Объект.НаименованиеПолное)
		И (НЕ ЗначениеЗаполнено(КонтактнаяИнформацияПолеЮрАдресКонтрагента)
		ИЛИ ЭтоПустойАдрес(КонтактнаяИнформацияПолеЮрАдресКонтрагента)) Тогда
		
		ЗаполнитьРеквизитыПоДаннымЕГРЮЛНаКлиенте();
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	
	Объект.Наименование = ОрганизацииФормыКлиентСервер.НаименованиеПоСокращенномуНаименованию(Объект.НаименованиеПолное);
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ПроверитьИННКППДубли(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	КПППриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНаСсылку(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ПоказатьДубли" Тогда
		СтандартнаяОбработка = Ложь;
		ОбработатьСитуациюВыбораДубля(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресНажатие(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, Модифицированность, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЦветВыделенияНекорректногоЗначение = ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой;
	
	УстановитьЗаголовокФормы();
	
	ПроверитьИНН = Истина;
	ПроверитьКПП = Истина;
	
	Элементы.ИНН.ОграничениеТипа = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(10));
	Элементы.КПП.ОграничениеТипа = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(9));
	Элементы.РегистрационныйНомер.ОграничениеТипа = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(13));
	
	ПроверитьИННКППДубли(ПроверитьИНН, ПроверитьКПП);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Юридический адрес
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КонтактнаяИнформацияПолеЮрАдресКонтрагента");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"КонтактнаяИнформацияПолеЮрАдресКонтрагента",
		ВидСравненияКомпоновкиДанных.Равно,
		УправлениеКонтактнойИнформациейКлиентСервер.ТекстПустогоАдресаВВидеГиперссылки());
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненныйРеквизит);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Заголовок = СтрШаблон(НСтр("ru='%1 (Учредитель)'"), Объект.Наименование);
	Иначе
		Заголовок = НСтр("ru = 'Учредитель (создание)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоПустойАдрес(ПолеАдреса)
	
	Возврат ПолеАдреса = УправлениеКонтактнойИнформациейКлиентСервер.ТекстПустогоАдресаВВидеГиперссылки();
	
КонецФункции

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.НаименованиеПолное = Результат.Значение;
		Объект.Наименование       = Результат.Значение;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КПППриИзмененииНаСервере()
	
	Справочники.Контрагенты.УстановитьАктуальноеЗначениеИсторииКПП(Объект.КПП , Объект.ИсторияКПП);
	
	ПроверитьИНН = Ложь;
	ПроверитьКПП = Истина;
	
	ПроверитьИННКППДубли(ПроверитьИНН, ПроверитьКПП);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИНН(СтрокаИНН)
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И СтрДлина(СтрокаИНН) = 10
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
КонецФункции

#Область ПроверкаИННКППДубли

&НаСервере
Процедура ПроверитьИННКППДубли(ПроверитьИНН, ПроверитьКПП)
	
	ЭтотОбъект.НадписьПоясненияНекорректногоИНН = "";
	ЭтотОбъект.НадписьПоясненияНекорректногоКПП = "";
	
	ТекстПредставленияИННКПП = НСтр("ru = '%1
									|%2'");
	
	Если ПроверитьИНН Тогда
		
		РезультатПроверки  = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямИНН(Объект.ИНН, Истина);
		ОшибокПоИННнет = РезультатПроверки.СоответствуетТребованиям;
		ТекстОшибкиИНН     = РезультатПроверки.ОписаниеОшибки;
		
		Если НЕ ТолькоПросмотр Тогда
			Объект.ИННВведенКорректно          = ПустаяСтрока(ТекстОшибкиИНН) И ОшибокПоИННнет;
			Объект.РасширенноеПредставлениеИНН = СтрШаблон(ТекстПредставленияИННКПП, Объект.ИНН, ТекстОшибкиИНН);
		КонецЕсли; 
		
		РезультатПроверкиИНН = Новый ФорматированнаяСтрока(ТекстОшибкиИНН,, ЦветВыделенияНекорректногоЗначение);
	
	КонецЕсли;
	
	Если ПроверитьКПП Тогда
		
		РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямКПП(Объект.КПП, Истина, Ложь);
		
		Если НЕ ТолькоПросмотр Тогда
			Объект.КППВведенКорректно = РезультатПроверки.СоответствуетТребованиям;
			Объект.РасширенноеПредставлениеКПП = СтрШаблон(ТекстПредставленияИННКПП, Объект.КПП, РезультатПроверки.ОписаниеОшибки);
		КонецЕсли;
		
		РезультатПроверкиКПП = Новый ФорматированнаяСтрока(РезультатПроверки.ОписаниеОшибки,, ЦветВыделенияНекорректногоЗначение);
	
	КонецЕсли;
	
	ПроверитьДубли(ЭтотОбъект);
	ОбщегоНазначенияБПКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентовВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьПоискДублейСервер(Знач ИНН, Знач КПП, Знач Ссылка)
	
	ДублиСправочникаКонтрагентыПоИННКПП = Справочники.Контрагенты.ПроверитьДублиСправочникаКонтрагентыПоИННКПП(СокрЛП(ИНН), СокрЛП(КПП), Ссылка);
	
	Возврат ДублиСправочникаКонтрагентыПоИННКПП.Количество();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьДубли(Форма)
	
	Если Не Форма.ТолькоПросмотр Тогда
		Объект = Форма.Объект;
		
		Если ЗначениеЗаполнено(Объект.ИНН) И Объект.ИННВведенКорректно И Объект.КППВведенКорректно Тогда 
			
			КоличествоЭлементовДублей = ВыполнитьПоискДублейСервер(Объект.ИНН, Объект.КПП, Объект.Ссылка);
			
			Форма.ЕстьДубли = НЕ КоличествоЭлементовДублей = 0;
			
			Если НЕ Форма.ЕстьДубли Тогда
				
				Объект.РасширенноеПредставлениеИНН = Объект.ИНН;
				Объект.РасширенноеПредставлениеКПП = Объект.КПП;
				
			КонецЕсли;
			
			Форма.РезультатПроверкиНаДубли = ОписаниеРезультатаПроверкиДублей(Форма, КоличествоЭлементовДублей);
			
		Иначе
			Форма.ЕстьДубли = Ложь;
			Форма.РезультатПроверкиНаДубли = "";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеРезультатаПроверкиДублей(Форма, Знач КоличествоЭлементовДублей)
	
	Объект = Форма.Объект;
	
	// Если контрагент еще не записан, то не учитываем его при подсчете.
	Если НЕ Объект.Ссылка.Пустая() Тогда
		КоличествоЭлементовДублей = КоличествоЭлементовДублей + 1;
	КонецЕсли;
	
	Если Форма.ЕстьДубли Тогда
		
		ТекстКоличествоДублей = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
			КоличествоЭлементовДублей, НСтр("ru = 'контрагент,контрагента,контрагентов'"), Истина);
		ТекстНадписиОДублях = СтрШаблон(НСтр("ru = 'С таким ИНН и КПП есть %1'"), ТекстКоличествоДублей);
		
		Возврат Новый ФорматированнаяСтрока(ТекстНадписиОДублях, ,Форма.ЦветВыделенияНекорректногоЗначение, ,"ПоказатьДубли");
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВопросЗаписатьЭлементСНеуникальнымИННЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПараметрыЗаписи = ДополнительныеПараметры.ПараметрыЗаписи;
		ПараметрыЗаписи.Вставить("ПропуститьПроверку", Истина);
		Если Записать(ПараметрыЗаписи) И ПараметрыЗаписи.Свойство("Закрыть") Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
	РезультатПроверкиНаДубли = ОписаниеРезультатаПроверкиДублей(ЭтотОбъект, ДополнительныеПараметры.КоличествоЭлементовДублей);
	
	ОбщегоНазначенияБПКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентовВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСитуациюВыбораДубля(Элемент)
	
	ПараметрыПередачи = Новый Структура;
	
	ПараметрыПередачи.Вставить("ИНН", Объект.ИНН);
	ПараметрыПередачи.Вставить("КПП", Объект.КПП);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ЧтоВыполнитьПослеЗакрытия = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыСпискаДублей", ЭтаФорма);
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбораДублей", 
		ПараметрыПередачи, 
		Элемент,
		,
		,
		,
		ЧтоВыполнитьПослеЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыСпискаДублей(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПроверитьДубли(ЭтаФорма);
	
	ОбщегоНазначенияБПКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентовВФорме(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеИзЕГРЮЛ

&НаСервере
Процедура ЗаполнитьРеквизитыПоТекстуЗаполнения(ТекстЗаполнения)
	
	ОтобразитьЗаполнениеПоДаннымЕГР = Истина;
	
	Если ПустаяСтрока(ТекстЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоИНН(ТекстЗаполнения) Тогда
		
		Объект.Наименование       = "";
		Объект.НаименованиеПолное = "";
		
		РезультатВыполнения = ДанныеЕдиныхГосРеестровПоИНН(Объект.ИНН);
		
		Если РезультатВыполнения.Свойство("АдресРеквизитовКонтрагента") Тогда
			Объект.ИНН = ТекстЗаполнения;
			ЗаполнитьРеквизитыНаСервере(РезультатВыполнения.АдресРеквизитовКонтрагента, Истина);
			ОтобразитьЗаполнениеПоДаннымЕГР = Ложь;
			Возврат;
		КонецЕсли; 
	КонецЕсли;
	
	ПолеПоискаИНННаименование = ТекстЗаполнения;
	ТекстЗаполнения = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГРЮЛНаКлиенте()
	
	ПолеПоискаИНННаименование = СокрЛП(ПолеПоискаИНННаименование);
	
	Если ПустаяСтрока(ПолеПоискаИНННаименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСТр("ru='Введите ИНН или Наименование'"),
			,
			"ПолеПоискаИНННаименование");
		Возврат;
	ИначеЕсли СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПолеПоискаИНННаименование) 
		И НЕ ЭтоИНН(ПолеПоискаИНННаименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСТр("ru='ИНН юридического лица должен состоять из 10 цифр'"),
			,
			"ПолеПоискаИНННаименование");
		Возврат;
	КонецЕсли;
	Если ОтключитьЗаполнениеПоИНН <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнениеПоИНН = ЭтоИНН(ПолеПоискаИНННаименование);
	Если ЗаполнениеПоИНН Тогда
		ВыполнитьЗаполнениеРеквизитовПоИНН();
	ИначеЕсли ЗначениеЗаполнено(Объект.НаименованиеПолное)
		ИЛИ (ЗначениеЗаполнено(КонтактнаяИнформацияПолеЮрАдресКонтрагента)
		И НЕ ЭтоПустойАдрес(КонтактнаяИнформацияПолеЮрАдресКонтрагента)) Тогда
		ТекстВопроса = НСтр("ru='Перезаполнить текущие реквизиты?'");
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("СтрокаПоиска", ПолеПоискаИНННаименование);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыПоДаннымЕГРЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(ПолеПоискаИНННаименование);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеРеквизитовПоИНН(ПроверитьИНН = Ложь)
	
	// Если нужно проверить ИНН, то берем из объекта (используется для заполнению по наименованию)
	Если ПроверитьИНН Тогда
		ИННОбъекта = СокрП(Объект.ИНН);
	Иначе
		ИННОбъекта = СокрП(ПолеПоискаИНННаименование);
		// Запустим проверку после заполнения
		ПроверитьИНН = Истина;
	КонецЕсли;
	
	ДанныеДляЗаполнения = ДанныеЕдиныхГосРеестровПоИНН(ИННОбъекта);
	
	Если ЗначениеЗаполнено(ДанныеДляЗаполнения.ОписаниеОшибки) Тогда
		// Обработка ошибок
		Если ДанныеДляЗаполнения.ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			ТекстВопроса = НСтр("ru='Для автоматического заполнения реквизитов контрагентов
				|необходимо подключиться к Интернет-поддержке пользователей.
				|Подключиться сейчас?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		ИначеЕсли ДанныеДляЗаполнения.ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен" Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторМестаВызова", "kontragent");
			ОткрытьФорму("ОбщаяФорма.Сервис1СКонтрагентНеПодключен", ПараметрыФормы, ЭтотОбъект);
		Иначе
			ПоказатьПредупреждение(, ДанныеДляЗаполнения.ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли ДанныеДляЗаполнения.Свойство("АдресРеквизитовКонтрагента") Тогда
		ЗаполнитьРеквизитыНаСервере(ДанныеДляЗаполнения.АдресРеквизитовКонтрагента, ПроверитьИНН)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГРЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(ДопПараметры.СтрокаПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(Наименование)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтрокаПоиска", Наименование);
	ДопПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыПоНаименованиюЗавершение", ЭтотОбъект, ДопПараметры);
	ОткрытьФорму("ОбщаяФорма.ЗаполнениеРеквизитовКонтрагента", ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованиюЗавершение(Результат, ДопПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) 
		ИЛИ ТипЗнч(Результат) <> Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ИНН = Результат;
	ВыполнитьЗаполнениеРеквизитовПоИНН(Истина);
	
	ТекущийЭлемент = Элементы.НаименованиеПолное;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеЕдиныхГосРеестровПоИНН(Знач ИННОбъекта)
	
	ДанныеЗаполнения  = Новый Структура("ОписаниеОшибки", "");
	ИННОбъекта        = СокрП(ИННОбъекта);
	РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямИНН(ИННОбъекта, Истина);
	
	Если РезультатПроверки.СоответствуетТребованиям Тогда
		РеквизитыКонтрагента = РаботаСКонтрагентами.РеквизитыЮридическогоЛицаПоИНН(ИННОбъекта);
		РеквизитыКонтрагента.Вставить("ЮридическоеФизическоеЛицо", Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
		
		Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда
			ДанныеЗаполнения.ОписаниеОшибки = РеквизитыКонтрагента.ОписаниеОшибки;
		Иначе
			ДанныеЗаполнения.Вставить("НаименованиеКонтрагента",   РеквизитыКонтрагента.Наименование);
			ДанныеЗаполнения.Вставить("ЮридическоеФизическоеЛицо", РеквизитыКонтрагента.ЮридическоеФизическоеЛицо);
			ДанныеЗаполнения.Вставить("АдресРеквизитовКонтрагента",
				ПоместитьВоВременноеХранилище(РеквизитыКонтрагента, Новый УникальныйИдентификатор));
		КонецЕсли;
	Иначе
		ДанныеЗаполнения.ОписаниеОшибки = РезультатПроверки.ОписаниеОшибки;
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыНаСервере(АдресРеквизитовКонтрагента, ПроверитьИНН)
	
	РеквизитыКонтрагента = ПолучитьИзВременногоХранилища(АдресРеквизитовКонтрагента);
	ЗаполнитьРеквизитыКонтрагента(РеквизитыКонтрагента, ПроверитьИНН);
	УдалитьИзВременногоХранилища(АдресРеквизитовКонтрагента);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыКонтрагента(РеквизитыКонтрагента, ПроверитьИНН)
	
	ЗаполнитьЗначенияСвойств(Объект, РеквизитыКонтрагента);
	
	НаименованияАвтозаполнения.Очистить();
	НаименованияАвтозаполнения.Добавить(РеквизитыКонтрагента.НаименованиеПолное);
	НаименованияАвтозаполнения.Добавить(РеквизитыКонтрагента.НаименованиеСокращенное);
	
	// Заполнение адресов
	
	ЗаполнитьЭлементКонтактнойИнформации("КонтактнаяИнформацияПолеЮрАдресКонтрагента",
		РеквизитыКонтрагента.ЮридическийАдрес);
	ЗаполнитьЭлементКонтактнойИнформации("КонтактнаяИнформацияПолеФактАдресКонтрагента",
		РеквизитыКонтрагента.ЮридическийАдрес);
	ЗаполнитьЭлементКонтактнойИнформации("КонтактнаяИнформацияПолеПочтовыйАдресКонтрагента",
		РеквизитыКонтрагента.ЮридическийАдрес);
		
	// Заполнение телефона
	
	ЗаполнитьЭлементКонтактнойИнформации("КонтактнаяИнформацияПолеТелефонКонтрагента", РеквизитыКонтрагента.Телефон);
	
	// Заполнение контактного лица 
	
	Если РеквизитыКонтрагента.Руководитель <> Неопределено 
		И НЕ ЗначениеЗаполнено(Объект.ОсновноеКонтактноеЛицо) Тогда
		
		ДанныеКонтактногоЛица = РеквизитыКонтрагента.Руководитель;
		ПредставлениеКонтактногоЛица = ДанныеКонтактногоЛица.Фамилия
			+ " " + ДанныеКонтактногоЛица.Имя
			+ " " + ДанныеКонтактногоЛица.Отчество
			+ ", " + ДанныеКонтактногоЛица.Должность;
		
	КонецЕсли;
	
	Справочники.Контрагенты.УстановитьАктуальноеЗначениеИсторииКПП(Объект.КПП , Объект.ИсторияКПП);
	Справочники.Контрагенты.УстановитьАктуальноеЗначениеИсторииНаименований(
		Объект.НаименованиеПолное, Объект.ИсторияНаименований);
		
	ПроверитьИННКППДубли(ПроверитьИНН, Истина);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьЗаполнениеПоИНН()
	
	ОтключитьЗаполнениеПоИНН = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформация

&НаСервере
Процедура РазместитьКонтактнуюИнформацию()
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИсключаемыеВиды = Новый Массив();
	ИсключаемыеВиды.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
	
	ПараметрыРазмещенияКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ПараметрыРазмещенияКонтактнойИнформации.ИмяЭлементаДляРазмещения = "ГруппаАдрес";
	ПараметрыРазмещенияКонтактнойИнформации.ИсключаемыеВиды = ИсключаемыеВиды;
	ПараметрыРазмещенияКонтактнойИнформации.ОтложеннаяИнициализация = Истина;
	
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ПараметрыРазмещенияКонтактнойИнформации);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементКонтактнойИнформации(ИмяРеквизита, СтруктураДанных)
	
	Если СтруктураДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отбор  = Новый Структура("ИмяРеквизита", ИмяРеквизита);
	Строки = ЭтотОбъект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтруктураДанных);
	ДанныеСтроки.Значение = СтруктураДанных.КонтактнаяИнформация;
	ЭтотОбъект[ИмяРеквизита]   = СтруктураДанных.Представление;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти