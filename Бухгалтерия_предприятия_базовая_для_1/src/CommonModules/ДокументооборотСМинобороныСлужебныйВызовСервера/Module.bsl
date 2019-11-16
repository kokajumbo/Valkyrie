#Область СлужебныйПрограммныйИнтерфейс

// Возвращает отдельные свойства сертификата в формате X.509 в соответствие с https://tools.ietf.org/html/rfc5280.
//
// Параметры:
//   ДанныеСертификата - ДвоичныеДанные, Строка - файл (двоичные данные, адрес во временном хранилище или строка Base64
//                                                при Настройки.ЭтоСтрокаBase64 = Истина) в формате X.509.
//   Настройки - Неопределено - настройки по умолчанию.
//             - Структура:
//     ЭтоЭлектроннаяПодписьВМоделиСервиса - Булево - по умолчанию Истина, влияет на имя события при записи в журнал регистрации.
//     ЭтоСтрокаBase64                     - Булево - по умолчанию Ложь, при Истина ДанныеСертификата задает строку Base64.
//     ВозможенФорматBase64                - Булево - по умолчанию Ложь, при Истина двоичные данные в ДанныеСертификата
//                                                    могут быть в формате Base64, в том числе с заголовками сертификата,
//                                                    корректность чтения определяется по прочитанному алгоритму
//     ВозвращатьИсключения                - Булево - по умолчанию Истина, генерировать исключения при неверной структуре данных.
//
// Возвращаемое значение:
//   Структура - свойства криптосообщения.
//     Размер                  - Число - размер файла в байтах.
//     Версия                  - Число - версия формата сертификата, 0 - v1, 1 - v2, 2 - v3.
//     СерийныйНомер           - ДвоичныеДанные - серийный номер сертификата.
//     АлгоритмПубличногоКлюча - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512"
//                                        или OID нераспознанного алгоритма.
//
Функция ПолучитьСвойстваСертификата(Знач ДанныеСертификата, Настройки = Неопределено) Экспорт
	
	НастройкиВызова = Новый Структура;
	НастройкиВызова.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", Ложь);
	НастройкиВызова.Вставить("ЭтоСтрокаBase64", 					Ложь);
	НастройкиВызова.Вставить("ВозможенФорматBase64", 				Ложь);
	НастройкиВызова.Вставить("ВозвращатьИсключения", 				Ложь);
	Если Настройки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НастройкиВызова, Настройки);
	КонецЕсли;
	
	СвойстваСертификата = Новый Структура;
	СвойстваСертификата.Вставить("Размер", 					0);
	СвойстваСертификата.Вставить("Версия", 					0);
	СвойстваСертификата.Вставить("СерийныйНомер", 			0);
	СвойстваСертификата.Вставить("АлгоритмПубличногоКлюча", "");
	
	Если НастройкиВызова.ЭтоСтрокаBase64 Тогда
		ДанныеСертификата = Base64Значение(ДанныеСертификата);
	ИначеЕсли ТипЗнч(ДанныеСертификата) = Тип("Строка") И ЭтоАдресВременногоХранилища(ДанныеСертификата) Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(ДанныеСертификата);
	КонецЕсли;
	
	СвойстваСертификата.Размер = ДанныеСертификата.Размер();
	
	Если НастройкиВызова.ВозможенФорматBase64 И СвойстваСертификата.Размер < 65536 Тогда
		НастройкиВызова.ЭтоСтрокаBase64 		= Ложь;
		НастройкиВызова.ВозможенФорматBase64 	= Ложь;
		СвойстваСертификата = ПолучитьСвойстваСертификата(ДанныеСертификата, НастройкиВызова);
		
		Если НЕ ЗначениеЗаполнено(СвойстваСертификата.АлгоритмПубличногоКлюча) Тогда
			ОбъектЧтениеДанных = Новый ЧтениеДанных(ДанныеСертификата, "windows-1251");
			Попытка
				ТекстСертификата = ОбъектЧтениеДанных.ПрочитатьСимволы();
			Исключение
				ИмяСобытия = ?(НастройкиВызова.ЭтоЭлектроннаяПодписьВМоделиСервиса,
					НСтр("ru = 'Электронная подпись в модели сервиса.Сервис криптографии.Чтение сертификата'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					НСтр("ru = 'Сервис криптографии.Чтение сертификата'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
				ЗаписьЖурналаРегистрации(
					ИмяСобытия,
					УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				Если НастройкиВызова.ВозвращатьИсключения Тогда
					ВызватьИсключение;
				КонецЕсли;
			КонецПопытки;
			ОбъектЧтениеДанных.Закрыть();
			
			ТекстСертификата = СокрЛП(ТекстСертификата);
			Если СтрНачинаетсяС(ТекстСертификата, "-----BEGIN CERTIFICATE-----")
				И СтрЗаканчиваетсяНа(ТекстСертификата, "-----END CERTIFICATE-----") Тогда
				ДлинаТекстаСертификата = СтрДлина(ТекстСертификата);
				ТекстСертификата = Сред(ТекстСертификата, 28, ДлинаТекстаСертификата - 52);
				ТекстСертификата = СокрЛП(ТекстСертификата);
			КонецЕсли;
			
			НастройкиВызова.ЭтоСтрокаBase64 		= Истина;
			НастройкиВызова.ВозможенФорматBase64 	= Ложь;
			СвойстваСертификата = ПолучитьСвойстваСертификата(ТекстСертификата, НастройкиВызова);
		КонецЕсли;
		
		Возврат СвойстваСертификата;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СвойстваСертификата.Размер) Тогда
		Возврат СвойстваСертификата;
	КонецЕсли;
	
	ОбъектЧтениеДанных = Новый ЧтениеДанных(ДанныеСертификата);
	Попытка
		// https://tools.ietf.org/html/rfc5280#section-4
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // Certificate ::= SEQUENCE...
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // TBSCertificate ::= SEQUENCE...
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 2 Тогда
			Если СвойстваБлока.Класс <> "CONTEXT-SPECIFIC" ИЛИ СвойстваБлока.Тег <> 0 Тогда // version [0] EXPLICIT Version DEFAULT v1
				ОбъектЧтениеДанных.Закрыть();
				Возврат СвойстваСертификата;
			КонецЕсли;
			
			СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		КонецЕсли;
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 2 Тогда // Version ::= INTEGER {v1(0), v2(1), v3(2)}
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		
		ВерсияСертификата = ПрочитатьЦелоеЧисло(ОбъектЧтениеДанных, СвойстваБлока);
		Если ВерсияСертификата < 0 ИЛИ ВерсияСертификата > 2 Тогда
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		СвойстваСертификата.Версия = ВерсияСертификата;
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		СвойстваСертификата.СерийныйНомер = ПрочитатьДвоичныеДанные(ОбъектЧтениеДанных,
			СвойстваБлока); // serialNumber CertificateSerialNumber ::= INTEGER
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // signature AlgorithmIdentifier = SEQUENCE {...}
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		ПропуститьБлок(ОбъектЧтениеДанных, СвойстваБлока.РазмерБлока);
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // issuer RDNSequence ::= SEQUENCE {...}
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		ПропуститьБлок(ОбъектЧтениеДанных, СвойстваБлока.РазмерБлока);
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // validity Validity ::= SEQUENCE {...}
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		ПропуститьБлок(ОбъектЧтениеДанных, СвойстваБлока.РазмерБлока);
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // subject RDNSequence ::= SEQUENCE {...}
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		ПропуститьБлок(ОбъектЧтениеДанных, СвойстваБлока.РазмерБлока);
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // subjectPublicKeyInfo SubjectPublicKeyInfo ::= SEQUENCE...
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		
		СвойстваБлока = ПрочитатьСвойстваБлока(ОбъектЧтениеДанных, СвойстваСертификата.Размер);
		Если СвойстваБлока.Класс <> "UNIVERSAL" ИЛИ СвойстваБлока.Тег <> 16 Тогда // algorithm AlgorithmIdentifier = SEQUENCE...
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		
		АлгоритмПубличногоКлюча = ПрочитатьAlgorithmIdentifier(ОбъектЧтениеДанных, СвойстваСертификата, СвойстваБлока, Истина);
		Если АлгоритмПубличногоКлюча = Неопределено Тогда
			ОбъектЧтениеДанных.Закрыть();
			Возврат СвойстваСертификата;
		КонецЕсли;
		СвойстваСертификата.АлгоритмПубличногоКлюча = АлгоритмПубличногоКлюча;
	Исключение
		ИмяСобытия = ?(НастройкиВызова.ЭтоЭлектроннаяПодписьВМоделиСервиса,
			НСтр("ru = 'Электронная подпись в модели сервиса.Сервис криптографии.Чтение сертификата'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			НСтр("ru = 'Сервис криптографии.Чтение сертификата'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если НастройкиВызова.ВозвращатьИсключения Тогда
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	ОбъектЧтениеДанных.Закрыть();
	
	Возврат СвойстваСертификата;
	
КонецФункции

Функция ИзвлечьКриптопровайдер(Сертификат) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("cer");
	Сертификат.Записать(ИмяВременногоФайла);
	
	Байты = ПрочитатьФайлВМассив(ИмяВременногоФайла);
	
	БайтыСигнатурыПоиска = Новый Массив; // Ищем OID 1.2.643.100.111
	БайтыСигнатурыПоиска.Добавить(6);
	БайтыСигнатурыПоиска.Добавить(5);
	БайтыСигнатурыПоиска.Добавить(42);
	БайтыСигнатурыПоиска.Добавить(133);
	БайтыСигнатурыПоиска.Добавить(3);
	БайтыСигнатурыПоиска.Добавить(100);
	БайтыСигнатурыПоиска.Добавить(111);
	
	Индекс = 0;
	ИндексНачалаСигнатуры = 0;
	СигнатураНайдена = Ложь;
	Для Каждого Байт Из Байты Цикл
		Если Байт = БайтыСигнатурыПоиска[0] Тогда
			СигнатураНайдена = Истина;
			Для Индекс2 = 1 По 6 Цикл
				Если Байты[Индекс2 + Индекс] <> БайтыСигнатурыПоиска[Индекс2] Тогда
					СигнатураНайдена = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если СигнатураНайдена Тогда
				ИндексНачалаСигнатуры = Индекс;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Криптопровайдер = "";
	Если СигнатураНайдена Тогда
		КоличествоБайтПодТекст = Байты[ИндексНачалаСигнатуры + БайтыСигнатурыПоиска.Количество() + 1];
		НачалоТекста = ИндексНачалаСигнатуры + БайтыСигнатурыПоиска.Количество() + 4;
		
		БайтыДляЗаписи = Новый Массив;
		Для Индекс = НачалоТекста По НачалоТекста + КоличествоБайтПодТекст - 3 Цикл
			БайтыДляЗаписи.Добавить(Байты[Индекс]);
		КонецЦикла;
		
		ИмяФайла = ПолучитьИмяВременногоФайла("txt");
		ЗаписатьФайлИзМассива(ИмяФайла, БайтыДляЗаписи);
		
		ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, "utf-8");
		Криптопровайдер = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ИмяФайла);
	КонецЕсли;
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ИмяВременногоФайла);
	
	Если СтрНайти(НРег(Криптопровайдер), "cryptopro") ИЛИ СтрНайти(НРег(Криптопровайдер), "криптопро") Тогда
		Криптопровайдер = ДокументооборотСМинобороныКлиентСервер.КриптопровайдерCryptoPro();
	ИначеЕсли СтрНайти(НРег(Криптопровайдер), "vipnet") ИЛИ СтрНайти(НРег(Криптопровайдер), "випнет") Тогда
		Криптопровайдер = ДокументооборотСМинобороныКлиентСервер.КриптопровайдерViPNet();
	Иначе
		Криптопровайдер = Неопределено;
	КонецЕсли;
			
	Возврат Криптопровайдер;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьФайлИзМассива(ИмяФайла, Массив)
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, "ISO-8859-1", Символы.ПС,, Символы.ПС);
	
	Для ИндексВМассиве = 0 По Массив.ВГраница() Цикл
		СимволИзМассива = Символ(Массив[ИндексВМассиве]);
		ЗаписьТекста.Записать(СимволИзМассива);
	КонецЦикла;
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Функция ПрочитатьФайлВМассив(ИмяФайла)
	
	Результат = Новый Массив;
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, "ISO-8859-1", Символы.ПС, Символы.ПС);
	
	Пока Истина Цикл
		СимволТекста = ЧтениеТекста.Прочитать(1);
		Если СимволТекста = Неопределено Тогда
			Прервать;
		КонецЕсли;
		КодСимволаТекста = КодСимвола(СимволТекста);
		
		Результат.Добавить(КодСимволаТекста);
	КонецЦикла;
	ЧтениеТекста.Закрыть();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ФункцииЧтенияPKCS7

Функция ПрочитатьAlgorithmIdentifier(ЧтениеДанных, СвойстваКриптосообщения, Свойства = Неопределено, ПроверитьТип = Ложь)
	
	Если Свойства = Неопределено Тогда
		Свойства = ПрочитатьСвойстваБлока(ЧтениеДанных, СвойстваКриптосообщения.Размер);
	КонецЕсли;
	КонецБлока = Свойства.РазмерБлока + ЧтениеДанных.ИсходныйПоток().ТекущаяПозиция();
	Свойства = ПрочитатьСвойстваБлока(ЧтениеДанных, СвойстваКриптосообщения.Размер);
	Если ПроверитьТип И (Свойства.Класс <> "UNIVERSAL" ИЛИ Свойства.Тег <> 6) Тогда // algorithm OBJECT IDENTIFIER
		Возврат Неопределено;
	КонецЕсли;
	ИдентификаторАлгоритма = ПрочитатьОбъектныйИдентификатор(ЧтениеДанных, Свойства);
	
	ПропуститьБлок(ЧтениеДанных, КонецБлока - ЧтениеДанных.ИсходныйПоток().ТекущаяПозиция());
	
	ОбъектныеИдентификаторы = Новый Соответствие;
	ОбъектныеИдентификаторы.Вставить("1.2.643.2.2.9", "GOST R 34.11-94");
	ОбъектныеИдентификаторы.Вставить("1.2.643.2.2.19", "GOST R 34.10-2001");
	
	ОбъектныеИдентификаторы.Вставить("1.2.643.7.1.1.1.1", "GOST R 34.10-2012-256");
	ОбъектныеИдентификаторы.Вставить("1.2.643.7.1.1.1.2", "GOST R 34.10-2012-512");
	ОбъектныеИдентификаторы.Вставить("1.2.643.7.1.1.2.2", "GOST R 34.11-2012-256");
	ОбъектныеИдентификаторы.Вставить("1.2.643.7.1.1.2.3", "GOST R 34.11-2012-512");
	ОбъектныеИдентификаторы.Вставить("1.2.643.7.1.1.3.2", "GOST R 34.10-2012-256 + GOST R 34.11-2012-256");
	ОбъектныеИдентификаторы.Вставить("1.2.643.7.1.1.3.3", "GOST R 34.10-2012-512 + GOST R 34.11-2012-512");
	
	Идентификатор = ОбъектныеИдентификаторы.Получить(ИдентификаторАлгоритма);
	Если Идентификатор = Неопределено Тогда
		Идентификатор = ИдентификаторАлгоритма;
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

#КонецОбласти

#Область БазовыеФункцииЧтенияASN1

Функция ПрочитатьДвоичныеДанные(ЧтениеДанных, Свойства)
	
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Свойства.РазмерБлока);
	Поток = Новый ПотокВПамяти(Буфер);
	
	Возврат Поток.ЗакрытьИПолучитьДвоичныеДанные();
	
КонецФункции

Функция ПрочитатьЦелоеЧисло(ЧтениеДанных, Свойства)
	
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Свойства.РазмерБлока);
	Значение = 0;
	Для Каждого Байт Из Буфер Цикл
		Значение = Значение * 256 + Байт;
	КонецЦикла;
	
	Возврат Значение;
	
КонецФункции

Функция ПрочитатьОбъектныйИдентификатор(ЧтениеДанных, Свойства)
	
	ОбъектныйИдентификатор = Новый Массив;
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Свойства.РазмерБлока);
	Если Буфер[0] < 40 Тогда
		SID1 = 0;
	ИначеЕсли Буфер[0] < 80 Тогда
		SID1 = 1;
	Иначе
		SID1 = 2;
	КонецЕсли;
	ОбъектныйИдентификатор.Добавить(Формат(SID1, "ЧРГ=; ЧГ="));
	
	// SID2
	ОбъектныйИдентификатор.Добавить(Буфер[0] - SID1 * 40);
	
	// Остальные SID
	Для Индекс = 1 По Буфер.Размер - 1 Цикл
		ОбъектныйИдентификатор.Добавить(Формат(ПрочитатьСоставляющуюОбъектногоИдентификатора(Буфер, Индекс), "ЧРГ=; ЧГ="));
	КонецЦикла;
	
	Возврат СтрСоединить(ОбъектныйИдентификатор, ".");
		
КонецФункции

Функция ПрочитатьСоставляющуюОбъектногоИдентификатора(Буфер, ТекущийБайт)
	
	МаскаЗначащиеБиты = 127; // 0111 1111
	МаскаСтаршийБит = 128;   // 1000 0000
	
	Множители = Новый Массив;	
	Пока Истина Цикл
		Байт = Буфер[ТекущийБайт];
		ДлинныйРазмер = Булево(ПобитовоеИ(Буфер[ТекущийБайт], МаскаСтаршийБит));
	 	Если ДлинныйРазмер Тогда
			Множители.Добавить(ПобитовоеИ(Буфер[ТекущийБайт], МаскаЗначащиеБиты))
		Иначе
			Множители.Добавить(Байт);
			Прервать;
		КонецЕсли;
		
		ТекущийБайт = ТекущийБайт + 1;
		Если ТекущийБайт > Буфер.Размер Тогда
			ВызватьИсключение("Ошибка разбора OID");
		КонецЕсли;
	КонецЦикла;
	
	Результат = 0;
	Для Индекс = 0 По Множители.ВГраница() Цикл
		Показатель = Множители.ВГраница() - Индекс;
		Результат = Результат + Множители[Индекс] * Pow(128, Показатель);
	КонецЦикла;

	Возврат Результат;
	
КонецФункции

Функция КлассТегаБлока(Байт)
	
	МаскаКлассБлока = 192; // 1100 0000	
	Класс = ПобитовоеИ(Байт, МаскаКлассБлока);
	
	Если Класс = 0 Тогда
		Возврат "UNIVERSAL";
	ИначеЕсли Класс = 192 Тогда
		Возврат "PRIVATE";
	ИначеЕсли Класс = 64 Тогда
		Возврат "APPLICATION";
	Иначе
		Возврат "CONTEXT-SPECIFIC";
	КонецЕсли;
	
КонецФункции

Функция ТегБлока(Байт)
	
	МаскаТег = 31; // 0001 1111
	Возврат ПобитовоеИ(Байт, МаскаТег);
	
КонецФункции

Функция ПрочитатьСвойстваБлока(ЧтениеДанных, РазмерДанных)
	
	Свойства = Новый Структура;
	
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(1);
	
	МаскаЗначащиеБиты = 127; // 0111 1111
	МаскаСтаршийБит = 128;   // 1000 0000
	
	Свойства.Вставить("Класс", КлассТегаБлока(Буфер[0]));
	Свойства.Вставить("Тег", ТегБлока(Буфер[0]));
		
	// Прочитать размер блока
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(1);
	Если Буфер[0] = 128 Тогда // Используется потоковый способ кодирования, т.е. размер блока не указан (окончание блока 00 00)
		РазмерБлока = -1;
	Иначе
		ДлинныйРазмер = Булево(ПобитовоеИ(Буфер[0], МаскаСтаршийБит));
		Если ДлинныйРазмер Тогда
			КоличествоБайтовПодРазмер = ПобитовоеИ(Буфер[0], МаскаЗначащиеБиты);
			Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(КоличествоБайтовПодРазмер);
			РазмерБлока = 0;
			Для Каждого Байт Из Буфер Цикл
				РазмерБлока = РазмерБлока * 256 + Байт;
				
				Если РазмерБлока > РазмерДанных Тогда
					ВызватьИсключение("Размер блока превышает размер файла");
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			РазмерБлока = ПобитовоеИ(Буфер[0], МаскаЗначащиеБиты);	
		КонецЕсли;
	КонецЕсли;
	
	Если РазмерБлока > РазмерДанных Тогда
		ВызватьИсключение("Размер блока превышает размер файла");
	КонецЕсли;
	
	Свойства.Вставить("РазмерБлока", РазмерБлока);
	
	Возврат Свойства;
	
КонецФункции

Процедура ПропуститьБлок(ЧтениеДанных, СколькоБайт)
	
	ЧтениеДанных.Пропустить(СколькоБайт);
	
КонецПроцедуры

#КонецОбласти
