#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.НачислениеЗарплаты;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "Документ.ВедомостьНаВыплатуЗарплаты";
	НовыеСведения.ПоляРегистрации = "Зарплата.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "СуммаДокумента,Зарплата.Сумма,Зарплата.КомпенсацияЗаЗадержкуЗарплаты";
	НовыеСведения.ОбластьДанных   = "Доходы";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "Документ.ВедомостьНаВыплатуЗарплаты";
	НовыеСведения.ПоляРегистрации = "Зарплата.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "Зарплата.БанковскийСчет";
	НовыеСведения.ОбластьДанных   = "ЛичныеДанные";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииФормы

// Производит перерасчет РК и СН
// 
// Параметры:
//  СтрокаИнициаторПересчета - ПланВидовРасчета.Начисления, исходное начисление.
//  Начисления               - Таблица значений, соответствующая табличной части "Начисления" документа.
//
Процедура ПересчитатьНачисленияСКоэффициентом(СтрокаИнициаторПересчета, Начисления) Экспорт
	
	Если Не СтрокаИнициаторПересчета.ВходитВБазуРКиСН Тогда
		Возврат;
	КонецЕсли;
	
	ОкладТариф = 0;
	СтрокиНачисленийОкладТариф = Начисления.НайтиСтроки(
		Новый Структура("Сотрудник,ВходитВБазуРКиСН", СтрокаИнициаторПересчета.Сотрудник, Истина));
		
	Для Каждого СтрокОкладТариф Из СтрокиНачисленийОкладТариф Цикл
		ОкладТариф = ОкладТариф + СтрокОкладТариф.Результат;
	КонецЦикла;
	
	СтрокиНачислений = Начисления.НайтиСтроки(
		Новый Структура("Сотрудник,ВходитВБазуРКиСН", СтрокаИнициаторПересчета.Сотрудник, Ложь));
		
	Для Каждого НайденнаяСтрока Из СтрокиНачислений Цикл
		Если НайденнаяСтрока.КоэффициентПересчета <> 0 Тогда
			НайденнаяСтрока.Результат = ОкладТариф * НайденнаяСтрока.КоэффициентПересчета;
		КонецЕсли; 
	КонецЦикла;
		
КонецПроцедуры

// Производит перерасчет НДФЛ и взносов по списку сотрудников.
//
//  Объект      - ДанныеФормыСтруктура.
//  Сотрудники  - Массив, сотрудники, по которым требуется провести перерасчет.
//  НДФЛ        - Булево, признак пересчета только НДФЛ.
//  Взносы      - Булево, признак пересчета только взносов.
//
Процедура ОбновитьНДФЛиВзносыСотрудников(Объект, Сотрудники, НДФЛ = Истина, Взносы = Истина) Экспорт
	
	Если Объект.КорректироватьНДФЛ И Объект.КорректироватьВзносы Тогда
		// Не пересчитываем, т.к. и НДФЛ, и взносы в режиме корректировки.
		Возврат;
	КонецЕсли;
	
	// Составляем временные таблицы для расчета НДФЛ и взносов.
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	РасчетЗарплатыБазовый.СоздатьВТДляРасчетаНДФЛиВзносов(МенеджерВременныхТаблиц, Объект, Сотрудники);
	
	// Составляем массив физических лиц.
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ФизическиеЛица.ФизическоеЛицо
	|ИЗ
	|	ВТФизическиеЛица КАК ФизическиеЛица";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ФизическиеЛицаМассив = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
	ФизическиеЛицаМассивНДФЛ   = Новый Массив;
	ФизическиеЛицаМассивВзносы = Новый Массив;
	
	Для Каждого ФизическоеЛицо ИЗ ФизическиеЛицаМассив Цикл
		Если НДФЛ Тогда
			ФиксРасчет = Объект.НДФЛ.НайтиСтроки(Новый Структура("ФизическоеЛицо, ФиксРасчет", ФизическоеЛицо, Истина));
			Если ФиксРасчет.Количество() = 0 Тогда
				ФиксРасчет = Объект.КорректировкиВыплаты.НайтиСтроки(Новый Структура("ФизическоеЛицо, ФиксРасчет", ФизическоеЛицо, Истина));
			КонецЕсли;
			Если ФиксРасчет.Количество() = 0 Тогда
				ФизическиеЛицаМассивНДФЛ.Добавить(ФизическоеЛицо);
			КонецЕсли;
		КонецЕсли;
		Если Взносы Тогда
			ФиксРасчет = Объект.Взносы.НайтиСтроки(Новый Структура("ФизическоеЛицо, ФиксРасчет", ФизическоеЛицо, Истина));
			Если ФиксРасчет.Количество() = 0 Тогда
				ФизическиеЛицаМассивВзносы.Добавить(ФизическоеЛицо);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Рассчитываем НДФЛ и взносы
	ДатаОперации = Мин(Объект.Дата, КонецДня(Объект.МесяцНачисления));
	
	НачатьТранзакцию();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не Объект.КорректироватьНДФЛ И НДФЛ Тогда
		
		Если ФизическиеЛицаМассивНДФЛ.Количество() > 0 Тогда
			
			ОтборСтрок   = Новый Структура("ФизическоеЛицо", ФизическиеЛицаМассивНДФЛ);
			
			РезультатРасчетаНДФЛ = РасчетЗарплатыБазовый.РезультатРасчетаНДФЛ(МенеджерВременныхТаблиц, Объект, ДатаОперации, Истина);
			СдвигИдентификатора = УчетНДФЛФормы.МаксимальныйИдентификаторСтрокиНДФЛ(Объект.НДФЛ) + 1;
			// Перенумеруем строки новых коллекций.
			УчетНДФЛФормы.НазначитьИдентификаторыНовымСтрокамТаблицамНДФЛИПримененныеВычетыНаДетейИИмущественные(
				СдвигИдентификатора, РезультатРасчетаНДФЛ.НДФЛ, РезультатРасчетаНДФЛ.ПримененныеВычетыНаДетейИИмущественные);
			// Выполняем замену прежних строк на новые.
			РасчетЗарплаты.ЗаменитьСтрокиНаНовыеДанные(Объект.НДФЛ, РезультатРасчетаНДФЛ.НДФЛ, "ФизическоеЛицо", , ОтборСтрок);
			// В таблице вычетов, т.к. она не отображается, достаточно просто добавить новые строки в любое место, старые будут
			// удалены перед записью.
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатРасчетаНДФЛ.ПримененныеВычетыНаДетейИИмущественные, Объект.ПримененныеВычетыНаДетейИИмущественные);
			// Обновление строк корректировки выплат
			РезультатРасчетаКорректировкиВыплаты = РасчетЗарплатыБазовый.РезультатРасчетаКорректировкиВыплаты(Объект, "МесяцНачисления", ФизическиеЛицаМассивНДФЛ);
			РасчетЗарплаты.ЗаменитьСтрокиНаНовыеДанные(Объект.КорректировкиВыплаты, РезультатРасчетаКорректировкиВыплаты, "ФизическоеЛицо", , ОтборСтрок);
			
		КонецЕсли;
	
	КонецЕсли;
	
	Если Не Объект.КорректироватьВзносы И Взносы Тогда
		
		Если ФизическиеЛицаМассивВзносы.Количество() > 0 Тогда
			
			ОтборСтрок = Новый Структура("ФизическоеЛицо", ФизическиеЛицаМассивВзносы);
			
			РезультатРасчетаВзносов = РасчетЗарплатыБазовый.РезультатРасчетаВзносов(МенеджерВременныхТаблиц, Объект.Ссылка, Объект.Организация, Объект.МесяцНачисления);	
			// Выполняем замену прежних строк на новые.
			РасчетЗарплаты.ЗаменитьСтрокиНаНовыеДанные(Объект.Взносы, РезультатРасчетаВзносов, "ФизическоеЛицо", , ОтборСтрок);
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОтменитьТранзакцию();
	
КонецПроцедуры

// Процедура инициирует перерасчет НДФЛ конкретного физического лица.
// Вызывается из вспомогательной формы документа
//
// Параметры:
//  Объект        - ДанныеФормыСтруктура
//  ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//
Процедура ПересчитатьНДФЛ(Объект, ФизическоеЛицо) Экспорт
	
	СотрудникиОрганизации = СотрудникиФизическогоЛица(Объект, ФизическоеЛицо);
	Если СотрудникиОрганизации.Количество() > 0 Тогда
		ОбновитьНДФЛиВзносыСотрудников(Объект, СотрудникиОрганизации.ВыгрузитьКолонку("Сотрудник"), Истина, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Процедура инициирует перерасчет взносов конкретного физического лица.
// Вызывается из вспомогательной формы документа
//
// Параметры:
//  Объект         - ДанныеФормыСтруктура
//  ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//
Процедура ПересчитатьВзносы(Объект, ФизическоеЛицо) Экспорт
	
	СотрудникиОрганизации = СотрудникиФизическогоЛица(Объект, ФизическоеЛицо);
	Если СотрудникиОрганизации.Количество() > 0 Тогда
		ОбновитьНДФЛиВзносыСотрудников(Объект, СотрудникиОрганизации.ВыгрузитьКолонку("Сотрудник"), Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция СотрудникиФизическогоЛица(Объект, ФизическоеЛицо)
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация         = Объект.Организация;
	ПараметрыПолученияСотрудников.НачалоПериода       = Объект.МесяцНачисления;
	ПараметрыПолученияСотрудников.ОкончаниеПериода    = КонецМесяца(Объект.МесяцНачисления);
	ПараметрыПолученияСотрудников.СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	
	Возврат КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников);
	
КонецФункции

#КонецОбласти

#КонецЕсли