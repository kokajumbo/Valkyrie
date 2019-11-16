
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	ТекущийТекстНомераДекларации = Объект.Код;
	
	КодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КодИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТекущийТекстНомераДекларации = Текст;
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиИнформациюОбОшибкахВНомере", 0.1, Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	КорректныйПериод = ОбщегоНазначенияБПСобытия.КорректныйПериодВводаДокументов();
	
	НачалоКорректногоПериода = КорректныйПериод.НачалоКорректногоПериода;
	КонецКорректногоПериода  = КорректныйПериод.КонецКорректногоПериода;
	
	ТекущийТекстНомераДекларации = Объект.Код;
	КодОшибки = НаличиеОшибокВНомереДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.НомерОшибочнаяСтруктура.Видимость      = Форма.КодОшибки = 1;
	Элементы.КодТаможенногоОрганаДлина.Видимость    = Форма.КодОшибки = 2;
	Элементы.ДатаДекларацииДлина.Видимость          = Форма.КодОшибки = 3;
	Элементы.ДатаДекларацииОшибочная.Видимость      = Форма.КодОшибки = 4;
	Элементы.ПорядковыйНомерДлина.Видимость         = Форма.КодОшибки = 5;
	Элементы.ПорядковыйЦифра0ВместоБуквыО.Видимость = Форма.КодОшибки = 6;
	Элементы.ПорядковыйЦифра3ВместоБуквыЗ.Видимость = Форма.КодОшибки = 7;
	Элементы.ПорядковыйНомерТовараДлина.Видимость   = Форма.КодОшибки = 8;
	
КонецПроцедуры

&НаСервере
Процедура КодПриИзмененииНаСервере()
	
	Реквизиты = Справочники.НомераГТД.РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации);
	ЗаполнитьЗначенияСвойств(Объект, Реквизиты, "РегистрационныйНомер,СтранаВвозаНеРФ");
	
	КодОшибки = НаличиеОшибокВНомереДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НаличиеОшибокВНомереДекларации(НомерТаможеннойДекларации, НачалоКорректногоПериода, КонецКорректногоПериода)
	
	НомерДекларацииНаТовары = СокрЛП(НомерТаможеннойДекларации);
	
	Если НЕ ЗначениеЗаполнено(НомерДекларацииНаТовары) Тогда
		// Пользователь еще ничего не ввел.
		Возврат 0;
	КонецЕсли;
	
	МассивТД = СтрРазделить(НомерДекларацииНаТовары, "/");
	
	Если МассивТД.Количество() > 4
	 ИЛИ МассивТД.Количество() < 3 Тогда
		// Ошибочное количество элементов.
		Возврат 1;
	КонецЕсли;
	
	КодТаможенногоОргана = МассивТД[0];
	
	Если СтрДлина(КодТаможенногоОргана) <> 2
		И СтрДлина(КодТаможенногоОргана) <> 5
		И СтрДлина(КодТаможенногоОргана) <> 8 Тогда
		// Ошибочная длина кода таможенного органа.
		Возврат 2;
	КонецЕсли;
	
	ДатаПринятияДекларацииНаТовары = МассивТД[1];
	
	Если СтрДлина(ДатаПринятияДекларацииНаТовары) <> 6 Тогда
		// Ошибочная длина поля дата.
		Возврат 3;
	Иначе
		// Проверим корректность указания даты.
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДатаПринятияДекларацииНаТовары) Тогда
			// Длина поля верная, но дата указана ошибочно.
			Возврат 3;
		КонецЕсли; 
		
		СтрокаВДату = СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаПринятияДекларацииНаТовары);
		Если НЕ ЗначениеЗаполнено(СтрокаВДату) Тогда
			// Длина поля верная, но дата указана ошибочно.
			Возврат 3;
		Иначе
			// Проверим год на корректность указания.
			
			Если СтрокаВДату < НачалоКорректногоПериода 
			 ИЛИ СтрокаВДату > КонецКорректногоПериода Тогда
				Возврат 4;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ПорядковыйНомерДекларацииНаТовары = МассивТД[2];
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) < 7
	 ИЛИ СтрДлина(ПорядковыйНомерДекларацииНаТовары) > 8 Тогда
		// Ошибочная длина поля порядковый номер.
		Возврат 5;
	КонецЕсли;
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) = 7
		И НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПорядковыйНомерДекларацииНаТовары) Тогда
		// Ошибочный формат поля порядковый номер.
		Возврат 5;
	КонецЕсли;
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) = 8 Тогда
		ПервыеДваСимвола = ВРег(Лев(ПорядковыйНомерДекларацииНаТовары, 2));
		Если ПервыеДваСимвола = "0Б" Тогда 
			// Вместо буквы "О" указана цифра ноль.
			Возврат 6;
		ИначеЕсли ПервыеДваСимвола = "3В"
		      ИЛИ ПервыеДваСимвола = "3B" Тогда
			// Вместо буквы "З" указана цифра три.
			Возврат 7;
		ИначеЕсли ПервыеДваСимвола <> "ОБ"
		        И ПервыеДваСимвола <> "OБ"
		        И ПервыеДваСимвола <> "ЗВ"
		        И ПервыеДваСимвола <> "ЗB" Тогда 
			// Ошибочный формат поля порядковый номер.
			Возврат 5;
		КонецЕсли;
		ПоследниеШестьСимволов = ВРег(Прав(ПорядковыйНомерДекларацииНаТовары, 6));
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПоследниеШестьСимволов) Тогда
			// Ошибочный формат поля порядковый номер.
			Возврат 5;
		КонецЕсли;
	КонецЕсли;
	
	Если МассивТД.Количество() = 4 Тогда
		ПорядковыйНомерТовара = МассивТД[3];
		Если СтрДлина(ПорядковыйНомерТовара) > 3
		 ИЛИ СтрДлина(ПорядковыйНомерТовара) < 1 Тогда
			// Ошибочная длина поля порядковый номер товара.
			Возврат 8;
		КонецЕсли;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ВывестиИнформациюОбОшибкахВНомере() Экспорт
	
	КодОшибки = НаличиеОшибокВНомереДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти