// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьЗаполнениеПоИНН;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользованныйВычет = НовыйИспользованныйВычет();
	Если ТипЗнч(Параметры.ИспользованныйВычет) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ИспользованныйВычет, Параметры.ИспользованныйВычет);
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов") 
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов)
		И Параметры.СтруктураДоходовВычетов.Свойство("ДанныеФормы")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов.ДанныеФормы) Тогда
		ЗаполнитьФормуИзДанных(Параметры.СтруктураДоходовВычетов.ДанныеФормы);
	Иначе
		ЗаполнитьНовуюФорму();
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	КодыВидовДоходовРФ = Отчеты.РегламентированныйОтчет3НДФЛ.КодыВидовДоходовРФ(Параметры.Декларация3НДФЛВыбраннаяФорма);
	
	Если Отчеты.РегламентированныйОтчет3НДФЛ.МожноНеУказыватьНаименованиеИсточникаДохода(Параметры.Декларация3НДФЛВыбраннаяФорма) Тогда
		Элементы.ВидКонтрагента.СписокВыбора.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ПустаяСсылка(), НСтр("ru = 'Неизвестен'"));
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ИсточникДоходовПриСозданииНаСервере(ЭтотОбъект, Ложь);
	УправлениеФормой(ЭтотОбъект);
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	// Доля
	Если ВидИмущества = "Доля" Тогда
		Если ДоляЧислитель > ДоляЗнаменатель Тогда
				ТекстСообщения = НСтр("ru = 'Значение доли указано неправильно'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ДоляЧислитель", , Отказ);
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДоляЧислитель");
		МассивНепроверяемыхРеквизитов.Добавить("ДоляЗнаменатель");
	КонецЕсли;
	
	Если ВидВычета = "Расходы" И СуммаВычета > СуммаПродажи Тогда
		ТекстСообщения = НСтр("ru = 'Сумма расходов превышает сумму продажи'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "СуммаВычета", , Отказ);
	КонецЕсли;
	
	// Информация из кадастра
	Если НЕ НедвижимостьПриобретенаПосле01012016 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КадастровыйНомер");
	КонецЕсли;
	
	// При продаже имущества физическому лицу указывать ИНН и ОКТМО не обязательно.
	Если ВидКонтрагента <> Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИНН");
		МассивНепроверяемыхРеквизитов.Добавить("ОКТМО");
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ПроверитьЗаполнениеРеквизитовИсточникаДоходов(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ОрганизацииФормыДляОтчетности.ПроверитьКодПоОКТМОНаФорме(ОКТМО, "ОКТМО", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидИмуществаПриИзменении(Элемент)
	
	УстановитьВидВычета(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	// Очистим реквизиты, которые зависят от вида контрагента.
	Наименование = "";
	ФИО = "";
	ИНН = "";
	КПП = "";
	ОКТМО = "";
	
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьВидимостьПолейКонтрагента(ЭтотОбъект, Ложь);
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПолеПоискаИНННаименование)
		И НЕ ЗначениеЗаполнено(ИНН) 
		И НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ИНН = СокрП(ИНН);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	КПП = СокрП(КПП);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидВычетаПриИзменении(Элемент)
	
	Если ВидВычета = "Норматив" Тогда
		СуммаВычета = 0;
	КонецЕсли;
	
	УстановитьВидимостьВычета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НедвижимостьПриобретенаПосле01012016ПриИзменении(Элемент)
	
	УстановитьВидимостьИнформацияИзКадастра(ЭтотОбъект);
	УстановитьТекстНалоговаяБаза(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КадастроваяСтоимостьПриИзменении(Элемент)
	
	УстановитьТекстНалоговаяБаза(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПонижающийКоэффициентПриИзменении(Элемент)
	
	УстановитьТекстНалоговаяБаза(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПродажиПриИзменении(Элемент)
	
	Если НедвижимостьПриобретенаПосле01012016 Тогда
		УстановитьТекстНалоговаяБаза(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗнаменательДолиПриИзменении(Элемент)
	
	УстановитьВидимостьПоВидуИмущества(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧислительДолиПриИзменении(Элемент)
	
	УстановитьВидимостьПоВидуИмущества(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроданаТолькоЭтаДоляПриИзменении(Элемент)
	
	УстановитьВидимостьПоВидуИмущества(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	
	// Информация для формы помощника.
	СтруктураРезультата.Вставить("Вид",        ВидПоВидуИмущества(ВидИмущества));
	СтруктураРезультата.Вставить("Информация", ОписаниеОперацииПоВидуИмущества(ВидИмущества));
	
	// Сумму дохода определяем либо по кадастровой стоимости, либо по сумме продажи.
	СкорректированнаяКадастроваяСтоимость = Окр(КадастроваяСтоимость * ПонижающийКоэффициент, 2);
	Если НедвижимостьПриобретенаПосле01012016 Тогда
		СуммаДохода = Макс(СуммаПродажи, СкорректированнаяКадастроваяСтоимость);
	Иначе
		СуммаДохода = СуммаПродажи;
	КонецЕсли;
	СтруктураРезультата.Вставить("СуммаДохода",  СуммаДохода);
	СтруктураРезультата.Вставить("ВидВычета",    ВидВычета);
	СтруктураРезультата.Вставить("ВидИмущества", ВидИмущества);
	
	Если ВидВычета = "Норматив" Тогда
		СуммаИмущественногоВычета = НормативИмущественногоВычета(ВидИмущества);
		Если ВидИмущества = "Доля" И НЕ ПроданаТолькоЭтаДоля И ДоляЗнаменатель <> 0 И ДоляЧислитель < ДоляЗнаменатель Тогда
			// Имущественный вычет рассчитывается по доле.
			СуммаИмущественногоВычета = Окр(СуммаИмущественногоВычета * ДоляЧислитель / ДоляЗнаменатель, 2);
		КонецЕсли;
		СуммаИмущественногоВычета = СуммаИмущественногоВычета - ИспользованныйВычет(ЭтотОбъект);
		// Имущественный вычет не может быть больше суммы продажи.
		СтруктураРезультата.Вставить("СуммаВычета", Мин(СуммаИмущественногоВычета, СуммаДохода));
	Иначе
		СтруктураРезультата.Вставить("СуммаВычета", СуммаВычета);
	КонецЕсли;
	
	СтруктураРезультата.Вставить("ОблагаемыйДоход", Макс(0, СтруктураРезультата.СуммаДохода - СтруктураРезультата.СуммаВычета));
	
	// Данные для отчетности.
	СтруктураДанныхОтчетности = Новый Структура;
	
	Если ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо") Тогда
		НаименованиеИсточникаДохода = ФИО;
	ИначеЕсли ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		НаименованиеИсточникаДохода = Наименование;
	Иначе
		НаименованиеИсточникаДохода = СтруктураРезультата.Информация;
	КонецЕсли;
	
	СтруктураДанныхОтчетности.Вставить("НаименованиеИсточникаДохода", НаименованиеИсточникаДохода);
	СтруктураДанныхОтчетности.Вставить("ИНН",                   ИНН);
	СтруктураДанныхОтчетности.Вставить("КПП",                   КПП);
	СтруктураДанныхОтчетности.Вставить("ОКТМО",                 ОКТМО);
	СтруктураДанныхОтчетности.Вставить("ВидИмущества",          ?(ВидИмущества = "Доля" И ПроданаТолькоЭтаДоля, "Жилая", ВидИмущества));
	СтруктураДанныхОтчетности.Вставить("ВидВычета",             ВидВычета);
	СтруктураДанныхОтчетности.Вставить("КодВидаДохода",         КодВидаДоходаПоВидуПроданногоИмущества(ВидИмущества));
	СтруктураДанныхОтчетности.Вставить("КадастровыйНомер",      КадастровыйНомер);
	СтруктураДанныхОтчетности.Вставить("КадастроваяСтоимость",  КадастроваяСтоимость);
	СтруктураДанныхОтчетности.Вставить("СкорректированнаяКадастроваяСтоимость", СкорректированнаяКадастроваяСтоимость);
	СтруктураДанныхОтчетности.Вставить("СуммаПоДоговору",       СуммаПродажи);
	СтруктураДанныхОтчетности.Вставить("НедвижимостьПриобретенаПосле01012016", НедвижимостьПриобретенаПосле01012016);
	СтруктураРезультата.Вставить("ДанныеОтчетности", СтруктураДанныхОтчетности);
	
	// Данные формы для восстановления.
	СтруктураДанныхФормы = Новый Структура;
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		СтруктураДанныхФормы.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	СтруктураРезультата.Вставить("ДанныеФормы", СтруктураДанныхФормы);
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоИНН(Команда)
	
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	ИначеЕсли НЕ ОшибокПоИННнет Тогда
		ПоказатьПредупреждение(, Строка(РезультатПроверкиИНН));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоИНН(ИНН, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГР(Команда)
	
	ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Поле ""Наименование"" не заполнено'"));
		ТекущийЭлемент = Элементы.Наименование;
	Иначе
		ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоНаименованию(Наименование, ОповещениеПослеЗаполненияПоИНН());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуИзДанных(ДанныеФормы)
	
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Свойство(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	ЗаполнениеРеквизитовПлашкой = НЕ ЗначениеЗаполнено(СуммаПродажи);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовуюФорму()
	
	КлючНазначенияФормы = Параметры.КлючНазначенияФормы;
	ВидКонтрагента      = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	ЗаполнениеРеквизитовПлашкой = Истина;
	
	Если КлючНазначенияФормы = "Автомобиль" Тогда
		ВидИмущества = "Автомобиль";
	ИначеЕсли КлючНазначенияФормы = "Недвижимость" Тогда
		ВидИмущества          = "Жилая";
		ПонижающийКоэффициент = 0.7;
		ДоляЧислитель         = 1;
		ДоляЗнаменатель       = 2;
	ИначеЕсли КлючНазначенияФормы = "ДоляУставногоКапитала" Тогда
		ВидИмущества = "ДоляУставногоКапитала";
	Иначе
		ВидИмущества = "ПрочееИмущество";
	КонецЕсли;
	
	Если ИспользованныйВычет(ЭтотОбъект) >= РазмерИмущественногоВычета(ЭтотОбъект) Тогда
		ВидВычета = "Расходы";
	Иначе
		ВидВычета = "Норматив";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если КлючНазначенияФормы = "Автомобиль" ИЛИ КлючНазначенияФормы = "Прочее" Тогда
		Элементы.ГруппаКогдаДекларироватьПродажуНедвижимости.Поведение = ПоведениеОбычнойГруппы.Обычное;
		Элементы.ГруппаКогдаДекларироватьПродажуНедвижимости.ОтображатьЗаголовок = Ложь;
	КонецЕсли;
	
	Элементы.ВидИмущества.Видимость = (КлючНазначенияФормы = "Недвижимость");
	
	Если КлючНазначенияФормы = "Недвижимость" Тогда
		Заголовок = НСтр("ru = 'Продажа недвижимости'");
	ИначеЕсли КлючНазначенияФормы = "Автомобиль" Тогда
		Заголовок = НСтр("ru = 'Продажа автомобиля'");
	ИначеЕсли КлючНазначенияФормы = "ДоляУставногоКапитала" Тогда
		Заголовок = НСтр("ru = 'Продажа доли в уставном капитале организации'");
	Иначе
		Заголовок = НСтр("ru = 'Продажа прочего имущества'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НормативИмущественногоВычета(Знач ВидИмущества)
	
	Если ВидИмущества = "Жилая" ИЛИ ВидИмущества = "Доля" Тогда
		НормативИмущественногоВычета = 1000000;
	ИначеЕсли ВидИмущества = "ДолевоеСтроительство" Тогда
		НормативИмущественногоВычета = 0;
	Иначе
		НормативИмущественногоВычета = 250000;
	КонецЕсли;
	
	Возврат НормативИмущественногоВычета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстНалоговаяБаза(Форма)
	
	Элементы = Форма.Элементы;
	
	КадастроваяСтоимостьИтого = Окр(Форма.КадастроваяСтоимость * Форма.ПонижающийКоэффициент, 2);
	НалоговаяБазаИтого = Макс(КадастроваяСтоимостьИтого, Форма.СуммаПродажи);
	Если Форма.СуммаПродажи = 0 Тогда
		Форма.ТекстРасчетНалоговойБазы = НСтр("ru = 'Налоговая база не определена.
			|Укажите сумму продажи недвижимости по договору купли-продажи.'");
		ТекстЗаголовкаГруппы = НСтр("ru = 'Налоговая база не определена'");
	ИначеЕсли КадастроваяСтоимостьИтого = 0 Тогда
		Форма.ТекстРасчетНалоговойБазы = СтрШаблон(НСтр("ru = 'Налоговая база составляет %1
			|и определяется по сумме продажи недвижимости по договору купли-продажи.'"),
				СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(НалоговаяБазаИтого, "рубль, рубля, рублей"));
		ТекстЗаголовкаГруппы = СтрШаблон(НСтр("ru = 'Налоговая база: %1'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(НалоговаяБазаИтого, "рубль, рубля, рублей"));
	Иначе
		ШаблонПодсказки = НСтр("ru = 'Налоговая база составляет %1 и определяется по большей из двух сумм:
			|- %2 - стоимость продажи по договору купли-продажи;
			|- %3 - кадастровая стоимость, умноженная на понижающий коэффициент.'");
		Форма.ТекстРасчетНалоговойБазы = СтрШаблон(ШаблонПодсказки,
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(НалоговаяБазаИтого, "рубль, рубля, рублей"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Форма.СуммаПродажи, "рубль, рубля, рублей"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КадастроваяСтоимостьИтого, "рубль, рубля, рублей"));
		ТекстЗаголовкаГруппы = СтрШаблон(НСтр("ru = 'Налоговая база: %1'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(НалоговаяБазаИтого, "рубль, рубля, рублей"));
	КонецЕсли;
		
	Элементы.ГруппаНалоговаяБаза.ЗаголовокСвернутогоОтображения = ТекстЗаголовкаГруппы;
	
	Если КадастроваяСтоимостьИтого = 0 Тогда
		Форма.ТекстКадастроваяСтоимостьИтого = НСтр("ru = 'Кадастровая стоимость не указана.'")
	Иначе
		Форма.ТекстКадастроваяСтоимостьИтого = СтрШаблон(НСтр("ru = 'Кадастровая стоимость, умноженная на понижающий коэффициент %1.'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КадастроваяСтоимостьИтого, "рубль, рубля, рублей"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеОперацииПоВидуИмущества(ВидИмущества)
	
	Если ВидИмущества = "Жилая" Тогда
		Возврат НСтр("ru = 'Продажа жилой недвижимости'");
	ИначеЕсли ВидИмущества = "Доля" Тогда
		Возврат НСтр("ru = 'Продажа доли в недвижимости'");
	ИначеЕсли ВидИмущества = "Автомобиль" Тогда
		Возврат НСтр("ru = 'Продажа автомобиля'");
	ИначеЕсли ВидИмущества = "ПрочаяНедвижимость" Тогда
		Возврат НСтр("ru = 'Продажа прочей недвижимости'");
	ИначеЕсли ВидИмущества = "ДолевоеСтроительство" Тогда
		Возврат НСтр("ru = 'Уступка прав при долевом строительстве'");
	ИначеЕсли ВидИмущества = "ДоляУставногоКапитала" Тогда
		Возврат НСтр("ru = 'Продажа доли в уставном капитале'");
	Иначе
		Возврат НСтр("ru = 'Продажа прочего имущества'");
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидПоВидуИмущества(ВидИмущества)
	
	Если (ВидИмущества = "Жилая" Или ВидИмущества = "Доля"
		Или ВидИмущества = "ПрочаяНедвижимость" Или ВидИмущества = "ДолевоеСтроительство") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ПродажаНедвижимости");
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ПродажаИмущества");
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидВычета(Форма)
	
	Если ИспользованныйВычет(Форма) >= РазмерИмущественногоВычета(Форма) Тогда
		Форма.ВидВычета = "Расходы";
	Иначе
		Форма.ВидВычета = "Норматив";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьВычета(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.СуммаВычета.Видимость = НЕ Форма.ВидВычета = "Норматив";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьИнформацияИзКадастра(Форма)
	
	Элементы = Форма.Элементы;
	НедвижимостьПолученаВСобственностьПосле01012016 = Форма.НедвижимостьПриобретенаПосле01012016
		И (Форма.ВидИмущества = "Жилая" ИЛИ Форма.ВидИмущества = "Доля" ИЛИ Форма.ВидИмущества = "ПрочаяНедвижимость");
	
	Элементы.ДекорацияИнформацияИзКадастра.Видимость   = НедвижимостьПолученаВСобственностьПосле01012016;
	Элементы.КадастровыйНомер.Видимость                = НедвижимостьПолученаВСобственностьПосле01012016;
	Элементы.ПонижающийКоэффициент.Видимость           = НедвижимостьПолученаВСобственностьПосле01012016;
	Элементы.КадастроваяСтоимость.Видимость            = НедвижимостьПолученаВСобственностьПосле01012016;
	Элементы.ТекстКадастроваяСтоимостьИтого.Видимость  = НедвижимостьПолученаВСобственностьПосле01012016;
	Элементы.ТекстРасчетНалоговойБазы.Видимость        = НедвижимостьПолученаВСобственностьПосле01012016;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПоВидуИмущества(Форма)
	
	Элементы = Форма.Элементы;
	
	// Минимальный срок владения.
	Элементы.ПодсказкаМинимальныйСрокВладенияНедвижимость.Видимость = Ложь;
	Элементы.ПодсказкаМинимальныйСрокВладенияСтройка.Видимость = Ложь;
	Элементы.ПодсказкаМинимальныйСрокВладенияАвтомобиль.Видимость = Ложь;
	Элементы.ПодсказкаМинимальныйСрокВладенияПрочееИмущество.Видимость = Ложь;
	Элементы.ПодсказкаМинимальныйСрокВладенияДоляУставногоКапитала.Видимость = Ложь;
	
	Если (Форма.ВидИмущества = "Жилая" ИЛИ Форма.ВидИмущества = "Доля" ИЛИ Форма.ВидИмущества = "ПрочаяНедвижимость") Тогда
		Элементы.ПодсказкаМинимальныйСрокВладенияНедвижимость.Видимость = Истина;
	ИначеЕсли Форма.ВидИмущества = "ДолевоеСтроительство" Тогда
		Элементы.ПодсказкаМинимальныйСрокВладенияСтройка.Видимость = Истина;
	ИначеЕсли Форма.ВидИмущества = "Автомобиль" Тогда
		Элементы.ПодсказкаМинимальныйСрокВладенияАвтомобиль.Видимость = Истина;
	ИначеЕсли Форма.ВидИмущества = "ДоляУставногоКапитала" Тогда
		Элементы.ПодсказкаМинимальныйСрокВладенияДоляУставногоКапитала.Видимость = Истина;
	Иначе
		Элементы.ПодсказкаМинимальныйСрокВладенияПрочееИмущество.Видимость = Истина;
	КонецЕсли;
	
	// Имущественный вычет.
	ТекстДополнительныйИмущественныйВычет = "";
	Элементы.ТекстДополнительныйИмущественныйВычет.Видимость = Ложь;
	
	РазмерИмущественногоВычета = РазмерИмущественногоВычета(Форма);
	
	ИспользованныйВычет = ИспользованныйВычет(Форма);
	
	Если ЭтоПродажаДоли(Форма) Тогда
		Форма.ТекстДополнительныйИмущественныйВычет = НСтр("ru = 'Имущественный вычет рассчитывается по доле от 1 000 000 рублей.'");
		Элементы.ТекстДополнительныйИмущественныйВычет.Видимость = Истина;
	КонецЕсли;
	
	Если Форма.ВидИмущества = "Доля" Или Форма.ВидИмущества = "Жилая" Или Форма.ВидИмущества = "ПрочаяНедвижимость" Тогда
		ТекстИмуществаНедвижимости = НСтр("ru = 'другой недвижимости'");
	ИначеЕсли Форма.ВидИмущества = "ДоляУставногоКапитала" Тогда
		ТекстИмуществаНедвижимости = НСтр("ru = 'другой доли'");
	Иначе
		ТекстИмуществаНедвижимости = НСтр("ru = 'другого имущества'");
	КонецЕсли;
	
	Если ИспользованныйВычет >= РазмерИмущественногоВычета Тогда
		Форма.ТекстИмущественныйВычет = 
			НСтр("ru = 'Доход от продажи можно уменьшить на сумму расходов по приобретению, подтвержденных документами.'");
		Форма.ТекстДополнительныйИмущественныйВычет = СтрШаблон(
			НСтр("ru = 'Вычет по нормативу использован при продаже %1.'"),
			ТекстИмуществаНедвижимости);
		Элементы.ТекстДополнительныйИмущественныйВычет.Видимость = (РазмерИмущественногоВычета > 0);
		Элементы.ВидВычета.Видимость = Ложь;
		Элементы.СуммаВычета.Видимость = Истина;
	ИначеЕсли ИспользованныйВычет > 0 Тогда
		РазмерИмущественногоВычета = РазмерИмущественногоВычета - ИспользованныйВычет;
		Форма.ТекстИмущественныйВычет = СтрШаблон(НСтр("ru = 'Доход от продажи можно уменьшить на имущественный вычет %1
			|или на сумму расходов по приобретению, подтвержденных документами.'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(РазмерИмущественногоВычета, "рубль, рубля, рублей"));
		Форма.ТекстДополнительныйИмущественныйВычет = СтрШаблон(
			НСтр("ru = 'Вычет по нормативу %1 использован при продаже %2'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(ИспользованныйВычет, "рубль, рубля, рублей"),
			ТекстИмуществаНедвижимости);
		Элементы.ТекстДополнительныйИмущественныйВычет.Видимость = Истина;
		Элементы.ВидВычета.Видимость = Истина;
	Иначе
		Форма.ТекстИмущественныйВычет = СтрШаблон(НСтр("ru = 'Доход от продажи можно уменьшить на имущественный вычет %1
			|или на сумму расходов по приобретению, подтвержденных документами.'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(РазмерИмущественногоВычета, "рубль, рубля, рублей"));
		Элементы.ВидВычета.Видимость = Истина;
	КонецЕсли;
	
	// Меняем представление, только в случае если оно изменилось.
	ПредставлениеНорматива = Элементы.ВидВычета.СписокВыбора[0].Представление;
	НовоеПредставлениеНорматива = СтрШаблон(НСтр("ru = '%1 рублей'"), РазмерИмущественногоВычета);
	Если ПредставлениеНорматива <> НовоеПредставлениеНорматива Тогда
		Элементы.ВидВычета.СписокВыбора[0].Представление = НовоеПредставлениеНорматива;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПродажаДоли(Форма)
	
	ЭтоПродажаДоли = (Форма.ВидИмущества = "Доля" И НЕ Форма.ПроданаТолькоЭтаДоля И
		Форма.ДоляЗнаменатель <> 0 И Форма.ДоляЧислитель < Форма.ДоляЗнаменатель);
	
	Возврат ЭтоПродажаДоли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РазмерИмущественногоВычета(Форма)
	
	Если ЭтоПродажаДоли(Форма) Тогда
		РазмерИмущественногоВычета = Окр(НормативИмущественногоВычета(Форма.ВидИмущества) * Форма.ДоляЧислитель / Форма.ДоляЗнаменатель, 2);
	Иначе
		РазмерИмущественногоВычета = НормативИмущественногоВычета(Форма.ВидИмущества);
	КонецЕсли;
	
	Возврат РазмерИмущественногоВычета;
	
КонецФункции

&НаСервереБезКонтекста
Функция НовыйИспользованныйВычет()
	
	ИспользованныйВычет = Новый Структура;
	ИспользованныйВычет.Вставить("Недвижимость", 0);
	ИспользованныйВычет.Вставить("Имущество", 0);
	ИспользованныйВычет.Вставить("ПрочаяНедвижимость", 0);
	ИспользованныйВычет.Вставить("ДоляУставногоКапитала", 0);
	
	Возврат ИспользованныйВычет;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИспользованныйВычет(Форма)
	
	Если Форма.ВидИмущества = "ПрочаяНедвижимость" Тогда
		ИспользованныйВычет = Форма.ИспользованныйВычет.ПрочаяНедвижимость;
	ИначеЕсли Форма.ВидИмущества = "Жилая" ИЛИ Форма.ВидИмущества = "Доля" Тогда
		ИспользованныйВычет = Форма.ИспользованныйВычет.Недвижимость;
	ИначеЕсли Форма.ВидИмущества = "ДоляУставногоКапитала" Тогда
		ИспользованныйВычет = Форма.ИспользованныйВычет.ДоляУставногоКапитала;
	ИначеЕсли Форма.ВидИмущества = "ПрочееИмущество" Или Форма.ВидИмущества = "Автомобиль" Тогда
		ИспользованныйВычет = Форма.ИспользованныйВычет.Имущество;
	Иначе
		ИспользованныйВычет = 0;
	КонецЕсли;
	
	Возврат ИспользованныйВычет;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоли(Форма)
	
	Элементы = Форма.Элементы;
	
	ЭтоДоля = (Форма.ВидИмущества = "Доля");
	Элементы.ДоляЧислитель.Видимость            = ЭтоДоля;
	Элементы.ДекорацияДоляЗнаменатель.Видимость = ЭтоДоля;
	Элементы.ДоляЗнаменатель.Видимость          = ЭтоДоля;
	Элементы.ПроданаТолькоЭтаДоля.Видимость     = ЭтоДоля;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.НедвижимостьПриобретенаПосле01012016.Видимость =
		(Форма.ВидИмущества = "Жилая"
		ИЛИ Форма.ВидИмущества = "Доля"
		ИЛИ  Форма.ВидИмущества = "ПрочаяНедвижимость");
	
	УстановитьВидимостьДоли(Форма);
	
	УстановитьВидимостьИнформацияИзКадастра(Форма);
	
	УстановитьВидимостьВычета(Форма);
	
	УстановитьВидимостьПоВидуИмущества(Форма);
	
	УстановитьТекстНалоговаяБаза(Форма);
	
	УстановитьКлючСохраненияПоложенияОкна(Форма);
	
КонецПроцедуры

&НаКлиенте
Функция КодВидаДоходаПоВидуПроданногоИмущества(ВидИмущества)
	
	Если ВидИмущества = "Жилая" Или ВидИмущества = "Доля" Или ВидИмущества = "ПрочаяНедвижимость" Тогда
		КодВидаДоходаРФ = КодыВидовДоходовРФ.ПродажаНедвижимости;
	ИначеЕсли ВидИмущества = "ДолевоеСтроительство" Или ВидИмущества = "ДоляУставногоКапитала" Тогда
		КодВидаДоходаРФ = КодыВидовДоходовРФ.ИнойДоходОтИсточникаРФ;
	Иначе
		КодВидаДоходаРФ = КодыВидовДоходовРФ.ПродажаИмущества;
	КонецЕсли;
	
	Возврат КодВидаДоходаРФ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкна(Форма)
	
	ШаблонКлюча = "[ВидИмущества][ВидВычета][ПроданаТолькоЭтаДоля][ЕстьИспользованныйВычет][ИнформацияИзКадастра]";
	СтруктураКлюча = Новый Структура("ВидИмущества, ВидВычета, ПроданаТолькоЭтаДоля, ЕстьИспользованныйВычет, ИнформацияИзКадастра");
	СтруктураКлюча.ВидИмущества            = Форма.ВидИмущества;
	СтруктураКлюча.ВидВычета               = Форма.ВидВычета;
	СтруктураКлюча.ПроданаТолькоЭтаДоля    = ?(Форма.ПроданаТолькоЭтаДоля, "ПроданаТолькоЭтаДоля", "");
	СтруктураКлюча.ЕстьИспользованныйВычет = ?(ИспользованныйВычет(Форма) > 0, "ЕстьИспользованныйВычет", "");
	СтруктураКлюча.ИнформацияИзКадастра    = ?(Форма.НедвижимостьПриобретенаПосле01012016, "ИнформацияИзКадастра", "");
	
	ПрефиксКлючаСохранения = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонКлюча, СтруктураКлюча);
	
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьКлючСохраненияПоложенияОкна(Форма, ПрефиксКлючаСохранения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивРеквизитовФормы()
	
	Массив = Новый Массив;
	Массив.Добавить("ВидИмущества");
	Массив.Добавить("СуммаПродажи");
	Массив.Добавить("ДоляЧислитель");
	Массив.Добавить("ДоляЗнаменатель");
	Массив.Добавить("ПроданаТолькоЭтаДоля");
	Массив.Добавить("ВидКонтрагента");
	Массив.Добавить("ФИО");
	Массив.Добавить("Наименование");
	Массив.Добавить("ИНН");
	Массив.Добавить("КПП");
	Массив.Добавить("ОКТМО");
	Массив.Добавить("НедвижимостьПриобретенаПосле01012016");
	Массив.Добавить("КадастровыйНомер");
	Массив.Добавить("КадастроваяСтоимость");
	Массив.Добавить("ПонижающийКоэффициент");
	Массив.Добавить("ВидВычета");
	Массив.Добавить("СуммаВычета");
	Массив.Добавить("КлючНазначенияФормы");
	
	Возврат Массив;
	
КонецФункции

#Область ЗаполнениеРеквизитовКонтрагента

&НаКлиенте
Функция ОповещениеПослеЗаполненияПоИНН()
	
	Возврат Новый ОписаниеОповещения("ПослеЗаполненияПоИНН", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаполненияПоИНН(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьЗаполнениеПоИНН()
	
	ОтключитьЗаполнениеПоИНН = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти