
#Область СлужебныеПроцедурыИФункции

Процедура ЭлементИндикацииПриАктивизацииЯчейки(Форма, Элемент) Экспорт
	ТекущаяЯчейка = Элемент.ТекущийЭлемент;
	
	Если ТекущаяЯчейка = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ОписаниеЭлемента = Форма.ОписаниеЭлементовСИндикациейОшибок.Получить(ТекущаяЯчейка.Имя);
	
	Если ОписаниеЭлемента = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	КоличествоПодчиненныхЭлементов = Элемент.ПодчиненныеЭлементы.Количество();
	
	АктивируемыйЭлемент = ЗарплатаКадрыОтображениеОшибокКлиентСервер.АктивныйЭлементВТаблицеСодержащейГиперссылку(Элемент, ТекущаяЯчейка);
		
	Если АктивируемыйЭлемент <> Неопределено Тогда
		Элемент.ТекущийЭлемент = АктивируемыйЭлемент;
	КонецЕсли;		
	
	Если Форма.ТекущийЭлемент = Элемент Тогда
		ПоказатьТекстОшибки(Форма, ОписаниеЭлемента);
	КонецЕсли;	
КонецПроцедуры

Процедура ЭлементИндикацииОшибкиНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	ОписаниеЭлемента = Форма.ОписаниеЭлементовСИндикациейОшибок.Получить(Элемент.Имя);
	
	Если ОписаниеЭлемента = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	ПоказатьТекстОшибки(Форма, ОписаниеЭлемента);
КонецПроцедуры

Процедура ПоказатьТекстОшибки(Форма, ОписаниеЭлемента)
	Если ОписаниеЭлемента.Тип = "ОписаниеЭлементаСИндикациейОшибокВСтрокеТаблицы"
		Или ОписаниеЭлемента.Тип = "ОписаниеЭлементаСИндикациейОшибокВСтрокеТаблицы" Тогда
		
		ДанныеСодержащиеОшибки = Форма.Элементы[ОписаниеЭлемента.ИмяЭлементаТаблица].ТекущиеДанные;
		ИмяРеквизитаСОшибкой = ОписаниеЭлемента.ИмяРеквизитаТаблицы;
	Иначе
		ДанныеСодержащиеОшибки = Форма;	
		ИмяРеквизитаСОшибкой = ОписаниеЭлемента.ПутьКДаннымФормыСодержащимОшибку;
	КонецЕсли;	
	
	Если ДанныеСодержащиеОшибки = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ОписаниеОшибок = ЗарплатаКадрыОтображениеОшибокКлиентСервер.ОписаниеОшибокИзДанныхФормы(ДанныеСодержащиеОшибки, ИмяРеквизитаСОшибкой, ОписаниеЭлемента.ОтображатьНепривязанныеОшибки);
	
	Если ОписаниеОшибок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ТекстОшибки = "";
	
	Для Каждого Ошибка Из ОписаниеОшибок Цикл
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + Ошибка.Текст;	
	КонецЦикла;	
	
	ТекстОшибки = Сред(ТекстОшибки, 2);
	
	ПоказатьПредупреждение(, ТекстОшибки);
КонецПроцедуры	

Процедура ПриИзмененииДанныхВЭлементеСФлагомИндикацииОшибок(Форма, Элемент, ПутьКДанным) Экспорт 
	СчетчикФлаговНаСтраницах = Новый Структура(Форма.СчетчикФлаговНаСтраницах);
	
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УстановитьФлагНаличияОшибки(
		Форма,
		ПутьКДанным,
		Ложь,
		0,
		Истина,
		СчетчикФлаговНаСтраницах);
		
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным);	
		
	Форма.СчетчикФлаговНаСтраницах = Новый ФиксированнаяСтруктура(СчетчикФлаговНаСтраницах);
		
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УстановитьКартинкиДляЗаголовковСтраницФормы(Форма);	
КонецПроцедуры

Процедура ПриОкончанииРедактированияСтрокиТаблицыСИндикациейОшибок(Форма, Элемент, НоваяСтрока, ПутьКДаннымТаблицы) Экспорт 
	Если НоваяСтрока Тогда
		Возврат;
	КонецЕсли;	
	
	СчетчикФлаговНаСтраницах = Новый Структура(Форма.СчетчикФлаговНаСтраницах);
	
	Таблица = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДаннымТаблицы);
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	
	ИндексТекущейСтроки = Таблица.Индекс(ТекущаяСтрока);
	
	ПутьКДанным = ПутьКДаннымТаблицы + "[" + ЗарплатаКадрыОтображениеОшибокКлиентСервер.ИндексСтрокой(ИндексТекущейСтроки) + "]";
	
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УстановитьФлагНаличияОшибки(
		Форма,
		ПутьКДанным,
		Ложь,
		0,
		Истина,
		СчетчикФлаговНаСтраницах);
		
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным + ".*");	
		
	Форма.СчетчикФлаговНаСтраницах = Новый ФиксированнаяСтруктура(СчетчикФлаговНаСтраницах);
		
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УстановитьКартинкиДляЗаголовковСтраницФормы(Форма);	
		
КонецПроцедуры

Процедура ПередУдалениемСтрокиТаблицыСИндикациейОшибок(Форма, Элемент, ПутьКДаннымТаблицы) Экспорт 
	СчетчикФлаговНаСтраницах = Новый Структура(Форма.СчетчикФлаговНаСтраницах);
	
	Таблица = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДаннымТаблицы);
	
	Для Каждого ИдентификаторСтроки Из Элемент.ВыделенныеСтроки Цикл 
		ТекущаяСтрока = Таблица.НайтиПоИдентификатору(ИдентификаторСтроки);
	
		ИндексТекущейСтроки = Таблица.Индекс(ТекущаяСтрока);
		
		ПутьКДанным = ПутьКДаннымТаблицы + "[" + ЗарплатаКадрыОтображениеОшибокКлиентСервер.ИндексСтрокой(ИндексТекущейСтроки) + "]";
		
		ЗарплатаКадрыОтображениеОшибокКлиентСервер.УстановитьФлагНаличияОшибки(
			Форма,
			ПутьКДанным,
			Ложь,
			0,
			Истина,
			СчетчикФлаговНаСтраницах);
			
		ЗарплатаКадрыОтображениеОшибокКлиентСервер.УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным + ".*");	
	КонецЦикла;
		
	Форма.СчетчикФлаговНаСтраницах = Новый ФиксированнаяСтруктура(СчетчикФлаговНаСтраницах);
		
	ЗарплатаКадрыОтображениеОшибокКлиентСервер.УстановитьКартинкиДляЗаголовковСтраницФормы(Форма);		
КонецПроцедуры

#КонецОбласти
