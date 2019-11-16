
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Переносим из параметров в реквизиты формы.
	Если ТипЗнч(Параметры.Банки) = Тип("Массив") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(Банки, Параметры.Банки, "Банк");
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ДокументооборотыПолучателей) = Тип("Соответствие") Тогда
		ДокументооборотыПолучателей = Новый ФиксированноеСоответствие(Параметры.ДокументооборотыПолучателей);
	КонецЕсли;
	
	// Параметры отбора сертификата для подписания заявки.
	ПараметрыОтбораСертификата = Параметры.ПараметрыОтбораСертификата;
	
	ТекстПояснения = НСтр("ru = 'Подготовка документов для заявки на кредит'");
	
	НачатьПодписаниеИОтправку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Шаг, после завершения которого будет вызван обработчик.
	ИмяШага = ?(Параметры.ПараметрыКриптографии.ЭтоЭлектроннаяПодписьВМоделиСервиса, "отправка", "подготовка");
	ДополнительныеПараметры = Новый Структура("ИмяШага", ИмяШага);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеВыполненияШагаФоновогоЗадания", ЭтотОбъект, ДополнительныеПараметры);

	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("СообщитьПрогрессВыполнения", ЭтотОбъект);

	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания       = Ложь; // Используем собственное окно
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьОтправку(Команда)
	
	Если ЗначениеЗаполнено(ДлительнаяОперация)
	   И ЗначениеЗаполнено(ДлительнаяОперация.ИдентификаторЗадания) Тогда
		ЗакрытиеМесяцаВызовСервера.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДвижениеИндикатора

// Обработчик вызывается в процессе выполнения шагов прогресса для перемещения индикатора.
//
&НаКлиенте
Процедура СообщитьПрогрессВыполнения(Результат, ДополнительныеПараметры = Неопределено) Экспорт

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Результат.Свойство("Прогресс")
	 Или ТипЗнч(Результат.Прогресс) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Прогресс = Результат.Прогресс;
	Если Не Прогресс.Свойство("Процент") Или Не Прогресс.Свойство("Текст") Тогда
		ТекстПояснения = НСтр("ru = 'Ошибка работы фонового задания'");
		Возврат;
	КонецЕсли;

	ТекстПояснения = Прогресс.Текст;
	
	// Каждый шаг занимает часть общего времени. Пропорции трех шагов предполагаются как 1:2:1:1 .
	// Сообщения прогресса сообщают о проценте от шага, который выполняется на данный момент.
	ИмяШагаПрогресса = ?(Прогресс.Свойство("ДополнительныеПараметры"),
		Прогресс.ДополнительныеПараметры.ИмяШага, "подписание");
	Если ИмяШагаПрогресса = "подготовка" Тогда
		ПроцентПредыдущегоШага = 0;
		ДоляТекущегоШага       = 0.2;
	ИначеЕсли ИмяШагаПрогресса = "подписание" Тогда
		ПроцентПредыдущегоШага = 20;
		ДоляТекущегоШага       = 0.4;
	ИначеЕсли ИмяШагаПрогресса = "транзакции" Тогда
		ПроцентПредыдущегоШага = 60;
		ДоляТекущегоШага       = 0.2;
	Иначе // отправка
		ПроцентПредыдущегоШага = 80;
		ДоляТекущегоШага       = 0.2;
	КонецЕсли;
	ПроцентВыполнения = ПроцентПредыдущегоШага + ДоляТекущегоШага * Прогресс.Процент;
	
	ОбновитьОтображениеДанных();

КонецПроцедуры

// Обработчик вызывается после выполнения шага, выполнявшегося в фоновом задании, для перехода к следующему шагу.
//
&НаКлиенте
Процедура ПослеВыполненияШагаФоновогоЗадания(Знач Результат, ДополнительныеПараметры) Экспорт

	СведенияОВыполнении = НовыеСведенияОВыполнении();
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда // остается только закрыть форму
		ОбработатьНеудачноеЗавершениеШага(СведенияОВыполнении);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("Структура")
	   И Не Результат.Свойство("Выполнено") // не прямой вызов обработчика
	   И Результат.Свойство("Статус") Тогда // вызов после фонового задания из БСП
	   
		Если Результат.Статус <> "Выполнено"
		 Или Не ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда

			СведенияОВыполнении.ОписаниеОшибки = ?(Результат.Статус = "Ошибка", Результат.ПодробноеПредставлениеОшибки, "");
			ОбработатьНеудачноеЗавершениеШага(СведенияОВыполнении);
			Возврат;
			
		КонецЕсли;
		
		// Передаем результат подписания и отправки из фонового задания.
		Результат = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	   
	КонецЕсли;

	// Приводим состав полей в результате к одинаковому составу.
	ЗаполнитьЗначенияСвойств(СведенияОВыполнении, Результат);
	
	Если СведенияОВыполнении.Выполнено = Истина Тогда
		// Получаем результат подписания и отправки из фонового задания.
		ОбработатьУспешноеЗавершениеШага(Результат, ДополнительныеПараметры);
	Иначе
		ОбработатьНеудачноеЗавершениеШага(СведенияОВыполнении);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НачатьПодписаниеИОтправку()

	ПараметрыКриптографии = Параметры.ПараметрыКриптографии;
	Если ПараметрыКриптографии.ЭтоЭлектроннаяПодписьВМоделиСервиса Тогда
		НаименованиеФоновогоЗадания = НСтр("ru = 'Подписание и отправка заявки на кредит (облачный сертификат)'");
		ИмяПроцедурыФоновогоЗадания = "Документы.ЗаявкаНаКредит.ПодписатьИОтправитьЭлектроннаяПодписьВМоделиСервиса";
	Иначе
		НаименованиеФоновогоЗадания = НСтр("ru = 'Подписание заявки на кредит (локальный сертификат)'");
		ИмяПроцедурыФоновогоЗадания = "Документы.ЗаявкаНаКредит.ПодготовитьФайлыДляОтправки";
	КонецЕсли;

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновогоЗадания;
	
	БанкиДляОтправки = Банки.Выгрузить(, "Банк").ВыгрузитьКолонку(0);

	Если ДокументооборотыПолучателей <> Неопределено Тогда
		ДокументооборотыПолучателейДляОтправки = Новый Соответствие(ДокументооборотыПолучателей);
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ТипТранзакции",        Параметры.ТипТранзакции);
	ПараметрыПроцедуры.Вставить("ПредметОбмена",        Параметры.ЗаявкаНаКредит);
	ПараметрыПроцедуры.Вставить("ОтпечатокСертификата", ПараметрыКриптографии.ОтпечатокСертификата);
	ПараметрыПроцедуры.Вставить("Банки",                БанкиДляОтправки);
	ПараметрыПроцедуры.Вставить("ДокументооборотыПолучателей", ДокументооборотыПолучателейДляОтправки);
	ПараметрыПроцедуры.Вставить("ПараметрыОтбораСертификата", ПараметрыОтбораСертификата);
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		ИмяПроцедурыФоновогоЗадания,
		ПараметрыПроцедуры,
		ПараметрыВыполнения);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНеудачноеЗавершениеШага(СведенияОВыполнении)
	
	Если ПустаяСтрока(СведенияОВыполнении.ОписаниеОшибки) Тогда
		// Произошла ошибка. Закрываем форму с индикатором.
		// Сообщение пользователю могло быть выдано ранее в месте возникновения ошибки,
		// здесь ничего не сообщает.
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(СведенияОВыполнении.ТаблицаСообщений) Тогда
		// В отчетности, которая прикрепляется к заявке, содержатся ошибки. Открываем форму для просмотра ошибок.
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуНавигацииПоОшибкамВыгрузки(СведенияОВыполнении.ТаблицаСообщений);
		Закрыть();
		
	Иначе
		// Произошла ошибка. Сообщаем о ней пользователю, затем закрываем форму с индикатором.
		
		КоличествоУспешноОбработано = 0;
		Если ЗначениеЗаполнено(СведенияОВыполнении.Транзакции) 
			И ЗначениеЗаполнено(СведенияОВыполнении.НеОтправленныеТранзакции) Тогда
			КоличествоУспешноОбработано = СведенияОВыполнении.Транзакции.Количество() 
				- СведенияОВыполнении.НеОтправленныеТранзакции.Количество();
			КоличествоУспешноОбработано = Макс(КоличествоУспешноОбработано, 0);
		КонецЕсли;

		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("КоличествоУспешноОбработано", КоличествоУспешноОбработано);
		ДополнительныеПараметры.Вставить("Транзакции", СведенияОВыполнении.Транзакции);

		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьПослеСообщения", ЭтотОбъект, ДополнительныеПараметры);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ТипТранзакции",            Параметры.ТипТранзакции);
		ПараметрыФормы.Вставить("ОписаниеОшибки",           СведенияОВыполнении.ОписаниеОшибки);
		ПараметрыФормы.Вставить("НеОтправленныеТранзакции", СведенияОВыполнении.НеОтправленныеТранзакции);
		ПараметрыФормы.Вставить("КоличествоУспешноОбработано", КоличествоУспешноОбработано);
		
		ОткрытьФорму("Документ.ЗаявкаНаКредит.Форма.СообщениеОбОшибках",
			ПараметрыФормы,
			ЭтотОбъект,
			,
			,
			,
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПослеСообщения(Результат, ДополнительныеПараметры) Экспорт

	РезультатВыполнения = Новый Структура();
	РезультатВыполнения.Вставить("Выполнено", Ложь);
	РезультатВыполнения.Вставить("Транзакции", ДополнительныеПараметры.Транзакции);

	Если ДополнительныеПараметры.КоличествоУспешноОбработано > 0 Тогда
		// Если в какие-то банки заявка все-таки была успешно отправлено,
		// то необходимо заблокировать ее от дальнейшего редактирования.
		// В этом случае принудительно выставляем признак Выполнено = Истина.
		РезультатВыполнения.Выполнено = Истина;
	КонецЕсли;

	Закрыть(РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУспешноеЗавершениеШага(Результат, ДополнительныеПараметры)
	
	Если Не ЗначениеЗаполнено(ДополнительныеПараметры)
	 Или Не ДополнительныеПараметры.Свойство("ИмяШага")
	 Или Параметры.ПараметрыКриптографии.ЭтоЭлектроннаяПодписьВМоделиСервиса
		И ДополнительныеПараметры.ИмяШага <> "отправка" Тогда
		
		ВызватьИсключение НСтр("ru = 'Некорректные параметры при переходе к следующему шагу подписания и отправки'");
		
	КонецЕсли;	
	
	Если ДополнительныеПараметры.ИмяШага = "подготовка" Тогда
		
		ИдентификаторВременногоХранилищаТранзакций = Результат.ИдентификаторВременногоХранилищаТранзакций;
	
		// Продолжаем выполнение на клиенте - подписываем подготовленные файлы.
		// Запускаем действия уже после того, как форма точно будет отображена на экране.
		ПодключитьОбработчикОжидания("Подключаемый_НачатьПодписаниеЛокальныйСертификат", 0.5, Истина);
		
	ИначеЕсли ДополнительныеПараметры.ИмяШага = "подписание" Тогда
				
		// Продолжаем выполнение запуском фонового задания - отправляем подписанные файлы.
		НачатьОтправкуЛокальныйСертификат(Результат);

		ДополнительныеПараметры = Новый Структура("ИмяШага", "отправка");
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеВыполненияШагаФоновогоЗадания", ЭтотОбъект, ДополнительныеПараметры);

		ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("СообщитьПрогрессВыполнения", ЭтотОбъект);

		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания       = Ложь; // Используем собственное окно
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		
	Иначе // формирование транзакций и отправка
		// Закрываем форму после отправки и возвращаем результат в вызвавшую процедуру.
		
		Закрыть(Результат);

	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИнформацияДляПодписания(ЗаявкаНаКредит)
	
	ДляПодписания = Новый Структура;
	ДляПодписания.Вставить("СостояниеПрогресса", ЗаявкиНаКредит.СостояниеПрогрессаПодписанияИОтправки());
	ДляПодписания.Вставить("Организация", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаявкаНаКредит, "Организация"));
	
	Возврат ДляПодписания;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_НачатьПодписаниеЛокальныйСертификат()

	ДляПодписания = ИнформацияДляПодписания(Параметры.ЗаявкаНаКредит);
	
	СостояниеПрогресса = ДляПодписания.СостояниеПрогресса;
	СостояниеПрогресса.ДополнительныеПараметры.ИмяШага = "подписание";
	СостояниеПрогресса.КоличествоДействий = 1 + Банки.Количество(); // заявка + банки
	СостояниеПрогресса.ВыполненоДействий = 1;
	
	Прогресс = Новый Структура;
	Прогресс.Вставить("Процент", СостояниеПрогресса.ВыполненоДействий / СостояниеПрогресса.КоличествоДействий * 100);
	Прогресс.Вставить("Текст",   НСтр("ru = 'Подписание файлов...'"));
	Прогресс.Вставить("ДополнительныеПараметры", СостояниеПрогресса.ДополнительныеПараметры); // имя шага
	Результат = Новый Структура("Прогресс", Прогресс);
	СообщитьПрогрессВыполнения(Результат);
	
	// Шифруем файлы.
	
	// Шаг, после завершения которого будет вызван обработчик.
	ДополнительныеПараметры = Новый Структура("ИмяШага", "подписание");
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеВыполненияШагаПодписанияЛокальнымСертификатом", ЭтотОбъект, ДополнительныеПараметры);
	
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("СообщитьПрогрессВыполнения", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыТранзакции = УниверсальныйОбменСБанкамиКлиент.ПараметрыПодготовкиТранзакции();
	ПараметрыТранзакции.Предмет           = Параметры.ЗаявкаНаКредит;
	ПараметрыТранзакции.Форма             = ЭтотОбъект;
	ПараметрыТранзакции.Сервис            = ПредопределенноеЗначение("Перечисление.СервисыОбменаСБанками.ЗаявкиНаКредит");
	ПараметрыТранзакции.Организация       = ДляПодписания.Организация;

	ПараметрыТранзакции.СертификатПодписи            = Параметры.ПараметрыКриптографии.ОтпечатокСертификата;
	ПараметрыТранзакции.ПарольДоступаКЗакрытомуКлючу = Параметры.ПараметрыКриптографии.ПарольЗакрытогоКлюча;

	ПараметрыТранзакции.ИдентификаторВременногоХранилища  = ИдентификаторВременногоХранилищаТранзакций;
	ПараметрыТранзакции.ОповещениеОПрогрессеВыполнения    = ОповещениеОПрогрессеВыполнения;
	
	// Параметры проверки сертификата
	ПараметрыТранзакции.ПараметрыПроверкиСертификата = ПараметрыОтбораСертификата;
	
	УниверсальныйОбменСБанкамиКлиент.ПодготовитьТранзакцию(ОповещениеОЗавершении,  ПараметрыТранзакции);

КонецПроцедуры

// Обработчик вызывается после выполнения шага, выполнявшегося вызовами сервера с клиента, для перехода к следующему шагу.
//
&НаКлиенте
Процедура ПослеВыполненияШагаПодписанияЛокальнымСертификатом(Результат, ДополнительныеПараметры) Экспорт
	
	СведенияОВыполнении = НовыеСведенияОВыполнении();

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда // остается только закрыть форму
		ОбработатьНеудачноеЗавершениеШага(СведенияОВыполнении);
		Возврат;
	КонецЕсли;
	
	// Приводим состав полей в результате к одинаковому составу.
	ЗаполнитьЗначенияСвойств(СведенияОВыполнении, Результат);
	
	Если СведенияОВыполнении.Выполнено = Истина Тогда
		// Получаем результат подписания и отправки из фонового задания.
		ОбработатьУспешноеЗавершениеШага(Результат, ДополнительныеПараметры);
	Иначе
		ОбработатьНеудачноеЗавершениеШага(СведенияОВыполнении);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачатьОтправкуЛокальныйСертификат(РезультатПодписания)

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Отправка заявки на кредит (локальный сертификат)'");
	
	Если ДокументооборотыПолучателей <> Неопределено Тогда
		ДокументооборотыПолучателейДляОтправки = Новый Соответствие(ДокументооборотыПолучателей);
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ТипТранзакции",        Параметры.ТипТранзакции);
	ПараметрыПроцедуры.Вставить("ПредметОбмена",        Параметры.ЗаявкаНаКредит);
	ПараметрыПроцедуры.Вставить("ОтпечатокСертификата", Параметры.ПараметрыКриптографии.ОтпечатокСертификата);
	ПараметрыПроцедуры.Вставить("Банки",                РезультатПодписания.Получатели);
	ПараметрыПроцедуры.Вставить("ДокументооборотыПолучателей", ДокументооборотыПолучателейДляОтправки);
	ПараметрыПроцедуры.Вставить("ИдентификаторВременногоХранилищаТранзакций", ИдентификаторВременногоХранилищаТранзакций);
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ЗаявкаНаКредит.ОтправитьПодписанныеФайлы",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Функция НовыеСведенияОВыполнении()

	Результат = Новый Структура();
	
	Результат.Вставить("Выполнено",                Ложь);
	Результат.Вставить("ОписаниеОшибки",           "");
	Результат.Вставить("Транзакции",               Новый Массив);
	Результат.Вставить("НеОтправленныеТранзакции", Новый Массив);
	Результат.Вставить("ТаблицаСообщений");
	
	Возврат Результат;

КонецФункции

#КонецОбласти
