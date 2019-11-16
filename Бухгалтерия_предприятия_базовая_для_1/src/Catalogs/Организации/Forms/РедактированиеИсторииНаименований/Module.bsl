
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоФизическоеЛицо = Параметры.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	Наименование = Параметры.Наименование;
	
	ИсторияНаименований.Загрузить(Параметры.ИсторияНаименований.Выгрузить());
	Если ИсторияНаименований.Количество() = 0 Тогда
		НоваяСтрока = ИсторияНаименований.Добавить();
		НоваяСтрока.НаименованиеПолное = Параметры.ТекущееНаименованиеПолное;
		НоваяСтрока.НаименованиеСокращенное = Параметры.ТекущееНаименованиеСокращенное;
		Если ЭтоФизическоеЛицо Тогда
			НоваяСтрока.ФамилияИП  = Параметры.ТекущаяФамилияИП;
			НоваяСтрока.ИмяИП      = Параметры.ТекущееИмяИП;
			НоваяСтрока.ОтчествоИП = Параметры.ТекущееОтчествоИП;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияНаименований);
	
	Если ИсторияНаименований.Количество() > 0 Тогда
		Элементы.ИсторияНаименований.ТекущаяСтрока = ИсторияНаименований[ИсторияНаименований.Количество()-1].ПолучитьИдентификатор();
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.Организации) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	Элементы.Наименование.Видимость                      = ЭтоФизическоеЛицо;
	Элементы.ИсторияНаименованийЗаголовокФИОИП.Видимость = ЭтоФизическоеЛицо;
	Элементы.ИсторияНаименованийГруппаФИО.Видимость      = ЭтоФизическоеЛицо;
	Элементы.ИсторияНаименованийГруппаНаименование.ОтображатьВШапке = НЕ ЭтоФизическоеЛицо;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыИсторияНаименований

&НаКлиенте
Процедура ИсторияНаименованийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			
			НовыйПериод = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			
			// Получим максимальный период в таблице
			ПоследнийПериод = '00010101000000';
			ПоследняяЗапись = Неопределено;
			Для Каждого ЗаписьИстории ИЗ ИсторияНаименований Цикл
				Если ЗаписьИстории.Период >= ПоследнийПериод
					И ЗаписьИстории <> Элемент.ТекущиеДанные Тогда
					ПоследнийПериод = ЗаписьИстории.Период;
					ПоследняяЗапись = ЗаписьИстории;
				КонецЕсли;
			КонецЦикла;
			
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = НачалоДня(ПоследнийПериод + 60*60*24);
			КонецЕсли;
			
			Элемент.ТекущиеДанные.Период = НовыйПериод;
			Если ПоследняяЗапись <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, ПоследняяЗапись, , "Период, ПервоначальноеЗначение");
			КонецЕсли;
			
			Если ЭтоФизическоеЛицо Тогда
				ЭтотОбъект.ТекущийЭлемент = Элементы.ИсторияНаименованийФамилияИП;
			Иначе
				ЭтотОбъект.ТекущийЭлемент = Элементы.ИсторияНаименованийНаименованиеСокращенное;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		НаименованиеСокращенноеДоИзменения = Элемент.ТекущиеДанные.НаименованиеСокращенное;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияНаименований);
	
	УстановитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПередУдалением(Элемент, Отказ)
	
	Если ИсторияНаименований.Индекс(Элемент.ТекущиеДанные) = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПослеУдаления(Элемент)
	
	УстановитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийНаименованиеСокращенноеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ИсторияНаименований.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоФизическоеЛицо Тогда
		Если ПустаяСтрока(ТекущиеДанные.НаименованиеПолное)
			ИЛИ ОрганизацииФормыКлиентСервер.ПолноеНаименованиеСоответствуетСокращенномуНаименованию(НаименованиеСокращенноеДоИзменения, ТекущиеДанные.НаименованиеПолное) Тогда
			ТекущиеДанные.НаименованиеПолное = ОрганизацииФормыКлиентСервер.ПолноеНаименованиеПоСокращенномуНаименованию(ТекущиеДанные.НаименованиеСокращенное);
		КонецЕсли;
	КонецЕсли;
	
	НаименованиеСокращенноеДоИзменения = ТекущиеДанные.НаименованиеСокращенное;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийФамилияИППриИзменении(Элемент)
	
	ФИОПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийИмяИППриИзменении(Элемент)
	
	ФИОПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийОтчествоИППриИзменении(Элемент)
	
	ФИОПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеИстории(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ИсторияНаименований", ИсторияНаименований);
	Если ЭтоФизическоеЛицо Тогда
		РезультатВыбора.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// ИсторияНаименованийПериод
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИсторияНаименованийПериод");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ИсторияНаименований.ПервоначальноеЗначение", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Начальное значение'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// ИсторияНаименованийПериод
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИсторияНаименованийПериод");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ИсторияНаименований.ПервоначальноеЗначение", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ИсторияНаименований.Период", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	// ИсторияНаименованийЗаголовокФИОИП
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИсторияНаименованийЗаголовокФИОИП");
	Элемент = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Истина;
	Элемент.ПравоеЗначение = Истина;
	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ФИО'"));
	
	// ИсторияНаименованийЗаголовокСокращенногоНаименования
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИсторияНаименованийЗаголовокСокращенногоНаименования");
	Элемент = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Истина;
	Элемент.ПравоеЗначение = Истина;
	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сокращенное'"));
	
	// ИсторияНаименованийЗаголовокПолногоНаименования
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИсторияНаименованийЗаголовокПолногоНаименования");
	Элемент = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Истина;
	Элемент.ПравоеЗначение = Истина;
	Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Полное'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПризнакПервоначальногоЗначения(ТаблицаИстории)
	
	ТаблицаИстории.Сортировать("Период");
	// Первая строка должна быть первоначальным значением
	Если ТаблицаИстории.Количество() > 0 Тогда
		ПерваяСтрока = ТаблицаИстории[0];
		ПерваяСтрока.ПервоначальноеЗначение = Истина;
		ПерваяСтрока.Период = '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеИстории(Отказ)
	
	ПериодыСтрок = Новый Массив;
	
	Для Каждого Запись Из ИсторияНаименований Цикл
		
		ИндексСтроки = ИсторияНаименований.Индекс(Запись);
		ПрефиксСообщенияСтроки = "ИсторияНаименований["+Формат(ИндексСтроки, "ЧЦ=; ЧДЦ=; ЧГ=")+"].";
		
		Если НЕ ЗначениеЗаполнено(Запись.Период) И ИндексСтроки > 0 Тогда
			СообщениеОбОшибке = НСтр("ru = 'Нужно указать дату начала действия'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если ПериодыСтрок.Найти(Запись.Период) = Неопределено Тогда
			Если ЗначениеЗаполнено(Запись.Период) Тогда
				ПериодыСтрок.Добавить(Запись.Период);
			КонецЕсли;
		Иначе
			// Строка с такой датой уже была раньше, это ошибка.
			// Не может быть 2 строки с одинаковой датой.
			СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.НаименованиеСокращенное) Тогда
			СообщениеОбОшибке = НСтр("ru = 'Поле ""Сокращенное наименование"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"НаименованиеСокращенное",  , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.НаименованиеПолное) Тогда
			СообщениеОбОшибке = НСтр("ru = 'Поле ""Полное наименование"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"НаименованиеПолное",  , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ФИОПриИзменении()
	
	ТекущиеДанные = Элементы.ИсторияНаименований.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ФамилияИП)
		ИЛИ ЗначениеЗаполнено(ТекущиеДанные.ИмяИП)
		ИЛИ ЗначениеЗаполнено(ТекущиеДанные.ОтчествоИП) Тогда
			
			ТекущиеДанные.НаименованиеСокращенное = ОрганизацииФормыКлиентСервер.СокращенноеНаименованиеИндивидульногоПредпринимателя(
									ТекущиеДанные.ФамилияИП, ТекущиеДанные.ИмяИП, ТекущиеДанные.ОтчествоИП);
			ТекущиеДанные.НаименованиеПолное = ОрганизацииФормыКлиентСервер.ПолноеНаименованиеИндивидульногоПредпринимателя(
									ТекущиеДанные.ФамилияИП, ТекущиеДанные.ИмяИП, ТекущиеДанные.ОтчествоИП);
			
	КонецЕсли;
	
	НаименованиеСокращенноеДоИзменения = ТекущиеДанные.НаименованиеСокращенное;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНаименование()
	
	Если ЭтоФизическоеЛицо Тогда
		
		Если ИсторияНаименований.Количество() > 0 Тогда
			ПоследняяСтрока = ИсторияНаименований.Количество() - 1;
			Наименование = ОрганизацииФормыКлиентСервер.НаименованиеИндивидульногоПредпринимателя(
										ИсторияНаименований[ПоследняяСтрока].ФамилияИП, ИсторияНаименований[ПоследняяСтрока].ИмяИП, ИсторияНаименований[ПоследняяСтрока].ОтчествоИП);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

