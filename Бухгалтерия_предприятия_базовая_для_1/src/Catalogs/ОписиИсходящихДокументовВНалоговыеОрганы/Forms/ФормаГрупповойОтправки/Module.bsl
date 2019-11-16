&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем МассивОтправляемыхОписей, ИндексОтправляемойОписи, СоответствиеОписьОтправлена;

&НаКлиенте
Перем ФормаДлительнаяОперация;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Требование = Параметры.Требование;
	НомерДата = Требование.НомерДокумента + " от " + Формат(Требование.ДатаДокумента, "ДЛФ=DD");
	Заголовок = "Отправка ответов на требование " + НомерДата;
	
	ЗаполнитьТаблицуОписей(Параметры.СписокОписей);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОписиИсходящихДокументовВНалоговыеОрганы" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы") Тогда
		ОбновитьСтатусОписейТаблицы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТаблицаОписейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОписейПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	ТекущаяСтрока = Элементы.ТаблицаОписей.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПоказатьЗначение(, ТекущаяСтрока.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВсе(Команда)
	
	ОбновитьСтатусОписейТаблицы();
	
		
	МассивОтправляемыхОписей = Новый Массив;
	СоответствиеОписьОтправлена = Новый Соответствие;
	ЕстьОтправленныеОписи = Ложь;
	
	Для каждого СтрокаТаблицыОписей Из ТаблицаОписей Цикл
		Если СтрокаТаблицыОписей.СтатусКартинка = 1 Тогда 
			//Опись не отправлялась
			МассивОтправляемыхОписей.Добавить(СтрокаТаблицыОписей.Ссылка);
		Иначе
			ЕстьОтправленныеОписи = Истина;			
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьОтправленныеОписи Тогда
		ТекстВопроса = "Все неотправленные ответы на требование из списка будут отправлены в ФНС. Продолжить?";
	Иначе
		ТекстВопроса = "Все ответы на требование из списка будут отправлены в ФНС. Продолжить?";
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьВсеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуОписей(СписокОписей)
	
	ЕстьНеотправленныеОписи = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОписиИсходящихДокументовВНалоговыеОрганыПредставляемыеДокументы.Ссылка КАК ОписьСсылка,
	|	СУММА(1) КАК КолвоДокументов
	|ПОМЕСТИТЬ КолвоДокументовВОписях
	|ИЗ
	|	Справочник.ОписиИсходящихДокументовВНалоговыеОрганы.ПредставляемыеДокументы КАК ОписиИсходящихДокументовВНалоговыеОрганыПредставляемыеДокументы
	|ГДЕ
	|	ОписиИсходящихДокументовВНалоговыеОрганыПредставляемыеДокументы.Ссылка В(&СписокОписей)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОписиИсходящихДокументовВНалоговыеОрганыПредставляемыеДокументы.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ОписиИсходящихДокументов.ПометкаУдаления
	|			ТОГДА ВЫБОР
	|					КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Отправлен)
	|						ТОГДА 10
	|					ИНАЧЕ ВЫБОР
	|							КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Доставлен)
	|								ТОГДА 11
	|							ИНАЧЕ ВЫБОР
	|									КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.НеПринят)
	|										ТОГДА 12
	|									ИНАЧЕ ВЫБОР
	|											КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Сдан)
	|												ТОГДА 13
	|											ИНАЧЕ 8
	|										КОНЕЦ
	|								КОНЕЦ
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Отправлен)
	|					ТОГДА 3
	|				ИНАЧЕ ВЫБОР
	|						КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Доставлен)
	|							ТОГДА 4
	|						ИНАЧЕ ВЫБОР
	|								КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.НеПринят)
	|									ТОГДА 5
	|								ИНАЧЕ ВЫБОР
	|										КОГДА СтатусОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Сдан)
	|											ТОГДА 6
	|										ИНАЧЕ 1
	|									КОНЕЦ
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК СтатусКартинка,
	|	КолвоДокументовВОписях.КолвоДокументов КАК КоличествоДокументов,
	|	ОписиИсходящихДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ОписиИсходящихДокументовВНалоговыеОрганы КАК ОписиИсходящихДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СтатусыОтправки.Объект КАК Объект,
	|			СтатусыОтправки.Статус КАК Статус
	|		ИЗ
	|			РегистрСведений.СтатусыОтправки КАК СтатусыОтправки) КАК СтатусОтправки
	|		ПО (СтатусОтправки.Объект = ОписиИсходящихДокументов.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КолвоДокументовВОписях КАК КолвоДокументовВОписях
	|		ПО ОписиИсходящихДокументов.Ссылка = КолвоДокументовВОписях.ОписьСсылка
	|ГДЕ
	|	ОписиИсходящихДокументов.Ссылка В(&СписокОписей)";
	
	Запрос.УстановитьПараметр("СписокОписей", СписокОписей); 
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаОписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если Выборка.СтатусКартинка = 1 Тогда
			ЕстьНеотправленныеОписи = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ОтправитьВсе.Доступность = ЕстьНеотправленныеОписи;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусОписейТаблицы()
	
	СписокОписей = Новый СписокЗначений;
	
	Для каждого СтрокаТаблицыОписей Из ТаблицаОписей Цикл
		СписокОписей.Добавить(СтрокаТаблицыОписей.Ссылка);	
	КонецЦикла;
	
	ТаблицаОписей.Очистить();
	ЗаполнитьТаблицуОписей(СписокОписей);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтправитьОписьПоТекущемуИндексу()
	
	ОтправляемаяОпись = МассивОтправляемыхОписей[ИндексОтправляемойОписи];
	
	ВыполнятьАвтонастройку = (ИндексОтправляемойОписи < 1);
	
	ЭтаФорма.Активизировать();
	
	ДополнительныеПараметры = Новый Структура("ОтправляемаяОпись", ОтправляемаяОпись);
	ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_ОтправитьОписьПоТекущемуИндексуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОрганизацияОтправляемойОписи = КонтекстЭДОКлиент.ПолучитьРеквизитНаСервере(ОтправляемаяОпись, "Организация");
	
	КонтекстЭДОКлиент.ОтправкаОписиИсходящихДокументовВФНС(
		ОтправляемаяОпись,
		ОрганизацияОтправляемойОписи,
		УникальныйИдентификатор,
		ОписаниеОповещения,
		ВыполнятьАвтонастройку);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтправитьОписьПоТекущемуИндексуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОтправляемаяОпись = ДополнительныеПараметры.ОтправляемаяОпись;
	
	Если Результат Тогда
		СоответствиеОписьОтправлена.Вставить(ОтправляемаяОпись, Истина);
	Иначе
		СоответствиеОписьОтправлена.Вставить(ОтправляемаяОпись, Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьОписьПоТекущемуИндексу()
	
	КолвоОтправляемыхОписей = МассивОтправляемыхОписей.Количество();
	НомерОписи = ИндексОтправляемойОписи + 1;
	
	Если КолвоОтправляемыхОписей < НомерОписи Тогда
		//все описи из массива были отправлены
		ОтключитьОбработчикОжидания("Подключаемый_ПродвинутьСостояниеОтправкиОписи");
		УправлениеВидимостьюФормыДлительнаяОперация(ФормаДлительнаяОперация, Ложь);
		
		ЕстьНеотправленныеОписи = Ложь;
		Для каждого ОтправкаОписи Из СоответствиеОписьОтправлена Цикл
			Если ОтправкаОписи.Значение = Ложь Тогда
				ЕстьНеотправленныеОписи = Истина
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		ТекстПояснения = "Отправка описи " + НомерОписи + " из " + КолвоОтправляемыхОписей + ". Пожалуйста, подождите...";
		
		Если ФормаДлительнаяОперация <> Неопределено Тогда
			ФормаДлительнаяОперация.ПоясняющийТекстДлительнойОперации = ТекстПояснения;
			ФормаДлительнаяОперация.ОбновитьОтображениеДанных();
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("Подключаемый_ОтправитьОписьПоТекущемуИндексу", 0.1, Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюФормыДлительнаяОперация(ФормаДлительнаяОперация, Показывать)
	
	Если Показывать Тогда
		
		Если ФормаДлительнаяОперация = Неопределено Тогда
			ФормаДлительнаяОперация = ОткрытьФорму("Справочник.ОписиИсходящихДокументовВНалоговыеОрганы.Форма.ФормаДлительнаяОперация");
			
		ИначеЕсли НЕ ФормаДлительнаяОперация.Открыта() Тогда
			ФормаДлительнаяОперация.Открыть();
		КонецЕсли;
		
	Иначе
		
		Если ФормаДлительнаяОперация <> Неопределено И ФормаДлительнаяОперация.Открыта() Тогда
			ФормаДлительнаяОперация.Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродвинутьСостояниеОтправкиОписи()
	
	ОтправляемаяОпись = МассивОтправляемыхОписей[ИндексОтправляемойОписи];
	СтатусОтправкиОписи = СоответствиеОписьОтправлена[ОтправляемаяОпись];
	Если СтатусОтправкиОписи = Неопределено Тогда
		//Процесс отправки еще не завершен
	Иначе
		ИндексОтправляемойОписи = ИндексОтправляемойОписи + 1;
		ОтправитьОписьПоТекущемуИндексу();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВсеЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ФормаДлительнаяОперация = Неопределено;
	
	УправлениеВидимостьюФормыДлительнаяОперация(ФормаДлительнаяОперация, Истина);
	ЭтаФорма.Активизировать();
	
	ИндексОтправляемойОписи = 0;
	ОтправитьОписьПоТекущемуИндексу();
	ПодключитьОбработчикОжидания("Подключаемый_ПродвинутьСостояниеОтправкиОписи", 2);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
