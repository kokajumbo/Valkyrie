#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда	

#Область СлужебныеПроцедурыИФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если МассивОбъектов.Количество() < 1 Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДокументыДляПечати(МассивОбъектов);

	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	// Проверяем, нужно ли для макета РасчетСреднегоЗаработка формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработка") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ТабличныйДокумент = ПолучитьТабличныйДокумент(МассивОбъектов, ОбъектыПечати, "РасчетСреднегоЗаработка");
		Если НЕ ТабличныйДокумент = Неопределено Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработка", НСтр("ru='Расчет среднего заработка'"), ТабличныйДокумент);
		КонецЕсли;
	КонецЕсли;
	
	// Проверяем, нужно ли для макета РасчетСреднегоЗаработкаВыходногоПособия формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработкаВыходногоПособия") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ТабличныйДокумент = ПолучитьТабличныйДокумент(МассивОбъектов, ОбъектыПечати, "РасчетСреднегоЗаработкаВыходногоПособия");
		Если НЕ ТабличныйДокумент = Неопределено Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработкаВыходногоПособия", НСтр("ru='Расчет среднего заработка (для выходного пособия)'"), ТабличныйДокумент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

// Функция возвращает табличный документ - печатную форму расчета среднего заработка.
Функция ПолучитьТабличныйДокумент(МассивСсылок, ОбъектыПечати, ИмяМакета)
	
	// Разделим массив ссылок по типам: создадим соответствие менеджеров объектов и ссылок относящихся к ним.
	// Также в соответствие поместим описание документа рассчитывающего средний заработок.
	МенеджерыДанныхСреднегоЗаработка = МенеджерыДанныхСреднегоЗаработка(МассивСсылок, ИмяМакета);
	
	Возврат ТабличныйДокументРасчетаСреднегоЗаработка(МенеджерыДанныхСреднегоЗаработка, ОбъектыПечати, ИмяМакета);
	
КонецФункции

// Функция возвращает соответствие менеджеров объектов и относящихся к ним ссылок.
// Также в итоговом соответствии заполняются описания документов рассчитывающих средний заработок.
//
Функция МенеджерыДанныхСреднегоЗаработка(МассивСсылок, ИмяМакета)
	МенеджерыДанныхСреднегоЗаработка = Новый Соответствие;
	
	Для каждого Ссылка Из МассивСсылок Цикл
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
		
		ОписаниеМенеджера = МенеджерыДанныхСреднегоЗаработка.Получить(Менеджер);
		
		Если ОписаниеМенеджера = Неопределено Тогда
			ОписаниеДокумента = ОписаниеДокументаРассчитывающегоСреднийЗаработок(Менеджер, ИмяМакета);
			МенеджерыДанныхСреднегоЗаработка.Вставить(Менеджер, Новый Структура("Менеджер,ОписаниеДокумента,МассивСсылок", Менеджер, ОписаниеДокумента, Новый Массив));
			ОписаниеМенеджера = МенеджерыДанныхСреднегоЗаработка.Получить(Менеджер);
		КонецЕсли;
		
		ОписаниеМенеджера.МассивСсылок.Добавить(Ссылка);
		
	КонецЦикла;
	
	Возврат МенеджерыДанныхСреднегоЗаработка;
	
КонецФункции

// Функция возвращает структуру - описание документа для формирования печатной формы расчета среднего заработка.
// Структура возвращается заполненной по данным менеджера.
//
Функция ОписаниеДокументаРассчитывающегоСреднийЗаработок(Менеджер, ИмяМакета)
	ОписаниеДокумента = Новый Структура;
	ОписаниеДокумента.Вставить("Менеджер", 						Менеджер);
	ОписаниеДокумента.Вставить("ИмяДокумента", 					"");
	ОписаниеДокумента.Вставить("СинонимДокумента", 				"");
	ОписаниеДокумента.Вставить("СреднийЗаработокОбщий", 		Истина);
	ОписаниеДокумента.Вставить("ДанныеОЗаработкеВДокументе", 	Истина);
	ОписаниеДокумента.Вставить("ВыводитьЗаголовок", 			Истина);
	ОписаниеДокумента.Вставить("ЕстьНачислениеВТабличнойЧасти", Истина);

	Менеджер.ЗаполнитьОписаниеДокументаРассчитывающегоСреднийЗаработок(ОписаниеДокумента, ИмяМакета);
	
	Возврат ОписаниеДокумента;
КонецФункции

// Функция возвращает табличный документ - печатную форму расчета среднего заработка.
// Табличный документ формируется по переданному описанию.
//
Функция ТабличныйДокументРасчетаСреднегоЗаработка(МенеджерыДанныхСреднегоЗаработка, ОбъектыПечати, ИмяМакета)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасчетСреднегоЗаработка";
	
	МассивОписанийМенеджеровОбщегоСреднего 	= Новый Массив;
	
	ПолныйМассивСотрудников = Новый Массив;
	
	Для каждого ОписаниеМенеджера Из МенеджерыДанныхСреднегоЗаработка Цикл
		
		// Для документов рассчитывающих общий средний заработок можно печатать разные печатные формы("бюджетную", отдельно
		// для выходного пособия и т.п.), а для тех, которые считают средний заработок ФСС - можно печатать только
		// стандартную печатную форму(макет "РасчетСреднегоЗаработка"), поэтому если документ считает средний заработок ФСС и
		// хочет напечатать нестандартную печатную форму - пропустим его.
		Если ОписаниеМенеджера.Значение.ОписаниеДокумента.СреднийЗаработокОбщий Тогда
			
			// Получим данные для всех документов относящихся к текущему менеджеру.
			ДанныеДокументов = ДанныеДокументовРасчетаСреднегоЗаработка(ОписаниеМенеджера.Значение.Менеджер, ОписаниеМенеджера.Значение.МассивСсылок, ИмяМакета);
			ОписаниеМенеджера.Значение.Вставить("ДанныеДокументов", ДанныеДокументов);
			
			// Для получения кадровых данных одним запросом по всем сотрудникам - соберем их в отдельный массив.
			Для каждого ДанныеДокумента Из ДанныеДокументов Цикл
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПолныйМассивСотрудников, ДанныеДокумента.МассивСотрудников);
			КонецЦикла;
			
			МассивОписанийМенеджеровОбщегоСреднего.Добавить(ОписаниеМенеджера.Значение);
			
		КонецЕсли;	
	КонецЦикла;

	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ПолныйМассивСотрудников, "ФизическоеЛицо,ФИОПолные,ТабельныйНомер,Подразделение,Должность,ВидЗанятости", '00010101000000');
	
	ПервыйДокумент = Истина;
	Для каждого ОписаниеМенеджера Из МассивОписанийМенеджеровОбщегоСреднего Цикл
		
		Для каждого Ссылка Из ОписаниеМенеджера.МассивСсылок Цикл
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			Иначе
				ПервыйДокумент = Ложь;
			КонецЕсли;
			
			ДанныеДокумента 				= ОписаниеМенеджера.ДанныеДокументов.Найти(Ссылка, "Ссылка");
			ТаблицыДанныхОСреднемЗаработке 	= ТаблицыДанныхОСреднемЗаработке(ОписаниеМенеджера.ОписаниеДокумента, ДанныеДокумента);
			
			ДанныеДляПечати = Новый Структура;
			ДанныеДляПечати.Вставить("ДанныеДокумента", 				ДанныеДокумента);						
			ДанныеДляПечати.Вставить("ДанныеСотрудников", 				КадровыеДанныеСотрудников);
			ДанныеДляПечати.Вставить("ТаблицыДанныхОСреднемЗаработке", 	ТаблицыДанныхОСреднемЗаработке);
			ДанныеДляПечати.Вставить("Ссылка", 							Ссылка);
			ДанныеДляПечати.Вставить("СинонимДокумента", 				ОписаниеМенеджера.ОписаниеДокумента.СинонимДокумента);
			ДанныеДляПечати.Вставить("ВыводитьЗаголовок", 				ОписаниеМенеджера.ОписаниеДокумента.ВыводитьЗаголовок);

			ЗаполнитьТабличныйДокументРасчетаСреднегоЗаработкаОбщий(ДанныеДляПечати, ОбъектыПечати, ИмяМакета, ТабличныйДокумент);			
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции 	

// Функция возвращает структуру - результат выполнения пакета запросов с данными о заработке в документах.
//
Функция ТаблицыДанныхОСреднемЗаработке(ОписаниеДокумента, ДанныеДокумента) 

	ТекстЗапроса = ТекстЗапросаТаблицСреднегоОбщего(ОписаниеДокумента);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДанныеДокумента.Ссылка);
	
	ТаблицыДанныхОСреднемЗаработке = Запрос.ВыполнитьПакет();
	
	ДанныеОНачислениях 	= ТаблицыДанныхОСреднемЗаработке[0].Выгрузить();
	ДанныеВремени 		= ТаблицыДанныхОСреднемЗаработке[1].Выгрузить();
	Если ОписаниеДокумента.СреднийЗаработокОбщий Тогда
		ДанныеДляРасчета = Новый Структура("ДанныеОНачислениях,ДанныеОВремени", ДанныеОНачислениях, ДанныеВремени);
	Иначе
		ДанныеДляРасчета = Новый Структура("ДанныеОНачислениях,ДанныеОВремени", ДанныеОНачислениях, ДанныеВремени);
	КонецЕсли;

	Возврат ДанныеДляРасчета
	
КонецФункции 

#КонецОбласти

#Область СреднийОбщий

// Функция возвращает табличный документ - печатную форму расчета среднего заработка, 
// для документов использующих расчет среднего заработка по общим правилам.
Процедура ЗаполнитьТабличныйДокументРасчетаСреднегоЗаработкаОбщий(ДанныеДляПечати, ОбъектыПечати, ИмяМакета, ТабличныйДокумент)
	
	ДанныеДокумента 				= ДанныеДляПечати.ДанныеДокумента;
	ДанныеСотрудников 				= ДанныеДляПечати.ДанныеСотрудников;
	
	ПервыйПриказ = Истина;
	ДобавлятьГруппировкуПоСотрудникам = ДанныеДокумента.МассивСотрудников.Количество() > 1;	
	
	ЗначенияПараметров = Новый Структура;
	ОтборСотрудник = Новый Структура("Сотрудник");
	
	Для Каждого Сотрудник Из ДанныеДокумента.МассивСотрудников Цикл
		
		ДанныеСотрудника 	= ДанныеСотрудников.Найти(Сотрудник, "Сотрудник"); 
		ОписаниеСотрудника 	= ДанныеДокумента.ОписанияСотрудников.Получить(Сотрудник);
		ОтборСотрудник.Вставить("Сотрудник", Сотрудник);
		
		ТаблицыПоСотруднику = ТаблицыДанныхОСреднемЗаработкеПоСотруднику(Сотрудник, ДанныеДляПечати.ТаблицыДанныхОСреднемЗаработке);
		
		ПараметрыПолученияДанныхСреднего = РасчетЗарплатыДляНебольшихОрганизаций.ПараметрыПолученияДанныхСреднегоОбщего();
		ПараметрыПолученияДанныхСреднего.Вставить("ТаблицыПоСотруднику", 	ТаблицыПоСотруднику); 
		ПараметрыПолученияДанныхСреднего.Вставить("ДатаНачалаПериода",  	ДанныеДокумента.НачалоРасчетногоПериода); 
		ПараметрыПолученияДанныхСреднего.Вставить("ДатаОкончанияПериода",	ДанныеДокумента.ОкончаниеРасчетногоПериода); 
		ПараметрыПолученияДанныхСреднего.Вставить("ДатаНачалаСобытия", 		ДанныеДокумента.ДатаНачалаСобытия);		
		
		ДанныеРасчетаСреднегоЗаработка = РасчетЗарплатыДляНебольшихОрганизаций.ДанныеРасчетаСреднегоЗаработкаОбщего(ПараметрыПолученияДанныхСреднего);

		// Подготовим макеты для формирования табличного документа.
		ОбластиМакета = ОбластиМакетаСреднегоЗаработкаОбщий();
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		Если Не ПервыйПриказ Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйПриказ = Ложь;
		КонецЕсли;
		
		Если ДанныеДляПечати.ВыводитьЗаголовок Тогда
			// Заполним шапку документа
			ЗначенияПараметров.Очистить();
			ЗначенияПараметров.Вставить("СинонимДокумента", 				ДанныеДляПечати.СинонимДокумента);
			ЗначенияПараметров.Вставить("НомерДокумента", 					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.НомерДокумента, Истина, Истина));
			ЗначенияПараметров.Вставить("ДатаДокумента", 					Формат(ДанныеДокумента.ДатаДокумента, "ДЛФ=DD"));
			ЗначенияПараметров.Вставить("Ссылка", 							ДанныеДляПечати.Ссылка);                                                                                                                         
			ЗначенияПараметров.Вставить("НаименованиеОрганизации", 			ДанныеДокумента.НаименованиеОрганизации);
			ЗначенияПараметров.Вставить("Организация", 						ДанныеДокумента.Организация);
			ЗначенияПараметров.Вставить("ФИОРаботника", 					ДанныеСотрудника.ФИОПолные);
			ЗначенияПараметров.Вставить("ТабельныйНомер", 					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеСотрудника.ТабельныйНомер, Истина, Истина));
			ЗначенияПараметров.Вставить("Сотрудник", 						Сотрудник);
			ЗначенияПараметров.Вставить("ДатаНачалаРасчетногоПериода", 		Формат(ДанныеДокумента.НачалоРасчетногоПериода,"ДЛФ=D"));
			ЗначенияПараметров.Вставить("ДатаОкончанияРасчетногоПериода", 	Формат(ДанныеДокумента.ОкончаниеРасчетногоПериода,"ДЛФ=D"));
			ЗначенияПараметров.Вставить("СпособРасчета", 					?(ЗначениеЗаполнено(ДанныеДокумента.СпособРасчета), ДанныеДокумента.СпособРасчета, НСтр("ru='Общий средний заработок'")));
			
			ЗначенияПараметров.Вставить("ВидЗанятости", 					ДанныеСотрудника.ВидЗанятости);
			ЗначенияПараметров.Вставить("Подразделение", 					ДанныеСотрудника.Подразделение);
			ЗначенияПараметров.Вставить("Должность", 						ДанныеСотрудника.Должность);		
			ЗначенияПараметров.Вставить("ДатаНачалаОтсутствия", 			Формат(ДанныеДокумента.ДатаНачалаОтсутствия, "ДЛФ=D"));
			ЗначенияПараметров.Вставить("ДатаОкончанияОтсутствия", 			Формат(ДанныеДокумента.ДатаОкончанияОтсутствия, "ДЛФ=D"));
			
			ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияШапка.Параметры, ЗначенияПараметров);
			ТабличныйДокумент.Вывести(ОбластиМакета.СекцияШапка);
		КонецЕсли;
		
		// Уточним названия колонок и показателей.
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("ЕдиницаИзмеренияВремени", "дней"); 
		ЗначенияПараметров.Вставить("ОписаниеЗаработка", "Среднедневной");

		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОтработанноеВремяШапка.Параметры, 	ЗначенияПараметров);
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияРасчетСреднегоЗаработка.Параметры, ЗначенияПараметров);
		
		НомерРаздела = 1;
		
		УстановитьНомерРазделаВОбласти(НомерРаздела, ОбластиМакета.СекцияЗаработокШапка, ЗначенияПараметров);
		
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияЗаработокШапка);
		Для каждого СтрокаЗаработка Из ДанныеРасчетаСреднегоЗаработка.Заработок Цикл
			ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияЗаработокСтрока.Параметры, СтрокаЗаработка);
			ЗначенияПараметров.Очистить();
			ЗначенияПараметров.Вставить("Месяц", Формат(СтрокаЗаработка.Месяц, "ДФ='MMMM yyyy'"));
			ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияЗаработокСтрока.Параметры, ЗначенияПараметров);
			ТабличныйДокумент.Вывести(ОбластиМакета.СекцияЗаработокСтрока);
		КонецЦикла;
		
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("Учтено", ДанныеРасчетаСреднегоЗаработка.Заработок.Итог("Учтено"));
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияЗаработокПодвал.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияЗаработокПодвал);
		
		УстановитьНомерРазделаВОбласти(НомерРаздела, ОбластиМакета.СекцияОтработанноеВремяШапка, ЗначенияПараметров);
		
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияОтработанноеВремяШапка);
		Для каждого СтрокаОтработанноеВремя Из ДанныеРасчетаСреднегоЗаработка.ОтработанноеВремя Цикл
			ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОтработанноеВремяСтрока.Параметры, СтрокаОтработанноеВремя);
			ЗначенияПараметров.Очистить();
			ЗначенияПараметров.Вставить("Месяц", Формат(СтрокаОтработанноеВремя.Месяц, "ДФ='MMMM yyyy'"));
			ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОтработанноеВремяСтрока.Параметры, ЗначенияПараметров);
			ТабличныйДокумент.Вывести(ОбластиМакета.СекцияОтработанноеВремяСтрока);
		КонецЦикла;
		
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("КалендарныхДней", 	ДанныеРасчетаСреднегоЗаработка.Итоги["ВсегоКалендарныхДней"]);
		ЗначенияПараметров.Вставить("Учтено", 			ДанныеРасчетаСреднегоЗаработка.Итоги["ВсегоДнейЧасов"]);
		
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОтработанноеВремяПодвал.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияОтработанноеВремяПодвал);
		
		УстановитьНомерРазделаВОбласти(НомерРаздела, ОбластиМакета.СекцияРасчетСреднегоЗаработка, ЗначенияПараметров);
		
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("УчтеноЗаработок", 			ДанныеРасчетаСреднегоЗаработка.Итоги["ВсегоЗаработка"]); 
		ЗначенияПараметров.Вставить("УчтеноДней", 				ДанныеРасчетаСреднегоЗаработка.Итоги["ВсегоДнейЧасов"]); 
		ЗначенияПараметров.Вставить("СреднедневнойЗаработок",	ДанныеРасчетаСреднегоЗаработка.Итоги["СреднедневнойЗаработок"]); 
														
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияРасчетСреднегоЗаработка.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияРасчетСреднегоЗаработка);
				
		Если ДобавлятьГруппировкуПоСотрудникам Тогда
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Сотрудник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

Функция ДанныеДокументовРасчетаСреднегоЗаработка(Менеджер, МассивСсылок, ИмяМакета) 
	
	ДанныеДокументов = Новый ТаблицаЗначений;
	ДанныеДокументов.Колонки.Добавить("Ссылка");
	ДанныеДокументов.Колонки.Добавить("Организация");
	ДанныеДокументов.Колонки.Добавить("НаименованиеОрганизации");
	ДанныеДокументов.Колонки.Добавить("КодПоОКПО");
	ДанныеДокументов.Колонки.Добавить("НачалоРасчетногоПериода");
	ДанныеДокументов.Колонки.Добавить("ОкончаниеРасчетногоПериода");
	ДанныеДокументов.Колонки.Добавить("ДатаНачалаСобытия");
	ДанныеДокументов.Колонки.Добавить("НомерДокумента");
	ДанныеДокументов.Колонки.Добавить("ДатаДокумента");
	ДанныеДокументов.Колонки.Добавить("Начисление");
	ДанныеДокументов.Колонки.Добавить("МассивСотрудников"); 
	ДанныеДокументов.Колонки.Добавить("ОписанияСотрудников"); 
	ДанныеДокументов.Колонки.Добавить("СпособРасчета");
	ДанныеДокументов.Колонки.Добавить("ДатаНачалаОтсутствия");
	ДанныеДокументов.Колонки.Добавить("ДатаОкончанияОтсутствия");
	ДанныеДокументов.Колонки.Добавить("ПериодРегистрации");
	ДанныеДокументов.Колонки.Добавить("НачалоПериодаЗаКоторыйПредоставляетсяОтпуск");
	ДанныеДокументов.Колонки.Добавить("КонецПериодаЗаКоторыйПредоставляетсяОтпуск");
	ДанныеДокументов.Колонки.Добавить("ДнейОсновногоОтпуска");
	ДанныеДокументов.Колонки.Добавить("ДнейДополнительногоОтпуска");
	ДанныеДокументов.Колонки.Добавить("ДнейОтпускаВсего");
	ДанныеДокументов.Колонки.Добавить("ГлавныйБухгалтерРасшифровкаПодписи");
	ДанныеДокументов.Колонки.Добавить("БухгалтерРасшифровкаПодписи");
	ДанныеДокументов.Колонки.Добавить("ИсполнительРасшифровкаПодписи");
	ДанныеДокументов.Колонки.Добавить("ДолжностьИсполнителя");
	
	Менеджер.ЗаполнитьДанныеДокументовДляПечатиРасчетаСреднегоЗаработка(МассивСсылок, ДанныеДокументов, ИмяМакета);
	
	РеквизитыОрганизаций = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ДанныеДокументов.ВыгрузитьКолонку("Организация"), "КодПоОКПО,НаименованиеПолное,Наименование");
	Для каждого ДанныеДокумента Из ДанныеДокументов Цикл
		РеквизитыОрганизации = РеквизитыОрганизаций.Получить(ДанныеДокумента.Организация);
		
		ДанныеДокумента.КодПоОКПО = РеквизитыОрганизации.КодПоОКПО;
		Если ЗначениеЗаполнено(РеквизитыОрганизации.НаименованиеПолное) Тогда              
			ДанныеДокумента.НаименованиеОрганизации = РеквизитыОрганизации.НаименованиеПолное;
		Иначе 
			ДанныеДокумента.НаименованиеОрганизации = РеквизитыОрганизации.Наименование;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат ДанныеДокументов;

КонецФункции

Функция ТекстЗапросаТаблицСреднегоОбщего(ОписаниеДокумента)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДокументДанныеОЗаработке.Сотрудник,
		|	ДокументДанныеОЗаработке.Период,
		|	ДокументДанныеОЗаработке.Сумма
		|ИЗ
		|	Документ.#ИмяДокумента#.СреднийЗаработокОбщий КАК ДокументДанныеОЗаработке
		|ГДЕ
		|	ДокументДанныеОЗаработке.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументОтработанноеВремя.Сотрудник,
		|	ДокументОтработанноеВремя.Период,
		|	ДокументОтработанноеВремя.ОтработаноДнейКалендарных
		|ИЗ
		|	Документ.#ИмяДокумента#.ОтработанноеВремяДляСреднегоОбщий КАК ДокументОтработанноеВремя
		|ГДЕ
		|	ДокументОтработанноеВремя.Ссылка = &Ссылка";
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяДокумента#", ОписаниеДокумента.ИмяДокумента);	
	
	Возврат ТекстЗапроса;
	
КонецФункции	
	
Функция ОбластиМакетаСреднегоЗаработкаОбщий()
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьРасчетаСреднегоЗаработка.ПФ_MXL_РасчетСреднегоЗаработка");
	
	ОбластиМакета = Новый Структура;
	
	ОбластиМакета.Вставить("СекцияШапка", 							Макет.ПолучитьОбласть("Шапка"));
	ОбластиМакета.Вставить("СекцияЗаработокШапка", 					Макет.ПолучитьОбласть("ЗаработокШапкаБезИндексации"));
	ОбластиМакета.Вставить("СекцияЗаработокСтрока",					Макет.ПолучитьОбласть("ЗаработокСтрокаБезИндексации"));
	ОбластиМакета.Вставить("СекцияЗаработокПодвал",					Макет.ПолучитьОбласть("ЗаработокПодвалБезИндексации"));
	ОбластиМакета.Вставить("СекцияОтработанноеВремяШапка",  		Макет.ПолучитьОбласть("ОтработанноеВремяШапка"));
	ОбластиМакета.Вставить("СекцияОтработанноеВремяСтрока",  		Макет.ПолучитьОбласть("ОтработанноеВремяСтрока"));
	ОбластиМакета.Вставить("СекцияОтработанноеВремяПодвал",  		Макет.ПолучитьОбласть("ОтработанноеВремяПодвал"));
	ОбластиМакета.Вставить("СекцияДоляВремени",  					Макет.ПолучитьОбласть("ДоляВремени"));
	ОбластиМакета.Вставить("СекцияПрочееШапка",  					Макет.ПолучитьОбласть("ПрочееШапка"));
	ОбластиМакета.Вставить("СекцияПрочееСтрока",  					Макет.ПолучитьОбласть("ПрочееСтрока"));
	ОбластиМакета.Вставить("СекцияПрочееПодвал",  					Макет.ПолучитьОбласть("ПрочееПодвал"));
	ОбластиМакета.Вставить("СекцияРасчетСреднегоЗаработка",  		Макет.ПолучитьОбласть("РасчетСреднегоЗаработка"));
	
	Возврат ОбластиМакета;	
	
КонецФункции 

Процедура УстановитьНомерРазделаВОбласти(НомерРаздела, Область, ЗначенияПараметров)
	ЗначенияПараметров.Очистить();
	ЗначенияПараметров.Вставить("НомерРаздела", НомерРаздела);
	ЗаполнитьЗначенияСвойств(Область.Параметры, ЗначенияПараметров);
	НомерРаздела = НомерРаздела + 1;
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Функция ТаблицыДанныхОСреднемЗаработкеПоСотруднику(Сотрудник, ТаблицыДанныхОСреднемЗаработке)
	
	Отбор = Новый Структура("Сотрудник", Сотрудник);
	
	ТаблицыНачислений 	= ТаблицыДанныхОСреднемЗаработке["ДанныеОНачислениях"];
	ТаблицыВремени 		= ТаблицыДанныхОСреднемЗаработке["ДанныеОВремени"];

	СтрокиТаблицыНачислений = ТаблицыНачислений.НайтиСтроки(Отбор);
	СтрокиТаблицыВремени 	= ТаблицыВремени.НайтиСтроки(Отбор); 
	
	Если СтрокиТаблицыНачислений.Количество() > 0 Тогда
		ТаблицаНачислений = ТаблицыНачислений.Скопировать(СтрокиТаблицыНачислений);
	Иначе 	
		ТаблицаНачислений = ТаблицыНачислений.СкопироватьКолонки();
	КонецЕсли;
	
	Если СтрокиТаблицыВремени.Количество() > 0 Тогда
		ТаблицаВремени = ТаблицыВремени.Скопировать(СтрокиТаблицыВремени);
	Иначе 	
		ТаблицаВремени = ТаблицыВремени.СкопироватьКолонки();
	КонецЕсли;
	
	Возврат Новый Структура("ДанныеОНачислениях, ДанныеОВремени", ТаблицаНачислений, ТаблицаВремени);
	
КонецФункции

#Область ИменованиеОбластейДляНавигацииПоТабличномуДокументу

// Задает область печати объекта в табличном документе.
// Применяется для связывания области в табличном документе, с объектом печати (ссылка).
// Необходимо вызывать при формировании очередной области печатной формы в табличном
// документе.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент - печатная форма;
//  НомерСтрокиНачало - Число - позиция начала очередной области в документе;
//  ОбъектыПечати - СписокЗначений - список объектов печати;
//  Ссылка - ЛюбаяСсылка - объект печати.
Процедура ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка, Сотрудник) Экспорт
	
	Если ТипЗнч(ОбъектыПечати) = Тип("СписокЗначений") Тогда
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
	Иначе
		ЗадатьОбластьПечатиВстраиваемойОбласти(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка, Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбъектыПечатиДляВстраиваемыхОбластей() Экспорт
	ОбъектыПечати = Новый ТаблицаЗначений;
	ОбъектыПечати.Колонки.Добавить("Ссылка");
	ОбъектыПечати.Колонки.Добавить("Сотрудник");
	ОбъектыПечати.Колонки.Добавить("ИмяОбласти");
	Возврат ОбъектыПечати;
КонецФункции 

Функция ИмяВстраиваемойОбласти(ОбъектыПечати, Ссылка, Сотрудник = Неопределено) Экспорт
	
	ИмяВстраиваемойОбласти = Неопределено;
	ВстраиваемаяОбласть = ВстраиваемаяОбласть(ОбъектыПечати, Ссылка, Сотрудник);
	Если НЕ ВстраиваемаяОбласть = Неопределено Тогда
	   ИмяВстраиваемойОбласти = ВстраиваемаяОбласть.ИмяОбласти;
	КонецЕсли;
	
	Возврат ИмяВстраиваемойОбласти;
	
КонецФункции

Процедура ЗадатьОбластьПечатиВстраиваемойОбласти(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка, Сотрудник)
	
	Элемент = ВстраиваемаяОбласть(ОбъектыПечати, Ссылка, Сотрудник);
	Если Элемент = Неопределено Тогда
		Элемент = НоваяВстраиваемаяОбласть(ОбъектыПечати, Ссылка, Сотрудник);
		Элемент.ИмяОбласти = "Документ_" + Формат(ОбъектыПечати.Количество() + 1, "ЧН=; ЧГ=");
	КонецЕсли;
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = Элемент.ИмяОбласти;		
	
КонецПроцедуры

Функция ВстраиваемаяОбласть(ОбъектыПечати, Ссылка, Сотрудник = Неопределено)
	
	ВстраиваемаяОбласть = Неопределено;
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат ВстраиваемаяОбласть;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Ссылка", Ссылка);
	Если НЕ Сотрудник = Неопределено Тогда
		Отбор.Вставить("Сотрудник", Сотрудник);
	КонецЕсли;
	
	СтрокиПоОтбору = ОбъектыПечати.НайтиСтроки(Отбор);
	Если СтрокиПоОтбору.Количество() > 0 Тогда
		ВстраиваемаяОбласть = СтрокиПоОтбору[0];
	КонецЕсли;
	
	Возврат ВстраиваемаяОбласть;

КонецФункции

Функция НоваяВстраиваемаяОбласть(ОбъектыПечати, Ссылка, Сотрудник)
	НоваяВстраиваемаяОбласть = ОбъектыПечати.Добавить();
	НоваяВстраиваемаяОбласть.Ссылка = Ссылка;
	НоваяВстраиваемаяОбласть.Сотрудник = Сотрудник;
	Возврат НоваяВстраиваемаяОбласть;	
КонецФункции

#КонецОбласти

Процедура ПроверитьДокументыДляПечати(МассивОбъектов)
	
	МассивПроверенныхДокументов = Новый Массив;
	Для Каждого ПроверяемыйДокумент ИЗ МассивОбъектов Цикл
		ДокументОбъект = ПроверяемыйДокумент.ПолучитьОбъект();
		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
			МассивПроверенныхДокументов.Добавить(ПроверяемыйДокумент);
		КонецЕсли;
	КонецЦикла;
	
	МассивОбъектов = МассивПроверенныхДокументов;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли