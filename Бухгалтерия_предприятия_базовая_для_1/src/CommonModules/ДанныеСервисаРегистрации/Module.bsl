#Область ПрограммныйИнтерфейс

Функция КвитанцияНаОплатуГоспошлины(ТипПлатежа, ДанныеПлательщика, АдресОрганизацииJSON, КБК, Сумма) Экспорт
	
	АдресОрганизацииXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(АдресОрганизацииJSON, , Перечисления.ТипыКонтактнойИнформации.Адрес);
	АдресПропискиXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(ДанныеПлательщика.АдресПропискиЗначениеJSON, , Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	ОписаниеОшибки = "";
	ОбъектXDTO     = Неопределено;
	Прокси         = ПроксиСервиса(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "getPaymentDocument"));
		
		ТипыПлатежа = ТипыПлатежа();
		ВходныеПараметры.Type = ТипыПлатежа[ТипПлатежа];
		ВходныеПараметры.KBK = КБК;
		ВходныеПараметры.Sum = Сумма;
		ВходныеПараметры.FirstName = ДанныеПлательщика.Имя;
		ВходныеПараметры.LastName = ДанныеПлательщика.Фамилия;
		Если ЗначениеЗаполнено(ДанныеПлательщика.Отчество) Тогда
			ВходныеПараметры.MiddleName = ДанныеПлательщика.Отчество;
		КонецЕсли;
		Если ЗначениеЗаполнено(ДанныеПлательщика.ИНН) Тогда
			ВходныеПараметры.INN = ДанныеПлательщика.ИНН;
		КонецЕсли;
		
		ВходныеПараметры.OrganizationAddress = ПолучитьАдресРФ(АдресОрганизацииXML, Прокси);
		ВходныеПараметры.LiveAddress = ПолучитьАдресРФ(АдресПропискиXML, Прокси);
		
		Попытка
			ДвоичныеДанныеФайла = Прокси.getPaymentDocument(
				ВходныеПараметры.Type,
				ВходныеПараметры.KBK,
				ВходныеПараметры.Sum,
				ВходныеПараметры.FirstName,
				ВходныеПараметры.LastName,
				ВходныеПараметры.MiddleName,
				ВходныеПараметры.INN,
				ВходныеПараметры.OrganizationAddress,
				ВходныеПараметры.LiveAddress);
			Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
		Исключение
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПлатежныеРеквизитыОплатаГоспошлины(ДанныеПлательщика, АдресОрганизацииJSON, КБК, Сумма) Экспорт
	
	АдресОрганизацииXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(АдресОрганизацииJSON, , Перечисления.ТипыКонтактнойИнформации.Адрес);
	АдресПропискиXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(ДанныеПлательщика.АдресПропискиЗначениеJSON, , Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	ОписаниеОшибки = "";
	ОбъектXDTO     = Неопределено;
	Прокси         = ПроксиСервиса(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		Результат = НовыйРеквизитыПлатежа();
		
		Результат.КБК = КБК;
		Результат.Сумма = Сумма;
		
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "getPaymentRequisites"));
		ВходныеПараметры.Type = "CHARTER";
		ВходныеПараметры.KBK = Результат.КБК;
		ВходныеПараметры.Sum = Результат.Сумма;
		ВходныеПараметры.FirstName = ДанныеПлательщика.Имя;
		ВходныеПараметры.LastName = ДанныеПлательщика.Фамилия;
		ВходныеПараметры.OrganizationAddress = ПолучитьАдресРФ(АдресОрганизацииXML, Прокси);
		ВходныеПараметры.LiveAddress = ПолучитьАдресРФ(АдресПропискиXML, Прокси);
		
		Попытка
			ПлатежныеРеквизитыИзСервиса = Прокси.getPaymentRequisites(
				ВходныеПараметры.Type,
				ВходныеПараметры.KBK,
				ВходныеПараметры.Sum,
				ВходныеПараметры.FirstName,
				ВходныеПараметры.LastName,
				ВходныеПараметры.MiddleName,
				ВходныеПараметры.INN,
				ВходныеПараметры.OrganizationAddress,
				ВходныеПараметры.LiveAddress);
			
			Результат.ОКТМО = ПлатежныеРеквизитыИзСервиса.OKTMO;
			Результат.ИНН = ПлатежныеРеквизитыИзСервиса.recipientINN;
			Результат.КПП = ПлатежныеРеквизитыИзСервиса.recipientKPP;
			Результат.НаименованиеПолучателя = ПлатежныеРеквизитыИзСервиса.RecipientName;
			Результат.НомерСчета = ПлатежныеРеквизитыИзСервиса.recipientBankPersAccount;
			Результат.БИК = ПлатежныеРеквизитыИзСервиса.recipientBankBIC;
			Результат.НаименованиеБанка = ПлатежныеРеквизитыИзСервиса.recipientBankName;
			Результат.КоррСчет = ПлатежныеРеквизитыИзСервиса.recipientBankCorrAccount;
			Если Результат.КоррСчет = "00000000000000000000" ИЛИ Результат.КоррСчет = Результат.НомерСчета Тогда
				Результат.КоррСчет = "";
			КонецЕсли;
			
			Возврат Результат;
		Исключение
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция НовыйРеквизитыПлатежа() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ОКТМО", "");
	Результат.Вставить("ИНН", "");
	Результат.Вставить("КПП");
	Результат.Вставить("НаименованиеПолучателя", "");
	Результат.Вставить("БИК", "");
	Результат.Вставить("НаименованиеБанка", "");
	Результат.Вставить("НомерСчета", "");
	Результат.Вставить("КоррСчет", "");
	Результат.Вставить("КБК", "");
	Результат.Вставить("Сумма", 0);
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеКодаПолученияИНН() Экспорт
	
	ОписаниеОшибки = "";
	ОбъектXDTO     = Неопределено;
	Прокси         = ПроксиСервисаИНН(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		Попытка
			
			ДанныеКодаПолученияИННXDTO = Прокси.getCaptcha();
			ДанныеКодаПолученияИНН = Новый Структура();
			ДанныеКодаПолученияИНН.Вставить("ДвоичныеДанныеКартинки", ДанныеКодаПолученияИННXDTO.Image);
			ДанныеКодаПолученияИНН.Вставить("Токен", ДанныеКодаПолученияИННXDTO.Token);
			
			Возврат ДанныеКодаПолученияИНН;
			
		Исключение
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка, , ,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОпределитьИНН(ДанныеФизическогоЛица, Токен, КодПолучения) Экспорт
	
	ДанныеИНН = Новый Структура();
	ДанныеИНН.Вставить("ИНН",         Неопределено);
	ДанныеИНН.Вставить("Ошибка",      "");
	ДанныеИНН.Вставить("ТекстОшибки", "");
	
	ОписаниеОшибки = "";
	ОбъектXDTO     = Неопределено;
	Прокси         = ПроксиСервисаИНН(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		Попытка
			
			ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(
				Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "getInn"));
			ВходныеПараметры.FirstName = ДанныеФизическогоЛица.Имя;
			ВходныеПараметры.LastName  = ДанныеФизическогоЛица.Фамилия;
			Если ЗначениеЗаполнено(ДанныеФизическогоЛица.Отчество) Тогда
				ВходныеПараметры.MiddleName = ДанныеФизическогоЛица.Отчество;
				ВходныеПараметры.NoMiddleName = Ложь;
			Иначе
				ВходныеПараметры.NoMiddleName = Истина
			КонецЕсли;
			
			ВходныеПараметры.DayOfBirth = ДанныеФизическогоЛица.ДатаРождения;
			ВходныеПараметры.DocumentType = "21";
			ВходныеПараметры.DocumentNumber = СтрШаблон(НСтр("ru = '%1 %2'"),
				ДанныеФизическогоЛица.ПаспортныеДанные.Серия,
				ДанныеФизическогоЛица.ПаспортныеДанные.Номер);
			ВходныеПараметры.DocumentDate = ДанныеФизическогоЛица.ПаспортныеДанные.ДатаВыдачи;
			ВходныеПараметры.CaptchaToken = Токен;
			ВходныеПараметры.CaptchaText  = КодПолучения;
			
			Результат = Прокси.getInn(ВходныеПараметры.FirstName, ВходныеПараметры.LastName,
				ВходныеПараметры.MiddleName, ВходныеПараметры.NoMiddleName,
				ВходныеПараметры.DayOfBirth, ВходныеПараметры.DocumentType,
				ВходныеПараметры.DocumentNumber, ВходныеПараметры.DocumentDate,
				ВходныеПараметры.CaptchaToken, ВходныеПараметры.CaptchaText);
			
			ДанныеИНН.ИНН = Результат;
			
			Возврат ДанныеИНН;
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, , ,
				ПодробноеПредставлениеОшибки);
			Если СтрНайти(ПодробноеПредставлениеОшибки, "SERVER-1:") > 0 Тогда
				ДанныеИНН.Ошибка = "НеверныйКод";
			ИначеЕсли СтрНайти(ПодробноеПредставлениеОшибки, "SERVER-2:") > 0 Тогда
				ДанныеИНН.Ошибка = "НеверныйАдрес";
			ИначеЕсли СтрНайти(ПодробноеПредставлениеОшибки, "SERVER-10:") > 0 Тогда
				ДанныеИНН.Ошибка = "ОшибкаОбработкиЗапроса";
			ИначеЕсли СтрНайти(ПодробноеПредставлениеОшибки, "SERVER-20:") > 0 Тогда
				ДанныеИНН.Ошибка = "ВнутренняяОшибка";
			Иначе
				ДанныеИНН.Ошибка = "НеизвестнаяОшибка";
			КонецЕсли;
			ДанныеИНН.ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ДанныеИНН;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроксиСервиса(ОписаниеОшибки)
	
	Прокси = Неопределено;
	ПараметрыАутентификации = ПараметрыАутентификацииВСервисе();
	
	Если ПараметрыАутентификации = Неопределено Тогда
		
		// Служебный текст. Должен быть обработан на клиенте.
		ОписаниеОшибки = "НеУказаныПараметрыАутентификации"; 
		
	Иначе
		
		Попытка
			
			ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
			ПараметрыПодключения.АдресWSDL           = АдресСервиса();
			ПараметрыПодключения.URIПространстваИмен = ПространствоИмен();
			ПараметрыПодключения.ИмяСервиса          = "RegistrationWebServiceEndpointV2ImplService";
			ПараметрыПодключения.ИмяТочкиПодключения = "RegistrationWebServiceEndpointV2ImplPort";
			ПараметрыПодключения.ИмяПользователя     = ПараметрыАутентификации.login;
			ПараметрыПодключения.Пароль              = ПараметрыАутентификации.password;
			ПараметрыПодключения.Таймаут             = 30;
			
			Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Функция ПроксиСервисаИНН(ОписаниеОшибки)
	
	Прокси = Неопределено;
	ПараметрыАутентификации = ПараметрыАутентификацииВСервисе();
	
	Если ПараметрыАутентификации = Неопределено Тогда
		
		// Служебный текст. Должен быть обработан на клиенте.
		ОписаниеОшибки = "НеУказаныПараметрыАутентификации"; 
		
	Иначе
		
		Попытка
			
			ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
			ПараметрыПодключения.АдресWSDL           = АдресСервисаИНН();
			ПараметрыПодключения.URIПространстваИмен = ПространствоИмен();
			ПараметрыПодключения.ИмяСервиса          = "RegistrationWebServiceEndpointImplService";
			ПараметрыПодключения.ИмяТочкиПодключения = "RegistrationWebServiceEndpointImplPort";
			ПараметрыПодключения.ИмяПользователя     = ПараметрыАутентификации.login;
			ПараметрыПодключения.Пароль              = ПараметрыАутентификации.password;
			ПараметрыПодключения.Таймаут             = 30;
			
			Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Функция ПараметрыАутентификацииВСервисе()
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Новый Структура("login,password", 
			"fresh", "fresh");
				
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		УстановитьПривилегированныйРежим(Ложь);
		Если ДанныеАутентификации <> Неопределено Тогда
			Возврат Новый Структура("login,password", 
				ДанныеАутентификации.Логин, 
				ДанныеАутентификации.Пароль);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция АдресСервиса()
	
	Возврат "https://api.registrationservices.1c.ru/registrationservices/services/v2?wsdl";
	
КонецФункции

Функция АдресСервисаИНН()
	
	Возврат "https://api.registrationservices.1c.ru/registrationservices/services/v1?wsdl";
	
КонецФункции

Функция ПространствоИмен()
	
	Возврат "http://ws.registrationservices.company1c.com/";
	
КонецФункции

Функция ПолучитьАдресРФ(Строка, Прокси)
	
	// При редактировании строка XML хранится в национальном формате http://www.v8.1c.ru/ssl/contactinfo_ru
	// При записи он преобразуется в общий формат http://www.v8.1c.ru/ssl/contactinfo
	// Поэтому в общем случае значение может приходить в любом формате.
	// В сервис нужно передать адрес в общем формате, поэтому преобразуем адрес в общий формат.
	
	СтрокаАдресаВОбщемФормате = РаботаСАдресами.ПередЗаписьюXDTOКонтактнаяИнформация(Строка);
	
	Адрес = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(СтрокаАдресаВОбщемФормате, Прокси.ФабрикаXDTO);
	СтрокаАдресРФ = ОбщегоНазначения.ОбъектXDTOВСтрокуXML(Адрес.Состав.Состав, Прокси.ФабрикаXDTO);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаАдресРФ);
	
	Результат = Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Возврат Результат;
	
КонецФункции

Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Регистрация организации.Сервис'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ТипыПлатежа()
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрацияЮрлица", "ORGANIZATION");
	Результат.Вставить("РегистрацияИП", "ENTREPRENEUR");
	Результат.Вставить("ИзмененияВУставеЮрлица", "CHARTER");
	
	Возврат Результат;
	
КонецФункции

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	НовыеРазрешения = Новый Массив;
	
	Сервисы = Новый Соответствие;
	Сервисы.Вставить(АдресСервиса(), НСтр("ru = 'Сервис получения квитанций на оплату госпошлины за регистрацию организаций и ИП'"));
	Сервисы.Вставить(АдресСервисаИНН(), НСтр("ru = 'Сервис Узнай ИНН'"));
	
	Для Каждого Сервис Из Сервисы Цикл
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Сервис.Ключ);
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			ВРег(СтруктураURI.Схема),
			СтруктураURI.Хост,
			СтруктураURI.Порт,
			Сервис.Значение);
		НовыеРазрешения.Добавить(Разрешение);
	КонецЦикла;
	
	ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(НовыеРазрешения));
	
КонецПроцедуры

#КонецОбласти