
////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму разбора банковской выписки.
//
// Параметры:
//   СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение с выпиской банка.
//
Процедура РазобратьВыпискуБанка(СообщениеОбмена) Экспорт
	
	ДанныеВыписки = ЭлектронноеВзаимодействиеБПВызовСервера.ПолучитьДанныеВыпискиБанкаТекстовыйФормат(СообщениеОбмена);
	
	Если НЕ ЗначениеЗаполнено(ДанныеВыписки.СсылкаНаХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимПоУмолчанию",                "ГруппаЗагрузка");
	ПараметрыОткрытия.Вставить("Организация",                     ДанныеВыписки.Организация);
	ПараметрыОткрытия.Вставить("ЭлектроннаяВыпискаБанка",         СообщениеОбмена);
	ПараметрыОткрытия.Вставить("СоглашениеПрямогоОбменаСБанками", ДанныеВыписки.НастройкаОбмена);
	ПараметрыОткрытия.Вставить("АдресФайлаВыписки",               ДанныеВыписки.СсылкаНаХранилище);
	Если ДанныеВыписки.МассивСчетов.Количество()>0 Тогда
		ПараметрыОткрытия.Вставить("БанковскийСчет",              ДанныеВыписки.МассивСчетов[0]);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КлиентБанк.Форма", ПараметрыОткрытия);
	
КонецПроцедуры


#КонецОбласти
