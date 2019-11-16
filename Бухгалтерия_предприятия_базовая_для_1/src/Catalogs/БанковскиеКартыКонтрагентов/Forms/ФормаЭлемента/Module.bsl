#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветТекстаОшибочногоНомера = ЦветаСтиля.ПоясняющийОшибкуТекст;
	ЦветТекстаПравильногоНомера= ЦветаСтиля.ЦветТекстаПоля;
	
	ИнициализироватьПоляСрокаДействия();
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	// Уточняем доступность полей после запрета редактирования:
	// может потребоваться отключить что-то ещё.
	УстановитьДоступностьПолейПоПравам();
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриПолученииДанныхНаСервере(РеквизитФормыВЗначение("Объект"));
		Объект.ИмяДержателяКарты = БанковскиеКартыСлужебныйКлиентСервер.ИмяДержателяКартыПоУмолчанию(Объект.Владелец);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьОшибкиНомера();	
	
	// При создании новой карты уместно сразу включать показ полного номера для ввода.
	ПоказатьПолныйНомерКарты(Объект.Ссылка.Пустая());
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.УстановитьОсновнойНомерДержателяКарты(ОсновнойНомерДержателяКарты);
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		ОбработатьСообщенияПользователю();
		Отказ = Истина
	КонецЕсли;	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.УстановитьОсновнойНомерДержателяКарты(ОсновнойНомерДержателяКарты);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	// Уточняем доступность полей после запрета редактирования:
	// может потребоваться отключить что-то еще.
	УстановитьДоступностьПолейПоПравам();
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	Объект.ИмяДержателяКарты = БанковскиеКартыСлужебныйКлиентСервер.ИмяДержателяКартыПоУмолчанию(Объект.Владелец);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПолныйНомерКартыНажатие(Элемент)
	ПроверитьОшибкиНомера(Ложь);
	ПоказатьПолныйНомерКарты(Истина);
	ТекущийЭлемент = Элементы.НомерКартыПолный;
КонецПроцедуры

&НаКлиенте
Процедура НомерКартыПолныйПриИзменении(Элемент)
	
	Если ПустаяСтрока(ОсновнойНомерДержателяКарты) Тогда
		Объект.Код = "";
		Объект.ЭтоНациональныйПлатежныйИнструмент = Ложь;
		Объект.ЭтоМеждународнаяПлатежнаяКарта     = Ложь;
		Возврат
	КонецЕсли;	
		
	ОсновнойНомерДержателяКарты = БанковскиеКартыСлужебныйКлиентСервер.СкопироватьЦифры(ОсновнойНомерДержателяКарты);
	Объект.Код = БанковскиеКартыСлужебныйКлиентСервер.МаскированныйНомер(ОсновнойНомерДержателяКарты);
	
	Если БанковскиеКартыСлужебныйКлиентСервер.ЭтоНомерНациональногоПлатежногоИнструмента(ОсновнойНомерДержателяКарты) Тогда
		Объект.ЭтоНациональныйПлатежныйИнструмент = Истина;
		Объект.ЭтоМеждународнаяПлатежнаяКарта     = Ложь;
	Иначе
		Объект.ЭтоНациональныйПлатежныйИнструмент = Ложь;
		Объект.ЭтоМеждународнаяПлатежнаяКарта     = Истина;
	КонецЕсли;
	
	ПроверитьОшибкиНомера();

КонецПроцедуры

&НаКлиенте
Процедура СкрытьПолныйНомерКартыНажатие(Элемент)
	ПроверитьОшибкиНомера(Истина);
	ПоказатьПолныйНомерКарты(Ложь);
	ТекущийЭлемент = Элементы.ПоказатьПолныйНомерКарты;
КонецПроцедуры

&НаКлиенте
Процедура СрокДействияМесяцПриИзменении(Элемент)
	УстановитьСрокДействия()
КонецПроцедуры

&НаКлиенте
Процедура СрокДействияГодПриИзменении(Элемент)
	УстановитьСрокДействия()
КонецПроцедуры

&НаКлиенте
Процедура ЭтоНациональныйПлатежныйИнструментПриИзменении(Элемент)
	ПроверитьОшибкиНомера();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда) 
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ОсновнойНомерДержателяКарты = ТекущийОбъект.ОсновнойНомерДержателяКарты(Истина);
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ДатаИстеченияСрокаДействияКарты) Тогда
		СрокДействияМесяц = Месяц(ТекущийОбъект.ДатаИстеченияСрокаДействияКарты);
		СрокДействияГод   = Год(ТекущийОбъект.ДатаИстеченияСрокаДействияКарты) % 100;
	Иначе
		СрокДействияМесяц = 0;
		СрокДействияГод   = 0;
	КонецЕсли;	
	
	УстановитьАктивныйЭлемент(ТекущийОбъект);	
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьАктивныйЭлемент(ТекущийОбъект)
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Владелец) Тогда
		АктивныйЭлемент = Элементы.Владелец
	ИначеЕсли ТекущийОбъект.Ссылка.Пустая() Тогда	
		АктивныйЭлемент = Элементы.НомерКартыПолный
	Иначе	
		АктивныйЭлемент = Элементы.НомерКартыСкрытый
	КонецЕсли;	
	
	ТекущийЭлемент = АктивныйЭлемент;
	АктивныйЭлемент.АктивизироватьПоУмолчанию = Истина;
	
КонецПроцедуры	

&НаСервере
Процедура ИнициализироватьПоляСрокаДействия()
	
	Элементы.СрокДействияГод.СписокВыбора.Очистить();
	ТекущийГод = Год(ТекущаяДатаСеанса()) % 100;
	Для Год = ТекущийГод По ТекущийГод + 10 Цикл
		Элементы.СрокДействияГод.СписокВыбора.Добавить(
			Год, 
			СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Год, 2));
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПолейПоПравам()
	
	Если Справочники.БанковскиеКартыКонтрагентов.РазрешеноИзменениеОсновногоНомераДержателяКарты() Тогда
		Элементы.ПоказатьПолныйНомерКарты.Картинка    = БиблиотекаКартинок.Изменить;
		Элементы.ПоказатьПолныйНомерКарты.Подсказка   = НСтр("ru = 'Изменить номер карты'");
		Элементы.СкрытьПолныйНомерКарты.Подсказка     = НСтр("ru = 'Завершить изменение номера'");
	ИначеЕсли Справочники.БанковскиеКартыКонтрагентов.РазрешенПросмотрОсновногоНомераДержателяКарты() Тогда
		Элементы.ПоказатьПолныйНомерКарты.Картинка    = БиблиотекаКартинок.Лупа;
		Элементы.ПоказатьПолныйНомерКарты.Подсказка   = НСтр("ru = 'Показать полный номер'");
		Элементы.СкрытьПолныйНомерКарты.Подсказка     = НСтр("ru = 'Скрыть полный номер'");
		Элементы.НомерКартыПолный.ТолькоПросмотр      = Истина;
	Иначе	
		Элементы.ПоказатьПолныйНомерКарты.Видимость   = Ложь;
		Элементы.ПоказатьПолныйНомерКарты.Доступность = Ложь;
		Элементы.НомерКартыПолный.ТолькоПросмотр      = Истина;
	КонецЕсли
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьСрокДействия()
	Если СрокДействияМесяц >= 1 
		И СрокДействияМесяц <= 12 Тогда
		Объект.ДатаИстеченияСрокаДействияКарты = КонецМесяца(Дата(2000 + СрокДействияГод, СрокДействияМесяц, 1));
	Иначе
		Объект.ДатаИстеченияСрокаДействияКарты = '00010101';
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ПоказатьПолныйНомерКарты(НомерПолностью)
	Элементы.НомерКартыПолныйГруппа.Видимость  = НомерПолностью;
	Элементы.НомерКартыСкрытыйГруппа.Видимость = Не НомерПолностью;
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьОшибкиНомера(Проверять = Истина)
	
	Если Проверять И ЗначениеЗаполнено(ОсновнойНомерДержателяКарты) Тогда
		ОшибкиНомера = БанковскиеКартыСлужебныйКлиентСервер.ОшибкиОсновногоНомераДержателяКарты(
			ОсновнойНомерДержателяКарты, 
			Объект.ЭтоНациональныйПлатежныйИнструмент);
	Иначе
		ОшибкиНомера = Новый Массив;
	КонецЕсли;
	
	Если ОшибкиНомера.Количество() > 0 Тогда
		Подсказка  = СтрСоединить(ОшибкиНомера, Символы.ПС);
		ЦветТекста = ЦветТекстаОшибочногоНомера
	Иначе
		Подсказка  = "";
		ЦветТекста = ЦветТекстаПравильногоНомера;
	КонецЕсли;
	Элементы.НомерКартыСкрытый.Подсказка  = Подсказка;
	Элементы.НомерКартыСкрытый.ЦветТекста = ЦветТекста;
	Элементы.НомерКартыПолный.Подсказка   = Подсказка;
	Элементы.НомерКартыПолный.ЦветТекста  = ЦветТекста;
	
КонецПроцедуры	

&НаСервере
Процедура ОбработатьСообщенияПользователю()
	
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	
	Для Каждого Сообщение Из Сообщения Цикл
		Если СтрНайти(Сообщение.Поле, "Код") Или СтрНайти(Сообщение.Поле, "ОсновнойНомерДержателяКарты") Тогда
			Сообщение.Поле = "";
			Если Элементы.НомерКартыПолныйГруппа.Видимость Тогда
				Сообщение.ПутьКДанным = "ОсновнойНомерДержателяКарты";
			ИначеЕсли Элементы.НомерКартыСкрытыйГруппа.Видимость Тогда	
				Сообщение.ПутьКДанным = "Объект.Код";
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти
