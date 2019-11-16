#Область ПрограммныйИнтерфейс

// В процедуре требуется реализовать открытие формы нового документа инвентаризации (пересчета товаров).
//
// Параметры:
//   Форма - УправляемаяФорма - форма запущенной обработки корректировки остатков,
//   ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - склад пересчета.
//
Процедура СоздатьПриказНаПроведениеИнвентаризации(Форма, ТорговыйОбъект) Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Склад", ТорговыйОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ИнвентаризацияТоваровНаСкладе.ФормаОбъекта",
		ПараметрыФормы,
		Форма,
		Форма.УникальныйИдентификатор);
	
КонецПроцедуры

// В процедуре требуется реализовать открытие формы списка документов инвентаризации (пересчета товаров).
//
// Параметры:
//   Форма - УправляемаяФорма - форма запущенной обработки корректировки остатков,
//   ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - склад пересчета.
//
Процедура ОткрытьСписокИнвентаризаций(Форма, ТорговыйОбъект) Экспорт
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Склад", ТорговыйОбъект);
	
	ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму("Документ.ИнвентаризацияТоваровНаСкладе.ФормаСписка",
		ПараметрыФормы,
		Форма,
		Форма.УникальныйИдентификатор);

	
КонецПроцедуры

// Формирует отчет по излишкам/недостачам для переданного торгового объекта.
//
// Параметры:
//   Форма - УправляемаяФорма - форма запущенной обработки корректировки остатков,
//   ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - склад пересчета.
//
Процедура СформироватьОтчетПоИзлишкамНедостачам(Форма, ТорговыйОбъект) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
