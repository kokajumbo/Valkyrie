#Область РаботаСФайлами

#Область ЗагрузкаФайла

&НаКлиенте
Процедура ВыбратьИЗагрузитьФайл(Форма, Кодировка = "Windows") Экспорт
	
	ДополнительныеПараметры = Новый Структура("Форма, Кодировка", Форма, Кодировка);
	
	Если Форма.РасширениеРаботыСФайламиПодключено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораФайлаДляЗагрузкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогВыбора.Фильтр                  = НСтр("ru = 'Текстовый файл'") + " (*.txt)|*.txt";
		ДиалогВыбора.Заголовок               = НСтр("ru = 'Выберите файл для загрузки выписки из банка'");
		ДиалогВыбора.ПредварительныйПросмотр = Ложь;
		ДиалогВыбора.Расширение              = "txt";
		ДиалогВыбора.ИндексФильтра           = 0;
		ДиалогВыбора.ПолноеИмяФайла          = "kl_to_1c.txt";
		ДиалогВыбора.МножественныйВыбор      = Ложь;
		ДиалогВыбора.Показать(ОписаниеОповещения);
	Иначе
		ОповещениеПомещениеФайла = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОповещениеПомещениеФайла, , "kl_to_1c.txt", Истина, Форма.УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыбранныйФайл(ФайлЗагрузки, Форма, Кодировка = "Windows") Экспорт
	
	ДополнительныеПараметры = Новый Структура("Форма, Кодировка", Форма, Кодировка);
	Если Форма.РасширениеРаботыСФайламиПодключено Тогда
		ЗагрузитьФайлНаКлиенте(ФайлЗагрузки, ДополнительныеПараметры);
	Иначе
		ОповещениеПомещениеФайла = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОповещениеПомещениеФайла, , ФайлЗагрузки, Истина, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогВыбораФайлаДляЗагрузкиЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		
		ИмяФайла = ВыбранныеФайлы.Получить(0);
		ЗагрузитьФайлНаКлиенте(ИмяФайла, ДополнительныеПараметры)
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлНаКлиенте(ИмяФайла, ДополнительныеПараметры)
	
	ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлНаКлиентеСозданиеФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещения, ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлНаКлиентеСозданиеФайла(Файл, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("Файл", Файл);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлНаКлиентеПроверкаСуществования",
		ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлНаКлиентеПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		Файл = ДополнительныеПараметры.Файл;
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлНаКлиентеПроверкаНаКаталог", ЭтотОбъект, ДополнительныеПараметры);
		Файл.НачатьПроверкуЭтоКаталог(ОписаниеОповещения);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросВыбратьФайлИнтерактивноЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Файл обмена с банком не обнаружен. Выбрать файл интерактивно?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросВыбратьФайлИнтерактивноЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыбратьИЗагрузитьФайл(ДополнительныеПараметры.Форма, ДополнительныеПараметры.Кодировка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлНаКлиентеПроверкаНаКаталог(ЭтоКаталог, ДополнительныеПараметры) Экспорт
	
	Если ЭтоКаталог Тогда
		ТекстСообщения = НСтр("ru = 'Файл данных для загрузки документов из банка некорректен - выбран ""каталог"".
			|Выберите файл загрузки'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайла));
	
	ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ЗагрузитьФайлНаКлиентеЗавершениеПомещения",
		ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы,, Ложь, ДополнительныеПараметры.Форма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлНаКлиентеЗавершениеПомещения(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено И ПомещенныеФайлы.Количество() > 0 Тогда
		
		ОписаниеФайла = ПомещенныеФайлы.Получить(0);
		АдресФайла    = ОписаниеФайла.Хранение;
		
		Если АдресФайла = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Кодировка = Неопределено;
		Если ЗначениеЗаполнено(ДополнительныеПараметры.Кодировка) Тогда
			Кодировка = ?(ДополнительныеПараметры.Кодировка = "Windows", КодировкаТекста.ANSI, КодировкаТекста.OEM);
		КонецЕсли;
		
		// В ВебКлиенте не выполняем экспресс проверку, так как объект ЧтениеТекста не доступен
		#Если НЕ ВебКлиент Тогда
			Результат = ЭкспрессЧтениеФайла(ОписаниеФайла.Имя, Кодировка);
			Если Результат.НеУдалосьПрочитатьФайл Тогда
				ТекстПредупреждения = НСтр("ru= 'Не удалось прочитать файл, возможно неверно указана кодировка!'");
				ПоказатьПредупреждение(, ТекстПредупреждения);
				Возврат;
			ИначеЕсли НЕ Результат.ЭтоФайлОбмена Тогда
				ТекстПредупреждения = НСтр("ru= 'Указанный файл не является файлом обмена - не найден ключ ""1CClientBankExchange""'");
				ПоказатьПредупреждение(, ТекстПредупреждения);
				Возврат;
			КонецЕсли;
			
			Если Кодировка = Неопределено Тогда
				Кодировка = Результат.Кодировка;
			КонецЕсли;
		#КонецЕсли
		
		ДополнительныеПараметры.Форма.ПрочитатьФайлВыпискиНаКлиенте(ОписаниеФайла, Кодировка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаЗавершение(Результат, АдресФайлаПомещенный, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Ложь ИЛИ АдресФайлаПомещенный = "" Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, АдресФайлаПомещенный);
	ДополнительныеПараметры.Форма.ПрочитатьФайлВыпискиНаКлиенте(ОписаниеФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФайла

// Открывает для просмотра текстовой документ
//
&НаКлиенте
Процедура ОткрытьФайлДляПросмотра(Форма, Элемент, Кодировка, Заголовок) Экспорт
	
	Объект          = Форма.Объект;
	ОбъектПроверки  = Объект[Элемент.Имя];
	ЭлементПривязки = "Объект." + Элемент.Имя;
	Если ПустаяСтрока(ОбъектПроверки) Тогда
		ТекстСоощения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 не заполнен'"), Заголовок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСоощения
			,, ЭлементПривязки);
		
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("Форма, ИмяФайла, Кодировка, Заголовок, ЭлементПривязки", Форма, Элемент.ТекстРедактирования, Кодировка, Заголовок, ЭлементПривязки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраСозданиеФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещения, ДополнительныеПараметры.ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраСозданиеФайла(Файл, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("Файл", Файл);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаСуществования", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		
		ТекстСоощения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 не обнаружен'"), ДополнительныеПараметры.Заголовок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСоощения
			,, ДополнительныеПараметры.ЭлементПривязки);
		
		Возврат;
		
	КонецЕсли;
	
	Файл = ДополнительныеПараметры.Файл;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаНаКаталог", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуЭтоКаталог(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраПроверкаНаКаталог(ЭтоКаталог, ДополнительныеПараметры) Экспорт
	
	Если ЭтоКаталог Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 некорректен - выбран ""каталог"".
			|Выберите %1'"), ДополнительныеПараметры.Заголовок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения
			,, ДополнительныеПараметры.ЭлементПривязки);
		
		Возврат;
		
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайла));
	
	ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраЗавешениеПомещения", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы,, Ложь, ДополнительныеПараметры.Форма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраЗавешениеПомещения(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено И ПомещенныеФайлы.Количество() > 0 Тогда
		ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
		АдресФайла     = ОписаниеФайлов.Хранение;
		
		Если АдресФайла = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Текст = ДополнительныеПараметры.Форма.ТекстовыйДокументИзВременногоХранилищаФайла(АдресФайла, ДополнительныеПараметры.Кодировка);
		Текст.Показать(ДополнительныеПараметры.Заголовок, ДополнительныеПараметры.ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ЭкспрессПроверкаВыбранногоФайла

&НаКлиенте
// Читаем первые строки файла, определяем является ли данный файл - файлом обмена, определяем кодировку.
// 
// Параметры:
//  ОписаниеФайла - ОписаниеПередаваемогоФайла - Также может использоваться структура:
//              ключ - Хранение, значение - Адрес файла на сервере (во временном хранилище)
//              ключ - Имя,      значение - Адрес файла на клиенте
//
// Возвращаемое значение:
//  Структура - содержит результат чтения файла.
//  Ключи     - ЭтоФайлОбмена          - Булево - Признак является ли файл файлом обмена
//            - НеУдалосьПрочитатьФайл - Булево
//            - Кодировка              - КодировкаТекста - Кодировка, в которой сохранен файл
//
Функция ЭкспрессЧтениеФайла(ИмяФайла, ИспользуемаяКодировкаТекста)
	
	// Если кодировка задана в настройке, то выполняем только проверку.
	Если ЗначениеЗаполнено(ИспользуемаяКодировкаТекста) Тогда
		Возврат ЧтениеПервыхСтрокФайлаПоКодировке(ИмяФайла, ИспользуемаяКодировкаТекста);
	КонецЕсли;
	
	Кодировки = Новый Массив;
	Кодировки.Добавить(КодировкаТекста.ANSI);
	Кодировки.Добавить(КодировкаТекста.OEM);
	
	Для каждого Кодировка Из Кодировки Цикл
		РезультатЧтенияФайла = ЧтениеПервыхСтрокФайлаПоКодировке(ИмяФайла, Кодировка);
		Если Не РезультатЧтенияФайла.НеУдалосьПрочитатьФайл Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультатЧтенияФайла;
	
КонецФункции

&НаКлиенте
Функция ЧтениеПервыхСтрокФайлаПоКодировке(ИмяФайла, Кодировка)
	
	РезультатЧтенияФайла = НовыйРезультатЧтенияФайла();
	
	Если Кодировка = КодировкаТекста.ANSI Тогда
		Кодир = "windows-1251";
	ИначеЕсли Кодировка = КодировкаТекста.OEM Тогда
		Кодир = "cp866";
	Иначе
		РезультатЧтенияФайла.НеУдалосьПрочитатьФайл = Истина;
		Возврат РезультатЧтенияФайла;
	КонецЕсли;
	
	НомерТекущейСтроки = 0;
	
	Текст = Новый ЧтениеТекста(ИмяФайла, Кодир);
	СтрокаТекста = Текст.ПрочитатьСтроку();
	Пока СтрокаТекста <> Неопределено Цикл
		
		// Проверяем кодировку файла
		Если НЕ ОбменСБанкомКлиентСервер.ТолькоСимволыВСтроке(СтрокаТекста) Тогда
			РезультатЧтенияФайла.НеУдалосьПрочитатьФайл = Истина;
			Прервать;
		КонецЕсли;
		
		// Читаем первые пять строк, этого должно быть достаточно,
		// чтобы определить кодировку и найти ключ 1CClientBankExchange
		Если НомерТекущейСтроки > 5 Тогда
			Прервать;
		КонецЕсли;
		
		ДанныеСтроки = РазложитьСтроку(СтрокаТекста);
		
		Если Врег(ДанныеСтроки.Ключ) = Врег("1CClientBankExchange") Тогда
			РезультатЧтенияФайла.ЭтоФайлОбмена = Истина;
		КонецЕсли;
		
		НомерТекущейСтроки = НомерТекущейСтроки + 1;
		СтрокаТекста = Текст.ПрочитатьСтроку();
		
	КонецЦикла;
	
	РезультатЧтенияФайла.Кодировка = Кодировка;
	
	Возврат РезультатЧтенияФайла;
	
КонецФункции

&НаКлиенте
Функция НовыйРезультатЧтенияФайла()
	
	РезультатЧтенияФайла = Новый Структура;
	РезультатЧтенияФайла.Вставить("ЭтоФайлОбмена",          Ложь);
	РезультатЧтенияФайла.Вставить("НеУдалосьПрочитатьФайл", Ложь);
	РезультатЧтенияФайла.Вставить("Кодировка",              Неопределено);
	
	Возврат РезультатЧтенияФайла;
	
КонецФункции

&НаКлиенте
// Функция возвращает структуру строки из файла
// Параметры:
// Строка - Строка - Текстовая строка, прочитанная из файла
// Возвращаемое значение
// Структура:
//    Ключ     - Идентификатор из строки
//    Значение - Значение из строки
//
Функция РазложитьСтроку(Строка)
	
	Результат = Новый Структура;
	Результат.Вставить("Ключ",     "");
	Результат.Вставить("Значение", "");
	
	ПозицияРавно = СтрНайти(Строка, "=");
	Если ПозицияРавно = 0 Тогда
		Результат.Ключ = Строка;
	Иначе
		Результат.Ключ     = Лев(Строка,  ПозицияРавно - 1);
		Результат.Значение = Сред(Строка, ПозицияРавно + 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти