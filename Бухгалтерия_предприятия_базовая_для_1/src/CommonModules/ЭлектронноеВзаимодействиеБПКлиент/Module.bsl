////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеБПКлиент: вспомогательные процедуры и функции БЭД
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗагрузкаЭД

Процедура ЗагрузитьРеализациюТоваровИУслугИзФайла(Форма) Экспорт

	Если Не ЭлектронноеВзаимодействиеБПВызовСервера.ИмеетсяВозможностьЗагрузкиДанныхИзФайла() Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Недостаточно прав для просмотра'"));
		Возврат;
		
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗагрузкуРеализацииТоваровИУслугXMLИзФайла", ЭтотОбъект, 
		Новый Структура("Форма", Форма));	
		
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);

КонецПроцедуры

Процедура ЗагрузитьРеализациюТоваровИУслугИзЭлектроннойПочты(Форма) Экспорт

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВариантЗагрузкиЭД", ПредопределенноеЗначение("Перечисление.ВариантыЗагрузкиЭД.РеализацияТоваровИУслуг"));
	ДополнительныеПараметры.Вставить("ГлубинаПоиска", 7);
	ДополнительныеПараметры.Вставить("ИдентификаторФормыВладельца", Форма.УникальныйИдентификатор);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗагрузкуРеализацииТоваровИУслугXMLИзЭлектроннойПочты", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПрямойОбменЭД.Форма.Форма", ДополнительныеПараметры,,,,, ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область КонвертацияФайлаВФорматФНС

Процедура ПродолжитьЗагрузкуРеализацииТоваровИУслугXMLИзЭлектроннойПочты(СтруктураЭД, ДополнительныеПараметры) Экспорт

	Если СтруктураЭД <> Неопределено Тогда
		
		ЗагрузитьЭД(СтруктураЭД);
		
	КонецЕсли;

КонецПроцедуры  

Процедура ПрочитатьЗагруженныеФайлы(ЗагруженныеФайлы, ДополнительныеПараметры) Экспорт 
	
	Если ЗагруженныеФайлы <> Неопределено Тогда
		
		ОписаниеФайлов = ЗагруженныеФайлы[0];
		АдресФайла     = ОписаниеФайлов.Хранение;
		ПолноеИмяФайла = ОписаниеФайлов.Имя;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
	Если РасширениеФайла = "zip" Тогда
		
		// Для загрузки электронных документов в архиве zip использован механизм однократных сделок БЭД.
		СтруктураОбмена = Новый Структура();
		СтруктураОбмена.Вставить("НаправлениеЭД",           ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
		СтруктураОбмена.Вставить("УникальныйИдентификатор", Форма.УникальныйИдентификатор);
		СтруктураОбмена.Вставить("АдресХранилища",          АдресФайла);
		СтруктураОбмена.Вставить("СсылкаНаДокумент",        Неопределено);
		СтруктураОбмена.Вставить("ИмяФайла",                ПолноеИмяФайла);
		СтруктураОбмена.Вставить("ФайлАрхива",              Истина);
	
		Параметры = Новый Структура("СтруктураЭД", СтруктураОбмена);
		
		ОткрытьФорму(
			"Обработка.ОбменСКонтрагентами.Форма.ЗагрузкаПросмотрЭлектронногоДокумента",
			Параметры,
			,
			СтруктураОбмена.УникальныйИдентификатор);
		
	Иначе
		
		ОбработатьТабличныйДокумент(АдресФайла, РасширениеФайла, Форма);
		
	КонецЕсли;
		
КонецПроцедуры 

#КонецОбласти

#Область СозданиеПоступленияИзЭД

Процедура НачатьЗагрузкуЭД(АдресХранилища, ИдентификаторФормы, ЭтоАрхивЭД = Ложь) Экспорт
	
	Если Не ЭтоАрхивЭД Тогда
		
		ДанныеЭД = ЭлектронноеВзаимодействиеБПВызовСервера.РазобратьПолученныеДанные(АдресХранилища, ИдентификаторФормы);	
		Если ДанныеЭД.Свойство("ТекстОшибки") Тогда
				
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ДанныеЭД.ТекстОшибки;		
			Сообщение.ИдентификаторНазначения = ИдентификаторФормы;
			Сообщение.Сообщить();
			Возврат;
				
		КонецЕсли;
		
	Иначе
		
		ДанныеЭД = Новый Структура;
		ДанныеЭД.Вставить("АдресХранилища", АдресХранилища);
		
	КонецЕсли;
		
	АдресаФайловXML = Новый Массив;
	АдресаФайловXML.Добавить(ДанныеЭД.АдресХранилища);
	СтруктураЭД = ЭлектронноеВзаимодействиеБПВызовСервера.ПолучитьКонтрагентаИДанныеДокумента(АдресаФайловXML, ИдентификаторФормы);	
	Если ДанныеЭД.Свойство("НомерСФ") Тогда
		
		СтруктураЭД.Вставить("НомерСФ", ДанныеЭД.НомерСФ);
		СтруктураЭД.Вставить("ДатаСФ", ДанныеЭД.ДатаСФ);
		
	КонецЕсли;
	
	Если СтруктураЭД <> Неопределено Тогда
	
		ЗагрузитьЭД(СтруктураЭД);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ДокументыМассив - Массив - Ссылки на документы, которые требуется провести перед печатью.
//                             После выполнения функции из массива исключаются непроведенные документы.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                         которая будет вызвана после завершения проверки документов.
//  ФормаИсточник - УправляемаяФорма - форма, из которой была вызвана команда.
//
Процедура ВыполнитьПроверкуПроведенияДокументов(ДокументыМассив, ОбработкаПродолжения, ФормаИсточник = Неопределено) Экспорт

	ОчиститьСообщения();
	
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести.
										|Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести.
										|Выполнить проведение документов и продолжить?'");
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
		ДополнительныеПараметры.Вставить("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение);
		ДополнительныеПараметры.Вставить("ФормаИсточник", ФормаИсточник);
		ДополнительныеПараметры.Вставить("ДокументыМассив", ДокументыМассив);
		Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовПродолжить", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;

КонецПроцедуры

Процедура ВыполнитьПроверкуПроведенияДокументовПродолжить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ДокументыМассив = Неопределено;
	ОбработкаПродолжения = Неопределено;
	ДокументыТребующиеПроведение = Неопределено;
	Если Результат = КодВозвратаДиалога.Да
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения)
		И ДополнительныеПараметры.Свойство("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение) Тогда
		
		ФормаИсточник = Неопределено;
		ДополнительныеПараметры.Свойство("ФормаИсточник", ФормаИсточник);
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// Cообщаем о документах, которые не провелись.
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Формирование ЭД невозможно.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																	ШаблонСообщения,
																	Строка(ИнформацияОДокументе.Ссылка),
																	ИнформацияОДокументе.ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// Оповещаем открытые формы о том, что были проведены документы.
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыТребующиеПроведение,
																			НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		Оповестить("ОбновитьДокументИБПослеЗаполнения", ПроведенныеДокументы);
		
		// Обновляем исходный массив документов.
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыМассив, НепроведенныеДокументы);
		ЕстьДокументыГотовыеДляФормированияЭД = ДокументыМассив.Количество() > 0;
		Если КоличествоНепроведенныхДокументов > 0 Тогда
			
			// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов.
			ТекстВопроса = НСтр("ru = 'Не удалось провести один или несколько документов.'");
			КнопкиДиалога = Новый СписокЗначений;
			
			Если ЕстьДокументыГотовыеДляФормированияЭД Тогда
				ТекстВопроса = ТекстВопроса + " " + НСтр("ru = 'Продолжить?'");
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
			Иначе
				КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
			КонецЕсли;
			ДопПараметры = Новый Структура("ОбработкаПродолжения, ДокументыМассив", ОбработкаПродолжения, ДокументыМассив);
			Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовЗавершить", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(Обработчик, ТекстВопроса, КнопкиДиалога);
		Иначе
			ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
		КонецЕсли;
		Оповестить("ОбновитьСостояниеЭД");
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПроверкуПроведенияДокументовЗавершить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ДокументыМассив = Неопределено;
	
	ОбработкаПродолжения = Неопределено;
	Если Результат = КодВозвратаДиалога.Пропустить
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения) Тогда
		
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;
	
КонецПроцедуры

#Область КомандыЭДО

Процедура КомандыЭДО_ПриОткрытии(Форма) Экспорт

	ПараметрыПриОткрытии = ОбменСКонтрагентамиКлиент.ПараметрыПриОткрытии();
	ПараметрыПриОткрытии.Форма = Форма;
	ПараметрыПриОткрытии.ЕстьОбработчикОбновитьКомандыЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ПараметрыПриОткрытии);

КонецПроцедуры

Процедура КомандыЭДО_ФормаСпискаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт

	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = Форма;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);

КонецПроцедуры

Процедура КомандыЭДО_ФормаЭлементаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт

	Элементы = Форма.Элементы;
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСправочника();
	ПараметрыОповещенияЭДО.Форма                            = Форма;
	ПараметрыОповещенияЭДО.МестоРазмещенияКоманд            = Элементы.КомандыЭДО;
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновитьКомандыЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСправочника(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КонвертацияФайлаВФорматФНС

Процедура ПродолжитьЗагрузкуРеализацииТоваровИУслугXMLИзФайла(РасширениеПодключено,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РасширениеПодключено = Истина Тогда
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр             = "(*.xlsx;*.xls;*.mxl;*.zip)|*.xlsx;*.xls;*.mxl;*.zip";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок          = НСтр("ru='Выберите файл электронного документа'");
		
		Форма = ДополнительныеПараметры.Форма;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПрочитатьЗагруженныеФайлы", ЭтотОбъект, 
			Новый Структура("Форма", Форма));		
		НачатьПомещениеФайлов(ОписаниеОповещения, , ДиалогОткрытияФайла, Истина, Форма.УникальныйИдентификатор); 
		
	Иначе 
		
		ТекстСообщения = НСтр("ru='Расширение для работы с файлами в веб-клиенте не подключено, загрузка поступления остановлена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьТабличныйДокумент(АдресФайла, РасширениеФайла, Форма)
	
	Результат = ЭлектронноеВзаимодействиеБПВызовСервера.ОбработатьТабличныйДокументСервер(АдресФайла, РасширениеФайла, Форма.УникальныйИдентификатор);
	Форма.ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	Форма.АдресХранилища       = Результат.АдресХранилища;
	Если Не Результат.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжидания);
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеКонвертацииФайла", 1, Истина);
		Форма.ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(Форма, Форма.ИдентификаторЗадания);
		
	Иначе
		
		НачатьЗагрузкуЭД(Форма.АдресХранилища, Форма.УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеПоступленияИзЭД

Процедура ЗагрузитьЭД(СтруктураЭД)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СтруктураЭД", СтруктураЭД);
	ОбработчикОповещения = Новый ОписаниеОповещения("СопоставитьПередЗаполнениемОповещение",
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	СписокНеСопоставленнойНоменклатуры = ЭлектронноеВзаимодействиеБПВызовСервера.СписокНеСопоставленнойНоменклатуры(
		СтруктураЭД.Контрагент, СтруктураЭД.ДанныеФайлаРазбора);
		
	Если СписокНеСопоставленнойНоменклатуры.Количество() > 0 Тогда
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьСопоставлениеНоменклатуры(
			СписокНеСопоставленнойНоменклатуры,, ОбработчикОповещения);
	Иначе
		СоздатьДокументИзЭД(СтруктураЭД);
	КонецЕсли;

КонецПроцедуры

Процедура СопоставитьПередЗаполнениемОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	СоздатьДокументИзЭД(ДополнительныеПараметры.СтруктураЭД);
	
КонецПроцедуры

Процедура СоздатьДокументИзЭД(СтруктураЭД)
	
	СсылкаДокумента = ЭлектронноеВзаимодействиеБПВызовСервера.СоздатьДокументИзЭД(СтруктураЭД);
	Если СтруктураЭД.Свойство("НомерСФ") Тогда
		УчетНДСВызовСервера.СоздатьСчетФактуруПолученныйНаОсновании(СсылкаДокумента, СтруктураЭД.НомерСФ, СтруктураЭД.ДатаСФ);
	КонецЕсли;
	ПоказатьЗначение(, СсылкаДокумента);
	Оповестить("ЗагруженДокументПоступления");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти




