&НаКлиенте
Перем Хранилище Экспорт;
&НаКлиенте
Перем КонтекстЭДО Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("БезВозможностиВыбора") И Параметры.БезВозможностиВыбора Тогда
		БезВозможностиВыбора = Истина;
		Элементы.КоманднаяПанельФормыВыбрать.Видимость = Ложь;
	КонецЕсли;
	
	// переопределяем параметры в реквизиты
	МножественныйВыбор = Параметры.МножественныйВыбор;
	Отпечатки = Параметры.Отпечатки;
	
	// если форма открыта не для множественного выбора, то скроем ЭУ, связанные с ним
	Если НЕ МножественныйВыбор Тогда
		Элементы.ГруппаМножественныйВыбор.Видимость = Ложь;
	КонецЕсли;
	
	// определяем с каким хранилищем будем работать
	ОбрабатываемоеХранилище = ?(ЗначениеЗаполнено(Параметры.Хранилище), Врег(Параметры.Хранилище), "MY");
	
	// регулируем пометку у кнопки показа просроченных сертификатов
	ЗапретитьВыборПросроченных = Параметры.ЗапретитьВыборПросроченных;
	Если ЗапретитьВыборПросроченных Тогда
		Элементы.ПоказыватьПросроченные.Пометка   = Ложь;
		Элементы.ПоказыватьПросроченные.Видимость = Ложь;
	Иначе
		Элементы.ПоказыватьПросроченные.Пометка = (Параметры.ПоказыватьПросроченные = Истина);
	КонецЕсли;
	
	// регулируем видимость колонки ИНН (если показывается хранилище Личные, то ИНН показываем)
	Элементы.СертификатыИНН.Видимость = (ОбрабатываемоеХранилище = "MY");
	Элементы.СертификатыСНИЛС.Видимость = (ОбрабатываемоеХранилище = "MY");
	
	// инициализируем массив с начальными значениями
	Если НЕ ЗначениеЗаполнено(Параметры.НачальноеЗначениеВыбора) Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений;
	ИначеЕсли ТипЗнч(Параметры.НачальноеЗначениеВыбора) = Тип("Массив") Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений;
		НачальноеЗначениеВыбора.ЗагрузитьЗначения(Параметры.НачальноеЗначениеВыбора);
	ИначеЕсли ТипЗнч(Параметры.НачальноеЗначениеВыбора) = Тип("Строка") Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений;
		НачальноеЗначениеВыбора.Добавить(Параметры.НачальноеЗначениеВыбора);
	Иначе
		НачальноеЗначениеВыбора = Новый СписокЗначений;
		НачальноеЗначениеВыбора.ЗагрузитьЗначения(Параметры.НачальноеЗначениеВыбора.Выгрузить( ,"Сертификат").ВыгрузитьКолонку("Сертификат"));
	КонецЕсли;
	
	Если НачальноеЗначениеВыбора.Количество() > 1 Тогда
		Элементы.МножественныйВыбор.Пометка = Истина;
	КонецЕсли;
	
	//
	ТекДата = ТекущаяДатаСеанса();
	
	Для Каждого ЭлементУсловногоОформления Из УсловноеОформление.Элементы Цикл
		Для Каждого Эл Из ЭлементУсловногоОформления.Отбор.Элементы Цикл
			Эл.ПравоеЗначение = ТекДата;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст ЭДО
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Получение контекста ЭДО" И КонтекстЭДО <> Неопределено И ТипЗнч(Параметр) = Тип("Структура") Тогда
		Параметр.КонтекстЭДО = КонтекстЭДО;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если БезВозможностиВыбора Тогда
		ПоказатьСертификат();
	Иначе
		ВыбратьСертификат(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КоманднаяПанельСертификатыПоказать(Команда = Неопределено)
	
	ПоказатьСертификат()

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыВыбрать(Кнопка)
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите сертификат!");
		Возврат;
	КонецЕсли;
	
	ВыбратьСертификат();
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыПоказыватьПросроченные(Команда)
	
	Элементы.ПоказыватьПросроченные.Пометка = НЕ Элементы.ПоказыватьПросроченные.Пометка;
	ОтобразитьТаблицуСертификатов();

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСертификатыМножественныйВыбор(Команда)
	
	Элементы.МножественныйВыбор.Пометка = НЕ Элементы.МножественныйВыбор.Пометка;
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСертификатыУстановитьВсеФлажки(Команда)
	
	Для Каждого Стр Из Сертификаты Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСертификатыСнятьВсеФлажки(Команда)
	
	Для Каждого Стр Из Сертификаты Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьСертификат()
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите в таблице сертификат для показа.'"));
	Иначе
		СертификатДляПоказа = Новый Структура("СерийныйНомер, Поставщик", ТекДанные.СерийныйНомер, ТекДанные.Поставщик);
		КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПоказа);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьСертификатыЗавершение", ЭтотОбъект, Новый Структура("КонтекстЭДО", КонтекстЭДО));
		
	КриптографияЭДКОКлиент.ПолучитьСертификаты(
		ОписаниеОповещения, Новый Структура("Хранилище,ЭтоЛокальноеХранилище", ОбрабатываемоеХранилище, Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСертификатыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Выполнено Тогда
		СписокСертификаты = Результат.Сертификаты;
		КонтекстЭДО = ДополнительныеПараметры.КонтекстЭДО;
	Иначе
		СписокСертификаты = Новый Массив;
	КонецЕсли;
	
	// заполняем полную таблицу сертификатов из хранилища
	Для Каждого ЭлементСертификат Из СписокСертификаты Цикл
		
		Если Отпечатки.Количество() > 0 И Отпечатки.НайтиПоЗначению(ЭлементСертификат.Отпечаток) <> Неопределено 
			ИЛИ Отпечатки.Количество() = 0 Тогда
			
			НовСтр = ПолнаяТаблицаСертификатов.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, ЭлементСертификат);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПостОбработкаПолнойТаблицыСертификатовНаСервере();
	
	// если один из сертификатов начального значения выбора просрочен, то включим показ просроченных
	ТекДата = КонтекстЭДО.ТекущаяДатаНаСервере();
	
	Если НЕ ЗапретитьВыборПросроченных Тогда
		Для Каждого ЭлНачальноеЗначениеВыбора Из НачальноеЗначениеВыбора Цикл
			Если ЗначениеЗаполнено(ЭлНачальноеЗначениеВыбора.Значение) Тогда
				ТекСертСтроки = ПолнаяТаблицаСертификатов.НайтиСтроки(Новый Структура("Отпечаток", ЭлНачальноеЗначениеВыбора.Значение));
				Если ТекСертСтроки.Количество() > 0 Тогда
					Для Каждого ТекСертСтрока Из ТекСертСтроки Цикл
						Если НЕ Элементы.ПоказыватьПросроченные.Пометка И (ТекДата < ТекСертСтрока.ДействителенС ИЛИ ТекДата > ТекСертСтрока.ДействителенПо) Тогда
							Элементы.ПоказыватьПросроченные.Пометка = Истина;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// отображаем на форме таблицу сертификатов на основе полной таблицы сертификатов
	ОтобразитьТаблицуСертификатов();
	
	// активизируем начальные значения выбора
	Для Каждого ЭлНачальноеЗначениеВыбора Из НачальноеЗначениеВыбора Цикл
		Если ЗначениеЗаполнено(ЭлНачальноеЗначениеВыбора.Значение) Тогда
			ТекСертСтроки = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", ЭлНачальноеЗначениеВыбора.Значение));
			Если ТекСертСтроки.Количество() > 0 Тогда
				Для Каждого Стр Из ТекСертСтроки Цикл
					Стр.Пометка = Истина;
					Элементы.Сертификаты.ТекущаяСтрока = Стр.ПолучитьИдентификатор();
				КонецЦикла;
			Иначе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сертификат с отпечатком ""%1"" не найден в хранилище сертификатов.'"),
					ЭлНачальноеЗначениеВыбора);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаСервере
Процедура ПостОбработкаПолнойТаблицыСертификатовНаСервере()
	
	Для Каждого СтрСертификат Из ПолнаяТаблицаСертификатов Цикл
		
		СтрСертификат.Поставщик = ЗначениеПоля(СтрСертификат.Поставщик);
		СтрСертификат.СерийныйНомер = ЗначениеПоля(СтрСертификат.СерийныйНомер);
		СтрСертификат.Владелец = ЗначениеПоля(СтрСертификат.Владелец);
		СтрСертификат.Наименование = ЗначениеПоля(СтрСертификат.Наименование);
		СтрСертификат.Отпечаток = нрег(СтрСертификат.Отпечаток);
		
		ПараметрыВладельца = РазложитьСтрокуВладелец(СтрСертификат.ВладелецСтруктура);
		СтрСертификат.ИмяВладельца = ЗначениеПоля(ПараметрыВладельца.Имя);
		СтрСертификат.Организация = ЗначениеПоля(ПараметрыВладельца.Организация);
		СтрСертификат.Должность = ЗначениеПоля(?(ЗначениеЗаполнено(ПараметрыВладельца.Должность) И ПараметрыВладельца.Должность <> "0", ПараметрыВладельца.Должность, ПараметрыВладельца.Подразделение));
		СтрСертификат.EMail = ЗначениеПоля(ПараметрыВладельца.ЭлектроннаяПочта);
		СтрСертификат.ИНН = ЗначениеПоля(ПараметрыВладельца.ИНН);
		СтрСертификат.СНИЛС = ЗначениеПоля(ПараметрыВладельца.СНИЛС);
		
		ПоставщикСтруктура = СтрСертификат.ПоставщикСтруктура;
		Если ПоставщикСтруктура.Свойство("CN") Тогда
			СтрСертификат.Издатель = ПоставщикСтруктура["CN"];
		КонецЕсли;
	
	КонецЦикла;
	
	ПолнаяТаблицаСертификатов.Сортировать("ИмяВладельца");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПоля(СтрЗначениеПоля)
	
	Возврат ?(НЕ ЗначениеЗаполнено(СтрЗначениеПоля) ИЛИ СокрЛП(СтрЗначениеПоля) = "0", "", СтрЗначениеПоля);
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьТаблицуСертификатов()
	
	// запоминаем выбранные сертификаты
	ВыбранныеСертификаты = Новый Массив;
	ПомеченныеСертификатыСтр = Сертификаты.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для Каждого ЭлСертификат Из ПомеченныеСертификатыСтр Цикл
		ВыбранныеСертификаты.Добавить(ЭлСертификат.Отпечаток);
	КонецЦикла;
	
	// запоминаем текущий сертификат
	Если Элементы.Сертификаты.ТекущиеДанные <> Неопределено Тогда
		ТекущийСертификат = Элементы.Сертификаты.ТекущиеДанные.Отпечаток;
	КонецЕсли;
	
	// очищаем таблицу перед новым заполнением
	Сертификаты.Очистить();
	
	// заполняем таблицу заново
	ТекущаяДата = КонтекстЭДО.ТекущаяДатаНаСервере();
	Для Каждого Серт Из ПолнаяТаблицаСертификатов Цикл
		Если НЕ Элементы.ПоказыватьПросроченные.Пометка И (ТекущаяДата < Серт.ДействителенС ИЛИ ТекущаяДата > Серт.ДействителенПо) Тогда
			Продолжить;
		КонецЕсли;
		
		НовСтр = Сертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Серт);
	КонецЦикла;
	
	// устанавливаем выбранные сертификаты
	Для Каждого ВыбранныйСертификат Из ВыбранныеСертификаты Цикл
		СтрНайденныеСертификаты = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", ВыбранныйСертификат));
		Для Каждого СтрНайденныйСертификат Из СтрНайденныеСертификаты Цикл
			СтрНайденныйСертификат.Пометка = Истина;
		КонецЦикла;
	КонецЦикла;
	
	// устанавливаем текущий сертификат
	Если ТекущийСертификат <> Неопределено Тогда
		СтрокаСертификат = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", ТекущийСертификат));
		Если СтрокаСертификат.Количество() > 0 Тогда
			Элементы.Сертификаты.ТекущаяСтрока = СтрокаСертификат[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазложитьСтрокуВладелец(Знач ВладелецСтруктура)
	
	СвойстваРезультат = Новый Структура();
	СвойстваРезультат.Вставить("Имя",              "");
	СвойстваРезультат.Вставить("Организация",      "");
	СвойстваРезультат.Вставить("Подразделение",    "");
	СвойстваРезультат.Вставить("ЭлектроннаяПочта", "");
	СвойстваРезультат.Вставить("Должность",        "");
	СвойстваРезультат.Вставить("ИНН",              "");
	СвойстваРезультат.Вставить("СНИЛС",            "");
	
	// ФИО
	Если ВладелецСтруктура.Свойство("SN") И ВладелецСтруктура.Свойство("GN") Тогда
		ФИО = ВладелецСтруктура["SN"] + " " + ВладелецСтруктура["GN"];
	ИначеЕсли ВладелецСтруктура.Свойство("CN") Тогда
		// У ПФРовских сертификатов поля с ФИО не заполнены.
		ФИО = ВладелецСтруктура["CN"];
	Иначе
		ФИО = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Имя", ФИО);

	// Организация
	Если ВладелецСтруктура.Свойство("O") Тогда
		Организация = ВладелецСтруктура["O"];
	Иначе
		Организация = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Организация", Организация);
	
	// Подразделение
	Если ВладелецСтруктура.Свойство("OU") Тогда
		Подразделение = ВладелецСтруктура["OU"];
	Иначе
		Подразделение = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Подразделение", Подразделение);
	
	// ЭлектроннаяПочта
	Если ВладелецСтруктура.Свойство("E") Тогда
		ЭлектроннаяПочта = ВладелецСтруктура["E"];
	Иначе
		ЭлектроннаяПочта = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);	

	// Должность
	Если ВладелецСтруктура.Свойство("T") Тогда
		Должность = ВладелецСтруктура["T"];
	Иначе
		Должность = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Должность", Должность);
	
	// ИНН
	Если ВладелецСтруктура.Свойство("INN") Тогда
		ИНН = ВладелецСтруктура["INN"];
	Иначе
		ИНН = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("ИНН", ИНН);
	
	// СНИЛС
	Если ВладелецСтруктура.Свойство("SNILS") Тогда
		СНИЛС = ВладелецСтруктура["SNILS"];
	Иначе
		СНИЛС = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("СНИЛС", СНИЛС);

	Возврат СвойстваРезультат;

КонецФункции

&НаКлиенте
Процедура УправлениеЭУ()
	
	Если Элементы.ГруппаМножественныйВыбор.Видимость И Элементы.МножественныйВыбор.Пометка Тогда
		Элементы.СертификатыПометка.Видимость = Истина;
		Элементы.УстановитьВсеФлажки.Доступность = Истина;
		Элементы.СнятьВсеФлажки.Доступность = Истина;
	Иначе
		Элементы.СертификатыПометка.Видимость = Ложь;
		Элементы.УстановитьВсеФлажки.Доступность = Ложь;
		Элементы.СнятьВсеФлажки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСертификат(парамМножественныйВыбор = Неопределено)
	
	ТекДата = КонтекстЭДО.ТекущаяДатаНаСервере();
	
	// если принудительно установлен режим выбора при вызове метода (множ. или нет) - используеи его
	Если парамМножественныйВыбор <> Неопределено Тогда
		ПризнакВыбораНесколькихСтрок = парамМножественныйВыбор;
	Иначе
		ПризнакВыбораНесколькихСтрок = Элементы.МножественныйВыбор.Пометка;
	КонецЕсли;
	
	Если ПризнакВыбораНесколькихСтрок Тогда
		// помещаем сертификаты в массив и анализируем их периоды действия
		ТекСертификаты = Новый Массив;
		ОдинИзСертификатовПросрочен = Ложь;
		Для Каждого СтрСертификат Из Сертификаты Цикл
			
			// если строка не помечена, то продолжим
			Если НЕ СтрСертификат.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			// если сертификат просрочен, то взведем флаг
			СрокИстек = ТекДата > СтрСертификат.ДействителенПо;
			СрокНеНачался = ТекДата < СтрСертификат.ДействителенС;
			Если СрокИстек ИЛИ СрокНеНачался Тогда
				ОдинИзСертификатовПросрочен = Истина;
			КонецЕсли;
			
			СвойстваСертификата = СвойстваСертификата(СтрСертификат);
			ТекСертификаты.Добавить(СвойстваСертификата);
			
		КонецЦикла;
		
		// если один из сертификатов просрочен, то задаем уточняющий вопрос
		Если ОдинИзСертификатовПросрочен Тогда
			ДополнительныеПараметры = Новый Структура("ТекСертификаты", ТекСертификаты);
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросСредиВыбранныеЕстьПросроченныеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ТекстВопроса = "Среди выбранных сертификатов есть такие, срок действия которых истек.
				|Вы уверены, что хотите продолжить выбор?";
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			Закрыть(ТекСертификаты);
		КонецЕсли;
		
	Иначе
		
		ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
		
		СрокИстек = ТекДата > ТекДанные.ДействителенПо;
		СрокНеНачался = ТекДата < ТекДанные.ДействителенС;
		Если СрокИстек ИЛИ СрокНеНачался Тогда
			ДополнительныеПараметры = Новый Структура("ТекДанные", ТекДанные);
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросСертификатПросроченЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ТекстВопроса = "Вы уверены, что хотите выбрать сертификат, срок действия которого " + ?(СрокИстек, "истек", "еще не начался") + "?";
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		
		СвойстваСертификата = СвойстваСертификата(ТекДанные);
		
		Закрыть(СвойстваСертификата);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СвойстваСертификата(ТекДанные)
	
	СвойстваСертификата = Новый Структура;
	СвойстваСертификата.Вставить("ДействителенС",			ТекДанные.ДействителенС);
	СвойстваСертификата.Вставить("ДействителенПо",			ТекДанные.ДействителенПо);
	СвойстваСертификата.Вставить("Отпечаток",				ТекДанные.Отпечаток);
	СвойстваСертификата.Вставить("Поставщик",				ТекДанные.Поставщик);
	СвойстваСертификата.Вставить("СерийныйНомер",			ТекДанные.СерийныйНомер);
	СвойстваСертификата.Вставить("Владелец",				ТекДанные.Владелец);
	СвойстваСертификата.Вставить("Наименование",			ТекДанные.Наименование);
	СвойстваСертификата.Вставить("ВозможностьПодписи",		ТекДанные.ПригоденДляПодписания);
	СвойстваСертификата.Вставить("ВозможностьШифрования",	ТекДанные.ПригоденДляШифрования);
	СвойстваСертификата.Вставить("ПоставщикСтруктура",		ТекДанные.ПоставщикСтруктура);
	СвойстваСертификата.Вставить("ВладелецСтруктура",		ТекДанные.ВладелецСтруктура);
	
	Возврат СвойстваСертификата;
	
КонецФункции

&НаКлиенте
Процедура ВопросСертификатПросроченЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекДанные = ДополнительныеПараметры.ТекДанные;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Закрыть(СвойстваСертификата(ТекДанные));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросСредиВыбранныеЕстьПросроченныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекСертификаты = ДополнительныеПараметры.ТекСертификаты;
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	Закрыть(ТекСертификаты);
	
КонецПроцедуры

#КонецОбласти

