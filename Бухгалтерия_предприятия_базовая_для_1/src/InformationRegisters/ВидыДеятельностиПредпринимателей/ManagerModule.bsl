#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Процедура выполняет очистку записей регистра сведений ВидыДеятельностиПредпринимателей
// в случае изменения характера вида деятельности, т.к. должна существовать только одна
// пара "Вид деятельности - Характер деятельности"
//
// Параметры:
//	ВидДеятельности - вид деятельности, для которого выполняется проверка
//	ИсключаяХарактерДеятельности - заданный характер вида деятельности
//
//
// Возвращаемое значение:
//	<Массив>	- массив строк оповещений пользователю, в обычной ситуации
//				содержит одну строку, соответствующую старому характеру
//				деятельности
//
Функция ОчиститьСписокНоменклатуныхГрупп(ВидДеятельности, ИсключаяХарактерДеятельности) Экспорт
	
	ОповещенияПользователю	= Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыДеятельностиПредпринимателей.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	ВидыДеятельностиПредпринимателей.ХарактерДеятельности КАК ХарактерДеятельности,
		|	ПРЕДСТАВЛЕНИЕ(ВидыДеятельностиПредпринимателей.ХарактерДеятельности) КАК ХарактерДеятельностиПредставление
		|ИЗ
		|	РегистрСведений.ВидыДеятельностиПредпринимателей КАК ВидыДеятельностиПредпринимателей
		|ГДЕ
		|	ВидыДеятельностиПредпринимателей.ВидДеятельности = &ВидДеятельности
		|	И (НЕ ВидыДеятельностиПредпринимателей.ХарактерДеятельности = &ХарактерДеятельности)
		|ИТОГИ ПО
		|	ХарактерДеятельности";

	Запрос.УстановитьПараметр("ВидДеятельности", ВидДеятельности);
	Запрос.УстановитьПараметр("ХарактерДеятельности", ИсключаяХарактерДеятельности);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат ОповещенияПользователю;
	КонецЕсли;
	
	// Установка управляемой блокировки
	ТаблицаБлокировки	= Новый ТаблицаЗначений;
	ТаблицаБлокировки.Колонки.Добавить("НоменклатурнаяГруппа", Новый ОписаниеТипов("СправочникСсылка.НоменклатурныеГруппы"));
	ТаблицаБлокировки.Колонки.Добавить("ХарактерДеятельности", Новый ОписаниеТипов("ПеречислениеСсылка.ХарактерДеятельности"));
	
	ВыборкаХарактерДеятельности = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаХарактерДеятельности.Следующий() Цикл
		
		ВыборкаДетальныеЗаписи = ВыборкаХарактерДеятельности.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СтрокаБлокировки	= ТаблицаБлокировки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаБлокировки, ВыборкаДетальныеЗаписи);
		КонецЦикла
		
	КонецЦикла;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ВидыДеятельностиПредпринимателей");
	ЭлементБлокировки.ИсточникДанных = ТаблицаБлокировки;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НоменклатурнаяГруппа", "НоменклатурнаяГруппа");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ХарактерДеятельности", "ХарактерДеятельности");
	Блокировка.Заблокировать();
	
	МенеджерЗаписиРегистра = РегистрыСведений.ВидыДеятельностиПредпринимателей.СоздатьМенеджерЗаписи();
	
	ВыборкаХарактерДеятельности = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаХарактерДеятельности.Следующий() Цикл
		
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Удалены номенклатурные группы характера деятельности ""%1""'"),
							ВыборкаХарактерДеятельности.ХарактерДеятельностиПредставление);

		ОповещенияПользователю.Добавить(ТекстОповещения);
		
		ВыборкаДетальныеЗаписи = ВыборкаХарактерДеятельности.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(МенеджерЗаписиРегистра, ВыборкаДетальныеЗаписи);
			МенеджерЗаписиРегистра.Прочитать();
			Если МенеджерЗаписиРегистра.Выбран() Тогда
				МенеджерЗаписиРегистра.Удалить();
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОповещенияПользователю;
	
КонецФункции

Функция ПолучитьВидДеятельности(ХарактерДеятельности, НоменклатурнаяГруппа) Экспорт
	Перем ВидДеятельности;
	
	Если НЕ ЗначениеЗаполнено(НоменклатурнаяГруппа)
		ИЛИ НЕ ЗначениеЗаполнено(ХарактерДеятельности) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос	= Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыДеятельностиПредпринимателей.ВидДеятельности КАК ВидДеятельности
		|ИЗ
		|	РегистрСведений.ВидыДеятельностиПредпринимателей КАК ВидыДеятельностиПредпринимателей
		|ГДЕ
		|	ВидыДеятельностиПредпринимателей.НоменклатурнаяГруппа = &НоменклатурнаяГруппа
		|	И ВидыДеятельностиПредпринимателей.ХарактерДеятельности = &ХарактерДеятельности";

	Запрос.УстановитьПараметр("ХарактерДеятельности",	ХарактерДеятельности);
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа",	НоменклатурнаяГруппа);

	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		Выборка	= Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ВидДеятельности	= Выборка.ВидДеятельности;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВидДеятельности;

КонецФункции

Функция ВидДеятельностиПоУмолчанию(Организация) Экспорт
	Перем ВидДеятельности;
	
	ХарактерДеятельности	= ХарактерДеятельностиПоУмолчанию();
	НоменклатурнаяГруппа	= НоменклатурнаяГруппаПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(ХарактерДеятельности)
		ИЛИ НЕ ЗначениеЗаполнено(НоменклатурнаяГруппа) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",			Организация);
	Запрос.УстановитьПараметр("ХарактерДеятельности",	ХарактерДеятельности);
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа",	НоменклатурнаяГруппа);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиУчетаНДФЛСрезПоследних.ОсновнойВидДеятельности КАК ВидДеятельности
		|ИЗ
		|	РегистрСведений.НастройкиУчетаНДФЛ.СрезПоследних(, Организация = &Организация) КАК НастройкиУчетаНДФЛСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыДеятельностиПредпринимателей.ВидДеятельности КАК ВидДеятельности
		|ИЗ
		|	РегистрСведений.ВидыДеятельностиПредпринимателей КАК ВидыДеятельностиПредпринимателей
		|ГДЕ
		|	ВидыДеятельностиПредпринимателей.НоменклатурнаяГруппа = &НоменклатурнаяГруппа
		|	И ВидыДеятельностиПредпринимателей.ХарактерДеятельности = &ХарактерДеятельности
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыДеятельностиПредпринимателей.Ссылка КАК ВидДеятельности
		|ИЗ
		|	Справочник.ВидыДеятельностиПредпринимателей КАК ВидыДеятельностиПредпринимателей
		|ГДЕ
		|	ВидыДеятельностиПредпринимателей.ХарактерДеятельности = &ХарактерДеятельности";
		
	Результаты	= Запрос.ВыполнитьПакет();
		
	Если НЕ Результаты[0].Пустой() Тогда
		
		// Найдена предыдущая учетная политика
		
		Выборка = Результаты[0].Выбрать();
		Если Выборка.Следующий() Тогда
			ВидДеятельности	= Выборка.ВидДеятельности;
		КонецЕсли;
		
	ИначеЕсли НЕ Результаты[1].Пустой() Тогда
		
		// Найдена подходящая запись регистра сведений
		
		Выборка = Результаты[1].Выбрать();
		Если Выборка.Следующий() Тогда
			ВидДеятельности	= Выборка.ВидДеятельности;
		КонецЕсли;
		
	Иначе
		
		Если НЕ Результаты[2].Пустой() Тогда
			
			// Найден подходящий элемент справочника видов деятельности
			
			Выборка = Результаты[2].Выбрать();
			Если Выборка.Следующий() Тогда
				ВидДеятельности	= Выборка.ВидДеятельности;
			КонецЕсли;
			
		КонецЕсли;
		
		НачатьТранзакцию();
		
		Попытка
			
			Если ВидДеятельности = Неопределено Тогда
				
				НовыйЭлемент	= Справочники.ВидыДеятельностиПредпринимателей.СоздатьЭлемент();
				НовыйЭлемент.Наименование			= Строка(ХарактерДеятельности);
				НовыйЭлемент.НаименованиеПолное		= Строка(ХарактерДеятельности);
				НовыйЭлемент.ХарактерДеятельности	= ХарактерДеятельности;
				НовыйЭлемент.НоменклатурнаяГруппа	= НоменклатурнаяГруппа;
				НовыйЭлемент.Записать();
				
				ВидДеятельности	= НовыйЭлемент.Ссылка;
				
			КонецЕсли;
			
			МенеджерЗаписиРегистра = РегистрыСведений.ВидыДеятельностиПредпринимателей.СоздатьМенеджерЗаписи();
			МенеджерЗаписиРегистра.НоменклатурнаяГруппа	= НоменклатурнаяГруппа;
			МенеджерЗаписиРегистра.ХарактерДеятельности	= ХарактерДеятельности;
			МенеджерЗаписиРегистра.ВидДеятельности		= ВидДеятельности;
			МенеджерЗаписиРегистра.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ВидДеятельности	= Неопределено;
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если ИнформацияОбОшибке.Причина = Неопределено Тогда
				ОписаниеОшибки = ИнформацияОбОшибке.Описание;
			Иначе
				ОписаниеОшибки = ИнформацияОбОшибке.Причина.Описание;
			КонецЕсли;
			
			ОписаниеОшибки = НСтр("ru = 'Ошибка при записи вида деятельности:'") + Символы.ПС + ОписаниеОшибки;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ВидДеятельности;
	
КонецФункции

Функция ХарактерДеятельностиПоУмолчанию()

	Возврат Перечисления.ХарактерДеятельности.ОптоваяТорговля;

КонецФункции

Функция НоменклатурнаяГруппаПоУмолчанию()
	Перем НоменклатурнаяГруппа;
	
	НаименованиеОсновнойНоменклатурнойГруппы	= НСтр("ru = 'Основная номенклатурная группа'");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаименованиеОсновнойНоменклатурнойГруппы", НаименованиеОсновнойНоменклатурнойГруппы);
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НоменклатурныеГруппы.Ссылка КАК НоменклатурнаяГруппа,
		|	"""" КАК Код
		|ИЗ
		|	Справочник.НоменклатурныеГруппы КАК НоменклатурныеГруппы
		|ГДЕ
		|	НЕ НоменклатурныеГруппы.ПометкаУдаления
		|	И НЕ НоменклатурныеГруппы.ЭтоГруппа
		|	И НоменклатурныеГруппы.Наименование = &НаименованиеОсновнойНоменклатурнойГруппы
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	НоменклатурныеГруппы.Ссылка,
		|	НоменклатурныеГруппы.Код
		|ИЗ
		|	Справочник.НоменклатурныеГруппы КАК НоменклатурныеГруппы
		|ГДЕ
		|	НЕ НоменклатурныеГруппы.ПометкаУдаления
		|	И НЕ НоменклатурныеГруппы.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			НоменклатурнаяГруппа	= Выборка.НоменклатурнаяГруппа;
		КонецЕсли;
		
	Иначе
		
		НовыйЭлемент	= Справочники.НоменклатурныеГруппы.СоздатьЭлемент();
		НовыйЭлемент.Наименование	= НаименованиеОсновнойНоменклатурнойГруппы;
		
		Попытка
			НовыйЭлемент.Записать();
			НоменклатурнаяГруппа	= НовыйЭлемент.Ссылка;
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если ИнформацияОбОшибке.Причина = Неопределено Тогда
				ОписаниеОшибки = ИнформацияОбОшибке.Описание;
			Иначе
				ОписаниеОшибки = ИнформацияОбОшибке.Причина.Описание;
			КонецЕсли;
			
			ОписаниеОшибки = НСтр("ru = 'Ошибка при записи номенклатурной группы:'") + Символы.ПС + ОписаниеОшибки;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат НоменклатурнаяГруппа;
	
КонецФункции

// Функция возвращает первую номенклатурную группу для
// вида деятельности, для использования в качестве основной
//
Функция ПолучитьПервуюНоменклатурнуюГруппу(ВидДеятельности, ХарактерДеятельности) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидДеятельности)
		ИЛИ НЕ ЗначениеЗаполнено(ХарактерДеятельности) Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыДеятельностиПредпринимателей.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
		|ИЗ
		|	РегистрСведений.ВидыДеятельностиПредпринимателей КАК ВидыДеятельностиПредпринимателей
		|ГДЕ
		|	ВидыДеятельностиПредпринимателей.ВидДеятельности = &ВидДеятельности
		|	И ВидыДеятельностиПредпринимателей.ХарактерДеятельности = &ХарактерДеятельности";

	Запрос.УстановитьПараметр("ВидДеятельности",      ВидДеятельности);
	Запрос.УстановитьПараметр("ХарактерДеятельности", ХарактерДеятельности);

	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ПерваяНоменклатурнаяГруппа = Выборка.НоменклатурнаяГруппа;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПерваяНоменклатурнаяГруппа;

КонецФункции

#КонецЕсли