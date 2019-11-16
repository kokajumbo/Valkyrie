#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ПродукцияВЕТИС) Тогда
		ВызватьИсключение Нстр("ru='Нет прав на просмотр справочника продукции'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторПродукции) Тогда
		ИдентификаторПродукции = Параметры.ИдентификаторПродукции;
		ЗагрузитьДанныеПоИдентификатору();
	КонецЕсли;
	Если Параметры.Свойство("Ключ")
		И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ПрочитатьОбъект(Ложь, Параметры.Ключ);
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПродукцияВЕТИС"
		И (Источник = Объект.Ссылка
			ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
				И Параметр.Свойство("Ссылка")
				И Параметр.Ссылка = Объект.Ссылка)) Тогда
		
		ПрочитатьОбъект(Истина, Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьВБазу(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	Оповестить(
		"Запись_ПродукцияВЕТИС",
		ПараметрыЗаписи,
		ЗагрузитьПродукциюНаСервере());
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	ПараметрыФормыИзменения = Новый Структура;
	ПараметрыФормыИзменения.Вставить("ПродукцияВЕТИС", Объект.Ссылка);
	ОткрытьФорму("Справочник.ПродукцияВЕТИС.Форма.ПомощникСоздания", ПараметрыФормыИзменения);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНаименованиеХС(Команда)
	ЗагрузитьНаименованиеХСНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНаименованиеСобственникаТМ(Команда)
	ЗагрузитьНаименованиеСобственникаТМНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиФормы(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСоответствиеНоменклатурыВЕТИС" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИнтеграцияВЕТИСКлиент.ОткрытьФормуСопоставленияПродукцииВЕТИС(
			Объект.Ссылка,
			ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПродукция" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПоказатьЗначение(,Объект.Продукция);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьВидПродукции" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПоказатьЗначение(,Объект.ВидПродукции);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСписокПроизводителей" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилищеНаСервере());
		ОткрытьФорму("Справочник.ПродукцияВЕТИС.Форма.СписокПроизводителей", ПараметрыФормы,ЭтаФорма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьФормуПроизводителя" Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Объект.Производители.Количество() > 0 Тогда
			ПоказатьЗначение(,Объект.Производители.Получить(0).Производитель);
		КонецЕсли;
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьФасовкаЕдиницаИзмерения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПоказатьЗначение(,Объект.ФасовкаЕдиницаИзмерения);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьФасовкаУпаковка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПоказатьЗначение(,Объект.ФасовкаУпаковка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьОбъект(ОбновитьЭлементы, СсылкаНаОбъект)
	
	СправочникОбъект = СсылкаНаОбъект.ПолучитьОбъект();
	СправочникОбъект.Прочитать();
	ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
	ИдентификаторПродукции = СправочникОбъект.Идентификатор;
	
	Если ОбновитьЭлементы Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	СформироватьНадписьОписаниеПродукции();
	СформироватьНадписьФасовка();
	СформироватьНадписьПроизводители();
	ОбновитьИнформациюОСопоставлении();
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьПродукциюНаСервере()
	Возврат ИнтеграцияВЕТИС.ЗагрузитьНаименованиеПродукцииПоИдентификатору(Объект.Идентификатор);
КонецФункции

&НаСервере
Процедура СформироватьНадписьОписаниеПродукции()
	
	ОписаниеПродукции = Новый ФорматированнаяСтрока(Строка(Объект.ТипПродукции) + " > ");
	ОписаниеПродукцииПодсказка = Строка(Объект.ТипПродукции);
	
	Если ЗначениеЗаполнено(Объект.Продукция) ИЛИ ЗначениеЗаполнено(ПродукцияСтрока) Тогда
		СтрокаПродукция = ?(ЗначениеЗаполнено(ПродукцияСтрока),ПродукцияСтрока, Строка(Объект.Продукция));
		ДлиннаяСтрока = СтрДлина(СтрокаПродукция)>30;
		СтрокаСсылка = Новый ФорматированнаяСтрока(
				Лев(СтрокаПродукция,30),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГосИС,,
				"ОткрытьПродукция");
		ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, СтрокаСсылка, ?(ДлиннаяСтрока,"...",""), " > ");
		ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаПродукция;
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ВидПродукции) ИЛИ ЗначениеЗаполнено(ВидПродукцииСтрока) Тогда
		СтрокаВидПродукции = ?(ЗначениеЗаполнено(ВидПродукцииСтрока), ВидПродукцииСтрока,Строка(Объект.ВидПродукции));
		ДлиннаяСтрока = СтрДлина(СтрокаВидПродукции)>30;
		СтрокаСсылка = Новый ФорматированнаяСтрока(
				Лев(СтрокаВидПродукции,30),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГосИС,,
				"ОткрытьВидПродукции");
		ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, СтрокаСсылка, ?(ДлиннаяСтрока,"...",""));
		ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаВидПродукции;
	КонецЕсли;
	
	Элементы.ОписаниеПродукции.Подсказка = ОписаниеПродукцииПодсказка;
КонецПроцедуры

&НаСервере
Процедура СформироватьНадписьФасовка()
	
	СтрокаФасовка = НСтр("ru='<не указано>'");
	Если ЗначениеЗаполнено(Объект.ФасовкаЕдиницаИзмерения) Тогда 
		СтрокаФасовка = Новый ФорматированнаяСтрока(
			Строка(Объект.ФасовкаЕдиницаИзмерения),
			Новый Шрифт(,,,,Истина),
			ЦветаСтиля.ЦветГиперссылкиГосИС,,
			"ОткрытьФасовкаЕдиницаИзмерения");
		ОписаниеФасовки = Новый ФорматированнаяСтрока(Строка(Объект.ФасовкаКоличествоЕдиницВУпаковке), " ", СтрокаФасовка);
		Если ЗначениеЗаполнено(Объект.ФасовкаУпаковка) Тогда
			СтрокаФасовка = Новый ФорматированнаяСтрока(
				Строка(Объект.ФасовкаУпаковка),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГосИС,,
				"ОткрытьФасовкаУпаковка");
			
			ОписаниеФасовки = Новый ФорматированнаяСтрока(СтрокаФасовка,
				" ",
				Строка(Объект.ФасовкаКоличествоУпаковок),
				" х ",
				ОписаниеФасовки);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ОписаниеФасовки.Видимость = Объект.ФасовкаКоличествоЕдиницВУпаковке > 0;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНадписьПроизводители()
	
	ОсновнойПроизводитель = Неопределено;
	
	Если Производители.Количество() > 0 Тогда
		СписокПроизводителей = Производители;
		ОсновнойПроизводитель = СписокПроизводителей[0];
	Иначе
		СписокПроизводителей = Объект.Производители;
		Если СписокПроизводителей.Количество() > 0 Тогда
			ОсновнойПроизводитель = Объект.Производители.Получить(0).Производитель;
		КонецЕсли;
	КонецЕсли;
	
	КоличествоПроизводителей = СписокПроизводителей.Количество();
	СтрокаПроизводитель = Строка(ОсновнойПроизводитель);
	Если КоличествоПроизводителей > 1 Тогда
		СтрокаПроизводитель = СтрШаблон(НСтр("ru = '%1 ( + еще %2...)'"), СтрокаПроизводитель, КоличествоПроизводителей - 1);
	ИначеЕсли КоличествоПроизводителей = 0 Тогда
		СтрокаПроизводитель = НСтр("ru='<не загружено>'");
	КонецЕсли;
	
	ГиперссылкаПроизводители = ?(КоличествоПроизводителей>1, "ОткрытьСписокПроизводителей", "ОткрытьФормуПроизводителя");
	
	ОписаниеПроизводители = Новый ФорматированнаяСтрока(СтрокаПроизводитель,
		Новый Шрифт(,,,,Истина),
		ЦветаСтиля.ЦветГиперссылкиГосИС,,
		ГиперссылкаПроизводители);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ДобавлениеДоступно = ПравоДоступа("Добавление", Метаданные.Справочники.ПродукцияВЕТИС);
	
	Элементы.Статус.Видимость                            = ИнтеграцияВЕТИС.СтатусУдаленногоОбъекта(Объект.Статус);
	Элементы.Идентификатор.Видимость                     = ЗначениеЗаполнено(Объект.Идентификатор);
	Элементы.GTIN.Видимость                              = Не Объект.ЭтоГруппа;
	Элементы.Артикул.Видимость                           = Не Объект.ЭтоГруппа;
	Элементы.ГОСТ.Видимость                              = Не Объект.ЭтоГруппа;
	Элементы.СоответствуетГОСТ.Видимость                 = Не Объект.ЭтоГруппа;
	Элементы.КодТНВЭД.Видимость                          = ЗначениеЗаполнено(Объект.ТипПродукции) И Объект.ЭтоГруппа;
	Элементы.ХозяйствующийСубъектПроизводитель.Видимость = ЗначениеЗаполнено(Объект.ХозяйствующийСубъектПроизводитель);
	Элементы.ГруппаХС.Видимость                          = Не ЗначениеЗаполнено(Объект.ХозяйствующийСубъектПроизводитель) И Не Объект.ЭтоГруппа;
	Элементы.ГруппаСобственникТМ.Видимость               = Не Объект.ЭтоГруппа;
	
	Элементы.ФормаЗагрузитьВБазу.Видимость = ЗначениеЗаполнено(ИдентификаторПродукции) И ДобавлениеДоступно;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ФормаЗагрузитьВБазу.Заголовок = НСтр("ru = 'Обновить из сервиса'");
	Иначе
		Элементы.ФормаЗагрузитьВБазу.Заголовок = НСтр("ru = 'Загрузить'");
	КонецЕсли;
	
	Элементы.ЗагрузитьНаименованиеХС.Доступность             = ЗначениеЗаполнено(Объект.ХозяйствующийСубъектПроизводительИдентификатор);
	Элементы.ЗагрузитьНаименованиеСобственникаТМ.Доступность = ЗначениеЗаполнено(Объект.ХозяйствующийСубъектСобственникТорговойМаркиИдентификатор);
	Элементы.ОписаниеПроизводители.Видимость                 = Не Объект.ЭтоГруппа;
	
	Элементы.ФормаИзменить.Видимость = ЗначениеЗаполнено(Объект.ХозяйствующийСубъектПроизводитель)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ХозяйствующийСубъектПроизводитель, "СоответствуетОрганизации")
		И ЗначениеЗаполнено(Объект.Ссылка)
		И ДобавлениеДоступно;
	
	Если Объект.ЭтоГруппа Или ЗначениеЗаполнено(ИдентификаторПродукции) Тогда
		Элементы.Сопоставлено.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОСопоставлении()
	
	Если Объект.ЭтоГруппа ИЛИ ЗначениеЗаполнено(ИдентификаторПродукции) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = Справочники.ПродукцияВЕТИС.ТекстЗапросаИнформацияОСопоставлении();
	Запрос.УстановитьПараметр("Продукция", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Если Выборка.Количество = 1 И ЗначениеЗаполнено(Выборка.Номенклатура) Тогда
			
			Сопоставлено = Новый ФорматированнаяСтрока(
				ИнтеграцияИС.ПредставлениеНоменклатуры(Выборка.Номенклатура, Выборка.Характеристика),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГосИС,,
				"ОткрытьСоответствиеНоменклатурыВЕТИС");
			
		ИначеЕсли Выборка.Количество > 1 И ЗначениеЗаполнено(Выборка.Номенклатура) Тогда
			
			Сопоставлено = Новый ФорматированнаяСтрока(
				СтрШаблон(НСтр("ru = '%1 ( + еще %2...)'"), Выборка.НоменклатураПредставление, Выборка.Количество - 1),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГосИС,,
				"ОткрытьСоответствиеНоменклатурыВЕТИС");
			
		Иначе
			
			Сопоставлено = Новый ФорматированнаяСтрока(
				НСтр("ru = '<Не сопоставлено>'"),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС,,
				"ОткрытьСоответствиеНоменклатурыВЕТИС");
			
		КонецЕсли;
	Иначе
		Элементы.Сопоставлено.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Производители.Выгрузить());
	
КонецФункции

&НаСервере
Процедура ЗагрузитьДанныеПоИдентификатору()
	
	РезультатВыполненияЗапроса = ПродукцияВЕТИСВызовСервера.НаименованиеПродукцииПоGUID(ИдентификаторПродукции);
	Если ЗначениеЗаполнено(РезультатВыполненияЗапроса.ТекстОшибки) Тогда
		ВызватьИсключение РезультатВыполненияЗапроса.ТекстОшибки;
	Иначе
		Данные = ИнтеграцияВЕТИС.ДанныеНаименованияПродукцииДляПросмотра(РезультатВыполненияЗапроса.Элемент);
		ЗаполнитьЗначенияСвойств(Объект, Данные, , "Производители");
		ПродукцияСтрока = Данные.Продукция;
		ВидПродукцииСтрока = Данные.ВидПродукции;
		
		ХСПроизводительСтрока = Данные.ХозяйствующийСубъектПроизводитель;
		ХССобственникТМСтрока = Данные.ХозяйствующийСубъектСобственникТорговойМарки;
		Производители.ЗагрузитьЗначения(Данные.Производители);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаименованиеХСНаСервере()
	
	Результат = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектПоGUID(Объект.ХозяйствующийСубъектПроизводительИдентификатор);
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
	Иначе
		ХСПроизводительСтрока = Результат.Элемент.name;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаименованиеСобственникаТМНаСервере()
	
	Результат = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектПоGUID(Объект.ХозяйствующийСубъектСобственникТорговойМаркиИдентификатор);
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
	Иначе
		ХССобственникТМСтрока = Результат.Элемент.name;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти