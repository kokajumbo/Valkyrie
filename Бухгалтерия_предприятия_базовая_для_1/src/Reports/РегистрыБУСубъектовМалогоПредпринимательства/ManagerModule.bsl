#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим", Истина);

	Возврат Результат;							
							
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт

	Если ПараметрыОтчета.КлючТекущегоВарианта = "ВедомостьУчетаРасчетовСПерсоналомПоОплатеТруда"
	   И ЗначениеЗаполнено(ПараметрыОтчета.Организация)
	   И ОбщегоНазначенияБП.СписокДоступныхОрганизаций(ПараметрыОтчета.Организация).Количество() = 1 Тогда
	   
		УстановитьПривилегированныйРежим(Истина);
		ФизическиеЛица = УчетЗарплаты.ФизическиеЛицаРаботавшиеВОрганизации(
							Ложь,
							ПараметрыОтчета.Организация,
							ПараметрыОтчета.НачалоПериода,
							ПараметрыОтчета.КонецПериода);
		
		ДанныеФизическихЛиц = УчетЗарплаты.ДанныеФизическихЛиц(
								ПараметрыОтчета.Организация,
								ФизическиеЛица.ВыгрузитьКолонку("ФизическоеЛицо"),
								ПараметрыОтчета.КонецПериода,
								Истина,
								Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
		Возврат Новый Структура("ДанныеФизическихЛиц", ДанныеФизическихЛиц);
		
	КонецЕсли;

	Возврат Новый Структура();

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
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат ПараметрыОтчета.НазваниеРегистра + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаГраница", Новый Граница(НачалоДня(ПараметрыОтчета.НачалоПериода)-1, ВидГраницы.Включая));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаГраница", Новый Граница(КонецДня(ПараметрыОтчета.КонецПериода), ВидГраницы.Включая));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаГод",  Новый Граница(НачалоГода(ПараметрыОтчета.КонецПериода), ВидГраницы.Включая));
	КонецЕсли;
	
	Если ПараметрыОтчета.Свойство("Счет") И ЗначениеЗаполнено(ПараметрыОтчета.Счет) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Счет", ПараметрыОтчета.Счет);
	КонецЕсли;	
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	             
КонецПроцедуры

Функция НайтиТелоВМекетеКомпановки(Тело, Имя)
	Для п = 0 по Тело.Количество() - 1 Цикл
		ТекТело = Тело[п];
		Если ТипЗнч(ТекТело) <> Тип("МакетОбластиМакетаКомпоновкиДанных") И ТипЗнч(ТекТело) <> Тип("МакетГруппировкиТаблицыМакетаКомпоновкиДанных") Тогда
			Если ТекТело.Имя = Имя тогда
				НайденноеТело = ТекТело;	
			Иначе
				Если ТипЗнч(ТекТело) = Тип("ГруппировкаМакетаКомпоновкиДанных") ИЛИ ТипЗнч(ТекТело) = Тип("ГруппировкаТаблицыМакетаКомпоновкиДанных") Тогда
					НайденноеТело = НайтиТелоВМекетеКомпановки(ТекТело.Тело, Имя);
				ИначеЕсли ТипЗнч(ТекТело) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
					НайденноеТело = НайтиТелоВМекетеКомпановки(ТекТело.Строки, Имя);
					Если НайденноеТело = Неопределено Тогда
						НайденноеТело = НайтиТелоВМекетеКомпановки(ТекТело.Колонки, Имя);
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
		Если НайденноеТело <> Неопределено Тогда
			Возврат НайденноеТело;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции	

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	Группировка = НайтиТелоВМекетеКомпановки(МакетКомпоновки.Тело,ПараметрыОтчета.КлючТекущегоВарианта);
	
	Если Группировка <> Неопределено Тогда
		Группировка.Тело.Удалить(Группировка.Тело[Группировка.Тело.Количество() - 1]);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	              
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	ВысотаЗаголовка  = 1;
	ОбластьЗаголовка = Результат.Области.Найти("Заголовок");
	
	Если ОбластьЗаголовка <> Неопределено Тогда
		
		ВысотаЗаголовка = ОбластьЗаголовка.Низ;
		ШиринаКолонки = 0;
		Для НомерКолонки = 1 По Результат.ШиринаТаблицы Цикл
			
			ШиринаКолонки = ШиринаКолонки + Результат.Область(ВысотаЗаголовка + 1, НомерКолонки , ВысотаЗаголовка + 1, НомерКолонки).ШиринаКолонки;
			
		КонецЦикла;
		
		ШиринаКолонки = ШиринаКолонки - 70;
		
		Если ШиринаКолонки > 0 Тогда
			Результат.Область("R1C2").ШиринаКолонки = ШиринаКолонки;
		КонецЕсли;	
		
	КонецЕсли;	
	
    // Объединим ячейки с одинаковым текстом в шапке таблицы
	// Для этого будем перебирать ячейки шапки построчно
	КоличествоКолонок = Результат.ШиринаТаблицы;
	
	// Начальные параметры
	НечитаемыйТекст = "%%//###\\%%";  		// нечитамый текст который не совпадет случайно ни с каким другим
	ТекстПредыдущейЯчейки = НечитаемыйТекст;// Текст предыдущей ячейки, изначально нечитамый текст 
	НомерКолонкиНачалоОбъединения = 1;  	// Номер колонки с которой нужно начинать объединение ячеек
	Объединение = Ложь;                 	// Флаг, нужно выполнить обънединение
	НомерСтроки = ВысотаЗаголовка;	
	ПеребиратьСтрокиШапки = Истина; 		// Флаг, будет сброшен когда определим что шапка таблицы кончилась
	
	
	// Перебираем строки шапки
	Пока ПеребиратьСтрокиШапки Цикл
		
		// Перебираем колонки в каждой строке
		Для НомерКолонки = 1 По КоличествоКолонок Цикл
			
			// Получаем текущую ячейку
			Ячейка = Результат.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			ТекстЯчейки = Ячейка.Текст;
			       
			Если НомерКолонки = 1 И ТекстЯчейки = "1" Тогда
				// Добрались до строки с нумерацией колонок, дальше идти не нужно
				ПеребиратьСтрокиШапки = Ложь;
				Прервать;
				
			КонецЕсли;	
			
			Если ТекстЯчейки = "" Тогда
				
				ТекстЯчейки = НечитаемыйТекст + НомерКолонки;
				
			КонецЕсли;	
			
			Если ТекстПредыдущейЯчейки <> ТекстЯчейки Тогда
				
				// Если текст разный, и объединение открыто нужно его закрыть
				Если Объединение Тогда
					
					// Объеденяем ячейки текущей строки, с начальной колонки (НомерКолонкиНачалоОбъединения)
					// по предыдущую
					Результат.Область(НомерСтроки, НомерКолонкиНачалоОбъединения, НомерСтроки, Ячейка.Лево - 1).Объединить();
										
					// Сбрасываем флаг
					Объединение = Ложь;
				КонецЕсли;
				// Перемещаем начало объединения на текщую колонку
				НомерКолонкиНачалоОбъединения =  Ячейка.Лево;
				ТекстПредыдущейЯчейки = ТекстЯчейки;
				
			Иначе
				
				// Если текст одинаковый нужно открыть объединение
				// Колонку начала объединения не перетаскиваем
				Объединение = Истина;
				
			КонецЕсли;	  
						
		КонецЦикла;	
		
		// В конце каждой строки закрываем объединение и сбрасываем флаг
		Если Объединение Тогда
			
			Результат.Область(НомерСтроки, НомерКолонкиНачалоОбъединения, НомерСтроки, КоличествоКолонок).Объединить();
			
			Объединение = Ложь;
			
		КонецЕсли;
		
		// Устанавливаем номер колонки текст ячейки в исходное положение
		НомерКолонкиНачалоОбъединения = 1;
		ТекстПредыдущейЯчейки = НечитаемыйТекст;
		НомерСтроки = НомерСтроки + 1;
		
		// Если не удалось определить конец шапки таблицы, выходим из цикла 
		// обработав 9 строк
		Если НомерСтроки = 10 Тогда
			ПеребиратьСтрокиШапки = Ложь;
		КонецЕсли;
		
	КонецЦикла;	
		
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Результат.ФиксацияСверху = 0;
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьМакет("ЗаголовокОтчета");
	
	Если ПараметрыОтчета.КлючТекущегоВарианта = "КнигаУчетаФактовХозяйственнойДеятельности" Тогда 
		ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокК1");
		ОбластьЗаголовок.Области.ЗаголовокК1.Имя = "Заголовок";
	Иначе
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	КонецЕсли;

	// Организация
	Если ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация);
		ОбластьЗаголовок.Параметры.НазваниеОрганизации = ТекстОрганизация;
	КонецЕсли;
	
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПолучитьТекстЗаголовка(ПараметрыОтчета);
	
	Результат.Вывести(ОбластьЗаголовок); 
		
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.РегистрыБУСубъектовМалогоПредпринимательства, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.РегистрыБУСубъектовМалогоПредпринимательства, "");
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
	
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаОсновныхСредствИАмортизации", НСтр("ru = '1МП. Ведомость основных средств и амортизации'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаМатериальноПроизводственныхЗапасов", НСтр("ru = '2МП. Ведомость материально-производственных запасов'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаЗатратНаПроизводство", НСтр("ru = '3МП. Ведомость затрат на производство'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаЗатратНаКапитальныеВложения", НСтр("ru = '3МП. Ведомость затрат на капитальные вложения'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаДенежныхСредств", НСтр("ru = '4МП. Ведомость денежных средств'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаРасчетовИПрочихОпераций", НСтр("ru = '5МП. Ведомость  расчетов и прочих операций'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаПродаж", НСтр("ru = '6МП. Ведомость продаж'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаРасчетовСПоставщиками", НСтр("ru = '7МП. Ведомость расчетов с поставщиками'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ВедомостьУчетаРасчетовСПерсоналомПоОплатеТруда", НСтр("ru = '8МП. Ведомость расчетов с персоналом'")));
	Массив.Добавить(Новый Структура("Имя, Представление","СводнаяВедомостьШахматная", НСтр("ru = '9МП. Сводная ведомость (шахматная)'")));
	Массив.Добавить(Новый Структура("Имя, Представление","КнигаУчетаФактовХозяйственнойДеятельности", НСтр("ru = 'К-1. Книга фактов хозяйственной деятельности'")));
	
	Возврат Массив;
	
КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	КлючВарианта = Неопределено;
	
	Если Параметры.Свойство("КлючВарианта",КлючВарианта) Тогда
		
		Если КлючВарианта = "ВедомостьУчетаМатериальноПроизводственныхЗапасов"
			Или КлючВарианта = "ВедомостьУчетаЗатратНаПроизводство"
			Или КлючВарианта = "ВедомостьУчетаЗатратНаКапитальныеВложения" Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ВыбраннаяФорма = "ФормаОтчетаСВыборомСчета";
			
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецЕсли
