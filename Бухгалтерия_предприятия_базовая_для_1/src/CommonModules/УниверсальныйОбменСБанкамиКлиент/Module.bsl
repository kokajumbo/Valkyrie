#Область ПрограммныйИнтерфейс

// Получает отпечаток сертификата, который может использоваться для подписания
// документов организации на указанную дату. 
// Прекращает поиск при нахождении первого подходящего сертификата.
//
// Параметры:
//   ПараметрыОтбора - Структура - структура с полями:
//		* Сервис        - ПеречислениеСсылка.СервисыОбменаСБанками - сервис, для которого подбирается сертификат.
//		* Организация   - СправочникСсылка.Организации - Организация, для которой подбирается сертификат.
//		* Дата          - Дата - Предполагаемая дата использования сертификата.
//	ОповещениеОПодбореСертификата - ОписаниеОповещения - Оповещение, вызываемое после окончания поиска.
//                  Параметры обработчика оповещения:
//			        * РезультатПоискаСертификата - Структура - Содержит ключи:
//				     ** Выполнено - Булево - Истина, если сертификат успешно найден.
//				     ** ОписаниеОшибки - Строка - Текст возникшей ошибки.
//				     ** ОтпечатокСертификата - Строка - Отпечаток найденного сертификата.
//				     ** ЭтоЭлектроннаяПодписьВМоделиСервиса - Булево - Истина, если сертификат является "облачным".
//			        * ДополнительныеПараметры - Произвольный - Дополнительные параметры оповещения.
//
Процедура ПодобратьСертификатОрганизации(ПараметрыОтбора, ОповещениеОПодбореСертификата) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ПодобратьСертификатОрганизации(ПараметрыОтбора, ОповещениеОПодбореСертификата);
	
КонецПроцедуры

// Процедура открывает пользователю форму выбора сертификата криптографии (опционально) и 
// ввода пароля для контейнера закрытого ключа.
//
// Параметры:
//   Сервис        - ПеречислениеСсылка.СервисыОбменаСБанками - сервис, для которого подбирается сертификат.
//   Организация   - СправочникСсылка.Организации - Организация, для которой подбирается сертификат.
//   ОповещенияОбратногоВызова - ОписаниеОповещения - Оповещение, вызываемое после окончания ввода параметров.
//                  Параметры обработчика оповещения:
//			        * РезультатПолученияПараметров - Структура - Содержит ключи:
//				     ** Выполнено - Булево - Истина, если сертификат успешно найден.
//				     ** ОписаниеОшибки - Строка - Текст возникшей ошибки.
//				     ** ОтпечатокСертификата - Строка - Отпечаток найденного сертификата.
//				     ** ЭтоЭлектроннаяПодписьВМоделиСервиса - Булево - Истина, если сертификат является "облачным".
//				     ** ПарольЗакрытогоКлюча - Строка - пароль контейнера закрытого ключа.
//				     ** ОтмененоПользователем - Булево - Истина, если пользователь отменил ввод параметров.
//   ВладелецФормы - УправляемаяФорма - форма владелец окна ввода параметров.
//   ДополнительныеПараметры - Структура - структура с дополнительными параметрами формы, может содежать строковые поля:
//      * ОтображатьПолеВводаПароля    - Булево - Истина, если будет отображаться поле ввода пароля.
//      * ВозможностьВыбораСертификата - Булево - Истина, если возможность выбора сертификата из хранилища.
//      * Заголовок                    - Строка - заголовок формы.
//      * НазваниеКнопки               - Строка - название кнопки по умолчанию.
//      * ПараметрыОтбора              - Структура - параметры отбора серификата см. УниверсальныйОбменСБанкамиКлиентСервер.ПараметрыОтбораСертификата.
//
Процедура ПараметрыКриптографии(Сервис,
		Организация,
		ОповещенияОбратногоВызова,
		ВладелецФормы,
		ДополнительныеПараметры = Неопределено) Экспорт

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Сервис", Сервис);
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("ОтображатьПолеВводаПароля", Истина);
	ПараметрыФормы.Вставить("ВозможностьВыбораСертификата", Истина);
	ПараметрыФормы.Вставить("ПараметрыОтбора", 
		УниверсальныйОбменСБанкамиКлиентСервер.ПараметрыОтбораСертификата(Сервис, Организация));
	ПараметрыФормы.Вставить("Заголовок", "");
	ПараметрыФормы.Вставить("НазваниеКнопки", "");
	
	// У формы могут быть установлены параметры Заголовок и НазваниеКнопки.
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ДополнительныеПараметры);
	КонецЕсли;
	
	ДополнительныеПараметрыФормы = Новый Структура();
	ДополнительныеПараметрыФормы.Вставить("ОписаниеОповещение", ОповещенияОбратногоВызова);
	
	ОповещениеПриЗакрытииФормы = Новый ОписаниеОповещения("ПараметрыКриптографииЗавершение", ЭтотОбъект, ДополнительныеПараметрыФормы);
	
	ОткрытьФорму("ОбщаяФорма.ВводПараметровКриптографииОбменаСБанками",
		ПараметрыФормы,
		ВладелецФормы,
		,
		,
		,
		ОповещениеПриЗакрытииФормы,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

// Выполняет подготовительные действия для возможности работы с сервисом криптографии
// с указанным облачным сертификатом.
//
// Параметры:
//	ОтпечатокСертификата - Строка - Отпечаток сертификата, который планируется использовать в дальнейшем
//    для работы с сервисом криптографии.
//
//  ОписаниеОповещения - ОписаниеОповещения - Обработчик, который будет вызыван после выполнения
//	  инициализации сервиса криптографии. Параметры обработчика:
//		* Результат - Структура - Содержит ключи:
//			** Выполнено - Булево - Истина, если сервис криптографии успешно инициализирован.
//			** ОписаниеОшибки - Строка - Текст ошибки, если возникла.
//
Процедура ИнициализироватьСервисКриптографии(ОтпечатокСертификата, ОписаниеОповещения) Экспорт

	// Чтобы работать с сервисом криптографии, необходимо получение сеансового ключа.
	// Сами действия по подписанию и шифрованию файлов лучше выполнять в фоновом задании,
	// т.к. они могут быть занимать длительное время, но сеансовый ключ необходимо получить
	// в клиенском сеансе, т.к. для этого требуется подтверждение по sms от пользователя.
	// Чтобы получить сеансовый ключ, вызываем функцию Подписать() сервиса криптографии для произвольной строки.
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	
	ДанныеДляПодписания = ПолучитьДвоичныеДанныеИзСтроки("ТестоваяСтрокаДляПодписания"); 
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ИнициализацияСервисаКриптографиииЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
	Подписант = Новый Структура();
	Подписант.Вставить("Отпечаток", ОтпечатокСертификата);
	
	СервисКриптографииКлиент.Подписать(ОповещениеОЗавершении, ДанныеДляПодписания, Подписант);

КонецПроцедуры

// Возвращает структурe с параметрами для процедуры ПодготовитьТранзакцию().
// 
// Возвращаемое значение:
//	Структура - См. переменную Результат.
//
Функция ПараметрыПодготовкиТранзакции() Экспорт

	Результат = Новый Структура();
	
	Результат.Вставить("Сервис"); // Сервис обмена с банками, тип ПеречислениеСсылка.СервисыОбменаСБанками.
	Результат.Вставить("ИдентификаторДокументооборота", ""); // Документооборот, в рамках которого будет передаваться транспортный контейнер.
	Результат.Вставить("Предмет");                  // Ссылка на объект, с которым связан транспортный контейнер в базе данных.
	Результат.Вставить("Форма");                    // Управляемая форма, из которой вызывается процедура.
	Результат.Вставить("Организация");              // Организация, для которой готовится контейнер.
	Результат.Вставить("ИдентификаторВременногоХранилища",   ""); // идентификатор регистра сведений ЖурналОперацийСФайламиОбменаСБанками

	Результат.Вставить("СертификатПодписи",   "");  // Отпечаток сертификата или пусто, если требуется вывод окна запроса сертификата.
	Результат.Вставить("ПарольДоступаКЗакрытомуКлючу",  Неопределено);  // Строка или Неопределено, если требуется вывод окна запроса сертификата.
	Результат.Вставить("ПроверятьПринадлежностьСертификатаОрганизации",  Истина);  // Если Истина, то будет будет проверяться соответствии ИНН организации и ИНН в сертификате.
	Результат.Вставить("ПараметрыПроверкиСертификата", Неопределено); // Параметры проверки сертификата перед подписанием.

	Результат.Вставить("ОповещениеОПрогрессеВыполнения");

	Возврат Результат;

КонецФункции

// Подготавливает транспортный контейнер и транзакцию для отправки на сервер.
// Подготовка включает подписание, шифрование и упаковку всех вложений в один архив для передачи.
//
// Параметры:
//	ОписаниеОповещенияОЗавершении - ОписаниеОповещения - Оповещение, вызываемое после завершения процесса подготовки.
//		В обработчик оповещения передаются:
//			* Результат - Структура с ключами:
//				** Выполнено - Булево - Содержит признак успешного выполнения.
//				** ОписаниеОшибки - Строка - Содержит описание возникшей ошибки.
//				** Документооборот - СправочникСсылка.ДокументооборотыОбменаСБанками - Созданный документооборот.
//				** Транзакция - СправочникСсылка.ТранзакцииОбменаСБанками - Созданная транзакция.
//
//	Параметры - Структура - см. ПараметрыПодготовкиТранзакции().
//	
Процедура ПодготовитьТранзакцию(ОписаниеОповещенияОЗавершении, Параметры) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ПодготовитьТранзакцию(ОписаниеОповещенияОЗавершении, Параметры);
	
КонецПроцедуры

// Возвращает структурe с параметрами для процедуры РасшифроватьНерасшифрованныеТранзакции().
//
// Возвращаемое значение:
//  Структура - см. переменную Результат.
//
Функция ПараметрыРасшифроватьНерасшифрованныеТранзакции() Экспорт
	
	Результат = Новый Структура();
	
	// Обработчик, вызываем после завершения обработки всех транзакций.
	// Параметры обработчика:
	//	Результат - Массив - Элементами являются структуры с ключами:
	//		* Транзакция - СправочникСсылка.ТранзакцииОбменаСБанками - Ссылка на транзакцию.
	//		* Расшифровано - Булево - Истина, если успешно расшифровано.
	//		* ПодписьВалидна - Булево - Истина, если подпись отправителя валидна.
	//		* ОписаниеОшибки - Строка - Текст ошибки, если возникла.
	//	ДополнительныеПараметры - Доп. параметры обработчика.
	Результат.Вставить("Сервис", Неопределено);
	Результат.Вставить("Организация", Неопределено);
	Результат.Вставить("ТранзакцииДляРасшифровки", Неопределено);

	// Обработчик, которая будет вызываться для отображения прогресса выполнения (необязательный).
	// Параметры обработчика:
	// 	Результат - Структура с ключами:
	//		* КоличествоЭлементов - Число - общее число элементов в массиве транзакций.
	//		* Индекс - Число - Индекс транзакции из общего массив обрабатываемых транзакций.
	//		* Транзакция - СправочникСсылка.ТранзакцииОбменаСБанками - Ссылка на справочник транзакций обмена, который сейчас обрабатывается.
	//		* ВыполненноеДействие - Строка - одно из значений: "СкачиваниеССервера", "Расшифровка", "ПроверкаПодписи", "ЗагрузкаНаСервер".
	//		* Выполнено - Булево - Признак успешного выполнения.
	//		* ОписаниеОшибки - Строка - Текст ошибки, если возникла.
	// ДополнительныеПараметры - Доп. параметры обработчика.
	Результат.Вставить("ОповещениеОПрогрессеВыполнения");

	Возврат Результат;

КонецФункции

// Выполняет расшифровку и проверку подписи для транзакций обмена с банками.
//
// Параметры:
//  ОповещениеОбратногоВызова - Оповещение - оповещение возврата из процедуры.
//	Параметры - Структура - См. ПараметрыРасшифроватьНерасшифрованныеТранзакции()
//
Процедура РасшифроватьНерасшифрованныеТранзакции(ОповещениеОбратногоВызова, Параметры) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.РасшифроватьНерасшифрованныеТранзакции(ОповещениеОбратногоВызова, Параметры);
	
КонецПроцедуры

// Выполняет расшифровку данных для транзакции обмена с банками.
//
// Параметры:
//  ОповещениеОбратногоВызова - Оповещение - оповещение возврата из процедуры.
//	Транзакция - СправочникСсылка.ТранзакцииОбменаСБанками - Ссылка на транзакцию.
//	КэшСертификатов - Соответствие - Используется для кэширования сертификатов между вызовами.
//
Процедура РасшифроватьДанныеТранзакции(ОповещениеОбратногоВызова, Транзакция, КэшСертификатов = Неопределено) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.РасшифроватьДанныеТранзакции(ОповещениеОбратногоВызова, Транзакция, КэшСертификатов);
	
КонецПроцедуры

// Возвращает признак доступности работы с объектами ЧтениеZIPФайла и ЗаписьZIPФайла из клиентского контекста.
//
// Возвращаемое значение:
//	Булево - Истина, если работа с объектами ZIP доступна.
//
Функция ДоступнаРаботаСZIPАрхивом() Экспорт

	Возврат УниверсальныйОбменСБанкамиСлужебныйКлиент.ДоступнаРаботаСZIPАрхивом();
	
КонецФункции

// Открывает форму этапов отправки документооборота.
// Параметры:
//   Документооборот - СправочникСсылка.ДокументооборотыОбменаСБанками - ссылка на документооборот
//   ДополнительныеПараметры - Структура - структура параметров с необязательными ключами:
//     * Наименование - Строка - наименование документооборота на форме.
//   ПараметрыФормы - Структура - структура параметров с необязательными ключами, 
//     в качестве ключей передаются параметры функции ОткрытьФорму: РежимОткрытияОкна, Владелец, Уникальность, Окно, ОписаниеОповещенияОЗакрытии
//   
Процедура ПоказатьФормуСостоянияДокументооборота(Документооборот, ДополнительныеПараметры = Неопределено, ПараметрыФормы = Неопределено) Экспорт
		
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("Ссылка", Документооборот);
	
	Если ПараметрыФормы <> Неопределено Тогда
		Если ПараметрыФормы.Свойство("РежимОткрытияОкна") Тогда
			РежимОткрытияОкна = ПараметрыФормы.РежимОткрытияОкна;
		Иначе
			РежимОткрытияОкна = Неопределено;
		КонецЕсли;
		
		Если ПараметрыФормы.Свойство("Владелец") Тогда
			Владелец = ПараметрыФормы.Владелец;
		Иначе
			Владелец = Неопределено;
		КонецЕсли;
		
		Если ПараметрыФормы.Свойство("Уникальность") Тогда
			Уникальность = ПараметрыФормы.Уникальность;
		Иначе
			Уникальность = Неопределено;
		КонецЕсли;
		
		Если ПараметрыФормы.Свойство("Окно") Тогда
			Окно = ПараметрыФормы.Окно;
		Иначе
			Окно = Неопределено;
		КонецЕсли;
		
		Если ПараметрыФормы.Свойство("ОписаниеОповещенияОЗакрытии") Тогда
			ОписаниеОповещенияОЗакрытии = ПараметрыФормы.ОписаниеОповещенияОЗакрытии;
		Иначе
			ОписаниеОповещенияОЗакрытии = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаСостоянияДокументооборотаОбменаСБанками",
		ДополнительныеПараметры,
		Владелец,
		Уникальность,
		Окно,
		,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкна);
	
КонецПроцедуры

// Открывает сертификат для просмотра в специализированной форме.
//
// Параметры:
//  Сертификат - Структура
//    * СерийныйНомер - Строка - серийный номер сертификата.
//    * Поставщик     - Строка - издатель сертификата.
//    * Отпечаток     - Строка - отпечаток сертификата. Используется для поиска сертификата если не указаны СерийныйНомер и Поставщик.
//    * Адрес         - Строка - адрес файла сертификата.
//
//	ФормаВладелец - УправляемаяФорма - владелец формы.
//
Процедура ПоказатьСертификат(Сертификат, ФормаВладелец = Неопределено) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ПоказатьСертификат(Сертификат, ФормаВладелец);
	
КонецПроцедуры

// Открывает окно выбора сертификата.
//
// Параметры:
//	ОповещенияОЗавершение - ОписаниеОповещения - Оповещение, которое необходимо вызвать после выбора.
//	НачальноеЗначениеВыбора - Строка, Массив из Строка - Отпечаток сертификата, которые выбран по умолчанию.
//	ПараметрыОтбора - Структура - Параметры отбора сертификатов, см. УниверсальныйОбменСБанкамиКлиентСервер.ПараметрыОтбораСертификата().
//
Процедура ВыбратьСертификат(ОповещенияОЗавершение, НачальноеЗначениеВыбора, ПараметрыОтбора) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ВыбратьСертификат(ОповещенияОЗавершение, НачальноеЗначениеВыбора, ПараметрыОтбора);
	
КонецПроцедуры

// Процедура - Отображает представления сертификатов в полях ввода
//
// Параметры:
//  ВыполняемоеОповещение	- ОписаниеОповещения - Описание процедуры, принимающей результат (не обязательный).
//  ПараметрыОтображения 	- Структура - описание параметров отображения сертификатов
//		* ПолеВвода         - ПолеФормы - поле формы, в котором выводится представление сертификата.
//										  Будет подкрашено красным, если в сертификате есть ошибка.
//  	* Сертификат - Строка - отпечаток сертификата.
//		* ИмяРеквизитаПредставлениеСертификата - Строка - имя реквизита представления сертификат.
//		* Форма								   - УправляемаяФорма - форма, в которой выводится представление сертификата.
//		* ЭтоЭлектроннаяПодписьВМоделиСервиса  - Булево - определяет системное хранилище: локальное или защищенное хранилище на сервере.
//		* ТекстПодсказкиПоСертификату - Строка - текст подсказки для сертификата.
//
Процедура ОтобразитьПредставлениеСертификата(ВыполняемоеОповещение = Неопределено, ПараметрыОтображения) Экспорт
		
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ОтобразитьПредставлениеСертификата(
		ВыполняемоеОповещение,
		ПараметрыОтображения);
		
КонецПроцедуры

