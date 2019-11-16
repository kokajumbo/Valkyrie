#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ЮридическоеФизическоеЛицо")
		= Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		
		КПП = "";
		
	КонецЕсли;
	
	Если НЕ ОбособленноеПодразделение Тогда
		НаименованиеПолное = "";
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И НЕ ОбособленноеПодразделение И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ОбособленноеПодразделение") Тогда
	
		РегистрыСведений.ЛимитОстаткаКассыОрганизаций.УдалитьЗаписиСПодразделением(Владелец, Ссылка);
	
	КонецЕсли;

	Если НЕ ЭтоНовый() Тогда
		
		// Запишем старые реквизиты подразделения
		// В том случае, если у подразделения меняется регистрация, то нужно будет обновить НаименованиеСлужебное в прежней регистрации
		// Это связано с тем, что, например, несколько подразделений на общем балансе могут ссылаться на одну регистрацию
		// Т.к. НаименованиеСлужебное отражает актуальную привязку к обособленному подразделению организации, понятную пользователю,
		//	то у прежней регистрации НаименованиеСлужебное, возможно, не будет верным - понадобится обновить
		
		РеквизитыДоЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Наименование, НаименованиеПолное, РегистрацияВНалоговомОргане, ОбособленноеПодразделение");
		
		ДополнительныеСвойства.Вставить("НаименованиеДоЗаписи", РеквизитыДоЗаписи.Наименование);
		ДополнительныеСвойства.Вставить("НаименованиеПолноеДоЗаписи", РеквизитыДоЗаписи.НаименованиеПолное);
		ДополнительныеСвойства.Вставить("РегистрацияВНалоговомОрганеДоЗаписи", РеквизитыДоЗаписи.РегистрацияВНалоговомОргане);
		ДополнительныеСвойства.Вставить("ОбособленноеПодразделениеДоЗаписи", РеквизитыДоЗаписи.ОбособленноеПодразделение);
		
	КонецЕсли;
	
	НастройкаПорядкаЭлементов.ЗаполнитьЗначениеРеквизитаУпорядочивания(ЭтотОбъект, Отказ);
	РеквизитИерархическогоУпорядочивания = РеквизитИерархическогоУпорядочивания();
	Если РеквизитДопУпорядочиванияИерархического <> РеквизитИерархическогоУпорядочивания Тогда
		РеквизитДопУпорядочиванияИерархического = РеквизитИерархическогоУпорядочивания;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("Организация") и ЗначениеЗаполнено(ДанныеЗаполнения.Организация) Тогда
			ЭтотОбъект.Владелец = ДанныеЗаполнения.Организация
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Владелец) Тогда
		Владелец = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	// Заполняем значениями по умолчанию реквизиты, оставшиеся пустыми.
	Если ЗначениеЗаполнено(Владелец) 
		И ЗначениеЗаполнено(Родитель) Тогда
		ОбособленноеПодразделение = Родитель.ОбособленноеПодразделение;
		Если ОбособленноеПодразделение Тогда
			КПП        = Родитель.КПП;
			Префикс    = Родитель.Префикс;
			РегистрацияВНалоговомОргане = Родитель.РегистрацияВНалоговомОргане;
			НаименованиеПолное          = Родитель.НаименованиеПолное;
			ЦифровойИндексОбособленногоПодразделения = Родитель.ЦифровойИндексОбособленногоПодразделения;
			КодПоОКПО     = Родитель.КодПоОКПО;
			КодОрганаФСГС = Родитель.КодОрганаФСГС;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПрефиксБП20 = "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ПодразделенияОрганизаций.ПроверитьЗначениеОпцииИспользоватьНесколькоПодразделений(ЭтотОбъект.Владелец);
	
	ОбновитьРеквизитИерархическогоУпорядочивания(Ссылка, РеквизитДопУпорядочиванияИерархического);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РеквизитИерархическогоУпорядочивания()
	
	РеквизитИерархическогоУпорядочивания = Формат(РеквизитДопУпорядочивания, "ЧЦ=5; ЧН=; ЧВН=; ЧГ=");
	ПроверяемыйРодитель = Родитель;
	Если ЗначениеЗаполнено(ПроверяемыйРодитель) Тогда
		ЗначенияРеквизитаРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроверяемыйРодитель, "РеквизитДопУпорядочиванияИерархического");
		РеквизитИерархическогоУпорядочивания = ЗначенияРеквизитаРодителя + РеквизитИерархическогоУпорядочивания;
	КонецЕсли;
	
	Возврат РеквизитИерархическогоУпорядочивания;
	
КонецФункции

Процедура ОбновитьРеквизитИерархическогоУпорядочивания(ПодразделенияОрганизацийСсылка, РеквизитИерархическогоУпорядочивания)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодразделенияОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	ПодразделенияОрганизаций.Родитель = &ПодразделенияОрганизацийСсылка
	|	И НЕ ПодразделенияОрганизаций.РеквизитДопУпорядочиванияИерархического ПОДОБНО &РеквизитИерархическогоУпорядочивания";
	
	Запрос.УстановитьПараметр("ПодразделенияОрганизацийСсылка", ПодразделенияОрганизацийСсылка);
	Запрос.УстановитьПараметр("РеквизитИерархическогоУпорядочивания", РеквизитИерархическогоУпорядочивания + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПодразделенияОрганизацийОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Попытка 
				ПодразделенияОрганизацийОбъект.Заблокировать();
			Исключение
				ТекстИсключенияЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось изменить настройку упорядочивания для подразделения ""%1"" 
				|Возможно, подразделения редактируется другим пользователем'"),
				ПодразделенияОрганизацийОбъект.Наименование);
				ВызватьИсключение ТекстИсключенияЗаписи;
			КонецПопытки;
			ПодразделенияОрганизацийОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
