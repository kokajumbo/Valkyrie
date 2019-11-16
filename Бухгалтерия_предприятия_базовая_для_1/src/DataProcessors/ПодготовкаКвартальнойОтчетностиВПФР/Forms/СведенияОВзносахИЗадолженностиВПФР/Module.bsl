#Область ОписаниеПеременных

&НаКлиенте
Перем СтарыеЗначенияКонтролируемыхПолей;
&НаКлиенте
Перем ЗакрыватьБезПроверкиМодифицированности;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьКонтролируемыеПоля();
	
	ЗначенияДляЗаполнения = Новый Структура;
	
	Если ЗначениеЗаполнено(Параметры.ОтчетныйПериод) Тогда
		ОтчетныйПериод = Параметры.ОтчетныйПериод;
	Иначе
		ЗначенияДляЗаполнения.Вставить("ПредыдущийКвартал", "ОтчетныйПериод");
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация;
	Иначе
		ЗначенияДляЗаполнения.Вставить("Организация", "Организация");
	КонецЕсли;

	Если ЗначенияДляЗаполнения.Количество() > 0 Тогда 
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);	
	КонецЕсли;	
	
	ОтчетныйПериодПредставление = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(ОтчетныйПериод);
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ОтчетныйПериод) Тогда
		
		ЗаполнитьСведенияОВзносах();
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрыватьБезПроверкиМодифицированности <> Истина Тогда
		Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Не ЗначениеЗаполнено(ОтчетныйПериод) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан отчетный период.'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,,
			"ОтчетныйПериодПредставление",,
			Отказ);		
	КонецЕсли;	
		
	ТекстСообщенияНеЗаполненСотрудник = НСтр("ru = 'В строке №%1 списка сотрудников не заполнено поле ""Сотрудник""'");
	
	ИндексСтроки = 0;
	Для Каждого СтрокаСотрудник Из СведенияОВзносах Цикл
		Если Не ЗначениеЗаполнено(СтрокаСотрудник.ФизическоеЛицо) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ТекстСообщенияНеЗаполненСотрудник,
								ИндексСтроки + 1);
								
			Поле = "СведенияОВзносах[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=") + "].ФизическоеЛицо";					
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,,
				Поле,,
				Отказ);							
		КонецЕсли;
		
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)

	ДополнительныеПараметры = Новый Структура("Направление", Направление);
	
	Оповещение = Новый ОписаниеОповещения("ОтчетныйПериодПредставлениеРегулированиеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	СохранитьДанныеСЗапросомСохранения(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеРегулированиеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	Если Отказ И Модифицированность Тогда
		Возврат;
	КонецЕсли;	
	
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(ОтчетныйПериод, ОтчетныйПериодПредставление, ДополнительныеПараметры.Направление);	
	
	ОтчетныйПериодПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ОтчетныйПериодПредставлениеНачалоВыбораПродолжение", ЭтотОбъект);
	СохранитьДанныеСЗапросомСохранения(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеНачалоВыбораПродолжение(Отказ, ДополнительныеПараметры) Экспорт

	Если Отказ И Модифицированность Тогда
		Возврат;
	КонецЕсли;	
	
	Оповещение = Новый ОписаниеОповещения("ОтчетныйПериодПредставлениеНачалоВыбораЗавершение", ЭтотОбъект);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "ОтчетныйПериод", "ОтчетныйПериодПредставление", , ,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеНачалоВыбораЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	ОтчетныйПериодПриИзменении();
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыСведенияОВзносах

&НаКлиенте
Процедура СведенияОВзносахПриАктивизацииСтроки(Элемент)
	Если Элементы.СведенияОВзносах.ТекущиеДанные <> Неопределено Тогда
		ПерсонифицированныйУчетКлиентСервер.ДокументыСЗВУстановитьЗначенияКонтролируемыхПолей(
			Элементы.СведенияОВзносах.ТекущиеДанные, 
			КонтролируемыеПоля, 
			СтарыеЗначенияКонтролируемыхПолей);
	КонецЕсли;		
		
	УстановитьДоступностьКомандСведенияОВзносах();	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВзносахПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элементы.СведенияОВзносах.ТекущиеДанные.ФиксСтрока = Истина;
		УстановитьДоступностьКомандСведенияОВзносах();
		
		ЕстьКорректировки = Истина;
		
		УстановитьТекстИнфонадписи(ЭтаФорма);
		УстановитьДоступностьКнопкиОбновитьВзносы(ЭтаФорма);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВзносахПередУдалением(Элемент, Отказ)
	Если Не Элементы.СведенияОВзносах.ТекущиеДанные.ФиксСтрока Тогда 
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВзносахПослеУдаления(Элемент)
	ЕстьКорректировки = ЕстьСтрокиСФиксДанными();
	
	УстановитьТекстИнфонадписи(ЭтаФорма);
	УстановитьДоступностьКнопкиОбновитьВзносы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура НачисленоСтраховаяПриИзменении(Элемент)
	ВзносыПриИзменении("СтраховаяЧасть");
КонецПроцедуры

&НаКлиенте
Процедура НачисленоНакопительнаяПриИзменении(Элемент)
	ВзносыПриИзменении("НакопительнаяЧасть");
КонецПроцедуры

&НаКлиенте
Процедура УплаченоСтраховаяПриИзменении(Элемент)
	ВзносыПриИзменении("СтраховаяЧасть");
КонецПроцедуры

&НаКлиенте
Процедура УплаченоНакопительнаяПриИзменении(Элемент)
	ВзносыПриИзменении("НакопительнаяЧасть");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВзносахЗадолженностьПоСтраховойЧастиПриИзменении(Элемент)
	ВзносыПриИзменении("ЗадолженностьПоСтраховойЧасти");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВзносахЗадолженностьПоНакопительнойЧастиПриИзменении(Элемент)
	ВзносыПриИзменении("ЗадолженностьПоНакопительнойЧасти");
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	Отказ = Ложь;
	ЗаписатьИзмененныеСведенияОВзносах(Отказ);
	
	Если Не Отказ Тогда
		ЗакрыватьБезПроверкиМодифицированности = Истина;
		Закрыть();	
	Иначе 
		ЗакрыватьБезПроверкиМодифицированности = Ложь;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ЗакрыватьБезПроверкиМодифицированности = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
		
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбора.Фильтр = ".xls|*.xls|.csv|*.csv";
	
	Если Не ДиалогВыбора.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(ДиалогВыбора.ПолноеИмяФайла);
	
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	Если ВРег(Файл.Расширение) = ".XLS" Тогда
		
		Информация = Новый СистемнаяИнформация;
	
		Если Информация.ТипПлатформы = ТипПлатформы.Linux_x86 Или Информация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
	        ПоказатьПредупреждение(, НСтр("ru = 'Загрузка из файла "".XLS"" недоступна при работе в Linux'"));
	        Возврат;
	    КонецЕсли;

		ДанныеФайла = ПреобразоватьXLSФайлВCSV(ДиалогВыбора.ПолноеИмяФайла);
	ИначеЕсли ВРег(Файл.Расширение) = ".CSV" Тогда 
		ДанныеФайла = Новый	ТекстовыйДокумент;
		ДанныеФайла.Прочитать(ДиалогВыбора.ПолноеИмяФайла);
	Иначе
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;	
	
	ДанныеCSVФайлаВДанныеФормы(ДанныеФайла);
	
	УстановитьДоступностьКнопкиОбновитьВзносы(ЭтаФорма);
	УстановитьДоступностьКомандСведенияОВзносах();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИсправленияВТекущейСтроке(Команда)
	ОтменитьИсправления(Элементы.СведенияОВзносах.ТекущиеДанные.ФизическоеЛицо);
	УстановитьДоступностьКомандСведенияОВзносах();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда)
	ОтменитьИсправления();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстИнфонадписи(Форма)
	ПредставлениеОтчетногоПериода = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Форма.ОтчетныйПериод, Истина);
	Если Форма.ЕстьКорректировки Тогда
		ШаблонТекста = НСтр("ru = 'Сведения о взносах и задолженности на начало %1 были скорректированы, корректировки учтены при распределении взносов, уплаченных за %1 Для отмены всех корректировок за квартал нажмите ""Отменить все исправления""'");
	Иначе 
		ШаблонТекста = НСтр("ru = 'В форме выведены текущие данные о взносах и задолженности на начало %1 При необходимости вы можете внести корректировки или загрузить данные о задолженности из файла, полученного в ПФР. Скорректированные данные будут использованы при распределении взносов, уплаченных за %1'");
	КонецЕсли;	
	
	Форма.ТекстИнфонадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ШаблонТекста,
								ПредставлениеОтчетногоПериода);
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКнопкиОбновитьВзносы(Форма)	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СведенияОВзносахОтменитьВсеИсправления", "Доступность", Форма.ЕстьКорректировки);
КонецПроцедуры	

&НаКлиенте
Функция РежимВыбораПериода(ВыбираемыйПериод) Экспорт
	Год = Год(ВыбираемыйПериод);
	Если Год < 2011 Тогда
		Возврат "Полугодие";
	Иначе
		Возврат "Квартал";
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура ОтчетныйПериодПриИзменении()
	Модифицированность = Ложь;
	                                          
	ЗаполнитьСведенияОВзносах();	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступностьКомандСведенияОВзносах()
	ДанныеТекущейСтроки = Элементы.СведенияОВзносах.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СведенияОВзносахОтменитьИсправленияВТекущейСтроке", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СведенияОВзносахУдалить", "Доступность", Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СведенияОВзносахОтменитьИсправленияВТекущейСтроке", "Доступность", ДанныеТекущейСтроки.ФиксВзносы);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СведенияОВзносахУдалить", "Доступность", ДанныеТекущейСтроки.ФиксВзносы);
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ВзносыПриИзменении(РазделВзносов)
	ДанныеТекущейСтроки = Элементы.СведенияОВзносах.ТекущиеДанные;
	
	Если РазделВзносов = "СтраховаяЧасть" Тогда
		ДанныеТекущейСтроки.ЗадолженностьПоСтраховойЧасти = ДанныеТекущейСтроки.НачисленоСтраховая - ДанныеТекущейСтроки.УплаченоСтраховая;
	ИначеЕсли РазделВзносов = "НакопительнаяЧасть" Тогда	
		ДанныеТекущейСтроки.ЗадолженностьПоНакопительнойЧасти = ДанныеТекущейСтроки.НачисленоНакопительная - ДанныеТекущейСтроки.УплаченоНакопительная;
	ИначеЕсли РазделВзносов = "ЗадолженностьПоСтраховойЧасти" Тогда
		ДанныеТекущейСтроки.НачисленоСтраховая = 0;
		ДанныеТекущейСтроки.УплаченоСтраховая = 0;
	ИначеЕсли РазделВзносов = "ЗадолженностьПоНакопительнойЧасти" Тогда
		ДанныеТекущейСтроки.НачисленоНакопительная = 0;
		ДанныеТекущейСтроки.УплаченоНакопительная = 0;		
	КонецЕсли;	
	
	ПерсонифицированныйУчетКлиент.ДокументыСЗВКонтрольИсправленийПриОкончанииРедактированияСтроки(
	 	ДанныеТекущейСтроки, 
		КонтролируемыеПоля, 
		СтарыеЗначенияКонтролируемыхПолей, 
		ДанныеТекущейСтроки);	
		
	Если ДанныеТекущейСтроки.ФиксВзносы Тогда
		ЕстьКорректировки = Истина;
	КонецЕсли;
		
	УстановитьДоступностьКомандСведенияОВзносах();	
	
	УстановитьТекстИнфонадписи(ЭтаФорма);
	УстановитьДоступностьКнопкиОбновитьВзносы(ЭтаФорма);
КонецПроцедуры	

&НаСервере
Процедура УстановитьКонтролируемыеПоля()
	СписокКонтролируемыхПолей = Новый Массив;
	СписокКонтролируемыхПолей.Добавить("НачисленоСтраховая");
	СписокКонтролируемыхПолей.Добавить("НачисленоНакопительная");
	СписокКонтролируемыхПолей.Добавить("УплаченоСтраховая");
	СписокКонтролируемыхПолей.Добавить("УплаченоНакопительная");
	СписокКонтролируемыхПолей.Добавить("ЗадолженностьПоСтраховойЧасти");
	СписокКонтролируемыхПолей.Добавить("ЗадолженностьПоНакопительнойЧасти");
	
	ОписаниеКонтролируемыхПолей = Новый Структура("ИмяПоляФиксДанных, КонтролируемыеПоля", "ФиксВзносы", Новый ФиксированныйМассив(СписокКонтролируемыхПолей));
	
	СтруктураКонтролируемыхПолей = Новый Структура("Взносы", Новый ФиксированнаяСтруктура(ОписаниеКонтролируемыхПолей)); 
											
	КонтролируемыеПоля = Новый ФиксированнаяСтруктура(СтруктураКонтролируемыхПолей);	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСведенияОВзносах()
	ЕстьКорректировки = Ложь;
	СведенияОВзносах.Очистить();
	
	Выборка = ВыборкаСведенийОВзносах();
	
	Пока Выборка.Следующий() Цикл
		СтрокаВзносов = СведенияОВзносах.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВзносов, Выборка); 
		
		Если Выборка.ФиксВзносы Тогда
			ЕстьКорректировки = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
	УстановитьТекстИнфонадписи(ЭтаФорма);
	УстановитьДоступностьКнопкиОбновитьВзносы(ЭтаФорма);
КонецПроцедуры	

&НаСервере
Функция ВыборкаСведенийОВзносах(СписокФизическихЛиц = Неопределено, ОтменаИсправлений = Ложь)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПерсонифицированныйУчет.СоздатьВТВзносыНаНачалоПериода(
		Запрос.МенеджерВременныхТаблиц,
		Организация,
		ОтчетныйПериод,
		Не ОтменаИсправлений,
		СписокФизическихЛиц);
		
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ВзносыНаНачалоПериода.ФизическоеЛицо,
	|	ВзносыНаНачалоПериода.НачисленоСтраховая,
	|	ВзносыНаНачалоПериода.НачисленоНакопительная,
	|	ВзносыНаНачалоПериода.УплаченоСтраховая,
	|	ВзносыНаНачалоПериода.УплаченоНакопительная,
	|	ВзносыНаНачалоПериода.ЗадолженностьСтраховая КАК ЗадолженностьПоСтраховойЧасти,
	|	ВзносыНаНачалоПериода.ЗадолженностьНакопительная КАК ЗадолженностьПоНакопительнойЧасти,
	|	ВзносыНаНачалоПериода.ФиксВзносы
	|ИЗ
	|	ВТВзносыНаНачалоПериода КАК ВзносыНаНачалоПериода";		
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции	

&НаСервере
Процедура ОтменитьИсправления(ФизическоеЛицо = Неопределено)
	
	Если ФизическоеЛицо = Неопределено Тогда
		СписокФизическихЛиц = Неопределено;
	Иначе	
		СписокФизическихЛиц = Новый Массив;
		СписокФизическихЛиц.Добавить(ФизическоеЛицо);
	КонецЕсли;	
	
	Выборка = ВыборкаСведенийОВзносах(СписокФизическихЛиц, Истина);
	
	Если ФизическоеЛицо = Неопределено Тогда
		ЕстьКорректировки = Ложь;
		СведенияОВзносах.Очистить();
		Пока Выборка.Следующий() Цикл
			СтрокаВзносов = СведенияОВзносах.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаВзносов, Выборка);
			
			Если Выборка.ФиксВзносы Тогда
				ЕстьКорректировки = Истина;
			КонецЕсли;	
		КонецЦикла;						
	Иначе
		НайденныеСтроки = СведенияОВзносах.НайтиСтроки(Новый Структура("ФизическоеЛицо", ФизическоеЛицо));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаСведенийОВзносах = НайденныеСтроки[0]; 
			СтрокаСведенийОВзносах.ЗадолженностьПоСтраховойЧасти = 0;	
			СтрокаСведенийОВзносах.ЗадолженностьПоНакопительнойЧасти = 0;	
			СтрокаСведенийОВзносах.НачисленоСтраховая = 0;	
			СтрокаСведенийОВзносах.НачисленоНакопительная = 0;	
			СтрокаСведенийОВзносах.УплаченоСтраховая = 0;	
			СтрокаСведенийОВзносах.УплаченоНакопительная = 0;
			СтрокаСведенийОВзносах.ФиксВзносы = Ложь;
			
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(СтрокаСведенийОВзносах, Выборка);	
			Иначе
				СведенияОВзносах.Удалить(СведенияОВзносах.Индекс(СтрокаСведенийОВзносах));
			КонецЕсли;		
		КонецЕсли;	
		
		ЕстьКорректировки = ЕстьСтрокиСФиксДанными();
	КонецЕсли;	
	
	УстановитьТекстИнфонадписи(ЭтаФорма);
	УстановитьДоступностьКнопкиОбновитьВзносы(ЭтаФорма);
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьИзмененныеСведенияОВзносах(Отказ)
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	ДанныеДляЗаписи = ПерсонифицированныйУчет.ТаблицаСведенияОВзносах();
	
	Для Каждого СтрокаДанныхФормы Из СведенияОВзносах Цикл
		Если СтрокаДанныхФормы.ФиксСтрока 
			Или СтрокаДанныхФормы.ФиксВзносы Тогда
			
			СтрокаФиксируемыхДанных = ДанныеДляЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаФиксируемыхДанных, СтрокаДанныхФормы);
			СтрокаФиксируемыхДанных.ЗадолженностьСтраховая = СтрокаДанныхФормы.ЗадолженностьПоСтраховойЧасти;
			СтрокаФиксируемыхДанных.ЗадолженностьНакопительная = СтрокаДанныхФормы.ЗадолженностьПоНакопительнойЧасти;
		КонецЕсли;	
	КонецЦикла;	
	
	ПерсонифицированныйУчет.ЗафиксироватьВзносыНаНачалоПериода(Организация, ОтчетныйПериод, ДанныеДляЗаписи);
	Модифицированность = Ложь;
КонецПроцедуры	

&НаКлиенте
Процедура СохранитьДанныеСЗапросомСохранения(ОповещениеЗавершения = Неопределено)
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("СохранитьДанныеСЗапросомСохраненияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе 
		СохранитьДанныеСЗапросомСохраненияЗавершение(Неопределено, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СохранитьДанныеСЗапросомСохраненияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 

	Отказ = Ложь;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзмененныеСведенияОВзносах(Отказ);
	Иначе
		Отказ = Ложь;
		Модифицированность = Ложь;
	КонецЕсли;					
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	Отказ = Ложь;
	ЗаписатьИзмененныеСведенияОВзносах(Отказ);
	
	Если Не Отказ Тогда 
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ЕстьСтрокиСФиксДанными()
	СтруктураПоиска = Новый Структура("ФиксВзносы", Истина);
	
	НайденныеСтроки = СведенияОВзносах.НайтиСтроки(СтруктураПоиска);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат Истина;
	КонецЕсли;	
	
	СтруктураПоиска = Новый Структура("ФиксСтрока", Истина);
	
	НайденныеСтроки = СведенияОВзносах.НайтиСтроки(СтруктураПоиска);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
КонецФункции	

#Область ЗагрузкаИзФайла

&НаКлиенте
Функция ПреобразоватьXLSФайлВCSV(ИмяФайла)
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
	Исключение
		ТекстИсключения = НСтр("ru = 'Не установлено приложение ""Excel"".'");
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	Excel.AutomationSecurity = 3;
	КнигаСданными = Excel.WorkBooks.Open(ИмяФайла);
	
	#Если ВебКлиент Тогда
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		
	Если Не ДиалогВыбора.Выбрать() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФайлаCSV = ДиалогВыбора.Каталог + "\" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "") + ".Csv";
	#иначе
	ИмяФайлаCSV = ПолучитьИмяВременногоФайла("Csv");
	#КонецЕсли
	
	КнигаСданными.SaveAs(ИмяФайлаCSV, 23);
	
	КнигаСданными.Close(Ложь);
    Excel.Quit();
    Excel = Неопределено;

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	ТекстовыйДокумент.Прочитать(ИмяФайлаCSV);
	
	УдалитьФайлы(ИмяФайлаCSV);

	Возврат ТекстовыйДокумент;
КонецФункции	

&НаСервере
Процедура ДанныеCSVФайлаВДанныеФормы(ДанныеФайла)	
	ПроверитьВозможностьЗагрузкиДанныхФайла(ДанныеФайла);
	
	КоличествоСтрок = ДанныеФайла.КоличествоСтрок();
	
	СписокСНИЛС = Новый Массив;
	
	Для НомерСтроки = 3 По КоличествоСтрок Цикл
		СтрокаДанных = ДанныеФайла.ПолучитьСтроку(НомерСтроки);
		
		ЗначенияКолонокВСтроке = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДанных, ";");
		
		Если ЗначенияКолонокВСтроке.Количество() > 3 Тогда
			СНИЛС = СНИЛСИзСтрокиФайла(ЗначенияКолонокВСтроке);
			СписокСНИЛС.Добавить(СНИЛС);			
		КонецЕсли;	
	КонецЦикла;	
	
	СоответствиеСНИЛСФизическимЛицам = СоответствиеСНИЛСФизическимЛицам(СписокСНИЛС);
		
	СтрокиПоСотрудникам = Новый Соответствие;
	Для Каждого СтрокаСведений Из СведенияОВзносах Цикл
		СтрокиПоСотрудникам.Вставить(СтрокаСведений.ФизическоеЛицо, СтрокаСведений);
	КонецЦикла;	
	
	Для НомерСтроки = 3 По КоличествоСтрок Цикл
		СтрокаДанных = ДанныеФайла.ПолучитьСтроку(НомерСтроки);
		
		ДобавитьСтрокуТаблицуЗадолженности(СтрокаДанных, СоответствиеСНИЛСФизическимЛицам, СтрокиПоСотрудникам);
	КонецЦикла;
КонецПроцедуры	

&НаСервере
Процедура ПроверитьВозможностьЗагрузкиДанныхФайла(ДанныеФайла)
	ТекстЗаголовка = "Суммы ЗЛ нарастающим итогом по организации до указанного периода (D) - ";
	
	КоличествоСтрок = ДанныеФайла.КоличествоСтрок();
	
	Если КоличествоСтрок < 3 Тогда
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;	
	
	ПерваяСтрока = ДанныеФайла.ПолучитьСтроку(1);

	Если Лев(ПерваяСтрока, СтрДлина(ТекстЗаголовка)) <> ТекстЗаголовка Тогда
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;
	
	РегНомерПФРИзФайла = Сред(ПерваяСтрока, СтрДлина(ТекстЗаголовка) + 1, 12);
	
	РегНомерИзФайлаФорматированный = Лев(РегНомерПФРИзФайла, 3) + "-" + Сред(РегНомерПФРИзФайла, 4, 3) + "-" + Сред(РегНомерПФРИзФайла, 7);
	
	РегНомерОрганизации = ПерсонифицированныйУчет.РегистрационныйНомерПФР(Организация);
	
	РегНомерОрганизации = ?(РегНомерОрганизации = Неопределено, "", РегНомерОрганизации);
	
	Если РегНомерОрганизации <> РегНомерИзФайлаФорматированный Тогда
		ТекстИсключения = НСтр("ru = 'Регистрационный номер ПФР указанный в файле (%1) и регистрационный номер ПФР указанный для организации (%2)  не совпадают.'");
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения, РегНомерИзФайлаФорматированный, РегНомерОрганизации);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;	
	
	ОтчетныйПериодИзФайла = ОтчетныйПериодИзЗаголовкаФайла(ПерваяСтрока, ТекстЗаголовка);
	
	СледующийПериод = ПерсонифицированныйУчетКлиентСервер.СледующийОтчетныйПериод(ОтчетныйПериодИзФайла);
	
	Если СледующийПериод <> ОтчетныйПериод Тогда
		ТекстИсключения = НСтр("ru = 'Данные файла приведены на начало %1.'");
		ПредставлениеПериодаФайла = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(СледующийПериод);
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения, ПредставлениеПериодаФайла);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;	
	
	СтрокаКолонок = ДанныеФайла.ПолучитьСтроку(2);
	
	Колонки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаКолонок, ";");
	
	Если Не ПроверитьИменованиеКолонок(Колонки) Тогда
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Функция ОтчетныйПериодИзЗаголовкаФайла(ПерваяСтрока, ТекстЗаголовка)
	ОтчетныйПериодИзФайлаСтрокой = Сред(ПерваяСтрока, СтрДлина(ТекстЗаголовка) + 14, 6);
	
	ЧастиПериода = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОтчетныйПериодИзФайлаСтрокой, "-");
	
	Если ЧастиПериода.Количество() <> 2 Тогда
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;	
	
	Попытка 
		Квартал = Число(ЧастиПериода[0]);
		Год = Число(ЧастиПериода[1]);
		Месяц = Квартал * 3 - 2;
		
		Возврат Дата(Год, Месяц, 1);
	Исключение
		ВызватьИсключениеНеверныйФорматФайла();
	КонецПопытки;		
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуТаблицуЗадолженности(СтрокаДанных, СоответствиеСНИЛСФизическимЛицам, СтрокиПоСотрудникам)
	ЗначенияКолонокВСтроке = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДанных, ";");
	
	ЕстьЗаполненныеЗначения = Ложь;
	Для Каждого Значение Из ЗначенияКолонокВСтроке Цикл
		Если Не ПустаяСтрока(Значение) Тогда
			ЕстьЗаполненныеЗначения = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьЗаполненныеЗначения Тогда
		Возврат;
	КонецЕсли;	
	
	Если ЗначенияКолонокВСтроке.Количество() <> 18 Тогда
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;
	
	Попытка
		СНИЛС = СНИЛСИзСтрокиФайла(ЗначенияКолонокВСтроке);
		
		ФизическоеЛицо = СоответствиеСНИЛСФизическимЛицам.Получить(СНИЛС);
		
		Если ФизическоеЛицо = Неопределено Тогда
			ТекстСообщения = НСтр("ru = '%1 (СНИЛС: %2) отсутствует в справочнике ""Физические лица"".'");
			
			Фамиля = ЗначенияКолонокВСтроке[4];
			Имя = ЗначенияКолонокВСтроке[5];
			Отчество = ЗначенияКолонокВСтроке[6];
			
			ФИО = Фамиля + " " + Имя + ?(ПустаяСтрока(Отчество), "", " ") + Отчество;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФИО, СНИЛС);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			Возврат;
		КонецЕсли;	
		
		СтрокаТаблицыФормы = СтрокиПоСотрудникам.Получить(ФизическоеЛицо);
		
		Если СтрокаТаблицыФормы = Неопределено Тогда
			СтрокаТаблицыФормы = СведенияОВзносах.Добавить();
			СтрокаТаблицыФормы.ФиксСтрока = Истина;
		КонецЕсли;	

		СтрокаТаблицыФормы.ФизическоеЛицо = ФизическоеЛицо;
		
		ЗадолженностьПоСтраховойЧастиСтрокой = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(" ", ЗначенияКолонокВСтроке[11], "");
		ЗадолженностьПоСтраховойЧастиСтрокой = ?(ЗадолженностьПоСтраховойЧастиСтрокой = "", "0", ЗадолженностьПоСтраховойЧастиСтрокой);
		
		ЗадолженностьПоНакопительнойЧасти = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(" ", ЗначенияКолонокВСтроке[12], "");
		ЗадолженностьПоНакопительнойЧасти = ?(ЗадолженностьПоНакопительнойЧасти = "", "0", ЗадолженностьПоНакопительнойЧасти);
		
		НачисленоСтраховаяСтрокой = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(" ", ЗначенияКолонокВСтроке[7], "");
		НачисленоСтраховаяСтрокой = ?(НачисленоСтраховаяСтрокой = "", "0", НачисленоСтраховаяСтрокой);
		
		НачисленоНакопительнаяСтрокой = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(" ", ЗначенияКолонокВСтроке[9], "");
		НачисленоНакопительнаяСтрокой = ?(НачисленоНакопительнаяСтрокой = "", "0", НачисленоНакопительнаяСтрокой);
		
		УплаченоСтраховаяСтрокой = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(" ", ЗначенияКолонокВСтроке[8], "");
		УплаченоСтраховаяСтрокой = ?(УплаченоСтраховаяСтрокой = "", "0", УплаченоСтраховаяСтрокой);
		
		УплаченоНакопительнаяСтрокой = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(" ", ЗначенияКолонокВСтроке[10], "");
		УплаченоНакопительнаяСтрокой = ?(УплаченоНакопительнаяСтрокой = "", "0", УплаченоНакопительнаяСтрокой);

		СтрокаТаблицыФормы.ЗадолженностьПоСтраховойЧасти = -Число(ЗадолженностьПоСтраховойЧастиСтрокой);
		СтрокаТаблицыФормы.ЗадолженностьПоНакопительнойЧасти = -Число(ЗадолженностьПоНакопительнойЧасти);
		СтрокаТаблицыФормы.НачисленоСтраховая = Число(НачисленоСтраховаяСтрокой);
		СтрокаТаблицыФормы.НачисленоНакопительная = Число(НачисленоНакопительнаяСтрокой);
		СтрокаТаблицыФормы.УплаченоСтраховая = Число(УплаченоСтраховаяСтрокой);
		СтрокаТаблицыФормы.УплаченоНакопительная = Число(УплаченоНакопительнаяСтрокой);
		СтрокаТаблицыФормы.ФиксВзносы = Истина;
		
		ЕстьКорректировки = Истина;
	Исключение
		ВызватьИсключениеНеверныйФорматФайла();	
	КонецПопытки;	
	
КонецПроцедуры	

&НаСервере
Функция СНИЛСИзСтрокиФайла(ЗначенияКолонокВСтроке)
	ПерваяЧастьСНИЛС = ЗначенияКолонокВСтроке[2];
	
	ДлинаСтроки = СтрДлина(ПерваяЧастьСНИЛС);
	
	Если ДлинаСтроки > 9 Тогда
		ВызватьИсключениеНеверныйФорматФайла();
	КонецЕсли;	
	
	Для Сч = 1 По 9 - ДлинаСтроки Цикл
		ПерваяЧастьСНИЛС = "0" + ПерваяЧастьСНИЛС; 	
	КонецЦикла;	
	
	СНИЛС = Сред(ПерваяЧастьСНИЛС, 1, 3) + "-" + Сред(ПерваяЧастьСНИЛС, 4, 3) + "-" + Сред(ПерваяЧастьСНИЛС, 7, 3);
	
	ВтораяЧастьСНИЛС = ЗначенияКолонокВСтроке[3];
	
	СНИЛС = СНИЛС + " " + ?(СтрДлина(ВтораяЧастьСНИЛС) = 1, "0" + ВтораяЧастьСНИЛС, ВтораяЧастьСНИЛС);
	
	Возврат СНИЛС;
	
КонецФункции	

&НаСервере
Функция СоответствиеСНИЛСФизическимЛицам(СписокСНИЛС)	
	СоответствиеСНИЛСФизическимЛицам = Новый Соответствие;
	
	Запрос = Новый Запрос;		
	Запрос.УстановитьПараметр("СписокСНИЛС", СписокСНИЛС);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка,
	|	ФизическиеЛица.СтраховойНомерПФР
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.СтраховойНомерПФР В(&СписокСНИЛС)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СоответствиеСНИЛСФизическимЛицам.Вставить(Выборка.СтраховойНомерПФР, Выборка.Ссылка);		
	КонецЦикла;	
	                                   
	Возврат СоответствиеСНИЛСФизическимЛицам;
КонецФункции	

&НаСервере
Функция ПроверитьИменованиеКолонок(Колонки)
	Если Колонки.Количество() <> 18 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Колонки[2] <> "страхномер" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Колонки[3] <> "кс" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Колонки[4] <> "фамилия" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Колонки[5] <> "имя" Тогда
		Возврат Ложь;
	КонецЕсли;

	Если Колонки[6] <> "отчество" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Колонки[7] <> "начислено сч" Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Если Колонки[8] <> "уплачено сч" Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Если Колонки[9] <> "начислено нч" Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Если Колонки[10] <> "уплачено нч" Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Если Колонки[11] <> "разница усч нсч" Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Если Колонки[12] <> "разница унч ннч" Тогда
		Возврат Ложь;
	КонецЕсли;	

	Возврат Истина;
КонецФункции	

&НаСервере
Процедура ВызватьИсключениеНеверныйФорматФайла()
	ТекстИсключения = НСтр("ru = 'Загрузка сведений о взносах в ПФР из файлов данного формата не поддерживается.'");
	ВызватьИсключение ТекстИсключения; 	
КонецПроцедуры	

СтарыеЗначенияКонтролируемыхПолей = Новый Структура;

#КонецОбласти

#КонецОбласти
