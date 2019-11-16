#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);

	Если ЗначениеЗаполнено(Склад) Тогда
		ОтветственноеЛицо = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(Склад, Дата);
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата 		  = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУчет");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	Для каждого Строка Из Товары Цикл
		
		Префикс = "Товары[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Товары'");
		
		Если Строка.Количество = 0 И Строка.КоличествоУчет = 0 Тогда
			
			ИмяПоля = НСтр("ru = 'Количество'");
			Поле = Префикс + "Количество";
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
			ИмяПоля = НСтр("ru = 'Количество учетное'");
			Поле = Префикс + "КоличествоУчет";
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

#КонецЕсли
