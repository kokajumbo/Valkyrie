
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ПервоначальнаяСтоимостьНУ

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПервоначальнаяСтоимостьНУ");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ПлательщикНДФЛ", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьСуммыРазниц(Форма)
	
	Если БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Форма.СчетУчетаБУ).НалоговыйУчет Тогда
		Форма.ТекущаяСтоимостьВР = Форма.ТекущаяСтоимостьБУ - Форма.ТекущаяСтоимостьНУ - Форма.ТекущаяСтоимостьПР;
	Иначе
		Форма.ТекущаяСтоимостьВР = 0;
		Форма.ТекущаяСтоимостьПР = 0;
	КонецЕсли;
	
	Если БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Форма.СчетНачисленияАмортизацииБУ).НалоговыйУчет Тогда
		Форма.НакопленнаяАмортизацияВР = Форма.НакопленнаяАмортизацияБУ - Форма.НакопленнаяАмортизацияНУ
										- Форма.НакопленнаяАмортизацияПР;
	Иначе
		Форма.НакопленнаяАмортизацияВР = 0;
		Форма.НакопленнаяАмортизацияПР = 0;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	СписокСпособовНачисленияАмортизацииБУ = Форма.Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора;
	СписокСпособовНачисленияАмортизацииБУ.Очистить();
	
	Форма.Элементы.ГруппаСпособПоступленияНМА.Видимость                = Форма.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив");
	Форма.Элементы.ГруппаПараметрыАмортизацииНУНМА.Видимость           = Форма.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив");
	Форма.Элементы.ГруппаПараметрыСписанияРасходовНУ_НИОКР.Видимость   = Форма.ВидОбъектаУчета <> ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив");
	Форма.Элементы.ГруппаПараметрыНачисленияАмортизацииНУНМА.Видимость = Форма.НачислятьАмортизациюНУ;
	Форма.Элементы.ГруппаСписыватьРасходыИП.Видимость                  = Форма.НачислятьАмортизациюНУ;
	
	Если Форма.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив") Тогда
		Форма.ТекстПараметрыАмортизации = "Параметры начисления амортизации";
		Форма.Элементы.НачислятьАмортизациюБУ.Заголовок = "Начислять амортизацию";
		Форма.Элементы.НачислятьАмортизациюНУ.Заголовок = "Начислять амортизацию";
		Форма.Элементы.СпособНачисленияАмортизацииБУ.Заголовок = "Способ начисления амортизации";
		Форма.Элементы.СпособОтраженияРасходов.Заголовок = "Способ отражения расходов по амортизации";
		Форма.Элементы.СрокПолезногоИспользованияБУ.Заголовок = "Срок полезного использования, мес";
		Форма.Элементы.ГруппаНакопленнаяАмортизацияИзнос.Доступность = Истина;
		
		СписокСпособовНачисленияАмортизацииБУ.Добавить(
			ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Линейный"));
		СписокСпособовНачисленияАмортизацииБУ.Добавить(
			ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка"));
		СписокСпособовНачисленияАмортизацииБУ.Добавить(
			ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции"));
		
	Иначе
		Форма.ТекстПараметрыАмортизации = "Параметры списания стоимости";
		Форма.Элементы.НачислятьАмортизациюБУ.Заголовок = "Списывать расходы";
		Форма.Элементы.НачислятьАмортизациюНУ.Заголовок = "Списывать расходы";
		Форма.Элементы.СпособНачисленияАмортизацииБУ.Заголовок = "Способ списания расходов";
		Форма.Элементы.СпособОтраженияРасходов.Заголовок = "Способ отражения расходов в учете";
		Форма.Элементы.СрокПолезногоИспользованияБУ.Заголовок = "Срок списания, мес";
		Форма.Элементы.ГруппаНакопленнаяАмортизацияИзнос.Доступность = Ложь;

		СписокСпособовНачисленияАмортизацииБУ.Добавить(
			ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Линейный"));
		СписокСпособовНачисленияАмортизацииБУ.Добавить(
			ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции"));
		
		Форма.Элементы.СрокПолезногоИспользованияНУ_НИОКР.Доступность = 
			Форма.ПорядокСписанияНИОКРНаРасходыНУ = ПредопределенноеЗначение("Перечисление.ПорядокСписанияНИОКРНУ.Равномерно");
			
	КонецЕсли;
	
	Форма.Элементы.ГруппаПараметрыНачисленияАмортизацииБУ.Видимость = Форма.НачислятьАмортизациюБУ;
	Форма.Элементы.ГруппаУменьшаемогоОстатка.Видимость = Форма.СпособНачисленияАмортизацииБУ =
		ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка");
	Форма.Элементы.ГруппаПропорциональноПродукции.Видимость = Форма.СпособНачисленияАмортизацииБУ =
		ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции");
	
	ДоступностьАмортизацииДо2009Года = Форма.МетодНачисленияАмортизацииНУ = ПредопределенноеЗначение("Перечисление.МетодыНачисленияАмортизации.Нелинейный");
	Форма.Элементы.АмортизацияДо2009.Доступность = ДоступностьАмортизацииДо2009Года;
	Форма.Элементы.ФактическийСрокИспользованияДо2009.Доступность = ДоступностьАмортизацииДо2009Года;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(Форма)
	
	Форма.РасшифровкаСрокаПолезногоИспользованияБУ = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Форма.СрокПолезногоИспользованияБУ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(Форма)
	
	Форма.РасшифровкаСрокаПолезногоИспользованияНУ = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Форма.СрокПолезногоИспользованияНУ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРасшифровкуСрокаПолезногоИспользованияУСН(Форма)
	
	Форма.РасшифровкаСрокаПолезногоИспользованияУСН = 
		УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(Форма.СрокПолезногоИспользованияУСН);
	
КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииСервер()
	
	ВидОбъектаУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НематериальныйАктив, "ВидОбъектаУчета");
	
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив Тогда
		СчетНачисленияАмортизацииБУ = ПланыСчетов.Хозрасчетный.АмортизацияНематериальныхАктивов;
		СчетУчетаБУ = ПланыСчетов.Хозрасчетный.НематериальныеАктивыОрганизации;
		
	Иначе
		СчетНачисленияАмортизацииБУ = Неопределено;
		НакопленнаяАмортизацияБУ = 0;
		НакопленнаяАмортизацияНУ = 0;
		НакопленнаяАмортизацияПР = 0;
		НакопленнаяАмортизацияВР = 0;
		СчетУчетаБУ = ПланыСчетов.Хозрасчетный.РасходыНаНИОКР;
		Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
			СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный;
			КоэффициентБУ = 0;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ВернутьСтруктуруЗакрытия()
	
	Структура = Новый Структура();
	
	Для Каждого Реквизит Из ЭтаФорма.ПолучитьРеквизиты() Цикл
		Структура.Вставить(Реквизит.Имя, ЭтаФорма[Реквизит.Имя]);
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура ВопросСохранитьИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			Модифицированность = Ложь;
			РезультатЗакрытия = ВернутьСтруктуруЗакрытия();
			Закрыть(РезультатЗакрытия);
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Модифицированность = Ложь;
		РезультатЗакрытия = ВернутьСтруктуруЗакрытия();
		Закрыть(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	НематериальныйАктивПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьБУПриИзменении(Элемент)
	
	Если (ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ) И ПервоначальнаяСтоимостьНУ = 0 Тогда
		ПервоначальнаяСтоимостьНУ = ПервоначальнаяСтоимостьБУ;
	КонецЕсли;
	
	Если ТекущаяСтоимостьБУ = 0 Тогда
		ТекущаяСтоимостьБУ = ПервоначальнаяСтоимостьБУ;
	КонецЕсли;
	
	Если (ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ) И ТекущаяСтоимостьНУ = 0 Тогда
		ТекущаяСтоимостьНУ = ПервоначальнаяСтоимостьБУ;
	КонецЕсли;
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьНУПриИзменении(Элемент)
	
	Если ТекущаяСтоимостьНУ = 0 Тогда
		ТекущаяСтоимостьНУ = ПервоначальнаяСтоимостьНУ;
	КонецЕсли;
	
	ПересчитатьСуммыРазниц(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьБУПриИзменении(Элемент)
	
	Если (ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ) И ТекущаяСтоимостьНУ = 0 Тогда
		ТекущаяСтоимостьНУ = ТекущаяСтоимостьБУ;
	КонецЕсли;
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьНУПриИзменении(Элемент)
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьПРПриИзменении(Элемент)
	
	ПересчитатьСуммыРазниц(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияБУПриИзменении(Элемент)
	
	Если (ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ) И НакопленнаяАмортизацияНУ = 0 Тогда
		НакопленнаяАмортизацияНУ = НакопленнаяАмортизацияБУ;
	КонецЕсли;
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияНУПриИзменении(Элемент)
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияПРПриИзменении(Элемент)
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюБУПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияБУПриИзменении(Элемент)
	
	Если (ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ) И СрокПолезногоИспользованияНУ = 0 Тогда
		СрокПолезногоИспользованияНУ = СрокПолезногоИспользованияБУ;
		ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
	КонецЕсли;
	
	Если ПрименяетсяУСНДоходыМинусРасходы И СрокПолезногоИспользованияУСН = 0 Тогда
		СрокПолезногоИспользованияУСН = СрокПолезногоИспользованияБУ;
		ОтобразитьРасшифровкуСрокаПолезногоИспользованияУСН(ЭтаФорма);
	КонецЕсли;
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюНУ_НМАПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура СрокПолезногоИспользованияНУПриИзменении(Элемент)
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияУСНПриИзменении(Элемент)
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияУСН(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииНУПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСписанияНИОКРНаРасходыНУПриИзменении(Элемент)
	
	ПорядокНачисления = ПорядокСписанияНИОКРНаРасходыНУ = ПредопределенноеЗначение("Перечисление.ПорядокСписанияНИОКРНУ.Равномерно");
	НачислятьАмортизациюНУ = ПорядокНачисления;
	СрокПолезногоИспользованияНУ = ?(ПорядокНачисления, ?(СрокПолезногоИспользованияНУ = 0, СрокПолезногоИспользованияБУ,СрокПолезногоИспользованияНУ),0);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюИППриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеЗаполнения);
	
	ДатаУчетнойПолитики = Дата + 86400;
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
		ЭтаФорма,
		Организация,
		ДатаУчетнойПолитики);
	
	ПрименениеУСН						= УчетнаяПолитика.ПрименяетсяУСН(Организация, ДатаУчетнойПолитики);
	ПрименяетсяУСНДоходыМинусРасходы	= УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, ДатаУчетнойПолитики);
	ПлательщикНалогаНаПрибыль 			= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, ДатаУчетнойПолитики);
	ПоддержкаПБУ18						= УчетнаяПолитика.ПоддержкаПБУ18(Организация, ДатаУчетнойПолитики);
	ПлательщикНДФЛ						= УчетнаяПолитика.ПлательщикНДФЛ(Организация, ДатаУчетнойПолитики);
	
	// Установка значений по умолчанию.
	Если Параметры.ЭтоНовый И НЕ Параметры.Копирование Тогда
		
		СчетУчетаБУ = ПланыСчетов.Хозрасчетный.НематериальныеАктивыОрганизации;
		СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный;
		МетодНачисленияАмортизацииНУ  = Перечисления.МетодыНачисленияАмортизации.Линейный;
		НачислятьАмортизациюБУ        = Истина;
		НачислятьАмортизациюНУ        = Истина;
		СпециальныйКоэффициентНУ      = 1;
		СчетаНачисленияАмортизацииБУ  = ПланыСчетов.Хозрасчетный.АмортизацияНематериальныхАктивов;
		ПорядокВключенияСтоимостиВСоставРасходовУСН = 
			Перечисления.ПорядокВключенияСтоимостиОСиНМАВСоставРасходовУСН.ВключитьВСоставАмортизируемогоИмущества;
		ОтражатьВНалоговомУчете       = Истина;
		ПорядокСписанияНИОКРНаРасходыНУ = ?(Дата < '20120101', Перечисления.ПорядокСписанияНИОКРНУ.Равномерно, 
			Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету);
		
	КонецЕсли;
	
	Заголовок = НСтр("ru='Нематериальные активы: %1'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок,
		?(Параметры.ЭтоНовый, Нстр("ru='Новая строка'"), НематериальныйАктив));
	
	ПересчитатьСуммыРазниц(ЭтаФорма);
	
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияБУ(ЭтаФорма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияНУ(ЭтаФорма);
	ОтобразитьРасшифровкуСрокаПолезногоИспользованияУСН(ЭтаФорма);
	
	Элементы.ГруппаНалоговыйУчет.Видимость	= ПлательщикНалогаНаПрибыль;
	Элементы.ГруппаУчетУСН.Видимость		= ПрименяетсяУСНДоходыМинусРасходы;
	Элементы.ГруппаУчетИП.Видимость			= ПлательщикНДФЛ;
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьУсловноеОформление();
	
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
		Оповещение = Новый ОписаниеОповещения("ВопросСохранитьИзмененияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	ДатаУчетнойПолитики = Дата + 86400;
	
	ПлательщикНалогаНаПрибыль        = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, ДатаУчетнойПолитики);
	ПрименяетсяУСНДоходыМинусРасходы = УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, ДатаУчетнойПолитики);
	ПлательщикНДФЛ                   = УчетнаяПолитика.ПлательщикНДФЛ(Организация, ДатаУчетнойПолитики);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ НачислятьАмортизациюБУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияБУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпособНачисленияАмортизацииБУ");
		МассивНепроверяемыхРеквизитов.Добавить("КоэффициентБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ОбъемПродукцииРаботДляВычисленияАмортизации");
	Иначе
		Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный
			ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
			МассивНепроверяемыхРеквизитов.Добавить("КоэффициентБУ");
		КонецЕсли;
		Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный
			 ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
			 МассивНепроверяемыхРеквизитов.Добавить("ОбъемПродукцииРаботДляВычисленияАмортизации");
		КонецЕсли;
	КонецЕсли;
	
	Если ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ Тогда
		
		Если НЕ ПлательщикНДФЛ Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПервоначальнаяСтоимостьНУ");
		КонецЕсли;
		
		Если НЕ НачислятьАмортизациюНУ Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияНУ");
			МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
			МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
			МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
			МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
			Если ПорядокСписанияНИОКРНаРасходыНУ = Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету Тогда   // новые строки
				МассивНепроверяемыхРеквизитов.Добавить("ПервоначальнаяСтоимостьНУ");
				МассивНепроверяемыхРеквизитов.Добавить("ТекущаяСтоимостьНУ");
			КонецЕсли;
		Иначе
			Если ПлательщикНДФЛ Тогда
				МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
				МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
				МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
				МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
			Иначе
				Если МетодНачисленияАмортизацииНУ = Перечисления.МетодыНачисленияАмортизации.Линейный Тогда
					МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
					МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокСписанияНИОКРНаРасходыНУ");
		МассивНепроверяемыхРеквизитов.Добавить("ПервоначальнаяСтоимостьНУ");
		МассивНепроверяемыхРеквизитов.Добавить("ТекущаяСтоимостьНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
		МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
		МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
		
	КонецЕсли;
	
	Если НЕ НачислятьАмортизациюБУ 
		И ((ПлательщикНалогаНаПрибыль ИЛИ ПлательщикНДФЛ)
			И НЕ НачислятьАмортизациюНУ) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособОтраженияРасходов");
	КонецЕсли;
	
	Если НЕ ПрименяетсяУСНДоходыМинусРасходы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПервоначальнаяСтоимостьУСН");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПриобретения");
		МассивНепроверяемыхРеквизитов.Добавить("НакопленнаяАмортизацияУСН");		
		МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияУСН");
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокВключенияСтоимостиВСоставРасходовУСН");
	КонецЕсли;
			
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетНачисленияАмортизацииБУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
		МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
		МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокСписанияНИОКРНаРасходыНУ");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры
