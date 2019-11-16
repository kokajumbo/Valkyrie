// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьЗаполнениеПоИНН;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	КодыВидовДоходовРФ = Отчеты.РегламентированныйОтчет3НДФЛ.КодыВидовДоходовРФ(Параметры.Декларация3НДФЛВыбраннаяФорма);
	
	Если Отчеты.РегламентированныйОтчет3НДФЛ.МожноНеУказыватьНаименованиеИсточникаДохода(Параметры.Декларация3НДФЛВыбраннаяФорма) Тогда
		Элементы.ВидКонтрагента.СписокВыбора.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ПустаяСсылка(), НСтр("ru = 'Неизвестен'"));
	КонецЕсли;
	
	ЗаполнениеРеквизитовПлашкой = Истина;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов) Тогда
		
		Параметры.СтруктураДоходовВычетов.Свойство("СуммаДохода", СуммаДохода);
		Параметры.СтруктураДоходовВычетов.Свойство("ВидКонтрагента", ВидКонтрагента);
		Параметры.СтруктураДоходовВычетов.Свойство("Наименование", Наименование);
		Параметры.СтруктураДоходовВычетов.Свойство("ФИО", ФИО);
		Параметры.СтруктураДоходовВычетов.Свойство("ИНН", ИНН);
		Параметры.СтруктураДоходовВычетов.Свойство("КПП", КПП);
		Параметры.СтруктураДоходовВычетов.Свойство("ОКТМО", ОКТМО);
		
		ЗаполнениеРеквизитовПлашкой = НЕ ЗначениеЗаполнено(СуммаДохода);
		
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ИсточникДоходовПриСозданииНаСервере(ЭтотОбъект, Ложь);
	
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидКонтрагента <> Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИНН");
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ПроверитьЗаполнениеРеквизитовИсточникаДоходов(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОрганизацииФормыДляОтчетности.ПроверитьКодПоОКТМОНаФорме(ОКТМО, "ОКТМО", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

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
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПолеПоискаИНННаименование)
		И НЕ ЗначениеЗаполнено(ИНН) 
		И НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.СдачаИмуществаВАренду"));
	СтруктураРезультата.Вставить("КодВидаДохода", КодыВидовДоходовРФ.СдачаИмуществаВАренду);
	СтруктураРезультата.Вставить("Информация", НСтр("ru='Сдача имущества в аренду'"));
	СтруктураРезультата.Вставить("СуммаДохода", СуммаДохода);
	СтруктураРезультата.Вставить("СуммаВычета", 0);
	
	СтруктураРезультата.Вставить("ВидКонтрагента", ВидКонтрагента);
	СтруктураРезультата.Вставить("ФИО", ФИО);
	СтруктураРезультата.Вставить("Наименование", Наименование);
	СтруктураРезультата.Вставить("ИНН", ИНН);
	СтруктураРезультата.Вставить("КПП", КПП);
	СтруктураРезультата.Вставить("ОКТМО", ОКТМО);
	
	Если ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо") Тогда
		НаименованиеИсточникаДохода = ФИО;
	ИначеЕсли ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		НаименованиеИсточникаДохода = Наименование;
	Иначе
		НаименованиеИсточникаДохода = СтруктураРезультата.Информация;
	КонецЕсли;
	
	СтруктураРезультата.Вставить("НаименованиеИсточникаДохода", НаименованиеИсточникаДохода);
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоИНН(Команда)
	
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН"" не заполнено'"));
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
		ПоказатьПредупреждение(, НСтр("ru='Поле ""Наименование"" не заполнено'"));
		ТекущийЭлемент = Элементы.Наименование;
		Возврат;
	Иначе
		ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоНаименованию(Наименование, ОповещениеПослеЗаполненияПоИНН());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкна(Форма)
	
	ПрефиксКлючаСохранения = "СдачаВАренду";
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьКлючСохраненияПоложенияОкна(Форма, ПрефиксКлючаСохранения);
	
КонецПроцедуры

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