
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьЗначенияСвойств(Объект, Параметры);
		Если НЕ ПустаяСтрока(Параметры.СВИФТБИК) Тогда
			СВИФТБИКИзменение(ЭтотОбъект);
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту();
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НадежностьБанковКлиент.ПодключитьОбработчикПоказатьИнформациюНадежностьБанков(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.РучноеИзменение = ?(РучноеИзменение = Неопределено, 2, РучноеИзменение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму банковского счета об изменении реквизитов банка
	Оповестить("ЗаписанЭлементБанк", Объект.Ссылка, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СВИФТБИКПриИзменении(Элемент)
	
	СВИФТБИКИзменение(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	НадежностьБанковКлиентСервер.ПолучитьИнформациюНадежностьБанков(ЭтотОбъект, 
		Объект.Код, 
		ПоказыватьИнформациюНадежностьБанков(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросИзменитьЗавершение", ЭтотОбъект);
	
	Текст = НСтр("ru = 'Поставляемые данные обновляются автоматически.
		|После ручного изменения автоматическое обновление этого элемента производиться не будет.
		|Продолжить с изменением?'");
		
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатора(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросОбновитьИзКлассификатораЗавершение", ЭтотОбъект);
	
	Текст = НСтр("ru = 'Данные элемента будут заменены данными из классификатора.
		|Все ручные изменения будут потеряны. Продолжить?'");
		
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	// Код банка.
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Код");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Страна", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СтраныМира.Россия);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СВИФТБИКИзменение(Форма)
	
	Объект = Форма.Объект;
	Объект.СВИФТБИК = ВРег(СокрЛП(Объект.СВИФТБИК));
	Если БанковскиеПравила.СтрокаСоответствуетФорматуSWIFT(Объект.СВИФТБИК) Тогда
		СтранаБанка = БанковскиеСчетаВызовСервера.СтранаПоSWIFT(Объект.СВИФТБИК);
		Если ЗначениеЗаполнено(СтранаБанка) Тогда
			Объект.Страна = СтранаБанка;
		КонецЕсли;
		
		ИзменитьРеквизитыЗависимыеОтСтраны(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРеквизитыЗависимыеОтСтраны(Форма)
	
	ЯвляетсяБанкомРФ = (Форма.Объект.Страна = Форма.СтранаРФ);
	
	Форма.Элементы.ТекстРучногоИзменения.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ОбновитьИзКлассификатора.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Изменить.Видимость = ЯвляетсяБанкомРФ;
	
	Если ЯвляетсяБанкомРФ Тогда
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'БИК'");
	Иначе
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'Национальный код'"); 
	КонецЕсли;
	
	НадежностьБанковКлиентСервер.ПолучитьИнформациюНадежностьБанков(Форма, 
		Форма.Объект.Код, 
		ПоказыватьИнформациюНадежностьБанков(Форма));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Банки);
	РаботаСБанкамиБП.СчитатьФлагРучногоИзменения(ЭтотОбъект, МожноРедактировать);
	
	Элементы.НадписьДеятельностьБанкаПрекращена.Видимость = ДеятельностьПрекращена;
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИзменитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		РучноеИзменение    = Истина;
		РаботаСБанкамиКлиентПереопределяемый.ОбработатьФлагРучногоИзменения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОбновитьИзКлассификатораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		ОбновитьНаСервере();
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	РаботаСБанкамиБП.ВосстановитьЭлементИзОбщихДанных(ЭтотОбъект);
	
	НадежностьБанковКлиентСервер.ПолучитьИнформациюНадежностьБанков(ЭтотОбъект, 
		Объект.Код, 
		ПоказыватьИнформациюНадежностьБанков(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПоказыватьИнформациюНадежностьБанков(Форма)

	Если Форма.ДеятельностьПрекращена 
		ИЛИ Форма.Объект.Страна <> Форма.СтранаРФ Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПоказатьИнформациюНадежностьБанков()
	
	НадежностьБанковКлиент.ПоказатьИнформациюНадежностьБанков(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
