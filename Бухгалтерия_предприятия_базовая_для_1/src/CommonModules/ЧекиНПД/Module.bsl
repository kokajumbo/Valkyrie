#Область ПрограммныйИнтерфейс

// Возвращает цену услуги НПД для организации.
//
// Параметры:
//  УслугаНПД	 - СправочникСсылка.Номенклатура - Услуга, по которой нужно определить цену.
//  Организация	 - СправочникСсылка.Организация - Организация на НПД, для которой нужно вернуть цену услуги.
//  Дата		 - Дата - Дата, на которую нужно вернуть цену.
// 
// Возвращаемое значение:
//   - Число - цена услуги НПД.
//
Функция ЦенаУслугиНПД(УслугаНПД, Организация, Дата) Экспорт
	
	ДанныеОбъекта = Новый Структура();
	ДанныеОбъекта.Вставить("Дата", Дата);
	ДанныеОбъекта.Вставить("Организация", Организация);
	ДанныеОбъекта.Вставить("СпособЗаполненияЦены", Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам);
	ДанныеОбъекта.Вставить("СуммаВключаетНДС", СуммаВключаетНДСДляНПД());
	ДанныеОбъекта.Вставить("СтавкаНДС", Перечисления.СтавкиНДС.БезНДС);
	
	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		УслугаНПД, ДанныеОбъекта, Ложь);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат СведенияОНоменклатуре.Цена;
	
КонецФункции

// Сохраняет цену услуги НПД при записи документа.
//
// Параметры:
//  Объект	 - ДокументСсылка - Документ, в котором указывается цена НПД.
//             В модуле менеджера данного документа должна быть реализована функция ТекстЗапросаДанныеДляОбновленияЦенДокументов().
// 
Процедура СохранитьЦенуУслугиНПД(Объект) Экспорт
	
	Ценообразование.ОбновитьЦеныНоменклатуры(Объект.Ссылка,
		Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам,
		Объект.ВалютаДокумента,
		СуммаВключаетНДСДляНПД());
	
КонецПроцедуры

// Возвращает контактную информацию для отправки чека.
//
// Параметры:
//  Контрагент	 - СправочникСсылка.Контрагенты - Контрагент, для которого возвращается контактная информация.
// 
// Возвращаемое значение:
//   - Структура - контактная информация для отправки чека.
//
Функция ПараметрыОтправкиЧека(Контрагент) Экспорт
	
	ПараметрыОтправки = Новый Структура;
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат ПараметрыОтправки;
	КонецЕсли;
	
	АдресЭлектроннойПочты = УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияНаДату(
		Контрагент, Справочники.ВидыКонтактнойИнформации.EmailКонтрагенты);
	
	Если ЗначениеЗаполнено(АдресЭлектроннойПочты.Представление) Тогда
		ПараметрыОтправки.Вставить("АдресЭлектроннойПочты", АдресЭлектроннойПочты.Представление);
	КонецЕсли;
	
	Телефон = УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияНаДату(
		Контрагент, Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
	
	Если ЗначениеЗаполнено(Телефон.Представление) Тогда
		ПараметрыОтправки.Вставить("НомерТелефона", Телефон.Представление);
	КонецЕсли;
	
	Возврат ПараметрыОтправки;
	
КонецФункции

// Процедура "УстановитьВДинамическомСпискеПредставленияАннулированныхЧеков"
//
// Параметры:
//  Строки - СтрокиДинамическогоСписка - в которых необходимо изменить представление поля "НомерЧека"
//
Процедура УстановитьВДинамическомСпискеПредставленияАннулированныхЧеков(Строки) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ДоступнаИнтеграцияСПлатформойСамозанятые") Тогда
		СостояниеАннулирован = Перечисления.СостоянияЧековНПД.Аннулирован;
		Для Каждого Строка Из Строки Цикл
			ДанныеСтроки = Строка.Значение.Данные;
			Если ДанныеСтроки.Состояние = СостояниеАннулирован
				Или ДанныеСтроки.ПроизведенВозвратПоЧеку Тогда
				ДанныеСтроки.НомерЧека = РегистрыСведений.ЧекиНПД.ПредставлениеАннулированногоЧека(
					ДанныеСтроки.НомерЧека, ДанныеСтроки.ДатаАннулированияЧека);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СуммаВключаетНДСДляНПД()
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
