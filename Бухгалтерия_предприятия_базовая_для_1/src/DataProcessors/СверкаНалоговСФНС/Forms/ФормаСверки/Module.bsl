
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация;
	Иначе
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Год) Тогда
		Год = Параметры.Год;
	ИначеЕсли Параметры.ТолькоПроблемные Тогда
		Год = Обработки.СверкаНалоговСФНС.ГодПоследнейПроверкиНеПрошедшейСверку(Организация);
	Иначе
		Год = Год(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если Параметры.ТолькоПроблемные Тогда
		ОтборОплат = ЗначениеОтбораОплатыНеПрошедшиеСверку();
		УстановитьОтборСпискаПлатежей(ЭтотОбъект);
	Иначе
		ОтборОплат = ЗначениеОтбораВсеОплаты();
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьДанныеФормы", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		Если ЗначениеЗаполнено(Параметр) И ТипЗнч(Параметр) = Тип("СправочникСсылка.Организации") Тогда
			ОбновитьДанныеФормы();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ОтправленыЗапросыНаПроверкуОплатыНалогов" Тогда
		УстановитьВидимостьКомандыОтправкиСверки(Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПриАктивизации(ПараметрыФормы) Экспорт
	
	Организация = ПараметрыФормы.Организация;
	Год         = ПараметрыФормы.Год;
	ОтборОплат  = ?(ПараметрыФормы.ТолькоПроблемные, ЗначениеОтбораОплатыНеПрошедшиеСверку(), ЗначениеОтбораВсеОплаты());
	УстановитьОтборСпискаПлатежей(ЭтотОбъект);

	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьДанныеФормы", 0.1, Истина);
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СостоянияПлатежейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если Поле.Имя = "СостоянияПлатежейСостояниеГиперссылка" Тогда
		РасшифровкаСостоянияПлатежа(ТекущиеДанные);
	Иначе
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ГодПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОплатПриИзменении(Элемент)
	
	УстановитьОтборСпискаПлатежей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатьСписка(Команда)
	
	ПараметрыФормы = Новый Структура(
		"ПечатьСписка, ТолькоПроблемные, АдресХранилища",
		Истина,
		ОтборОплат = ЗначениеОтбораОплатыНеПрошедшиеСверку(),
		ПоместитьДанныеОплатВХранилище());
	
	ОткрытьФорму("Обработка.СверкаНалоговСФНС.Форма.ПечатьСверкиОплат", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьСверку(Команда)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите организацию'"),, "Организация");
		Возврат;
	КонецЕсли;
	
	СверкаСФНСКлиент.ОтправитьЗапросВыпискиОперацийФНС(Организация, Год);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеОтбораВсеОплаты()
	
	Возврат "Все";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеОтбораОплатыНеПрошедшиеСверку()
	
	Возврат "НеПрошедшиеСверку";
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбновитьДанныеФормы()
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеФормы()
	
	Элементы.ГруппаПодождите.Видимость   = Истина;
	Элементы.СостоянияПлатежей.Видимость = Ложь;
	
	ДлительнаяОперация = ПолучитьДанныеСверки(Организация, Год, УникальныйИдентификатор);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьДанныеФормыЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
		Возврат;
	ИначеЕсли НЕ Результат.Статус = "Выполнено" Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеФормыНаСервере(Результат.АдресРезультата);
	
	Элементы.ГруппаПодождите.Видимость   = Ложь;
	Элементы.СостоянияПлатежей.Видимость = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеСверки(Организация, Год, УникальныйИдентификатор)
	
	ПараметрыПроцедуры = Новый Структура; 
	ПараметрыПроцедуры.Вставить("Организация", Организация);
	ПараметрыПроцедуры.Вставить("Год",         Год);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания  = НСтр("ru = 'Сверка оплат налогов с данными ФНС'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.СверкаНалоговСФНС.ПолучитьДанныеСверкиВФоне", 
		ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
		
КонецФункции

&НаСервере
Процедура ОбновитьДанныеФормыНаСервере(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	ДанныеПоследнейСверки = Результат.ДанныеПоследнейСверки;
	ДатаПоследнейСверки      = ДанныеПоследнейСверки.Дата;
	ВидимостьКомандыОтправки = Не ДанныеПоследнейСверки.ЗапросОтправлен;
	УстановитьВидимостьКомандыОтправкиСверки(ВидимостьКомандыОтправки);
	СостоянияПлатежей.Загрузить(Результат.ОплатыСоСтатусами);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПроблемныеСостояния = Новый СписокЗначений;
	ПроблемныеСостояния.Добавить(Перечисления.СостоянияНалоговогоПлатежа.НеНайден);
	ПроблемныеСостояния.Добавить(Перечисления.СостоянияНалоговогоПлатежа.Расхождения);
	
	СостоянияГиперссылки = Новый СписокЗначений;
	СостоянияГиперссылки.Добавить(Перечисления.СостоянияНалоговогоПлатежа.НеНайден);
	СостоянияГиперссылки.Добавить(Перечисления.СостоянияНалоговогоПлатежа.Расхождения);
	СостоянияГиперссылки.Добавить(Перечисления.СостоянияНалоговогоПлатежа.ОжидаетсяЗачисление);
	
	// Цвет состояния зачисленного платежа.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СостоянияПлатежейСостояние");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СостоянияПлатежей.Состояние", ВидСравненияКомпоновкиДанных.Равно, Перечисления.СостоянияНалоговогоПлатежа.Зачислен);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОплатаНалогаЗачислена);
	
	// Видимость поля состояния зачисленного платежа.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СостоянияПлатежейСостояние");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СостоянияПлатежей.Состояние", ВидСравненияКомпоновкиДанных.ВСписке, СостоянияГиперссылки);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Цвет состояния проблемного платежа.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СостоянияПлатежейСостояниеГиперссылка");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СостоянияПлатежей.Состояние", ВидСравненияКомпоновкиДанных.ВСписке, ПроблемныеСостояния);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОплатаНалогаНеОбнаружена);
	
	// Видимость поля состояния проблемного платежа.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СостоянияПлатежейСостояниеГиперссылка");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СостоянияПлатежей.Состояние", ВидСравненияКомпоновкиДанных.НеВСписке, СостоянияГиперссылки);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСпискаПлатежей(Форма)
	
	Элементы = Форма.Элементы;
	Если Форма.ОтборОплат = ЗначениеОтбораОплатыНеПрошедшиеСверку() Тогда
		ОтборПоПроблемным = Новый ФиксированнаяСтруктура("ПроблемныйПлатеж", Истина);
		Элементы.СостоянияПлатежей.ОтборСтрок = ОтборПоПроблемным;
	Иначе
		Элементы.СостоянияПлатежей.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаСостоянияПлатежа(ТекущиеДанные)
	
	Если ТекущиеДанные.ПроблемныйПлатеж Тогда // платеж не найден или есть расхождения
		
		ДанныеОплаты = Новый Структура("Ссылка, Состояние, Период, КБК, ОКТМО, КБКПоДаннымФНС, ОКТМОПоДаннымФНС");
		ЗаполнитьЗначенияСвойств(ДанныеОплаты, ТекущиеДанные);
		ОткрытьФорму(
			"Обработка.СверкаНалоговСФНС.Форма.ПечатьСверкиОплат",
			Новый Структура("ПечатьСписка, ДанныеОплаты", Ложь, ДанныеОплаты));
			
	Иначе // ожидается зачисление
		
		ТекстПредупреждения = НСтр(
			"ru = 'С момента оплаты еще не прошло 10 рабочих дней, в данных ФНС
             |пока нет информации о платеже.'");
		ПоказатьПредупреждение(, ТекстПредупреждения,, НСтр("ru = 'Ожидается зачисление платежа'"));
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПоместитьДанныеОплатВХранилище()

	ДанныеОплат = РеквизитФормыВЗначение("СостоянияПлатежей");
	Возврат ПоместитьВоВременноеХранилище(ДанныеОплат);

КонецФункции

&НаСервере
Процедура УстановитьВидимостьКомандыОтправкиСверки(ВидимостьКомандыОтправки)
	
	Элементы.ГруппаЗапросСверки.Видимость           = ВидимостьКомандыОтправки;
	Элементы.ДекорацияОтправленЗапросВФНС.Видимость = Не ВидимостьКомандыОтправки;
	
КонецПроцедуры

#КонецОбласти
