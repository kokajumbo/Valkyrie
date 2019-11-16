#Область ПрограммныйИнтерфейс

Функция НовыйКлючЗаписи(Владелец) Экспорт
	
	ЗначенияКлюча = Новый Структура("Владелец", Владелец);
	Возврат РегистрыСведений.БезопасноеХранилищеДанных.СоздатьКлючЗаписи(ЗначенияКлюча);
	
КонецФункции

// Записывает конфиденциальные данные в безопасное хранилище.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Безопасное хранилище недоступно для чтения пользователям (кроме администраторов),
// а доступно только коду, который делает обращения только к своей части данных и
// в том контексте, который предполагает чтение или запись конфиденциальных данных.
//
// В отличие от безопасного хранилища БСП, в этом хранилище доступна запись 
// неразделенных данных из разделенного сеанса.
// 
// Параметры:
//  Владелец - ПланОбменаСсылка, СправочникСсылка, Строка - ссылка на объект информационной базы,
//             представляющий объект-владелец сохраняемого пароля или строка до 128 символов.
//             Для объектов других типов в качестве Владельца рекомендуется использовать ссылку на
//             элемент метаданных этого типа в справочнике ИдентификаторыОбъектовМетаданных
//             или ключ в виде строки с учетом имен подсистем.
//
//  Данные  - Произвольный - Данные помещаемые в безопасное хранилище. Неопределенно - удаляет все данные.
//             Для удаления данных по ключу следует использовать процедуру УдалитьДанныеИзБезопасногоХранилища.
//  Ключ    - Строка       - Ключ сохраняемых настроек, по умолчанию "Пароль".
//                           Ключ должен соответствовать правилам, установленным для идентификаторов:
//                           * Первым символом ключа должна быть буква или символ подчеркивания (_).
//                           * Каждый из последующих символов может быть буквой, цифрой или символом подчеркивания (_).
//
// Пример:
//  Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//      Если ТекущийПользовательМожетИзменятьПароль Тогда
//          УстановитьПривилегированныйРежим(Истина);
//          РегистрыСведений.БезопасноеХранилищеДанныхОбщее.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Логин, "Логин");
//          РегистрыСведений.БезопасноеХранилищеДанныхОбщее.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Пароль);
//          УстановитьПривилегированныйРежим(Ложь);
//      КонецЕсли;
//  КонецПроцедуры
//
Процедура Записать(Владелец, Данные, Ключ = "Пароль") Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать ссылку; передано значение: %3 (тип %4).'"),
			"Владелец", "ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище", Владелец, ТипЗнч(Владелец)));
			
	БезопасноеХранилищеДанных = РегистрыСведений.БезопасноеХранилищеДанныхОбщее.СоздатьМенеджерЗаписи();
	
	БезопасноеХранилищеДанных.Владелец = Владелец;
	БезопасноеХранилищеДанных.Прочитать();
	Если Данные <> Неопределено Тогда
		Если БезопасноеХранилищеДанных.Выбран() Тогда
			ДанныеДляСохранения = БезопасноеХранилищеДанных.Данные.Получить();
			Если ТипЗнч(ДанныеДляСохранения) <> Тип("Структура") Тогда
				ДанныеДляСохранения = Новый Структура();
			КонецЕсли;
			ДанныеДляСохранения.Вставить(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
			БезопасноеХранилищеДанных.Записать();
		Иначе
			ДанныеДляСохранения = Новый Структура(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
			БезопасноеХранилищеДанных.Владелец = Владелец;
			БезопасноеХранилищеДанных.Записать();
		КонецЕсли;
	Иначе
		БезопасноеХранилищеДанных.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные из безопасного хранилища.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Безопасное хранилище недоступно для чтения пользователям (кроме администраторов),
// а доступно только коду, который делает обращения только к своей части данных и
// в том контексте, который предполагает чтение или запись конфиденциальных данных.
//
// Параметры:
//  Владелец    - ПланОбменаСсылка, СправочникСсылка, Строка - ссылка на объект информационной базы,
//                  представляющий объект-владелец сохраняемого пароля или строка до 128 символов.
//  Ключи       - Строка - Содержит список имен сохраненных данных, указанных через запятую.
// 
// Возвращаемое значение:
//  Произвольный, Структура, Неопределенно - Данные из безопасного хранилища. Если указан один ключ,
//                            то возвращается его значение, иначе структура.
//                            Если данные отсутствуют - Неопределенно.
//
// Пример:
//	Процедура ПриЧтенииНаСервере(ТекущийОбъект)
//		
//		Если ТекущийПользовательМожетИзменятьПароль Тогда
//			УстановитьПривилегированныйРежим(Истина);
//			Логин  = РегистрыСведений.БезопасноеХранилищеДанныхОбщее.ПрочитатьДанныеИзБезопасногоХранилища(ТекущийОбъект.Ссылка, "Логин");
//			Пароль = РегистрыСведений.БезопасноеХранилищеДанныхОбщее.ПрочитатьДанныеИзБезопасногоХранилища(ТекущийОбъект.Ссылка);
//			УстановитьПривилегированныйРежим(Ложь);
//		Иначе
//			Элементы.ГруппаЛогинИПароль.Видимость = Ложь;
//		КонецЕсли;
//		
//	КонецПроцедуры
//
Функция Прочитать(Владелец, Ключи = "Пароль") Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать ссылку; передано значение: %3 (тип %4).'"),
			"Владелец", "ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища", Владелец, ТипЗнч(Владелец)));
	
	Результат = ДанныеИзБезопасногоХранилища(Владелец, Ключи);
	
	Если Результат <> Неопределено И Результат.Количество() = 1 Тогда
		Возврат ?(Результат.Свойство(Ключи), Результат[Ключи], Неопределено);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Удаляет конфиденциальные данные в безопасное хранилище.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
