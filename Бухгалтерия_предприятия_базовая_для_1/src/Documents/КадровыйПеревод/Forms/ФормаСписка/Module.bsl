#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	
	ОсновнаяОрганизация           = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОтборОрганизация              = ОсновнаяОрганизация;
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.КадровыйПеревод);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОсновнаяОрганизация = Параметр;
		Если ОсновнаяОрганизация <> ОтборОрганизация Тогда
			ОтборОрганизация                 = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
			ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ЗначениеЗаполнено(СтруктураОтбора) Тогда
		
		Если СтруктураОтбора.Свойство("Организация") И ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			ОтборОрганизация = СтруктураОтбора.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			Параметры.Отбор.Удалить("Организация");
		КонецЕсли;
		
	Иначе
		Если ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьПозжеНажатие(Элемент)
	
	ОтложитьПоказНапоминанияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодробнееНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке(СсылкаНаСтатьюИТС);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ПравоПримененияСпецрежима

&НаКлиенте
Процедура ПоказатьИнформациюОПравеПримененияСпецрежима()
	
	// Если не заполнена организация, тогда не показываем предупреждение
	Если НЕ (ОтборОрганизацияИспользование И ЗначениеЗаполнено(ОтборОрганизация)) Тогда
		Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ПоказатьИнформациюОПравеПримененияСпецрежимаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПравеПримененияСпецрежимаНаСервере()
	
	ИнформацияОПравеПримененияСпецрежима = КонтрольПраваПримененияСпецрежима.ИнформацияОПравеПримененияСпецрежима(
		ОтборОрганизация, 
		КонтрольПраваПримененияСпецрежима.ИмяПоказателяСпецрежимаРаботники());
	СледующееЗначениеНапоминания         = ИнформацияОПравеПримененияСпецрежима.СледующееЗначениеНапоминания;
	СсылкаНаСтатьюИТС                    = ИнформацияОПравеПримененияСпецрежима.СсылкаНаСтатьюИТС;
	
	Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = ИнформацияОПравеПримененияСпецрежима.Показать;
	Элементы.ИнформацияОПравеПримененияСпецрежима.ЦветФона = ИнформацияОПравеПримененияСпецрежима.ЦветФонаГруппы;
	Элементы.ТекстИнформации.Заголовок = ИнформацияОПравеПримененияСпецрежима.ТекстИнформации;
	
	Элементы.НапомнитьПозже.Заголовок  = ИнформацияОПравеПримененияСпецрежима.ТекстНапомнитьПозже;
	// В случае если это последний шаг, то прячем команду "Напомнить позже"
	Элементы.НапомнитьПозже.Видимость  = (ИнформацияОПравеПримененияСпецрежима.СледующееЗначениеНапоминания < 100);
	
КонецПроцедуры

&НаСервере
Процедура ОтложитьПоказНапоминанияНаСервере()
	
	КонтрольПраваПримененияСпецрежима.ОтложитьПоказНапоминания(
		ОтборОрганизация,
		КонтрольПраваПримененияСпецрежима.ИмяПоказателяСпецрежимаРаботники(),
		СледующееЗначениеНапоминания);
		
	Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти