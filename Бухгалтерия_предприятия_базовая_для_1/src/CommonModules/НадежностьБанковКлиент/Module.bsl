#Область СлужебныеПроцедурыИФункции
	
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПодключитьОбработчикОжидания("Подключаемый_ПолучитьСобытияБанковОрганизаций", 15, Истина);
	
КонецПроцедуры

Процедура ПолучитьСобытияБанковОрганизаций() Экспорт
	
	ДлительнаяОперация = НадежностьБанковВызовСервера.ПолучитьСобытияБанковОрганизацийВФоне();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПоказатьПоследниеСобытияБанковОрганизаций", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПоказатьИнформациюНадежностьБанков(Форма) Экспорт
	
	ПредотвратитьСбросРедактируемогоЗначения(Форма);
	
	НадежностьБанковВызовСервера.ПроверитьОбновлениеСобытий(Форма.ИнформацияНадежностьБанков);
	
	Если ПодключитьОбработчикПоказатьИнформациюНадежностьБанков(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	НадежностьБанковКлиентСервер.ПоказатьИнформациюНадежностьБанков(Форма);
	
КонецПроцедуры

Функция ПодключитьОбработчикПоказатьИнформациюНадежностьБанков(Форма) Экспорт

	Информация = Форма.ИнформацияНадежностьБанков;
	Если ТипЗнч(Информация) <> Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Информация.Используется 
		И НЕ Информация.Актуальность Тогда
		Если Информация.ПараметрыОбработчикаОжидания = Неопределено Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Информация.ПараметрыОбработчикаОжидания);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Информация.ПараметрыОбработчикаОжидания);
		КонецЕсли;
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьИнформациюНадежностьБанков",
			Информация.ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		Возврат Истина;
	Иначе
		Информация.ПараметрыОбработчикаОжидания = Неопределено;
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Процедура ОткрытьИнформациюОСобытии(ДопПараметры) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДанныеСобытия", ДопПараметры.ДанныеСобытия);
	ЭтоОповещение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДопПараметры, "ЭтоОповещение", Ложь);
	ПараметрыФормы.Вставить("ЭтоОповещение", ЭтоОповещение);
	ОткрытьФорму("Обработка.ИнформацияНадежностьБанков.Форма", ПараметрыФормы, , ДопПараметры.КлючСобытия);
	
КонецПроцедуры

Процедура ПоказатьПоследниеСобытияБанковОрганизаций(Результат, ДопПараметры) Экспорт

	Если Результат = Неопределено
		ИЛИ Результат.Статус = "Ошибка" Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПолучитьСобытияБанковОрганизаций", 5 * 60, Истина);
		Возврат;
	КонецЕсли;
	
	Информация = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если НЕ ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Информация, "Используется", Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючЗначениеСобытия Из Информация.События Цикл
		
		ДанныеСобытия = КлючЗначениеСобытия.Значение;
		
		Если ДанныеСобытия.Показано Тогда
			Продолжить;
		КонецЕсли;
		
		КлючСобытия = "НадежностьБанков" + Формат(ДанныеСобытия.Идентификатор, "ЧГ=");
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("ДанныеСобытия", ДанныеСобытия);
		ДопПараметры.Вставить("КлючСобытия", КлючСобытия);
		ДопПараметры.Вставить("ЭтоОповещение", Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьИнформациюОСобытии", 
			НадежностьБанковКлиент.ЭтотОбъект, 
			ДопПараметры);
			
		Пояснение = ДанныеСобытия.ТекстСобытия;
		КартинкаСобытия = ?(ДанныеСобытия.Критичное, БиблиотекаКартинок.НовостиВажные, БиблиотекаКартинок.Новости);
		
		ПоказатьОповещениеПользователя(ДанныеСобытия.Событие,
			ОписаниеОповещения,
			Пояснение,
			КартинкаСобытия, 
			СтатусОповещенияПользователя.Важное, 
			КлючСобытия);
		
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПолучитьСобытияБанковОрганизаций", 60 * 60, Истина);
	
КонецПроцедуры

Процедура ПредотвратитьСбросРедактируемогоЗначения(Форма)
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ПолеФормы") 
			И Форма.ТекущийЭлемент.Вид = ВидПоляФормы.ПолеВвода Тогда
			Форма.ТекущийЭлемент.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.ПриИзмененииЗначения;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти




