#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОбновлениеСобытий(Результат) Экспорт

	НадежностьБанков.ПроверитьОбновлениеСобытий(Результат);

КонецПроцедуры

Функция ИнформацияОКритичномСобытии(БИК) Экспорт

	Возврат НадежностьБанков.ИнформацияОКритичномСобытии(БИК);

КонецФункции

Функция ПолучитьСобытияБанковОрганизацийВФоне() Экспорт
	
	Возврат НадежностьБанков.ПолучитьСобытияБанковОрганизацийВФоне();
	
КонецФункции

#КонецОбласти
