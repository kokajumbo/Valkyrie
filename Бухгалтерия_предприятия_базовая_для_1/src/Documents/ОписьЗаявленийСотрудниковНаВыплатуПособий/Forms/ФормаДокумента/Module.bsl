#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		Объект.СтатусДокумента = Перечисления.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе;
		ЗаполнитьДанныеОрганизации();
	КонецЕсли;
	
	ОбновитьЭлементыПодписей();
	
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

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОписьЗаявленийСотрудниковНаВыплатуПособий", ПараметрыЗаписи, Объект.Ссылка);
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
	ОрганизацияПриИзмененииНаСервере()
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаявления

&НаКлиенте
Процедура ЗаявленияЗаявлениеПриИзменении(Элемент)
	ЗаявленияЗаявлениеПриИзмененииНаСервере(Элементы.Заявления.ТекущаяСтрока);
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
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
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

#Область ПодписиДокументов

// ЗарплатаКадрыПодсистемы.ПодписиДокументов
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент)
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
	ОбновитьЭлементыПодписей();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент)
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

#КонецОбласти

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ПодходящиеЗаявления = ПодходящиеЗаявления();
	
	Объект.Заявления.Очистить();
	
	МассивСтрокДляЗаполнения = Новый Массив;
	Пока ПодходящиеЗаявления.Следующий() Цикл
	   НоваяСтрокаОписи = Объект.Заявления.Добавить();
	   НоваяСтрокаОписи.Заявление = ПодходящиеЗаявления.Заявление;
	   МассивСтрокДляЗаполнения.Добавить(НоваяСтрокаОписи);
	КонецЦикла;
	
	ЗаполнитьКраткоеНаименованиеДокументов(МассивСтрокДляЗаполнения);
	
КонецПроцедуры

&НаСервере
Функция ПодходящиеЗаявления()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявлениеСотрудника.Ссылка КАК Заявление
	|ИЗ
	|	Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудника
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий.Заявления КАК ОписьЗаявлений
	|		ПО (ОписьЗаявлений.Заявление = ЗаявлениеСотрудника.Ссылка)
	|			И (ОписьЗаявлений.Ссылка.Проведен)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СведенияНеобходимыеДляНазначенияПособий КАК ЗаявленияВРеестрах
	|		ПО (ЗаявленияВРеестрах.Заявление = ЗаявлениеСотрудника.Ссылка)
	|			И (ЗаявленияВРеестрах.Ссылка.Проведен)
	|ГДЕ
	|	ЗаявлениеСотрудника.Проведен
	|	И (ОписьЗаявлений.Ссылка ЕСТЬ NULL
	|			ИЛИ ОписьЗаявлений.Ссылка = &Ссылка)
	|	И ЗаявлениеСотрудника.Организация = &Организация
	|	И ЗаявленияВРеестрах.Ссылка ЕСТЬ NULL
	|	И ЗаявлениеСотрудника.ВидПособия <> ЗНАЧЕНИЕ(Перечисление.ПособияНазначаемыеФСС.ОтпускСверхЕжегодногоНаПериодЛечения)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаявлениеСотрудника.ФамилияПолучателя,
	|	ЗаявлениеСотрудника.ИмяПолучателя,
	|	ЗаявлениеСотрудника.ОтчествоПолучателя,
	|	ЗаявлениеСотрудника.Дата";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеОрганизации()
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПолученияСведений = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Организация, "НаименованиеСокращенное, НаименованиеТерриториальногоОрганаФСС, ДополнительныйКодФСС");
	РеквизитыОрганизации.Свойство("НаименованиеСокращенное", Объект.НаименованиеОрганизации);
	РеквизитыОрганизации.Свойство("НаименованиеТерриториальногоОрганаФСС", Объект.НаименованиеТерриториальногоОрганаФСС);
	РеквизитыОрганизации.Свойство("ДополнительныйКодФСС", Объект.ДополнительныйКодФСС);
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, ДатаПолученияСведений, "ИННЮЛ,КППЮЛ,РегистрационныйНомерФСС,КодПодчиненностиФСС");
	ОргСведения.Свойство("ИННЮЛ", Объект.ИНН);
	ОргСведения.Свойство("КППЮЛ", Объект.КПП);
	ОргСведения.Свойство("РегистрационныйНомерФСС", Объект.РегистрационныйНомерФСС);
	ОргСведения.Свойство("КодПодчиненностиФСС", Объект.КодПодчиненностиФСС);
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Объект.ТелефонУполномоченногоПредставителя = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Объект.Организация,
		Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации,
		,
		ДатаПолученияСведений,
		Новый Структура("ТолькоПервая", Истина));
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеОрганизации()
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКраткоеНаименованиеДокументов(МассивСтрокДляЗаполнения)
	
	МассивЗаявлений = Новый Массив;
	Для каждого ЗаполняемаяСтрока Из МассивСтрокДляЗаполнения Цикл
	   МассивЗаявлений.Добавить(ЗаполняемаяСтрока.Заявление);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявлениеСотрудника.Ссылка КАК Заявление,
	|	ЗаявлениеСотрудника.ВидПособия КАК ВидПособия,
	|	ЗаявлениеСотрудника.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
	|	ЗаявлениеСотрудника.ДатаСправкиОПостановкеНаУчетВРанниеСрокиБеременности КАК ДатаСправкиОПостановкеНаУчетВРанниеСрокиБеременности,
	|	ЗаявлениеСотрудника.НомерСправкиОПостановкеНаУчетВРанниеСрокиБеременности КАК НомерСправкиОПостановкеНаУчетВРанниеСрокиБеременности,
	|	ЗаявлениеСотрудника.Дата КАК ДатаПредставленияПакетаДокументов,
	|	ЗаявлениеСотрудника.ФормаСправкиОРожденииРебенка КАК ФормаСправкиОРожденииРебенка,
	|	ЗаявлениеСотрудника.ДатаСправкиОРожденииРебенка КАК ДатаСправкиОРожденииРебенка,
	|	ЗаявлениеСотрудника.НомерСправкиОРожденииРебенка КАК НомерСправкиОРожденииРебенка,
	|	ЗаявлениеСотрудника.ДатаСвидетельстваОРождении КАК ДатаСвидетельстваОРождении,
	|	ЗаявлениеСотрудника.СерияСвидетельстваОРождении КАК СерияСвидетельстваОРождении,
	|	ЗаявлениеСотрудника.НомерСвидетельстваОРождении КАК НомерСвидетельстваОРождении,
	|	ЗаявлениеСотрудника.ДатаИногоДокументаПодтверждающегоРождение КАК ДатаИногоДокументаПодтверждающегоРождение,
	|	ЗаявлениеСотрудника.НомерИногоДокументаПодтверждающегоРождение КАК НомерИногоДокументаПодтверждающегоРождение,
	|	ЗаявлениеСотрудника.СправкаОНеполученииПособия КАК СправкаОНеполученииПособия,
	|	ЗаявлениеСотрудника.ДатаСправкиОНеполученииПособияОтОтца КАК ДатаСправкиОНеполученииПособияОтОтца,
	|	ЗаявлениеСотрудника.НомерСправкиОНеполученииПособияОтОтца КАК НомерСправкиОНеполученииПособияОтОтца,
	|	ЗаявлениеСотрудника.ДатаСправкиОНеполученииПособияОтМатери КАК ДатаСправкиОНеполученииПособияОтМатери,
	|	ЗаявлениеСотрудника.НомерСправкиОНеполученииПособияОтМатери КАК НомерСправкиОНеполученииПособияОтМатери,
	|	ЗаявлениеСотрудника.ДатаРешенияОбОпеке КАК ДатаРешенияОбОпеке,
	|	ЗаявлениеСотрудника.НомерРешенияОбОпеке КАК НомерРешенияОбОпеке,
	|	ЗаявлениеСотрудника.ДатаРешенияОбУсыновлении КАК ДатаРешенияОбУсыновлении,
	|	ЗаявлениеСотрудника.НомерРешенияОбУсыновлении КАК НомерРешенияОбУсыновлении,
	|	ЗаявлениеСотрудника.ДатаДоговораОПередачеРебенкаВПриемнуюСемью КАК ДатаДоговораОПередачеРебенкаВПриемнуюСемью,
	|	ЗаявлениеСотрудника.НомерДоговораОПередачеРебенкаВПриемнуюСемью КАК НомерДоговораОПередачеРебенкаВПриемнуюСемью
	|ИЗ
	|	Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудника
	|ГДЕ
	|	ЗаявлениеСотрудника.Ссылка В(&МассивЗаявлений)";
	Запрос.УстановитьПараметр("МассивЗаявлений", МассивЗаявлений);
	
	ДанныеЗаявлений = Запрос.Выполнить().Выбрать();
	СтруктураПоиска = Новый Структура("Заявление"); 
	Для каждого ЗаполняемаяСтрока Из МассивСтрокДляЗаполнения Цикл
		ДанныеЗаявлений.Сбросить();
		СтруктураПоиска.Вставить("Заявление", ЗаполняемаяСтрока.Заявление);
		Если ДанныеЗаявлений.НайтиСледующий(СтруктураПоиска) Тогда
		 ЗаполнитьКраткоеНаименованиеДокументовВСтроке(ЗаполняемаяСтрока, ДанныеЗаявлений)
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКраткоеНаименованиеДокументовВСтроке(ЗаполняемаяСтрока, ДанныеЗаявления)
	
	Если ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоВременнойНетрудоспособности 
		Или ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеВСвязиСНесчастнымСлучаемНаПроизводстве 
		Или ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодам Тогда
		
		ДокументыОснованияСтрока 	= НСтр("ru = 'Заявление о выплате пособия, Листок нетруд-ти № %1'");
		ДокументыОснования 			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, ДанныеЗаявления.НомерЛисткаНетрудоспособности);		
		КоличествоСтраниц 			= 4;
		
	ИначеЕсли ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодамВставшимНаУчетВРанниеСроки Тогда
		
		ДокументыОснованияСтрока 	= НСтр("ru = 'Заявление о выплате пособия, Листок нетруд-ти № %1, Справка о постановке на учет от %2 № %3'");
		ДокументыОснования 			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, ДанныеЗаявления.НомерЛисткаНетрудоспособности, Формат(ДанныеЗаявления.ДатаСправкиОПостановкеНаУчетВРанниеСрокиБеременности, "ДЛФ=D"), ДанныеЗаявления.НомерСправкиОПостановкеНаУчетВРанниеСрокиБеременности);		
		КоличествоСтраниц 			= 5;
		
	ИначеЕсли ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеВставшимНаУчетВРанниеСроки Тогда
		
		ДокументыОснованияСтрока 	= НСтр("ru = 'Заявление о выплате пособия, Справка о постановке на учет от %1 № %2'"); 
		ДокументыОснования 			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, ДанныеЗаявления.ДатаСправкиОПостановкеНаУчетВРанниеСрокиБеременности, ДанныеЗаявления.НомерСправкиОПостановкеНаУчетВРанниеСрокиБеременности);		
		КоличествоСтраниц 			= 4;
		
	ИначеЕсли ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ЕжемесячноеПособиеПоУходуЗаРебенком Тогда  
		
		ДокументыОснования 			= НСтр("ru = 'Заявление'");
		КоличествоСтраниц 			= 3;
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаСправкиОРожденииРебенка) И ЗначениеЗаполнено(ДанныеЗаявления.НомерСправкиОРожденииРебенка) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка %1 от %2 № %3'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, ДанныеЗаявления.ВидСправкиОРожденииРебенка, Формат(ДанныеЗаявления.ДатаСправкиОРожденииРебенка, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОРожденииРебенка);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаСвидетельстваОРождении) И ЗначениеЗаполнено(ДанныеЗаявления.НомерСвидетельстваОРождении) И ЗначениеЗаполнено(ДанныеЗаявления.СерияСвидетельстваОРождении) Тогда			
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Св-во о рожд. от %1 сер. %2 № %3'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСвидетельстваОРождении, "ДФ=dd.MM.yy"), ДанныеЗаявления.СерияСвидетельстваОРождении, ДанныеЗаявления.НомерСвидетельстваОРождении);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаИногоДокументаПодтверждающегоРождение) И ЗначениеЗаполнено(ДанныеЗаявления.НомерИногоДокументаПодтверждающегоРождение) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = '<Иное подтв. рожд.> от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаИногоДокументаПодтверждающегоРождение, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерИногоДокументаПодтверждающегоРождение);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;
			
		КонецЕсли; 
		
		Если ДанныеЗаявления.СправкаОНеполученииПособия = Перечисления.РодителиПредоставившиеСправкуОНеполученииПособия.Отец Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка от отца о непол. пос. от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСправкиОНеполученииПособияОтОтца, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОНеполученииПособияОтОтца);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		ИначеЕсли ДанныеЗаявления.СправкаОНеполученииПособия = Перечисления.РодителиПредоставившиеСправкуОНеполученииПособия.Мать Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка от др. род. о непол. пос. от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСправкиОНеполученииПособияОтМатери, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОНеполученииПособияОтМатери);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		ИначеЕсли ДанныеЗаявления.СправкаОНеполученииПособия = Перечисления.РодителиПредоставившиеСправкуОНеполученииПособия.ОбаРодителя Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка от отца о непол. пос. от %1 № %2; Справка от матери о непол. пос. от %3 № %4'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСправкиОНеполученииПособияОтОтца, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОНеполученииПособияОтОтца, Формат(ДанныеЗаявления.ДатаСправкиОНеполученииПособияОтМатери, "ДФ=dd.MM.yy"),  ДанныеЗаявления.НомерСправкиОНеполученииПособияОтМатери);					
			КоличествоСтраниц 			= КоличествоСтраниц + 2;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаРешенияОбОпеке) И ЗначениеЗаполнено(ДанныеЗаявления.НомерРешенияОбОпеке) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Решение об устан. опеки от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаРешенияОбОпеке, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерРешенияОбОпеке);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаРешенияОбУсыновлении) И ЗначениеЗаполнено(ДанныеЗаявления.НомерРешенияОбУсыновлении) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Решение об усын-ии от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаРешенияОбУсыновлении, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерРешенияОбУсыновлении);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаДоговораОПередачеРебенкаВПриемнуюСемью) И ЗначениеЗаполнено(ДанныеЗаявления.НомерДоговораОПередачеРебенкаВПриемнуюСемью) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Договор о передаче на восп. от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаДоговораОПередачеРебенкаВПриемнуюСемью, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерДоговораОПередачеРебенкаВПриемнуюСемью);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
	ИначеЕсли ДанныеЗаявления.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ЕдиновременноеПособиеПриРожденииРебенка Тогда  
		
		ДокументыОснования 			= НСтр("ru = 'Заявление'");
		КоличествоСтраниц 			= 3;
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ФормаСправкиОРожденииРебенка) И ЗначениеЗаполнено(ДанныеЗаявления.ДатаСправкиОРожденииРебенка) И ЗначениеЗаполнено(ДанныеЗаявления.НомерСправкиОРожденииРебенка) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка %1 от %2 № %3'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, ДанныеЗаявления.ФормаСправкиОРожденииРебенка, Формат(ДанныеЗаявления.ДатаСправкиОРожденииРебенка, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОРожденииРебенка);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаСвидетельстваОРождении) И ЗначениеЗаполнено(ДанныеЗаявления.НомерСвидетельстваОРождении) И ЗначениеЗаполнено(ДанныеЗаявления.СерияСвидетельстваОРождении) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Св-во о рожд. от %1 сер. %2 № %3'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСвидетельстваОРождении, "ДФ=dd.MM.yy"), ДанныеЗаявления.СерияСвидетельстваОРождении, ДанныеЗаявления.НомерСвидетельстваОРождении);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;

		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаИногоДокументаПодтверждающегоРождение) И ЗначениеЗаполнено(ДанныеЗаявления.НомерИногоДокументаПодтверждающегоРождение) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = '<Иное подтв. рожд.> от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаИногоДокументаПодтверждающегоРождение, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерИногоДокументаПодтверждающегоРождение);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;
			
		КонецЕсли; 
		
		Если ДанныеЗаявления.СправкаОНеполученииПособия = Перечисления.РодителиПредоставившиеСправкуОНеполученииПособия.Отец Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка от отца о непол. пос. от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСправкиОНеполученииПособияОтОтца, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОНеполученииПособияОтОтца);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		ИначеЕсли ДанныеЗаявления.СправкаОНеполученииПособия = Перечисления.РодителиПредоставившиеСправкуОНеполученииПособия.Мать Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Справка от др. род. о непол. пос. от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаСправкиОНеполученииПособияОтМатери, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерСправкиОНеполученииПособияОтМатери);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаРешенияОбОпеке) И ЗначениеЗаполнено(ДанныеЗаявления.НомерРешенияОбОпеке) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Решение об устан. опеки от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаРешенияОбОпеке, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерРешенияОбОпеке);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаРешенияОбУсыновлении) И ЗначениеЗаполнено(ДанныеЗаявления.НомерРешенияОбУсыновлении) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Решение об усын-ии от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаРешенияОбУсыновлении, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерРешенияОбУсыновлении);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДанныеЗаявления.ДатаДоговораОПередачеРебенкаВПриемнуюСемью) И ЗначениеЗаполнено(ДанныеЗаявления.НомерДоговораОПередачеРебенкаВПриемнуюСемью) Тогда
			
			ДокументыОснованияСтрока 	= НСтр("ru = 'Договор о передаче на восп. от %1 № %2'");
			ДокументыОснования 			= ДокументыОснования + ", " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументыОснованияСтрока, Формат(ДанныеЗаявления.ДатаДоговораОПередачеРебенкаВПриемнуюСемью, "ДФ=dd.MM.yy"), ДанныеЗаявления.НомерДоговораОПередачеРебенкаВПриемнуюСемью);					
			КоличествоСтраниц 			= КоличествоСтраниц + 1;			
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ЗаполняемаяСтрока.КраткоеНаименованиеДокументов = ДокументыОснования;
	ЗаполняемаяСтрока.КоличествоСтраниц = КоличествоСтраниц;

КонецПроцедуры 

&НаСервере
Процедура ЗаявленияЗаявлениеПриИзмененииНаСервере(ИдентификаторСтроки)
	ТекущаяСтрока = Объект.Заявления.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если НЕ ТекущаяСтрока = Неопределено Тогда
	    ЗаполнитьКраткоеНаименованиеДокументов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущаяСтрока))
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыПодписей()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		ПодписиДокументовКлиентСервер.ИмяЭлементаФормыПоРолиПодписанта("УполномоченныйПоПрямымВыплатамФСС"),
		"ПоложениеЗаголовка",
		ПоложениеЗаголовкаЭлементаФормы.Верх);
	
	ВводВСтаромФормате = ЗначениеЗаполнено(Объект.УдалитьФИОУполномоченного) И Не ЗначениеЗаполнено(Объект.УполномоченныйПоПрямымВыплатамФСС);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УдалитьФИОУполномоченного",
		"Видимость",
		ВводВСтаромФормате);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УдалитьДолжностьУполномоченного",
		"Видимость",
		ВводВСтаромФормате);
	
КонецПроцедуры

#КонецОбласти
