#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодОтчетности = Параметры.Период;
	Декларация3НДФЛВыбраннаяФорма = Параметры.Декларация3НДФЛВыбраннаяФорма;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов") 
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов)
		И Параметры.СтруктураДоходовВычетов.Свойство("ДанныеФормы")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов.ДанныеФормы) Тогда
		
		ЗаполнитьФормуИзДанных(Параметры.СтруктураДоходовВычетов.ДанныеФормы);
	Иначе
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		ДействуетДоговорОбИзбежанииДвойногоНалогообложения = ПризнакИзбежанияДвойногоНалогообложения(Страна, ПериодОтчетности);
	КонецЕсли;
	
	СтавкаНалога = Отчеты.РегламентированныйОтчет3НДФЛ.НалоговыеСтавки(Декларация3НДФЛВыбраннаяФорма).ПоУмолчанию;
	
	УправлениеФормой(ЭтотОбъект);
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкна(Форма)
	
	Если Форма.ДействуетДоговорОбИзбежанииДвойногоНалогообложения Тогда
		ИмяКлюча = "ДействуетДоговорОбИзбежанииДвойногоНалогообложения";
	Иначе
		ИмяКлюча = "НеДействуетДоговорОбИзбежанииДвойногоНалогообложения";
	КонецЕсли;
	
	Форма.КлючСохраненияПоложенияОкна = ИмяКлюча;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Страна = Справочники.СтраныМира.Россия Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность",
			НСтр("ru = 'Страна'"), , , 
			НСтр("ru = 'Для отражения дохода, полученного в РФ, используйте другие формы помощника.'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Страна", , Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеВалюты(Команда)
	
	ОткрытьФорму("Справочник.Валюты.ФормаСписка", ,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	
	СуммаНалогаИсчисленная = СуммаДоходаВРублях * СтавкаНалога / 100;
	Если ДействуетДоговорОбИзбежанииДвойногоНалогообложения Тогда
		СуммаНалогаПодлежащаяЗачету = Мин(СуммаНалогаВРублях, СуммаНалогаИсчисленная);
	Иначе
		СуммаНалогаПодлежащаяЗачету = 0;
	КонецЕсли;
	
	// Информация для формы помощника.
	СтруктураРезультата.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ДоходЗаПределамиРФ"));
	СтруктураРезультата.Вставить("Информация", СтрШаблон(НСтр("ru='Доход за пределами РФ (%1)'"), НаименованиеИсточника));
	СтруктураРезультата.Вставить("СуммаДохода", СуммаДоходаВРублях);
	СтруктураРезультата.Вставить("СуммаВычета", СуммаНалогаПодлежащаяЗачету);
	
	// Данные для декларации.
	СтруктураДанныхДекларации = Новый Структура;
	СтруктураДанныхДекларации.Вставить("Страна", Страна);
	СтруктураДанныхДекларации.Вставить("СтавкаНалога", СтавкаНалога);
	СтруктураДанныхДекларации.Вставить("ИсточникДохода", НаименованиеИсточника);
	СтруктураДанныхДекларации.Вставить("Валюта", ВалютаДохода);
	СтруктураДанныхДекларации.Вставить("ДатаПолученияДохода", ДатаДохода);
	СтруктураДанныхДекларации.Вставить("КурсНаДатуПолученияДохода", КурсНаДатуПолученияДохода);
	СтруктураДанныхДекларации.Вставить("СуммаДоходаВВалюте", СуммаДоходаВВалюте);
	СтруктураДанныхДекларации.Вставить("СуммаДоходаВРублях", СуммаДоходаВРублях);
	СтруктураДанныхДекларации.Вставить("СуммаНалогаИсчисленная", СуммаНалогаИсчисленная);
	Если ДействуетДоговорОбИзбежанииДвойногоНалогообложения Тогда
		СтруктураДанныхДекларации.Вставить("ДатаУплатыНалога", ДатаУплатыНалога);
		СтруктураДанныхДекларации.Вставить("КурсНаДатуУплатыНалога", КурсНаДатуУплатыНалога);
		СтруктураДанныхДекларации.Вставить("СуммаНалогаВВалюте", СуммаНалогаВВалюте);
		СтруктураДанныхДекларации.Вставить("СуммаНалогаВРублях", СуммаНалогаВРублях);
		СтруктураДанныхДекларации.Вставить("СуммаНалогаПодлежащаяЗачету", СуммаНалогаПодлежащаяЗачету);
	Иначе
		СтруктураДанныхДекларации.Вставить("ДатаУплатыНалога", '00010101');
		СтруктураДанныхДекларации.Вставить("КурсНаДатуУплатыНалога", 0);
		СтруктураДанныхДекларации.Вставить("СуммаНалогаВВалюте", 0);
		СтруктураДанныхДекларации.Вставить("СуммаНалогаВРублях", 0);
		СтруктураДанныхДекларации.Вставить("СуммаНалогаПодлежащаяЗачету", 0);
	КонецЕсли;
	СтруктураДанныхДекларации.Вставить("КодВидаДохода", КодПрочегоДоходаЗаПределамиРФ(Декларация3НДФЛВыбраннаяФорма));
	
	СтруктураРезультата.Вставить("ДанныеДекларации", СтруктураДанныхДекларации);
	
	// Данные формы для восстановления.
	СтруктураДанныхФормы = Новый Структура;
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		СтруктураДанныхФормы.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	СтруктураРезультата.Вставить("ДанныеФормы", СтруктураДанныхФормы);
	
	Закрыть(СтруктураРезультата);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтранаИсточникаПриИзменении(Элемент)
	
	ДействуетДоговорОбИзбежанииДвойногоНалогообложения = ПризнакИзбежанияДвойногоНалогообложения(Страна, ПериодОтчетности);
	УправлениеФормой(ЭтотОбъект);
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДоходаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ДатаДохода) ИЛИ ЗначениеЗаполнено(ДатаУплатыНалога) Тогда
		ВалютаДоходаПриИзмененииНаСервере();
	КонецЕсли;
	
	РассчитатьСуммуДоходаВРублях();
	РассчитатьСуммуНалогаВРублях();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДоходаПриИзменении(Элемент)
	
	КурсВалюты = КурсВалюты(ВалютаДохода, ДатаДохода);
	КурсНаДатуПолученияДохода           = КурсВалюты.Курс;
	КратностьКурсаНаДатуПолученияДохода = КурсВалюты.Кратность;
	РассчитатьСуммуДоходаВРублях();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаУплатыНалогаПриИзменении(Элемент)
	
	КурсВалюты = КурсВалюты(ВалютаДохода, ДатаУплатыНалога);
	КурсНаДатуУплатыНалога           = КурсВалюты.Курс;
	КратностьКурсаНаДатуУплатыНалога = КурсВалюты.Кратность;
	РассчитатьСуммуНалогаВРублях();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаНалогВВалютеПриИзменении(Элемент)
	РассчитатьСуммуНалогаВРублях();
КонецПроцедуры

&НаКлиенте
Процедура КурсНаДатуПолученияДоходаПриИзменении(Элемент)
	РассчитатьСуммуДоходаВРублях();
КонецПроцедуры

&НаКлиенте
Процедура КратностьКурсаНаДатуПолученияДоходаПриИзменении(Элемент)
	РассчитатьСуммуДоходаВРублях();
КонецПроцедуры

&НаКлиенте
Процедура КурсНаДатуУплатыНалогаПриИзменении(Элемент)
	РассчитатьСуммуНалогаВРублях();
КонецПроцедуры

&НаКлиенте
Процедура КратностьКурсаНаДатуУплатыНалогаПриИзменении(Элемент)
	РассчитатьСуммуНалогаВРублях();
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаВВалютеПриИзменении(Элемент)
	РассчитатьСуммуДоходаВРублях();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ДекорацияИзбежаниеДвойногоНалогообложения.Видимость = Форма.ДействуетДоговорОбИзбежанииДвойногоНалогообложения;
	Элементы.ГруппаНалогИностранногоГосударства.Видимость = Форма.ДействуетДоговорОбИзбежанииДвойногоНалогообложения;
	
	Если МожноНеУказыватьНаименованиеИсточникаДохода(Форма.Декларация3НДФЛВыбраннаяФорма) Тогда
		Элементы.Наименование.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	Иначе
		Элементы.Наименование.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПризнакИзбежанияДвойногоНалогообложения(Знач Страна, Знач Период)
	
	Если ЗначениеЗаполнено(Страна) Тогда
		
		КодСтраны = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Страна, "Код");
		
		МакетСтран = Обработки.ПомощникЗаполнения3НДФЛ.ПолучитьМакет("ДоговорыОбИзбежанииДвойногоНалогообложения");
		ТаблицаСтранСДоговоромОбИзбежанииДвойногоНалогообложения = 
			ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетСтран.ПолучитьТекст());
		
		НайденнаяСтрока = ТаблицаСтранСДоговоромОбИзбежанииДвойногоНалогообложения.Данные.Найти(КодСтраны, "КодСтраны");
		
		Если НайденнаяСтрока = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Если ЗначениеЗаполнено(Период) Тогда
				Возврат Период >= Дата(НайденнаяСтрока.ДатаНачалаДействия);
			Иначе
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция КурсВалюты(Знач Валюта, Знач ДатаКурса)
	
	Возврат РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса);
	
КонецФункции

&НаСервере
Процедура ВалютаДоходаПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(ДатаДохода) Тогда
		КурсВалюты = КурсВалюты(ВалютаДохода, ДатаДохода);
		КурсНаДатуПолученияДохода           = КурсВалюты.Курс;
		КратностьКурсаНаДатуПолученияДохода = КурсВалюты.Кратность;
	КонецЕсли;
	Если ЗначениеЗаполнено(ДатаУплатыНалога) Тогда
		КурсВалюты = КурсВалюты(ВалютаДохода, ДатаУплатыНалога);
		КурсНаДатуУплатыНалога           = КурсВалюты.Курс;
		КратностьКурсаНаДатуУплатыНалога = КурсВалюты.Кратность;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивРеквизитовФормы()
	
	Массив = Новый Массив;
	Массив.Добавить("ВалютаДохода");
	Массив.Добавить("ДатаДохода");
	Массив.Добавить("ДатаУплатыНалога");
	Массив.Добавить("ДействуетДоговорОбИзбежанииДвойногоНалогообложения");
	Массив.Добавить("КратностьКурсаНаДатуПолученияДохода");
	Массив.Добавить("КратностьКурсаНаДатуУплатыНалога");
	Массив.Добавить("КурсНаДатуПолученияДохода");
	Массив.Добавить("КурсНаДатуУплатыНалога");
	Массив.Добавить("НаименованиеИсточника");
	Массив.Добавить("Страна");
	Массив.Добавить("СуммаДоходаВВалюте");
	Массив.Добавить("СуммаДоходаВРублях");
	Массив.Добавить("СуммаНалогаВВалюте");
	Массив.Добавить("СуммаНалогаВРублях");
	Возврат Массив;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьФормуИзДанных(ДанныеФормы)
	
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Свойство(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДоходаВРублях()
	
	Если НЕ (ЗначениеЗаполнено(КурсНаДатуПолученияДохода) И ЗначениеЗаполнено(КратностьКурсаНаДатуПолученияДохода)) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураКурсаРуб = Новый Структура(
		"Валюта, Курс, Кратность", ВалютаРегламентированногоУчета, 1, 1);
	СтруктураКурсаВалюты = Новый Структура(
		"Валюта, Курс, Кратность", ВалютаДохода, КурсНаДатуПолученияДохода, КратностьКурсаНаДатуПолученияДохода);
	
	СуммаДоходаВРублях = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		СуммаДоходаВВалюте, СтруктураКурсаВалюты, СтруктураКурсаРуб);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуНалогаВРублях()
	
	Если НЕ (ЗначениеЗаполнено(КурсНаДатуУплатыНалога) И ЗначениеЗаполнено(КратностьКурсаНаДатуУплатыНалога)) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураКурсаРуб = Новый Структура(
		"Валюта, Курс, Кратность", ВалютаРегламентированногоУчета, 1, 1);
	СтруктураКурсаВалютыНаДатуУплаты = Новый Структура(
		"Валюта, Курс, Кратность", ВалютаДохода, КурсНаДатуУплатыНалога, КратностьКурсаНаДатуУплатыНалога);
	
	СуммаНалогаВРублях = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		СуммаНалогаВВалюте, СтруктураКурсаВалютыНаДатуУплаты, СтруктураКурсаРуб);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МожноНеУказыватьНаименованиеИсточникаДохода(Знач ВыбраннаяФорма)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.МожноНеУказыватьНаименованиеИсточникаДохода(ВыбраннаяФорма);
	
КонецФункции

&НаСервереБезКонтекста
Функция КодПрочегоДоходаЗаПределамиРФ(Знач ВыбраннаяФорма)
	
	Перем КодВидаДохода;
	
	КодыВидовДоходовЗаПределамиРФ = Отчеты.РегламентированныйОтчет3НДФЛ.КодыВидовДоходовЗаПределамиРФ(ВыбраннаяФорма);
	Если КодыВидовДоходовЗаПределамиРФ.Свойство("Иной", КодВидаДохода) Тогда
		Возврат КодВидаДохода;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти