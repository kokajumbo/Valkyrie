
#Область СлужебныйПрограммныйИнтерфейс

// Процедура определяет был ли зафиксирован реквизит ранее и если не был, то фиксирует его.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ПараметрыФиксацииВторичныхДанных - структура см. ПараметрыФиксацииВторичныхДанных.
//    	ИмяРеквизита - имя элемента описания формы для механизма фиксации изменений.
//
Процедура ЗафиксироватьИзменениеРеквизита(Форма, ИмяРеквизита, ТекущаяСтрока = 0) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеФиксацииРеквизита = НайтиЭлементСоответствияПоКлючу(ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов, ИмяРеквизита);
	Если НЕ ОписаниеФиксацииРеквизита = Неопределено Тогда
		Если ОписаниеФиксацииРеквизита.Значение.ФиксацияГруппы Тогда
			УстановитьФиксациюИзмененийГруппыРеквизитов(Форма, ОписаниеФиксацииРеквизита.Значение.ИмяГруппы, ТекущаяСтрока);
		Иначе
			УстановитьФиксациюРеквизита(Форма, ОписаниеФиксацииРеквизита, ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура устанавливает фиксацию реквизитов принадлежащих группе указанной в описании формы для механизма фиксации
// изменений:
//    	Форма - управляемая форма.
//    	ИмяГруппы - параметр ИмяГруппы описания элемента фиксации.
//    	ТекущаяСтрока - если редактируется реквизит табличной части.
//
Процедура УстановитьФиксациюИзмененийГруппыРеквизитов(Форма, ИмяГруппы, ТекущаяСтрока = 0) Экспорт
	Если НЕ ЗначениеЗаполнено(ИмяГруппы) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если ОписаниеФиксацииРеквизита.Значение.ИмяГруппы = ИмяГруппы Тогда
			УстановитьФиксациюРеквизита(Форма, ОписаниеФиксацииРеквизита, ТекущаяСтрока);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура определяет подключен ли реквизит к механизму фиксации изменений и если подключен, то
// сбрасывает его фиксацию.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ПараметрыФиксацииВторичныхДанных - структура см. ПараметрыФиксацииВторичныхДанных.
//    	ИмяРеквизита - имя элемента описания формы для механизма фиксации изменений.
//
Процедура СброситьФиксациюИзмененийРеквизита(Форма, ИмяРеквизита, ТекущаяСтрока = 0) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеФиксацииРеквизита = НайтиЭлементСоответствияПоКлючу(ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов, ИмяРеквизита);
	Если НЕ ОписаниеФиксацииРеквизита  = Неопределено Тогда
		Если НЕ ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки И ПолучитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита) Тогда
			УстановитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита, Ложь);
			ОбновитьОтображениеПредупреждения(Форма, ОписаниеФиксацииРеквизита);
		ИначеЕсли ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки И ПолучитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, ТекущаяСтрока) Тогда
			УстановитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, Ложь, ТекущаяСтрока);
			ОбновитьОтображениеПредупреждения(Форма, ОписаниеФиксацииРеквизита, ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// См. ОбновитьОтображениеПредупреждений и ОбновитьИспользованиеФиксацииРеквизитов.
//
Процедура ОбновитьФорму(Форма) Экспорт
	ОбновитьОтображениеПредупреждений(Форма);
	ОбновитьИспользованиеФиксацииРеквизитов(Форма);
КонецПроцедуры

// Процедура устанавливает ФиксИспользование для реквизитов
// подключенных к механизму фиксации изменений реквизитов формы, в зависимости от параметров механизма.
// 	Параметры:
//    	Форма - управляемая форма к которой подключается механизм.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура ОбновитьИспользованиеФиксацииРеквизитов(Форма) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		УстановитьПризнакИспользованияФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита);
	КонецЦикла;
КонецПроцедуры

// Процедура устанавливает ОтображениеПредупрежденияПриРедактировании для реквизитов
// подключенных к механизму фиксации изменений реквизитов формы, в зависимости от их фиксированности.
// 	Параметры:
//    	Форма - управляемая форма к которой подключается механизм.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура ОбновитьОтображениеПредупреждений(Форма) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Для Каждого ОписаниеРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если Не ОписаниеРеквизита.Значение.РеквизитСтроки Тогда
			ОбновитьОтображениеПредупреждения(Форма, ОписаниеРеквизита);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура устанавливает ОтображениеПредупрежденияПриРедактировании для реквизитов табличной части
// подключенных к механизму фиксации изменений реквизитов формы, в зависимости от их фиксированности.
//
// Параметры:
//    Форма - Управляемая форма - Форма, к которой подключен механизм фиксации.
//    ИмяТаблицы - Строка - Имя таблицы, для которой необходимо обновить элементы.
//    ИдентификаторСтроки - Число - Идентификатор строки таблицы, для которой обновляются элементы.
//
Процедура ОбновитьОтображениеПредупрежденийТЧ(Форма, ИмяТаблицы, ИдентификаторСтроки = 0, ОтключитьПредупреждения = Ложь) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Для Каждого ОписаниеРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если ОписаниеРеквизита.Значение.РеквизитСтроки
			И ОписаниеРеквизита.Значение.Путь = ИмяТаблицы Тогда
			ОбновитьОтображениеПредупреждения(Форма, ОписаниеРеквизита, ИдентификаторСтроки, ОтключитьПредупреждения);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Возвращает имя реквизита по его описанию.
// 	Параметры:
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//
Функция ИмяРеквизита(ОписаниеФиксацииРеквизита, ПрефиксПути) Экспорт
	Путь = ПрефиксПути;
	
	Если ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
		Путь = Путь + "." + ОписаниеФиксацииРеквизита.Значение.Путь;
	КонецЕсли;
	
	Возврат Путь + ?(ЗначениеЗаполнено(Путь), ".", "") + ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
КонецФункции

// Возвращает имя реквизита Фикс по описанию основного реквизита.
// 	Параметры:
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//
Функция ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути) Экспорт
	Путь = "";
	
	Если ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
		Путь = ПрефиксПути + "." + ОписаниеФиксацииРеквизита.Значение.Путь;
	КонецЕсли;
	
	Возврат Путь + ?(ЗначениеЗаполнено(Путь), ".", "") + ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита + "Фикс";
КонецФункции

// Возвращает имя реквизита Фикс по описанию основного реквизита.
// 	Параметры:
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//
Функция ИмяРеквизитаФиксИспользование(ОписаниеФиксацииРеквизита) Экспорт
	Возврат ОписаниеФиксацииРеквизита.Ключ + "ФиксИспользование";
КонецФункции

// Проверяет зафиксирован-ли реквизит.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма с реквизитом.
//   ИмяРеквизита - Строка - Имя реквизита.
//
Функция РеквизитЗафиксирован(Форма, ИмяРеквизита) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеФиксацииРеквизита = НайтиЭлементСоответствияПоКлючу(ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов, ИмяРеквизита);
	Если ОписаниеФиксацииРеквизита = Неопределено Тогда
		Возврат Ложь; // Реквизит не фиксируется.
	КонецЕсли;
	ПрефиксПути = ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
	Возврат ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути));
КонецФункции

// Функция возвращает признак фиксированности реквизита.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//
Функция ПолучитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита) Экспорт
	ОписаниеЭлементовФормы = Форма.ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
	
	Возврат ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути))
КонецФункции

// Функция возвращает признак фиксированности реквизита.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//
Функция ПолучитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, ИдентификаторСтроки) Экспорт
	ОписаниеЭлементовФормы = Форма.ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
	ПутьРеквизита = ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути);
	
	МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьРеквизита, ".");
	
	Объект			= Форма;
	ПоследнееПоле	= МассивИмен[МассивИмен.Количество()-1];
	
	Сч = 0;
	Пока Сч < МассивИмен.Количество()-1 Цикл
		Объект = Объект[МассивИмен[Сч]];
		Сч = Сч + 1;
	КонецЦикла;
	
	Возврат НЕ ИдентификаторСтроки = Неопределено
		И НЕ Объект.НайтиПоИдентификатору(ИдентификаторСтроки) = Неопределено
		И Объект.НайтиПоИдентификатору(ИдентификаторСтроки)[ПоследнееПоле];
КонецФункции

// Процедура устанавливает новое значение реквизиту Фикс.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//    	Значение - Булево, новое значение реквизита.
//
Процедура УстановитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита, Значение) Экспорт
	ОписаниеЭлементовФормы = Форма.ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути), Значение)
КонецПроцедуры

// Процедура устанавливает новое значение реквизиту Фикс расположенному в табличной части.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//    	Значение - Булево, новое значение реквизита.
//
Процедура УстановитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, Значение, ТекущаяСтрока) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеЭлементовФормы = ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
	ПутьРеквизита = ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути);
	
	МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьРеквизита, ".");
	
	Объект			= Форма;
	ПоследнееПоле	= МассивИмен[МассивИмен.Количество()-1];
	
	Для Сч = 0 По МассивИмен.Количество()-2 Цикл
		Объект = Объект[МассивИмен[Сч]]
	КонецЦикла;
	
	Объект.НайтиПоИдентификатору(ТекущаяСтрока)[ПоследнееПоле] = Значение;
КонецПроцедуры

// Процедура устанавливает новое значение реквизиту ФиксИспользование.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//    	Значение - Булево, новое значение реквизита.
//
Процедура УстановитьПризнакИспользованияФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита) Экспорт
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизитаФиксИспользование(ОписаниеФиксацииРеквизита), ОписаниеФиксацииРеквизита.Значение.Используется)
КонецПроцедуры

// Процедура проверяет зафиксирован ли реквизит и устанавливает(или не устанавливает) новое значение.
// Автообновление реквизитов формы должно делаться с использованием этой процедуры.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//    	Значение - Произвольный, новое значение реквизита.
//
Процедура УстановитьЗначениеРеквизита(Форма, ИмяРеквизита, Значение) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеФиксацииРеквизита = НайтиЭлементСоответствияПоКлючу(ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов, ИмяРеквизита);
	ОписаниеЭлементовФормы = ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	// Если описания нет - ничего не делаем.
	Если НЕ ОписаниеФиксацииРеквизита = Неопределено Тогда
		Если НЕ ПолучитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита)
			Или НЕ ОписаниеФиксацииРеквизита.Значение.Используется Тогда
			ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизита(ОписаниеФиксацииРеквизита, ПрефиксПути), Значение)
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура проверяет зафиксирован ли реквизит и устанавливает(или не устанавливает) новое значение.
// Автообновление реквизитов формы должно делаться с использованием этой процедуры.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//    	Значение - Произвольный, новое значение реквизита.
//
Процедура УстановитьЗначениеРеквизитаТЧ(Форма, ИмяРеквизита, Значение, ТекущаяСтрока) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеФиксацииРеквизита = НайтиЭлементСоответствияПоКлючу(ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов, ИмяРеквизита);
	ОписаниеЭлементовФормы = ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	// Если описания нет - ничего не делаем.
	Если НЕ ОписаниеФиксацииРеквизита = Неопределено Тогда
		Если НЕ ПолучитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, ТекущаяСтрока)
			Или НЕ ОписаниеФиксацииРеквизита.Значение.Используется Тогда
			
			ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
			ПутьРеквизита = ИмяРеквизита(ОписаниеФиксацииРеквизита, ПрефиксПути);
			
			МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьРеквизита, ".");
			
			Объект        = Форма;
			ПоследнееПоле = МассивИмен[МассивИмен.Количество()-1];
			
			Для Сч = 0 По МассивИмен.Количество()-2 Цикл
				Объект = Объект[МассивИмен[Сч]]
			КонецЦикла;
			
			Объект.НайтиПоИдентификатору(ТекущаяСтрока)[ПоследнееПоле] = Значение;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура очищает таблицу хранящую признаки фиксации реквизитов формы.
//		ПараметрыФиксацииВторичныхДанных - структура см.
//		                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//		Путь - Строка - Имя табличной части, для которой очищается фиксация изменений,
//				если не задано - очищается фиксация изменений для всех табличных частей.
//		МассивИдентификаторовСтрок - Массив - Идентификаторы строк табличных частей, для которой очищается фиксация
//		                                      изменений, если не задано - очищается фиксация изменений для всей табличной
//		                                      части.
//
Процедура ОчиститьФиксациюИзменений(Форма, Объект, Путь = Неопределено, МассивИдентификаторовСтрок = Неопределено) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Если Путь = Неопределено Тогда
		Объект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].Очистить();
	Иначе
		ОтборСтрок = Новый Структура();
		ОтборСтрок.Вставить("Путь", Путь);
		НайденныеСтроки = Объект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].НайтиСтроки(ОтборСтрок);
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если МассивИдентификаторовСтрок = Неопределено Тогда
				Объект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].Удалить(НайденнаяСтрока);
			Иначе
				Если МассивИдентификаторовСтрок.Найти(НайденнаяСтрока.ИдентификаторСтроки) <> Неопределено Тогда
					Объект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].Удалить(НайденнаяСтрока);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Процедура переносит признаки фиксации из реквизитов формы в табличную часть объекта.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеЭлементовФормы = ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	ТекущийОбъект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].Очистить();
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если Не ОписаниеФиксацииРеквизита.Значение.Используется Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
			ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
			МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяРеквизитаФикс(ОписаниеФиксацииРеквизита, ПрефиксПути), ".");
			
			Объект        = Форма;
			ПоследнееПоле = МассивИмен[МассивИмен.Количество()-1];
			
			Для Сч = 0 По МассивИмен.Количество()-2 Цикл
				Объект = Объект[МассивИмен[Сч]]
			КонецЦикла;
			
			Для каждого СтрокаТЧ Из Объект Цикл
				Если ПолучитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, СтрокаТЧ.ПолучитьИдентификатор()) Тогда
					Если СтрокаТЧ[ПоследнееПоле] Тогда
						НоваяФиксацияРеквизита						= ТекущийОбъект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].Добавить();
						НоваяФиксацияРеквизита.ИмяРеквизита			= ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
						НоваяФиксацияРеквизита.Путь					= ОписаниеФиксацииРеквизита.Значение.Путь;
						НоваяФиксацияРеквизита.ИдентификаторСтроки	= СтрокаТЧ.ИдентификаторСтрокиФикс;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Если ПолучитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита) Тогда
				НоваяФиксацияРеквизита = ТекущийОбъект[ПараметрыФиксацииВторичныхДанных.ИмяТабличнойЧастиФиксацияИзменений].Добавить();
				НоваяФиксацияРеквизита.ИмяРеквизита = ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
				НоваяФиксацияРеквизита.Путь			= ОписаниеФиксацииРеквизита.Значение.Путь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура заполняет реквизит ИдентификаторСтрокиФикс в переданной ТЧ.
//
Процедура ЗаполнитьИдентификаторыФиксТЧ(ТЧ, ИмяКолонкиИдентификаторСтрокиФикс = "ИдентификаторСтрокиФикс") Экспорт
	ТекущийИдентификатор = 1;
	Для каждого СтрокаТЧ Из ТЧ Цикл
		СтрокаТЧ[ИмяКолонкиИдентификаторСтрокиФикс] = ТекущийИдентификатор;
		ТекущийИдентификатор = ТекущийИдентификатор + 1;
	КонецЦикла;
КонецПроцедуры

// Процедура очищает фиксацию реквизитов принадлежащих группе указанной в описании формы для механизма фиксации
// изменений: ОснованиеЗаполнения из СтруктураПараметровОписанияФиксацииРеквизитов.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(Форма, ОснованиеЗаполнения, ТекущаяСтрока = 0) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Для Каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если ОписаниеФиксацииРеквизита.Значение.ОснованиеЗаполнения = ОснованиеЗаполнения Тогда
			СброситьФиксациюИзмененийРеквизита(Форма, ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита, ТекущаяСтрока);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Отменяет фиксацию реквизитов строки табличной части.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма с табличной частью.
