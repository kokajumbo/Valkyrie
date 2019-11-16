
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем УИДЗамера;

&НаСервере
Процедура ПриИзмененииДоговораКонтрагента(ИндексТекущейСтроки)

	ТекущаяСтрока = Объект.Список[ИндексТекущейСтроки];

	ДоговорКонтрагента = ТекущаяСтрока.ДоговорКонтрагента;
	Если ДоговорКонтрагента.РасчетыВУсловныхЕдиницах ИЛИ НЕ ЗначениеЗаполнено(ДоговорКонтрагента.ВалютаВзаиморасчетов) Тогда
		ТекущаяСтрока.ВалютаДокумента = ВалютаРегламентированногоУчета;
	Иначе
		Если НЕ ТекущаяСтрока.ВалютаДокумента = ДоговорКонтрагента.ВалютаВзаиморасчетов Тогда
			СуммаСтарая = 0;
		КонецЕсли;
		ТекущаяСтрока.ВалютаДокумента = ДоговорКонтрагента.ВалютаВзаиморасчетов;
	КонецЕсли;

	ПересчитатьНДСиВалютнуюСуммуПоСтроке(ТекущаяСтрока, Истина, СуммаСтарая, ВалютаРегламентированногоУчета);

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСуммы(ТекущаяСтрока)

	ПересчитатьНДСиВалютнуюСуммуПоСтроке(Объект.Список[ТекущаяСтрока], Истина, СуммаСтарая, ВалютаРегламентированногоУчета);

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСтавкиНДС(ТекущаяСтрока)

	ПересчитатьНДСиВалютнуюСуммуПоСтроке(Объект.Список[ТекущаяСтрока], Ложь, , ВалютаРегламентированногоУчета);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДополнительныеПоля(Форма)

	Список = Форма.Объект.Список;
	Для каждого ДанныеСтроки из Список Цикл
		КонецНалоговогоПериода = КонецКвартала(ДанныеСтроки.ДатаДокументаОснования);

		Если ДанныеСтроки.ПорядокРегистрацииСчетовФактурНаАванс = ПредопределенноеЗначение("Перечисление.ПорядокРегистрацииСчетовФактурНаАванс.НаВсеАвансы")
			И (ДанныеСтроки.Дата > КонецНалоговогоПериода
			Или ДанныеСтроки.Дата - ДанныеСтроки.ДатаДокументаОснования > 4 * 86400) Тогда
			ДанныеСтроки.ВыделятьСтроку = Истина;
		ИначеЕсли ДанныеСтроки.ПорядокРегистрацииСчетовФактурНаАванс = ПредопределенноеЗначение("Перечисление.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеПятиДней")
			И (КонецМесяца(ДанныеСтроки.Дата) > КонецМесяца(КонецНалоговогоПериода)
			Или ДанныеСтроки.Дата - ДанныеСтроки.ДатаДокументаОснования > 4 * 86400) Тогда
			ДанныеСтроки.ВыделятьСтроку = Истина;
		ИначеЕсли ДанныеСтроки.ПорядокРегистрацииСчетовФактурНаАванс = ПредопределенноеЗначение("Перечисление.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеМесяца")
			И КонецМесяца(ДанныеСтроки.Дата) > КонецМесяца(ДанныеСтроки.ДатаДокументаОснования) Тогда
			ДанныеСтроки.ВыделятьСтроку = Истина;
		ИначеЕсли ДанныеСтроки.ПорядокРегистрацииСчетовФактурНаАванс = ПредопределенноеЗначение("Перечисление.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеНалоговогоПериода")
			И КонецМесяца(ДанныеСтроки.Дата) > КонецМесяца(КонецНалоговогоПериода) Тогда
			ДанныеСтроки.ВыделятьСтроку = Истина;
		Иначе
			ДанныеСтроки.ВыделятьСтроку = Ложь;
		КонецЕсли;
		
		ДанныеСтроки.АвансПоКомиссии = ТипЗнч(ДанныеСтроки.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах");

	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			ПоказатьИнформациюОЗавершенииРегистрации();
			ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		КонецЕсли;
	Исключение
		УИДЗамера = Неопределено;
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИнформациюОЗавершенииРегистрации()
	
	Если ПараметрЗаполненияДокумента Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Регистрация счетов-фактур выполнена.'");
	ПоказатьПредупреждение(, ТекстСообщения);

КонецПроцедуры 

&НаСервере
Процедура ОпределитьНаличиеНеиспользуемыхСчетовФактурЗаПериод()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетФактураВыданный.Номер,
	|	СчетФактураВыданный.Дата,
	|	СчетФактураВыданный.Ссылка,
	|	СчетФактураВыданный.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.НаАванс)
	|	И СчетФактураВыданный.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И СчетФактураВыданный.Организация = &Организация
	|	И (НЕ СчетФактураВыданный.Ссылка В (&СФдляОбновления))
	|	И (НЕ СчетФактураВыданный.СформированПриВводеНачальныхОстатковНДС)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетФактураВыданный.Дата,
	|	СчетФактураВыданный.Номер";

	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Объект.КонецПериода));
	Запрос.УстановитьПараметр("СФдляОбновления",
		ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(Объект.Список.Выгрузить().ВыгрузитьКолонку("СчетФактура"),
			Истина));

	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Колонки.Добавить("Использован", Новый ОписаниеТипов("Булево"));

	НеиспользуемыеСчетаФактуры.Загрузить(Результат);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеУчетнойПолитики(Организация, Период)

	Выборка = РегистрыСведений.НастройкиУчетаНДС.Выбрать(, Период,
		Новый Структура("Организация", Организация), "Убыв");
	Если Выборка.Следующий() Тогда
		Отбор = Новый Структура("Период, Организация", Выборка.Период, Выборка.Организация);
		Возврат РегистрыСведений.НастройкиУчетаНДС.СоздатьКлючЗаписи(Отбор)
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьНДСиВалютнуюСуммуПоСтроке(ТД, ПересчетВалютнойСуммы = Ложь, СуммаСтарая = 0,
	ВалютаРегламентированногоУчета) Экспорт

	ТД.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(ТД.Сумма, Истина, УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ТД.СтавкаНДС));

	Если ПересчетВалютнойСуммы = Истина тогда
		Если ТД.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
			ТД.ВалютнаяСумма = ТД.Сумма;
		Иначе
			ТД.ВалютнаяСумма = ?(НЕ ЗначениеЗаполнено(СуммаСтарая), 0, ТД.ВалютнаяСумма * ТД.Сумма / СуммаСтарая);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСчетФактурыНаАванс()
	
	ПараметрЗаполненияДокумента = Истина;
	ИнициализацияКомандДокументаНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализацияКомандДокументаНаКлиенте(ПараметрыОбработки = Неопределено)

	ОчиститьСообщения();

	// СтандартныеПодсистемы.ОценкаПроизводительности
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "СозданиеСчетФактурыНаАвансЗаполнение");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	Если ПараметрЗаполненияДокумента Тогда
		Результат = ЗаполнитьСчетаФактурыНаСервере(ИБФайловая);
	Иначе
		Результат = СоздатьСчетаФактурыНаСервере(ПараметрыОбработки, ИБФайловая);
	КонецЕсли;

	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
	Иначе
		ПоказатьИнформациюОЗавершенииРегистрации();
		ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	КонецЕсли;
	
	Если Не ПараметрЗаполненияДокумента Тогда
		Оповестить("СостояниеРегламентнойОперации", 
			?(Результат.ЗаданиеВыполнено, ПредопределенноеЗначение("Перечисление.ВидыСостоянийРегламентныхОпераций.Выполнено"), 
				ПредопределенноеЗначение("Перечисление.ВидыСостоянийРегламентныхОпераций.НеВыполнено")));		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСчетаФактурыНаСервере(ИБФайловая)

	Объект.Список.Очистить();

	СтруктураПараметров = Обработки.РегистрацияСчетовФактурНаАванс.ПараметрыЗаполнения();
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Объект);

	Если ИБФайловая Тогда
		ЭтаФорма.АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
		Обработки.РегистрацияСчетовФактурНаАванс.ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);

	Иначе
		НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение таблицы ""Регистрация счетов-фактур на аванс""'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.РегистрацияСчетовФактурНаАванс.ПодготовитьДанныеДляЗаполнения",
			СтруктураПараметров,
			НаименованиеФоновогоЗадания);

		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;

	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если СтруктураДанных.Свойство("Список") Тогда
		Объект.Список.Загрузить(СтруктураДанных.Список);
	КонецЕсли;
	ЗаполнитьДополнительныеПоля(ЭтаФорма);
	ОпределитьМоментАктуальностиОтложенныхРасчетов(Ложь);
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Функция ПровестиПроверкиПередВыполнениемСервер()

	РезультатыПроверки = Новый Структура("НетНеиспользуемыхСчетовФактур", Истина);

	ОпределитьНаличиеНеиспользуемыхСчетовФактурЗаПериод();

	РезультатыПроверки.Вставить("НетНеиспользуемыхСчетовФактур", НеиспользуемыеСчетаФактуры.Количество() = 0);

	Возврат РезультатыПроверки;

КонецФункции

&НаСервере
Функция СоздатьСчетаФактурыНаСервере(ПараметрыОбработки, ИБФайловая)

	СтруктураПараметров = Новый Структура("Организация, НачалоПериода, КонецПериода, ЗаТекущийПериод, НеПередаютсяКонтрагентам",
		Объект.Организация, Объект.НачалоПериода, Объект.КонецПериода, Ложь, Ложь);

	Если ПараметрыОбработки.Свойство("ОчиститьСписокНеиспользуемыхСчетовФактур")
		И ПараметрыОбработки.ОчиститьСписокНеиспользуемыхСчетовФактур Тогда
		НеиспользуемыеСчетаФактуры.Очистить();
	КонецЕсли;

	Если ПараметрыОбработки.Свойство("УстановитьПометкиУдаления") Тогда
		СтруктураПараметров.Вставить("УстановитьПометкиУдаления", ПараметрыОбработки.УстановитьПометкиУдаления);
	КонецЕсли;

	СтруктураПараметров.Вставить("ТаблицыСчетовФактур", Новый Структура("Список, НеиспользуемыеСчетаФактуры",
		Объект.Список.Выгрузить(), НеиспользуемыеСчетаФактуры.Выгрузить()));

	Если ИБФайловая Тогда
		ЭтаФорма.АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
		Обработки.РегистрацияСчетовФактурНаАванс.СформироватьСчетаФактуры(СтруктураПараметров, ЭтаФорма.АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеФоновогоЗадания = НСтр("ru = 'Формирование счетов-фактур в ""Регистрация счетов-фактур на аванс""'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.РегистрацияСчетовФактурНаАванс.СформироватьСчетаФактуры",
			СтруктураПараметров,
			НаименованиеФоновогоЗадания);
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;

	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьУППорядокРегистрацииСчетовФактурНаАванс(Организация, Дата)
	
	Если НЕ ЗначениеЗаполнено(Организация) ИЛИ НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат "";
	КонецЕсли; 
	
	ПорядокРегистрацииПоУчетнойПолитике = УчетнаяПолитика.ПорядокРегистрацииСчетовФактурНаАванс(Организация, Дата);
	
	Если ПорядокРегистрацииПоУчетнойПолитике = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.НаВсеАвансы Тогда
		Возврат НСтр("ru = 'регистрируются всегда при получении аванса'")
	ИначеЕсли ПорядокРегистрацииПоУчетнойПолитике = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеПятиДней Тогда
		Возврат НСтр("ru = 'регистрируются, если аванс не зачтен в течение 5-ти календарных дней'")
	ИначеЕсли ПорядокРегистрацииПоУчетнойПолитике = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеМесяца Тогда
		Возврат НСтр("ru = 'регистрируются, если аванс не зачтен в течение месяца'")
	ИначеЕсли ПорядокРегистрацииПоУчетнойПолитике = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеНалоговогоПериода Тогда
		Возврат НСтр("ru = 'регистрируются, если аванс не зачтен в течение налогового периода'")
	ИначеЕсли ПорядокРегистрацииПоУчетнойПолитике = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.НеРегистрироватьСчетаФактурыНаАвансы Тогда
		Возврат НСтр("ru = 'не регистрируются'");
	КонецЕсли;

КонецФункции

&НаСервереБезКонтекста
Функция ОпределитьПорядокНумерацииСчетовФактурНаАванс()
	
	Возврат ?(Константы.ОтдельнаяНумерацияСчетовФактурНаАванс.Получить(), 
		НСтр("ru = 'отдельная, с префиксом ""А""'"),
		НСтр("ru = 'единая'"));
	
КонецФункции	

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыИзПараметровФормы(Форма)
	
	ПараметрыЗаполненияФормы = Неопределено;
	
	Объект = Форма.Объект;
	
	Если Форма.Параметры.Свойство("ПараметрыЗаполненияФормы",ПараметрыЗаполненияФормы) Тогда
	
		ЗаполнитьЗначенияСвойств(Объект,ПараметрыЗаполненияФормы);			
	
	Иначе
		
		Объект.НачалоПериода = ОбщегоНазначения.ТекущаяДатаПользователя();
		Объект.КонецПериода  = ОбщегоНазначения.ТекущаяДатаПользователя();

	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыДокументаОснования(ДокументОснование, ВалютаРегламентированногоУчета)
	
	РеквизитыДокументаОснования = Новый Структура("Дата, ВалютаДокумента");
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		Если ТипЗнч(ДокументОснование)= Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
			РеквизитыДокументаОснования.Дата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Дата");
			РеквизитыДокументаОснования.ВалютаДокумента = ВалютаРегламентированногоУчета;
		Иначе
			ЗаполнитьЗначенияСвойств(РеквизитыДокументаОснования, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Дата, ВалютаДокумента"));
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(РеквизитыДокументаОснования.ВалютаДокумента) Тогда
		РеквизитыДокументаОснования.ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Возврат РеквизитыДокументаОснования;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СписокСчетовФактур(Команда)

	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("Организация",                 Объект.Организация);
	ПараметрыОтбор.Вставить("ТолькоАвансовыеСчетаФактуры", Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыОтбораСписка", ПараметрыОтбор);
	
	Если Объект.НачалоПериода <> '00010101' ИЛИ Объект.КонецПериода <> '00010101' Тогда
		Если Объект.НачалоПериода = '00010101' Тогда
			ПараметрыФормы.Вставить("ДатаМеньшеИлиРавно", КонецДня(Объект.КонецПериода));
		ИначеЕсли Объект.КонецПериода = '00010101' Тогда
			ПараметрыФормы.Вставить("ДатаБольшеИлиРавно", Объект.НачалоПериода);
		Иначе
			// ИнтервалВключаяГраницы с НачалоПериода по КонецПериода
			ПараметрыФормы.Вставить("ДатаБольшеИлиРавно", Объект.НачалоПериода);
			ПараметрыФормы.Вставить("ДатаМеньшеИлиРавно", КонецДня(Объект.КонецПериода));
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Документ.СчетФактураВыданный.ФормаСписка", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	Если Объект.Список.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросОчищениеТабличнойЧастиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, "Регистрация счетов-фактур на аванс");
	Иначе
		ЗаполнитьСчетФактурыНаАванс();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнить(Команда)

	Если НЕ ПроверитьЗаполнение() ИЛИ НЕ Объект.Список.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;

	РезультатыПроверки = ПровестиПроверкиПередВыполнениемСервер();

	ПараметрыОбработки =
	Новый Структура("УстановитьПометкиУдаления,ОчиститьСписокНеиспользуемыхСчетовФактур,
	|Организация, НачалоПериода", Ложь, Ложь, Объект.Организация, Объект.НачалоПериода);
	
	Если НЕ РезультатыПроверки.НетНеиспользуемыхСчетовФактур Тогда
		ТекстВопроса = НСтр("ru='По организации обнаружены счета-фактуры на аванс за обрабатываемый период,
			|которые не используются в списке счетов-фактур к регистрации (значение поля ""Счет-фактура"" по строке).
			|Номера найденных документов могут быть использованы для тех строк, у которых не установлен соответствующий
			|строке счет-фактура.
			|Использовать номера ранее зарегистрированных счетов-фактур?
			|
			|Да - Использовать номера обнаруженных счетов-фактур, неиспользованные пометить на удаление
			|Нет - Оставить обнаруженные счета-фактуры без изменений, продолжить процедуру регистрации
			|Отмена - Отменить формирование счетов-фактур на аванс'");
		Оповещение = Новый ОписаниеОповещения("ВопросИспользоватьРанееЗарегистрированныеСчетаФактуры", ЭтотОбъект, ПараметрыОбработки);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	Иначе
		ПараметрЗаполненияДокумента = Ложь;
		ИнициализацияКомандДокументаНаКлиенте(ПараметрыОбработки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Объект.НачалоПериода, Объект.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ПриИзмененииОрганизацииИПериода();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	Если Объект.НачалоПериода > Объект.КонецПериода Тогда
		
		Объект.КонецПериода = Объект.НачалоПериода;
		
		ПриИзмененииОрганизацииИПериода();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	Если Объект.КонецПериода < Объект.НачалоПериода Тогда
		Объект.НачалоПериода = Объект.КонецПериода;
	КонецЕсли;
	
	ПриИзмененииОрганизацииИПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Объект.Список.Очистить();
	
	ПриИзмененииОрганизацииИПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокНумерацииСчетовФактурНаАвансНажатие(Элемент, СтандартнаяОбработка)
	
	// Переход к параметрам учета
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("ПараметрыОткрытия",
		Новый Структура("АктивныйЭлемент", "ПорядокНумерацииСчетовФактур"));
		
	ОткрытьФорму("ОбщаяФорма.НДС", ПараметрыОткрытия, ЭтаФорма, "");

	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПорядокРегистрацииСчетовФактурНаАвансНажатие(Элемент, СтандартнаяОбработка)
	
	// Переход к учетной политике
	
	СтандартнаяОбработка = Ложь;

	Если ЗначениеЗаполнено(Объект.Организация)
		И ЗначениеЗаполнено(Объект.КонецПериода) Тогда
		КлючЗаписи = ПолучитьДанныеУчетнойПолитики(Объект.Организация, Объект.КонецПериода);
		Если КлючЗаписи <> Неопределено Тогда
			ПараметрыОткрытия = Новый Структура("Ключ, ПараметрыОткрытия",
				КлючЗаписи,
				Новый Структура("АктивныйЭлемент", "ПорядокРегистрацииСчетовФактурНаАванс"));
			ОткрытьФорму("РегистрСведений.НастройкиУчетаНДС.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма, "");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ "СПИСОК"

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		СуммаСтарая = Объект.Список[Элементы.Список.ТекущиеДанные.НомерСтроки - 1].Сумма;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокДоговорКонтрагентаПриИзменении(Элемент)

	ПриИзмененииДоговораКонтрагента(Элементы.Список.ТекущиеДанные.НомерСтроки - 1);

КонецПроцедуры

&НаКлиенте
Процедура СписокСуммаПриИзменении(Элемент)

	ПриИзмененииСуммы(Элементы.Список.ТекущиеДанные.НомерСтроки - 1);

КонецПроцедуры

&НаКлиенте
Процедура СписокСтавкаНДСПриИзменении(Элемент)

	ПриИзмененииСтавкиНДС(Элементы.Список.ТекущиеДанные.НомерСтроки - 1);

КонецПроцедуры

&НаКлиенте
// Выполняется при изменении документа-основания
// Производит определение валюты документа, возможно изменение валютной суммы
Процедура СписокДокументОснованиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	РеквизитыДокументаОснования = ПолучитьРеквизитыДокументаОснования(ТекущиеДанные.ДокументОснование, ВалютаРегламентированногоУчета);
	
	Если НЕ РеквизитыДокументаОснования.ВалютаДокумента = ТекущиеДанные.ВалютаДокумента Тогда
		Если РеквизитыДокументаОснования.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
			ТекущиеДанные.ВалютнаяСумма = ТекущиеДанные.Сумма;
		Иначе
			ТекущиеДанные.ВалютнаяСумма = 0;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, РеквизитыДокументаОснования);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ТД = Элементы.Список.ТекущиеДанные;

	СтандартнаяОбработка = Ложь;
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Организация",   	Объект.Организация);
	ПараметрыОбъекта.Вставить("Контрагент",    	ТД.Контрагент);
	ПараметрыОбъекта.Вставить("НачалоПериода", 	Объект.НачалоПериода);
	ПараметрыОбъекта.Вставить("КонецПериода",  	КонецДня(Объект.Конецпериода));
	ПараметрыОбъекта.Вставить("ТипыДокументов",	ТипыДокументов);
    ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыОбъекта", ПараметрыОбъекта);

	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент, Истина);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Структура_ТипыДокументовАванса = Обработки.РегистрацияСчетовФактурНаАванс.ТипыДокументовАванса();
	
	МассивТиповДокумента = Новый Массив;
	Для Каждого ТипДокумента Из Структура_ТипыДокументовАванса Цикл
		МассивТиповДокумента.Добавить(ТипДокумента.Значение);
	КонецЦикла;
	
	ТипыДокументов = Новый ОписаниеТипов(МассивТиповДокумента);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	СуммаСтарая = 0;
	
	Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);

	ПорядокРегистрацииСчетовФактурНаАванс = ПолучитьУППорядокРегистрацииСчетовФактурНаАванс(Объект.Организация,
		Объект.КонецПериода);
		
	ПорядокНумерацииСчетовФактурНаАванс = ОпределитьПорядокНумерацииСчетовФактурНаАванс();
	
	ИспользуетсяОтложенноеПроведение = ПолучитьФункциональнуюОпцию("ИспользоватьОтложенноеПроведение");
	
	ОпределитьМоментАктуальностиОтложенныхРасчетов(Ложь);
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда
		ОжидатьВыполнениеОтложенныхРасчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеУчетнойПолитики" Тогда
		
		Если Параметр = Объект.Организация
		 Или Параметр = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Объект.Организация) Тогда
			ПорядокРегистрацииСчетовФактурНаАванс = ПолучитьУППорядокРегистрацииСчетовФактурНаАванс(Объект.Организация,
				Объект.КонецПериода);
			УправлениеФормой(ЭтаФорма);	
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзменениеНастроекПараметровУчета" Тогда
		
		ПорядокНумерацииСчетовФактурНаАванс = ОпределитьПорядокНумерацииСчетовФактурНаАванс();
		
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого СтрокаТаблицы Из Объект.Список Цикл
		
		Префикс = "Список[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Список'");
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДоговорКонтрагента)
			И ТипЗнч(СтрокаТаблицы.ДокументОснование) <> Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение",
				НСтр("ru = 'Договор'"), СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстСообщения);
			Поле = Префикс + "ДоговорКонтрагента";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "Объект", Отказ);
			
		КонецЕсли;
			
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Если (НЕ УчетнаяПолитика.Существует(Объект.Организация, Объект.НачалоПериода, Истина)) Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ПолеПорядокРегистрацииСчетовФактурНаАванс.Видимость = ЗначениеЗаполнено(Форма.ПорядокРегистрацииСчетовФактурНаАванс);
	Элементы.Выполнить.Доступность = Форма.Объект.Список.Количество() <> 0;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Процедура ПриИзмененииОрганизацииИПериода()

	ПорядокРегистрацииСчетовФактурНаАванс = ПолучитьУППорядокРегистрацииСчетовФактурНаАванс(Объект.Организация,
		Объект.КонецПериода);
		
	ОпределитьМоментАктуальностиОтложенныхРасчетов(Ложь);
		
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// Выделение ошибочных данных.

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокНомерСтроки");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокСФсформирован");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокКонтрагент");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокДоговорКонтрагента");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокСумма");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокСтавкаНДС");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокСуммаНДС");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокДокументОснование");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокСчетНаОплату");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокДата");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокВалютаДокумента");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокВалютнаяСумма");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокСчетФактура");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Список.ВыделятьСтроку", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);


	// СписокДоговорКонтрагента

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокДоговорКонтрагента");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Список.ДоговорКонтрагента", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Список.Контрагент", ВидСравненияКомпоновкиДанных.Заполнено);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Список.ДокументОснование", ВидСравненияКомпоновкиДанных.Заполнено);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Список.АвансПоКомиссии", ВидСравненияКомпоновкиДанных.Равно, Истина);
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Комиссия>'"));

КонецПроцедуры

&НаКлиенте
Процедура ВопросОчищениеТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьСчетФактурыНаАванс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИспользоватьРанееЗарегистрированныеСчетаФактуры(Результат, ПараметрыОбработки) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		// Отменено пользователем
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		// Помечаем документы на удаление. Использование документов
		// будет выполняться далее, непосредственно в процессе регистрации счетов-фактур
		ПараметрыОбработки.Вставить("УстановитьПометкиУдаления", Истина);
	Иначе
		ПараметрыОбработки.Вставить("ОчиститьСписокНеиспользуемыхСчетовФактур", Истина);
	КонецЕсли;
	
	ПараметрЗаполненияДокумента = Ложь;
	ИнициализацияКомандДокументаНаКлиенте(ПараметрыОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПриНеобходимостиАктуализацииНажатие(Элемент)

	// Пользователь хочет скрыть данные по актуализации, сбрасываем соответствующие признаки.
	МоментАктуальностиОтложенныхРасчетов = Неопределено;
	УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНажатие(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания)

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты)
		И НЕ ЗаданиеВыполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда
		// Задание запущено и еще не завершилось, продолжаем ожидание.
		Возврат;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов");
	
	ЗаданиеВыполнено = ЗапуститьОтложенныеРасчетыНаСервере();
	Если ЗаданиеВыполнено Тогда
		ПоказатьРезультатОтложенногоРасчета();
	Иначе
		ОжидатьВыполнениеОтложенныхРасчетов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов");
		ОтменитьВыполнениеЗадания(ИдентификаторЗаданияОтложенныеРасчеты);
		ИдентификаторЗаданияОтложенныеРасчеты = Неопределено;
	КонецЕсли;
	
	ОпределитьМоментАктуальностиОтложенныхРасчетов(Истина);

КонецПроцедуры

#Область ОтложенныеРасчеты

&НаСервере
Функция ДатаОкончанияАктуализации()

	Возврат ?(ЗначениеЗаполнено(Объект.КонецПериода), Объект.КонецПериода, ТекущаяДатаСеанса());

КонецФункции

&НаСервере
Процедура ОпределитьМоментАктуальностиОтложенныхРасчетов(БылаПопыткаАктуализации)
	
	УчетВзаиморасчетовОтложенноеПроведение.ОпределитьМоментАктуальностиОтложенныхРасчетов(
		ЭтотОбъект,
		Объект.Организация,
		ДатаОкончанияАктуализации(),
		БылаПопыткаАктуализации);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты(БылаПопыткаАктуализации)

	УчетВзаиморасчетовОтложенноеПроведение.УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты(
		ЭтотОбъект,
		ДатаОкончанияАктуализации(),
		БылаПопыткаАктуализации);

КонецПроцедуры

&НаСервере
Функция ЗапуститьОтложенныеРасчетыНаСервере()

	ЗаданиеВыполнено = УчетВзаиморасчетовОтложенноеПроведение.ЗапуститьОтложенныеРасчетыИзФормы(
		ЭтотОбъект,
		Объект.Организация,
		ДатаОкончанияАктуализации());
	
	Возврат ЗаданиеВыполнено;

КонецФункции

&НаКлиенте
Процедура ОжидатьВыполнениеОтложенныхРасчетов()

	ПрогрессорАктуализации = "0%.";
	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов", 1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов()

	Попытка
		Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты)
			И ЗаданиеВыполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда 

			ЗагрузитьДанныеПослеОтложенногоРасчета();
			ПоказатьРезультатОтложенногоРасчета();
		
		Иначе
			
			ЗакрытиеМесяцаКлиент.ОбновитьПроцентПрогресса(ЭтотОбъект, ИдентификаторЗаданияОтложенныеРасчеты);
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
				
		КонецЕсли;
	Исключение
		ИдентификаторЗаданияОтложенныеРасчеты = Неопределено;
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРезультатОтложенногоРасчета()

	Если ЭтоАдресВременногоХранилища(АдресХранилищаСОшибками) Тогда
		ОбщегоНазначенияБПКлиент.ОткрытьФормуОшибокПерепроведения(ЭтотОбъект, АдресХранилищаСОшибками);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеПослеОтложенногоРасчета() Экспорт
	
	УчетВзаиморасчетовОтложенноеПроведение.ЗагрузитьДанныеПослеОтложенногоРасчета(
		ЭтотОбъект,
		Объект.Организация,
		ДатаОкончанияАктуализации());
	
КонецПроцедуры

#КонецОбласти
