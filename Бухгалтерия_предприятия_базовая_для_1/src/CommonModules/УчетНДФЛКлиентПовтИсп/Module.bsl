
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОписаниеКодаДохода(КодДохода) Экспорт
	Возврат УчетНДФЛВызовСервера.ПолучитьОписаниеКодаДохода(КодДохода);		
КонецФункции

Функция ВычетыКДоходам(ГодНалоговогоПериода) Экспорт
	Возврат УчетНДФЛВызовСервера.ВычетыКДоходам(ГодНалоговогоПериода);	
КонецФункции

Функция ВычетВПределахНормативовПоАвторскимВознаграждениям() Экспорт

	Возврат ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыВычетовНДФЛ.Код405");

КонецФункции

#КонецОбласти
