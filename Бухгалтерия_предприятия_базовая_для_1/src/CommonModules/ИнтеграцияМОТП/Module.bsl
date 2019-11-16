#Область ПрограммныйИнтерфейс

#Область ПроверкаЗаполнения

Функция ДанныеДокументаСоответствуютДаннымУпаковок(ПроверяемыйДокумент) Экспорт
	
	ИмяДокумента = ПроверяемыйДокумент.Метаданные().Имя;
	
	ИмяТаблицы = СтрШаблон("Документ.%1.ШтрихкодыУпаковок", ИмяДокумента);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаШтрихКодыУпаковок.ШтрихкодУпаковки КАК ШтрихкодУпаковки
	|ИЗ
	|	&ИмяТаблицы КАК ТаблицаШтрихКодыУпаковок
	|ГДЕ
	|	ТаблицаШтрихКодыУпаковок.Ссылка = &ПроверяемыйДокумент";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяТаблицы", ИмяТаблицы);
	Запрос.УстановитьПараметр("ПроверяемыйДокумент", ПроверяемыйДокумент);
	
	ШтрихкодыУпаковок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ШтрихкодУпаковки");
	
	ДанныеДерева    = ЭлектронноеВзаимодействиеМОТП.Содержимое(ШтрихкодыУпаковок, Перечисления.ВидыПродукцииИС.Табачная);
	ДанныеДокумента = ТаблицаТабачнойПродукцииДокумента(ПроверяемыйДокумент);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДанныеДерева.Номенклатура,
	|	ДанныеДерева.Характеристика,
	|	ДанныеДерева.Серия,
	|	ДанныеДерева.Количество
	|ПОМЕСТИТЬ ДанныеДерева
	|ИЗ
	|	&ДанныеДерева КАК ДанныеДерева
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Номенклатура,
	|	ДанныеДокумента.Характеристика,
	|	ДанныеДокумента.Серия,
	|	ДанныеДокумента.Количество
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	&ДанныеДокумента КАК ДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Номенклатура,
	|	ДанныеДокумента.Характеристика,
	|	ДанныеДокумента.Серия,
	|	ЕСТЬNULL(ДанныеДерева.Количество , 0) - ДанныеДокумента.Количество КАК Различие
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДерева КАК ДанныеДерева
	|		ПО ДанныеДерева.Номенклатура = ДанныеДокумента.Номенклатура
	|		И ДанныеДерева.Характеристика = ДанныеДокумента.Характеристика
	|		И ДанныеДерева.Серия = ДанныеДокумента.Серия
	|ГДЕ
	|	ЕСТЬNULL(ДанныеДерева.Количество, 0) - ДанныеДокумента.Количество <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДерева.Номенклатура,
	|	ДанныеДерева.Характеристика,
	|	ДанныеДерева.Серия,
	|	ДанныеДерева.Количество
	|ИЗ
	|	ДанныеДерева КАК ДанныеДерева
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДокумента КАК ДанныеДокумента
	|		ПО ДанныеДокумента.Номенклатура = ДанныеДерева.Номенклатура
	|		И ДанныеДокумента.Характеристика = ДанныеДерева.Характеристика
	|		И ДанныеДокумента.Серия = ДанныеДерева.Серия
	|ГДЕ
	|	ДанныеДокумента.Номенклатура ЕСТЬ NULL
	|	И ДанныеДерева.Количество <> 0";
	
	Запрос.УстановитьПараметр("ДанныеДерева",    ДанныеДерева);
	Запрос.УстановитьПараметр("ДанныеДокумента", ДанныеДокумента);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
		
КонецФункции

Функция ТаблицаТабачнойПродукцииДокумента(Документ)
	
	ТаблицаПродукции = Новый ТаблицаЗначений;
	ТаблицаПродукции.Колонки.Добавить("Номенклатура",   Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаПродукции.Колонки.Добавить("Характеристика", Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ТаблицаПродукции.Колонки.Добавить("Серия",          Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ТаблицаПродукции.Колонки.Добавить("Количество",     ОбщегоНазначения.ОписаниеТипаЧисло(15, 3));
	
	ИнтеграцияМОТППереопределяемый.СформироватьТаблицуТабачнойПродукцииДокумента(Документ, ТаблицаПродукции);
	
	Возврат ТаблицаПродукции;
	
КонецФункции

#КонецОбласти

#Область НастройкиУчета

Функция АктыОРасхожденияПослеПоступленияИспользуются(Документ) Экспорт
	
	Используются = Ложь;
	
	ИнтеграцияМОТППереопределяемый.ОпределитьИспользованиеАктовОРасхождениииПослеПриемки(Документ, Используются);
	
	Возврат Используются;
	
КонецФункции

#КонецОбласти

#Область РегламентноеЗадание

// Выполнить регламентное задание обмена с ИС МОТП
//
Процедура ВыполнитьОбменРегламентноеЗадание() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхМОТП);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СертификатыДляПодписанияНаСервере = СертификатыДляПодписанияНаСервере();
	
	Если СертификатыДляПодписанияНаСервере = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
//	Для Каждого СтрокаТЧ Из СертификатыДляПодписанияНаСервере.Сертификаты Цикл
//		
//		ОбработатьОчередьПолученияДанныхРегламентнымЗаданием(СтрокаТЧ.GLN, СертификатыДляПодписанияНаСервере);
//		ОбработатьОчередьПолученияКвитанцийОФиксацииРегламентнымЗаданием(СтрокаТЧ.GLN, СертификатыДляПодписанияНаСервере);
//		
//	КонецЦикла;
//	
//	ОбработатьОчередьПередачиДанных(СертификатыДляПодписанияНаСервере);
	
КонецПроцедуры

// Определяет следующие свойства регламентных заданий:
//  - зависимость от функциональных опций.
//  - возможность выполнения в различных режимах работы программы.
//  - прочие параметры.
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхМОТП;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхМОТП;
	
КонецПроцедуры

// Получает сертификаты организаций, для предназначены для подписания на сервере.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * Сертификаты - ТаблицаЗначений - содержит сертификат и пароль.
//   * МенеджерКриптографии - МенеджерКриптографии - менеджер криптографии.
//
Функция СертификатыДляПодписанияНаСервере() Экспорт
	
	НастройкиОбмена = ИнтеграцияИС.НастройкиОбменаГосИС();
	
	Если НастройкиОбмена = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	Т.Сертификат  КАК Сертификат
	|ПОМЕСТИТЬ ТаблицаДанных
	|ИЗ
	|	&Таблица КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДанных.Организация          КАК Организация,
	|	ТаблицаДанных.Сертификат           КАК Сертификат,
	|	ТаблицаДанных.Сертификат.Отпечаток КАК Отпечаток
	|ИЗ
	|	ТаблицаДанных КАК ТаблицаДанных
	|");
	
	Запрос.УстановитьПараметр("Таблица", НастройкиОбмена);
	
	ДанныеСертификатовИзНастроекОбмена = Запрос.Выполнить().Выгрузить();
	
	СертификатыОрганизацийДляОбменаНаСервере = Новый ТаблицаЗначений();
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Организация");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Сертификат");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Отпечаток");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("СертификатКриптографии");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Пароль");
	
	Для Каждого ДанныеСертификата Из ДанныеСертификатовИзНастроекОбмена Цикл
		
		Пароль = ПарольКСертификату(ДанныеСертификата.Сертификат);
		
		СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(ДанныеСертификата.Отпечаток, Ложь);
		Если СертификатКриптографии = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТЧ = СертификатыОрганизацийДляОбменаНаСервере.Добавить();
		СтрокаТЧ.Организация            = ДанныеСертификата.Организация;
		СтрокаТЧ.Сертификат             = ДанныеСертификата.Сертификат;
		СтрокаТЧ.Отпечаток              = ДанныеСертификата.Отпечаток;
		СтрокаТЧ.СертификатКриптографии = СертификатКриптографии;
		Если Пароль <> Неопределено Тогда
			СтрокаТЧ.Пароль = Пароль;
		Иначе
			СтрокаТЧ.Пароль = "";
		КонецЕсли;
		
	КонецЦикла;
	
	Если СертификатыОрганизацийДляОбменаНаСервере.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерКриптографии = ЭлектроннаяПодпись.МенеджерКриптографии("Подписание", Ложь);
	
	СертификатыДляПодписанияНаСервере = Новый Структура;
	СертификатыДляПодписанияНаСервере.Вставить("Сертификаты",          СертификатыОрганизацийДляОбменаНаСервере);
	СертификатыДляПодписанияНаСервере.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	
	Возврат СертификатыДляПодписанияНаСервере;
	
КонецФункции

// Возвращает пароль к сертификату, если доступен текущему пользователю.
// При вызове в привилегированном режиме текущий пользователь не учитывается.
//
// Параметры:
//  Сертификат - Неопределено - вернуть пароли ко всем сертификатам, доступным текущему пользователю.
//             - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - вернуть пароль
//                 к указанному сертификату.
//              
// Возвращаемое значение:
//  Неопределено - пароль для указанного сертификата не указан.
//  Строка       - пароль для указанного сертификата.
//  Соответствие - все заданные пароли, доступные текущему пользователю
//                 в виде ключ - сертификат и значение - пароль.
//
Функция ПарольКСертификату(Сертификат = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Данные = Константы.КонтекстРаботыГИСМ.Получить().Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеЭлектронныхПодписейИШифрование") Тогда
		Если Сертификат <> Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		Возврат Новый СписокЗначений;
	КонецЕсли;
	
	Если Сертификат <> Неопределено Тогда
		Если ТипЗнч(Данные) <> Тип("Соответствие") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Свойства = Данные.Получить(Сертификат);
		
		Если ТипЗнч(Свойства) = Тип("Структура")
		   И Свойства.Свойство("Пароль")
		   И ТипЗнч(Свойства.Пароль) = Тип("Строка")
		   И Свойства.Свойство("Пользователь")
		   И ТипЗнч(Свойства.Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			
		   Если Свойства.Пользователь = Пользователи.ТекущийПользователь()
			   ИЛИ Свойства.Пользователь = Справочники.Пользователи.ПустаяСсылка() Тогда
				
				Возврат Свойства.Пароль;
			КонецЕсли;
		КонецЕсли;
		
		Возврат Неопределено;
	КонецЕсли;
	
	ПаролиСертификатов = Новый Соответствие;
	
	Если ТипЗнч(Данные) <> Тип("Соответствие") Тогда
		Возврат ПаролиСертификатов;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Данные Цикл
		Свойства = КлючИЗначение.Значение;
		
		Если ТипЗнч(Свойства) = Тип("Структура")
		   И Свойства.Свойство("Пароль")
		   И ТипЗнч(Свойства.Пароль) = Тип("Строка")
		   И Свойства.Свойство("Пользователь")
		   И ТипЗнч(Свойства.Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			
		   Если Свойства.Пользователь = Пользователи.ТекущийПользователь()
			   ИЛИ Свойства.Пользователь = Справочники.Пользователи.ПустаяСсылка()
			 Или ПривилегированныйРежим() Тогда
				ПаролиСертификатов.Вставить(КлючИЗначение.Ключ, Свойства.Пароль);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПаролиСертификатов;
	
КонецФункции

#КонецОбласти

#Область ЭлектроннаяПодпись

// Подписать сообщение XML
//
// Параметры:
//  ТекстСообщенияXML - Строка - Подписываемое сообщение XML
//  СертификатКриптографии - Сертификат криптографии
//  МенеджерКриптографии - Менеджер криптографии.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//   * Успех       - Булево - Признак успешности подписания.
//   * КонвертSOAP - Строка - Конверт SOAP.
//   * ТекстОшибки - Строка - Текст ошибки.
//
Функция Подписать(ДанныеДляПодписания, СертификатКриптографии, МенеджерКриптографии) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Успех");
	ВозвращаемоеЗначение.Вставить("Подпись");
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	Попытка
		
		Отпечаток = Отпечаток(СертификатКриптографии);
		Если Отпечаток <> Неопределено Тогда
			
			ComОбъектСертификата = ComОбъектСертификатаПоОтпечатку(Отпечаток);
			
			ВозвращаемоеЗначение.Успех   = Истина;
			ВозвращаемоеЗначение.Подпись = ПодписатьCAdES(ДанныеДляПодписания, ComОбъектСертификата);
		
		Иначе
			
			ВозвращаемоеЗначение.Успех       = Ложь;
			ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Ошибка поиска сертификата...'");
			
		КонецЕсли;
		
	Исключение
		
		ВозвращаемоеЗначение.Успех       = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция Отпечаток(СертификатКриптографии)
	
	Возврат НРег(ПолучитьHexСтрокуИзДвоичныхДанных(СертификатКриптографии.Отпечаток));
	
КонецФункции

Функция ПодписатьCAdES(ТекстДляПодписи, ComОбъектСертификата)
	
	CADESCOM_CADES_TYPE = 1; // Тип усовершенствованной подписи
	bDetached           = Ложь;
	EncodingType        = 0;
	
	oSigner = Новый COMОбъект("CAdESCOM.CPSigner"); // Объект, задающий параметры создания и содержащий информацию об усовершенствованной подписи.
	oSigner.Certificate = ComОбъектСертификата;
	
	oSignedData = Новый COMОбъект("CAdESCOM.CadesSignedData"); // Объект CadesSignedData предоставляет свойства и методы для работы с усовершенствованной подписью.
	oSignedData.Content = СокрЛП(ТекстДляПодписи);
	
	sSignedMessage = oSignedData.SignCades(oSigner, CADESCOM_CADES_TYPE, bDetached, EncodingType); // Метод добавляет к сообщению усовершенствованную подпись.
	
	Возврат sSignedMessage; // Подпись в формате Base64
	
КонецФункции

// Получить Com-объект сертификата по отпечатку.
// 
// Параметры:
// 	Отпечаток - Строка - отпечаток сертификата, используемого для подписи; строка, представляющая отпечаток в шестнадцатеричном виде
// 	                     пример 195934d72dcdf69149901d6632aca4562d8806d8
// Возвращаемое значение:
// 	ComОбъект - Com-объект сертификата.
Функция ComОбъектСертификатаПоОтпечатку(Отпечаток)
	
	CAPICOM_CURRENT_USER_STORE         = 2;    // 2 - Искать сертификат в ветке "Личное" хранилища.
	CAPICOM_MY_STORE                   = "My"; // Указываем, что ветку "Личное" берем из хранилища текущего пользователя
	CAPICOM_STORE_OPEN_READ_ONLY       = 0;    // Открыть хранилище только на чтение
	CAPICOM_CERTIFICATE_FIND_SHA1_HASH = 0;
	
	oStore = Новый COMОбъект("CAdESCOM.Store"); // Объект описывает хранилище сертификатов
	oStore.Open(CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE, CAPICOM_STORE_OPEN_READ_ONLY); // Открыть хранилище сертификатов
	
	Certificates = oStore.Certificates.Find(CAPICOM_CERTIFICATE_FIND_SHA1_HASH, Отпечаток);
	ComОбъект = Certificates.Item(1); // Найденный сертификат (Com-объект)
	
	oStore.Close(); // Закрыть хранилище сертификатов и освободить объект
	
	Возврат ComОбъект;
	
КонецФункции

#КонецОбласти

#Область Серии

// Генерирует серии по переданным данным
// 
// Параметры:
// 	ДанныеДляГенерации - Структура - (См. ИнтеграцияМОТПУТКлиентСервер.СтруктураДанныхДляГенерацииСерии)
Процедура СгенерироватьСерии(ДанныеДляГенерации) Экспорт

	ИнтеграцияМОТППереопределяемый.СгенерироватьСерии(ДанныеДляГенерации);

КонецПроцедуры

#КонецОбласти

#КонецОбласти