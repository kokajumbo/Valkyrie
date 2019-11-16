#Область ПрограммныйИнтерфейс

// Возвращает Истина, если в базе есть хотя бы одна действующая настройка интеграции.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ИнтеграцияВИнформационнойБазеВключена() Экспорт
	
	Возврат Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВИнформационнойБазеВключена();
	
КонецФункции

// Возвращает Истина, если для расчетного счета включена интеграция.
//
// Параметры:
//  СчетОрганизации	 - СправочникСсылка.БанковскиеСчета - Ссылка на расчетный счет организации.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ИнтеграцияВключена(СчетОрганизации) Экспорт
	
	Возврат Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВключена(СчетОрганизации);
	
КонецФункции

#КонецОбласти
