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

#Область ОбработчикиОбновления

Процедура ЗаполнитьПриОбновлении() Экспорт
	
	НаборДанныхБанковскиеСчетаИнтеграции = РегистрыСведений.БанковскиеСчетаИнтеграцииСБанком.СоздатьНаборЗаписей();
	НаборДанныхБанковскиеСчетаИнтеграции.Прочитать();
	Если НаборДанныхБанковскиеСчетаИнтеграции.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиИнтеграцииСБанками.Ссылка КАК НастройкаИнтеграции,
	|	БанковскиеСчета.Ссылка КАК БанковскийСчет,
	|	БанковскиеСчета.Владелец КАК Организация
	|ИЗ
	|	Справочник.НастройкиИнтеграцииСБанками КАК НастройкиИнтеграцииСБанками
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиИнтеграцииСБанками.Банки КАК НастройкиИнтеграцииСБанкамиБанки
	|		ПО НастройкиИнтеграцииСБанками.Ссылка = НастройкиИнтеграцииСБанкамиБанки.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ПО (БанковскиеСчета.Банк = НастройкиИнтеграцииСБанкамиБанки.Банк)
	|			И (БанковскиеСчета.Владелец ССЫЛКА Справочник.Организации)
	|ГДЕ
	|	НастройкиИнтеграцииСБанками.ПометкаУдаления = ЛОЖЬ";
	
	БанковскиеСчетаИнтеграции = Запрос.Выполнить().Выгрузить();
	НаборДанныхБанковскиеСчетаИнтеграции.Загрузить(БанковскиеСчетаИнтеграции);
	ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборДанныхБанковскиеСчетаИнтеграции);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
