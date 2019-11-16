
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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	
	Параметры.Свойство("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
	Параметры.Свойство("Данные", Данные);
	НужноОповещатьОСоздании = Ложь;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Организация = Объект.Организация;
	Иначе
		Организация = Параметры.Организация;
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			Объект.РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	Если ЗначениеЗаполнено(Данные) И ТипЗнч(Данные) = Тип("Структура") Тогда 
		ЗагрузитьДанныеТорговойТочки(Данные);
	КонецЕсли;
	ЗагрузитьДанные();
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМакетыУведомления(ЭтотОбъект, Объект.ИмяОтчета, "ПараметрыФорма2015_1");
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	СформироватьМакетНаСервере();
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
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

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗагрузитьДанные()
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.Титульный;
	НоваяСтрока = ТитульнаяСтраница.Добавить();
	ТекущийИдентификаторСтраницы = НоваяСтрока.UID;
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Титульный[0]);
	ТекущийИдентификаторСтраницы = НоваяСтрока.UID;
	
	СтруктураПараметров.Свойство("РегОтчет", РегОтчет);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2;
		Объект.Организация = Организация;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Объект.ПодписантТелефон = ТитульнаяСтраница[0].ТЕЛЕФОН;
	Объект.ПодписантДокумент = ТитульнаяСтраница[0].ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ;
	Объект.ПодписантПризнак = ТитульнаяСтраница[0].ПРИЗНАК_НП_ПОДВАЛ;
	Если ЗначениеЗаполнено(ТитульнаяСтраница[0].ДАТА_ПОДПИСИ) Тогда
		Объект.ДатаПодписи = ТитульнаяСтраница[0].ДАТА_ПОДПИСИ;
	Иначе
		Объект.ДатаПодписи = Неопределено;
	КонецЕсли;
	СтруктураПараметров = Новый Структура("Титульный, РегОтчет",
			ТитульнаяСтраница.Выгрузить(), РегОтчет);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТитульный(НовыйЛист)
	НовыйЛист.UID = Новый УникальныйИдентификатор;
	ТекущийИдентификаторСтраницы = НовыйЛист.UID;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		СтрокаСведений = "ИННЮЛ,КППЮЛ,ОГРН,НаимЮЛПол";
		ДП = ?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса());
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
		НовыйЛист.ОГРН = СведенияОбОрганизации.ОГРН;
		НовыйЛист.ОГРНИП = "";
		НовыйЛист.П_ИНН = СведенияОбОрганизации.ИННЮЛ;
		НовыйЛист.П_КПП = СведенияОбОрганизации.КППЮЛ;
		НовыйЛист.КОД_НО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
		НовыйЛист.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ = СведенияОбОрганизации.НаимЮЛПол;
	Иначе 
		СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ОГРН";
		ДП = ?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса());
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
		НовыйЛист.ОГРНИП = СведенияОбОрганизации.ОГРН;
		НовыйЛист.ОГРН = "";
		НовыйЛист.П_ИНН = СведенияОбОрганизации.ИННФЛ;
		НовыйЛист.П_КПП = "";
		НовыйЛист.ТЕЛЕФОН = СведенияОбОрганизации.ТелДом;
		НовыйЛист.КОД_НО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
		НовыйЛист.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ = СведенияОбОрганизации.ФИО;
		ИндивидуальныйПредприниматель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ИндивидуальныйПредприниматель");
	КонецЕсли;
	
	НовыйЛист.ДАТА_ПОДПИСИ = ДП;
	УстановитьДанныеПоРегистрацииВИФНС(Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяТаблицы(ТекущийТипСтраницы)
	Возврат "ТитульнаяСтраница";
КонецФункции

&НаСервере
Процедура СформироватьМакетНаСервере()
	Если ТитульнаяСтраница.Количество() = 0 Тогда
		НовыйЛист = ТитульнаяСтраница.Добавить();
		ЗаполнитьТитульный(НовыйЛист);
	КонецЕсли;
	Документы.УведомлениеОСпецрежимахНалогообложения.СформироватьМакетОтчетаНаСервере(ЭтотОбъект, Объект.ИмяОтчета, "Форма2015_1", "Титульный", ПолучитьИмяТаблицы(ТекущийТипСтраницы));
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка(Инфо)
	Если Инфо.Обработчик = "ОбработкаКодаНО" Тогда
		ОбработкаКодаНО(Инфо);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	Если ЗначениеЗаполнено(Физлицо) И ТипЗнч(Физлицо) = Тип("СправочникСсылка.Контрагенты") Тогда
		Фамилия = "";
		Имя = "";
		Отчество = "";
		Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
			ПредставлениеУведомления.Области["ОРГ_ПРЕДСТАВИТЕЛЬ"].Значение = Физлицо;
		КонецЕсли;
		ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = "";
		ТитульнаяСтраница[0].ОРГ_ПРЕДСТАВИТЕЛЬ = Физлицо;
	ИначеЕсли ЗначениеЗаполнено(Физлицо) Тогда
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Фамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Имя = СокрЛП(ДанныеПредставителя.Имя);
		Отчество = СокрЛП(ДанныеПредставителя.Отчество);
		Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Фамилия + " " + Имя + " " + Отчество);
			ПредставлениеУведомления.Области["ОРГ_ПРЕДСТАВИТЕЛЬ"].Значение = "";
		КонецЕсли;
		ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Фамилия + " " + Имя + " " + Отчество);
		ТитульнаяСтраница[0].ОРГ_ПРЕДСТАВИТЕЛЬ = "";
	Иначе
		Фамилия = "";
		Имя = "";
		Отчество = "";
		Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
			ПредставлениеУведомления.Области["ОРГ_ПРЕДСТАВИТЕЛЬ"].Значение = "";
		КонецЕсли;
		ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = "";
		ТитульнаяСтраница[0].ОРГ_ПРЕДСТАВИТЕЛЬ = "";
	КонецЕсли;
	
	Объект.ПодписантФамилия = Фамилия;
	Объект.ПодписантИмя = Имя;
	Объект.ПодписантОтчество = Отчество;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	
	Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ПредставлениеУведомления.Области["ОРГ_ПРЕДСТАВИТЕЛЬ"].Значение = "";
	КонецЕсли;
	ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ТитульнаяСтраница[0].ОРГ_ПРЕДСТАВИТЕЛЬ = "";
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС(МенятьКПП = Ложь)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Представитель,ДокументПредставителя,КПП,Код");
	Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
		Если МенятьКПП = Истина Тогда 
			ПредставлениеУведомления.Области["П_КПП"].Значение = Реквизиты.КПП;
		КонецЕсли;
		ПредставлениеУведомления.Области["КОД_НО"].Значение = Реквизиты.Код;
	КонецЕсли;
	Если МенятьКПП = Истина Тогда 
		ТитульнаяСтраница[0].П_КПП = Реквизиты.КПП;
	КонецЕсли;
	ТитульнаяСтраница[0].КОД_НО = Реквизиты.Код;
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
			ПризнакПодписанта = "4";
		Иначе
			ПризнакПодписанта = "2";
		КонецЕсли;
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
			ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = ПризнакПодписанта;
			ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = Реквизиты.ДокументПредставителя;
		КонецЕсли;
		ТитульнаяСтраница[0].ПРИЗНАК_НП_ПОДВАЛ = ПризнакПодписанта;
		ТитульнаяСтраница[0].ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
			ПризнакПодписанта = "3";
		Иначе
			ПризнакПодписанта = "1";
		КонецЕсли;
		Если ПредставлениеУведомления.Области.Количество() > 0 Тогда 
			ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = ПризнакПодписанта;
			ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		КонецЕсли;
		ТитульнаяСтраница[0].ПРИЗНАК_НП_ПОДВАЛ = ПризнакПодписанта;
		ТитульнаяСтраница[0].ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеТорговойТочки(Данные)
	НужноОповещатьОСоздании = Истина;
	ИФНС = Неопределено;
	ДанныеТорговойТочки = Неопределено;
	Данные.Свойство("ИФНС", ИФНС);
	Данные.Свойство("ДанныеТорговойТочки", ДанныеТорговойТочки);
	
	Если ЗначениеЗаполнено(ИФНС) И ТипЗнч(ИФНС) = Тип("СправочникСсылка.РегистрацииВНалоговомОргане") Тогда 
		Объект.РегистрацияВИФНС = ИФНС;
	ИначеЕсли Не ЗначениеЗаполнено(Объект.РегистрацияВИФНС) Тогда 
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеТорговойТочки) И ТипЗнч(ДанныеТорговойТочки) = Тип("Структура") Тогда
		ДанныеТорговойТочки.Свойство("ТорговаяТочка", ТорговаяТочка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	ОповеститьОСозданииТС2();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	ИмяОбласти = "Титульный";
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(Область.Имя, Область.Значение);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	
	ОтборПоИмениОбласти = Новый Структура("Имя", Область.Имя);
	Поля = ПоляСОсобымПорядкомЗаполнения.НайтиСтроки(ОтборПоИмениОбласти);
	Если Поля.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка(Поля[0]);
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления", "ТитульнаяСтраница");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

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
		ОповеститьОСозданииТС2();
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
		ОповеститьОСозданииТС2();
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	ОповеститьОСозданииТС2();
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
	ОповеститьОСозданииТС2();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	ОповеститьОСозданииТС2();
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
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2015_1"),
			"1110051_5.01000_01.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	ОповеститьОСозданииТС2();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОСозданииТС2()
	Если НужноОповещатьОСоздании И ЗначениеЗаполнено(ТорговаяТочка) Тогда
		Оповестить("Создание_ФормаТС2", ТорговаяТочка, Объект.Ссылка);
		НужноОповещатьОСоздании = Ложь;
	КонецЕсли;
КонецПроцедуры

#Область ОтправкаВФНС
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
#КонецОбласти

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
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
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
Процедура ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПроверитьДокумент(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ПроверитьВыгрузкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
