#Область СлужебныеПроцедурыИФункции

Функция ИмяПомощникаРегистрации() Экспорт
	
	Возврат "Регистрация";
	
КонецФункции

Функция ИмяПомощникаВнесенияИзменений() Экспорт
	
	Возврат "ВнесениеИзменений";
	
КонецФункции

Функция МинимальныйУставныйКапитал() Экспорт

	Возврат 10000;

КонецФункции

Функция ЭтоДолжностьРуководителя(Должность) Экспорт
	
	НаименованияРуководителя = Новый Массив;
	НаименованияРуководителя.Добавить(НСтр("ru='ГЕНЕРАЛЬНЫЙ ДИРЕКТОР'", 
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	НаименованияРуководителя.Добавить(НСтр("ru='ДИРЕКТОР'", 
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	Возврат НаименованияРуководителя.Найти(ВРег(Должность)) <> Неопределено;
	
КонецФункции

Функция ОснованиеПолномочийПредставителя() Экспорт
	
	Возврат НСтр("ru = 'Устава'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Определяет вносятся ли изменения в учредительные документы
//
// Параметры:
//   Изменено - Структура - см. НоваяСтруктураИзменений()
//   АдресВУставеПолный - Булево - Истина, если в уставе указан полный юридический адрес
//   КодыОКВЭДпротиворечатУставу - Булево - Истина, если изменения кодов ОКВЭД необходимо внести в устав
//
// Возвращаемое значение:
//   Булево - Истина, если изменения вносятся в учредительные документы
//
Функция ИзмененияВносятсяВУчредительныеДокументы(Изменено, АдресВУставеПолный = Неопределено, КодыОКВЭДпротиворечатУставу = Неопределено) Экспорт
	
	ИзмененияВносятся = Изменено.СокращенноеНаименование
		Или Изменено.ПолноеНаименование
		Или Изменено.Местоположение
		Или Изменено.УставныйКапитал;
	
	Если АдресВУставеПолный <> Неопределено Тогда
		ИзмененияВносятся = ИзмененияВносятся Или (Изменено.ЮридическийАдрес И АдресВУставеПолный);
	КонецЕсли;
	
	Если КодыОКВЭДпротиворечатУставу <> Неопределено Тогда
		ИзмененияВносятся = ИзмененияВносятся Или ((Изменено.ОсновнойВидДеятельности Или Изменено.ВидыДеятельности) И КодыОКВЭДпротиворечатУставу);
	КонецЕсли;
	
	Возврат ИзмененияВносятся;
	
КонецФункции

// Определяет необходимость предварительно вносить в ЕГР сведения о том, что юридическим лицом принято решение об изменении реквизитов
//
// Параметры:
//   Изменено - Структура - см. НоваяСтруктураИзменений()
//   ЮрАдресИПропискаГлавногоСовпадают - Булево
//
// Возвращаемое значение:
//   Булево - Истина, если регистрация изменений выполняется в два этапа
//
Функция ИзмененияТребуютУведомления(Изменено, ЮрАдресИПропискаГлавногоСовпадают) Экспорт
	
	// Документы для государственной регистрации изменения адреса юридического лица, при котором изменяется место нахождения
	// юридического лица, не могут быть представлены в регистрирующий орган до истечения двадцати дней с момента внесения
	// в единый государственный реестр юридических лиц сведений о том, что юридическим лицом принято решение об изменении
	// адреса юридического лица, при котором изменяется место нахождения юридического лица.
	
	Возврат Изменено.Местоположение И НЕ ЮрАдресИПропискаГлавногоСовпадают;
	
КонецФункции

// Возвращает структуру изменений, вносимых в ЕГР для передачи в качестве параметра функциям
//
// Возвращаемое значение:
//   Структура - состав см. в коде функции
//
Функция НоваяСтруктураИзменений() Экспорт
	
	СтруктураИзменений = Новый Структура;
	СтруктураИзменений.Вставить("СокращенноеНаименование", Ложь);
	СтруктураИзменений.Вставить("ПолноеНаименование", Ложь);
	СтруктураИзменений.Вставить("ЮридическийАдрес", Ложь);
	СтруктураИзменений.Вставить("Местоположение", Ложь);
	СтруктураИзменений.Вставить("Руководитель", Ложь);
	СтруктураИзменений.Вставить("Учредители", Ложь);
	СтруктураИзменений.Вставить("УставныйКапитал", Ложь);
	СтруктураИзменений.Вставить("ОсновнойВидДеятельности", Ложь);
	СтруктураИзменений.Вставить("ВидыДеятельности", Ложь);
	
	Возврат СтруктураИзменений;
	
КонецФункции

Функция НовыеПараметрыПомощникаВнесенияИзменений() Экспорт
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("КонтекстныйВызов", Ложь);
	ПараметрыПомощника.Вставить("СоздатьПриОткрытии", Ложь);
	ПараметрыПомощника.Вставить("Организация", ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	
	Возврат ПараметрыПомощника;
	
КонецФункции

Функция ПоддерживаемыеПравовыеФормы() Экспорт
	
	ПравовыеФормы = Новый Массив;
	ПравовыеФормы.Добавить("Индивидуальные предприниматели");
	ПравовыеФормы.Добавить("Общества с ограниченной ответственностью");
	
	Возврат ПравовыеФормы;
	
КонецФункции

Функция ФинальныйСтатусЗаявленияОВнесенииИзмененийЕГР() Экспорт
	
	Возврат "Получены документы";
	
КонецФункции

Функция СпособыПодачиДокументов() Экспорт
	
	Способы = Новый Структура;
	
	Способы.Вставить("ИФНСлично", "ИФНСлично");
	Способы.Вставить("ИФНСпредставитель", "ИФНСпредставитель");
	Способы.Вставить("МФЦлично", "МФЦлично");
	Способы.Вставить("Почта", "Почта");
	
	Возврат Способы;
	
КонецФункции

Функция СпособРегистрацииПоСпособуПодачиДокументов(СпособПодачиДокументов) Экспорт
	
	Если ЗначениеЗаполнено(СпособПодачиДокументов) Тогда
		Возврат ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СпособыРегистрации(), СпособПодачиДокументов, 1);
	Иначе
		Возврат СпособыРегистрации().ИФНСлично;
	КонецЕсли;
	
КонецФункции

Функция СпособыРегистрации()
	
	Способы = Новый Структура;
	
	Способы.Вставить("ИФНСлично", 1);
	Способы.Вставить("ИФНСпредставитель", 2);
	Способы.Вставить("МФЦлично", 1);
	Способы.Вставить("Почта", 3);
	
	Возврат Способы;
	
КонецФункции

#КонецОбласти
