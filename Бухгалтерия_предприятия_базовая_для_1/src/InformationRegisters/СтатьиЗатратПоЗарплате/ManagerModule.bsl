#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет регистр данными по умолчанию при создании статей затрат по зарплате.
//
// Параметры:
//  СтатьяОплатаТруда		 - СправочникСсылка.СтатьиЗатрат - статья затрат для учета оплаты труда.
//                             К этой статье затрат будут привязаны остальные ("дополнительные") статьи.
//  СтатьяСтраховыеВзносы	 - СправочникСсылка.СтатьиЗатрат - статья затрат в виде страховых взносов.
//                             См. также Перечисление.ВидыДополнительныхСтатейЗатрат
//  СтатьяФСС_НС			 - СправочникСсылка.СтатьиЗатрат - статья затрат в виде взносов на страхование ФСС
//  СтатьяОплатаБольничного	 - СправочникСсылка.СтатьиЗатрат - статья затрат в виде расходов на оплату больничного, не возмещаемых ФСС
//
Процедура ЗаполнитьПоУмолчанию(СтатьяОплатаТруда, СтатьяСтраховыеВзносы, СтатьяФСС_НС, СтатьяОплатаБольничного) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// Поставляемые данные не следует создавать в подчиненных узлах РИБ
		Возврат;
	КонецЕсли;
	
	// Настройка применяется по принципу "правило - исключения".
	// Правило задается для пустой ссылки, исключения - для конкретных статей оплаты труда.
	//
	// В то же время, интерфейсно настройка отображается иначе: "от статей затрат".
	// То есть, пользователь может не увидеть "правило", видит только "исключения".
	//
	// Поэтому при заполнении по умолчанию приходится добавить
	// - и правило - оно сработает по факту для всех тех статей,
	//   для которых не указано исключение
	// - и первое исключение, для статьи по умолчанию, совпадающее с правилом - для поддержания интерфейсной особенности.
	СтатьиЗатратНачисления = Новый Массив;
	СтатьиЗатратНачисления.Добавить(Справочники.СтатьиЗатрат.ПустаяСсылка());
	СтатьиЗатратНачисления.Добавить(СтатьяОплатаТруда);
	
	СтатьиЗатратВзносов = Новый Соответствие;
	СтатьиЗатратВзносов.Вставить(Перечисления.ВидыДополнительныхСтатейЗатрат.СтраховыеВзносы,           СтатьяСтраховыеВзносы);
	СтатьиЗатратВзносов.Вставить(Перечисления.ВидыДополнительныхСтатейЗатрат.ФСС_НС,                    СтатьяФСС_НС);
	СтатьиЗатратВзносов.Вставить(Перечисления.ВидыДополнительныхСтатейЗатрат.ПособияЗаСчетРаботодателя, СтатьяОплатаБольничного);
	
	Для Каждого СтатьяЗатратНачисления Из СтатьиЗатратНачисления Цикл
		
		НаборЗаписей = РегистрыСведений.СтатьиЗатратПоЗарплате.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СтатьяЗатратНачисления.Установить(СтатьяЗатратНачисления);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтатьяЗатратВзносов Из СтатьиЗатратВзносов Цикл
			
			Запись = НаборЗаписей.Добавить();
			Запись.СтатьяЗатратНачисления = СтатьяЗатратНачисления;
			Запись.ВидСтатьиЗатрат        = СтатьяЗатратВзносов.Ключ;
			Запись.СтатьяЗатрат           = СтатьяЗатратВзносов.Значение;
			
		КонецЦикла;
		
		ШаблонТекстаОшибкиЗаписи = НСтр(
			"ru = 'Не выполнена настройка статей затрат по страховым взносам.
			|%1'",
			Метаданные.ОсновнойЯзык.КодЯзыка);
		
		Попытка
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей, Истина, Истина);
			
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = СтрШаблон(
				ШаблонТекстаОшибкиЗаписи,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.СтатьиЗатратПоЗарплате,
				,// Данные
				ТекстОшибки);
				
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет статью затрат, используемую по умолчанию для конкретной задачи
//
// Параметры:
//  ВидСтатьиЗатрат        - ПеречислениеСсылка.ВидыДополнительныхСтатейЗатрат - назначение запрошенной статьи
//  РежимНалогообложения 
//          - ПеречислениеСсылка.ВидыДеятельностиДляНалоговогоУчетаЗатрат - режим налогообложения,
//                         в рамках которого применяется набор статей.
//          - Неопределено - режим налогообложения по умолчанию
// 
// Возвращаемое значение:
//  СправочникСсылка.СтатьиЗатрат - статья затрат, используемая по умолчанию для конкретной задачи.
//
Функция ОсновнаяСтатьяЗатрат(ВидСтатьиЗатрат, РежимНалогообложения = Неопределено) Экспорт
	
	Если РежимНалогообложения = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения Тогда
		СтатьяЗатратОплатаТруда = Справочники.СтатьиЗатрат.СтатьяЗатратПоНазначению("ОплатаТрудаЕНВД");
	Иначе
		СтатьяЗатратОплатаТруда = Справочники.СтатьиЗатрат.СтатьяЗатратПоНазначению("ОплатаТруда");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтатьяЗатратОплатаТруда) Тогда
		Возврат Справочники.СтатьиЗатрат.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидСтатьиЗатрат",         ВидСтатьиЗатрат);
	Запрос.УстановитьПараметр("СтатьяЗатратОплатаТруда", СтатьяЗатратОплатаТруда);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтатьиЗатратПоЗарплате.СтатьяЗатрат КАК СтатьяЗатрат,
	|	МАКСИМУМ(СтатьиЗатратПоЗарплате.СтатьяЗатрат = &СтатьяЗатратОплатаТруда) КАК Основная,
	|	КОЛИЧЕСТВО(*) КАК КоличествоНастроек
	|ИЗ
	|	РегистрСведений.СтатьиЗатратПоЗарплате КАК СтатьиЗатратПоЗарплате
	|ГДЕ
	|	СтатьиЗатратПоЗарплате.ВидСтатьиЗатрат = &ВидСтатьиЗатрат
	|	И СтатьиЗатратПоЗарплате.СтатьяЗатрат ССЫЛКА Справочник.СтатьиЗатрат
	|
	|СГРУППИРОВАТЬ ПО
	|	СтатьиЗатратПоЗарплате.СтатьяЗатрат
	|
	|УПОРЯДОЧИТЬ ПО
	|	Основная УБЫВ,
	|	КоличествоНастроек УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтатьяЗатрат;
	Иначе
		Возврат Справочники.СтатьиЗатрат.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
