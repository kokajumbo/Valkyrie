#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет поддерживаемый набор суммовых показателей справки-расчета.
// См. соответствующие методы модулей подсистемы СправкиРасчеты.
// Справка-расчет должна поддерживать хотя бы один набор.
// Если поддерживается несколько наборов, то конкретный набор выбирается в форме
// и передается через свойство отчета НаборПоказателейОтчета.
//
// Возвращаемое значение:
//  Массив - номера наборов суммовых показателей.
//
Функция ПоддерживаемыеНаборыСуммовыхПоказателей() Экспорт
	
	Возврат СправкиРасчетыКлиентСервер.ВсеНаборыСуммовыхПоказателей();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт 
	
	Возврат СправкиРасчеты.ЗаголовокОтчета(Контекст);
	
КонецФункции

Процедура ПриВыводеЗаголовка(Контекст, КомпоновщикНастроек, Результат) Экспорт
	
	СправкиРасчеты.ВывестиШапкуОтчета(Результат, Контекст);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	СправкиРасчеты.ОформитьРезультатОтчета(Результат, Контекст);
	
КонецПроцедуры

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Ложь);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	
	Возврат Результат;
	
КонецФункции

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ПараметрыОтчета.НачалоПериода);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйУчет", ПараметрыОтчета.ПоказательНУ);
	
	БазаРаспределенияКосвенныхРасходовПоВидамДеятельности = УчетнаяПолитика.БазаРаспределенияКосвенныхРасходовПоВидамДеятельности(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	Если ЗначениеЗаполнено(БазаРаспределенияКосвенныхРасходовПоВидамДеятельности) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"УчитыватьВсеДоходы", 
			БазаРаспределенияКосвенныхРасходовПоВидамДеятельности = 
				Перечисления.БазыРаспределенияКосвенныхРасходовПоВидамДеятельности.ДоходыОтРеализацииИВнереализационные);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"УчитыватьВсеДоходы",Истина);
	КонецЕсли;
	
	ИспользуетсяЕНВД = Константы.ИспользуетсяЕНВД.Получить();
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"ИспользуетсяЕНВД",ИспользуетсяЕНВД);
	ПараметрыОтчета.Вставить("ИспользуетсяЕНВД",ИспользуетсяЕНВД);
	
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
	МассивПоказателей.Добавить("ПР");
	МассивПоказателей.Добавить("ВР");
	
	Группировка = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ВидДеятельности");
	
	ГруппировкаСписаниеКосвенныхРасходов = НайтиПоИмени(Группировка.Структура,"СписаниеКосвенныхРасходов");
	ГруппировкаСписаниеКосвенныхРасходовРаспределяемые = НайтиПоИмени(Группировка.Структура,"СписаниеКосвенныхРасходовРаспределяемые");
	
	Таблица = НайтиПоИмени(ГруппировкаСписаниеКосвенныхРасходов.Структура,"Таблица");
	ТаблицаРаспределяемые = НайтиПоИмени(ГруппировкаСписаниеКосвенныхРасходовРаспределяемые.Структура,"ТаблицаРаспределяемые");
	
	Если ПараметрыОтчета.ПоказательВР Тогда 
		ГруппировкаПериод 	= НайтиПоИмени(Таблица.Строки,"ПериодСРазницами");
		ГруппировкаПериодРаспределяемые 	= НайтиПоИмени(ТаблицаРаспределяемые.Строки,"ПериодРаспределяемыеСРазницами");
	Иначе
		ГруппировкаПериод 	= НайтиПоИмени(Таблица.Строки,"Период");
		ГруппировкаПериодРаспределяемые 	= НайтиПоИмени(ТаблицаРаспределяемые.Строки,"ПериодРаспределяемые");
	КонецЕсли;
	
	ГруппировкаПериод.Использование = Истина;
	ГруппировкаПериодРаспределяемые.Использование = Истина;
	
	ГруппировкаСтатьяЗатрат = НайтиПоИмени(ГруппировкаПериод.Структура,"Группировка");
	ГруппировкаСтатьяЗатратРаспределяемые = НайтиПоИмени(ГруппировкаПериодРаспределяемые.Структура,"ГруппировкаРаспределяемые");
	
	ОтборГруппировки = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаСписаниеКосвенныхРасходов = ГруппировкаСписаниеКосвенныхРасходов.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаСписаниеКосвенныхРасходов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаСписаниеКосвенныхРасходовРаспределяемые = ГруппировкаСписаниеКосвенныхРасходовРаспределяемые.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаСписаниеКосвенныхРасходовРаспределяемые.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаПериод = ГруппировкаПериод.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаПериод.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаПериодРаспределяемые = ГруппировкаПериодРаспределяемые.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаПериодРаспределяемые.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаСтатьяЗатрат = ГруппировкаСтатьяЗатрат.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаСтатьяЗатрат.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборГруппировкаСтатьяЗатратРаспределяемые = ГруппировкаСтатьяЗатратРаспределяемые.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировкаСтатьяЗатратРаспределяемые.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	//Показатели группировки по периоду
	ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Если ПараметрыОтчета.ПоказательВР Тогда 
		Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ГруппировкаПериодПоказатели 						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппировкаПериодПоказатели.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
	КонецЕсли;	
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодСумма						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодСуммаСписано			 	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		
	ГруппировкаПериодСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодСуммаСписано.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Распределяемые
	ГруппировкаПериодРаспределяемые.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Если ПараметрыОтчета.ПоказательВР Тогда 
		Группа = ГруппировкаПериодРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ГруппировкаПериодПоказателиРаспределяемые 						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппировкаПериодПоказателиРаспределяемые.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
	КонецЕсли;	
	
	Группа = ГруппировкаПериодРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодРаспеделяемыеСумма						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериодРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодРаспеделяемыеСуммаСписаноННП			 	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаПериодРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаПериодРаспеделяемыеСуммаСписаноНеННП			 	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	ГруппировкаПериодРаспеделяемыеСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодРаспеделяемыеСуммаСписаноННП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаПериодРаспеделяемыеСуммаСписаноНеННП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	//Показатели группировки по статье затрат
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатрат.Выбор,"СчетУчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатрат.Выбор,"СтатьяЗатрат");
	
	Если ПараметрыОтчета.ПоказательВР Тогда 
		Группа = ГруппировкаСтатьяЗатрат.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ГруппировкаСтатьяЗатратПоказатели 						= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппировкаСтатьяЗатратПоказатели.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
	КонецЕсли;	
		
	Группа = ГруппировкаСтатьяЗатрат.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаСтатьяЗатратСумма 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаСтатьяЗатрат.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаСтатьяЗатратСуммаСписано		 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		
	ГруппировкаСтатьяЗатратСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаСтатьяЗатратСуммаСписано.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;	
	
	//Распределяемые
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратРаспределяемые.Выбор,"СчетУчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратРаспределяемые.Выбор,"СтатьяЗатрат");
	
	Если ПараметрыОтчета.ПоказательВР Тогда 
		Группа = ГруппировкаСтатьяЗатратРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ГруппировкаСтатьяЗатратПоказателиРаспределяемые 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппировкаСтатьяЗатратПоказателиРаспределяемые.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
	КонецЕсли;	
		
	Группа = ГруппировкаСтатьяЗатратРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаСтатьяЗатратРаспеделяемыеСумма 					= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаСтатьяЗатратРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаСтатьяЗатратРаспеделяемыеСуммаСписаноННП		 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	Группа = ГруппировкаСтатьяЗатратРаспределяемые.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	ГруппировкаСтатьяЗатратРаспеделяемыеСуммаСписаноНеННП		 			= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	ГруппировкаСтатьяЗатратРаспеделяемыеСумма.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппировкаСтатьяЗатратРаспеделяемыеСуммаСписаноННП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;	
	ГруппировкаСтатьяЗатратРаспеделяемыеСуммаСписаноНеННП.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;	
	
	//Добавляем показатели в группы
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
						
			//Показатели группировки по периоду
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодСумма, "Ресурсы.СуммаЗатрат" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодСуммаСписано, "Ресурсы.СуммаРасходов" + ИмяПоказателя);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодРаспеделяемыеСумма, "Ресурсы.СуммаЗатрат" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодРаспеделяемыеСуммаСписаноННП, "Ресурсы.СуммаРасходовННП" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодРаспеделяемыеСуммаСписаноНеННП, "Ресурсы.СуммаРасходовНеННП" + ИмяПоказателя);
			
			//Показатели группировки по статье затрат
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратСумма, "Ресурсы.СуммаЗатрат" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратСуммаСписано, "Ресурсы.СуммаРасходов" + ИмяПоказателя);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратРаспеделяемыеСумма, "Ресурсы.СуммаЗатрат" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратРаспеделяемыеСуммаСписаноННП, "Ресурсы.СуммаРасходовННП" + ИмяПоказателя);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратРаспеделяемыеСуммаСписаноНеННП, "Ресурсы.СуммаРасходовНеННП" + ИмяПоказателя);
			
			//Отборы
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериод, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаПериодРаспределяемые, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаСтатьяЗатрат, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаСтатьяЗатратРаспределяемые, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаСписаниеКосвенныхРасходовРаспределяемые, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкаСписаниеКосвенныхРасходов, "Ресурсы.СуммаЗатрат" + ИмяПоказателя,0,ВидСравненияКомпоновкиДанных.НеРавно);
			
			//Показатели
			Если ПараметрыОтчета.ПоказательВР Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодПоказатели, "Показатели." + ИмяПоказателя);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратПоказатели, "Показатели." + ИмяПоказателя);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПериодПоказателиРаспределяемые, "Показатели." + ИмяПоказателя);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаСтатьяЗатратПоказателиРаспределяемые, "Показатели." + ИмяПоказателя);
			КонецЕсли;	
			
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ИтогиГруппировкиСписаниеКосвенныхРасходов 				= МакетКомпоновки.Тело[0].Тело[1].Тело[1].Строки[0].Тело[2];
	ИтогиГруппировкиСписаниеКосвенныхРасходовРаспределяемые = МакетКомпоновки.Тело[0].Тело[2].Тело[1].Строки[0].Тело[2];
	ИтогиТаблицаПоВыручке 									= МакетКомпоновки.Тело[0].Тело[3].Тело[1].Строки[0].Тело[1];
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Двойная,1);

	МакетИтоговГруппировкиСписаниеКосвенныхРасходов 				= МакетКомпоновки.Макеты[МакетКомпоновки.Тело[0].Тело[1].Тело[1].Строки[0].МакетПодвала.Макет];
	МакетИтоговГруппировкиСписаниеКосвенныхРасходовРаспределяемые 	= МакетКомпоновки.Макеты[МакетКомпоновки.Тело[0].Тело[2].Тело[1].Строки[0].МакетПодвала.Макет];
	МакетИтоговТаблицаПоВыручке 									= МакетКомпоновки.Макеты[МакетКомпоновки.Тело[0].Тело[3].Тело[1].Строки[0].МакетПодвала.Макет];
	
	Для ИндексЯчейки = 0 По МакетИтоговГруппировкиСписаниеКосвенныхРасходов.Макет[0].Ячейки.Количество() - 1 Цикл
		МакетИтоговГруппировкиСписаниеКосвенныхРасходов.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Значение = Линия;
		МакетИтоговГруппировкиСписаниеКосвенныхРасходов.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Использование = Истина;
	КонецЦикла;
	
	Для ИндексЯчейки = 0 По МакетИтоговГруппировкиСписаниеКосвенныхРасходовРаспределяемые.Макет[0].Ячейки.Количество() - 1 Цикл
		МакетИтоговГруппировкиСписаниеКосвенныхРасходовРаспределяемые.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Значение = Линия;
		МакетИтоговГруппировкиСписаниеКосвенныхРасходовРаспределяемые.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Использование = Истина;
	КонецЦикла;
	
	Для ИндексЯчейки = 0 По МакетИтоговТаблицаПоВыручке.Макет[0].Ячейки.Количество() - 1 Цикл
		МакетИтоговТаблицаПоВыручке.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Значение = Линия;
		МакетИтоговТаблицаПоВыручке.Макет[0].Ячейки[ИндексЯчейки].Оформление.Элементы[3].ЗначенияВложенныхПараметров[1].Использование = Истина;
	КонецЦикла;
	
	МакетКомпоновки.Тело[0].Тело[1].Тело[1].Строки[0].Тело.Удалить(ИтогиГруппировкиСписаниеКосвенныхРасходов);
	МакетКомпоновки.Тело[0].Тело[2].Тело[1].Строки[0].Тело.Удалить(ИтогиГруппировкиСписаниеКосвенныхРасходовРаспределяемые);
	МакетКомпоновки.Тело[0].Тело[3].Тело[1].Строки[0].Тело.Удалить(ИтогиТаблицаПоВыручке);
	
	Если ПараметрыОтчета.Свойство("ИспользуетсяЕНВД") и Не ПараметрыОтчета.ИспользуетсяЕНВД Тогда
		МакетКомпоновки.Тело[0].Тело.Удалить(МакетКомпоновки.Тело[0].Тело[0]);
	КонецЕсли;	
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","СправкаРасчетСписанияКосвенныхРасходов", "Списание косвенных расходов"));
	
	Возврат Массив;
	
КонецФункции

#КонецЕсли