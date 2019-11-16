
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СписокСвойств = "Организация, Дата";
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, СписокСвойств);

	ЗагрузитьОбъектыНедвижимости(Параметры.АдресОбъектыНедвижимостиВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		АдресОбъектыНедвижимостиВХранилище = ПоместитьОбъектыНедвижимости();
		Структура = Новый Структура("АдресОбъектыНедвижимостиВХранилище", АдресОбъектыНедвижимостиВХранилище);
		ОповеститьОВыборе(Структура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбъектыНедвижимостиПодбор

&НаКлиенте
Процедура ОбъектыНедвижимостиПодборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Выбран = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьОбъектыНедвижимостиПодбор();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ТекстВопроса = НСтр("ru = 'Вы уверены, что хотите очистить список объектов недвижимости'");
	Оповещение = Новый ОписаниеОповещения("ВопросОчиститьЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если ОбъектыНедвижимостиПодбор.Количество() = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не выбраны объекты недвижимости для переноса в документ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат
	КонецЕсли;
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыНедвижимостиВыделитьВсе(Команда)
	
	Для Каждого СтрокаОбъектНедвижимости ИЗ ОбъектыНедвижимостиПодбор Цикл
		СтрокаОбъектНедвижимости.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыНедвижимостиСнятьВыделениеВсех(Команда)
	
	Для Каждого СтрокаОбъектНедвижимости ИЗ ОбъектыНедвижимостиПодбор Цикл
		СтрокаОбъектНедвижимости.Выбран = Ложь;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТаблицуОбъектовНедвижимости(ОграничениеПериода = Ложь )
	
	Если ЭтаФорма.ОбъектыНедвижимостиПодбор.Количество() > 0 Тогда 
		ИсключаемыеОС = ЭтаФорма.ОбъектыНедвижимостиПодбор.Выгрузить(,"ОбъектНедвижимости");
	Иначе 
		ИсключаемыеОС = Неопределено;
	КонецЕсли;
	
	// Формирование списка ОС:
	// - входящих в список групп
	// - введенных в эксплуатацию не ранее нижнего ограничения периода
	// - с момента ввода которых в эксплуатацию не прошло указанное число лет
	// - не снятых с учета в данной организации
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период",                               КонецГода(ЭтаФорма.Дата));
	Запрос.УстановитьПараметр("Организация",                          ЭтаФорма.Организация);
	Запрос.УстановитьПараметр("СнятоСУчета",                          Перечисления.СостоянияОС.СнятоСУчета);
	Запрос.УстановитьПараметр("ВведеноВЭксплуатацию",                 Перечисления.СостоянияОС.ПринятоКУчету);
	Запрос.УстановитьПараметр("НижнееОграничениеПериода",             ?(ОграничениеПериода, '20060101', '00010101'));
	Запрос.УстановитьПараметр("ОграничениеПериодаЭксплуатацииВГодах", 15);
	Запрос.УстановитьПараметр("ИсключатьОС", ИсключаемыеОС <> Неопределено);
	Запрос.УстановитьПараметр("ИсключаемыеОС", ИсключаемыеОС);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияОСОрганизаций.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ВведенныеВЭксплуатациюОС
	|ИЗ
	|	РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
	|ГДЕ
	|	СостоянияОСОрганизаций.Состояние = &ВведеноВЭксплуатацию
	|	И СостоянияОСОрганизаций.ДатаСостояния МЕЖДУ &НижнееОграничениеПериода И &Период
	|	И &Период < ДОБАВИТЬКДАТЕ(СостоянияОСОрганизаций.ДатаСостояния, ГОД, &ОграничениеПериодаЭксплуатацииВГодах)
	|	И СостоянияОСОрганизаций.Организация = &Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостоянияОСОрганизаций.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ СнятыеСУчетаОС
	|ИЗ
	|	РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
	|ГДЕ
	|	СостоянияОСОрганизаций.Состояние = &СнятоСУчета
	|	И СостоянияОСОрганизаций.ДатаСостояния < &Период
	|	И СостоянияОСОрганизаций.Организация = &Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСредства.Ссылка КАК ОсновноеСредство
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВведенныеВЭксплуатациюОС КАК ВведенныеВЭксплуатациюОС
	|		ПО ОсновныеСредства.Ссылка = ВведенныеВЭксплуатациюОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ СнятыеСУчетаОС КАК СнятыеСУчетаОС
	|		ПО ОсновныеСредства.Ссылка <> СнятыеСУчетаОС.ОсновноеСредство
	|ГДЕ
	|	(НЕ &ИсключатьОС
	|			ИЛИ НЕ ОсновныеСредства.Ссылка В (&ИсключаемыеОС))
	|	И ОсновныеСредства.НедвижимоеИмущество";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		СписокОС = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
		
		Запрос = Документы.ВосстановлениеНДСПоОбъектамНедвижимости.ПолучитьПараметрыОСпоСписку(
			ЭтаФорма.Дата, ЭтаФорма.Организация, СписокОС);
		
		ТаблицаОС = Запрос.Выгрузить();
		ТаблицаОС.Колонки.Добавить("Выбран");
		ТаблицаОС.ЗаполнитьЗначения(Истина, "Выбран");
		Возврат ТаблицаОС;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

&НаСервере
Процедура ЗаполнитьОбъектыНедвижимостиПодбор()

	ТаблицаОС = ПолучитьТаблицуОбъектовНедвижимости(ТолькоОС2006Года);
	Если ТаблицаОС <> Неопределено Тогда
		ТаблицаФормы = РеквизитФормыВЗначение("ОбъектыНедвижимостиПодбор");
		Для Каждого СтрокаТаблицыОС ИЗ ТаблицаОС Цикл 
			НоваяСтрока = ТаблицаФормы.Добавить();
			НоваяСтрока.Выбран                            = СтрокаТаблицыОС.Выбран;
			НоваяСтрока.ДатаВводаВЭксплуатациюБУ          = СтрокаТаблицыОС.ДатаВводаВЭксплуатациюБУ;
			НоваяСтрока.ДатаНачисленияАмортизацииНУ       = СтрокаТаблицыОС.ДатаНачисленияАмортизацииНУ;
			НоваяСтрока.ОбъектНедвижимости                = СтрокаТаблицыОС.ОбъектНедвижимости;
			НоваяСтрока.СтоимостьОбъектаНедвижимости      = СтрокаТаблицыОС.СтоимостьОбъектаНедвижимости;
		КонецЦикла;
		
		ЗначениеВДанныеФормы(ТаблицаФормы,ОбъектыНедвижимостиПодбор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьОбъектыНедвижимости()
	
	СтруктураПоиска = Новый Структура("Выбран", Истина);
	НайденныеСтроки = ОбъектыНедвижимостиПодбор.НайтиСтроки(СтруктураПоиска);
	
	тзОбъектыНедвижимости = ОбъектыНедвижимостиПодбор.Выгрузить(НайденныеСтроки);
	
	АдресОбъектыНедвижимостиВХранилище = ПоместитьВоВременноеХранилище(тзОбъектыНедвижимости, УникальныйИдентификатор);
	
	Возврат АдресОбъектыНедвижимостиВХранилище;

КонецФункции

&НаСервере
Процедура ЗагрузитьОбъектыНедвижимости(АдресОбъектыНедвижимостиВХранилище)

	ТаблицаОбъектыНедвижимости = ПолучитьИзВременногоХранилища(АдресОбъектыНедвижимостиВХранилище);
	ОбъектыНедвижимостиПодбор.Загрузить(ТаблицаОбъектыНедвижимости);

КонецПроцедуры

&НаКлиенте
Процедура ВопросОчиститьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОбъектыНедвижимостиПодбор.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


