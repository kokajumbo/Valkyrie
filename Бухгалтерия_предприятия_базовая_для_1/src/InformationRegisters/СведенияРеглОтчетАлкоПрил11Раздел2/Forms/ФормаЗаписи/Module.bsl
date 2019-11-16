
#Область ОписаниеПеременных

&НаСервере
Перем ОбъектЭтогоОтчета; // Объект метаданных отчета, из которого открыта форма записи.

&НаКлиенте
Перем УправляемаяФормаВладелец; // Форма отчета, из которого открыта форма записи.

&НаКлиенте
Перем УникальностьФормы; // Уникальный идентификатор формы отчета.

&НаКлиенте
Перем ПоказыватьПредупреждениеПослеПереходаПоСсылке; // Флаг необходимости показа предупреждения.

// Форма выбора из списка, ввода пары значений, форма длительной операции, 
// записи регистра, ввода данных по ОП и т.д.
// Любая открытая из данной формы форма в режиме блокировки владельца.
&НаКлиенте
Перем ОткрытаяФормаПотомокСБлокировкойВладельца Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеВидимостью(Ложь, Ложь);
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	ФормированиеПредставленияПродукцииНаСервере(Запись.П000020000301, Запись.П000020000302);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	// Определим тексты запросов динамических списков.
			
	ВставитьКодПродукции = Ложь;
	
	ТекстЗапроса = РегламентированнаяОтчетностьАЛКО.ТекстЗапросаВыбораПроизводителяИмпортераАЛКО(
																	ВставитьКодПродукции, "НеПиво");	    
	ДинСписокПроизводителяИмпортера.ТекстЗапроса = ТекстЗапроса;
	ДинСписокПроизводителяИмпортера.ОсновнаяТаблица = "Справочник.Контрагенты";
	ДинСписокПроизводителяИмпортера.ДинамическоеСчитываниеДанных = Истина;
	
	Если ВставитьКодПродукции Тогда
		ДинСписокПроизводителяИмпортера.Параметры.УстановитьЗначениеПараметра("КодПродукции", Запись.П000020000302);
	КонецЕсли;
	
	ОсновнаяТаблица = "";
	ТекстЗапроса = РегламентированнаяОтчетностьАЛКО.ТекстЗапросаВыбораКонтрагентаАЛКО(
																	ОсновнаяТаблица, Истина, "НеПиво");
			
	ДинСписокПоставщика.ТекстЗапроса = ТекстЗапроса;
	ДинСписокПоставщика.ОсновнаяТаблица = ОсновнаяТаблица;
	ДинСписокПоставщика.ДинамическоеСчитываниеДанных = Истина;
	
	Элементы.ТаблицаПоставщиков.Обновить();
	Элементы.ТаблицаПроизводителей.Обновить();
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ТекстПредупреждения = НСтр("ru='Данная форма предназначена для редактирования данных из форм регламентированных отчетов.
										|
										|Открытие данной формы не из формы регламентированного отчета не предусмотрено!'");
	
	// Ищем управляемую форму, откуда открыли.
	Если ВладелецФормы = Неопределено Тогда
		
	    Отказ = Истина;		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
				
	ТекущийРодитель = ВладелецФормы;
	 
	Пока ТипЗнч(ТекущийРодитель) <> Тип("УправляемаяФорма") Цикл
	    ТекущийРодитель = ТекущийРодитель.Родитель;		
	КонецЦикла;
	
	УправляемаяФормаВладелец = ТекущийРодитель;
		
	ИмяФормыВладельца 	= УправляемаяФормаВладелец.ИмяФормы;
		
	Если СтрНайти(ИмяФормыВладельца, "РегламентированныйОтчетАлко") = 0 Тогда
	
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	
	КонецЕсли;
	
	УникальностьФормы   = УправляемаяФормаВладелец.УникальностьФормы;
	Оповестить("ОткрытаФормаЗаписиРегистра", ЭтаФорма, УникальностьФормы);
	
	ТекущееСостояниеВладельца = УправляемаяФормаВладелец.ТекущееСостояние;
	
    ДокументЗаписи = 		УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИндексСтраницыЗаписи = 	УправляемаяФормаВладелец.ИндексАктивнойСтраницыВРегистре;
	ИндексСтраницы = 		УправляемаяФормаВладелец.НомерАктивнойСтраницыМногострочногоРаздела;
	НомерПоследнейЗаписи = 	УправляемаяФормаВладелец.КоличествоСтрок;
	МаксИндексСтраницы = 	УправляемаяФормаВладелец.МаксИндексСтраницы;
	
	ПоказыватьПредупреждениеПослеПереходаПоссылке = УправляемаяФормаВладелец.ПоказыватьПредупреждениеПослеПереходаПоссылке;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
				
		// Заполним измерения, их нет на форме.
	    Запись.Активно = Истина;
		
		Запись.Документ = ДокументЗаписи;
				
		НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
	    Запись.ИндексСтроки = НомерПоследнейЗаписи;
		
		Модифицированность = Истина;
		
		// При копировании документ заполнения не копируем,
		// поскольку по факту строка создается вручную, а не в процессе заполнения.
		Запись.ДокументПоступления = Неопределено;
			
	КонецЕсли;
		
	Заголовок = "Поступление алкогольной продукции";
	
	ФлажокОтклАвтоРасчет 	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет;
	ФлажокОтклАвтоВыборКодов	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мАвтоВыборКодов;
	ДатаПериодаОтчета = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мДатаКонцапериодаОтчета;
	
	ПодготовкаНаСервере();

	Если НЕ ВладелецФормы.ТекущийЭлемент = Неопределено Тогда
		
		ИмяАктивногоПоля = ВладелецФормы.ТекущийЭлемент.Имя;
		
		// Если активное поле Наименование продукции - перекинем на код.
		Если ИмяАктивногоПоля = "П000020000301" Тогда
		    ИмяАктивногоПоля = "П000020000302";			
		КонецЕсли; 
		
	    АктивноеПоле = Элементы.Найти(ИмяАктивногоПоля);
		Если НЕ АктивноеПоле = Неопределено Тогда
		    ТекущийЭлемент = АктивноеПоле;		
		КонецЕсли;
	
	КонецЕсли;
			
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытаФормаЗаписиРегистра", , УникальностьФормы);
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
				
	ВнесеныИзменения = Модифицированность;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		// Обработка ситуаций "битых" внутренних данных отчета.
		// В норме условие должно проверяться один раз, результат Ложь, 
		// но если из отчета пришло неверное значениепоследней строки - этот цикл позволит
		// записать корректно данные.
		// В дальнейшем при закрытии формы через оповещение отчет будет проинформирован о текущей строке,
		// и скорректирует свои внутренние данные.
		
		СписокСоставаРегистра = Новый СписокЗначений;
		СписокСоставаРегистра.Добавить("Измерения");
		СтруктураИзмерений = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(
																		ИмяРегистра, СписокСоставаРегистра);
	
		Пока РегламентированнаяОтчетностьАЛКО.СуществуетЗапись(Запись, ИмяРегистра, СтруктураИзмерений) Цикл
			
			НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
			Запись.ИндексСтроки = НомерПоследнейЗаписи;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоПервоеРедактирование = Ложь;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "ДобавлениеСтроки");
									
	ИначеЕсли ВнесеныИзменения Тогда
			
		// Нужно записать первоначальные данные Записи регистра в журнал.
		// Но сделать это надо только для случая первого изменения Записи после последнего сохранения отчета,
		// чтобы была информация о данных до изменения в случае отката внесенных изменений, если
		// отказался пользователь от сохранения отчета.
		
		ЭтоПервоеРедактирование = РегламентированнаяОтчетностьАЛКО.ЭтоПервоеРедактированиеЗаписиРегистра(ТекущийОбъект.Документ, ИмяРегистра, 
															ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки);
				
	КонецЕсли;
	
	Если ЭтоПервоеРедактирование Тогда
		
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("НачальноеЗначение", НачальноеЗначение);
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		// Нужно сохранить первоначальные данные.
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "Редактирование", Ресурсы);
	Иначе
									
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);		
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, 0, "Сервис", Ресурсы);							
	КонецЕсли;

	Если ВнесеныИзменения Тогда
		РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
											Запись, ИмяРегистра, КонечноеЗначениеСтруктураДанных);
	КонецЕсли;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
    	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
    	МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповещаем о необходимости пересчета итогов форму-владелец для активных записей.
	Если ВнесеныИзменения и Запись.Активно Тогда
	 
		// Оповещаем форму-владелец о изменениях.
		ИнформацияДляПересчетаИтогов = Новый Структура;
		ИнформацияДляПересчетаИтогов.Вставить("ИмяРегистра", 		ИмяРегистра);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтраницы", 	ИндексСтраницы);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтроки", 		Запись.ИндексСтроки);
		ИнформацияДляПересчетаИтогов.Вставить("НачальноеЗначение", 	НачальноеЗначениеСтруктураДанных);
		ИнформацияДляПересчетаИтогов.Вставить("КонечноеЗначение", 	КонечноеЗначениеСтруктураДанных);
		
		Оповестить("ПересчетИтогов", ИнформацияДляПересчетаИтогов, УникальностьФормы);
	
	КонецЕсли;
	
	ВнесеныИзменения = Ложь;
		
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если (НЕ ЗавершениеРаботы = Неопределено) и ЗавершениеРаботы Тогда
		// Идет завершение работы системы.
	Иначе
		// Обычное закрытие.
	    Если Элементы.ГруппаВыборПроизводителя.Видимость или Элементы.ГруппаВыборПоставщика.Видимость Тогда
		    // Щелкнули на крестик при выборе производителя.
			Отказ = Истина;
		    УправлениеВидимостью(Ложь, Ложь);
			
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормыЗаписи") Тогда			
		    Модифицированность = Ложь;
			Закрыть();			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура П000020000302НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
		
	ОбработкаПослеИзменения();
		
КонецПроцедуры


&НаКлиенте
Процедура ДокументПоступленияНажатие(Элемент, СтандартнаяОбработка)
	
	НажатиеГиперссылки(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры


&НаКлиенте
Процедура ПроизводительИмпортерПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	НажатиеГиперссылки(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры


&НаКлиенте
Процедура ПоставщикПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	НажатиеГиперссылки(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПроизводителей

&НаКлиенте
Процедура ТаблицаПроизводителейВыбор(Элемент, ВыбраннаяСтрока = Неопределено, Поле = Неопределено, СтандартнаяОбработка = Истина)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	Производитель 		= Элемент.ТекущиеДанные.НаименованиеПолное;
	
	ПроизводительИНН	= Элемент.ТекущиеДанные.ИНН;
	ПроизводительКПП	= Элемент.ТекущиеДанные.КПП;	
	
	ТаблицаПроизводителейВыборНаСервере(Производитель, ПроизводительИНН, ПроизводительКПП);
			
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПроизводителейПриАктивизацииСтроки(Элемент)
	
	Если НЕ ПроверялиНеобходимостьПоказаПредупреждения Тогда	
		
		Элементы.ГруппаИнфоВыбораПроизводителя.Видимость = (Элемент.ТекущиеДанные = Неопределено);			
		
		ПроверялиНеобходимостьПоказаПредупреждения = Истина;
		
	КонецЕсли;	 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПоставщиков

&НаКлиенте
Процедура ТаблицаПоставщиковВыбор(Элемент, ВыбраннаяСтрока = Неопределено, Поле = Неопределено, СтандартнаяОбработка = Истина)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	НаименованиеПолное = Элемент.ТекущиеДанные.НаименованиеПолное;
	ИНН = Элемент.ТекущиеДанные.ИНН;
	КПП = Элемент.ТекущиеДанные.КПП;
	
	СерияНомер = Элемент.ТекущиеДанные.СерияНомер;
	ДатаВыдачи = Элемент.ТекущиеДанные.ДатаВыдачи;
	ДатаОкончания = Элемент.ТекущиеДанные.ДатаОкончания;
	КемВыдана = Элемент.ТекущиеДанные.КемВыдана;
	ТаблицаПоставщиковВыборНаСервере(НаименованиеПолное, ИНН, КПП, СерияНомер, ДатаВыдачи, ДатаОкончания, КемВыдана);
			
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПоставщиковПриАктивизацииСтроки(Элемент)
	
	Если НЕ ПроверялиНеобходимостьПоказаПредупреждения Тогда	
		
		Элементы.ГруппаИнфоВыбораПоставщика.Видимость = (Элемент.ТекущиеДанные = Неопределено);			
		
		ПроверялиНеобходимостьПоказаПредупреждения = Истина;
		
	КонецЕсли;	 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьИЗакрыть(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ Модифицированность Тогда
	    Закрыть();
	Иначе	
	    Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПроизводителяИмпортера(Команда)
	
	УправлениеВидимостью(Истина, Ложь);
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПоставщика(Команда)
	
	УправлениеВидимостью(Ложь, Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборПроизводителя(Команда)
	
	ТаблицаПроизводителейВыбор(Элементы.ТаблицаПроизводителей);
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборПоставщика(Команда)
	
	ТаблицаПоставщиковВыбор(Элементы.ТаблицаПоставщиков);
	
КонецПроцедуры


&НаКлиенте
Процедура ВернутьсяНазад(Команда)
	
	УправлениеВидимостью(Ложь, Ложь);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовкаНаСервере()
	
	УправлениеВидимостью(Ложь, Ложь);
	
	ДоступностьПолейНаСервере();	
	СформироватьСпискиВыбораНаСервере();
	ФормированиеПредставленияПродукцииНаСервере(Запись.П000020000301, Запись.П000020000302);
	
	// Заполним начальное значение всех полей записи во внутреннем формате.
	ИмяРегистра = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяОбъектаМетаданныхПоИмениФормы(ИмяФормы);
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		Запись.ИДДокИндСтраницы = РегламентированнаяОтчетностьАЛКО.ПолучитьИдДокИндСтраницы(Запись.Документ, ИндексСтраницыЗаписи);
		Запись.Организация = Запись.Документ.Организация;
		
		// Начальные данные в этих случаях всегда пустые.
		НачальноеЗначениеСтруктураДанных = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(ИмяРегистра);
		НачальноеЗначение = ЗначениеВСтрокуВнутр(НачальноеЗначениеСтруктураДанных);
		
	Иначе
		НачальноеЗначение = РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
															Запись, ИмяРегистра, НачальноеЗначениеСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ДоступностьПолейНаСервере()

	// Доступность полей формы в зависимости от флажка Авторасчет в отчете-владельце.
	// Для раздела 2 Алко приложения 11 нет авторасчета.
	
	Возврат;
	
КонецПроцедуры


&НаСервере
Функция ОбъектОтчета(ИмяФормыОбъекта)
	
	Возврат РегламентированнаяОтчетностьАЛКО.ОбъектОтчетаАЛКО(ИмяФормыОбъекта, ОбъектЭтогоОтчета);
	
КонецФункции


&НаСервере
Процедура ОбработкаМодифицированности(НачальноеЗначениеПолей, СтруктураМодифицированности)
	
	МодифицированностьКлючевыхПолей = Ложь;
	Для Каждого ЭлСтруктуры Из СтруктураМодифицированности Цикл
					
		Если ЭлСтруктуры.Значение Тогда
		    МодифицированностьКлючевыхПолей = Истина;
			Прервать;			
		КонецЕсли; 
	
	КонецЦикла;
			
	Если НЕ МодифицированностьКлючевыхПолей Тогда
		
		// Принудительно записываем начальные данные, включая всю
		// вспомогательную информацию.
		ЗаполнитьЗначенияСвойств(Запись, НачальноеЗначениеПолей);
		
	Иначе
		
		// Что то изменилось, значит уже не по документу.
		Запись.ДокументПоступления = Неопределено;
		
		Запись.ПроизводительИмпортер = Неопределено;
		Запись.Поставщик = Неопределено;
		
		ОбъектОтчета(ИмяФормыВладельца).ОбработкаЗаписи(ИмяРегистра, Запись);		
						
	КонецЕсли; 
	
	Модифицированность = МодифицированностьКлючевыхПолей;
	
КонецПроцедуры


&НаСервере
Процедура ОбработкаПослеИзменения()
	
	СтруктураМодифицированности = "";
	РегламентированнаяОтчетностьАЛКО.ЗаписьИзменилась(Запись, НачальноеЗначениеСтруктураДанных, 
														Ложь, СтруктураМодифицированности);
	ОбработкаМодифицированности(НачальноеЗначениеСтруктураДанных, СтруктураМодифицированности);
	
	ФормированиеЗаголовковСвернутогоОтображения();
	
КонецПроцедуры


&НаСервере
Процедура ФормированиеЗаголовковСвернутогоОтображения()
	
	Элементы.ДокументПоступления.Видимость = ЗначениеЗаполнено(Запись.ДокументПоступления);
	
	// ГруппаПроизводительИмпортер.
	Элементы.ПроизводительИмпортерПредставление.Видимость = ЗначениеЗаполнено(Запись.ПроизводительИмпортер);
	
	Если ЗначениеЗаполнено(Запись.П000020000303) 
		или ЗначениеЗаполнено(Запись.П000020000304)
		или ЗначениеЗаполнено(Запись.П000020000305)
		Тогда
	    Элементы.ГруппаПроизводительИмпортер.ЗаголовокСвернутогоОтображения = "Производитель или импортер: " + 
			?(ЗначениеЗаполнено(Запись.П000020000303),Запись.П000020000303, "наименование не заполнено") 
			+ ?(ЗначениеЗаполнено(Запись.П000020000304),", ИНН " + Запись.П000020000304, ", ИНН не заполнено")
			+ ?(ЗначениеЗаполнено(Запись.П000020000305),", КПП " + Запись.П000020000305, 
											?(СтрДлина(Запись.П000020000304) = 10,", КПП не заполнено", "") );
	Иначе	
	    Элементы.ГруппаПроизводительИмпортер.ЗаголовокСвернутогоОтображения = 
							Элементы.ГруппаПроизводительИмпортер.Заголовок + " не заполнены!";							
	КонецЕсли;
	
	// Доступ к КПП только если введен 10 значный ИНН.
	Если СтрДлина(Запись.П000020000304) = 10 Тогда
	    Элементы.П000020000305.ТолькоПросмотр = Ложь;
		Элементы.П000020000305.ПропускатьПриВводе = Ложь;
	Иначе
		
	    Элементы.П000020000305.ТолькоПросмотр = Истина;
		Элементы.П000020000305.ПропускатьПриВводе = Истина;
		Если НЕ СокрЛП(Запись.П000020000305) = "" Тогда
		    Запись.П000020000305 = "";
			Модифицированность = Истина;		
		КонецЕсли; 
		
	КонецЕсли; 
	
	// ГруппаПоставщика.
	Элементы.ПоставщикПредставление.Видимость = ЗначениеЗаполнено(Запись.Поставщик);
	
	Если ЗначениеЗаполнено(Запись.П000020000307) 
		или ЗначениеЗаполнено(Запись.П000020000308)
		или ЗначениеЗаполнено(Запись.П000020000306)
		Тогда
		
	    Элементы.ГруппаПоставщика.ЗаголовокСвернутогоОтображения = "Поставщик: " + 
			?(ЗначениеЗаполнено(Запись.П000020000306),Запись.П000020000306, "наименование не заполнено") 
			+ ?(ЗначениеЗаполнено(Запись.П000020000307),", ИНН " + Запись.П000020000307, ", ИНН не заполнено")
			+ ?(ЗначениеЗаполнено(Запись.П000020000308),", КПП " + Запись.П000020000308, 
											?(СтрДлина(Запись.П000020000307) = 10,", КПП не заполнено", "") );
		// Сведения о лицензии.
		Если ЗначениеЗаполнено(Запись.П000020000391) или ЗначениеЗаполнено(Запись.П000020000392) Тогда
			
			Серия = ?(ЗначениеЗаполнено(Запись.П000020000391), Запись.П000020000391, "");
			Номер = ?(ЗначениеЗаполнено(Запись.П000020000392), Запись.П000020000392, "");
			СерияНомер = ?(ЗначениеЗаполнено(Серия) и ЗначениеЗаполнено(Номер), Серия + " - " + Номер,
																				Серия + Номер);
			Элементы.ГруппаПоставщика.ЗаголовокСвернутогоОтображения = 
				Элементы.ГруппаПоставщика.ЗаголовокСвернутогоОтображения + " Лицензия " + СерияНомер;
				
			ДатаНачалаДействия = ?(ЗначениеЗаполнено(Запись.П000020000310), Запись.П000020000310, Неопределено);
			Если НЕ ДатаНачалаДействия = Неопределено Тогда			
				Элементы.ГруппаПоставщика.ЗаголовокСвернутогоОтображения = 
				Элементы.ГруппаПоставщика.ЗаголовокСвернутогоОтображения + " от " + ДатаНачалаДействия;			
			КонецЕсли; 
				
		КонецЕсли;
			
	Иначе	
	    Элементы.ГруппаПоставщика.ЗаголовокСвернутогоОтображения = 
							Элементы.ГруппаПоставщика.Заголовок + " не заполнены!";							
	КонецЕсли;
						
	// Доступ к КПП только если введен 10 значный ИНН.
	Если СтрДлина(Запись.П000020000307) = 10 Тогда
		
	    Элементы.П000020000308.ТолькоПросмотр = Ложь;
		Элементы.П000020000308.ПропускатьПриВводе = Ложь;
		
	Иначе
		
	    Элементы.П000020000308.ТолькоПросмотр = Истина;
		Элементы.П000020000308.ПропускатьПриВводе = Истина;
		Если НЕ СокрЛП(Запись.П000020000308) = "" Тогда
		    Запись.П000020000308 = "";
			Модифицированность = Истина;		
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры


&НаСервере
Процедура ФормированиеПредставленияПродукцииНаСервере(ВидПродукции = Неопределено, КодВида = Неопределено)
	
	Если ВидПродукции = Неопределено Тогда
	    ВидПродукции = Запись.П000020000301;	
	КонецЕсли;
	
	Если КодВида = Неопределено Тогда
	    КодВида = Запись.П000020000302;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодВида) Тогда
	    ПредставлениеПродукции = "Код " + КодВида + ", " + ВидПродукции;
	Иначе	
	    ПредставлениеПродукции = "Заполнить";
	КонецЕсли; 
	
	Если ПредставлениеПродукции = "Заполнить" Тогда		
		Элементы.Представление.ЦветТекста = ЦветСтиляНезаполненныйРеквизит;
	Иначе
		Элементы.Представление.ЦветТекста = ЦветСтиляЦветГиперссылкиБРО;
	КонецЕсли;
		
	ФормированиеЗаголовковСвернутогоОтображения();
		
КонецПроцедуры


&НаКлиенте
Процедура ВыборВидаПродукции()
	
	// Из списка.
	ИсходноеЗначениеКода = СокрЛП(Запись.П000020000302);
	ИсходноеЗначениеНазвания = СокрЛП(Запись.П000020000301);
	КолонкаПоиска = "Код";
	ИмяКолонкиКодПродукции = "П000020000302";
		
	// Не из списка.
	ЗаголовокФормы = "Ввод вида продукции";
	НадписьПоляЗначения = "Вид продукции";
	НадписьПоляКод = "Код";
	МногострочныйРежимЗначения = Истина;
	ДлинаПоляКода  = 4;
	ДлинаПоляЗначения = 40;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗавершение", ЭтотОбъект);
		
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ПараметрыПриВключенномВыбореИзСписка", Новый Структура);
	ПараметрыВыборИзСписка = СтруктураПараметров.ПараметрыПриВключенномВыбореИзСписка;
	// Из списка.
	ПараметрыВыборИзСписка.Вставить("СвойстваПоказателей", 	СвойстваПоказателей);
	ПараметрыВыборИзСписка.Вставить("ИмяКолонкиКод", 		ИмяКолонкиКодПродукции);	
	ПараметрыВыборИзСписка.Вставить("КолонкаПоиска", 		КолонкаПоиска);
	ПараметрыВыборИзСписка.Вставить("ИсходноеЗначение", 	ИсходноеЗначениеКода);
	
	СтруктураПараметров.Вставить("ПараметрыПриОтключенномВыбореИзСписка", Новый Структура);
	ПараметрыВыборНеИзСписка = СтруктураПараметров.ПараметрыПриОтключенномВыбореИзСписка;
	// Не из списка.
	ПараметрыВыборНеИзСписка.Вставить("ЗаголовокФормы", 			ЗаголовокФормы);
	ПараметрыВыборНеИзСписка.Вставить("ИсходноеЗначениеКода", 		ИсходноеЗначениеКода);	
	ПараметрыВыборНеИзСписка.Вставить("ИсходноеЗначениеПоКоду",		ИсходноеЗначениеНазвания);
	ПараметрыВыборНеИзСписка.Вставить("НадписьПоляЗначения", 		НадписьПоляЗначения);
	ПараметрыВыборНеИзСписка.Вставить("НадписьПоляКод", 			НадписьПоляКод);
	ПараметрыВыборНеИзСписка.Вставить("МногострочныйРежимЗначения", МногострочныйРежимЗначения);
	ПараметрыВыборНеИзСписка.Вставить("ДлинаПоляКода", 				ДлинаПоляКода);
	ПараметрыВыборНеИзСписка.Вставить("ДлинаПоляЗначения", 			ДлинаПоляЗначения);
	ПараметрыВыборНеИзСписка.Вставить("УникальностьФормы", 			УникальностьФормы);

	
	РегламентированнаяОтчетностьАЛКОКлиент.ВызватьФормуВыбораЗначенийАЛКО(
			ЭтаФорма, ФлажокОтклАвтоВыборКодов, СтруктураПараметров, ОписаниеОповещения);
		
КонецПроцедуры


&НаКлиенте
Процедура ВыборЗавершение(РезультатВыбора, Параметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если РезультатВыбора = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	// Поскольку всегда "выбираем" код.
	ИмяКолонкиКодПродукции 			= "П000020000302";
	ИмяКолонкиНаименованияПродукции = "П000020000301";
	
	ИсходноеЗначение 				= СокрЛП(Запись[ИмяКолонкиКодПродукции]);
	Запись[ИмяКолонкиКодПродукции] 	= СокрЛП(РезультатВыбора.Код);
	
	КодИзменился = (ИсходноеЗначение <> СокрЛП(Запись[ИмяКолонкиКодПродукции]));
		
	ИсходноеЗначениеНаименования 			= СокрЛП(Строка(Запись[ИмяКолонкиНаименованияПродукции]));
	Запись[ИмяКолонкиНаименованияПродукции] = ?(СокрЛП(РезультатВыбора.Код) = "",
													"", СокрЛП(РезультатВыбора.Название));
	
	НаименованиеИзменилось = (ИсходноеЗначениеНаименования <> СокрЛП(Запись[ИмяКолонкиНаименованияПродукции]));	
	
	Модифицированность = Модифицированность или КодИзменился или НаименованиеИзменилось;
	
	ФормированиеПредставленияПродукцииНаСервере();	
	ОбработкаПослеИзменения(); 
	
КонецПроцедуры


&НаСервере
Процедура СформироватьСпискиВыбораНаСервере()
	
	КоллекцияСписковВыбора = РегламентированнаяОтчетностьАЛКО.СчитатьКоллекциюСписковВыбораАЛКО(
														ДатаПериодаОтчета, ИмяФормыВладельца, ОбъектЭтогоОтчета);
	
	СвойстваПоказателей.Очистить();
	
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000020000301", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000020000302", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);
	
КонецПроцедуры


&НаСервере
Процедура УправлениеВидимостью(ПоказатьВыборПроизводителей = Ложь, ПоказатьВыборПоставщиков = Ложь)
	
	Если ПоказатьВыборПроизводителей Тогда
		
		ПроверялиНеобходимостьПоказаПредупреждения = Ложь;
		
		Если ВставитьКодПродукции Тогда
		    ДинСписокПроизводителяИмпортера.Параметры.УстановитьЗначениеПараметра("КодПродукции", Запись.П000020000302);		
		КонецЕсли; 
				
		Элементы.ОК.Видимость = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.ГруппаЗапись.Видимость = Ложь;
		Элементы.ГруппаВыборПоставщика.Видимость = Ложь;
		
		Элементы.ГруппаВыборПроизводителя.Видимость = Истина;
		
		Если ЗначениеЗаполнено(Запись.ПроизводительИмпортер) Тогда
		
			Элементы.ТаблицаПроизводителей.ТекущаяСтрока = Запись.ПроизводительИмпортер;
		
		КонецЕсли; 
		
	ИначеЕсли ПоказатьВыборПоставщиков Тогда
		
		ПроверялиНеобходимостьПоказаПредупреждения = Ложь;
				
		Элементы.ОК.Видимость = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.ГруппаЗапись.Видимость = Ложь;
		Элементы.ГруппаВыборПроизводителя.Видимость = Ложь;
		
		Элементы.ГруппаВыборПоставщика.Видимость = Истина;
		
		Если ЗначениеЗаполнено(Запись.Поставщик) Тогда
																				
			Если НЕ ДинСписокПоставщика.ОсновнаяТаблица = "Справочник.Контрагенты" Тогда
				
				ОсновнаяТаблица = "";
				ТекстЗапроса = РегламентированнаяОтчетностьАЛКО.ТекстЗапросаВыбораКонтрагентаАЛКО(
																ОсновнаяТаблица, Истина, "НеПиво", Истина);
				ЗапросВидаЛицензии = Новый Запрос;
				ЗапросВидаЛицензии.Текст = ТекстЗапроса;
				
				ЗапросВидаЛицензии.Параметры.Вставить("ИскомыйКонтрагентСсылка", Запись.Поставщик);
				
				Результат = ЗапросВидаЛицензии.Выполнить().Выгрузить();
				
				// Выбор из регистра сведений лицензии поставщиков.
				СтрокаРегистрСведенийЛицензииПоставщиковАлкогольнойПродукции = ДинСписокПоставщика.ОсновнаяТаблица;
				
				ИзмерениеПоставщик = "";
				
				Если СтрНайти(ВРег(СтрокаРегистрСведенийЛицензииПоставщиковАлкогольнойПродукции), 
								  ВРег("РегистрСведений.")) > 0 Тогда
					ИзмерениеПоставщик 	= "Поставщик";
					
				ИначеЕсли СтрНайти(ВРег(СтрокаРегистрСведенийЛицензииПоставщиковАлкогольнойПродукции), 
								  ВРег("Справочник.")) > 0 Тогда
					ИзмерениеПоставщик 	= "Владелец";
					
				КонецЕсли;
	 
				КолСтрокРезультата = Результат.Количество();
				ВидЛицензии = Неопределено;
				ДатаНачала  = Неопределено;
				СсылкаНаЭлемент	= Неопределено;
				
				Если КолСтрокРезультата > 0 Тогда
					
					// Зафиксируем первую подходящую запись.
					// Даже если не найдем полное совпадение - спозиционируем на первой
					// более менее подходящей строке.
					
					ВидЛицензии = Результат[0].ВидЛицензии;
					ДатаНачала =  Результат[0].ДатаВыдачи;
					
					Если ИзмерениеПоставщик = "Владелец" Тогда
					
						СсылкаНаЭлемент =  Результат[0].Ссылка;
					
					КонецЕсли; 
					
					Если КолСтрокРезультата > 1 Тогда
						
						// Найдем по соответствию серии-номера. Количество строк перебора не может быть большим.
						Для Инд = 0 По КолСтрокРезультата - 1 Цикл
						
							ТекСтрокаРезультата = Результат[Инд];
							ТекСерияНомер 		= ТекСтрокаРезультата.СерияНомер;
							ТекДатаНачала 		= ТекСтрокаРезультата.ДатаВыдачи;
							ТекДатаОкончания 	= ТекСтрокаРезультата.ДатаОкончания;
							
							Если (СтрНайти(ТекСерияНомер, СокрЛП(Запись.П000020000391)) > 0)
								и (СтрНайти(ТекСерияНомер, СокрЛП(Запись.П000020000392)) > 0)
								и (ТекДатаНачала = Запись.П000020000310)
								и (ТекДатаОкончания = Запись.П000020000311) Тогда
								
								// Нашли что искали.
								ВидЛицензии = ТекСтрокаРезультата.ВидЛицензии;
							    ДатаНачала  = ТекДатаНачала;
								
								Если ИзмерениеПоставщик = "Владелец" Тогда
					
									СсылкаНаЭлемент =  ТекСтрокаРезультата.Ссылка;
								
								КонецЕсли;
					
								Прервать;
							
							КонецЕсли; 
						
						КонецЦикла;
						
					КонецЕсли; 
				    
				КонецЕсли;
				
				Если (НЕ ВидЛицензии = Неопределено) и (НЕ ДатаНачала = Неопределено) Тогда
					
					Если ИзмерениеПоставщик = "Поставщик" Тогда
								  
						Отбор = Новый Структура;
						Отбор.Вставить("Поставщик", Запись.Поставщик);
						Отбор.Вставить("ВидЛицензии", ВидЛицензии);
						Отбор.Вставить("Период", ДатаНачала);
											
						ИмяРегистраСведенийЛицензииПоставщиковАлкогольнойПродукции = 
							СтрЗаменить(ВРег(СтрокаРегистрСведенийЛицензииПоставщиковАлкогольнойПродукции), 
								  		ВРег("РегистрСведений."), "");
						РегистрСведенийЛицензий = РегистрыСведений[ИмяРегистраСведенийЛицензииПоставщиковАлкогольнойПродукции];
						
						КлючЗаписи = РегистрСведенийЛицензий.СоздатьКлючЗаписи(Отбор);
				 
					Иначе						
						КлючЗаписи = СсылкаНаЭлемент;
					КонецЕсли;
					
					Элементы.ТаблицаПоставщиков.ТекущаяСтрока = КлючЗаписи;
						
				КонецЕсли; 
					
			Иначе
				
				Элементы.ТаблицаПоставщиков.ТекущаяСтрока = Запись.Поставщик;
				
			КонецЕсли; 
			
		КонецЕсли;
		
	Иначе
				
		Элементы.ГруппаИнфоВыбораПроизводителя.Видимость = Ложь;
		Элементы.ГруппаИнфоВыбораПоставщика.Видимость = Ложь;
		
		Элементы.ГруппаВыборПоставщика.Видимость = Ложь;
		Элементы.ГруппаВыборПроизводителя.Видимость = Ложь;
		
		Элементы.ГруппаЗапись.Видимость = Истина;	
		Элементы.Отмена.Видимость = Истина;
		Элементы.ОК.Видимость = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры


&НаСервере
Функция ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка = Неопределено)
	
	ЗначениеСсылка = РегламентированнаяОтчетностьАЛКО.ПолучитьЗначениеЭлементаФормы(ЭтаФорма, ИмяЭлементаСсылки);	
	ИмяФормыОбъекта = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяФормыОбъекта(ЗначениеСсылка);
	
	Возврат ИмяФормыОбъекта;
	
КонецФункции


&НаКлиенте
Процедура НажатиеГиперссылки(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ИмяЭлементаСсылки = Элемент.Имя;
	
	ЗначениеСсылка = Неопределено;
	ИмяФормыОбъекта = ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НажатиеГиперссылкиЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ЗначениеСсылка);
	ОткрытаяФормаПотомокСБлокировкойВладельца = ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы, 
			ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


&НаКлиенте
Процедура НажатиеГиперссылкиЗавершение(Результат, ДопПараметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке = Неопределено Тогда
	    ПоказыватьПредупреждениеПослеПереходаПоссылке = Истина;	
	КонецЕсли;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке Тогда
	    // Открываем форму предупреждения.
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Внимание!'"));
		ПараметрыФормы.Вставить("ТекстПредупреждения", НСтр("ru='"
				+ "Если Вы внесли изменения в элемент справочника или документ,"
				+ " для внесения изменений в строки отчета, заполняемых на основании"
				+ " измененной информации, необходимо перезаполнить Отчет.
				|
				|Для этого в основной форме отчета нужно нажать кнопку ""Заполнить"".
				|
				|Не обязательно это делать прямо сейчас, это можно сделать после внесения"
				+ " всех необходимых правок по разным документам и справочникам.'"));
		ПараметрыФормы.Вставить("ТекстЗаголовкаФлажка", НСтр("ru='Больше не показывать в этом сеансе редактирования'"));
		ПараметрыФормы.Вставить("УникальностьФормы",       		УникальностьФормы);
		
		ИмяФормыПредупреждения = "ОбщаяФорма.АЛКОФормаПредупрежденияСФлажком";
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьСостояниеФлажкаФормыПредупреждения", ЭтотОбъект);
		ОткрытьФорму(ИмяФормыПредупреждения, ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьСостояниеФлажкаФормыПредупреждения(Результат, ДопПараметры) Экспорт
	
	Если (НЕ Результат = Неопределено) и Результат Тогда
		// Оповещаем форму отчета владельца о том, что больше показывать
		// предупреждение не надо.
		ПоказыватьПредупреждениеПослеПереходаПоссылке = Ложь;
		Оповестить("ПоказыватьПредупреждениеПослеПереходаПоСсылке", , УникальностьФормы);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ТаблицаПроизводителейВыборНаСервере(Производитель, ПроизводительИНН, ПроизводительКПП)
	
	Запись.П000020000304 = СокрЛП(ПроизводительИНН);
	Запись.П000020000305 = СокрЛП(ПроизводительКПП);
	Запись.П000020000303 = СокрЛП(Производитель);
	
	УправлениеВидимостью(Ложь, Ложь);
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры


&НаСервере
Процедура ТаблицаПоставщиковВыборНаСервере(НаименованиеПолное, ИНН, КПП, СерияНомер, ДатаВыдачи, ДатаОкончания, КемВыдана)
		
	Запись.П000020000307 = СокрЛП(ИНН);
	Запись.П000020000308 = СокрЛП(КПП);	
	Запись.П000020000306 = СокрЛП(НаименованиеПолное);
		
	// Нужно выделить Серию и Номер из СерияНомер
	ПозицияРазделителя = Найти(СерияНомер, ",");
	Если ПозицияРазделителя = 0 Тогда
		ПозицияРазделителя = Найти(СерияНомер, " ");
	КонецЕсли;
		
	Если ПозицияРазделителя = 0 Тогда
		// Все пишем в номер.
		Запись.П000020000391 = "";
	    Запись.П000020000392 = СокрЛП(СерияНомер);
	Иначе		
		// Серия.
	    Запись.П000020000391 = СокрЛП(Лев(СерияНомер, ПозицияРазделителя - 1));
		// Номер.
		Запись.П000020000392 = СокрЛП(Сред(СерияНомер, ПозицияРазделителя + 1));
	КонецЕсли;
	
	Запись.П000020000310 = ДатаВыдачи;
	Запись.П000020000311 = ДатаОкончания;
		
	Запись.П000020000312  = СокрЛП(КемВыдана);
	
	УправлениеВидимостью(Ложь, Ложь);
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры

#КонецОбласти
