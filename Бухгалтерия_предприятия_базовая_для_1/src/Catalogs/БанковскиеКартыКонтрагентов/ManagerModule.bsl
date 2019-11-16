#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Владелец");
	БлокируемыеРеквизиты.Добавить("Объект.ОсновнойНомерДержателяКарты; НомерКартыПолный");
	
	Возврат БлокируемыеРеквизиты;	
	
КонецФункции	

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НайтиПоОсновномуНомеруДержателяКарты(Знач ОсновнойНомерДержателяКарты) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", БанковскиеКартыСлужебныйКлиентСервер.МаскированныйНомер(ОсновнойНомерДержателяКарты));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БанковскиеКартыКонтрагентов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.БанковскиеКартыКонтрагентов КАК БанковскиеКартыКонтрагентов
	|ГДЕ
	|	БанковскиеКартыКонтрагентов.Код = &Код
	|	И БанковскиеКартыКонтрагентов.ПометкаУдаления = ЛОЖЬ
	|	И БанковскиеКартыКонтрагентов.ВАрхиве = ЛОЖЬ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено
	КонецЕсли;	
	
	КартыСТакимЖеКодом = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОсновныеНомераДержателейКарт = 
		Справочники.БанковскиеКартыКонтрагентов.ОсновныеНомераДержателейКарт(КартыСТакимЖеКодом);
			
	Для Каждого Карта Из КартыСТакимЖеКодом Цикл
		Если ОсновныеНомераДержателейКарт[Карта] = ОсновнойНомерДержателяКарты Тогда
			Возврат Карта
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Добавляет в хранилище новую банковскую карту с указанным номером или реквизитами.
// Если у владельца уже есть карта с указанным номером, то обновляется существующий элемент справочника.
// Если действующая карта с указанным номером уже зарегистрирована на другого держателя, то:
// - при Загрузка = Ложь возникнет исключение;
// - при Загрузка = Истина будет создана новая карта с указанным владельцем.
//
// Параметры:
//   ДержательКарты - Справочник.ФизическиеЛица         - держатель карты.
//   Карта          - Структура                         - основные реквизиты карты, см. ОсновныеРеквизитыКарты().
//   Свойства       - Структура, ФиксированнаяСтруктура - свойства карты:
//                  	* ЭтоНациональныйПлатежныйИнструмент - Булево;        
//                  	* ЭтоМеждународнаяПлатежнаяКарта     - Булево;        
//   Загрузка       - Булево                            - если Истина, то проверки отключаются. 
//                                                        См. ПараметрыОбменаДанными.Загрузка  
//
// Возвращаемое значение:
//  СправочникСсылка.БанковскиеКартыКонтрагентов - созданная карта. 
//
Функция Добавить(Знач ДержательКарты, Знач Карта, Знач Свойства = Неопределено, Загрузка = Ложь) Экспорт
	
	Проверять = Не Загрузка;
	
	СуществующаяКарта = Справочники.БанковскиеКартыКонтрагентов.НайтиПоОсновномуНомеруДержателяКарты(Карта.ОсновнойНомерДержателяКарты);
	Если СуществующаяКарта = Неопределено Тогда
		Результат = НоваяКарта(ДержательКарты, Карта);
	Иначе
		Результат = СуществующаяКарта.ПолучитьОбъект();
		Если Результат.Владелец <> ДержательКарты Тогда
			Если Проверять Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Карта с номером %1 уже зарегистрирована на %2'"),
					Карта.ОсновнойНомерДержателяКарты,
					Результат.Владелец);
				ВызватьИсключение ТекстОшибки;
			Иначе
				Результат = НоваяКарта(ДержательКарты, Карта);
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Результат, Карта, "ИмяДержателяКарты, ДатаИстеченияСрокаДействияКарты");
	
	Если Свойства <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, Свойства);
	КонецЕсли;
	
	Если Проверять Тогда
		// Изымаем сообщения, имеющиеся до проверки, и запоминаем их.
		ОтложенныеСообщения = ПолучитьСообщенияПользователю(Истина);
		
		Если Не Результат.ПроверитьЗаполнение() Тогда
			// Перехватываем все сообщенное при проверке и собираем в одно исключение.
			ОшибкиПроверкиЗаполнения = "";
			Для Каждого Сообщение Из ПолучитьСообщенияПользователю(Ложь) Цикл
				ОшибкиПроверкиЗаполнения = ОшибкиПроверкиЗаполнения + Символы.ПС + Сообщение.Текст;
			КонецЦикла;

			// Восстанавливаем исходные сообщения
			СообщитьОтложенныеСообщения(ОтложенныеСообщения);
			
			ВызватьИсключение НСтр("ru = 'Ошибка проверки заполнения.'") + Символы.ПС + ОшибкиПроверкиЗаполнения;
		КонецЕсли;
		
		// Восстанавливаем исходные сообщения
		СообщитьОтложенныеСообщения(ОтложенныеСообщения);
	Иначе	
		Результат.ОбменДанными.Загрузка = Истина;
	КонецЕсли;
	
	Результат.Записать();
	
	Возврат Результат.Ссылка;
	
КонецФункции

Функция ОсновныеРеквизитыКарты() Экспорт
	ОсновныеРеквизитыКарты = Новый Структура;
	ОсновныеРеквизитыКарты.Вставить("ОсновнойНомерДержателяКарты",     "");
	ОсновныеРеквизитыКарты.Вставить("ИмяДержателяКарты",               "");
	ОсновныеРеквизитыКарты.Вставить("ДатаИстеченияСрокаДействияКарты", '00010101');
	Возврат ОсновныеРеквизитыКарты
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Справочник.БанковскиеКартыКонтрагентов";
	НовыеСведения.ПоляРегистрации	= "Владелец";
	НовыеСведения.ПоляДоступа		= "ИмяДержателяКарты,ДатаИстеченияСрокаДействияКарты";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

Функция РазрешеноИзменениеОсновногоНомераДержателяКарты() Экспорт
	Возврат	ПравоДоступа("Редактирование", МетаданныеОсновногоНомераДержателяКарты())
КонецФункции

Функция РазрешенПросмотрОсновногоНомераДержателяКарты() Экспорт
	Возврат	ПравоДоступа("Просмотр", МетаданныеОсновногоНомераДержателяКарты())
КонецФункции

Функция ОсновнойНомерДержателяКарты(Карта, Знач ТолькоРазрешенные = Ложь) Экспорт
	Возврат ОсновныеНомераДержателейКарт(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Карта), ТолькоРазрешенные)[Карта];	
КонецФункции

Функция ОсновныеНомераДержателейКарт(Карты, Знач ТолькоРазрешенные = Ложь) Экспорт
	
	Если РазрешенПросмотрОсновногоНомераДержателяКарты() Тогда
			
		ОсновныеНомераДержателейКарт = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Карты, "ОсновнойНомерДержателяКарты", Истина);
		Для Каждого ОсновнойНомерДержателяКарты Из ОсновныеНомераДержателейКарт Цикл
			Если ЗначениеЗаполнено(ОсновнойНомерДержателяКарты) Тогда
				ОсновныеНомераДержателейКарт[ОсновнойНомерДержателяКарты.Ключ] = ОсновнойНомерДержателяКарты.Значение.Получить();
			Иначе
				ОсновныеНомераДержателейКарт[ОсновнойНомерДержателяКарты.Ключ] = "";
			КонецЕсли;	
		КонецЦикла;	
		Возврат ОсновныеНомераДержателейКарт;
		
	Иначе
		Если ТолькоРазрешенные Тогда
			Возврат Новый Соответствие
		Иначе
			ВызватьИсключение НСтр("ru = 'Недостаточно прав для просмотра полного номера банковской карты.'")
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат ОсновныеНомераДержателейКарт
	
КонецФункции

Функция ЭтоНациональныйПлатежныйИнструмент(Знач Карта) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Карта, "ЭтоНациональныйПлатежныйИнструмент")
КонецФункции

Функция МетаданныеОсновногоНомераДержателяКарты() 
	Возврат Метаданные.Справочники.БанковскиеКартыКонтрагентов.Реквизиты.ОсновнойНомерДержателяКарты
КонецФункции	

Процедура СообщитьОтложенныеСообщения(Знач ОтложенныеСообщения)
	Для Каждого Сообщение Из ОтложенныеСообщения Цикл
		Сообщение.Сообщить();
	КонецЦикла;
КонецПроцедуры

Функция НоваяКарта(ДержательКарты, Карта)
	
	ДанныеЗаполнения = ОсновныеРеквизитыКарты();
	ДанныеЗаполнения.Вставить("Владелец", ДержательКарты);
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Карта);
	
	Результат = Справочники.БанковскиеКартыКонтрагентов.СоздатьЭлемент();
	Результат.Заполнить(ДанныеЗаполнения);
	
	Возврат Результат
	
КонецФункции

#КонецОбласти

#КонецЕсли