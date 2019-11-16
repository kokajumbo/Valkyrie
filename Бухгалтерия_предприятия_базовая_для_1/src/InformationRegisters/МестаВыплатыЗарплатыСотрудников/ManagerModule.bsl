#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает допустимые значения видов мест выплаты зарплаты сотрудников.
//
// Возвращаемое значение:
//	Массив элементов типа ПеречислениеСсылка.ВидыМестВыплатыЗарплаты.
//
Функция ДопустимыеВидыМестВыплаты() Экспорт
	
	Возврат Перечисления.ВидыМестВыплатыЗарплаты.ВсеЗначения()
	
КонецФункции	

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура УстановитьМестаВыплатыЗарплатыСотрудников() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаВыплатыЗарплатыСотрудников.Сотрудник КАК Сотрудник,
	|	МестаВыплатыЗарплатыСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация, МестаВыплатыЗарплатыСотрудников.Сотрудник.ГоловнаяОрганизация) КАК Организация
	|ПОМЕСТИТЬ ВТ_Исключения
	|ИЗ
	|	РегистрСведений.МестаВыплатыЗарплатыСотрудников КАК МестаВыплатыЗарплатыСотрудников,
	|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект) КАК Вид
	|ПОМЕСТИТЬ ВТ_ВыплатаЗарплатныйПроект
	|ИЗ
	|	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ПО ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация = ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация
	|			И ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо = ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо
	|ГДЕ
	|	НЕ ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо В
	|				(ВЫБРАТЬ
	|					ВТ_Исключения.ФизическоеЛицо
	|				ИЗ
	|					ВТ_Исключения)
	|	И НЕ ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация В
	|				(ВЫБРАТЬ
	|					ВТ_Исключения.Организация
	|				ИЗ
	|					ВТ_Исключения)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник КАК Сотрудник,
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.БанковскийСчет) КАК Вид
	|ПОМЕСТИТЬ ВТ_ВыплатаБанковскийСчет
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьНаВыплатуЗарплатыВБанкЗарплата
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.ЗарплатныйПроект = ЗНАЧЕНИЕ(Справочник.ЗарплатныеПроекты.ПустаяСсылка)
	|	И НЕ ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник В
	|				(ВЫБРАТЬ
	|					ВТ_ВыплатаЗарплатныйПроект.Сотрудник
	|				ИЗ
	|					ВТ_ВыплатаЗарплатныйПроект)
	|	И НЕ ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник В
	|				(ВЫБРАТЬ
	|					ВТ_Исключения.Сотрудник
	|				ИЗ
	|					ВТ_Исключения)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.ФизическоеЛицо,
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Ссылка КАК Сотрудник,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.Касса) КАК Вид
	|ПОМЕСТИТЬ ВТ_ВыплатаКасса
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	НЕ Сотрудники.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТ_ВыплатаЗарплатныйПроект.Сотрудник
	|				ИЗ
	|					ВТ_ВыплатаЗарплатныйПроект)
	|	И НЕ Сотрудники.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТ_ВыплатаБанковскийСчет.Сотрудник
	|				ИЗ
	|					ВТ_ВыплатаБанковскийСчет)
	|	И НЕ Сотрудники.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТ_Исключения.Сотрудник
	|				ИЗ
	|					ВТ_Исключения)
	|
	|СГРУППИРОВАТЬ ПО
	|	Сотрудники.Ссылка,
	|	Сотрудники.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВыплатаЗарплатныйПроект.Сотрудник КАК Сотрудник,
	|	ВТ_ВыплатаЗарплатныйПроект.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТ_ВыплатаЗарплатныйПроект.Вид КАК Вид
	|ПОМЕСТИТЬ ВТ_МестаВыплаты
	|ИЗ
	|	ВТ_ВыплатаЗарплатныйПроект КАК ВТ_ВыплатаЗарплатныйПроект
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ВыплатаБанковскийСчет.Сотрудник,
	|	ВТ_ВыплатаБанковскийСчет.ФизическоеЛицо,
	|	ВТ_ВыплатаБанковскийСчет.Вид
	|ИЗ
	|	ВТ_ВыплатаБанковскийСчет КАК ВТ_ВыплатаБанковскийСчет
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ВыплатаКасса.Сотрудник,
	|	ВТ_ВыплатаКасса.ФизическоеЛицо,
	|	ВТ_ВыплатаКасса.Вид
	|ИЗ
	|	ВТ_ВыплатаКасса КАК ВТ_ВыплатаКасса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_МестаВыплаты.Сотрудник КАК Сотрудник,
	|	ВТ_МестаВыплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МАКСИМУМ(ВТ_МестаВыплаты.Вид) КАК Вид
	|ИЗ
	|	ВТ_МестаВыплаты КАК ВТ_МестаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_МестаВыплаты.Сотрудник,
	|	ВТ_МестаВыплаты.ФизическоеЛицо";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЗапроса = Результат.Выгрузить();
	
	НаборЗаписей = РегистрыСведений.МестаВыплатыЗарплатыСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		ТаблицаРезультата = ТаблицаЗапроса;
	Иначе
		ТаблицаРезультата = НаборЗаписей.Выгрузить();
		Для Каждого СтрокаТаблицы ИЗ ТаблицаЗапроса Цикл
			НоваяСтрока = ТаблицаРезультата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		КонецЦикла;
	КонецЕсли;
	НаборЗаписей.Загрузить(ТаблицаРезультата);
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Сотрудник.ФизическоеЛицо)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли