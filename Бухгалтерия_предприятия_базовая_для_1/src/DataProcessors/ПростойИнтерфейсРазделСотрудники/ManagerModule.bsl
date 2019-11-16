#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура собирает данные о сотрудниках и состоянии взаиморасчетов с ними
// Параметры:
//   ПараметрыОбработки - Структура, содержит параметры получения данных
//                        Состав:
//                              Организация       - СправочникСсылка.Организации
//                              ПериодРегистрации - Дата, дата месяца за который выводятся данные
//                              ТекущаяДатаРаботы - Дата, текущая дата работы пользователя
//                              Параметр          - произвольный
//   АдресХранилища     - Строка, адрес временного хранилище
//
Процедура ПодготовитьДанные(ПараметрыОбработки, АдресХранилища) Экспорт
	
	РезультатВыполнения = Новый Структура();
	РезультатВыполнения.Вставить("ОбновитьВесьСписок",  Ложь);
	РезультатВыполнения.Вставить("ОбновитьСотрудников", Ложь);
	РезультатВыполнения.Вставить("Список", "");
	
	Организация             = ПараметрыОбработки.Организация;
	ПериодРегистрации       = ПараметрыОбработки.ПериодРегистрации;
	ПериодРегистрацииНачало = НачалоМесяца(ПериодРегистрации);
	ПериодРегистрацииКонец  = КонецМесяца(ПериодРегистрации);
	ПериодОборотов          = ПараметрыОбработки.ТекущаяДатаРаботы;
	ПериодОстатков          = ДобавитьМесяц(ПараметрыОбработки.ТекущаяДатаРаботы,1);
	Параметр                = ПараметрыОбработки.Параметр;
	МассивСотрудников       = Неопределено;
	Если ЗначениеЗаполнено(Параметр) Тогда
		МассивСотрудников = МассивСотрудниковПоПараметру(Организация, Параметр);
		Если МассивСотрудников.Количество() = 0 Тогда
			ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ГоловнаяОрганизация");
	Иначе
		ГоловнаяОрганизация  = Организация;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НачислениеДивидендов.Ссылка КАК Ссылка,
	|	НачислениеДивидендов.Учредитель КАК ФизическоеЛицо,
	|	СУММА(НачислениеДивидендов.СуммаДохода) КАК НачисленоДивиденды,
	|	СУММА(НачислениеДивидендов.СуммаНалога) КАК НДФЛДивиденды
	|ПОМЕСТИТЬ ВТ_ДокументыДивидендов
	|ИЗ
	|	Документ.НачислениеДивидендов КАК НачислениеДивидендов
	|ГДЕ
	|	НачислениеДивидендов.Организация = &Организация
	|	И НачислениеДивидендов.Дата МЕЖДУ &ПериодРегистрацииНачало И &ПериодРегистрацииКонец
	|	И НачислениеДивидендов.Проведен
	|	И НачислениеДивидендов.ТипУчредителя = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо)
	|
	|СГРУППИРОВАТЬ ПО
	|	НачислениеДивидендов.Ссылка,
	|	НачислениеДивидендов.Учредитель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДокументыДивидендов.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(ВТ_ДокументыДивидендов.НачисленоДивиденды) КАК НачисленоДивиденды,
	|	СУММА(ВТ_ДокументыДивидендов.НДФЛДивиденды) КАК НДФЛДивиденды
	|ПОМЕСТИТЬ ВТ_Дивиденды
	|ИЗ
	|	ВТ_ДокументыДивидендов КАК ВТ_ДокументыДивидендов
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ДокументыДивидендов.ФизическоеЛицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачисленияУдержанияПоСотрудникам.Сотрудник КАК Сотрудник,
	|	СУММА(ВЫБОР
	|			КОГДА ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание КАК ПланВидовРасчета.Начисления).КодДоходаНДФЛ <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)
	|					ИЛИ НЕ ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание КАК ПланВидовРасчета.Начисления).КодДоходаСтраховыеВзносы В (ЗНАЧЕНИЕ(Справочник.ВидыДоходовПоСтраховымВзносам.НеЯвляетсяОбъектом), ЗНАЧЕНИЕ(Справочник.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликом))
	|					ИЛИ ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание КАК ПланВидовРасчета.Начисления) В (ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ДоговорАвторскогоЗаказа), ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ДоговорРаботыУслуги))
	|				ТОГДА НачисленияУдержанияПоСотрудникам.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Начислено,
	|	СУММА(ВЫБОР
	|			КОГДА НачисленияУдержанияПоСотрудникам.НачислениеУдержание = ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ)
	|				ТОГДА НачисленияУдержанияПоСотрудникам.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НДФЛ,
	|	СУММА(ВЫБОР
	|			КОГДА НачисленияУдержанияПоСотрудникам.НачислениеУдержание ССЫЛКА ПланВидовРасчета.Удержания
	|				ТОГДА НачисленияУдержанияПоСотрудникам.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ИсполнительныйЛист
	|ПОМЕСТИТЬ ВТ_НачисленияУдержанияПоСотрудникам
	|ИЗ
	|	РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
	|ГДЕ
	|	НачисленияУдержанияПоСотрудникам.Период МЕЖДУ &ПериодРегистрацииНачало И &ПериодРегистрацииКонец
	|	И НачисленияУдержанияПоСотрудникам.Организация = &Организация
	|	И НачисленияУдержанияПоСотрудникам.Сотрудник В(&МассивСотрудников)
	|
	|СГРУППИРОВАТЬ ПО
	|	НачисленияУдержанияПоСотрудникам.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(СписаниеСРасчетногоСчета.СуммаДокумента) КАК СуммаДокумента,
	|	СписаниеСРасчетногоСчета.Контрагент КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТ_ВыплатаДивидендовПромежуточная
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	СписаниеСРасчетногоСчета.Организация = &Организация
	|	И СписаниеСРасчетногоСчета.Проведен
	|	И СписаниеСРасчетногоСчета.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов)
	|	И СписаниеСРасчетногоСчета.НачислениеДивидендов В
	|			(ВЫБРАТЬ
	|				ВТ_ДокументыДивидендов.Ссылка
	|			ИЗ
	|				ВТ_ДокументыДивидендов)
	|
	|СГРУППИРОВАТЬ ПО
	|	СписаниеСРасчетногоСчета.Контрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СУММА(РасходныйКассовыйОрдер.СуммаДокумента),
	|	РасходныйКассовыйОрдер.Контрагент
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Организация = &Организация
	|	И РасходныйКассовыйОрдер.Проведен
	|	И РасходныйКассовыйОрдер.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВыплатаДивидендов)
	|	И РасходныйКассовыйОрдер.НачислениеДивидендов В
	|			(ВЫБРАТЬ
	|				ВТ_ДокументыДивидендов.Ссылка
	|			ИЗ
	|				ВТ_ДокументыДивидендов)
	|
	|СГРУППИРОВАТЬ ПО
	|	РасходныйКассовыйОрдер.Контрагент
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ_ВыплатаДивидендовПромежуточная.СуммаДокумента) КАК СуммаДокумента,
	|	ВТ_ВыплатаДивидендовПромежуточная.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТ_ВыплатаДивидендов
	|ИЗ
	|	ВТ_ВыплатаДивидендовПромежуточная КАК ВТ_ВыплатаДивидендовПромежуточная
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ВыплатаДивидендовПромежуточная.ФизическоеЛицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеОбороты.Сотрудник КАК Сотрудник,
	|	СУММА(ЗарплатаКВыплатеОбороты.СуммаКВыплатеРасход) КАК Выплачено
	|ПОМЕСТИТЬ ВТ_Выплаты
	|ИЗ
	|	РегистрНакопления.ЗарплатаКВыплате.Обороты(
	|			&ПериодРегистрацииНачало,
	|			&ПериодОборотов,
	|			Период,
	|			Организация = &Организация
	|				И ПериодВзаиморасчетов = &ПериодРегистрации
	|				И Сотрудник В (&МассивСотрудников)) КАК ЗарплатаКВыплатеОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОбороты.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|	СУММА(ВЫБОР
	|			КОГДА ЗарплатаКВыплатеОстатки.СуммаКВыплатеОстаток < 0
	|				ТОГДА 0
	|			ИНАЧЕ ЗарплатаКВыплатеОстатки.СуммаКВыплатеОстаток
	|		КОНЕЦ) КАК КВыплате
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.ЗарплатаКВыплате.Остатки(
	|			&ПериодОстатков,
	|			Организация = &Организация
	|				И ПериодВзаиморасчетов <= &ПериодРегистрации
	|				И Сотрудник В (&МассивСотрудников)) КАК ЗарплатаКВыплатеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОстатки.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникСотрудники.Ссылка КАК Ссылка,
	|	СправочникСотрудники.ВерсияДанных КАК ВерсияДанных,
	|	СправочникСотрудники.ПометкаУдаления КАК ПометкаУдаления,
	|	СправочникСотрудники.Предопределенный КАК Предопределенный,
	|	СправочникСотрудники.Код КАК Код,
	|	СправочникСотрудники.Наименование КАК Наименование,
	|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СправочникСотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	СправочникСотрудники.ТекущийПроцентСевернойНадбавки КАК ТекущийПроцентСевернойНадбавки,
	|	СправочникСотрудники.ВАрхиве КАК ВАрхиве,
	|	СправочникСотрудники.УточнениеНаименования КАК УточнениеНаименования,
	|	СправочникСотрудники.ГоловнойСотрудник КАК ГоловнойСотрудник,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущийВидЗанятости, ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ПустаяСсылка)) КАК ВидЗанятости,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ОсновноеРабочееМестоВОрганизации, ЛОЖЬ) КАК ОсновноеРабочееМестоВОрганизации,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК ТекущаяОрганизация,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)) КАК ТекущееПодразделение,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяДолжность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК ТекущаяДолжность,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриема,
	|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаУвольнения,
	|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущаяТарифнаяСтавка, 0) КАК ТекущаяТарифнаяСтавка,
	|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийСпособРасчетаАванса, ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаАванса.ПустаяСсылка)) КАК ТекущийСпособРасчетаАванса,
	|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийАванс, 0) КАК ТекущийАванс,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
	|				ИЛИ ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОформленПоТрудовомуДоговору,
	|	ЕСТЬNULL(СправочникСотрудники.ФизическоеЛицо.ДатаРождения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаРождения,
	|	НАЧАЛОПЕРИОДА(ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)), МЕСЯЦ) КАК МесяцПриема,
	|	ЕСТЬNULL(ВТ_НачисленияУдержанияПоСотрудникам.Начислено, 0) КАК Начислено,
	|	ЕСТЬNULL(ВТ_Дивиденды.НачисленоДивиденды, 0) КАК НачисленоДивиденды,
	|	ЕСТЬNULL(ВТ_НачисленияУдержанияПоСотрудникам.НДФЛ, 0) + ЕСТЬNULL(ВТ_НачисленияУдержанияПоСотрудникам.ИсполнительныйЛист, 0) КАК Удержано,
	|	ЕСТЬNULL(ВТ_Выплаты.Выплачено, 0) КАК Выплачено,
	|	ЕСТЬNULL(ВТ_ВыплатаДивидендов.СуммаДокумента, 0) КАК ВыплаченоДивиденды,
	|	ЕСТЬNULL(ВТ_Остатки.КВыплате, 0) КАК КВыплате,
	|	ЕСТЬNULL(ВТ_Дивиденды.НачисленоДивиденды, 0) - ЕСТЬNULL(ВТ_Дивиденды.НДФЛДивиденды, 0) - ЕСТЬNULL(ВТ_ВыплатаДивидендов.СуммаДокумента, 0) КАК КВыплатеДивиденды,
	|	ЕСТЬNULL(ВТ_НачисленияУдержанияПоСотрудникам.НДФЛ, 0) КАК НДФЛ,
	|	ЕСТЬNULL(ВТ_Дивиденды.НДФЛДивиденды, 0) КАК НДФЛДивиденды,
	|	ЕСТЬNULL(ВТ_НачисленияУдержанияПоСотрудникам.ИсполнительныйЛист, 0) КАК ИсполнительныйЛист,
	|	ИСТИНА КАК Работает,
	|	0 КАК Картинка,
	|	"""" КАК Отступ
	|ИЗ
	|	Справочник.Сотрудники КАК СправочникСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ПО (ТекущиеКадровыеДанныеСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
	|			И (ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущаяТарифнаяСтавкаСотрудников КАК ТекущаяТарифнаяСтавкаСотрудников
	|		ПО (ТекущаяТарифнаяСтавкаСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
	|			И (ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НачисленияУдержанияПоСотрудникам КАК ВТ_НачисленияУдержанияПоСотрудникам
	|		ПО СправочникСотрудники.Ссылка = ВТ_НачисленияУдержанияПоСотрудникам.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Выплаты КАК ВТ_Выплаты
	|		ПО СправочникСотрудники.Ссылка = ВТ_Выплаты.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО СправочникСотрудники.Ссылка = ВТ_Остатки.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Дивиденды КАК ВТ_Дивиденды
	|		ПО СправочникСотрудники.ФизическоеЛицо = ВТ_Дивиденды.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВыплатаДивидендов КАК ВТ_ВыплатаДивидендов
	|		ПО СправочникСотрудники.ФизическоеЛицо = ВТ_ВыплатаДивидендов.ФизическоеЛицо
	|ГДЕ
	|	ТекущаяТарифнаяСтавкаСотрудников.ГоловнаяОрганизация = &ГоловнаяОрганизация
	|	И (ТекущаяТарифнаяСтавкаСотрудников.ТекущаяОрганизация = &Организация
	|			ИЛИ ТекущаяТарифнаяСтавкаСотрудников.ТекущаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|	И ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация = &ГоловнаяОрганизация
	|	И (ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = &Организация
	|			ИЛИ ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|	И СправочникСотрудники.Ссылка В(&МассивСотрудников)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Работает УБЫВ,
	|	ПометкаУдаления,
	|	Наименование";
	
	Если МассивСотрудников = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НачисленияУдержанияПоСотрудникам.Сотрудник В(&МассивСотрудников)", "Истина");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Сотрудник В (&МассивСотрудников)", "Истина");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СправочникСотрудники.Ссылка В(&МассивСотрудников)", "Истина");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",             Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",     ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("ПериодРегистрации",       ПериодРегистрации);
	Запрос.УстановитьПараметр("ПериодРегистрацииНачало", ПериодРегистрацииНачало);
	Запрос.УстановитьПараметр("ПериодРегистрацииКонец",  ПериодРегистрацииКонец);
	Запрос.УстановитьПараметр("ПериодОборотов",          ПериодОборотов);
	Запрос.УстановитьПараметр("ПериодОстатков",          ПериодОстатков);
	Запрос.УстановитьПараметр("МассивСотрудников",       МассивСотрудников);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить().Выгрузить();
	УстановитьСтатусыСотрудников(Результат, ПериодРегистрации);
	
	РезультатВыполнения.Вставить("ОбновитьВесьСписок",  ?(МассивСотрудников = Неопределено, Истина, Ложь));
	РезультатВыполнения.Вставить("ОбновитьСотрудников", ?(МассивСотрудников <> Неопределено, Истина, Ложь));
	РезультатВыполнения.Вставить("Список", Результат);
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

// Процедура устанавливает статус сотрудника: работает он или нет, и номер картинки для отображения в таблице
// Параметры:
//   СведенияОСотруднике - Структура таблицы значений
//   ПериодРегистрации   - Дата, дата месяца за который выводятся данные
//
Процедура УстановитьСтатусСотрудника(СведенияОСотруднике, ПериодРегистрации) Экспорт
	
	ПериодРегистрацииНачало = НачалоМесяца(ПериодРегистрации);
	ПериодРегистрацииКонец  = КонецМесяца(ПериодРегистрации);
	
	Если СведенияОСотруднике.ПометкаУдаления Тогда
		СведенияОСотруднике.Работает = Ложь;
	ИначеЕсли (НЕ ЗначениеЗаполнено(СведенияОСотруднике.ДатаУвольнения) ИЛИ КонецМесяца(СведенияОСотруднике.ДатаУвольнения) >= ПериодРегистрацииКонец)
		И ЗначениеЗаполнено(СведенияОСотруднике.ДатаПриема)
		И НачалоМесяца(СведенияОСотруднике.ДатаПриема) <= ПериодРегистрацииНачало Тогда
		СведенияОСотруднике.Работает = Истина;
	Иначе
		СведенияОСотруднике.Работает = Ложь;
	КонецЕсли;
	
	Если СведенияОСотруднике.ПометкаУдаления Тогда
		СведенияОСотруднике.Картинка = 2;
	Иначе
		Если НЕ СведенияОСотруднике.Работает Тогда
			СведенияОСотруднике.Картинка = 3;
		Иначе
			Если ЗначениеЗаполнено(СведенияОСотруднике.ДатаРождения)
				И Месяц(СведенияОСотруднике.ДатаРождения) = Месяц(ПериодРегистрации) Тогда
				СведенияОСотруднике.Картинка = 4;
			Иначе
				СведенияОСотруднике.Картинка = 1;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает массив сотрудников, вычисленный из значения 
// переданного в Параметр, обработчиком оповещения
// Параметры:
//   Параметр- Структура, СправочникСсылка.Сотрудники,
//             ДокументСсылка.НачислениеЗарплаты,
//             ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк, ДокументСсылка.ВедомостьНаВыплатуЗарплатыВКассу,
//             ДокументСсылка.Отпуск, ДокументСсылка.БольничныйЛист,
//             ДокументСсылка.ПриемНаРаботу, ДокументСсылка.КадровыйПеревод,
//             ДокументСсылка.Увольнение
//
Функция МассивСотрудниковПоПараметру(Организация, Параметр)
	
	МассивСотрудников = Новый Массив;
	
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Сотрудники") Тогда
		Если Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметр, "ГоловнаяОрганизация") Тогда
			МассивСотрудников.Добавить(Параметр);
		КонецЕсли;
		Возврат МассивСотрудников;
	КонецЕсли;
	
	Если ТипЗнч(Параметр) = Тип("Структура") Тогда
		Если Параметр.Свойство("Сотрудник") Тогда
			Если Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметр.Сотрудник, "ГоловнаяОрганизация") Тогда
				МассивСотрудников.Добавить(Параметр.Сотрудник);
			КонецЕсли;
		КонецЕсли;
		Возврат МассивСотрудников;
	КонецЕсли;
	
	Если Организация <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметр, "Организация") Тогда
		Возврат МассивСотрудников;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Параметр);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник
	|ПОМЕСТИТЬ ВТ_Сотрудники
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьНаВыплатуЗарплатыВБанкЗарплата
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВедомостьНаВыплатуЗарплатыВКассуЗарплата.Сотрудник
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу.Зарплата КАК ВедомостьНаВыплатуЗарплатыВКассуЗарплата
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВКассуЗарплата.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НачислениеЗарплатыСотрудники.Сотрудник.Ссылка
	|ИЗ
	|	Документ.НачислениеЗарплаты.Сотрудники КАК НачислениеЗарплатыСотрудники
	|ГДЕ
	|	НачислениеЗарплатыСотрудники.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Отпуск.Сотрудник
	|ИЗ
	|	Документ.Отпуск КАК Отпуск
	|ГДЕ
	|	Отпуск.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БольничныйЛист.Сотрудник
	|ИЗ
	|	Документ.БольничныйЛист КАК БольничныйЛист
	|ГДЕ
	|	БольничныйЛист.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КадровыйПеревод.Сотрудник
	|ИЗ
	|	Документ.КадровыйПеревод КАК КадровыйПеревод
	|ГДЕ
	|	КадровыйПеревод.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Увольнение.Сотрудник
	|ИЗ
	|	Документ.Увольнение КАК Увольнение
	|ГДЕ
	|	Увольнение.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриемНаРаботу.Сотрудник
	|ИЗ
	|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
	|ГДЕ
	|	ПриемНаРаботу.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Сотрудники.Сотрудник
	|ИЗ
	|	ВТ_Сотрудники КАК ВТ_Сотрудники";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивСотрудников.Добавить(Выборка.Сотрудник);
	КонецЦикла;
	
	Возврат МассивСотрудников;
	
КонецФункции

Процедура УстановитьСтатусыСотрудников(ТаблицаСотрудников, ПериодРегистрации)
	
	Для Каждого СтрокаТаблицы ИЗ ТаблицаСотрудников Цикл
		УстановитьСтатусСотрудника(СтрокаТаблицы, ПериодРегистрации);
	КонецЦикла;
	ТаблицаСотрудников.Сортировать("Работает Убыв, ПометкаУдаления Возр, Наименование Возр");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
