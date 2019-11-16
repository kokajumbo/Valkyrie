#Область ПрограммныйИнтерфейс

// Изменяет элемент отбора группы списка.
//
// Параметры:
//   Группа         - ГруппаЭлементовОтбора - Группа, для которой меняется элемент отбора.
//   ИмяПоля        - Строка - Имя поля.
//   ПравоеЗначение - ПроизвольноеЗначение, по умолчанию Неопределено - значение отбора.
//   Установить     - Булево, по умолчанию Ложь - Признак установки отбора
//   ВидСравнения   - ВидСравненияКомпоновкиДанных, по умолчанию Неопределено.
//
Процедура ИзменитьЭлементОтбораГруппыСписка(Группа, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено) Экспорт
	
	УдалитьЭлементОтбораКоллекции(Группа.Элементы, ИмяПоля);
	
	Если Установить Тогда
		УстановитьЭлементОтбораКоллекции(Группа.Элементы, ИмяПоля, ПравоеЗначение, ВидСравнения);
	КонецЕсли;
	
КонецПроцедуры // ИзменитьЭлементОтбораСписка()

// Поиск элемента отбора по представлению.
//
// Параметры:
//   КоллекцияЭлементов - Коллекция элементов, в которой производится поиск.
//   Представление      - Значение поиска.
//   ВидПоиска          - 0 точное совпадение,
//                        1 начинается с переданного значения,
//                        2 вхождение переданного значения в представление.
//
// Возвращаемое значение:
//   Элемент отбора
//
Функция НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление, ВидПоиска = 0) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ВидПоиска = 0 Тогда
			Если ЭлементОтбора.Представление = Представление Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		ИначеЕсли ВидПоиска = 1 Тогда
			Если СтрНайти(ЭлементОтбора.Представление, Представление) = 1 Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		ИначеЕсли ВидПоиска = 2 Тогда
			Если СтрНайти(ЭлементОтбора.Представление, Представление) > 0 Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции // НайтиЭлементОтбораПоПредставлению()

// Создает группу элементов отбора.
// 
// Параметры:
//   КоллекцияЭлементов - Коллекция элементов, в которой будет создана группа.
//   Представление - Строка - Представление группы.
//   ТипГруппы - ТипГруппыЭлементовОтбораКомпоновкиДанных - Тип группы.
//
// Возвращаемое значение:
//   ГруппаЭлементовОтбора
//
Функция СоздатьГруппуЭлементовОтбора(КоллекцияЭлементов, Представление, ТипГруппы) Экспорт
	
	ГруппаЭлементовОтбора = НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление);
	Если ГруппаЭлементовОтбора = Неопределено Тогда
		ГруппаЭлементовОтбора = КоллекцияЭлементов.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	Иначе
		ГруппаЭлементовОтбора.Элементы.Очистить();
	КонецЕсли;
	
	ГруппаЭлементовОтбора.Представление    = Представление;
	ГруппаЭлементовОтбора.Применение       = ТипПримененияОтбораКомпоновкиДанных.Элементы;
	ГруппаЭлементовОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ГруппаЭлементовОтбора.ТипГруппы        = ТипГруппы;
	ГруппаЭлементовОтбора.Использование    = Истина;
	
	Возврат ГруппаЭлементовОтбора;
	
КонецФункции

// Устанавливает элемент отбор динамического списка
//
// Параметры:
//   Список         - обрабатываемый динамический список.
//   ИмяПоля        - имя поля компоновки, отбор по которому нужно установить.
//   ВидСравнения   - вид сравнения отбора, по умолчанию - Равно.
//   ПравоеЗначение - значение отбора.
//
Процедура УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено, Представление = "") Экспорт
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);	
	ЭлементОтбора.ВидСравнения   = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	ЭлементОтбора.Представление  = Представление;
	
КонецПроцедуры 

// Изменяет элемент отбора динамического списка.
//
// Параметры:
// Список         - обрабатываемый динамический список.
// ИмяПоля        - имя поля компоновки, отбор по которому нужно установить.
// ПравоеЗначение - значение отбора, по умолчанию - Неопределено.
// Использование  - признак использования отбора, по умолчанию - Ложь.
// ВидСравнения   - вид сравнения отбора, по умолчанию - Равно.
//
Процедура ИзменитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение = Неопределено, Использование = Ложь, ВидСравнения = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля, 
		ПравоеЗначение, 
		ВидСравнения, 
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ, 
		Использование); 
		
КонецПроцедуры 

// Возвращает элемент пользовательского отбора динамического списка, 
// соответствующий отбору, заданному в конфигураторе с указанным именем.
// Соответствие определяется по совпадению идентификаторов настройки.
//
// Параметры
//  Список - ДинамическийСписок - динамический список, для которого ищется элемент отбора.
//  ИмяОтбора - Строка - имя отбора, заданное в конфигураторе для элемента настроек динамического списка.
//
// Возвращаемое значение:
//	ЭлементОтбораКомпоновкиДанных - найденный элемент пользовательского отбора.
//  Неопределено - если элемент пользовательского отбора не найден.
//
Функция ЭлементОтбораСпискаПоИмени(Список, ИмяОтбора) Экспорт

	Отборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяОтбора);
	
	Если Отборы.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Отборы[0];
	КонецЕсли;
	
КонецФункции

// Устанавливает или изменяет "быстрый" отбор динамического списка (по значениям отбора, указанным в реквизитах формы).
//
// Параметры:
// Форма - УправляемаяФорма - форма, у которой есть реквизит динамический список с именем Список.
// ИмяПоля - Строка - имя отбора, у формы должны быть реквизиты с именами Отбор<ИмяПоля> и Отбор<ИмяПоля>Использование.
//
Процедура УстановитьБыстрыйОтбор(Форма, ИмяПоля, ВидСравнения = Неопределено) Экспорт
	
	ПравоеЗначение = Форма["Отбор" + ИмяПоля];
	Использование  = Форма["Отбор" + ИмяПоля + "Использование"];
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Форма.Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Форма.Список.КомпоновщикНастроек.Настройки.Отбор,
		ИмяПоля,
		ПравоеЗначение,
		ВидСравнения,
		,
		Использование);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЭлементОтбораКоллекции(КоллекцияЭлементов, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено)
	
	ЭлементОтбора = КоллекцияЭлементов.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ЭлементОтбора.ВидСравнения     = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = ПравоеЗначение;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
КонецПроцедуры // УстановитьЭлементОтбораКоллекции()

Процедура УдалитьЭлементОтбораКоллекции(КоллекцияЭлементов, ИмяПоля)
	
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			КоллекцияЭлементов.Удалить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // УдалитьЭлементОтбораКоллекции()

#КонецОбласти