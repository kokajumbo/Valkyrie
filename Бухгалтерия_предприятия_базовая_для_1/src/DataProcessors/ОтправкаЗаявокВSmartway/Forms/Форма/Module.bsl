
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Данные организации
	Организация = Параметры.Организация;
	ДанныеОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация, ТекущаяДатаСеанса());
	ИННОрганизации          = ДанныеОрганизации.ИНН;
	НаименованиеОрганизации = ДанныеОрганизации.ПолноеНаименование;
	Телефон                 = ДанныеОрганизации.Телефоны;
	ЭлектроннаяПочта        = ДанныеОрганизации.Email;
	
	// Имя пользователя
	Пользователь = Пользователи.ТекущийПользователь();
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ДанныеПользователя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Пользователь, "Наименование, Служебный, ФизическоеЛицо");
		Если Не ДанныеПользователя.Служебный Тогда
			Если ЗначениеЗаполнено(ДанныеПользователя.ФизическоеЛицо) Тогда
				ИмяПользователя = ДанныеПользователя.ФизическоеЛицо;
			Иначе
				ИмяПользователя = ДанныеПользователя.Наименование;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Описание возможностей сервиса
	ОписаниеВозможностей = Новый Массив;
	ОписаниеВозможностей.Добавить(НСтр("ru = 'Интеграция с ""1С"" позволит автоматически перенести информацию о поездках
		|в авансовые отчеты и книгу покупок. Просто оставьте заявку и с вами свяжется
		|менеджер'"));
	ОписаниеВозможностей.Добавить(" ");
	ОписаниеВозможностей.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Smartway'"),,,, URLсервисаSmartway()));
	ОписаниеВозможностей.Добавить(НСтр("ru = ', который проведет презентацию и откроет тестовый доступ
		|для демонстрации возможностей.'"));
	ТекстВозможностиСервиса = Новый ФорматированнаяСтрока(ОписаниеВозможностей);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЛоготипНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке(URLсервисаSmartway());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявку(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаявки = Новый Структура(
		"ИмяПользователя, Телефон, ЭлектроннаяПочта, Организация, ИННОрганизации, НаименованиеОрганизации");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаявки, ЭтотОбъект);
	
	Закрыть(ПараметрыЗаявки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция URLсервисаSmartway()

	Возврат "https://smartway.today/";

КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта) Тогда
		
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Указан некорретный E-mail'"),, "ЭлектроннаяПочта");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти