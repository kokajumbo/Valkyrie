#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОптимизации = ИнтеграцияВЕТИС.ПараметрыОптимизации();
	
	ВремяОжиданияОбработкиЗаявки                 = ПараметрыОптимизации.ВремяОжиданияОбработкиЗаявки;
	КоличествоПовторныхЗапросов                  = ПараметрыОптимизации.КоличествоПовторныхЗапросов;
	КоличествоПопытокВосстановленияДокументов    = ПараметрыОптимизации.КоличествоПопытокВосстановленияДокументов;
	КоличествоЭлементов                          = ПараметрыОптимизации.КоличествоЭлементов;
	ИнтервалМеждуЗапросамиСписков                = ПараметрыОптимизации.ИнтервалМеждуЗапросамиСписков;
	
	ОтправлятьЗависшиеЗапросыПовторно            = ПараметрыОптимизации.ОтправлятьЗависшиеЗапросыПовторно;
	ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала = ПараметрыОптимизации.ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнтервалЗапросаИзмененныхДанныхВЕТИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОжиданияОбработкиЗаявкиПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьЗависшиеЗапросыПовторноПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуЗапросамиСписковПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПовторныхЗапросовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПопытокВосстановленияДокументовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗапрашиватьИзмененияЗаписейСкладскогоЖурналаПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьСинхронизацииТолькоВРегламентномЗаданииПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПовторныхЗапросовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВремяОжиданияОбработкиЗаявкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуЗапросамиСписковОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалЗапросаИзмененныхДанныхВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНастройкиКлиент(Элемент)
	
	Результат = ПриИзмененииНастройкиСервер(Элемент.Имя);
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииНастройкиСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СинхронизацияКлассификаторовВЕТИС");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Если ИмяЭлемента = "КоличествоЭлементов" Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СинхронизацияКлассификаторовВЕТИС.ТипВЕТИС             КАК ТипВЕТИС,
			|	СинхронизацияКлассификаторовВЕТИС.ХозяйствующийСубъект КАК ХозяйствующийСубъект,
			|	СинхронизацияКлассификаторовВЕТИС.Предприятие          КАК Предприятие,
			|	СинхронизацияКлассификаторовВЕТИС.ДатаСинхронизации    КАК ДатаСинхронизации,
			|	СинхронизацияКлассификаторовВЕТИС.Смещение             КАК Смещение
			|ИЗ
			|	РегистрСведений.СинхронизацияКлассификаторовВЕТИС КАК СинхронизацияКлассификаторовВЕТИС
			|ГДЕ
			|	СинхронизацияКлассификаторовВЕТИС.ТипВЕТИС В (
			|		ЗНАЧЕНИЕ(Перечисление.ТипыВЕТИС.ВетеринарноСопроводительныеДокументы),
			|		ЗНАЧЕНИЕ(Перечисление.ТипыВЕТИС.ЗаписиСкладскогоЖурнала))
			|	И СинхронизацияКлассификаторовВЕТИС.Смещение > 0");
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				НаборЗаписей = РегистрыСведений.СинхронизацияКлассификаторовВЕТИС.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ТипВЕТИС.Установить(Выборка.ТипВЕТИС);
				НаборЗаписей.Отбор.ХозяйствующийСубъект.Установить(Выборка.ХозяйствующийСубъект);
				НаборЗаписей.Отбор.Предприятие.Установить(Выборка.Предприятие);
				
				ЗаписьНабора = НаборЗаписей.Добавить();
				ЗаписьНабора.ТипВЕТИС             = Выборка.ТипВЕТИС;
				ЗаписьНабора.ДатаСинхронизации    = Выборка.ДатаСинхронизации;
				ЗаписьНабора.Смещение             = 0;
				ЗаписьНабора.ХозяйствующийСубъект = Выборка.ХозяйствующийСубъект;
				ЗаписьНабора.Предприятие          = Выборка.Предприятие;
				
				НаборЗаписей.Записать();
				
			КонецЦикла;
			
		КонецЕсли;
		
		ПараметрыОптимизации = ИнтеграцияВЕТИС.ПараметрыОптимизации();
		ПараметрыОптимизации.ВремяОжиданияОбработкиЗаявки                     = ВремяОжиданияОбработкиЗаявки;
		ПараметрыОптимизации.ИнтервалМеждуЗапросамиСписков                    = ИнтервалМеждуЗапросамиСписков;
		ПараметрыОптимизации.КоличествоПовторныхЗапросов                      = КоличествоПовторныхЗапросов;
		ПараметрыОптимизации.КоличествоПопытокВосстановленияДокументов        = КоличествоПопытокВосстановленияДокументов;
		ПараметрыОптимизации.КоличествоЭлементов                              = КоличествоЭлементов;
		ПараметрыОптимизации.ОтправлятьЗависшиеЗапросыПовторно                = ОтправлятьЗависшиеЗапросыПовторно;
		ПараметрыОптимизации.ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала     = ЗапрашиватьИзмененияЗаписейСкладскогоЖурнала;
		ПараметрыОптимизации.ВыполнятьСинхронизацииТолькоВРегламентномЗадании = ВыполнятьСинхронизацииТолькоВРегламентномЗадании;
		
		Константы.НастройкиОбменаВЕТИС.Установить(Новый ХранилищеЗначения(ПараметрыОптимизации));
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнфрмацияОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнфрмацияОшибки));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, КонстантаИмя, КонстантаЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ПраваНаРедактирование = ПраваНаРедактированиеЭлементовФормы();
	
	Для Каждого ЭлементФормы Из Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
			
			МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементФормы.ПутьКДанным, ".");
			ИмяРеквизитаФормы = МассивПодстрок[МассивПодстрок.ВГраница()];
			ПравоТолькоПросмотр = Не ПраваНаРедактирование.Получить(ИмяРеквизитаФормы);
			ЭлементФормы.ТолькоПросмотр = ПравоТолькоПросмотр; 
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПраваНаРедактированиеЭлементовФормы()
	
	Соответствие = Новый Соответствие;
	
	НастройкиОбменаВЕТИС = ИнтеграцияВЕТИС.ПараметрыОптимизации();	
	ПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Константы.НастройкиОбменаВЕТИС);
	Для Каждого КлючЗначение Из НастройкиОбменаВЕТИС Цикл	
		Соответствие.Вставить(КлючЗначение.Ключ, ПравоРедактирования);
	КонецЦикла;
	
	мИнтервалЗапросаИзмененныхДанныхВЕТИС = Метаданные.Константы.ИнтервалЗапросаИзмененныхДанныхВЕТИС; 
	ПравоРедактирования = ПравоДоступа("Редактирование", мИнтервалЗапросаИзмененныхДанныхВЕТИС);
	Соответствие.Вставить(мИнтервалЗапросаИзмененныхДанныхВЕТИС.Имя, ПравоРедактирования);
	
	Возврат Соответствие;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти