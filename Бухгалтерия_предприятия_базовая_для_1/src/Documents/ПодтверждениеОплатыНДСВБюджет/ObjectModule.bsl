#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект, Ложь);
	// Далее вызов ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей() не требуется,
	// т.к. был передан параметр ВыборочноОчищатьРегистры = Ложь, и все действия уже выполнены.
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПодтверждениеОплатыНДСВБюджет.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИБ

	ТаблицаСнятиеБлокировкиВычета = УчетНДС.ПодготовитьТаблицуСнятиеБлокировкиВычетаПриВвозеТоваров(
		ПараметрыПроведения.ТаблицаОплатаПодтверждена,
		ПараметрыПроведения.ТаблицаРеквизиты);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	УчетНДС.СформироватьДвиженияПодтвержденаОплатаНДСПоВвезеннымТоварам(
		ПараметрыПроведения.ТаблицаРеквизиты,
		ТаблицаСнятиеБлокировкиВычета,
		Движения, Отказ);
		
	УчетНДС.СформироватьДвиженияЖурналУчетаСчетовФактурРегистрация(
		ПараметрыПроведения.ТаблицаРегистрацияЗаявленияНалоговымОрганом,
		Движения, Отказ);
		
	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СформироватьДвиженияФактВыполненияРегламентнойОперации(
		ПараметрыПроведения.ДанныеРегламентнойОперации, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СброситьФактВыполненияОперации(Ссылка);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьСтрокиДокумента(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если УчетНДСПереопределяемый.ВерсияПостановленияНДС1137(Дата) < 3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Состав.НомерДокументаОплаты");
	КонецЕсли;
	
	Если Дата < '20160101' Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Состав.НомерОтметкиОРегистрации");
		МассивНепроверяемыхРеквизитов.Добавить("Состав.ДатаОтметкиОРегистрации");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияОДублях = ИнформацияОДубляхПодтвержденияОплатыЗаявленияОВвозе();
	
	Если ИнформацияОДублях.ЕстьДубли Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИнформацияОДублях.СообщениеПользователю, ЭтотОбъект, , , Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтрокиДокумента(Основание)

	СтруктураПараметров = Новый Структура("Дата,Организация,Основание", Дата, Организация, Основание);
	
	ДанныеДляЗаполнения = Документы.ПодтверждениеОплатыНДСВБюджет.ПодготовитьДанныеДляЗаполнения(СтруктураПараметров);
	
	Состав.Загрузить(ДанныеДляЗаполнения);

КонецПроцедуры

Функция ИнформацияОДубляхПодтвержденияОплатыЗаявленияОВвозе()
	
	Результат = Новый Структура("ЕстьДубли, СообщениеПользователю");
	
	ЕстьДубли = Ложь;
	СообщенияПользователю = Новый Массив;
	ПодтвержденияОплатыПоЗаявленияОВвозе = НайтиПодтвержденияОплатыПоЗаявленияОВвозе();
	
	Если ПодтвержденияОплатыПоЗаявленияОВвозе.ЕстьДубли Тогда
		ЕстьДубли = Истина;
		Для Каждого СтрокаТЗ Из ПодтвержденияОплатыПоЗаявленияОВвозе.ТаблицаДублей Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='На основании документа %1 уже введен документ %2'"),
				СтрокаТЗ.СчетФактура,
				СтрокаТЗ.Регистратор);
			СообщенияПользователю.Добавить(ТекстСообщения);
		КонецЦикла;
	КонецЕсли;
	
	СообщениеПользователю = СтрСоединить(СообщенияПользователю, ". ");
	
	Результат.ЕстьДубли             = ЕстьДубли;
	Результат.СообщениеПользователю = СообщениеПользователю;
	
	Возврат Результат;
	
КонецФункции

Функция НайтиПодтвержденияОплатыПоЗаявленияОВвозе()
	
	ЗаявленияОВвозеПоДокументу = Состав.ВыгрузитьКолонку("ЗаявлениеОВвозе");
	
	УникальныеЗаявленияОВвозеПоДокументу = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(УникальныеЗаявленияОВвозеПоДокументу, ЗаявленияОВвозеПоДокументу, Истина);
	ЗаявленияОВвозеПоДокументу = УникальныеЗаявленияОВвозеПоДокументу;
	
	Результат = Новый Структура("ЕстьДубли,ТаблицаДублей", Ложь);
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЖурналУчетаСчетовФактур.Регистратор,
	|	ЖурналУчетаСчетовФактур.СчетФактура
	|ИЗ
	|	РегистрСведений.ЖурналУчетаСчетовФактур КАК ЖурналУчетаСчетовФактур
	|ГДЕ
	|	ЖурналУчетаСчетовФактур.СчетФактура В(&ЗаявленияОВвозеПоДокументу)
	|	И ЖурналУчетаСчетовФактур.Регистратор <> &Ссылка";
	
	Запрос.УстановитьПараметр("ЗаявленияОВвозеПоДокументу", ЗаявленияОВвозеПоДокументу);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Результат.ЕстьДубли = Истина;
		Результат.ТаблицаДублей = РезультатЗапроса.Выгрузить();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


#КонецЕсли

