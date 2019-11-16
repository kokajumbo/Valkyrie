#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноСоздаватьЗаписиКУДиР = ПравоДоступа("Изменение", Метаданные.Документы.ЗаписьКУДиР);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация, НачалоПериода, КонецПериода");
	
	УстановитьОтборыДинамическогоСписка();
	
	Заголовок = ТекстЗаголовка();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПоказателиРасчетаУСН" И Источник <> ЭтотОбъект
		 И Не ЗначениеЗаполнено(Параметр) Тогда
		
		Элементы.Список.Обновить();
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ЗаписьКУДиР.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.Сумма.ТекстПодвала = ИтогиКнигиУчетаДоходовИРасходов(Форма.Организация, Форма.НачалоПериода, Форма.КонецПериода);
	
	Элементы.СоздатьДокумент.Доступность = Форма.МожноСоздаватьЗаписиКУДиР;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическогоСписка()
	
	ОтборКомпоновкиДанных = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных,
		"Период",
		НачалоПериода,
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборКомпоновкиДанных,
		"Период",
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		КонецПериода,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных,
		"Графа7",
		0,
		ВидСравненияКомпоновкиДанных.НеРавно,
		,
		Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИтогиКнигиУчетаДоходовИРасходов(Знач Организация, Знач НачалоПериода, Знач КонецПериода)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Новый Граница(НачалоПериода, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("КонецПериода",  Новый Граница(КонецПериода, ВидГраницы.Включая));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КнигаУчетаДоходовИРасходовОбороты.Графа7Оборот КАК Сумма
	|ИЗ
	|	РегистрНакопления.КнигаУчетаДоходовИРасходов.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК КнигаУчетаДоходовИРасходовОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Сумма = Выборка.Сумма;
	Иначе
		Сумма = 0;
	КонецЕсли;
	
	Возврат ОбщегоНазначенияБПВызовСервера.ФорматСумм(Сумма, , "0.00", " ");
	
КонецФункции

&НаСервере
Функция ТекстЗаголовка()
	
	ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоПериода, КонецПериода, Истина);
	
	ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Расходы за %1'"), ПредставлениеПериода);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстЗаголовка = ТекстЗаголовка + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Организация);
	КонецЕсли;
	
	Возврат ТекстЗаголовка;
	
КонецФункции

#КонецОбласти