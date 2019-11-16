&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Процедура УстановитьЗначениеСтрокиРодителя(ВеткаРодителя, ТаблицаПравилВыгрузки)
	
	Если ВеткаРодителя.Родитель <> Неопределено Тогда
		УстановитьЗначениеСтрокиРодителя(ВеткаРодителя.Родитель, ТаблицаПравилВыгрузки);
	КонецЕсли;

	НайденыВключенные	= Ложь;
	НайденыВыключенные	= Ложь;

	Для Каждого СтрокаДерева ИЗ ВеткаРодителя.Строки Цикл		
		
		Если СтрокаДерева.Включить = 0 Тогда
			НайденыВыключенные	= Истина;
		ИначеЕсли СтрокаДерева.Включить = 1 Тогда
			НайденыВключенные	= Истина;
		ИначеЕсли СтрокаДерева.Включить = 2 Тогда
			НайденыВыключенные	= Истина;
			НайденыВключенные	= Истина;
		КонецЕсли; 
		
		Если НайденыВключенные И НайденыВыключенные Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НайденыВключенные И НайденыВыключенные Тогда
		Включить = 2;
	ИначеЕсли НайденыВключенные И (Не НайденыВыключенные) Тогда
		Включить = 1;
	ИначеЕсли (Не НайденыВключенные) И НайденыВыключенные Тогда
		Включить = 0;
	ИначеЕсли (Не НайденыВключенные) И (Не НайденыВыключенные) Тогда
		Включить = 2;
	КонецЕсли;
	
	ВеткаРодителя.Включить = Включить;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОшибкуВЖурнал(ТекстСообщения)

	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка данных в ЗУП'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Ошибка,,, 
		ТекстСообщения);

КонецПроцедуры

&НаКлиенте
Процедура ВыборФайла(Элемент)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр                      = "Файл данных (*.xml)|*.xml";
	ДиалогВыбораФайла.Заголовок                   = "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр     = Ложь;
	ДиалогВыбораФайла.МножественныйВыбор          = Ложь;
	ДиалогВыбораФайла.Расширение                  ="xml";
	ДиалогВыбораФайла.ИндексФильтра               = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла              = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Объект.ИмяФайлаДанных = ВыбранныеФайлы[0];
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкиПодчиненных(ИмяПравила)
    
	ТаблицаПравилВыгрузки = ДанныеФормыВЗначение(Объект.ТаблицаПравилВыгрузки, Тип("ДеревоЗначений"));
	
	ПараметрыОтбора = Новый Структура("Имя", ИмяПравила);
	РедактируемыеСтроки = ТаблицаПравилВыгрузки.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	
	Для Каждого РедактируемаяСтрока ИЗ РедактируемыеСтроки Цикл
		Если РедактируемаяСтрока <> Неопределено Тогда
			Обработки.ВыгрузкаДанныхВЗУП.УстановитьЗначениеСтрокиДерева(РедактируемаяСтрока.Строки, ТаблицаПравилВыгрузки, РедактируемаяСтрока.Включить);
		КонецЕсли;		
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ТаблицаПравилВыгрузки, Объект.ТаблицаПравилВыгрузки);

КонецПроцедуры

&НаСервере
Процедура УстановитьПометкиРодителей(ИмяПравила)
	
	ТаблицаПравилВыгрузки = ДанныеФормыВЗначение(Объект.ТаблицаПравилВыгрузки, Тип("ДеревоЗначений"));
	
	ПараметрыОтбора = Новый Структура("Имя", ИмяПравила);
	РедактируемыеСтроки = ТаблицаПравилВыгрузки.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	
	Для Каждого РедактируемаяСтрока ИЗ РедактируемыеСтроки Цикл
		Если РедактируемаяСтрока <> Неопределено Тогда
			Если РедактируемаяСтрока.Родитель <> Неопределено Тогда
				УстановитьЗначениеСтрокиРодителя(РедактируемаяСтрока.Родитель, ТаблицаПравилВыгрузки);
			КонецЕсли;
		КонецЕсли;		
	КонецЦикла;

	ЗначениеВДанныеФормы(ТаблицаПравилВыгрузки, Объект.ТаблицаПравилВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСернутьВетки(Коллекция, УстановитьПоУмолчанию = Ложь)
	
	Если НЕ УстановитьПоУмолчанию Тогда
		Для Каждого Строка ИЗ Коллекция Цикл
			Если Строка.ВеткаРазвернута Тогда
				Элементы.ТаблицаПравилВыгрузки.Развернуть(Строка.ПолучитьИдентификатор());
				ПодКоллекция = Строка.ПолучитьЭлементы();
				РазвернутьСернутьВетки(ПодКоллекция);		
			КонецЕсли;		
		КонецЦикла;
	Иначе
		Для Каждого Строка ИЗ Коллекция Цикл
			Строка.ВеткаРазвернута = Ложь;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СнятьУстановитьВсеФлажки(Включить)
    
	ТаблицаПравилВыгрузки = ДанныеФормыВЗначение(Объект.ТаблицаПравилВыгрузки, Тип("ДеревоЗначений"));
	
	Для Каждого РедактируемаяСтрока ИЗ ТаблицаПравилВыгрузки.Строки Цикл
		РедактируемаяСтрока.Включить = Включить;
		Обработки.ВыгрузкаДанныхВЗУП.УстановитьЗначениеСтрокиДерева(РедактируемаяСтрока.Строки, ТаблицаПравилВыгрузки, Включить);		
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ТаблицаПравилВыгрузки, Объект.ТаблицаПравилВыгрузки);

КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				СохранитьФайл();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат()
		
	ФайлДанных = Неопределено;
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат.Свойство("ДвоичныеДанные", ФайлДанных);
	АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ФайлДанных, УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Результат.Сообщение) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.Сообщение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьВыгрузкуДанныхНаСервере()
	
	ТаблицаПравилВыгрузки = ДанныеФормыВЗначение(Объект.ТаблицаПравилВыгрузки, Тип("ДеревоЗначений"));
	ПараметрыВыгрузки = Новый Структура("ТаблицаПравилВыгрузки,УникальныйИдентификатор", ТаблицаПравилВыгрузки, УникальныйИдентификатор);
		
	НаименованиеЗадания = НСтр("ru = 'Выгрузка данных в ЗУП'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.ВыгрузкаДанныхВЗУП.ВыгрузитьДанные", 
		ПараметрыВыгрузки, 
		НаименованиеЗадания);
		
	АдресХранилища = Результат.АдресХранилища;	
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура СохранитьФайл()
	
	Если АдресФайлаВоВременномХранилище <> Неопределено Тогда
		
		Если ВозможностьВыбораФайлов Тогда
			
			ПередаваемыеФайлы = Новый Массив;
			
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Объект.ИмяФайлаДанных, АдресФайлаВоВременномХранилище);
			ПередаваемыеФайлы.Добавить(ОписаниеФайла);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлЗавершение", ЭтотОбъект);
			НачатьПолучениеФайлов(ОписаниеОповещения, ПередаваемыеФайлы, Объект.ИмяФайлаДанных, Ложь);
			
		Иначе
			
			Попытка
				
				ПолучитьФайл(АдресФайлаВоВременномХранилище, "acc_to_hrm.xml", Истина);
				
			Исключение
				ШаблонСообщения = НСтр("ru = 'При записи файла возникла ошибка
				|%1'");
				
				ТекстСообщения = СтрШаблон(ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				
				ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписатьОшибкуВЖурнал(ТекстСообщения);
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Данные успешно выгружены'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайлами() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = РасширениеРаботыСФайламиПодключено;
	Элементы.ИмяФайлаДанных.Видимость = ВозможностьВыбораФайлов;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ОчиститьСообщения();
	
	АдресФайлаВоВременномХранилище = Неопределено;	
		
	Если ВозможностьВыбораФайлов Тогда
		//	Вариант для установленного расширения для работы с файлами
		Если НЕ ЗначениеЗаполнено(Объект.ИмяФайлаДанных) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Не указан файл данных для выгрузки'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Результат = ВыполнитьВыгрузкуДанныхНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		СохранитьФайл();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура КнопкаСнятьФлажки(Команда)
	
	СнятьУстановитьВсеФлажки(0);
	Коллекция = Объект.ТаблицаПравилВыгрузки.ПолучитьЭлементы();
	РазвернутьСернутьВетки(Коллекция);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаУстановитьФлажки(Команда)
	
	СнятьУстановитьВсеФлажки(1);
	Коллекция = Объект.ТаблицаПравилВыгрузки.ПолучитьЭлементы();
	РазвернутьСернутьВетки(Коллекция);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

&НаКлиенте
Процедура ТаблицаПравилВыгрузкиВключитьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаПравилВыгрузки.ТекущиеДанные;
	ТекущаяСтрока = Элементы.ТаблицаПравилВыгрузки.ТекущаяСтрока;
			
	Если ТекущиеДанные.Включить = 2 Тогда
		ТекущиеДанные.Включить = 0;
	КонецЕсли;
	
	ИмяПравила = ТекущиеДанные.Имя;
	
	УстановитьПометкиПодчиненных(ИмяПравила);
	УстановитьПометкиРодителей(ИмяПравила);
	
	Коллекция = Объект.ТаблицаПравилВыгрузки.ПолучитьЭлементы();
	РазвернутьСернутьВетки(Коллекция);	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПравилВыгрузкиПередРазворачиванием(Элемент, Строка, Отказ)
	
	ТекущиеДанные = Элементы.ТаблицаПравилВыгрузки.ДанныеСтроки(Строка);
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.ВеткаРазвернута = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПравилВыгрузкиПередСворачиванием(Элемент, Строка, Отказ)
	
	ТекущиеДанные = Элементы.ТаблицаПравилВыгрузки.ДанныеСтроки(Строка);
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.ВеткаРазвернута = Ложь;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстПравил = Обработки.ВыгрузкаДанныхВЗУП.ПолучитьМакет("ПравилаОбмена");
	
	УниверсальнаяВыгрузкаДанных = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	УниверсальнаяВыгрузкаДанных.ЗагрузитьПравилаОбмена(ТекстПравил.ПолучитьТекст(), "Строка");
	ЗначениеВДанныеФормы(УниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки, Объект.ТаблицаПравилВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Коллекция = Объект.ТаблицаПравилВыгрузки.ПолучитьЭлементы();
	РазвернутьСернутьВетки(Коллекция, Истина);
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ПодключениеРасширенияРаботыСФайлами", 0.1, Истина);
	#Иначе
		ЭтаФорма.ВозможностьВыбораФайлов = Истина;
	#КонецЕсли
	
КонецПроцедуры
