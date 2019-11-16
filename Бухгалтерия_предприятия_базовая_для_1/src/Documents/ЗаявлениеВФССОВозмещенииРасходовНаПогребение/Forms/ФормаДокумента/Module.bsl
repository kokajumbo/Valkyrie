#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере("Объект");
		
		ОрганизацияПриИзмененииНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект);
	ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияОбновитьФиксациюВФорме();
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗаявлениеВФССОВозмещенииРасходовНаПогребение", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПредставлениеАдресаОрганизацииЗавершениеВыбора", ЭтотОбъект);
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации"),
		Объект.АдресОрганизации);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОрганизацииЗавершениеВыбора(СтруктураАдреса, ПараметрыОповещения) Экспорт 
	Если ТипЗнч(СтруктураАдреса) = Тип("Структура")Тогда
		Объект.АдресОрганизации = СтруктураАдреса.КонтактнаяИнформация;
		ФиксацияЗафиксироватьИзменениеРеквизита("АдресОрганизации");
		ОбновитьПоляВводаКонтактнойИнформации();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаСоставителяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПредставлениеТелефонаСоставителяЗавершениеВыбора", ЭтотОбъект);
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонОрганизации"),
		Объект.ТелефонСоставителя);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаСоставителяЗавершениеВыбора(СтруктураТелефона, ПараметрыОповещения) Экспорт 
	Если ТипЗнч(СтруктураТелефона) = Тип("Структура") Тогда
		Объект.ТелефонСоставителя = СтруктураТелефона.КонтактнаяИнформация;
		ФиксацияЗафиксироватьИзменениеРеквизита("ТелефонСоставителя");
		ОбновитьПоляВводаКонтактнойИнформации();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыОрганизацииПриИзменении(Элемент)
	ФиксацияЗафиксироватьИзменениеРеквизита("АдресЭлектроннойПочтыОрганизации");
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыОплаты

&НаКлиенте
Процедура ОплатыПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьОтображениеПредупрежденийТЧ_Оплаты", 0.2, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыФизическоеЛицоПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "ФизическоеЛицо", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыРазмерПособияПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "РазмерПособия", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыКоличествоСтраницПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "КоличествоСтраниц", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыДокументОснованиеПриИзменении(Элемент)
	ОплатыДокументОснованиеПриИзмененииНаСервере(Элементы.Оплаты.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.УстановитьФиксациюИзмененийГруппыРеквизитов(ЭтотОбъект, "Оплаты",  Элементы.Оплаты.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаполнитьОплаты(Команда)
	ЗаполнитьДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВторичныеДанные(Команда)
	ОбновитьВторичныеДанныеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда) 
	ОтменитьВсеИсправленияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПояснениеНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

&НаСервере
Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ИменаСлужебныхРеквизитов = ФиксацияВторичныхДанныхВДокументахКлиентСервер.ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных();
	
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтотОбъект, МассивИменРеквизитовФормы);
	
	Если МассивИменРеквизитовФормы.Найти(ИменаСлужебныхРеквизитов["ПараметрыФиксацииВторичныхДанных"]) = Неопределено Тогда
		ПараметрыФиксации = Документы.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ПараметрыФиксацииВторичныхДанных();
		ПараметрыФиксации.Вставить("ОписаниеФормы", ФиксацияОписаниеФормы(ПараметрыФиксации));
	Иначе	
		ПараметрыФиксации = ЭтотОбъект[ИменаСлужебныхРеквизитов["ПараметрыФиксацииВторичныхДанных"]];
	КонецЕсли;
	
	Возврат ПараметрыФиксации;
	
КонецФункции

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	ОписаниеЭлементаФормы.ПрефиксПутиТекущиеДанные = "Элементы.Оплаты.ТекущиеДанные";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	// Т.к. адреса редактируется через рек-т формы, укажем ему особые пути к данным.
	ПустоеОписаниеЭлементовФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеЭлементовФормы.Вставить("ПредставлениеАдресаОрганизации", ПустоеОписаниеЭлементовФормы);
	ОписаниеЭлементовФормы.Вставить("ПредставлениеТелефонаСоставителя", ПустоеОписаниеЭлементовФормы);
	
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	ОписаниеФормы.Вставить("ФормаРедактируетсяПослеФиксации", Ложь);
	Возврат ОписаниеФормы;
КонецФункции

&НаСервере
Функция ФиксацияБыстрыйПоискРеквизитов()
	БыстрыйПоискРеквизитов = Новый Соответствие; // Ключ - имя элемента, значение - имя реквизита.
	ПараметрыФиксации = ЭтотОбъект["ПараметрыФиксацииВторичныхДанных"];
	Для Каждого КлючИЗначение Из ПараметрыФиксации.ОписаниеФиксацииРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Значение.ИмяРеквизита;
		// Поиск элементов по имени.
		Если Элементы.Найти(ИмяРеквизита) <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить(ИмяРеквизита, ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	Возврат БыстрыйПоискРеквизитов;
КонецФункции

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	
	ИменаСлужебныхРеквизитов = ФиксацияВторичныхДанныхВДокументахКлиентСервер.ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных();

	ОписанияТЧ = Форма[ИменаСлужебныхРеквизитов["ПараметрыФиксацииВторичныхДанных"]]["ОписанияТЧ"];
	
	Для каждого ОписаниеТЧ Из ОписанияТЧ Цикл
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыФиксТЧ(Форма.Объект[ОписаниеТЧ.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
	
КонецФункции

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	 ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеЗаявлений = Истина, МассивПервичныхДокументов = Неопределено)
	
	Если ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = ФиксацияПодготовленныйДокумент();
	
	Если ДокументОбъект.ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации, ДанныеЗаявлений, МассивПервичныхДокументов) Тогда
		Если НЕ ДокументОбъект.ЭтоНовый() Тогда
			ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);	
		КонецЕсли;
		ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
		ОбновитьПоляВводаКонтактнойИнформации();
	КонецЕсли;	
	
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	
	ПодписиДокументовКлиентСервер.УстановитьПредставлениеПодписей(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтаФорма, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	ИдентификаторСтроки = Элементы.Оплаты.ТекущаяСтрока;
	ОписаниеЭлементов = ФиксацияБыстрыйПоискРеквизитов();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтотОбъект, Элемент, ОписаниеЭлементов, ИдентификаторСтроки);
КонецПроцедуры

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ОбъектЗафиксирован();
	
КонецФункции 

&НаКлиенте
Процедура ОбновитьОтображениеПредупрежденийТЧ_Оплаты()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьОтображениеПредупрежденийТЧ(ЭтотОбъект, "Оплаты", Элементы.Оплаты.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ФиксацияЗафиксироватьИзменениеРеквизита(ИмяРеквизита, ТекущаяСтрока = 0)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, ИмяРеквизита, ТекущаяСтрока)
КонецПроцедуры

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Оплаты");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	НСтр("ru = 'организации'")));
	Возврат Массив
КонецФункции

#КонецОбласти 

#Область ПодписиДокументов

// ЗарплатаКадрыПодсистемы.ПодписиДокументов
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент)
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
	Если Элемент.Имя = ПодписиДокументовКлиентСервер.ИмяЭлементаФормыПоРолиПодписанта("Руководитель") Тогда
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "Руководитель");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент)
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтаФорма, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияБыстрыйПоискРеквизитов());
	
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	
	НастроитьФорму();
	
	ОбновитьПоляВводаКонтактнойИнформации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокумент()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьДокумент();
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПоляВводаКонтактнойИнформации()
	УправлениеКонтактнойИнформациейЗарплатаКадры.ОбновитьПолеВводаКонтактнойИнформации(
		ЭтотОбъект,
		"ПредставлениеАдресаОрганизации",
		Объект.АдресОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	УправлениеКонтактнойИнформациейЗарплатаКадры.ОбновитьПолеВводаКонтактнойИнформации(
		ЭтотОбъект,
		"ПредставлениеТелефонаСоставителя",
		Объект.ТелефонСоставителя,
		Перечисления.ТипыКонтактнойИнформации.Телефон);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуСведений(Идентификатор)
	ТекущаяСтрока = Объект.Оплаты.НайтиПоИдентификатору(Идентификатор);
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ДокументОснование) Тогда 
		ДанныеСтроки = ДанныеСтроки(ТекущаяСтрока.ДокументОснование);
		Если ЗначениеЗаполнено(ДанныеСтроки) Тогда
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеСтроки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДанныеСтроки(Ссылка)
	
	Документ = РеквизитФормыВЗначение("Объект");
	
	Возврат Документ.ДанныеСтроки(Ссылка);
	
КонецФункции

&НаСервере
Процедура ОплатыДокументОснованиеПриИзмененииНаСервере(Идентификатор)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "ДокументОснование", Идентификатор);
	ЗаполнитьСтрокуСведений(Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьОтображениеПредупрежденийТЧ(ЭтотОбъект, "Оплаты", Элементы.Оплаты.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	УстановитьВидимостьЭлементовЗаполненияДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовЗаполненияДокумента()
	
	ИспользуетсяЗаполнениеДокумента = ПрямыеВыплатыПособийСоциальногоСтрахования.ИспользуетсяЗаполнениеЗаявленияВФССОВозмещенииРасходовНаПогребение();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОплатыЗаполнить", "Видимость", ИспользуетсяЗаполнениеДокумента);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОплатыДокументОснование", "Видимость", ИспользуетсяЗаполнениеДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтаФорма, "Организация");
	ОбновитьВторичныеДанныеДокумента(Истина, Ложь);
	ФиксацияОбновитьФиксациюВФорме();
КонецПроцедуры

#КонецОбласти

