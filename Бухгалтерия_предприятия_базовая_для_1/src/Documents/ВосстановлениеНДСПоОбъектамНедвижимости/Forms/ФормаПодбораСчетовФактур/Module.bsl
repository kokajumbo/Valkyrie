
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокСвойств = "Дата, КлючСтроки, Организация, ОсновноеСредство";
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, СписокСвойств);
	
	ЗагрузитьСчетаФактуры(Параметры.АдресСчетаФактурыВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		АдресСчетаФактурыВХранилище = ПоместитьСчетаФактуры();
		Структура = Новый Структура();
		Структура.Вставить("АдресСчетаФактурыВХранилище", АдресСчетаФактурыВХранилище);
		
		ОповеститьОВыборе(Структура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСчетаФактурыПодбор

&НаКлиенте
Процедура СчетаФактурыПодборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаФактурыПодборСуммаБезНДСПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СчетаФактурыПодбор.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные.НДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		ТекущиеДанные.СуммаБезНДС, Ложь, УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ТекущиеДанные.СтавкаНДС));
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для Каждого СтрокаСчетФактура ИЗ СчетаФактурыПодбор Цикл
		СтрокаСчетФактура.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделениеВсех(Команда)
	
	Для Каждого СтрокаСчетФактура ИЗ СчетаФактурыПодбор Цикл
		СтрокаСчетФактура.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	Если СчетаФактурыПодбор.Количество() <> 0 Тогда
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличное поле будет очищено. Продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);	
	Иначе
		ЗаполнитьСписокСчетовФактур(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)

	ТекстВопроса = НСтр("ru = 'Вы уверены, что хотите очистить список счетов-фактур?'");
	Оповещение = Новый ОписаниеОповещения("ВопросОчиститьЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);	
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнить(Команда)

	ЗаполнитьСписокСчетовФактур(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьКодОперацииДляДекларации(ВидЦенности)
	
	Если ВидЦенности = Перечисления.ВидыЦенностей.ОбъектыНезавершенногоСтроительства Тогда
		Возврат Перечисления.НДСКодыОперацийПоОбъектамНедвижимости.Приобретение;
	ИначеЕсли ВидЦенности = Перечисления.ВидыЦенностей.СМРПодрядные Тогда
		Возврат Перечисления.НДСКодыОперацийПоОбъектамНедвижимости.СМРПодрядные;
	ИначеЕсли ВидЦенности = Перечисления.ВидыЦенностей.СМРСобственнымиСилами Тогда
		Возврат Перечисления.НДСКодыОперацийПоОбъектамНедвижимости.СМРСобственные;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокСчетовФактур(Дополнять = Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОС", ОсновноеСредство);
	Запрос.УстановитьПараметр("КонецПериода", ДобавитьМесяц(КонецГода(Дата), 1));
	
	ВидыСубконтоОбъектыСтатьиСпособСтроительства = Новый Массив;
	ВидыСубконтоОбъектыСтатьиСпособСтроительства.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства);
	ВидыСубконтоОбъектыСтатьиСпособСтроительства.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат);
	ВидыСубконтоОбъектыСтатьиСпособСтроительства.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СпособыСтроительства);
	Запрос.УстановитьПараметр("ВидыСубконтоОбъектыСтатьиСпособСтроительства", ВидыСубконтоОбъектыСтатьиСпособСтроительства);

	ВидыСубконтоКонтрагентыДоговоры = Новый Массив;
	ВидыСубконтоКонтрагентыДоговоры.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКонтрагентыДоговоры.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	Запрос.УстановитьПараметр("ВидыСубконтоКонтрагентыДоговоры", ВидыСубконтоКонтрагентыДоговоры);

	// Определим проводки Дт 01 - Кт 08.04 или Дт 01 - Кт 08.03, которыми принималось к учету 
	// или модернизировалось ОС, и по ним для номенклатуры или объекта строительства, 
	// из которых получено ОС, определяем документы поступления - счета-фактуры поставщиков.
	//
	// В случае объекта строительства номенклатура могла быть изначально оприходована на 07, 
	// а потом передана в монтаж Дт 08.03 - Кт 07, поэтому на один шаг поиска надо сделать больше.
	//
	// Для объектов строительства хозспособом дополнительно выбираем данные документов НачислениеНДСпоСМРхозспособом.

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетаБухгалтерскогоУчетаОС.СчетУчета
	|ПОМЕСТИТЬ ВТ_СчетаУчетаОС
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК СчетаБухгалтерскогоУчетаОС
	|ГДЕ
	|	СчетаБухгалтерскогоУчетаОС.ОсновноеСредство = &ОС
	|	И СчетаБухгалтерскогоУчетаОС.Организация = &Организация
	|	И СчетаБухгалтерскогоУчетаОС.Период <= &КонецПериода
	|	И СчетаБухгалтерскогоУчетаОС.Активность
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетаБухгалтерскогоУчетаОС.СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Хозрасчетный.Регистратор,
	|	Хозрасчетный.КорСчет КАК СчетУчетаВнеоборотногоАктива,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.КорСубконто1 ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ВЫРАЗИТЬ(Хозрасчетный.КорСубконто1 КАК Справочник.Номенклатура)
	|		КОГДА Хозрасчетный.КорСубконто2 ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ВЫРАЗИТЬ(Хозрасчетный.КорСубконто2 КАК Справочник.Номенклатура)
	|		КОГДА Хозрасчетный.КорСубконто3 ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ВЫРАЗИТЬ(Хозрасчетный.КорСубконто3 КАК Справочник.Номенклатура)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.КорСубконто1 ССЫЛКА Справочник.ОбъектыСтроительства
	|			ТОГДА ВЫРАЗИТЬ(Хозрасчетный.КорСубконто1 КАК Справочник.ОбъектыСтроительства)
	|		КОГДА Хозрасчетный.КорСубконто2 ССЫЛКА Справочник.ОбъектыСтроительства
	|			ТОГДА ВЫРАЗИТЬ(Хозрасчетный.КорСубконто2 КАК Справочник.ОбъектыСтроительства)
	|		КОГДА Хозрасчетный.КорСубконто3 ССЫЛКА Справочник.ОбъектыСтроительства
	|			ТОГДА ВЫРАЗИТЬ(Хозрасчетный.КорСубконто3 КАК Справочник.ОбъектыСтроительства)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ОбъектСтроительства
	|ПОМЕСТИТЬ ВТ_ВнеоборотныеАктивы
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&КонецПериода,
	|			Регистратор,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаУчетаОС.СчетУчета
	|				ИЗ
	|					ВТ_СчетаУчетаОС),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация
	|				И Субконто1 = &ОС,
	|			,
	|			) КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.СуммаОборотДт <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Хозрасчетный.Регистратор,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ВнеоборотныеАктивы.СчетУчетаВнеоборотногоАктива,
	|	ВТ_ВнеоборотныеАктивы.ОбъектСтроительства
	|ПОМЕСТИТЬ ВТ_ОбъектыСтроительства
	|ИЗ
	|	ВТ_ВнеоборотныеАктивы КАК ВТ_ВнеоборотныеАктивы
	|ГДЕ
	|	ВТ_ВнеоборотныеАктивы.ОбъектСтроительства <> НЕОПРЕДЕЛЕНО
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВТ_ВнеоборотныеАктивы.ОбъектСтроительства,
	|	ВТ_ВнеоборотныеАктивы.СчетУчетаВнеоборотногоАктива
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОбороты.КорСчет КАК СчетУчетВнеоборотногоАктива,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.КорСубконто1 КАК Справочник.Номенклатура) КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_ОборудованиеКУстановке
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&КонецПериода,
	|			,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_ОбъектыСтроительства.СчетУчетаВнеоборотногоАктива
	|				ИЗ
	|					ВТ_ОбъектыСтроительства),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства),
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						ВТ_ОбъектыСтроительства.ОбъектСтроительства
	|					ИЗ
	|						ВТ_ОбъектыСтроительства),
	|			,
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура)) КАК ХозрасчетныйОбороты
	|ГДЕ
	|	ХозрасчетныйОбороты.СуммаОборотДт <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВнеоборотныеАктивы.СчетУчетаВнеоборотногоАктива,
	|	ВТ_ВнеоборотныеАктивы.Номенклатура
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|	ВТ_ВнеоборотныеАктивы КАК ВТ_ВнеоборотныеАктивы
	|ГДЕ
	|	ВТ_ВнеоборотныеАктивы.Номенклатура <> НЕОПРЕДЕЛЕНО
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВТ_ОборудованиеКУстановке.СчетУчетВнеоборотногоАктива,
	|	ВТ_ОборудованиеКУстановке.Номенклатура
	|ИЗ
	|	ВТ_ОборудованиеКУстановке КАК ВТ_ОборудованиеКУстановке
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВТ_ВнеоборотныеАктивы.Номенклатура,
	|	ВТ_ВнеоборотныеАктивы.СчетУчетаВнеоборотногоАктива
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК СчетРасчетов
	|ПОМЕСТИТЬ ВТ_СчетаРасчетовСПоставщиками
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчиками), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторами), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчикамиВал), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиВал), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчикамиУЕ), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиУЕ), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.КорректировкаРасчетовПрошлогоПериода))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетРасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеОбъектовСтроительства.Ссылка,
	|	ПоступлениеОбъектовСтроительства.ОбъектСтроительства,
	|	ПоступлениеОбъектовСтроительства.СчетУчета
	|ПОМЕСТИТЬ ВТ_ПоступлениеОбъектовСтроительства
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.ОбъектыСтроительства КАК ПоступлениеОбъектовСтроительства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ОбъектыСтроительства КАК ВТ_ОбъектыСтроительства
	|		ПО ПоступлениеОбъектовСтроительства.ОбъектСтроительства = ВТ_ОбъектыСтроительства.ОбъектСтроительства
	|			И ПоступлениеОбъектовСтроительства.СчетУчета = ВТ_ОбъектыСтроительства.СчетУчетаВнеоборотногоАктива
	|ГДЕ
	|	ПоступлениеОбъектовСтроительства.Ссылка.Проведен
	|	И ПоступлениеОбъектовСтроительства.Ссылка.Дата <= &КонецПериода
	|	И ПоступлениеОбъектовСтроительства.Ссылка.Организация = &Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПоступлениеОбъектовСтроительства.Ссылка,
	|	ПоступлениеОбъектовСтроительства.ОбъектСтроительства,
	|	ПоступлениеОбъектовСтроительства.СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДСпоПриобретеннымЦенностям.Номенклатура,
	|	НДСпоПриобретеннымЦенностям.Регистратор,
	|	НДСпоПриобретеннымЦенностям.СчетУчета,
	|	НДСпоПриобретеннымЦенностям.ВидЦенности,
	|	НДСпоПриобретеннымЦенностям.СчетФактура,
	|	НДСпоПриобретеннымЦенностям.Период,
	|	СУММА(НДСпоПриобретеннымЦенностям.Стоимость - НДСпоПриобретеннымЦенностям.НДС) КАК СуммаБезНДС,
	|	СУММА(НДСпоПриобретеннымЦенностям.НДС) КАК НДС
	|ПОМЕСТИТЬ ВТ_НДСПоПриобретеннымЦенностям
	|ИЗ
	|	РегистрНакопления.НДСПоПриобретеннымЦенностям КАК НДСпоПриобретеннымЦенностям
	|ГДЕ
	|	НДСпоПриобретеннымЦенностям.Период <= &КонецПериода
	|	И НДСпоПриобретеннымЦенностям.Организация = &Организация
	|	И НДСпоПриобретеннымЦенностям.НДСВключенВСтоимость = ЛОЖЬ
	|	И НДСпоПриобретеннымЦенностям.Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС
	|	И НДСпоПриобретеннымЦенностям.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И НДСпоПриобретеннымЦенностям.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	НДСпоПриобретеннымЦенностям.Номенклатура,
	|	НДСпоПриобретеннымЦенностям.Регистратор,
	|	НДСпоПриобретеннымЦенностям.СчетУчета,
	|	НДСпоПриобретеннымЦенностям.ВидЦенности,
	|	НДСпоПриобретеннымЦенностям.СчетФактура,
	|	НДСпоПриобретеннымЦенностям.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НДСпоПриобретеннымЦенностям.Номенклатура,
	|	НДСпоПриобретеннымЦенностям.Регистратор,
	|	НДСпоПриобретеннымЦенностям.СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДСпоПриобретеннымЦенностям.СчетФактура КАК СчетФактура,
	|	НДСпоПриобретеннымЦенностям.Период КАК Период,
	|	NULL КАК СчетРасчетов,
	|	ВТ_ВнеоборотныеАктивы.СчетУчетаВнеоборотногоАктива,
	|	НДСпоПриобретеннымЦенностям.ВидЦенности,
	|	NULL КАК Поставщик,
	|	NULL КАК УчетАгентскогоНДС,
	|	NULL КАК ВидАгентскогоДоговора,
	|	ВТ_ВнеоборотныеАктивы.Номенклатура КАК ВнеоборотныйАктив,
	|	NULL КАК СпособСтроительства,
	|	ВТ_ВнеоборотныеАктивы.Номенклатура КАК Объект,
	|	НДСпоПриобретеннымЦенностям.СуммаБезНДС КАК СуммаБезНДС,
	|	НДСпоПриобретеннымЦенностям.НДС КАК НДС
	|ИЗ
	|	ВТ_ВнеоборотныеАктивы КАК ВТ_ВнеоборотныеАктивы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_НДСПоПриобретеннымЦенностям КАК НДСпоПриобретеннымЦенностям
	|		ПО ВТ_ВнеоборотныеАктивы.Регистратор = НДСпоПриобретеннымЦенностям.Регистратор
	|			И ВТ_ВнеоборотныеАктивы.Номенклатура = НДСпоПриобретеннымЦенностям.Номенклатура
	|			И ВТ_ВнеоборотныеАктивы.СчетУчетаВнеоборотногоАктива = НДСпоПриобретеннымЦенностям.СчетУчета
	|ГДЕ
	|	ВТ_ВнеоборотныеАктивы.Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Хозрасчетный.Регистратор,
	|	Хозрасчетный.Период,
	|	Хозрасчетный.Счет,
	|	Хозрасчетный.КорСчет,
	|	NULL,
	|	Хозрасчетный.Субконто1,
	|	ЕСТЬNULL(ДоговорыКонтрагентов.УчетАгентскогоНДС, ЛОЖЬ),
	|	ДоговорыКонтрагентов.ВидАгентскогоДоговора,
	|	Хозрасчетный.КорСубконто1,
	|	NULL,
	|	Хозрасчетный.КорСубконто1,
	|	Хозрасчетный.СуммаОборотКт,
	|	0
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&КонецПериода,
	|			Регистратор,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаРасчетовСПоставщиками.СчетРасчетов
	|				ИЗ
	|					ВТ_СчетаРасчетовСПоставщиками),
	|			&ВидыСубконтоКонтрагентыДоговоры,
	|			Организация = &Организация
	|				И КорСубконто1 В
	|					(ВЫБРАТЬ
	|						ВТ_Номенклатура.Номенклатура
	|					ИЗ
	|						ВТ_Номенклатура),
	|			КорСчет В
	|				(ВЫБРАТЬ
	|					ВТ_Номенклатура.СчетУчетаВнеоборотногоАктива
	|				ИЗ
	|					ВТ_Номенклатура),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура)) КАК Хозрасчетный
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Номенклатура КАК ВТ_Номенклатура
	|		ПО Хозрасчетный.КорСчет = ВТ_Номенклатура.СчетУчетаВнеоборотногоАктива
	|			И Хозрасчетный.КорСубконто1 = ВТ_Номенклатура.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО Хозрасчетный.Субконто2 = ДоговорыКонтрагентов.Ссылка
	|ГДЕ
	|	Хозрасчетный.СуммаОборотКт <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Хозрасчетный.Регистратор,
	|	Хозрасчетный.Период,
	|	Хозрасчетный.Счет,
	|	Хозрасчетный.КорСчет,
	|	NULL,
	|	Хозрасчетный.Субконто1,
	|	ЕСТЬNULL(ДоговорыКонтрагентов.УчетАгентскогоНДС, ЛОЖЬ),
	|	ДоговорыКонтрагентов.ВидАгентскогоДоговора,
	|	Хозрасчетный.КорСубконто1,
	|	Хозрасчетный.КорСубконто3,
	|	ВЫБОР
	|		КОГДА НЕ ВТ_ПоступлениеОбъектовСтроительства.Ссылка ЕСТЬ NULL 
	|			ТОГДА Хозрасчетный.КорСубконто1
	|		ИНАЧЕ Хозрасчетный.КорСубконто2
	|	КОНЕЦ,
	|	Хозрасчетный.СуммаОборотКт,
	|	0
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&КонецПериода,
	|			Регистратор,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаРасчетовСПоставщиками.СчетРасчетов
	|				ИЗ
	|					ВТ_СчетаРасчетовСПоставщиками),
	|			&ВидыСубконтоКонтрагентыДоговоры,
	|			Организация = &Организация
	|				И КорСубконто1 В
	|					(ВЫБРАТЬ
	|						ВТ_ОбъектыСтроительства.ОбъектСтроительства
	|					ИЗ
	|						ВТ_ОбъектыСтроительства),
	|			КорСчет В
	|				(ВЫБРАТЬ
	|					ВТ_ОбъектыСтроительства.СчетУчетаВнеоборотногоАктива
	|				ИЗ
	|					ВТ_ОбъектыСтроительства),
	|			&ВидыСубконтоОбъектыСтатьиСпособСтроительства) КАК Хозрасчетный
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ОбъектыСтроительства КАК ВТ_ОбъектыСтроительства
	|		ПО Хозрасчетный.КорСчет = ВТ_ОбъектыСтроительства.СчетУчетаВнеоборотногоАктива
	|			И Хозрасчетный.КорСубконто1 = ВТ_ОбъектыСтроительства.ОбъектСтроительства
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПоступлениеОбъектовСтроительства КАК ВТ_ПоступлениеОбъектовСтроительства
	|		ПО Хозрасчетный.Регистратор = ВТ_ПоступлениеОбъектовСтроительства.Ссылка
	|			И Хозрасчетный.КорСчет = ВТ_ПоступлениеОбъектовСтроительства.СчетУчета
	|			И Хозрасчетный.КорСубконто1 = ВТ_ПоступлениеОбъектовСтроительства.ОбъектСтроительства
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО Хозрасчетный.Субконто2 = ДоговорыКонтрагентов.Ссылка
	|ГДЕ
	|	Хозрасчетный.СуммаОборотКт <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НачислениеНДСпоСМРхозспособом.Ссылка,
	|	НачислениеНДСпоСМРхозспособом.Ссылка.Дата,
	|	NULL,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств),
	|	NULL,
	|	NULL,
	|	ЛОЖЬ,
	|	NULL,
	|	НачислениеНДСпоСМРхозспособом.ОбъектСтроительства,
	|	NULL,
	|	НачислениеНДСпоСМРхозспособом.ОбъектСтроительства,
	|	НачислениеНДСпоСМРхозспособом.СуммаБезНДС,
	|	НачислениеНДСпоСМРхозспособом.НДС
	|ИЗ
	|	Документ.НачислениеНДСпоСМРхозспособом.СМРхозспособом КАК НачислениеНДСпоСМРхозспособом
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ОбъектыСтроительства КАК ВТ_ОбъектыСтроительства
	|		ПО НачислениеНДСпоСМРхозспособом.ОбъектСтроительства = ВТ_ОбъектыСтроительства.ОбъектСтроительства
	|ГДЕ
	|	НачислениеНДСпоСМРхозспособом.Ссылка.Дата <= &КонецПериода
	|	И НачислениеНДСпоСМРхозспособом.Ссылка.Организация = &Организация
	|	И НачислениеНДСпоСМРхозспособом.Ссылка.Проведен";

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСчетовФактур = Результат.Выгрузить();
	ВидыЦенностейПоСчетамУчета = Неопределено;
	СтруктураШапкиДокумента = Новый Структура();
	
	Для Каждого СтрокаТаблицы Из ТаблицаСчетовФактур Цикл
	
		Если ЗначениеЗаполнено(СтрокаТаблицы.ВидЦенности) Тогда
			Продолжить;
		КонецЕсли;
	
		СтруктураШапкиДокумента.Вставить("Дата", СтрокаТаблицы.Период);
	
		СтрокаТаблицы.ВидЦенности = УчетНДС.ОпределитьВидЦенностиПоОперации(
			СтрокаТаблицы.Объект, 
			СтрокаТаблицы.СчетУчетаВнеоборотногоАктива, 
			БухгалтерскийУчетКлиентСерверПереопределяемый.ДокументЯвляетсяПоступлениемДопРасходов(СтрокаТаблицы.СчетФактура),
			СтрокаТаблицы.УчетАгентскогоНДС,
			СтрокаТаблицы.ВидАгентскогоДоговора, 
			СтрокаТаблицы.СпособСтроительства, 
			Ложь, // ЭтоУслуга
			ВидыЦенностейПоСчетамУчета,
			СтруктураШапкиДокумента);
	
	КонецЦикла;
	
	СписокСчетовФактур = ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(ТаблицаСчетовФактур.ВыгрузитьКолонку("СчетФактура"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСчетовФактур", СписокСчетовФактур);
	Запрос.Текст = "ВЫБРАТЬ
	               |	НДСЗаписиКнигиПокупок.СчетФактура,
	               |	НДСЗаписиКнигиПокупок.ВидЦенности,
	               |	НДСЗаписиКнигиПокупок.Поставщик,
	               |	СУММА(НДСЗаписиКнигиПокупок.СуммаБезНДС) КАК СуммаБезНДС,
	               |	НДСЗаписиКнигиПокупок.СтавкаНДС,
	               |	СУММА(НДСЗаписиКнигиПокупок.НДС) КАК НДС,
	               |	НДСЗаписиКнигиПокупок.СчетУчетаНДС
	               |ИЗ
	               |	РегистрНакопления.НДСЗаписиКнигиПокупок КАК НДСЗаписиКнигиПокупок
	               |ГДЕ
	               |	НДСЗаписиКнигиПокупок.СчетФактура В(&СписокСчетовФактур)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НДСЗаписиКнигиПокупок.СтавкаНДС,
	               |	НДСЗаписиКнигиПокупок.ВидЦенности,
	               |	НДСЗаписиКнигиПокупок.СчетФактура,
	               |	НДСЗаписиКнигиПокупок.Поставщик,
	               |	НДСЗаписиКнигиПокупок.СчетУчетаНДС
	               |
	               |ИМЕЮЩИЕ
	               |	СУММА(НДСЗаписиКнигиПокупок.СуммаБезНДС) + СУММА(НДСЗаписиКнигиПокупок.НДС) > 0";
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВычетов = Результат.Выгрузить();
	СтруктураОтбора = Новый Структура("СчетФактура, ВидЦенности");
	ТаблицаВычетов.Индексы.Добавить("СчетФактура, ВидЦенности");
	СтруктураОтбораСуществующих = Новый Структура("СчетФактура, ВидЦенности");
	
	Для Каждого СтрокаСчетФактура ИЗ ТаблицаСчетовФактур Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаСчетФактура);
		ЗаполнитьЗначенияСвойств(СтруктураОтбораСуществующих, СтрокаСчетФактура);
		
		СтрокиОтбора = ТаблицаВычетов.НайтиСтроки(СтруктураОтбора);
		
		СуммаБезНДСпоСтрокеСФ 	= СтрокаСчетФактура.СуммаБезНДС;
		НДСпоСтрокеСФ			= СтрокаСчетФактура.НДС;
		
		Для Каждого СтрокаОтбора ИЗ СтрокиОтбора Цикл
			
			Если СуммаБезНДСпоСтрокеСФ <= 0 Тогда
				Прервать;
			КонецЕсли;
			
			Если НДСпоСтрокеСФ = 0 Тогда
				НДСпоСтрокеСФ = УчетНДСКлиентСервер.РассчитатьСуммуНДС(СуммаБезНДСпоСтрокеСФ,
					Ложь, УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаОтбора.СтавкаНДС));

				Если СуммаБезНДСпоСтрокеСФ = СтрокаОтбора.СуммаБезНДС Тогда
					НДСпоСтрокеСФ 		= СтрокаОтбора.НДС;
				КонецЕсли;

			КонецЕсли;
			
			Если Дополнять Тогда
				СуществующиеСФ = СчетаФактурыПодбор.НайтиСтроки(СтруктураОтбораСуществующих);
				Для Каждого СуществующаяСФ ИЗ СуществующиеСФ Цикл
					СуммаБезНДСВычета = Мин(СуществующаяСФ.СуммаБезНДС, СуммаБезНДСпоСтрокеСФ);
					НДСВычета = Мин(СуществующаяСФ.НДС, НДСпоСтрокеСФ);
					
					Если СуммаБезНДСВычета - СуществующаяСФ.СуммаБезНДС < 0 Тогда
						ТекстСообщения = НСтр("ru = 'Сумма без НДС по счету-фактуре &СчетФактура& превышает сумму без НДС вычета 
												|по данным книги покупок'");
                        ТекстСообщения = СтрЗаменить(ТекстСообщения, "&СчетФактура&", СуществующаяСФ.СчетФактура);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					КонецЕсли;
					Если СуммаБезНДСВычета - СуществующаяСФ.СуммаБезНДС < 0 Тогда
						ТекстСообщения = НСтр("ru = 'Сумма НДС по счету-фактуре &СчетФактура& превышает сумму НДС вычета 
												|по данным книги покупок'");
                        ТекстСообщения = СтрЗаменить(ТекстСообщения, "&СчетФактура&", СуществующаяСФ.СчетФактура);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					КонецЕсли;	
					СуммаБезНДСпоСтрокеСФ 	= СуммаБезНДСпоСтрокеСФ - СуммаБезНДСВычета;
					НДСпоСтрокеСФ 			= НДСпоСтрокеСФ - НДСВычета;
					
					// Уменьшим доступный вычет по данным книги на сумму уже существующих в ТЧ счетов-фактур.
					СтрокаОтбора.СуммаБезНДС 	= СтрокаОтбора.СуммаБезНДС - СуществующаяСФ.СуммаБезНДС;
					СтрокаОтбора.НДС 			= СтрокаОтбора.НДС - СуществующаяСФ.НДС;
				КонецЦикла;
			КонецЕсли;
			
			СуммаБезНДСВычета = Мин(СуммаБезНДСпоСтрокеСФ, СтрокаОтбора.СуммаБезНДС);
			НДСВычета = Мин(НДСпоСтрокеСФ, СтрокаОтбора.НДС);
			
			Если СуммаБезНДСВычета <= 0 ИЛИ НДСВычета <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = СчетаФактурыПодбор.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОтбора);
			НоваяСтрока.СуммаБезНДС = СуммаБезНДСВычета;
			НоваяСтрока.НДС = НДСВычета;
			Если НоваяСтрока.ВидЦенности = Перечисления.ВидыЦенностей.ОбъектыНезавершенногоСтроительства
				ИЛИ НоваяСтрока.ВидЦенности = Перечисления.ВидыЦенностей.СМРПодрядные
				ИЛИ НоваяСтрока.ВидЦенности = Перечисления.ВидыЦенностей.СМРСобственнымиСилами Тогда
				НоваяСтрока.Выбран = Истина;
			КонецЕсли;
			НоваяСтрока.КодОперацииДляДекларации = ПолучитьКодОперацииДляДекларации(НоваяСтрока.ВидЦенности);
			
			СуммаБезНДСпоСтрокеСФ = СуммаБезНДСпоСтрокеСФ - СуммаБезНДСВычета;
			НДСпоСтрокеСФ = НДСпоСтрокеСФ - НДСВычета;
			
			СтрокаОтбора.СуммаБезНДС = СтрокаОтбора.СуммаБезНДС - СуммаБезНДСВычета;
			СтрокаОтбора.НДС = СтрокаОтбора.НДС - НДСВычета;
			
		КонецЦикла;
		СтрокаСчетФактура.СуммаБезНДС 	= СуммаБезНДСпоСтрокеСФ;
		СтрокаСчетФактура.НДС 			= НДСпоСтрокеСФ;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьСчетаФактуры()
	
	СтрокиКПомещению = СчетаФактурыПодбор.НайтиСтроки(Новый Структура("Выбран", Истина));

	тзСчетаФактуры = СчетаФактурыПодбор.Выгрузить(СтрокиКПомещению);
	
	АдресСчетаФактурыВХранилище = ПоместитьВоВременноеХранилище(тзСчетаФактуры, УникальныйИдентификатор);
	
	Возврат АдресСчетаФактурыВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьСчетаФактуры(АдресСчетаФактурыВХранилище)
	
	ТаблицаСчетаФактуры = ПолучитьИзВременногоХранилища(АдресСчетаФактурыВХранилище);
	СчетаФактурыПодбор.Загрузить(ТаблицаСчетаФактуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СчетаФактурыПодбор.Очистить();
		ЗаполнитьСписокСчетовФактур(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОчиститьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СчетаФактурыПодбор.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

