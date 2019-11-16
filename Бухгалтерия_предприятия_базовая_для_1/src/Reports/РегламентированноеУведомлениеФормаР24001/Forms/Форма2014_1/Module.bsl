
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	ПараметрыЗаполнения = Неопределено;
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР24001;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2014_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомления(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		СформироватьДеревоСтраниц();
		
		ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", ИмяФормы, РеквизитФормыВЗначение("ДеревоСтраниц"));
		РезультатКонтейнер = Новый Структура;
		УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер, Истина);
		Для Каждого КЗ Из РезультатКонтейнер Цикл 
			ЭтаФорма[КЗ.Ключ] = КЗ.Значение;
		КонецЦикла;
		
		РезультатКонтейнер.Очистить();
		УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииСКонтейнеромМногострочныхБлоков(ВходящийКонтейнер, РезультатКонтейнер);
		Для Каждого КЗ Из РезультатКонтейнер Цикл 
			ЗначениеВРеквизитФормы(КЗ.Значение, КЗ.Ключ);
		КонецЦикла;
		УведомлениеОСпецрежимахНалогообложения.ДополнитьСлужебнымиСтруктурамиАдреса(ДанныеУведомления, ДанныеМногостраничныхРазделов);
	КонецЕсли;
	
	Если Параметры.СформироватьФормуОтчетаАвтоматически Тогда 
		ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	КонецЕсли;
	
	Если Параметры.СформироватьПечатнуюФорму Тогда
		Модифицированность = Истина;
		СохранитьДанные();
		Отказ = Истина;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		СохраненныеДанныеУведомления = Объект.Ссылка.ДанныеУведомления.Получить();
		УведомлениеЗаполненоВПомощнике = СохраненныеДанныеУведомления.Свойство("ДанныеПомощникаЗаполнения") 
			И ТипЗнч(СохраненныеДанныеУведомления.ДанныеПомощникаЗаполнения) = Тип("Структура")
			И ЗначениеЗаполнено(СохраненныеДанныеУведомления.ДанныеПомощникаЗаполнения);
	Иначе
		УведомлениеЗаполненоВПомощнике = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	СформироватьДеревоСтраниц();
	
	ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", ИмяФормы, РеквизитФормыВЗначение("ДеревоСтраниц"));
	РезультатКонтейнер = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер, Истина);
	Для Каждого КЗ Из РезультатКонтейнер Цикл 
		ЭтаФорма[КЗ.Ключ] = КЗ.Значение;
	КонецЦикла;
	
	РезультатКонтейнер.Очистить();
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииСКонтейнеромМногострочныхБлоков(ВходящийКонтейнер, РезультатКонтейнер);
	Для Каждого КЗ Из РезультатКонтейнер Цикл 
		ЗначениеВРеквизитФормы(КЗ.Значение, КЗ.Ключ);
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИДОтчета(Знач ЭтаФормаИмя)
	
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ЭтаФормаИмя = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	
	Возврат ЭтаФормаИмя;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения = Неопределено)
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Объект.Организация);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          ПараметрыЗаполнения);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	Контейнер = СформироватьКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ЭтаФормаИмя, Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7), ПараметрыОтчета, Контейнер);
	ЗагрузитьПодготовленныеДанные(Контейнер);
КонецПроцедуры

&НаСервере
Функция СформироватьКонтейнерДляАвтозаполнения()
	Контейнер = Новый Структура;
	Для Каждого КЗ Из ДанныеУведомления Цикл 
		Контейнер.Вставить(КЗ.Ключ, ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(КЗ.Значение));
	КонецЦикла;
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Контейнер)
	Для Каждого КЗ Из Контейнер Цикл 
		Если ДанныеУведомления.Свойство(КЗ.Ключ) Тогда 
			ЗаполнитьЗначенияСвойств(ДанныеУведомления[КЗ.Ключ], КЗ.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".");
	ДС = Отчеты[Разложение[1]].СформироватьДеревоСтраниц(Разложение[3]);
	ЗначениеВРеквизитФормы(ДС, "ДеревоСтраниц");
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета);
		
		Если Элемент.ТекущиеДанные.Многострочность Тогда
			Если ТекущееИДНаименования = "ЛистЕ1" Тогда 
				ВывестиМногострочнуюЧасть("МногострочнаяЧасть1");
			ИначеЕсли ТекущееИДНаименования = "ЛистЕ2" Тогда
				ВывестиМногострочнуюЧасть("МногострочнаяЧасть2");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета)
	ПредставлениеУведомления.Очистить();
	ПредставлениеУведомления.Вывести(Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета));
	СтрДанных = ДанныеУведомления[ТекущееИДНаименования];
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("ДанныеПомощникаЗаполнения", Новый Структура);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("МногострочнаяЧасть1", РеквизитФормыВЗначение("МногострочнаяЧасть1"));
	СтруктураПараметров.Вставить("МногострочнаяЧасть2", РеквизитФормыВЗначение("МногострочнаяЧасть2"));
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	УведомлениеЗаполненоВПомощнике = Ложь;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаКлиенте();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	МногострочнаяЧасть1.Загрузить(СтруктураПараметров.МногострочнаяЧасть1);
	МногострочнаяЧасть2.Загрузить(СтруктураПараметров.МногострочнаяЧасть2);
КонецПроцедуры

&НаКлиенте
Функция ЭтоОбластьОКСМ(Область)
	Если Область.Имя = "П01020000" И ТекущееИДНаименования = "ЛистБ" Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтроку") > 0 Тогда
		ДобавитьСтроку();
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтроку") > 0 Тогда
		УдалитьСтроку(Область);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда 
		ОбработкаАдреса(Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		Если ЭтоОбластьОКСМ(Область) Тогда 
			СтандартнаяОбработка = Ложь;
			ДополнительныеПараметры = Новый Структура("Область, СтандартнаяОбработка, Элемент", Область, СтандартнаяОбработка, Элемент);
			ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораСтраныЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("Справочник.СтраныМира.ФормаВыбора", Новый Структура("РежимВыбора", Истина), ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАдреса(Область, СтандартнаяОбработка) Экспорт
	РоссийскийАдрес = Неопределено;
	ЗначенияПолей = Неопределено;
	ПредставлениеАдреса = Неопределено;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаАдреса(ЭтотОбъект, Область, РоссийскийАдрес, ЗначенияПолей, ПредставлениеАдреса, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	ПрефиксПоляАдреса = ?(СтрНачинаетсяС(Область.Имя, "АДДР"), Лев(Область.Имя, 6), "");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",				"Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", 			ЗначенияПолей);
	ПараметрыФормы.Вставить("Представление", 			ПредставлениеАдреса);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации",	ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица"));
	
	ТекСтраницаДанные = Неопределено;
	Если ДанныеУведомления.Свойство(ТекущееИДНаименования) Тогда 
		ТекСтраницаДанные = ДанныеУведомления[ТекущееИДНаименования];
	Иначе
		Для Каждого Стр Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
			Если Стр.Значение.УИД = УИДТекущаяСтраница Тогда 
				ТекСтраницаДанные = Стр.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ТекСтраницаДанные <> Неопределено 
		И ТекСтраницаДанные.Свойство(ПрефиксПоляАдреса + "АдресXML")
		И ЗначениеЗаполнено(ТекСтраницаДанные[ПрефиксПоляАдреса + "АдресXML"]) Тогда
		
		ПараметрыФормы.Вставить("КонтактнаяИнформация", ТекСтраницаДанные[ПрефиксПоляАдреса + "АдресXML"]);
		ПараметрыФормы.Вставить("ЗначенияПолей", ТекСтраницаДанные[ПрефиксПоляАдреса + "АдресXML"]);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РоссийскийАдрес", РоссийскийАдрес);
	ДополнительныеПараметры.Вставить("Префикс", ПрефиксПоляАдреса);
	ДополнительныеПараметры.Вставить("ТекСтраницаДанные", ТекСтраницаДанные);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтотОбъект;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбновитьАдресВТабличномДокументе(ЭтотОбъект, Результат, Параметры, Истина);
		
		Если Параметры.Свойство("ТекСтраницаДанные") И Параметры.ТекСтраницаДанные <> Неопределено Тогда 
			Если Не Параметры.ТекСтраницаДанные.Свойство(Параметры.Префикс + "АдресXML") Тогда 
				Параметры.ТекСтраницаДанные.Вставить(Параметры.Префикс + "АдресXML", Результат.КонтактнаяИнформация);
			Иначе
				Параметры.ТекСтраницаДанные[Параметры.Префикс + "АдресXML"] = Результат.КонтактнаяИнформация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КодЭлементаСправочника(Результат)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Результат, "Код");
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораСтраныЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		КодЭлементаСправочника = КодЭлементаСправочника(Результат);
		Область = ДополнительныеПараметры.Область;
		Если Область.Значение <> КодЭлементаСправочника Тогда
			Область.Значение = КодЭлементаСправочника;
			Модифицированность = Истина;
		КонецЕсли;
		ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элементы.ПредставлениеУведомления, Область);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтроку()
	Если ТекущееИДНаименования = "ЛистЕ1" Тогда 
		МногострочнаяЧасть1.Добавить();
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть1");
	ИначеЕсли ТекущееИДНаименования = "ЛистЕ2" Тогда
		МногострочнаяЧасть2.Добавить();
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть2");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтроку(Область)
	ОбластьИмя = Область.Имя;
	Номер = Число(Сред(ОбластьИмя, СтрНайти(ОбластьИмя, "_") + 1)) - 1;
	
	Если ТекущееИДНаименования = "ЛистЕ1" Тогда
		МногострочнаяЧасть1.Удалить(Номер);
		Если МногострочнаяЧасть1.Количество() = 0 Тогда 
			МногострочнаяЧасть1.Добавить();
		КонецЕсли;
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть1");
	ИначеЕсли ТекущееИДНаименования = "ЛистЕ2" Тогда
		МногострочнаяЧасть2.Удалить(Номер);
		Если МногострочнаяЧасть2.Количество() = 0 Тогда 
			МногострочнаяЧасть2.Добавить();
		КонецЕсли;
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть2");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВывестиМногострочнуюЧасть(МногострочнаяЧасть)
	Обл = ПредставлениеУведомления.Область(МногострочнаяЧасть);
	ПредставлениеУведомления.УдалитьОбласть(ПредставлениеУведомления.Область(Обл.Верх, , Обл.Верх + 10 * ЭтаФорма[МногострочнаяЧасть].Количество()), ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	Колонки = РеквизитФормыВЗначение(МногострочнаяЧасть).Колонки;
	Если ТекущееИДНаименования = "ЛистЕ1" Тогда 
		Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2014_1_Страница7");
	ИначеЕсли ТекущееИДНаименования = "ЛистЕ2" Тогда
		Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2014_1_Страница8");
	КонецЕсли;
	
	ОбластьМнг = Макет.ПолучитьОбласть(МногострочнаяЧасть);
	ОбластьДоб = Макет.ПолучитьОбласть("ДобавлениеСтроки");
	
	Инд = 1;
	Для Каждого Стр Из ЭтаФорма[МногострочнаяЧасть] Цикл 
		Если Инд > 1 Тогда 
			Для Каждого Колонка Из Колонки Цикл 
				ОбластьМнг.Области[Колонка.Имя + "_" + (Инд - 1)].Имя = Колонка.Имя + "_" + Инд;
			КонецЦикла;
			ОбластьМнг.Области["УдалитьСтроку_" + (Инд - 1)].Имя = "УдалитьСтроку_" + Инд;
			Если Инд = 2 Тогда 
				ОбластьМнг.Области[МногострочнаяЧасть].Имя = "";
			КонецЕсли;
		КонецЕсли;
		ПредставлениеУведомления.Вывести(ОбластьМнг);
		
		Для Каждого Колонка Из Колонки Цикл 
			ПредставлениеУведомления.Области[Колонка.Имя + "_" + Инд].Значение = Стр[Колонка.Имя];
		КонецЦикла;
		Инд = Инд + 1;
	КонецЦикла;
	
	ПредставлениеУведомления.Вывести(ОбластьДоб);
КонецПроцедуры

&НаКлиенте
Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ОбластьИмя) Экспорт 
	Если ("А01020000" = Лев(ОбластьИмя, СтрНайти(ОбластьИмя, "_") - 1)) Тогда 
		Если ТекущееИДНаименования = "ЛистЕ1" Тогда
			Возврат "МногострочнаяЧасть1";
		ИначеЕсли ТекущееИДНаименования = "ЛистЕ2" Тогда
			Возврат "МногострочнаяЧасть2";
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", Объект.Организация, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1112502_5.01000_04.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	Если Модифицированность И УведомлениеЗаполненоВПомощнике Тогда
		Оповестить("ЗакрытьПомощникВнесенияИзмененийЕГР", Объект.Ссылка);
	КонецЕсли;
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьНаКлиенте();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПроверитьДокумент(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ПроверитьВыгрузкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКодОКСМ(Команда)
	ПредставлениеУведомления.ТекущаяОбласть.Значение = "";
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ПредставлениеУведомления.ТекущаяОбласть);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриАктивизацииОбласти(Элемент)
	Элементы.ПредставлениеУведомленияКонтекстноеМенюОчиститьКодОКСМ.Доступность = ЭтоОбластьОКСМ(Элемент.ТекущаяОбласть);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ЕстьВыходЗаГраницы = Ложь;
	ПечатьБРОНаСервере(ЕстьВыходЗаГраницы);
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, , Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов, Новый Структура("ЕстьВыходЗаГраницы", ЕстьВыходЗаГраницы));
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере(ЕстьВыходЗаГраницы)
	ЕстьВыходЗаГраницы = Ложь;
	СохранитьДанные();
	СтруктураРеквизитовУведомления = Новый Структура("СписокПечатаемыхЛистов", ОбщегоНазначения.ОбщийМодуль("Отчеты.РегламентированноеУведомлениеФормаР24001").СформироватьСписокЛистов(Объект, ЕстьВыходЗаГраницы));
КонецПроцедуры
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеЗаполненоВПомощникеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВнесениеИзмененийЕГР" Тогда
		СтандартнаяОбработка = Ложь;
		
		МодульРегистрацияОрганизацииКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("РегистрацияОрганизацииКлиентСервер");
		ПараметрыПомощника = МодульРегистрацияОрганизацииКлиентСервер.НовыеПараметрыПомощникаВнесенияИзменений();
		ПараметрыПомощника.Организация = Объект.Организация;
		ПараметрыПомощника.КонтекстныйВызов = Истина;
		
		МодульРегистрацияОрганизацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РегистрацияОрганизацииКлиент");
		МодульРегистрацияОрганизацииКлиент.ОткрытьПомощникВнесенияИзменений(ПараметрыПомощника);
		
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьУведомлениеЗаполненоВПомощникеНажатие(Элемент)
	УведомлениеЗаполненоВПомощнике = Ложь;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	Форма.Элементы.ГруппаУведомлениеИзПомощника.Видимость = Форма.УведомлениеЗаполненоВПомощнике;
КонецПроцедуры
