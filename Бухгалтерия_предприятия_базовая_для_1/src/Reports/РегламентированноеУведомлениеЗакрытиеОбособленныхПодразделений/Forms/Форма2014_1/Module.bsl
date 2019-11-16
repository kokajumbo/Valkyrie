&НаКлиенте
Перем UID_Пустой;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Разделы.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	UID_Пустой = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЗначениеКопирования = Неопределено;
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	
	Если Не Параметры.Свойство("Ключ") Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			Объект.РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Сообщение по форме С-09-3-2 можно создавать только для организаций");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	ЗагрузитьДанные(ЗначениеКопирования);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМакетыУведомления(ЭтотОбъект, Объект.ИмяОтчета, "ПараметрыФорма2014_1");
	СформироватьДерево();
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;

	СтруктураПараметров = Новый Структура("Титульный, ДопЛисты",
									ТитульнаяСтраница.Выгрузить(),
									ДопЛисты.Выгрузить());
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");

КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(ЗначениеКопирования)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СсылкаНаДанные = Объект.Ссылка;
	ИначеЕсли ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		Объект.Организация = ЗначениеКопирования.Организация;
		СсылкаНаДанные = ЗначениеКопирования;
	Иначе 
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = СсылкаНаДанные.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.Титульный;
	НоваяСтрока = ТитульнаяСтраница.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Титульный[0]);
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Листы = СтруктураПараметров.ДопЛисты;
	Для Каждого Строка Из Листы Цикл
		НоваяСтрока = ДопЛисты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	Если ТитульнаяСтраница[0].КОЛИЧЕСТВО_СТРАНИЦ =0 Тогда
		ТитульнаяСтраница[0].КОЛИЧЕСТВО_СТРАНИЦ = 1 + ДопЛисты.Количество();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДерево()
	КорневойУровень = Разделы.ПолучитьЭлементы();
	Если ТитульнаяСтраница.Количество() = 0 Тогда
		НовыйЛист = ТитульнаяСтраница.Добавить();
		ЗаполнитьТитульный(НовыйЛист);
	КонецЕсли;
	Титульный = КорневойУровень.Добавить();
	Титульный.Наименование = "Титульный лист";
	Титульный.ИндексКартинки = 1;
	Титульный.ТипСтраницы = 1;
	Титульный.UID = ТитульнаяСтраница[0].UID;
	
	Листы = КорневойУровень.Добавить();
	Листы.Наименование = "Сведения об обособленном" + Символы.ПС + "подразделении";
	СписокЛистов = Листы.ПолучитьЭлементы();
	
	Если ДопЛисты.Количество() = 0 Тогда
		НовыйЛист = ДопЛисты.Добавить();
		ЗаполнитьДопЛист(НовыйЛист);
	КонецЕсли;
	
	Номер = 1;
	Для Каждого ДопЛист Из ДопЛисты Цикл 
		Лист = СписокЛистов.Добавить();
		Лист.ИндексКартинки = 1;
		Лист.ТипСтраницы = 2;
		Лист.Наименование = "Стр. " + Номер;
		Лист.UID = ДопЛист.UID;
		Номер = Номер + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТитульный(НовыйЛист)
	
	НовыйЛист.ДАТА_ПОДПИСИ = ТекущаяДатаСеанса(); 
	Объект.ДатаПодписи = НовыйЛист.ДАТА_ПОДПИСИ;
	
	СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации,ОГРН";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	
	НовыйЛист.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ = СведенияОбОрганизации.НаимЮЛПол;
	НовыйЛист.ОГРН = СведенияОбОрганизации.ОГРН;
	НовыйЛист.КОД_НО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
	НовыйЛист.П_ИНН = СведенияОбОрганизации.ИННЮЛ;
	НовыйЛист.П_КПП = СведенияОбОрганизации.КППЮЛ;
	НовыйЛист.ТЕЛЕФОН = СведенияОбОрганизации.ТелОрганизации;
	
	УстановитьДанныеПоРегистрацииВИФНС();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДопЛист(НовыйЛист)
	НовыйЛист.П_ИНН_Д = ТитульнаяСтраница[0].П_ИНН;
	НовыйЛист.П_КПП_Д = ТитульнаяСтраница[0].П_КПП;
	НовыйЛист.UID = Новый УникальныйИдентификатор;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопок()
	Если Элементы.Разделы.ТекущиеДанные = Неопределено Тогда 
		ТипСтраницы = Неопределено;
	Иначе 
		ТипСтраницы = Элементы.Разделы.ТекущиеДанные.ТипСтраницы;
	КонецЕсли;
	
	КМенюРО = Элементы.Разделы.КонтекстноеМеню;
	Если ТипСтраницы = 2 Тогда
		КМенюРО.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыКонтекстноеМенюДобавитьСтраницу.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыКонтекстноеМенюУдалитьСтраницу.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыКонтекстноеМенюДобавитьСтраницу.Доступность = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыКонтекстноеМенюУдалитьСтраницу.Доступность = (ДопЛисты.Количество() > 1);
	Иначе
		КМенюРО.Видимость = Ложь;
		КМенюРО.ПодчиненныеЭлементы.РазделыКонтекстноеМенюДобавитьСтраницу.Видимость = Ложь;
		КМенюРО.ПодчиненныеЭлементы.РазделыКонтекстноеМенюУдалитьСтраницу.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьМакетНаСервере()
	Документы.УведомлениеОСпецрежимахНалогообложения.СформироватьМакетОтчетаНаСервере(ЭтотОбъект, Объект.ИмяОтчета, "Форма2014_1", ПолучитьИмяОбласти(ТекущийТипСтраницы), ПолучитьИмяТаблицы(ТекущийТипСтраницы));
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяОбласти(ТекущийТипСтраницы)
	Если ТекущийТипСтраницы = 1 Тогда
		Возврат "Титульная";
	ИначеЕсли ТекущийТипСтраницы = 2 Тогда
		Возврат "ДопЛист";
	КонецЕсли;
	
	Возврат "";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяТаблицы(ТекущийТипСтраницы)
	Если ТекущийТипСтраницы = 1 Тогда
		Возврат "ТитульнаяСтраница";
	ИначеЕсли ТекущийТипСтраницы = 2 Тогда
		Возврат "ДопЛисты";
	КонецЕсли;
	
	Возврат "";
КонецФункции

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура НестандартнаяОбработка(Инфо, Элемент)
	Если Инфо.Обработчик = "ОбработкаСписка" Тогда
		ОбработкаСписка(Инфо);
	ИначеЕсли Инфо.Обработчик = "ОбработкаКодаНО" Тогда
		ОбработкаКодаНО(Инфо);
	ИначеЕсли Инфо.Обработчик = "ОбработкаАдреса" Тогда
		ОбработкаАдреса(Инфо, Элемент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегионыНаСервере()
	
	РегламентированнаяОтчетность.ЗаполнитьРегионы(Регионы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАдреса(Инфо, Элемент)
	РоссийскийАдрес = Новый Соответствие;
	
	РоссийскийАдрес.Вставить("Индекс",	        ПредставлениеУведомления.Области["ИНДЕКС"].Значение);
	РоссийскийАдрес.Вставить("КодРегиона",      ПредставлениеУведомления.Области["КОД_РЕГИОНА"].Значение);
	РоссийскийАдрес.Вставить("Район",           ПредставлениеУведомления.Области["РАЙОН"].Значение);
	РоссийскийАдрес.Вставить("Город",           ПредставлениеУведомления.Области["ГОРОД"].Значение);
	РоссийскийАдрес.Вставить("НаселенныйПункт", ПредставлениеУведомления.Области["НАСЕЛЕННЫЙ_ПУНКТ"].Значение);
	РоссийскийАдрес.Вставить("Улица",           ПредставлениеУведомления.Области["УЛИЦА"].Значение);
	РоссийскийАдрес.Вставить("Дом",             ПредставлениеУведомления.Области["ДОМ"].Значение);
	РоссийскийАдрес.Вставить("Корпус",          ПредставлениеУведомления.Области["КОРПУС"].Значение);
	РоссийскийАдрес.Вставить("Квартира",        ПредставлениеУведомления.Области["КВАРТИРА"].Значение);
	
	Если Регионы.Количество() = 0 Тогда
		ЗаполнитьРегионыНаСервере();
	КонецЕсли;
	
	Регион = Регионы.НайтиСтроки(Новый Структура("Код", СокрЛП(РоссийскийАдрес["КодРегиона"])));
	
	Если Регион.Количество() > 0 Тогда
		
		РоссийскийАдрес["Регион"] = Регион[0].Наим;
		
	КонецЕсли;
	
	ЗначенияПолей = Новый СписокЗначений;
	
	ЗначенияПолей.Добавить(РоссийскийАдрес["Индекс"],          "Индекс");
	ЗначенияПолей.Добавить(РоссийскийАдрес["КодРегиона"],      "КодРегиона");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Район"],           "Район");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Город"],           "Город");
	ЗначенияПолей.Добавить(РоссийскийАдрес["НаселенныйПункт"], "НаселенныйПункт");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Улица"],           "Улица");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Дом"],             "Дом");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Корпус"],          "Корпус");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Квартира"],        "Квартира");
	ЗначенияПолей.Добавить(РоссийскийАдрес["Регион"],          "Регион");
	
	ПредставлениеАдреса = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеАдресаВФормате9Запятых("643," + РоссийскийАдрес["Индекс"] + ","
	+ РоссийскийАдрес["Регион"] + ","
	+ РоссийскийАдрес["КодРегиона"] + ","
	+ РоссийскийАдрес["Район"] + ","
	+ РоссийскийАдрес["Город"] + ","
	+ РоссийскийАдрес["НаселенныйПункт"] + ","
	+ РоссийскийАдрес["Улица"] + ","
	+ РоссийскийАдрес["Дом"] + ","
	+ РоссийскийАдрес["Корпус"] + ","
	+ РоссийскийАдрес["Квартира"]);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",               "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", 		   ЗначенияПолей);
	ПараметрыФормы.Вставить("Представление", 		   ПредставлениеАдреса);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РоссийскийАдрес", РоссийскийАдрес);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтотОбъект;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	ОбновитьАдресВТабличномДокументе(Результат, Параметры.РоссийскийАдрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресВТабличномДокументе(Результат, РоссийскийАдрес)
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		// Обход ошибки платформы: в веб-клиенте, в результате выполнения процедуры "СформироватьАдрес"
		// общего модуля "РегламентированнаяОтчетностьВызовСервера", не изменяются значения ключей
		// соответствия "РоссийскийАдрес", передаваемого в качестве параметра.
		РоссийскийАдрес_ = РоссийскийАдрес;
		
		РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(Результат.КонтактнаяИнформация, РоссийскийАдрес_);
		
		ПредставлениеУведомления.Области["ИНДЕКС"].Значение = РоссийскийАдрес_["Индекс"];
		ПредставлениеУведомления.Области["КОД_РЕГИОНА"].Значение = РоссийскийАдрес_["КодРегиона"];
		ПредставлениеУведомления.Области["РАЙОН"].Значение = РоссийскийАдрес_["Район"];
		ПредставлениеУведомления.Области["ГОРОД"].Значение = РоссийскийАдрес_["Город"];
		ПредставлениеУведомления.Области["НАСЕЛЕННЫЙ_ПУНКТ"].Значение = РоссийскийАдрес_["НаселенныйПункт"];
		ПредставлениеУведомления.Области["УЛИЦА"].Значение = РоссийскийАдрес_["Улица"];
		ПредставлениеУведомления.Области["ДОМ"].Значение = РоссийскийАдрес_["Дом"];
		ПредставлениеУведомления.Области["КОРПУС"].Значение = РоссийскийАдрес_["Корпус"];
		ПредставлениеУведомления.Области["КВАРТИРА"].Значение = РоссийскийАдрес_["Квартира"];
		
		ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
		Данные = ЭтотОбъект[ПолучитьИмяТаблицы(ТекущийТипСтраницы)].НайтиСтроки(ПараметрыОтбора);
		Если Данные.Количество() > 0 Тогда
			СтрокаДанных = Данные[0];
			СтрокаДанных["ИНДЕКС"] = РоссийскийАдрес_["Индекс"];
			СтрокаДанных["КОД_РЕГИОНА"] = РоссийскийАдрес_["КодРегиона"];
			СтрокаДанных["РАЙОН"] = РоссийскийАдрес_["Район"];
			СтрокаДанных["ГОРОД"] = РоссийскийАдрес_["Город"];
			СтрокаДанных["НАСЕЛЕННЫЙ_ПУНКТ"] = РоссийскийАдрес_["НаселенныйПункт"];
			СтрокаДанных["УЛИЦА"] = РоссийскийАдрес_["Улица"];
			СтрокаДанных["ДОМ"] = РоссийскийАдрес_["Дом"];
			СтрокаДанных["КОРПУС"] = РоссийскийАдрес_["Корпус"];
			СтрокаДанных["КВАРТИРА"] = РоссийскийАдрес_["Квартира"];
		КонецЕсли;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСписка(Инфо)
	ИмяНестандартнойОбласти = Инфо.Имя;
	НазваниеСписка = Инфо.ИмяФормы;
	
	СтруктураОтбора = Новый Структура("ИмяСписка", Инфо.ИмяСписка);
	Строки = ТаблицаЗначенийПредопределенныхРеквизитов.НайтиСтроки(СтруктураОтбора);
	ЗагружаемыеКоды.Очистить();
	Для Каждого Строка Из Строки Цикл 
		НоваяСтрока = ЗагружаемыеКоды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НазваниеСписка);
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ЗагружаемыеКоды);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение));
	ДополнительныеПараметры = Новый Структура("ИмяНестандартнойОбласти", ИмяНестандартнойОбласти);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаСпискаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСпискаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ИмяНестандартнойОбласти = ДополнительныеПараметры.ИмяНестандартнойОбласти;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбластиДоп = "";
	РезультатВыбораКод = СокрЛП(РезультатВыбора.Код);
	Если 0 <> СтрНайти(ИмяНестандартнойОбласти, "Код_") Тогда
		ОбластьКоличество = СтрЗаменить(ИмяНестандартнойОбласти, "Код_", "Количество_");
		Если ЗначениеЗаполнено(РезультатВыбораКод) Тогда 
			ПредставлениеУведомления.Области[ОбластьКоличество].Защита = Ложь;
		Иначе
			ПредставлениеУведомления.Области[ОбластьКоличество].Значение = "";
			ИмяОбластиДоп = ОбластьКоличество;
			ПредставлениеУведомления.Области[ОбластьКоличество].Защита = Истина;
		КонецЕсли;
	ИначеЕсли ИмяНестандартнойОбласти = "КОД_ТС" Тогда
		ОбластьКоличество = СтрЗаменить(ИмяНестандартнойОбласти, "Код_", "Количество_");
		Если ЗначениеЗаполнено(РезультатВыбораКод) Тогда 
			ПредставлениеУведомления.Области["КОЛИЧЕСТВО_ТС"].Защита = Ложь;
		Иначе
			ПредставлениеУведомления.Области["КОЛИЧЕСТВО_ТС"].Значение = 0;
			ИмяОбластиДоп = "КОЛИЧЕСТВО_ТС";
			ПредставлениеУведомления.Области["КОЛИЧЕСТВО_ТС"].Защита = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение = РезультатВыбораКод;
	ИмяОбласти = ПолучитьИмяОбласти(ТекущийТипСтраницы);
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(ИмяНестандартнойОбласти, РезультатВыбораКод);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОбластиДоп) Тогда 
		СтруктураЗаписи = Новый Структура(ИмяОбластиДоп, "");
		Если Данные.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		ПредставлениеУведомления.Области[Инфо.Имя].Значение = КодНалоговогоОргана();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КодНалоговогоОргана()
	УстановитьДанныеПоРегистрацииВИФНС();
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
КонецФункции

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	
	Титульный = ТитульнаяСтраница[0];
	Организация = Объект.Организация;
	РегистрацияВИФНС = Объект.РегистрацияВИФНС;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВИФНС, "Представитель,КПП,ДокументПредставителя,Код");
	Титульный.КОД_НО = Реквизиты.Код;
	Титульный.П_КПП = Реквизиты.КПП;
	Для Каждого Лист Из ДопЛисты Цикл 
		Лист.П_КПП_Д = Реквизиты.КПП;
	КонецЦикла;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		ПризнакПодписанта = "4";
		Титульный.ПРИЗНАК_НП_ПОДВАЛ = "4";
		Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = Реквизиты.ДокументПредставителя;
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоФизЛицу(Объект, Реквизиты.Представитель, Титульный, "ИНН_ПОДПИСАНТА");
	Иначе
		УстановитьПредставителяПоОрганизации(Титульный);
		ПризнакПодписанта = "3";
		Титульный.ПРИЗНАК_НП_ПОДВАЛ = "3";
		Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = "";
	КонецЕсли;
	
	Если ТекущийТипСтраницы = 1 Тогда
		ПредставлениеУведомления.Область("П_КПП").Значение = Титульный.П_КПП;
		ПредставлениеУведомления.Область("ПРИЗНАК_НП_ПОДВАЛ").Значение = Титульный.ПРИЗНАК_НП_ПОДВАЛ;
		ПредставлениеУведомления.Область("ТЕЛЕФОН").Значение = Титульный.ТЕЛЕФОН;
		ПредставлениеУведомления.Область("ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ").Значение = Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ;
		ПредставлениеУведомления.Область("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ").Значение = Титульный.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ;
		ПредставлениеУведомления.Область("ИНН_ПОДПИСАНТА").Значение = Титульный.ИНН_ПОДПИСАНТА;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации(Титульный)
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	Титульный.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
КонецПроцедуры

&НаКлиенте
Процедура ПеренумероватьСтраницы()
	Листы = Разделы.ПолучитьЭлементы()[1].ПолучитьЭлементы();
	Номер = 1;
	Для Каждого Лист Из Листы Цикл 
		Лист.Наименование = "Стр. "+Номер;
		Номер = Номер + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	Если ТекущийТипСтраницы = 2 Тогда
		КорневойУровень = Разделы.ПолучитьЭлементы();
		СписокЛистов = КорневойУровень[1].ПолучитьЭлементы();
		НовыйЛист = ДопЛисты.Добавить();
		ЗаполнитьДопЛист(НовыйЛист);
		ДопЛист = СписокЛистов.Добавить();
		ДопЛист.ИндексКартинки = 1;
		ДопЛист.ТипСтраницы = 2;
		ДопЛист.Наименование = "ДопЛист";
		ДопЛист.UID = НовыйЛист.UID;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УдалитьСтраницуНаСервере(UID, ТипСтраницы)
	ОтборСтрок = Новый Структура("UID", UID);
	Таблица = ЭтотОбъект[ПолучитьИмяТаблицы(ТипСтраницы)];
	Строки = Таблица.НайтиСтроки(ОтборСтрок);
	Таблица.Удалить(Строки[0]);
	Возврат Таблица[0].UID;
КонецФункции

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	Если ТекущийТипСтраницы = 2 Тогда
		ДобавитьСтраницуНаСервере();
		ПеренумероватьСтраницы();
		УстановитьДоступностьКнопок();
		ТитульнаяСтраница[0].КОЛИЧЕСТВО_СТРАНИЦ = 1 + ДопЛисты.Количество();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	НайденныйИД = РегламентированнаяОтчетностьКлиентСервер.НайтиИДВДереве(Разделы.ПолучитьЭлементы(), ТекущийИдентификаторСтраницы, UID_Пустой);
	Если ТекущийИдентификаторСтраницы = UID_Пустой Тогда 
		Возврат;
	КонецЕсли;
	ЭлементДерева = Разделы.НайтиПоИдентификатору(НайденныйИД);
	ТС = ЭлементДерева.ТипСтраницы;
	UID = ЭлементДерева.UID;
	ТекущиеДанныеРодитель = ЭлементДерева.ПолучитьРодителя();
	Если ТекущиеДанныеРодитель.ПолучитьЭлементы().Количество() <= 1 Тогда 
		Возврат;
	КонецЕсли;
	UID_новый = УдалитьСтраницуНаСервере(UID, ТС);
	Для Каждого Стр Из ТекущиеДанныеРодитель.ПолучитьЭлементы() Цикл 
		Если Стр.UID = UID Тогда
			ТекущиеДанныеРодитель.ПолучитьЭлементы().Удалить(Стр);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ПеренумероватьСтраницы();
	УстановитьДоступностьКнопок();
	
	ТитульнаяСтраница[0].КОЛИЧЕСТВО_СТРАНИЦ = 1 + ДопЛисты.Количество();
	РегламентированнаяОтчетностьКлиент.УстановитьТекущуюСтрокуВДеревеРазделов(ЭтотОбъект, UID_новый);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РазделыПриАктивизацииСтроки(Элемент)
	Если ТекущийИдентификаторСтраницы = Элемент.ТекущиеДанные.UID И
		ТекущийТипСтраницы = Элемент.ТекущиеДанные.ТипСтраницы Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ТипСтраницы = 0 Тогда
		ПодчиненныеЭлементыДерева = Элемент.ТекущиеДанные.ПолучитьЭлементы();
		ТекущийИдентификаторСтраницы = ПодчиненныеЭлементыДерева[0].UID;
		ТекущийТипСтраницы = ПодчиненныеЭлементыДерева[0].ТипСтраницы;
		СформироватьМакетНаСервере();
		УстановитьДоступностьКнопок();
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификаторСтраницы = Элемент.ТекущиеДанные.UID;
	ТекущийТипСтраницы = Элемент.ТекущиеДанные.ТипСтраницы;
	СформироватьМакетНаСервере();
	УстановитьДоступностьКнопок();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
	КонецЕсли;
	
	ОтборПоИмениОбласти = Новый Структура("Имя", Область.Имя);
	Поля = ПоляСОсобымПорядкомЗаполнения.НайтиСтроки(ОтборПоИмениОбласти);
	Если Поля.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка(Поля[0], Элемент);
	КонецЕсли;
	
	Если Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления", "ТитульнаяСтраница");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	ИмяОбласти = ПолучитьИмяОбласти(ТекущийТипСтраницы);
	Если Не ЗначениеЗаполнено(ИмяОбласти) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "П_ИНН" Тогда
		НовИнн = Область.Значение;
		Для Каждого Стр Из ДопЛисты Цикл 
			Стр.П_ИНН_Д = НовИнн;
		КонецЦикла;
	ИначеЕсли Область.Имя = "П_КПП" Тогда
		НовКпп = Область.Значение;
		Для Каждого Стр Из ДопЛисты Цикл 
			Стр.П_КПП_Д = НовКпп;
		КонецЦикла;
	ИначеЕсли Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(Область.Имя, Область.Значение);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	Иначе
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1111052_5.01000_01.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		Если Параметр.ИмяСтраницы = "Титульный" Тогда 
			ТекущийТипСтраницы = 1;
		ИначеЕсли Параметр.ИмяСтраницы = "ДопЛист" Тогда 
			ТекущийТипСтраницы = 2;
		КонецЕсли;
		
		ТекущийИдентификаторСтраницы = Параметр.УИДСтраницы;
		СформироватьМакетНаСервере();
		Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Области.Найти(Параметр.ИмяОбласти);
		УстановитьДоступностьКнопок();
		Активизировать();
		Источник.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
