////////////////////////////////////////////////////////////////////////////////
// СписаниеСРасчетногоСчетаФормыВызовСервера: серверные процедуры и функции,
// вызываемые из форм документа "Списание с расчетного счета".
//
////////////////////////////////////////////////////////////////////////////////

#Область РасшифровкаПлатежа

Процедура ЗаполнитьОтражениеСтрокиВУСННаСервере(СтрокаПлатеж, Знач ПараметрыУСН) Экспорт
	
	НалоговыйУчетУСН.ЗаполнитьОтражениеВУСНСтрокиРасшифровкиПлатежа(СтрокаПлатеж, ПараметрыУСН);
	
КонецПроцедуры

Функция НастроитьСтатьяДДСДляОперации(СтатьяДДС, КонтекстОперации) Экспорт
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.СтатьиДвиженияДенежныхСредств) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Не БанкИКассаФормы.СтатьяДДСДляОперацииНастроена(СтатьяДДС, КонтекстОперации);
	
КонецФункции

Процедура УстановитьСтатьюДДСПоУмолчанию(РезультатВыполнения) Экспорт
	
	СтатьяДДСОбъект = РезультатВыполнения.СтатьяДДС.ПолучитьОбъект();
	ЗаполнитьЗначенияСвойств(СтатьяДДСОбъект, РезультатВыполнения);
	СтатьяДДСОбъект.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура УстановитьДоговорУмолчанию(Договор) Экспорт
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьОсновнойДоговорКонтрагента(Договор);
	
КонецПроцедуры

Функция НастроитьОсновнойДоговор(ПараметрыПлатежа) Экспорт
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ОсновныеДоговорыКонтрагента) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Не БанкИКассаФормы.ЕстьОсновнойДоговор(ПараметрыПлатежа);
	
КонецФункции

#КонецОбласти

#Область ПеречислениеЗаработнойПлаты

Функция СуммаЗаработнойПлатыПоВедомости(Знач ПлатежнаяВедомость, Знач Ссылка, Знач УчетЗарплатыИКадровВоВнешнейПрограмме) Экспорт
	
	Возврат СписаниеСРасчетногоСчетаФормы.СуммаЗаработнойПлатыПоВедомости(
		ПлатежнаяВедомость, Ссылка, УчетЗарплатыИКадровВоВнешнейПрограмме);
	
КонецФункции

#КонецОбласти

#Область ПеречислениеДепонентов

Функция СуммаНеВыплаченнойЗарплатыРаботнику(Знач Ссылка, Знач Организация, Знач Дата, Знач ФизЛицо, Знач ПлатежнаяВедомость, Знач УчетЗарплатыИКадровВоВнешнейПрограмме) Экспорт
	
	Возврат СписаниеСРасчетногоСчетаФормы.СуммаНеВыплаченнойЗарплатыРаботнику(
		Ссылка, Организация, Дата, ФизЛицо, ПлатежнаяВедомость, УчетЗарплатыИКадровВоВнешнейПрограмме);
	
КонецФункции

#КонецОбласти

#Область ПеречислениеНалога

Функция ДанныеВыбораНалогаПоКБК(Знач КодБК) Экспорт
	
	Возврат Справочники.ВидыНалоговИПлатежейВБюджет.ДанныеВыбораПоКБК(КодБК);
	
КонецФункции

Функция ПоместитьРасшифровкуНалоговыйАгентНДСВХранилище(Объект) Экспорт
	
	Возврат СписаниеСРасчетногоСчетаФормы.ПоместитьРасшифровкуНалоговыйАгентНДСВХранилище(Объект);
	
КонецФункции

#КонецОбласти

#Область ИзмененияВОрганизации

Процедура ОбработатьИзмененияВОрганизации(Знач Организация, ИспользоватьНесколькоБанковскихСчетовОрганизации, ОсновнойБанковскийСчетОрганизацииЗаполнен, СчетОрганизации) Экспорт
	
	ИспользоватьНесколькоБанковскихСчетовОрганизации =
		Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация);
	
	ОсновнойБанковскийСчетОрганизацииЗаполнен =
		ПроверкаРеквизитовОрганизации.ОсновнойБанковскийСчетОрганизацииЗаполнен(Организация);
	
	Если
		НЕ ИспользоватьНесколькоБанковскихСчетовОрганизации
		И ОсновнойБанковскийСчетОрганизацииЗаполнен
		И НЕ ЗначениеЗаполнено(СчетОрганизации) Тогда
		СчетОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