//   Путь - Строка - Имя таблицы.
//   ТекущаяСтрока - Произвольный - Идентификатор строки табличной части.
//
Процедура СброситьФиксациюСтрокиТаблицы(Форма, Путь, ТекущаяСтрока = 0) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Для Каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если ОписаниеФиксацииРеквизита.Значение.Путь = Путь Тогда
			СброситьФиксациюИзмененийРеквизита(Форма, ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита, ТекущаяСтрока);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура очищает фиксацию реквизитов принадлежащих группе указанной в описании формы для механизма фиксации
// изменений: ОснованиеЗаполнения из СтруктураПараметровОписанияФиксацииРеквизитов.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура СброситьФиксациюИзмененийГруппыРеквизитов(Форма, ИмяГруппы, ТекущаяСтрока = 0) Экспорт
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	Для Каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если ОписаниеФиксацииРеквизита.Значение.ИмяГруппы = ИмяГруппы Тогда
			СброситьФиксациюИзмененийРеквизита(Форма, ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита, ТекущаяСтрока);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Процедура обработчик события "При изменении" реквизитов подключенных к механизму фиксации.
//
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Форма, Элемент, ОписаниеЭлементов, ТекущаяСтрока = 0) Экспорт
	ИмяРеквизита = ОписаниеЭлементов.Получить(Элемент.Имя);
	ЗафиксироватьИзменениеРеквизита(Форма, ИмяРеквизита, ТекущаяСтрока)
КонецПроцедуры

// Процедура устанавливает значение реквизита формы ФиксацияОбъектЗафиксирован.
// 	Параметры:
//    	Форма - управляемая форма к которой подключается механизм.
//				У формы должен быть определен экспортный метод ОбъектЗафиксирован().
//
Функция ОбъектФормыЗафиксирован(Форма) Экспорт
	ИменаРеквизитовИЭлементов = ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных();
	Возврат Форма[ИменаРеквизитовИЭлементов.Получить("ФиксацияОбъектЗафиксирован")];
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных() Экспорт
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("ФиксацияСоответствиеПутейЭлементов","ФиксацияСоответствиеПутейЭлементов");
	Соответствие.Вставить("ПараметрыФиксацииВторичныхДанных","ПараметрыФиксацииВторичныхДанных");
	Соответствие.Вставить("ФиксацияОбъектЗафиксирован","ФиксацияОбъектЗафиксирован");
	Соответствие.Вставить("ПредупреждениеОбновленияВторичныхДанных","ПредупреждениеОбновленияВторичныхДанных");
	Соответствие.Вставить("ГруппаПредупреждениеОбновленияВторичныхДанных","ГруппаПредупреждениеОбновленияВторичныхДанных");
	
	Возврат Соответствие;
КонецФункции

// Процедура определяет необходимость отображения предупреждения для элементов связанных с реквизитом
// и устанавливает ОтображениеПредупрежденияПриРедактировании.
// 	Параметры:
//    	Форма - управляемая форма.
//    	ОписаниеФиксацииРеквизита - Структура с полями - см. описание СтруктураПараметровОписанияФиксацииРеквизитов().
//
Процедура ОбновитьОтображениеПредупреждения(Форма, ОписаниеФиксацииРеквизита, ИдентификаторСтроки = 0, ОтключитьПредупреждения = Ложь)
	Если ОписаниеФиксацииРеквизита.Значение.ОтображатьПредупреждение Тогда
		
		Если ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
			Зафиксирован = ПолучитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, ИдентификаторСтроки);
		Иначе
			Зафиксирован = ПолучитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита);
		КонецЕсли;
		
		Если ОтключитьПредупреждения Тогда
			ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		ИначеЕсли Зафиксирован Или НЕ ОписаниеФиксацииРеквизита.Значение.Используется Тогда
			ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		Иначе
			ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.Отображать;
		КонецЕсли;
		
		МассивЭлементов = МассивЭлементовФормыПоОписанию(Форма, ОписаниеФиксацииРеквизита);
		
		Для каждого ИмяЭлемента Из МассивЭлементов Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ИмяЭлемента, "ОтображениеПредупрежденияПриРедактировании", ОтображениеПредупреждения);
			Если ТипЗнч(Форма.Элементы[ИмяЭлемента]) = Тип("ПолеФормы")
				И Форма.Элементы[ИмяЭлемента].Вид = ВидПоляФормы.ПолеФлажка Тогда
				Шрифт = Форма.ПараметрыФиксацииВторичныхДанных[?(Зафиксирован, "ЖирныйШрифт", "НеЖирныйШрифт")];
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ИмяЭлемента, "ШрифтЗаголовка", Шрифт);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Процедура устанавливает фиксацию реквизита.
//
Процедура УстановитьФиксациюРеквизита(Форма, ОписаниеФиксацииРеквизита, ИдентификаторСтроки = 0)
	Если НЕ ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки И НЕ ПолучитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита) Тогда
		УстановитьПризнакФиксацииРеквизита(Форма, ОписаниеФиксацииРеквизита, Истина);
		ОбновитьОтображениеПредупреждения(Форма, ОписаниеФиксацииРеквизита);
	ИначеЕсли ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки И НЕ ПолучитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, ИдентификаторСтроки) Тогда
		УстановитьПризнакФиксацииРеквизитаТЧ(Форма, ОписаниеФиксацииРеквизита, Истина, ИдентификаторСтроки);
		ОбновитьОтображениеПредупреждения(Форма, ОписаниеФиксацииРеквизита, ИдентификаторСтроки);
	КонецЕсли;
КонецПроцедуры

Функция МассивЭлементовФормыПоОписанию(Форма, ОписаниеФиксацииРеквизита) Экспорт
	ИменаРеквизитовИЭлементов = ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных();
	
	ПараметрыФиксацииВторичныхДанных = Форма.ПараметрыФиксацииВторичныхДанных;
	ОписаниеЭлементовФормы = ПараметрыФиксацииВторичныхДанных.ОписаниеФормы.ОписаниеЭлементовФормы;
	ПрефиксПути = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПути;
	ПрефиксПутиТекущиеДанные = ОписаниеЭлементовФормы.Получить(ОписаниеФиксацииРеквизита.Ключ).ПрефиксПутиТекущиеДанные;
	ПутьКРеквизиту = ИмяРеквизита(ОписаниеФиксацииРеквизита, ПрефиксПути);
	
	МассивЭлементов = Форма[ИменаРеквизитовИЭлементов.Получить("ФиксацияСоответствиеПутейЭлементов")].Получить(ВРег(ПутьКРеквизиту));
	
	Если МассивЭлементов = Неопределено Тогда
		МассивЭлементов = Новый Массив;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПрефиксПутиТекущиеДанные) Тогда
		ПутьТекущиеДанные = ВРег(ПрефиксПутиТекущиеДанные +"."+ ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита);
		МассивЭлементовТекущиеДанные = Форма["ФиксацияСоответствиеПутейЭлементов"].Получить(ПутьТекущиеДанные);
		Если НЕ МассивЭлементовТекущиеДанные = Неопределено Тогда
			Для каждого ЭлементТекущиеДанные Из МассивЭлементовТекущиеДанные Цикл
				МассивЭлементов.Добавить(ЭлементТекущиеДанные);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивЭлементов
КонецФункции

Функция НайтиЭлементСоответствияПоКлючу(Соответствие, Ключ)
	ЭлементСоответствия = Неопределено;
	Для каждого Элемент Из Соответствие Цикл
		Если Элемент.Значение.ИмяРеквизита = Ключ Тогда
			ЭлементСоответствия = Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭлементСоответствия
КонецФункции

#КонецОбласти
