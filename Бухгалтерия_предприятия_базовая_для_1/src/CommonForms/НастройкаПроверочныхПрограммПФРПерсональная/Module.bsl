
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 НастройкиПользователяВДанныеФормы();	
	 УстановитьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПодсказкуКЭлементуКаталогПрограммыCheckUFA();
	УстановитьПодсказкуКЭлементуКаталогПрограммыCheckXML();
	УстановитьПодсказкуКЭлементуКаталогПрограммыПОПД();
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыCheckUFAНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
																
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок = НСтр("ru = 'Укажите каталог программы CheckPFR.'");
	ДиалогВыбора.Каталог = КаталогПрограммыCheckUFA;
	ДиалогВыбора.Показать(Новый ОписаниеОповещения("КаталогПрограммыCheckUFAПослеВыбора", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыCheckUFAПослеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
																
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КаталогПрограммыCheckUFA = ВыбранныеФайлы[0];
	УстановитьПодсказкуКЭлементуКаталогПрограммыCheckUFA();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыCheckXMLНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
																
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок = НСтр("ru = 'Укажите каталог программы CheckXML.'");
	ДиалогВыбора.Каталог = КаталогПрограммыCheckXML;
	ДиалогВыбора.Показать(Новый ОписаниеОповещения("КаталогПрограммыCheckXMLПослеВыбора", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыCheckXMLПослеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
																
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КаталогПрограммыCheckXML = ВыбранныеФайлы[0];
	УстановитьПодсказкуКЭлементуКаталогПрограммыCheckXML();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыПОПДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок = НСтр("ru = 'Укажите каталог программы ПО ПД.'");
	ДиалогВыбора.Каталог = КаталогПрограммыПОПД;
	ДиалогВыбора.Показать(Новый ОписаниеОповещения("КаталогПрограммыПОПДПослеВыбора", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыПОПДПослеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
																
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КаталогПрограммыПОПД = ВыбранныеФайлы[0];
	УстановитьПодсказкуКЭлементуКаталогПрограммыПОПД();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыCheckXMLПриИзменении(Элемент)
	УстановитьПодсказкуКЭлементуКаталогПрограммыCheckXML();
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыCheckUFAПриИзменении(Элемент)
	УстановитьПодсказкуКЭлементуКаталогПрограммыCheckUFA();
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыПОПДПриИзменении(Элемент)
	
	УстановитьПодсказкуКЭлементуКаталогПрограммыПОПД();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьПрограммойCheckUFAПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьПрограммойCheckXMLПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьПрограммойПОПДПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Отказ = Ложь;
	ПроверитьНаличиеФайловПрограмм(Отказ);
	
	Если Не Отказ Тогда
		СохранитьНастройкиПрограммПроверки();
		Оповестить("ИзмененыПерсональныеНастройкиПроверочныхПрограммПФР");
		Закрыть();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастройкиПользователяВДанныеФормы()
	НастройкиПроверочныхПрограмм = ПерсонифицированныйУчет.ПерсональныеНастройкиПрограммПроверкиОтчетности();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиПроверочныхПрограмм);
КонецПроцедуры	

&НаСервере
Процедура СохранитьНастройкиПрограммПроверки()
	ХранилищеОбщихНастроек.Сохранить("НастройкиПерсонифицированногоУчета", "ПроверятьПрограммойCheckUFA", ПроверятьПрограммойCheckUFA);	
	ХранилищеОбщихНастроек.Сохранить("НастройкиПерсонифицированногоУчета", "ПроверятьПрограммойCheckXML", ПроверятьПрограммойCheckXML);
	ХранилищеОбщихНастроек.Сохранить("НастройкиПерсонифицированногоУчета", "ПроверятьПрограммойПОПД", ПроверятьПрограммойПОПД);
	ХранилищеОбщихНастроек.Сохранить("НастройкиПерсонифицированногоУчета", "КаталогПрограммыCheckUFA", КаталогПрограммыCheckUFA);
	ХранилищеОбщихНастроек.Сохранить("НастройкиПерсонифицированногоУчета", "КаталогПрограммыCheckXml", КаталогПрограммыCheckXml);
	ХранилищеОбщихНастроек.Сохранить("НастройкиПерсонифицированногоУчета", "КаталогПрограммыПОПД", КаталогПрограммыПОПД);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	Элементы = Форма.Элементы;
	
	Элементы.КаталогПрограммыCheckUFA.Доступность = Форма.ПроверятьПрограммойCheckUFA;
	
	Элементы.КаталогПрограммыCheckXML.Доступность = Форма.ПроверятьПрограммойCheckXML;
	
	Элементы.КаталогПрограммыПОПД.Доступность = Форма.ПроверятьПрограммойПОПД;
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьПодсказкуКЭлементуКаталогПрограммыCheckXML()
	ФайлCheckXMLНайден = Истина;		
	Если ПроверятьПрограммойCheckXML И ПустаяСтрока(КаталогПрограммыCheckXML) Тогда
		ФайлCheckXMLНайден = Ложь;	
		Элементы.КаталогПрограммыCheckXML.Подсказка = НСтр("ru = 'Укажите каталог программы CheckXML'");
	Иначе				
		Элементы.КаталогПрограммыCheckXML.Подсказка = НСтр("ru = 'Каталог программы CheckXML'");
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьПодсказкуКЭлементуКаталогПрограммыCheckUFA()
	ФайлCheckUFAНайден = Истина;
	Если ПроверятьПрограммойCheckUFA И ПустаяСтрока(КаталогПрограммыCheckUFA) Тогда
		ФайлCheckUFAНайден = Ложь;	
		Элементы.КаталогПрограммыCheckUFA.Подсказка = НСтр("ru = 'Укажите каталог программы CheckPFR'");
	Иначе	
		Элементы.КаталогПрограммыCheckUFA.Подсказка = НСтр("ru = 'Каталог программы CheckPFR'");	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПодсказкуКЭлементуКаталогПрограммыПОПД()
	ФайлПОПДНайден = Истина;
	Если ПроверятьПрограммойПОПД И ПустаяСтрока(КаталогПрограммыПОПД) Тогда
		ФайлПОПДНайден = Ложь;	
		Элементы.КаталогПрограммыПОПД.Подсказка = НСтр("ru = 'Укажите каталог программы ПО ПД'");
	Иначе	
		Элементы.КаталогПрограммыПОПД.Подсказка = НСтр("ru = 'Каталог программы ПО ПД'");	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте 
Процедура ПроверитьНаличиеФайловПрограмм(Отказ)
	
	Если ПроверятьПрограммойCheckUFA И Не ФайлCheckUFAНайден Тогда
		ТекстСообщения = НСтр("ru = 'Файл программы CheckPFR не найден.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КаталогПрограммыCheckUFA", ,Отказ);
	КонецЕсли;
	
	Если ПроверятьПрограммойCheckXML И Не ФайлCheckXMLНайден Тогда
		ТекстСообщения = НСтр("ru = 'Файл программы CheckXML не найден.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КаталогПрограммыCheckXML", ,Отказ);
	КонецЕсли;
	
	Если ПроверятьПрограммойПОПД И Не ФайлПОПДНайден Тогда  
		ТекстСообщения = НСтр("ru = 'Файл программы ПО ПД не найден.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "КаталогПрограммыПОПД", ,Отказ);
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти
