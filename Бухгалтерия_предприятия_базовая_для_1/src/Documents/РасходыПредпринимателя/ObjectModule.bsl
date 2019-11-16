#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Расходы");
	ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата) Тогда
		НДСВключенВСтоимость = Ложь;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	СуммаВключаетНДС = Истина;

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.РасходыПредпринимателя.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Документы.РасходыПредпринимателя.ДобавитьКолонкуСодержаниеТовары(ПараметрыПроведения.ПоступлениеТоваровТаблица);
	Документы.РасходыПредпринимателя.ДобавитьКолонкуСодержаниеУслуги(ПараметрыПроведения.ПоступлениеУслугТаблица);
	Документы.РасходыПредпринимателя.ДобавитьКолонкуСодержаниеТовары(ПараметрыПроведения.ТоварыНДС);
	Документы.РасходыПредпринимателя.ДобавитьКолонкуСодержаниеУслуги(ПараметрыПроведения.УслугиНДС);
	
	// Учет доходов и расходов ИП
	ТаблицаТоваровИП          = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуПоступленияМПЗ(
		ПараметрыПроведения.ПоступлениеМПЗИПТаблицаТоваров,
		ПараметрыПроведения.Реквизиты);
	
	ТаблицаУслугиИП           = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуПоступленияМПЗ(
		ПараметрыПроведения.ПоступлениеМПЗИПТаблицаУслуги,
		ПараметрыПроведения.Реквизиты);
	
	СтруктураТаблицМПЗ        = Новый Структура("ТаблицаТоваров, ТаблицаПрочее",
		ТаблицаТоваровИП, ТаблицаУслугиИП);
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УчетТоваров.СформироватьДвиженияПоступлениеТоваров(
		ПараметрыПроведения.ПоступлениеТоваровТаблица, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияПоступлениеУслуг(
		ПараметрыПроведения.ПоступлениеУслугТаблица, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// УСН
	СуммаСторноРасхода = 0;
	УчетУСН.ПоступлениеРасходовУСН(ПараметрыПроведения.ПоступлениеРасходовУСНТаблицаРасходов,
		ПараметрыПроведения.ПоступлениеРасходовУСНРеквизиты, СуммаСторноРасхода, Движения, Отказ);

	Если НЕ Отказ И Движения.РасходыПриУСН.Количество()>0 Тогда
		Движения.РасходыПриУСН.Записать(Истина);
		Движения.РасходыПриУСН.Записывать = Ложь;
	КонецЕсли;
		
	Документы.РасходыПредпринимателя.СформироватьДвиженияЗаписьКУДиР(ПараметрыПроведения, Движения, Отказ);
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияПоступлениеМПЗ(СтруктураТаблицМПЗ,
		ПараметрыПроведения.ПоступлениеМПЗИПТаблицаВзаиморасчетов,, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	// НДС
	УчетНДС.СформироватьДвиженияПоступлениеТоваровУслугОтПодотчетногоЛица(
		ПараметрыПроведения.ТоварыНДС, ПараметрыПроведения.УслугиНДС, Неопределено,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетНДСРаздельный.СформироватьДвиженияПоступлениеТоваровУслугОтПодотчетногоЛица(
		ПараметрыПроведения.ТоварыНДС, ПараметрыПроведения.УслугиНДС,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Регистрация в последовательности
	Документы.РасходыПредпринимателя.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, ПараметрыПроведения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	МассивНоменклатуры = ОбщегоНазначения.ВыгрузитьКолонку(Расходы, "Номенклатура", Истина);
	ЗначенияРеквизитаУслуга = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивНоменклатуры, "Услуга");
	
	ТолькоУслуги = Истина;
	
	МассивНепроверяемыхРеквизитов.Добавить("Расходы.Количество");
	Для каждого СтрокаТаблицы Из Расходы Цикл
		Префикс = "Расходы[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Расходы'");
		
		ЭтоУслуга = ?(ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура), ЗначенияРеквизитаУслуга[СтрокаТаблицы.Номенклатура], Ложь);
		
		Если ТолькоУслуги Тогда
			ТолькоУслуги = ЭтоУслуга;
		КонецЕсли;
		
		Если НЕ ЭтоУслуга И НЕ ЗначениеЗаполнено(СтрокаТаблицы.Количество) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Количество'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "Количество";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если ТолькоУслуги Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти

#КонецЕсли