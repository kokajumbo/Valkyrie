
#Область СлужебныеПроцедурыИФункции

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	УчетДепонированнойЗарплатыБазовый.ПриЗаполненииСписковСОграничениемДоступа(Списки);
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	УчетДепонированнойЗарплатыБазовый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание)
КонецПроцедуры

Процедура ДепонированиеЗарплатыОбработкаПроведения(ДокументОбъект, Отказ) Экспорт
	УчетДепонированнойЗарплатыБазовый.ДепонированиеЗарплатыОбработкаПроведения(ДокументОбъект, Отказ);
КонецПроцедуры

// Возвращает описание команды печати реестра депонированных сумм.
// 
// Возвращаемое значение:
//   Структура - структура с полями:
//		* ПредставлениеКоманды - строка.
//
Функция ОписаниеПечатиРеестраДепонированныхСумм() Экспорт
	Возврат УчетДепонированнойЗарплатыБазовый.ОписаниеПечатиРеестраДепонированныхСумм()
КонецФункции

Процедура ПриКомпоновкеОтчетаКнигаУчетаДепонентов(Объект, ДокументРезультат, СтандартнаяОбработка) Экспорт
	УчетДепонированнойЗарплатыБазовый.ПриКомпоновкеОтчетаКнигаУчетаДепонентов(Объект, ДокументРезультат, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти
