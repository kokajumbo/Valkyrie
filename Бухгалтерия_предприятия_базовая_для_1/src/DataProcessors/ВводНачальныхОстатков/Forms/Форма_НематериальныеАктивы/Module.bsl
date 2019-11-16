
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
	
	ПараметрыСтроки  = Новый Структура("Организация, ДатаВводаОстатков, ВалютаРегламентированногоУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Объект.ВалютаРегламентированногоУчета);
	
	Для Каждого Колонка ИЗ КолонкиТаблицы Цикл
		ИмяКолонки = Колонка.Значение;
		ПараметрыСтроки.Вставить(ИмяКолонки, СтрокаТаблицы[ИмяКолонки]);
	КонецЦикла;
	
	Возврат ПараметрыСтроки;
	
КонецФункции

#КонецОбласти

#Область ЗаписьДанных

&НаСервере
Процедура ЗаписатьНаСервере(ОбновитьОстатки = Истина, Отказ = Ложь)
	
	Отказ = НЕ ПроверитьЗаполнение();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СинхронизироватьСостояниеДокументов(Объект.НематериальныеАктивы, Объект.СуществующиеДокументы);
	
	СтруктураПараметровДокументов = Новый Структура("Организация, Дата, РазделУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Перечисления.РазделыУчетаДляВводаОстатков.НематериальныеАктивыИНИОКР);
		
	Отбор = Новый Структура("НеЗаполненныеРеквизиты, ТабличнаяЧасть", Истина, "НематериальныеАктивы");
	СчетаУчетаВДокументах.ЗаполнитьТаблицу(Обработки.ВводНачальныхОстатков, СтруктураПараметровДокументов, Объект.НематериальныеАктивы, Отбор);
	
	ТаблицаДанных = ПодготовитьТабличнуюЧастьКЗаписи(Объект.НематериальныеАктивы);
	
	МенеджерОбработки.ЗаписатьНаСервереДокументы(СтруктураПараметровДокументов, ТаблицаДанных, "НМА");
	МенеджерОбработки.ОбновитьФинансовыйРезультат(СтруктураПараметровДокументов, Объект.ФинансовыйРезультат, Объект.СуществующиеДокументы);
	
	Если ОбновитьОстатки Тогда
		
		МенеджерОбработки.ОбновитьОстатки(Объект.НематериальныеАктивы, "НематериальныеАктивы", 
			Новый Структура("Организация,ДатаВводаОстатков",
				Объект.Организация,Объект.ДатаВводаОстатков),
			Объект.СуществующиеДокументы);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьТабличнуюЧастьКЗаписи(Таблица);
	
	ТаблицаДанных = Таблица.Выгрузить();
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
		Если Элементы.НематериальныеАктивы.ТекущиеДанные <> Неопределено Тогда
			НомерСтроки = Элементы.НематериальныеАктивы.ТекущиеДанные.НомерСтроки;
		КонецЕсли;
		Отказ = Ложь;
		ЗаписатьНаСервере(Истина, Отказ);
		Если НЕ Отказ Тогда
			Если НомерСтроки <> 0 Тогда
				Элементы.НематериальныеАктивы.ТекущаяСтрока = Объект.НематериальныеАктивы[НомерСтроки-1].ПолучитьИдентификатор();
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

&НаСервереБезКонтекста
Процедура ЗаполнитьСведенияОНематериальномАктиве(ПараметрыСтроки)
	
	ПараметрыСтроки.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный;
	ПараметрыСтроки.МетодНачисленияАмортизацииНУ  = Перечисления.МетодыНачисленияАмортизации.Линейный;
	ПараметрыСтроки.НачислятьАмортизациюБУ        = Истина;
	ПараметрыСтроки.НачислятьАмортизациюНУ        = Истина;
	ПараметрыСтроки.СпециальныйКоэффициентНУ      = 1;
	ПараметрыСтроки.СчетНачисленияАмортизацииБУ   = ПланыСчетов.Хозрасчетный.АмортизацияНематериальныхАктивов;
	ПараметрыСтроки.ПорядокВключенияСтоимостиВСоставРасходовУСН = 
		Перечисления.ПорядокВключенияСтоимостиОСиНМАВСоставРасходовУСН.ВключитьВСоставАмортизируемогоИмущества;
	ПараметрыСтроки.ПорядокСписанияНИОКРНаРасходыНУ = Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету;
	ПараметрыСтроки.ВидОбъектаУчета                 = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив;
	
	Обработки.ВводНачальныхОстатков.УстановитьСпособОтраженияРасходовПоАмортизации(ПараметрыСтроки, "СпособОтраженияРасходов");
	
КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыТекущаяСтоимостьБУПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.НематериальныеАктивы.ТекущиеДанные;
	СтрокаТаблицы.ТекущаяСтоимостьНУ        = СтрокаТаблицы.ТекущаяСтоимостьБУ;
	СтрокаТаблицы.ПервоначальнаяСтоимостьБУ = СтрокаТаблицы.ТекущаяСтоимостьБУ;
	СтрокаТаблицы.ПервоначальнаяСтоимостьНУ = СтрокаТаблицы.ТекущаяСтоимостьБУ;
	
КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыНакопленнаяАмортизацияБУПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.НематериальныеАктивы.ТекущиеДанные;
	СтрокаТаблицы.НакопленнаяАмортизацияНУ = СтрокаТаблицы.НакопленнаяАмортизацияБУ;

КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыНематериальныйАктивПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.НематериальныеАктивы.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ЗаполнитьСведенияОНематериальномАктиве(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура НематериальныеАктивыСрокПолезногоИспользованияБУПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.НематериальныеАктивы.ТекущиеДанные;
	СтрокаТаблицы.СрокПолезногоИспользованияНУ = СтрокаТаблицы.СрокПолезногоИспользованияБУ;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.Организация                    = Параметры.Организация;
	Объект.ДатаВводаОстатков              = Параметры.ДатаВводаОстатков;
	Объект.ВалютаРегламентированногоУчета = Параметры.ВалютаРегламентированногоУчета;
	
	ТекстЗаголовок = НСтр("ru = 'Начальные остатки: Нематериальные активы (%1)'");
	ТекстЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, Объект.Организация);
	ЭтаФорма.Заголовок = ТекстЗаголовок;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СобратьСтруктуруТаблиц(Объект.НематериальныеАктивы, "НематериальныеАктивы", СтруктураТаблиц);
	МенеджерОбработки.ОбновитьОстатки(Объект.НематериальныеАктивы, "НематериальныеАктивы", 
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