//
// Безопасное хранилище недоступно для чтения пользователям (кроме администраторов),
// а доступно только коду, который делает обращения только к своей части данных и
// в том контексте, который предполагает чтение или запись конфиденциальных данных.
//
// Параметры:
//  Владелец - ПланОбменаСсылка, СправочникСсылка, Строка - ссылка на объект информационной базы,
//               представляющий объект-владелец сохраняемого пароля или строка до 128 символов.
//  Ключи    - Строка - Содержит список имен удаляемых данных, указанных через запятую. 
//               Неопределенно - удаляет все данные.
//
// Пример:
//	Процедура ПередУдалением(Отказ)
//		
//		// Проверка значения свойства ОбменДанными.Загрузка отсутствует, так как удалять данные
//		// из безопасного хранилища нужно даже при удалении объекта при обмене данными.
//		
//		УстановитьПривилегированныйРежим(Истина);
//		РегистрыСведений.БезопасноеХранилищеДанныхОбщее.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
//		УстановитьПривилегированныйРежим(Ложь);
//		
//	КонецПроцедуры
//
Процедура Удалить(Владелец, Ключи = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение параметра %1 в %2.
			           |параметр должен содержать ссылку; передано значение: %3 (тип %4).'"),
			"Владелец", "ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища", Владелец, ТипЗнч(Владелец)));
	
	БезопасноеХранилищеДанных = РегистрыСведений.БезопасноеХранилищеДанныхОбщее.СоздатьМенеджерЗаписи();
	
	БезопасноеХранилищеДанных.Владелец = Владелец;
	БезопасноеХранилищеДанных.Прочитать();
	Если ТипЗнч(БезопасноеХранилищеДанных.Данные) = Тип("ХранилищеЗначения") Тогда
		ДанныеДляСохранения = БезопасноеХранилищеДанных.Данные.Получить();
		Если Ключи <> Неопределено И ТипЗнч(ДанныеДляСохранения) = Тип("Структура") Тогда
			СписокКлючей = СтрРазделить(Ключи, ",", Ложь);
			Если БезопасноеХранилищеДанных.Выбран() И СписокКлючей.Количество() > 0 Тогда
				Для каждого КлючДляУдаления Из СписокКлючей Цикл
					Если ДанныеДляСохранения.Свойство(КлючДляУдаления) Тогда
						ДанныеДляСохранения.Удалить(КлючДляУдаления);
					КонецЕсли;
				КонецЦикла;
				ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
				БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
				БезопасноеХранилищеДанных.Записать();
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	БезопасноеХранилищеДанных.Удалить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеИзБезопасногоХранилища(Владелец, Ключ)
	
	Результат = Новый Структура(Ключ);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БезопасноеХранилищеДанных.Данные КАК Данные
	|ИЗ
	|	РегистрСведений.БезопасноеХранилищеДанныхОбщее КАК БезопасноеХранилищеДанных
	|ГДЕ
	|	БезопасноеХранилищеДанных.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Если ЗначениеЗаполнено(РезультатЗапроса.Данные) Тогда
			СохраненныеДанные = РезультатЗапроса.Данные.Получить();
			Если ЗначениеЗаполнено(СохраненныеДанные) Тогда
				ЗаполнитьЗначенияСвойств(Результат, СохраненныеДанные);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти