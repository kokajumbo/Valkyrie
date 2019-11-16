#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановленОтборПоВладельцу = Параметры.Отбор.Свойство("Владелец");
	
	ВидимостьОрганизации = Не УстановленОтборПоВладельцу И Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	Элементы.Владелец.Видимость = ВидимостьОрганизации;
	Элементы.Список.Шапка       = ВидимостьОрганизации;
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("РегистрацияВНалоговомОргане", ОтборРегистрацияВНалоговомОргане);
	ОтборРегистрацияВНалоговомОрганеИспользование = ЗначениеЗаполнено(ОтборРегистрацияВНалоговомОргане);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "РегистрацияВНалоговомОргане");
	КонецЕсли;
	
	ЗаполнитьСписокВыбораНалоговыхИнспекций(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененВидДеятельностиОрганизации" Тогда
		
		Если Параметр = Организация Тогда
			ЗаполнитьСписокВыбораНалоговыхИнспекций(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборРегистрацияВНалоговомОрганеИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "РегистрацияВНалоговомОргане");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНалоговаяИнспекцияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "РегистрацияВНалоговомОргане");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если ЭтотОбъект.ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		
		Регистрация = РегистрацияВНалоговомОрганеВыбранногоВидаДеятельности(Значение);
		Если ЗначениеЗаполнено(Регистрация) Тогда
			ДополнительныеПараметры = ЭтотОбъект.ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры;
			ДополнительныеПараметры.Вставить("РегистрацияВНалоговомОргане", Регистрация);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораНалоговыхИнспекций(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ОтборРегистрацияВНалоговомОргане.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Форма.Организация) Тогда
		СписокВыбораНалоговыхИнспекций = СписокВыбораНалоговыхИнспекций(Форма.Организация);
		Для Каждого НалоговаяИнспекция Из СписокВыбораНалоговыхИнспекций Цикл
			Элементы.ОтборРегистрацияВНалоговомОргане.СписокВыбора.Добавить(НалоговаяИнспекция.Значение, НалоговаяИнспекция.Представление);
		КонецЦикла;
		Элементы.ГруппаОтборРегистрацияВНалоговомОргане.Видимость = (СписокВыбораНалоговыхИнспекций.Количество() > 1);
	Иначе
		Элементы.ГруппаОтборРегистрацияВНалоговомОргане.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокВыбораНалоговыхИнспекций(Организация)
	
	Возврат Справочники.ВидыДеятельностиЕНВД.СписокВыбораНалоговыхИнспекций(Организация);
	
КонецФункции

&НаСервереБезКонтекста
Функция РегистрацияВНалоговомОрганеВыбранногоВидаДеятельности(ВыбранныеВидыДеятельности)
	
	Если ТипЗнч(ВыбранныеВидыДеятельности) = Тип("Массив") Тогда
		Если ВыбранныеВидыДеятельности.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			ВидДеятельности = ВыбранныеВидыДеятельности[0];
		КонецЕсли;
	Иначе
		ВидДеятельности = ВыбранныеВидыДеятельности;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидДеятельности) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ВидДеятельности, "РегистрацияВНалоговомОргане");
	
КонецФункции

#КонецОбласти