#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЭтоПредприниматель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Отдельные проверки для раздела Запасы
	ВедетсяСкладскойУчет = Истина;
	БУ = ПланыСчетов.Хозрасчетный.Товары.ПолучитьОбъект();
	Если БУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады, "ВидСубконто") = Неопределено Тогда
		ВедетсяСкладскойУчет = Ложь;
	КонецЕсли;
	Если ВедетсяСкладскойУчет Тогда
		ВедетсяСкладскойУчет  = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладовБухгалтерскийУчет");
	КонецЕсли;
	
	Если НЕ ВедетсяСкладскойУчет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Запасы.Склад");
	КонецЕсли;
	
	// Отдельные проверки для раздела Основные средства
	Ошибки = Неопределено;
	ИмяТабличнойЧасти = "ОсновныеСредства";
	ТабличнаяЧасть = ЭтотОбъект[ИмяТабличнойЧасти];
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	Для Каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		ИндексСтроки = ТабличнаяЧасть.Индекс(ТекущаяСтрока);
		НомерСтроки  = ИндексСтроки+1;
		МассивДублей = ТабличнаяЧасть.НайтиСтроки(Новый Структура("ОсновноеСредство", ТекущаяСтрока.ОсновноеСредство));
		Если МассивДублей.Количество() > 1 Тогда
			ШаблонСообщенияОбОшибке = НСтр("ru = 'Основное средство %1 повторяется в строках %2.'");
			НомераСтрок = "";
			Для Каждого СтрокаМассива ИЗ МассивДублей Цикл
				НомераСтрок = НомераСтрок + ", " + Формат(СтрокаМассива.НомерСтроки, "ЧГ=");
			КонецЦикла;
			НомераСтрок = Сред(НомераСтрок, 3);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщенияОбОшибке, ТекущаяСтрока.ОсновноеСредство, НомераСтрок);
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА","КОРРЕКТНОСТЬ", "Основное средство", НомерСтроки, "Основные средства", ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ОсновныеСредства[%1].ОсновноеСредство",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
	// Отдельные проверки для раздела Нематериальные активы
	Ошибки = Неопределено;
	ИмяТабличнойЧасти = "НематериальныеАктивы";
	ТабличнаяЧасть = ЭтотОбъект[ИмяТабличнойЧасти];
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	Для Каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		ИндексСтроки = ТабличнаяЧасть.Индекс(ТекущаяСтрока);
		НомерСтроки  = ИндексСтроки+1;
		МассивДублей = ТабличнаяЧасть.НайтиСтроки(Новый Структура("НематериальныйАктив", ТекущаяСтрока.НематериальныйАктив));
		Если МассивДублей.Количество() > 1 Тогда
			ШаблонСообщенияОбОшибке = НСтр("ru = 'Нематериальный актив %1 повторяется в строках %2.'");
			НомераСтрок = "";
			Для Каждого СтрокаМассива ИЗ МассивДублей Цикл
				НомераСтрок = НомераСтрок + ", " + Формат(СтрокаМассива.НомерСтроки, "ЧГ=");
			КонецЦикла;
			НомераСтрок = Сред(НомераСтрок, 3);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщенияОбОшибке, ТекущаяСтрока.ОсновноеСредство, НомераСтрок);
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА","КОРРЕКТНОСТЬ", "Нематериальный актив", НомерСтроки, "Нематериальные активы", ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.НематериальныеАктивы[%1].НематериальныйАктив",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
	// Отдельные проверки для раздела Постащики
	Ошибки = Неопределено;
	ИмяТабличнойЧасти = "Поставщики";
	ТабличнаяЧасть = ЭтотОбъект[ИмяТабличнойЧасти];
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	Для Каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		ИндексСтроки = ТабличнаяЧасть.Индекс(ТекущаяСтрока);
		НомерСтроки  = ИндексСтроки+1;
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ЗадолженностьОстаток)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.АвансОстаток) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Задолженность", НомерСтроки, "Поставщики");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Поставщики[%1].ЗадолженностьОстаток",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Аванс выданный", НомерСтроки, "Поставщики");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Поставщики[%1].АвансОстаток",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
	// Отдельные проверки для раздела Покупатели
	ЕдинственныйВидДеятельности = Истина;
	ДатаУчетнойПолитики = ДатаВводаОстатков + 86400;
	Если УчетнаяПолитика.ПрименяетсяУСН(Организация, ДатаУчетнойПолитики) Тогда
		Если УчетнаяПолитика.ПлательщикЕНВД(Организация, ДатаУчетнойПолитики) Тогда
			ЕдинственныйВидДеятельности = Ложь;
		КонецЕсли;
		Если УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, ДатаУчетнойПолитики) Тогда
			ЕдинственныйВидДеятельности = Ложь;
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ОсуществляетсяРеализацияТоваровУслугКомитентов") Тогда
			ЕдинственныйВидДеятельности = Ложь;
		КонецЕсли;
	Иначе
		Если ЭтоПредприниматель Тогда
			Если УчетнаяПолитика.ПлательщикЕНВД(Организация, ДатаУчетнойПолитики)
				ИЛИ УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, ДатаУчетнойПолитики) Тогда
				ЕдинственныйВидДеятельности = Истина;
			Иначе
				ЕдинственныйВидДеятельности = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ЕдинственныйВидДеятельности Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Покупатели.ВидДеятельности");
	КонецЕсли;
		
	Ошибки = Неопределено;
	ИмяТабличнойЧасти = "Покупатели";
	ТабличнаяЧасть = ЭтотОбъект[ИмяТабличнойЧасти];
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	Для Каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		ИндексСтроки = ТабличнаяЧасть.Индекс(ТекущаяСтрока);
		НомерСтроки  = ИндексСтроки+1;
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ЗадолженностьОстаток)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.АвансОстаток) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Задолженность", НомерСтроки, "Покупатели");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Покупатели[%1].ЗадолженностьОстаток",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Аванс полученный", НомерСтроки, "Покупатели");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Покупатели[%1].АвансОстаток",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
	// Отдельные проверки для раздела Зарплата
	УчетЗарплатыИКадровВоВнешнейПрограмме = Константы.УчетЗарплатыИКадровВоВнешнейПрограмме.Получить();
	Если УчетЗарплатыИКадровВоВнешнейПрограмме Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Зарплата.Сотрудник");
		МассивНепроверяемыхРеквизитов.Добавить("Зарплата.СпособВыплаты");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Зарплата.РаботникОрганизации");
	КонецЕсли;
	Ошибки = Неопределено;
	ИмяТабличнойЧасти = "Зарплата";
	ТабличнаяЧасть = ЭтотОбъект[ИмяТабличнойЧасти];
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	Для Каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		ИндексСтроки = ТабличнаяЧасть.Индекс(ТекущаяСтрока);
		НомерСтроки  = ИндексСтроки+1;
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ЗадолженностьЗаОрганизацией)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ЗадолженностьЗаРаботником) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Долг по зарплате", НомерСтроки, "Зарплата");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Зарплата[%1].ЗадолженностьЗаОрганизацией",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Выданный аванс", НомерСтроки, "Зарплата");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Зарплата[%1].ЗадолженностьЗаРаботником",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
	// Отдельные проверки для раздела Подотчет
	Ошибки = Неопределено;
	ИмяТабличнойЧасти = "Подотчет";
	ТабличнаяЧасть = ЭтотОбъект[ИмяТабличнойЧасти];
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	Для Каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		ИндексСтроки = ТабличнаяЧасть.Индекс(ТекущаяСтрока);
		НомерСтроки  = ИндексСтроки+1;
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ЗадолженностьОстаток)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ПерерасходОстаток) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Задолженность", НомерСтроки, "Подотчет");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Подотчет[%1].ЗадолженностьОстаток",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, "Перерасход", НомерСтроки, "Подотчет");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Подотчет[%1].ПерерасходОстаток",
				ТекстСообщения, "", ИндексСтроки,"", ИндексСтроки);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
	// Удаление непроверяемых реквизитов
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры


Если МакетПомощника = Неопределено Тогда
	МакетПомощника = ПолучитьМакет("Справка");
КонецЕсли;

#КонецЕсли