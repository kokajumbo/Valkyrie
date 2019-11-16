////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПлательщик = Параметры.ЭтоПлательщик;
	
	ОрганизацияИП = ?(ЭтоПлательщик,
		(Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Объект.Организация, "ЮридическоеФизическоеЛицо")),
		Ложь);
	
	ПереводМеждуСчетами         = Параметры.Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПереводНаДругойСчет;
	ПеречислениеФизическомуЛицу = УчетДенежныхСредствКлиентСервер.РасчетыСФизическимиЛицами(Параметры.Объект.ВидОперации);
	ПеречислениеНаЛичныйСчет    = ПеречислениеФизическомуЛицу И НЕ ЗначениеЗаполнено(Параметры.Объект.Банк);
	
	АвтоЗначенияРеквизитов = УчетДенежныхСредствБП.СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(
		Параметры.Объект.Организация,
		Параметры.Объект.СчетОрганизации,
		?(ПереводМеждуСчетами, Параметры.Объект.Организация,
			?(ПеречислениеФизическомуЛицу И НЕ ПеречислениеНаЛичныйСчет, Параметры.Объект.Банк, Параметры.Объект.Контрагент)),
		Параметры.Объект.СчетКонтрагента,
		Истина,
		Параметры.Объект.Дата);
	
	Если ЭтоПлательщик Тогда
		ВсегдаУказыватьКПП     = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Объект.СчетОрганизации, "ВсегдаУказыватьКПП");
		ТекстНаименования      = Параметры.Объект.ТекстПлательщика;
		УказаниеКППОбязательно = Параметры.Объект.ПеречислениеВБюджет ИЛИ НЕ ОрганизацияИП И ВсегдаУказыватьКПП;
		
		ИНН = Параметры.Объект.ИННПлательщика;
		КПП = Параметры.Объект.КПППлательщика;
		
		ИННОбъекта = АвтоЗначенияРеквизитов.ИННПлательщика;
		Если УказаниеКППОбязательно Тогда
			Если НЕ ПустаяСтрока(КПП) Тогда
				КППОбъекта = КПП;
			ИначеЕсли НЕ ПустаяСтрока(АвтоЗначенияРеквизитов.КПППлательщика) Тогда
				КППОбъекта = АвтоЗначенияРеквизитов.КПППлательщика;
			ИначеЕсли ЭтоПлательщик И ОрганизацияИП Тогда
				КППОбъекта = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение();
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ПереводМеждуСчетами Тогда
			ПолучательФизЛицо = ОрганизацияИП;
		ИначеЕсли ПеречислениеФизическомуЛицу Тогда
			Если ПеречислениеНаЛичныйСчет Тогда
				ПолучательФизЛицо = Истина;
			ИначеЕсли ЗначениеЗаполнено(Параметры.Объект.Банк) Тогда
				СтранаРегистрацииПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Объект.Банк, "СтранаРегистрации");
				ПолучательНерезидент        = СтранаРегистрацииПолучателя <> Справочники.СтраныМира.Россия;
			КонецЕсли;
		Иначе
			Если Параметры.Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов
				И ТипЗнч(Параметры.Объект.Контрагент) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				ПолучательФизЛицо = Истина;
				СтранаРегистрацииПолучателя = Справочники.СтраныМира.Россия;
			Иначе
				ПолучательФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо =
					ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
						?(ПеречислениеФизическомуЛицу, Параметры.Объект.Банк, Параметры.Объект.Контрагент), "ЮридическоеФизическоеЛицо");
						
				СтранаРегистрацииПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Объект.Контрагент, "СтранаРегистрации");
			КонецЕсли;
			
			ПолучательНерезидент = СтранаРегистрацииПолучателя <> Справочники.СтраныМира.Россия;
		КонецЕсли;
		
		ТекстНаименования      = Параметры.Объект.ТекстПолучателя;
		УказаниеКППОбязательно = НЕ ПолучательФизЛицо И НЕ ПолучательНерезидент
			И (Параметры.Объект.ПеречислениеВБюджет
			ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Объект.СчетКонтрагента, "ВсегдаУказыватьКПП"));
		
		ИНН = Параметры.Объект.ИННПолучателя;
		КПП = Параметры.Объект.КПППолучателя;
		
		ИННОбъекта = АвтоЗначенияРеквизитов.ИННПолучателя;
		Если УказаниеКППОбязательно И НЕ ПустаяСтрока(КПП) Тогда
			КППОбъекта = КПП;
		Иначе
			КППОбъекта = АвтоЗначенияРеквизитов.КПППолучателя
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЭтоПлательщик Тогда
		Элементы.ИНН.Заголовок = НСтр("ru = 'ИНН получателя'");
		Элементы.КПП.Заголовок = НСтр("ru = 'КПП получателя'");
		Элементы.ТекстНаименования.Заголовок = НСтр("ru = 'Наименование получателя'");
	КонецЕсли;
	
	ПлательщикаПолучателя = ?(ЭтоПлательщик, НСтр("ru = 'плательщика'"), НСтр("ru = 'получателя'"));
	
	ТекстИННВладельца = НСтр("ru = '%1 - ИНН, указанный для %2'");
	ТекстИННВладельца = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстИННВладельца, ИННОбъекта, ПлательщикаПолучателя);
	Элементы.ИНН.СписокВыбора.Добавить(ИННОбъекта, ТекстИННвладельца);
	
	ТекстКППвладельца = НСтр("ru = '%1 - КПП, указанный для %2 (основной)'");
	
	ТекстКППвладельца = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстКППвладельца, КППОбъекта, ПлательщикаПолучателя);
	Элементы.КПП.СписокВыбора.Добавить(КППОбъекта, ТекстКППвладельца);
	
	Если ЭтоПлательщик Тогда
		ЗаполнитьСписокКПП(СписокКПП, Параметры.Объект.Организация);
		Если СписокКПП.Количество() > 1 Тогда
			Для каждого ЭлементКПП Из СписокКПП Цикл
				Если Элементы.КПП.СписокВыбора.НайтиПоЗначению(ЭлементКПП.Значение) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ТекстШаблона = НСтр("ru = '%1 - КПП в налоговом органе ""%2""'");
				КПППредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстШаблона, ЭлементКПП.Значение, ЭлементКПП.Представление);
				Элементы.КПП.СписокВыбора.Добавить(ЭлементКПП.Значение, КПППредставление);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьДоступность();
	
	Заголовок = ?(ЭтоПлательщик, НСтр("ru = 'Реквизиты плательщика'"), НСтр("ru = 'Реквизиты получателя'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Изменить значения реквизитов в документе?'");
		Оповещение   = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КППОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "Неопределено" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение", ЭтотОбъект);
		ПоказатьВыборИзСписка(ОповещениеВыбора, СписокКПП, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	Если ЕстьОшибкиЗаполненияРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьРеквизитыДокумента();
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьДоступность()
	
	Если ОрганизацияИП И НЕ ВсегдаУказыватьКПП Тогда
		Элементы.КПП.АвтоОтметкаНезаполненного = Ложь;
	Иначе
		Элементы.КПП.АвтоОтметкаНезаполненного = УказаниеКППОбязательно;
	КонецЕсли;
	
	Если НЕ ЭтоПлательщик И ПолучательФизЛицо Тогда
		Элементы.КПП.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокКПП(СписокКПП, ВладелецСчета)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Спр.Наименование,
	|	Спр.КПП КАК КПП
	|ИЗ
	|	Справочник.РегистрацииВНалоговомОргане КАК Спр
	|ГДЕ
	|	Спр.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	КПП";
	
	Запрос.УстановитьПараметр("Владелец", ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(ВладелецСчета));
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ТекстШаблон = НСтр("ru = '%1 (%2)'");
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокКПП.Добавить(Выборка.КПП, Выборка.Наименование);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОшибкиЗаполненияРеквизитов()
	
	ОчиститьСообщения();
	ЕстьОшибки = Ложь;
	ЭтоЮрЛицо  = НЕ ПолучательФизЛицо;
	
	Если ПустаяСтрока(ИНН) Тогда
		Если ЭтоПлательщик Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""ИНН плательщика"" не заполнено'");
		Иначе
			ТекстПодстановки = "";
			ШаблонСообщения  = НСтр("ru = 'Поле ""ИНН получателя"" не заполнено.%1'");
			Если ПолучательФизЛицо Тогда
				ТекстПодстановки = НСтр("ru = '
					|Если ИНН физ.лица не известен, укажите ""0""'");
			КонецЕсли;
			
			Если ПолучательНерезидент Тогда
				ТекстПодстановки = НСтр("ru = '
					|Если у нерезидента нет ИНН, укажите КИО или ""0""'");
			КонецЕсли;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ТекстПодстановки);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ИНН",, ЕстьОшибки);
	ИначеЕсли НЕ ЭтоПлательщик И (ПолучательФизЛицо ИЛИ ПолучательНерезидент) И ИНН = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение() Тогда
		// Для получателя - физ.лица можно указывать "0", если ИНН неизвестен или отсутствует.
	ИначеЕсли НЕ (ПолучательНерезидент И СтрДлина(СокрЛП(ИНН)) = 5) Тогда // Для нерезидента может указываться КИО, который состоит из 5 знаков.
		РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямИНН(ИНН, ЭтоЮрЛицо);
		Если НЕ РезультатПроверки.СоответствуетТребованиям Тогда
			РезультатПроверкиФизЛицо = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямИНН(ИНН, НЕ ЭтоЮрЛицо);
			Если ЭтоПлательщик
				И (ИНН = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение() ИЛИ РезультатПроверкиФизЛицо.СоответствуетТребованиям) Тогда
				// Возможно это уплата по исполнительному листу ("101" - "19") и при уплате налога за третье лицо.
				// Дополнительная проверка на соответствие полю "101" (Статус плательщика) будет в обработке проведения.
				ЕстьОшибки = Ложь;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.ОписаниеОшибки,, "ИНН",, ЕстьОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если УказаниеКППОбязательно Тогда
		Если ПустаяСтрока(КПП) Тогда
			Если ЭтоПлательщик Тогда
				ТекстСообщения = НСтр("ru = 'Поле ""КПП плательщика"" не заполнено'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Поле ""КПП получателя"" не заполнено'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КПП",, ЕстьОшибки);
		ИначеЕсли ОрганизацияИП И КПП = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение() Тогда
			// Для плательщика - ИП указывается "0".
		Иначе
			ЭтоКонтрагент = НЕ ЭтоПлательщик;
			РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямКПП(КПП, ЭтоЮрЛицо, Ложь, ЭтоКонтрагент);
			Если НЕ РезультатПроверки.СоответствуетТребованиям Тогда
				Если НЕ (ЭтоПлательщик И КПП = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение()) Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.ОписаниеОшибки,, "КПП",, ЕстьОшибки);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстНаименования) Тогда
		Если ЭтоПлательщик Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Наименование плательщика"" не заполнено'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Поле ""Наименование получателя"" не заполнено'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ТекстНаименования",, ЕстьОшибки);
	КонецЕсли;
	
	Возврат ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьРеквизитыДокумента()
	
	СтруктураРезультата = Новый Структура;
	
	Если ЭтоПлательщик Тогда
		СтруктураРезультата.Вставить("ИННПлательщика",   ИНН);
		СтруктураРезультата.Вставить("КПППлательщика",   КПП);
		СтруктураРезультата.Вставить("ТекстПлательщика", ТекстНаименования);
		Оповестить("ВыборРеквизитовПлательщика", СтруктураРезультата, ВладелецФормы);
	Иначе
		СтруктураРезультата.Вставить("ИННПолучателя",   ИНН);
		СтруктураРезультата.Вставить("КПППолучателя",   КПП);
		СтруктураРезультата.Вставить("ТекстПолучателя", ТекстНаименования);
		Оповестить("ВыборРеквизитовПолучателя", СтруктураРезультата, ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		КПП = ВыбранныйЭлемент.Значение;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЗАВЕРШЕНИЕ НЕМОДАЛЬНЫХ ВЫЗОВОВ

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ЕстьОшибкиЗаполненияРеквизитов() Тогда
			Возврат;
		КонецЕсли;
		
		ИзменитьРеквизитыДокумента();
		Модифицированность = Ложь;
	ИначеЕсли Результат <> КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		Модифицированность = Ложь;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры
