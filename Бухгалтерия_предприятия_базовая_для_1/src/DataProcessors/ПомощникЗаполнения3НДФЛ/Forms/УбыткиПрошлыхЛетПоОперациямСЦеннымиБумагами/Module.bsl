
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период = Параметры.Период;
	Декларация3НДФЛВыбраннаяФорма = Параметры.Декларация3НДФЛВыбраннаяФорма;
	АдресКлючейПоказателей = Параметры.АдресКлючейПоказателей;
	
	Если Параметры.ЕстьДоходыПоИИС Или Не Параметры.ЕстьДоходыПоИнымОперациям Тогда
		ВидИнвестиционногоСчета = "ИндивидуальныйИнвестиционныйСчет";
	Иначе
		ВидИнвестиционногоСчета = "ПрочиеСчета";
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов)
		И Параметры.СтруктураДоходовВычетов.Свойство("ДанныеФормы")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов.ДанныеФормы) Тогда
		ЗаполнитьФормуИзДанных(Параметры.СтруктураДоходовВычетов.ДанныеФормы);
	Иначе
		ЗаполнитьНовуюФорму();
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	УстановитьКлючСохраненияПоложенияОкна();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ (ЗначениеЗаполнено(ОстатокУбыткаЦБ) Или ЗначениеЗаполнено(ОстатокУбыткаПФИ)) Тогда
		ТекстОшибки = НСтр("ru = 'Заполните сумму убытка по ценным бумагам или ПФИ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ОстатокУбыткаЦБ", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидИнвестиционногоСчетаПриИзменении(Элемент)
	
	ГодУбытка = ГодУбыткаПоУмолчанию(Период, ВидИнвестиционногоСчета);
	ЗаполнитьСписокЛетСУбытками(Элементы.ГодУбытка.СписокВыбора, ВидИнвестиционногоСчета, Период);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодУбыткаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = СохранитьРезультаты();
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ДетализироватьУбыткиПоГодам = ЕстьКлючПоказателя("ЦБУбыткиПрошлыхЛетГод1", Форма.АдресКлючейПоказателей);
	ПредыдущийГод = Год(Форма.Период) - 1;
	
	Элементы.ГодУбытка.Видимость = ДетализироватьУбыткиПоГодам;
	
	Если Форма.ГодУбытка = ПредыдущийГод Или Не ДетализироватьУбыткиПоГодам Тогда
		Элементы.ПодсказкаКОстаткам.Видимость = Ложь;
		Элементы.ОстатокУбыткаЦБ.Заголовок = НСтр("ru = 'Убыток по ценным бумагам'");
		Элементы.ОстатокУбыткаПФИ.Заголовок = НСтр("ru = 'Убыток по операциям с ПФИ'");
	ИначеЕсли ЗначениеЗаполнено(Форма.ГодУбытка) Тогда
		Элементы.ПодсказкаКОстаткам.Видимость = Истина;
		Элементы.ПодсказкаКОстаткам.Заголовок = ЗаголовокПодсказкиКОстаткам(Форма.Период, Форма.ГодУбытка);
		Элементы.ОстатокУбыткаЦБ.Заголовок = НСтр("ru = 'По ценным бумагам'");
		Элементы.ОстатокУбыткаПФИ.Заголовок = НСтр("ru = 'По ПФИ'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокПодсказкиКОстаткам(ОтчетныйПериод, ГодУбытка)
	
	ПредыдущийГод = Год(ОтчетныйПериод) - 1;
	ПервыйОтчетныйГодПослеУбытка = ГодУбытка + 1;
	
	КоличествоДеклараций = ПредыдущийГод - ПервыйОтчетныйГодПослеУбытка + 1;
	
	Если КоличествоДеклараций = 1 Тогда
		ТекстПодсказки = СтрШаблон(
			НСтр("ru = 'Сумма убытка, не учтенная в декларации за %1 год:'"),
			Формат(ПредыдущийГод, "ЧГ=0"));
	Иначе
		ТекстПодсказки = СтрШаблон(
			НСтр("ru = 'Сумма убытка, не учтенная в декларациях за %1-%2 годы:'"),
			Формат(ПервыйОтчетныйГодПослеУбытка, "ЧГ=0"),
			Формат(ПредыдущийГод, "ЧГ=0"));
	КонецЕсли;
	
	Возврат ТекстПодсказки;
	
КонецФункции

&НаСервере
Процедура УстановитьКлючСохраненияПоложенияОкна()
	
	СуффиксПодсказка = ?(Элементы.ПодсказкаКОстаткам.Видимость, "СПодсказкойКОстаткам", "");
	
	КлючСохраненияПоложенияОкна = ВидИнвестиционногоСчета + СуффиксПодсказка;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокЛетСУбытками(СписокВыбора, ВидИнвестиционногоСчета, ОтчетныйПериод)
	
	СписокВыбора.Очистить();
	
	ГодУбытка = Год(ОтчетныйПериод) - 1;
	Пока ГодУбытка >= ПервыйГодКогдаМожноЗачестьУбытки(ОтчетныйПериод, ВидИнвестиционногоСчета) Цикл
		СписокВыбора.Добавить(ГодУбытка, Формат(ГодУбытка, "ЧГ=0"));
		ГодУбытка = ГодУбытка - 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзДанных(ДанныеФормы)
	
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Свойство(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	Если ДанныеФормы.Свойство("ВидОперации") Тогда
		Если ДанныеФормы.ВидОперации = "ОперацииПоИИС" Тогда
			ВидИнвестиционногоСчета = "ИндивидуальныйИнвестиционныйСчет";
		Иначе
			ВидИнвестиционногоСчета = "ПрочиеСчета";
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокЛетСУбытками(Элементы.ГодУбытка.СписокВыбора, ВидИнвестиционногоСчета, Период);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовуюФорму()
	
	ГодУбытка = ГодУбыткаПоУмолчанию(Период, ВидИнвестиционногоСчета);
	ЗаполнитьСписокЛетСУбытками(Элементы.ГодУбытка.СписокВыбора, ВидИнвестиционногоСчета, Период);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПервыйГодКогдаМожноЗачестьУбытки(ОтчетныйПериод, ВидИнвестиционногоСчета)
	
	ГодОтчетногоПериода = Год(ОтчетныйПериод);
	
	// Можно зачесть убытки за последние 10 лет, но не ранее ГодНачалаДействияВычета.
	Возврат Макс(ГодНачалаДействияВычета(ВидИнвестиционногоСчета), ГодОтчетногоПериода - 10);
	
КонецФункции

&НаСервереБезКонтекста
Функция ГодНачалаДействияВычета(ВидИнвестиционногоСчета)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.ГодНачалаДействияВычетаУбыткиПрошлыхЛетПоЦеннымБумагам(ВидИнвестиционногоСчета);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ГодУбыткаПоУмолчанию(ОтчетныйПериод, ВидИнвестиционногоСчета)
	
	ГодУбыткаПоУмолчанию = Год(ОтчетныйПериод) - 1;
	
	Возврат Макс(ГодУбыткаПоУмолчанию, ПервыйГодКогдаМожноЗачестьУбытки(ОтчетныйПериод, ВидИнвестиционногоСчета));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МассивРеквизитовФормы()
	
	Массив = Новый Массив;
	Массив.Добавить("ВидИнвестиционногоСчета");
	Массив.Добавить("ГодУбытка");
	Массив.Добавить("ОстатокУбыткаПФИ");
	Массив.Добавить("ОстатокУбыткаЦБ");
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Функция СохранитьРезультаты()
	
	СтруктураРезультата = Новый Структура;
	
	Если ВидИнвестиционногоСчета = "ИндивидуальныйИнвестиционныйСчет" Тогда
		Информация = СтрШаблон(
			НСтр("ru = 'Убыток за %1 год по ценным бумагам и ПФИ (ИИС)'"),
			Формат(ГодУбытка, "ЧГ=0"));
	Иначе
		Информация = СтрШаблон(
			НСтр("ru = 'Убыток за %1 год по ценным бумагам и ПФИ (прочие счета)'"),
			Формат(ГодУбытка, "ЧГ=0"));
	КонецЕсли;
	
	// Информация для формы помощника.
	СтруктураРезультата.Вставить("Вид", 
		ПредопределенноеЗначение("Перечисление.ВычетыФизическихЛиц.УбыткиПрошлыхЛетПоОперациямСЦеннымиБумагами"));
	
	СтруктураРезультата.Вставить("Информация",  Информация);
	СтруктураРезультата.Вставить("СуммаВычета", ОстатокУбыткаЦБ + ОстатокУбыткаПФИ);
	
	// Данные формы для восстановления.
	СтруктураРезультата.Вставить("ДанныеФормы", СохранитьДанныеФормы());
	
	// Данные для отчетности.
	СтруктураРезультата.Вставить("ДанныеДекларации", СохранитьДанныеДекларации());
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаСервере
Функция СохранитьДанныеФормы()
	
	ДанныеФормы = Новый Структура;
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	Возврат ДанныеФормы;
	
КонецФункции

&НаСервере
Функция СохранитьДанныеДекларации()
	
	ВидыИнвестиционныхСчетов = Отчеты.РегламентированныйОтчет3НДФЛ.ВидыИнвестиционныхСчетов();
	
	ДанныеДекларации = Новый Структура;
	ДанныеДекларации.Вставить("ВидСчета",        ВидыИнвестиционныхСчетов[ВидИнвестиционногоСчета]);
	ДанныеДекларации.Вставить("ГодУбытка",       ГодУбытка);
	ДанныеДекларации.Вставить("УбытокЦБ",        ОстатокУбыткаЦБ);
	ДанныеДекларации.Вставить("УбытокПФИ",       ОстатокУбыткаПФИ);
	
	Возврат ДанныеДекларации;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьКлючПоказателя(Знач ИмяКлюча, Знач АдресКлючейПоказателей)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.ЕстьКлючПоказателя(ИмяКлюча, АдресКлючейПоказателей);
	
КонецФункции

#КонецОбласти
