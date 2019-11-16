
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияПоУмолчаниюИзОтбора();
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ЗаполнитьСпискиРеквизитовПлатежейВБюджет();
	
	ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Запись.Организация); // Используется в связях параметров выбора регистрации в НО
	ФизическоеЛицо      = НЕ ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Запись.Организация);
	
	НастроитьВидимостьКодаТерритории();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФорм

&НаКлиенте
Процедура ПоказательОснованияПриИзменении(Элемент)
	
	Если ПустаяСтрока(Запись.ПоказательОснования) Тогда
		Запись.ПоказательОснования = "0";
	КонецЕсли;
	
	Если Запись.ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.НалоговыйПлатеж") Тогда
		
		Если Запись.ПоказательОснования = "ТР" Тогда
			Запись.ПоказательПериода = "-";
		ИначеЕсли Запись.ПоказательОснования = "РС" Тогда
			Запись.ПоказательПериода = "-";
		ИначеЕсли Запись.ПоказательОснования = "ОТ" Тогда
			Запись.ПоказательПериода = "-";
		ИначеЕсли Запись.ПоказательОснования = "РТ" Тогда
			Запись.ПоказательПериода = "-";
		ИначеЕсли Запись.ПоказательОснования = "ВУ" Тогда
			Запись.ПоказательПериода = "-";
		ИначеЕсли Запись.ПоказательОснования = "ПР" Тогда
			Запись.ПоказательПериода = "-";
		ИначеЕсли Запись.ПоказательОснования = "АП" Тогда
			Запись.ПоказательПериода = "0";
		ИначеЕсли Запись.ПоказательОснования = "АР" Тогда
			Запись.ПоказательПериода = "0";
		Иначе
			Запись.ПоказательПериода = "МС";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательТипаПриИзменении(Элемент)
	
	Если ПустаяСтрока(Запись.ПоказательТипа) Тогда
		Запись.ПоказательТипа = "0";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПериодаПриИзменении(Элемент)
	
	Если ПустаяСтрока(Запись.ПоказательПериода) Тогда
		Запись.ПоказательПериода = "0";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПеречисленияВБюджетПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Запись.ВидПеречисленияВБюджет) Тогда
		Запись.ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.НалоговыйПлатеж");
	КонецЕсли;
	
	Контекст = ПлатежиВБюджетКлиентСервер.НовыйКонтекст();
	Контекст.Период         = ТекущаяДата();
	Контекст.ФизическоеЛицо = ФизическоеЛицо;
	
	УчетДенежныхСредствКлиентСервер.ЗаполнитьРеквизитыПлатежаВБюджетПоВидуПеречисления(Запись, Контекст);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусСоставителяПриИзменении(Элемент)
	
	Если ПустаяСтрока(Запись.СтатусСоставителя) Тогда
		Запись.СтатусСоставителя = "01";
	КонецЕсли;
	
	Если Запись.СтатусСоставителя = "08"
		ИЛИ Запись.ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ИнойПлатеж") Тогда
		Запись.ПоказательТипа      = "0";
		Запись.ПоказательОснования = "0";
		Запись.ПоказательПериода   = "0";
	Иначе
		Если Запись.ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.НалоговыйПлатеж") Тогда
			СписокОснований = Элементы.ПоказательОснования.СписокВыбора;
		Иначе
			СписокОснований = Элементы.ПоказательОснованияТаможня.СписокВыбора;
		КонецЕсли;
		
		Если ПустаяСтрока(Запись.ПоказательОснования) ИЛИ Запись.ПоказательОснования = "0" Тогда
			Запись.ПоказательОснования = СписокОснований[0].Значение;
			ПоказательОснованияПриИзменении("");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Запись.Организация);
	ФизическоеЛицо      = НЕ ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Запись.Организация);
	Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
		Запись.РегистрацияВНалоговомОргане = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	УстановитьСчетПолучателя(
		Запись.СчетПолучателя,
		Запись.Получатель,
		ВалютаРегламентированногоУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчередностьПлатежаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчередностьПлатежаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПлатежаПриИзменении(Элемент)
	
	НастроитьВидимостьКодаТерритории();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбора(Элемент, СписокДанных)
	
	Элемент.СписокВыбора.Очистить();
	Для каждого ЭлементДанных Из СписокДанных Цикл
		Элемент.СписокВыбора.Добавить(ЭлементДанных.Значение, ЭлементДанных.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиРеквизитовПлатежейВБюджет()
	
	ЗаполнитьСписокВыбора(
		Элементы.СтатусСоставителя,
		ПлатежиВБюджетКлиентСервер.СтатусыПлательщика());
	
	ЗаполнитьСписокВыбора(
		Элементы.ПоказательОснования,
		ПлатежиВБюджетКлиентСервер.ОснованияПлатежа(Перечисления.ВидыПеречисленийВБюджет.НалоговыйПлатеж));
	
	ЗаполнитьСписокВыбора(
		Элементы.ПоказательОснованияТаможня,
		ПлатежиВБюджетКлиентСервер.ОснованияПлатежа(Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж));
	
	РабочаяДатаСеанса = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ЗаполнитьСписокВыбора(
		Элементы.ПоказательТипа,
		ПлатежиВБюджетКлиентСервер.ТипыПлатежа(Перечисления.ВидыПеречисленийВБюджет.НалоговыйПлатеж, РабочаяДатаСеанса));
	
	ЗаполнитьСписокВыбора(
		Элементы.ПоказательТипаТаможня,
		ПлатежиВБюджетКлиентСервер.ТипыПлатежа(Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж, РабочаяДатаСеанса));
	
	ЗаполнитьСписокВыбора(
		Элементы.ПоказательПериода,
		ПлатежиВБюджетКлиентСервер.ВидыНалоговыхПериодов());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияПоУмолчаниюИзОтбора()
	
	Если НЕ ЗначениеЗаполнено(Запись.Организация) И Параметры.ЗначенияЗаполнения.Свойство("Организация")
		И ТипЗнч(Параметры.ЗначенияЗаполнения.Организация) = Тип("СписокЗначений") Тогда
		Для каждого ЗначениеЗаполнения Из Параметры.ЗначенияЗаполнения.Организация Цикл
			Если ЗначениеЗаполнено(ЗначениеЗаполнения.Значение) Тогда
				Запись.Организация = ЗначениеЗаполнения.Значение;
				Если НЕ ЗначениеЗаполнено(Запись.РегистрацияВНалоговомОргане) Тогда
					Запись.РегистрацияВНалоговомОргане = Запись.Организация.РегистрацияВНалоговомОргане;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьКодаТерритории()
	
	ПравилаЗаполнения = ПлатежиВБюджетНастройки.ПравилаЗаполненияРеквизитовПлатежа(Запись.ВидПлатежа);
	Элементы.КодТерритории.Видимость = ПравилаЗаполнения.СохранятьКодТерриторииПриЗаписи;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСчетПолучателя(СчетПолучателя, Знач Получатель, Знач ВалютаРеглУчета)
	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(
		СчетПолучателя,
		Получатель,
		ВалютаРеглУчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Запись   = Форма.Запись;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаНалоговыйПлатеж.Видимость  = Ложь;
	Элементы.ГруппаТаможенныйПлатеж.Видимость = Ложь;
	Элементы.ГруппаИнойПлатеж.Видимость       = Ложь;
	
	Если Запись.ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.НалоговыйПлатеж") Тогда
		Элементы.ГруппаНалоговыйПлатеж.Видимость = Истина;
	ИначеЕсли Запись.ВидПеречисленияВБюджет = ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ТаможенныйПлатеж") Тогда
		Элементы.ГруппаТаможенныйПлатеж.Видимость = Истина;
	Иначе
		Элементы.ГруппаИнойПлатеж.Видимость = Истина;
	КонецЕсли;
	
	Если Запись.ОчередностьПлатежа > 0 Тогда
		Если Запись.ОчередностьПлатежа > Элементы.ОчередностьПлатежа.СписокВыбора.Количество() Тогда
			// Если ОчередностьПлатежа = 6 будут выбирать после вступления в действие 345-Ф, не будем у такого значения отображать подсказку
			Форма.РасшифровкаОчередностиПлатежа = "";
		Иначе
			Форма.РасшифровкаОчередностиПлатежа = Сред(Элементы.ОчередностьПлатежа.СписокВыбора[
				Запись.ОчередностьПлатежа - 1].Представление, 5);
		КонецЕсли;
	Иначе
		Форма.РасшифровкаОчередностиПлатежа = "";
	КонецЕсли;
	
#Если Клиент Тогда
	ВидимостьПоказательТипа = ТекущаяДата() < ПлатежиВБюджетКлиентСервер.НачалоДействияПриказа126н();
#Иначе
	ВидимостьПоказательТипа = ТекущаяДатаСеанса() < ПлатежиВБюджетКлиентСервер.НачалоДействияПриказа126н();
#КонецЕсли
	
	Элементы.ПоказательТипа.Видимость          = ВидимостьПоказательТипа;
	
КонецПроцедуры

#КонецОбласти
