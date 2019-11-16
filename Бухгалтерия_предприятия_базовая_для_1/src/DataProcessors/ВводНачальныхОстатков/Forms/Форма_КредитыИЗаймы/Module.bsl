
#Область ПроцедурыИФункцииОбщегоНазначения

#Область ОбщегоНазначения

&НаСервереБезКонтекста
Функция ПеречитатьДатуНачалаУчета(Организация)
	
	Возврат Обработки.ВводНачальныхОстатков.ПеречитатьДатуНачалаУчета(Организация);
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Ложь;
		ЗаписатьНаСервере(, Отказ);
		Если НЕ Отказ Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоляСтрокиТабличнойЧасти(СтрокаТаблицы)
	
	КолонкиТаблицы = СтруктураТаблиц.Получить(0).Значение;
	
	ПараметрыСтроки  = Новый Структура("Организация, ДатаВводаОстатков, ВалютаРегламентированногоУчета, ВестиУчетПоДоговорам", 
		Объект.Организация, Объект.ДатаВводаОстатков, Объект.ВалютаРегламентированногоУчета, ВестиУчетПоДоговорам);
	
	Для Каждого Колонка ИЗ КолонкиТаблицы Цикл
		ИмяКолонки = Колонка.Значение;
		ПараметрыСтроки.Вставить(ИмяКолонки, СтрокаТаблицы[ИмяКолонки]);
	КонецЦикла;
	
	Возврат ПараметрыСтроки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита)
	
	Если ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета Тогда
		ПараметрыСтроки.ВалютнаяСумма = 0;
	КонецЕсли;
	ПересчитатьСуммуСервер(ПараметрыСтроки, ИмяРеквизита, ?(ИмяРеквизита = "СуммаПроценты", "ВалютнаяСуммаПроценты", "ВалютнаяСумма"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПересчитатьСуммуСервер(ПараметрыСтроки, ИмяРеквизита, ИмяРеквизитаВал = "ВалютнаяСумма")
	
	ИмяРасчетногоРеквизита = ИмяРеквизита + "Остаток";
	
	Если ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета Тогда
		ПараметрыСтроки.ВалютнаяСумма = 0;
		ПараметрыСтроки[ИмяРеквизита] = ПараметрыСтроки[ИмяРасчетногоРеквизита];
	Иначе
		ПараметрыСтроки[ИмяРеквизитаВал] = ПараметрыСтроки[ИмяРасчетногоРеквизита];
		ПараметрыСтроки[ИмяРеквизита] = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
								ПараметрыСтроки[ИмяРасчетногоРеквизита],
								РаботаСКурсамиВалют.ПолучитьКурсВалюты(ПараметрыСтроки.Валюта, ПараметрыСтроки.ДатаВводаОстатков),
								РаботаСКурсамиВалют.ПолучитьКурсВалюты(ПараметрыСтроки.ВалютаРегламентированногоУчета, ПараметрыСтроки.ДатаВводаОстатков));
		
	КонецЕсли;
	
	ПараметрыСтроки.ВидПлатежаПоКредитамЗаймамТело     = Перечисления.ВидыПлатежейПоКредитамЗаймам.ПогашениеДолга;
	ПараметрыСтроки.ВидПлатежаПоКредитамЗаймамПроценты = Перечисления.ВидыПлатежейПоКредитамЗаймам.УплатаПроцентов;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьДанных

&НаСервере
Процедура ЗаполнитьДоговораПередЗаписьюВТабличнойЧасти()

	ПараметрыДоговора = Новый Структура;
	ПараметрыДоговора.Вставить("Организация", Объект.Организация);
	ПараметрыДоговора.Вставить("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	
	Для Каждого Строка Из Объект.КредитыИЗаймы Цикл
		ПараметрыДоговора.Вставить("Владелец", Строка.Контрагент);
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
			
		РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
			ДоговорКонтрагента,
			ПараметрыДоговора.Владелец, 
			ПараметрыДоговора.Организация, 
			ПараметрыДоговора.ВидДоговора);
			
		Если НЕ ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
			ПараметрыСоздания = Новый Структура("ЗначенияЗаполнения", ПараметрыДоговора);
			ДоговорКонтрагента = РаботаСДоговорамиКонтрагентовБПВызовСервера.СоздатьОсновнойДоговорКонтрагента(ПараметрыСоздания);
		КонецЕсли;
		Строка.ДоговорКонтрагента = ДоговорКонтрагента;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(ОбновитьОстатки = Истина, Отказ = Ложь)
	
	// Перед проверкой заполнения заполним договор контрагента в строках
	Если Не ВестиУчетПоДоговорам Тогда
		ЗаполнитьДоговораПередЗаписьюВТабличнойЧасти();
	КонецЕсли;
	
	Отказ = НЕ ПроверитьЗаполнение();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СинхронизироватьСостояниеДокументов(Объект.КредитыИЗаймы, Объект.СуществующиеДокументы);
	
	СтруктураПараметровДокументов = Новый Структура("Организация, Дата, РазделУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Перечисления.РазделыУчетаДляВводаОстатков.ПрочиеСчетаБухгалтерскогоУчета);
	
	Отбор = Новый Структура("НеЗаполненныеРеквизиты, ТабличнаяЧасть", Истина, "КредитыИЗаймы");
	СчетаУчетаВДокументах.ЗаполнитьТаблицу(Обработки.ВводНачальныхОстатков, СтруктураПараметровДокументов, Объект.КредитыИЗаймы, Отбор);
	
	ТаблицаДанных = ПодготовитьТабличнуюЧастьКЗаписи(Объект.КредитыИЗаймы);
	МенеджерОбработки.ЗаписатьНаСервереДокументы(СтруктураПараметровДокументов, ТаблицаДанных, "БухСправка");
	МенеджерОбработки.ОбновитьФинансовыйРезультат(СтруктураПараметровДокументов, Объект.ФинансовыйРезультат, Объект.СуществующиеДокументы);
	
	Если ОбновитьОстатки Тогда
		
		МенеджерОбработки.ОбновитьОстатки(Объект.КредитыИЗаймы, "КредитыИЗаймы", 
			Новый Структура("Организация,ДатаВводаОстатков",
				Объект.Организация,Объект.ДатаВводаОстатков),
			Объект.СуществующиеДокументы);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьТабличнуюЧастьКЗаписи(Таблица);
	
	ТаблицаДанных = Таблица.Выгрузить();
	ТаблицаДанных.Очистить();
	ТаблицаДанных.Колонки.Добавить("СуммаКт");
	ТаблицаДанных.Колонки.Добавить("СуммаНУ");
	
	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл
		Если СтрокаТаблицы.СуммаПроценты <> 0 Тогда
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.СчетУчета     = НоваяСтрока.СчетУчетаПроценты;
			НоваяСтрока.СуммаКт       = НоваяСтрока.СуммаПроценты;
			НоваяСтрока.СуммаНУ       = НоваяСтрока.СуммаПроценты;
			НоваяСтрока.ВалютнаяСумма = НоваяСтрока.ВалютнаяСуммаПроценты;
			НоваяСтрока.Сумма         = 0;
		КонецЕсли;
		Если СтрокаТаблицы.Сумма <> 0 Тогда
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.СуммаКт   = НоваяСтрока.Сумма;
			НоваяСтрока.СуммаНУ   = НоваяСтрока.Сумма;
			НоваяСтрока.Сумма         = 0;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Контрагент.Имя         = "Субконто1";
	ТаблицаДанных.Колонки.ДоговорКонтрагента.Имя = "Субконто2";
	
	Возврат ТаблицаДанных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОбработчикиЭлементовШапкиФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если Модифицированность Тогда
		НомерСтроки = 0;
		Если Элементы.КредитыИЗаймы.ТекущиеДанные <> Неопределено Тогда
			НомерСтроки = Элементы.КредитыИЗаймы.ТекущиеДанные.НомерСтроки;
		КонецЕсли;
		Отказ = Ложь;
		ЗаписатьНаСервере(Истина, Отказ);
		Если НЕ Отказ Тогда
			Если НомерСтроки <> 0 Тогда
				Элементы.КредитыИЗаймы.ТекущаяСтрока = Объект.КредитыИЗаймы[НомерСтроки-1].ПолучитьИдентификатор();
			КонецЕсли;
			Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	Если Модифицированность Тогда
		ЗаписатьНаСервере(Ложь, Отказ);
		Если НЕ Отказ Тогда
			Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьМассивВидовДоговоров()

	СписокВидовДоговоров = Новый Массив;
	СписокВидовДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));
	Возврат СписокВидовДоговоров;

КонецФункции

&НаСервереБезКонтекста
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыСтроки)
	
	ПараметрыСтроки.СчетУчета = "";
	ПараметрыСтроки.СчетУчетаПроценты = "";
	
	Если ЗначениеЗаполнено(ПараметрыСтроки.Контрагент) Тогда
		РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ПараметрыСтроки.ДоговорКонтрагента, ПараметрыСтроки.Контрагент, ПараметрыСтроки.Организация, 
		ПолучитьМассивВидовДоговоров());
		
		Если ЗначениеЗаполнено(ПараметрыСтроки.ДоговорКонтрагента) Тогда
			ДоговорПриИзмененииСервер(ПараметрыСтроки);
		ИначеЕсли НЕ ПараметрыСтроки.ВестиУчетПоДоговорам Тогда
			ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
	
&НаСервереБезКонтекста
Процедура ДоговорПриИзмененииСервер(ПараметрыСтроки)
	
	ПараметрыСтроки.СчетУчета = "";
	ПараметрыСтроки.СчетУчетаПроценты = "";
	
	Если ПараметрыСтроки.Свойство("Валюта") Тогда
		ПараметрыСтроки.Валюта = ПараметрыСтроки.ДоговорКонтрагента.ВалютаВзаиморасчетов;
		ВалютаПриИзмененииСервер(ПараметрыСтроки, "Сумма");
		ВалютаПриИзмененииСервер(ПараметрыСтроки, "СуммаПроценты");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыКонтрагентПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.КредитыИЗаймы.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	КонтрагентПриИзмененииНаСервере(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыДоговорКонтрагентаПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.КредитыИЗаймы.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ДоговорПриИзмененииСервер(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыСуммаОстатокПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.КредитыИЗаймы.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПересчитатьСуммуСервер(ПараметрыСтроки, "Сумма");
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыСуммаПроцентыОстатокПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.КредитыИЗаймы.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ПересчитатьСуммуСервер(ПараметрыСтроки, "СуммаПроценты", "ВалютнаяСуммаПроценты");
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыВидОбязательстваПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.КредитыИЗаймы.ТекущиеДанные;
	СтрокаТаблицы.СчетУчета = "";
	СтрокаТаблицы.СчетУчетаПроценты = "";
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыВидОбязательстваОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КредитыИЗаймыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы   = Элементы.КредитыИЗаймы.ТекущиеДанные;
	Если СтрокаТаблицы.ВидОбязательства = "" Тогда
		СтрокаТаблицы.ВидОбязательства = "Займ";
	КонецЕсли;
	СтрокаТаблицы.ПодсказкаПроценты = "Проценты";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.Организация                    = Параметры.Организация;
	Объект.ДатаВводаОстатков              = Параметры.ДатаВводаОстатков;
	Объект.ВалютаРегламентированногоУчета = Параметры.ВалютаРегламентированногоУчета;
	ВестиУчетПоДоговорам                  = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	
	ТекстЗаголовок = НСтр("ru = 'Начальные остатки: Кредиты и займы (%1)'");
	ТекстЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, Объект.Организация);
	ЭтаФорма.Заголовок = ТекстЗаголовок;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СобратьСтруктуруТаблиц(Объект.КредитыИЗаймы, "КредитыИЗаймы", СтруктураТаблиц);
	МенеджерОбработки.ОбновитьОстатки(Объект.КредитыИЗаймы, "КредитыИЗаймы", 
		Новый Структура("Организация,ДатаВводаОстатков",
					Объект.Организация,Объект.ДатаВводаОстатков),
		Объект.СуществующиеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененениеДатыВводаОстатков" И Источник = "ВводНачальныхОстатков" И Параметр = Объект.Организация Тогда
		Объект.ДатаВводаОстатков = ПеречитатьДатуНачалаУчета(Объект.Организация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПередЗакрытиемЗавершение",
		ЭтотОбъект);
	
	ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти
