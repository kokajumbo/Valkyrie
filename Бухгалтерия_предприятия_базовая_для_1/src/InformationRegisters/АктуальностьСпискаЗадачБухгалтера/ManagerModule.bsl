#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

// Возвращает дату актуальности списка задач бухгалтера. Если передана пустая ссылка, то
// минимальную дату для всех организаций не помеченных на удаление.
//
Функция ДатаАктуальности(Организация) Экспорт
	
	Запрос = Новый Запрос;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АктуальностьСпискаЗадачБухгалтера.ДатаАктуальности
		|ИЗ
		|	РегистрСведений.АктуальностьСпискаЗадачБухгалтера КАК АктуальностьСпискаЗадачБухгалтера
		|ГДЕ
		|	АктуальностьСпискаЗадачБухгалтера.Организация = &Организация";
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(МИНИМУМ(АктуальностьСпискаЗадачБухгалтера.ДатаАктуальности), ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаАктуальности
		|ИЗ
		|	Справочник.Организации КАК Организации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктуальностьСпискаЗадачБухгалтера КАК АктуальностьСпискаЗадачБухгалтера
		|		ПО Организации.Ссылка = АктуальностьСпискаЗадачБухгалтера.Организация
		|ГДЕ
		|	НЕ Организации.ПометкаУдаления";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ДатаАктуальности;
	Иначе
		Результат = '00010101'
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
