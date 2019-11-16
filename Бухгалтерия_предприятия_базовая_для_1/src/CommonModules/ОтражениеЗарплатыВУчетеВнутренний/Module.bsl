////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в учете
// Переопределяемое в пределах библиотеки поведение.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТУдержанияПоСотрудникамКонтрагент(МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВУчетеБазовый.СоздатьВТУдержанияПоСотрудникамКонтрагент(МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура ДополнитьТаблицуНДФЛ(ПериодРегистрации, Организация, МенеджерВременныхТаблиц) Экспорт

	// В базовой реализации не требуется дополнение.

КонецПроцедуры

Процедура ДополнитьТаблицуНачислений(ПериодРегистрации, Организация, МенеджерВременныхТаблиц, Сотрудники) Экспорт

	// В базовой реализации не требуется дополнение.

КонецПроцедуры

Процедура ДополнитьТаблицуУдержаний(ПериодРегистрации, Организация, МенеджерВременныхТаблиц) Экспорт

	// В базовой реализации не требуется дополнение.

КонецПроцедуры

Процедура ДополнитьМассивТиповНачисления(МассивТипов) Экспорт

	// В базовой реализации не требуется дополнение.
	
КонецПроцедуры

Функция ТипыПоляДокументОснование() Экспорт

	Возврат ОтражениеЗарплатыВУчетеБазовый.ТипыПоляДокументОснование();

КонецФункции

Процедура ДополнитьТаблицуНачислениеУдержаниеВидОперации(Таблица) Экспорт

	// В базовой реализации не требуется дополнение.

КонецПроцедуры

// Дополняет записи набора записей регистра НДФЛКПеречислению аналитикой: Статьи финансирования, Статьи расходов
// Параметры 
//		Движения - коллекции наборов записей движений документа, должна содержать коллекции еще не записанных наборов
//			НДФЛКПеречислению
//		ДанныеДляДополнения - структура см ОтражениеЗарплатыВУчете.ОписаниеДанныхДляДополненияНДФЛСтатьями.
//
Процедура ДополнитьНДФЛКПеречислениюСведениямиОРаспределенииПоСтатьям(Движения, ДанныеДляДополнения) Экспорт

	// В базовой реализации не требуется дополнение.
	
КонецПроцедуры

// Дополняет записи набора записей регистра НДФЛПеречисленный аналитикой: Статьи финансирования, Статьи расходов
// Параметры 
//		Движения - коллекции наборов записей движений документа, должна содержать коллекции еще не записанных наборов
//			НДФЛПеречисленный
//		ДанныеДляДополнения - структура см ОтражениеЗарплатыВУчете.ОписаниеДанныхДляДополненияНДФЛСтатьями.
//
Процедура ДополнитьНДФЛПеречисленныйСведениямиОРаспределенииПоСтатьям(Движения, ДанныеДляДополнения) Экспорт
	
	// В базовой реализации не требуется дополнение.
	
КонецПроцедуры

#КонецОбласти
