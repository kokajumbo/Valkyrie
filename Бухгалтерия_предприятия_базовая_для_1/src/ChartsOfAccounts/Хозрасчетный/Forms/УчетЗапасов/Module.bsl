#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.ПланыСчетов.Хозрасчетный);
	Элементы.ЗаписатьИЗакрыть.Видимость = НЕ ТолькоПросмотр;
	
	ПараметрыУчета = ОбщегоНазначенияБП.ОпределитьПараметрыУчета();
	
	ВестиПартионныйУчет                 = ПараметрыУчета.ВестиПартионныйУчет;
	ВестиПартионныйУчетИсходноеЗначение = ВестиПартионныйУчет;
	
	СкладскойУчет                 = ПараметрыУчета.СкладскойУчет;
	СкладскойУчетИсходноеЗначение = СкладскойУчет;
	
	ВестиУчетПоСкладам = СкладскойУчет <> 0;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВестиПартионныйУчетПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетПоСкладамПриИзменении(Элемент)
	
	СкладскойУчет = Число(ВестиУчетПоСкладам);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкладскойУчетПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СкладскойУчет) Тогда
		СкладскойУчет = 1;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПрименитьНастройкуСубконто();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзменения();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если (Форма.ВестиПартионныйУчет <> Форма.ВестиПартионныйУчетИсходноеЗначение)
		И Форма.ВестиПартионныйУчетИсходноеЗначение Тогда
		Форма.Элементы.ГруппаВестиПартионныйУчетПредупреждениеАктивно.Видимость = Истина;
	Иначе
		Форма.Элементы.ГруппаВестиПартионныйУчетПредупреждениеАктивно.Видимость = Ложь;
	КонецЕсли;
	
	Форма.Элементы.СкладскойУчет.Доступность = Форма.ВестиУчетПоСкладам;
	
	Если Форма.СкладскойУчет < Форма.СкладскойУчетИсходноеЗначение Тогда
		Форма.Элементы.ГруппаСкладскойУчетПредупреждениеАктивно.Видимость = Истина;
	Иначе
		Форма.Элементы.ГруппаСкладскойУчетПредупреждениеАктивно.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзменения()
	
	ПараметрыУчета.ВестиПартионныйУчет = ВестиПартионныйУчет;
	ПараметрыУчета.СкладскойУчет       = СкладскойУчет;
	
	ТекстВопроса = ОбщегоНазначенияБПВызовСервера.ПолучитьТекстВопросаПриУдаленииСубконто(ПараметрыУчета);
	Если ПустаяСтрока(ТекстВопроса) Тогда
		ПрименитьНастройкуСубконто();
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПередЗаписьюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьНастройкуСубконто(Отказ = Ложь)
	
	ПрименитьНастройкуСубконтоНаСервере(Отказ);
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		Оповестить("ИзменениеНастройкиПланаСчетов");
		Оповестить("ИзменениеНастроекПараметровУчета");
		ОповеститьОбИзменении(Тип("ПланСчетовСсылка.Хозрасчетный"));
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменены параметры субконто'"), 
			"e1cib/app/Обработка.ЖурналРегистрации", "Журнал регистрации");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкуСубконтоНаСервере(Отказ = Ложь)
	
	ОбщегоНазначенияБП.ПрименитьПараметрыУчета(ПараметрыУчета, Истина, Отказ);
		
КонецПроцедуры

#КонецОбласти