// Возвращает признак того, что указанный сертификат является облачным.
//
// Параметры:
//	Отпечаток - Строка - Отпечаток проверяемого сертификата.
//
// Возвращаемое значение:
//	Булево - Истина, если сертификат является облачным, иначе Ложь.
//
Функция ЭтоОблачныйСертификатПользователя(Отпечаток) Экспорт
	
	Возврат УниверсальныйОбменСБанкамиСлужебныйКлиент.ЭтоОблачныйСертификатПользователя(Отпечаток);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Криптография

// Создает и возвращает менеджер криптографии (на клиенте) для указанной программы.
Процедура СоздатьМенеджерКриптографии(Оповещение, СвойстваПрограммы) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.СоздатьМенеджерКриптографии(Оповещение, СвойстваПрограммы);
	
КонецПроцедуры

// ищет сертификат в хранилище сертификатов по отпечатку
// Параметры:
//  ОписаниеОповещениеВозврата - ОписаниеОповещения - описание процедуры, принимающей результат
//  Отпечаток - Строка - отпечаток сертификата
//  МенеджерКриптографии - МенеджерКриптографии - менеджер криптографии для поиска сертификата (не обязательный)
Процедура НайтиСертификатПоОтпечатку(
	ОписаниеОповещениеВозврата,
	Отпечаток,
	МенеджерКриптографии = Неопределено,
	ТипХранилища = Неопределено) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.НайтиСертификатПоОтпечатку(
		ОписаниеОповещениеВозврата,
		Отпечаток,
		МенеджерКриптографии,
		ТипХранилища);
	
КонецПроцедуры

Функция ПараметрыПодписать() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("МенеджерКриптографии", Неопределено);
	Параметры.Вставить("Сертификат", Неопределено);
	Параметры.Вставить("Данные", Неопределено);
	Параметры.Вставить("ПарольДоступаКЗакрытомуКлючу", Неопределено);
	Параметры.Вставить("ЭтоОблачныйСертификат", Ложь);
	Параметры.Вставить("ВключениеСертификатовВПодпись", Неопределено);
	 
	Возврат Параметры;
	
КонецФункции

Процедура Подписать(Оповещение, ПараметрыПодписи) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.Подписать(Оповещение, ПараметрыПодписи);
	
КонецПроцедуры

Процедура Зашифровать(Оповещение, ПараметрыШифрования) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.Зашифровать(Оповещение, ПараметрыШифрования);
	
КонецПроцедуры

Процедура ПолучитьСертификаты(ОписаниеОповещения, Параметры) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ПолучитьСертификаты(ОписаниеОповещения, Параметры);
	
КонецПроцедуры

Процедура ПроверитьПодпись(Оповещение, ИсходныеДанные, Подпись) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ПроверитьПодпись(Оповещение, ИсходныеДанные, Подпись);
	
КонецПроцедуры

Функция ПараметрыОтобразитьПредставленияСертификатов() Экспорт
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода");
	ПараметрыОтображенияСертификата.Вставить("Сертификат");
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", "");
	ПараметрыОтображенияСертификата.Вставить("Форма");
	ПараметрыОтображенияСертификата.Вставить("ЭтоОблачныйСертификат", Ложь);
	ПараметрыОтображенияСертификата.Вставить("ТекстПодсказкиПоСертификату", Неопределено);
	
	Возврат ПараметрыОтображенияСертификата;
	
КонецФункции

// Выполняет проверку сертификата.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено            - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписаниеОшибки       - Строка - описание ошибки выполнения.
//      * Валиден              - Булево - сертификат соответствует требованиям проверки.
//
//  Сертификат - Структура - описание сертификата.
//    * СерийныйНомер - Строка - серийный номер сертификата.
//    * Поставщик     - Строка - издатель сертификата.
//    * Отпечаток     - Строка - отпечаток сертификата. Используется для поиска сертификата если не указаны СерийныйНомер и Поставщик.
//
//  Параметры - Структура - структура с полями:
//    * РежимПроверки   - РежимПроверкиСертификатаКриптографии  - задает режим проверки сертификата криптографии.
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ПроверитьСертификат(ОповещениеОЗавершении, Сертификат, Параметры = Неопределено, ВыводитьСоообщения = Истина) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ПроверитьСертификат(ОповещениеОЗавершении, Сертификат, Параметры, ВыводитьСоообщения);
	
КонецПроцедуры

// Выгружает указанный сертификат хранилища в файл.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено            - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * МенеджерКриптографии - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки       - Строка - описание ошибки выполнения.
//      * ИмяФайлаСертификата  - Строка - имя файла, в который выгружен сертификат.
//
//  Сертификат - Структура - описание сертификата.
//    * СерийныйНомер - Строка - серийный номер сертификата.
//    * Поставщик     - Строка - издатель сертификата.
//    * Отпечаток     - Строка - отпечаток сертификата. Используется для поиска сертификата если не указаны СерийныйНомер и Поставщик.
//
//  ИмяФайлаИлиРасширение - Строка - имя файла, в который необходимо сохранить результат.
//                                   Также можно указать только расширение создаваемого файла - ".расширение".
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  МенеджерКриптографии  - AddIn  - объект используемый для работы с криптографией. Если не задан, то будет создан новый.
//
Процедура ЭкспортироватьСертификатВФайл(ОповещениеОЗавершении, Сертификат, ИмяФайлаИлиРасширение = Неопределено, 
										ВыводитьСоообщения = Истина) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ЭкспортироватьСертификатВФайл(
		ОповещениеОЗавершении, Сертификат, ИмяФайлаИлиРасширение, ВыводитьСоообщения);
	
КонецПроцедуры

Процедура ПараметрыКриптографииЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Результат = Новый Структура();
	Результат.Вставить("Выполнено",                           Ложь);
	Результат.Вставить("ОписаниеОшибки",                      "");
	Результат.Вставить("ОтпечатокСертификата",                "");
	Результат.Вставить("ПарольЗакрытогоКлюча",                "");
	Результат.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", Ложь);
	Результат.Вставить("ОтмененоПользователем", Ложь);
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		Результат.Выполнено            = Истина;
		Результат.ОтпечатокСертификата                = РезультатВыбора.Сертификат;
		Результат.ПарольЗакрытогоКлюча                = РезультатВыбора.Пароль;
		Результат.ЭтоЭлектроннаяПодписьВМоделиСервиса = РезультатВыбора.ЭтоОблачныйСертификат;
	Иначе
		Результат.ОтмененоПользователем = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещение, Результат);

КонецПроцедуры

Процедура ИнициализацияСервисаКриптографиииЗавершение(РезультатПодписания, ДополнительныеПараметры) Экспорт

	Если ДополнительныеПараметры.ОписаниеОповещения = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Результат = Новый Структура();
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	
	Результат.Выполнено = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатПодписания, "Выполнено", Ложь);
	
	ИнфоОбОшибке = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатПодписания, "ИнформацияОбОшибке", Неопределено);
	Если ТипЗнч(ИнфоОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		Результат.ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнфоОбОшибке);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Результат);

КонецПроцедуры

#КонецОбласти

// Открывает файл с использованием ассоциированного с ним приложения.
//
// Параметры:
//  ПолноеИмяФайлаИлиАдрес - Строка - полное имя файла, который необходимо открыть.
//                                  - адрес файла на сервере во временном хранилище.
//
//  ИмяФайла               - Строка - указывается имя, с которым необходимо сохранить файл, полученный с сервера.
//
//  ВыводитьСообщения      - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ОткрытьФайл(ПолноеИмяФайлаИлиАдрес, ИмяФайла = "", ВыводитьСообщения = Истина) Экспорт
	
	УниверсальныйОбменСБанкамиСлужебныйКлиент.ОткрытьФайл(ПолноеИмяФайлаИлиАдрес, ИмяФайла, ВыводитьСообщения);
	
КонецПроцедуры

Функция ДвоичныеДанныеВСтроку(Данные) Экспорт 
	
	Возврат УниверсальныйОбменСБанкамиСлужебныйКлиент.ДвоичныеДанныеВСтроку(Данные);
	
КонецФункции

Функция ВременныеДанныеТранзакции(Идентификатор, СписокФайлов = Неопределено, ИсходныеДанные = Ложь, Результаты = Ложь, Подписи = Ложь, РезультатыПослеРасшифровки = Ложь) Экспорт
	
	Возврат УниверсальныйОбменСБанкамиВызовСервера.ВременныеДанныеТранзакции(Идентификатор, СписокФайлов, ИсходныеДанные, Результаты, Подписи);
	
КонецФункции

#Область ПрограммныйИнтерфейсДляПотребителей

Функция СоздатьТранзакцииИзДанныхЖурналаОперацийСФайлами(Параметры) Экспорт
	
	Возврат УниверсальныйОбменСБанкамиВызовСервера.СоздатьТранзакцииИзДанныхЖурналаОперацийСФайлами(Параметры);
	
КонецФункции

// получает массив контейнеров для расшифровки
Функция ТранзакцииТребующиеРасшифровки(Сервис = Неопределено, Организация = Неопределено, СписокТранзакций = Неопределено) Экспорт
	
	Возврат УниверсальныйОбменСБанкамиВызовСервера.ТранзакцииТребующиеРасшифровки(Сервис, Организация, СписокТранзакций);
	
КонецФункции

Процедура ОтправитьТранзакцииВБанк(ОповещениеОбратногоВызова, Сервис, Транзакции) Экспорт
	
	 УниверсальныйОбменСБанкамиСлужебныйКлиент.ОтправитьТранзакцииВБанк(ОповещениеОбратногоВызова, Сервис, Транзакции);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти