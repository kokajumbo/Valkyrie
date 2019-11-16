
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обработка заявлений абонента 
//             на подключение электронной подписи в модели сервиса".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Регламентное задание.
Процедура ОбработкаЗаявленийАбонентов(ДокументЗаявление) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если ЗначениеЗаполнено(ДокументЗаявление) Тогда
		
		Если ДокументЗаявление.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено
			И НЕ ДокументЗаявление.ПометкаУдаления
			И ДокументЗаявление.Дата + 2 * 30 * 24 * 60 * 60 > ТекущаяДатаСеанса() Тогда
			
			Если ДокументЗаявление.ЭлектроннаяПодписьВМоделиСервиса Тогда
				ЗаявлениеОбработано = ОбработкаЗаявленийАбонентаВызовСервера.ОбработатьИзменениеСтатусаЗаявленияАбонентаВМоделиСервиса(ДокументЗаявление);
			Иначе
				РезультатОтветаСервера 	= ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьИРазобратьОтветНаЗаявление(ДокументЗаявление,,Истина);
				ЗаявлениеОбработано 	= РезультатОтветаСервера.Выполнено И РезультатОтветаСервера.СтатусИзменился;
			КонецЕсли;
			
			Если ЗаявлениеОбработано Тогда
				ОбработкаЗаявленийАбонентаВызовСервера.ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление);
			КонецЕсли;
			
		Иначе
			
			ОбработкаЗаявленийАбонентаВызовСервера.ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление);
			
		КонецЕсли;
		
	Иначе
		
		ОбработкаЗаявленийАбонентаВызовСервера.ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВыгрузитьЗаявлениеАбонентаВМоделиСервиса(Знач ЗаявлениеАбонента, Знач Алгоритм) Экспорт
	
	Если ЗаявлениеАбонента.ПодписатьЭП Тогда
		Результат = МенеджерСервисаКриптографии.СформироватьЗаявлениеДляПодписания(ПодготовитьЗаявление(ЗаявлениеАбонента, Алгоритм));
	Иначе
		Результат = МенеджерСервисаКриптографии.ОтправитьЗаявлениеНаПодключение(ПодготовитьЗаявление(ЗаявлениеАбонента, Алгоритм));
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлючЗаявленийТребующихНапоминанияПозже() Экспорт

	Возврат "ДокументооборотСКонтролирующимиОрганами_ЗаявленияТребующиеНапоминанияПозже";

КонецФункции

Функция ПодготовитьЗаявление(ДокументЗаявление, Алгоритм) Экспорт
	
	Заявление = Новый Структура;
	Заявление.Вставить("type", XMLСтрока(ДокументЗаявление.ТипЗаявления));
	
	Если ДокументЗаявление.ЭтоУпрощенноеЗаявление И ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования() Тогда
		Заявление.Вставить("test", Истина);
	КонецЕсли;
	
	Заявление.Вставить("version", "1.7");
	Заявление.Вставить("application", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	Заявление.Вставить("abonent_id", ПолучитьИдентификаторАбонента(ДокументЗаявление));
	Заявление.Вставить("id", ДокументЗаявление.ИдентификаторДокументооборота);
	Заявление.Вставить("date", ТекущаяУниверсальнаяДата());
	Заявление.Вставить("organization", ПодготовитьОрганизацию(ДокументЗаявление));
	Заявление.Вставить("signature_owner", ПодготовитьВладельцаЭП(ДокументЗаявление));
	Заявление.Вставить("recipients", ПодготовитьПолучателей(ДокументЗаявление));
	Заявление.Вставить("files", ПодготовитьФайлы(ДокументЗаявление));
	Заявление.Вставить("changed_attributes", ПодготовитьИзменившиесяРеквизиты(ДокументЗаявление));
	Заявление.Вставить("code_product_1c", ДокументЗаявление.НомерОсновнойПоставки1с);
	Заявление.Вставить("auth", ПолучитьПараметрыАутентификации(ДокументЗаявление));
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		Заявление.Вставить("ПриоритетГОСТ", "2012-256");
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		Заявление.Вставить("ПриоритетГОСТ", "2012-512");
	КонецЕсли;
	
	Возврат Заявление;
	
КонецФункции

Функция ПодготовитьОрганизацию(ДокументЗаявление)
	
	Организация = Новый Структура;
	Организация.Вставить("short_name", ДокументЗаявление.КраткоеНаименование);
	Организация.Вставить("inn", ДокументЗаявление.ИНН);
	Организация.Вставить("kpp", ДокументЗаявление.КПП);
	Организация.Вставить("ogrn", ДокументЗаявление.ОГРН);
	
	Если НЕ ЗначениеЗаполнено(ДокументЗаявление.ОГРН) И ДокументЗаявление.ЭтоНотариусАдвокатИлиГКФХ Тогда
		Организация.Вставить("is_individual", Истина);
	КонецЕсли;
	
	Организация.Вставить("reg_number_pfr", ДокументЗаявление.РегНомерПФР);
	Организация.Вставить("reg_number_fss", ДокументЗаявление.РегНомерФСС);
	Организация.Вставить("reg_number_fss_optional", ДокументЗаявление.ДополнительныйКодФСС);
	Организация.Вставить("separate_subdivision", ДокументЗаявление.ПризнакОбособленногоПодразделения);
	Организация.Вставить("legal_address", ПодготовитьАдрес(ДокументЗаявление, "АдресЮридический"));
	Организация.Вставить("actual_address", ПодготовитьАдрес(ДокументЗаявление, "АдресФактический"));
	Организация.Вставить("phone", ДокументЗаявление.ТелефонОсновной);
	Организация.Вставить("mobile_phone", ДокументЗаявление.ТелефонМобильный);
	Организация.Вставить("email", ДокументЗаявление.ЭлектроннаяПочта);
	Организация.Вставить("tariff", ДокументЗаявление.Тариф);
	
	Если НЕ ДокументЗаявление.ЭтоУпрощенноеЗаявление Тогда
		Организация.Вставить("full_name", ДокументЗаявление.ПолноеНаименование);
		Организация.Вставить("phone_optional", ДокументЗаявление.ТелефонДополнительный);
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции

Функция ПодготовитьАдрес(ДокументЗаявление, ИмяРеквизита)
	
	АдресСтрокой = ДокументЗаявление[ИмяРеквизита];
	
	Если ЗначениеЗаполнено(АдресСтрокой) Тогда
		
		ЭтоАдресПоФИАСу = УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(АдресСтрокой);

		Если ЭтоАдресПоФИАСу Тогда
			
			КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		
			Адрес = Новый Структура;
			Адрес.Вставить("country", "643");
			Адрес.Вставить("region_code", "");
			Адрес.Вставить("region", "");
			Адрес.Вставить("district", "");
			Адрес.Вставить("city", "");
			Адрес.Вставить("locality", "");
			Адрес.Вставить("street", "");
			Адрес.Вставить("house", "");
			Адрес.Вставить("building", "");
			Адрес.Вставить("apartment", "");
			
			// Представление
			ПредставлениеАдреса = КонтекстЭДОСервер.ПредставлениеАдресаИзДанныхОрганизации(АдресСтрокой);
			Адрес.Вставить("presentation", ПредставлениеАдреса);
			
			// Адрес в том виде, как он передается в заявлении на подключение.
			АдресВВидеXML = КонтекстЭДОСервер.АдресФИАСДляТелаЗаявления(ДокументЗаявление, ИмяРеквизита);
			Адрес.Вставить("fias", АдресВВидеXML);
			
			localityName 		= КонтекстЭДОСервер.ПолеСертификата_2_5_4_7(АдресСтрокой);
			stateOrProvinceName = КонтекстЭДОСервер.ПолеСертификата_2_5_4_8(АдресСтрокой);
			streetAddress 		= КонтекстЭДОСервер.ПолеСертификата_2_5_4_9(АдресСтрокой);
				
			Адрес.street 		= streetAddress; 
			Адрес.region_code	= Лев(stateOrProvinceName, 2);
			Адрес.region 		= Сред(stateOrProvinceName, 4);
			Адрес.city 			= localityName;
			
		Иначе
			
			ЧастиАдреса = СтрРазделить(АдресСтрокой, ",");
			Если ЧастиАдреса.Количество() <> 10 И ЧастиАдреса.Количество() <> 13 Тогда
				ВызватьИсключение(НСтр("ru = 'Неверный формат адреса.'"));
			КонецЕсли;
			
			Адрес = Новый Структура;
			Адрес.Вставить("country", ЧастиАдреса[0]);
			Адрес.Вставить("postcode", ЧастиАдреса[1]);
			Адрес.Вставить("region_code", ЧастиАдреса[2]);
			Адрес.Вставить("region", НазваниеРегионаПоКоду(ЧастиАдреса[2]));
			Адрес.Вставить("district", ЧастиАдреса[3]);
			Адрес.Вставить("city", ЧастиАдреса[4]);
			Адрес.Вставить("locality", ЧастиАдреса[5]);
			Адрес.Вставить("street", ЧастиАдреса[6]);
			Адрес.Вставить("house", ЧастиАдреса[7]);
			Адрес.Вставить("building", ЧастиАдреса[8]);
			Адрес.Вставить("apartment", ЧастиАдреса[9]);
			
		КонецЕсли;

	Иначе
		
		Если ИмяРеквизита = "АдресЮридический" Тогда
		
			РеквизитыСертификата = ДокументЗаявление.РеквизитыСертификата.Получить();
			Если ЗначениеЗаполнено(РеквизитыСертификата) Тогда
				
				Адрес = Новый Структура;
				Адрес.Вставить("country", "643");
				Адрес.Вставить("region_code", "");
				Адрес.Вставить("region", "");
				Адрес.Вставить("district", "");
				Адрес.Вставить("city", "");
				Адрес.Вставить("locality", "");
				Адрес.Вставить("street", "");
				Адрес.Вставить("house", "");
				Адрес.Вставить("building", "");
				Адрес.Вставить("apartment", "");
				
				Если РеквизитыСертификата.Свойство("OID2_5_4_9") Тогда
					Адрес.street = РеквизитыСертификата["OID2_5_4_9"]; 
				КонецЕсли;
				Адрес.region_code = Лев(РеквизитыСертификата["OID2_5_4_8"], 2);
				Адрес.region = Сред(РеквизитыСертификата["OID2_5_4_8"], 4);
				
				Адрес.city = РеквизитыСертификата["OID2_5_4_7"];
			Иначе
				Возврат Неопределено;
			КонецЕсли;
			
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Адрес;
	
КонецФункции

Функция НазваниеРегионаПоКоду(КодРегиона)
	
	Название = РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(КодРегиона);
	
	Если Не ЗначениеЗаполнено(Название) Тогда
		// затем пробуем найти в таблице регионов
		МакетРегионы = Обработки.ОбщиеОбъектыРеглОтчетности.ПолучитьМакет("Регионы");
		нрегАдресРегион = нрег(Название);
		Для Индекс = 1 По МакетРегионы.ВысотаТаблицы Цикл
			ТекущийКодРегиона = СокрЛП(МакетРегионы.Область(Индекс, 2, Индекс, 2).Текст);
			Если ТекущийКодРегиона = КодРегиона Тогда
				Название = СокрЛП(МакетРегионы.Область(Индекс, 1, Индекс, 1).Текст);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Название;
	
КонецФункции

Функция ПодготовитьВладельцаЭП(ДокументЗаявление)
	
	ВладелецЭП = Новый Структура;
	ВладелецЭП.Вставить("first_name", ДокументЗаявление.ВладелецЭЦПИмя);
	ВладелецЭП.Вставить("middle_name", ДокументЗаявление.ВладелецЭЦПОтчество);
	ВладелецЭП.Вставить("last_name", ДокументЗаявление.ВладелецЭЦПФамилия);
	ВладелецЭП.Вставить("snils", ДокументЗаявление.ВладелецЭЦПСНИЛС);
	ВладелецЭП.Вставить("post", ДокументЗаявление.ВладелецЭЦПДолжность);
	ВладелецЭП.Вставить("subdivision", ДокументЗаявление.ВладелецЭЦППодразделение);
	
	Если ДокументЗаявление.ВладелецЭЦППол = Перечисления.ПолФизическогоЛица.Мужской Тогда
		Пол = "1";
	ИначеЕсли ДокументЗаявление.ВладелецЭЦППол = Перечисления.ПолФизическогоЛица.Женский Тогда
		Пол = "2";
	Иначе
		Пол = "0";
	КонецЕсли;
	
	Гражданство = ДокументЗаявление.ВладелецЭЦПГражданство;
	КодАльфа2 = "RU";
	Если ЗначениеЗаполнено(Гражданство) И ЗначениеЗаполнено(Гражданство.КодАльфа2) Тогда
		КодАльфа2 = Гражданство.КодАльфа2;
	КонецЕсли;
	
	ВладелецЭП.Вставить("sex", Пол);
	ВладелецЭП.Вставить("date_birth", 	ДокументЗаявление.ВладелецЭЦПДатаРождения);
	ВладелецЭП.Вставить("place_birth",  ДокументЗаявление.ВладелецЭЦПМестоРождения);
	ВладелецЭП.Вставить("nationality",  КодАльфа2);
	
	ВладелецЭП.Вставить("identity_document", ПодготовитьДокументУдостоверяющийЛичность(ДокументЗаявление));
	
	Возврат ВладелецЭП;
	
КонецФункции

Функция ПолучитьПараметрыАутентификации(ДокументЗаявление)
	
	ПараметрыАутентификации = Новый Структура;
	ПараметрыАутентификации.Вставить("phone", ДокументЗаявление.ИдентификаторПроверкиТелефонаДляПаролей);
	ПараметрыАутентификации.Вставить("email", ДокументЗаявление.ИдентификаторПроверкиЭлектроннойПочтыДляПаролей);
	
	Возврат ПараметрыАутентификации;
	
КонецФункции

Функция ПодготовитьДокументУдостоверяющийЛичность(ДокументЗаявление)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КодВидаДокумента  = КонтекстЭДОСервер.ПолучитьКодВидаДокументаФизическогоЛица(ДокументЗаявление.ВладелецЭЦПВидДокумента);
	
	ДокументУдостоверяющийЛичность = Новый Структура;
	ДокументУдостоверяющийЛичность.Вставить("type", КодВидаДокумента);
	ДокументУдостоверяющийЛичность.Вставить("serial", ДокументЗаявление.ВладелецЭЦПСерияДокумента);
	ДокументУдостоверяющийЛичность.Вставить("number", ДокументЗаявление.ВладелецЭЦПНомерДокумента);
	ДокументУдостоверяющийЛичность.Вставить("issuer", ДокументЗаявление.ВладелецЭЦПКемВыданДокумент);
	ДокументУдостоверяющийЛичность.Вставить("issue_date", ДокументЗаявление.ВладелецЭЦПДатаВыдачиДокумента);
	ДокументУдостоверяющийЛичность.Вставить("issuer_code", ДокументЗаявление.ВладелецЭЦПКодПодразделения);
		
	Возврат ДокументУдостоверяющийЛичность;
	
КонецФункции

Функция ПодготовитьПолучателей(ДокументЗаявление)
	
	Получатели = Новый Массив;
	
	Если ДокументЗаявление.ПодатьЗаявкуНаСертификатДляФСРАР Тогда
		Получатель = Новый Структура;
		Получатель.Вставить("type", XMLСтрока(Перечисления.ТипыКонтролирующихОрганов.ФСРАР));
		Получатель.Вставить("code", XMLСтрока(ДокументЗаявление.КодРегионаФСРАР));
		Получатели.Добавить(Получатель);
	КонецЕсли;
	
	Если ДокументЗаявление.ПодатьЗаявкуНаПодключениеРПН Тогда
		Получатель = Новый Структура;
		Получатель.Вставить("type", XMLСтрока(Перечисления.ТипыКонтролирующихОрганов.РПН));
		Получатели.Добавить(Получатель);
	КонецЕсли;
	
	Если ДокументЗаявление.ПодатьЗаявкуНаПодключениеФТС Тогда
		Получатель = Новый Структура;
		Получатель.Вставить("type", XMLСтрока(Перечисления.ТипыКонтролирующихОрганов.ФТС));
		Получатели.Добавить(Получатель);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ДокументЗаявление.Получатели Цикл
		Получатель = Новый Структура;			
		Если СтрокаТаблицы.ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ФНС Тогда
			Получатель.Вставить("type", XMLСтрока(СтрокаТаблицы.ТипПолучателя));
			Получатель.Вставить("code", СтрокаТаблицы.КодПолучателя);
			Получатель.Вставить("kpp",  СтрокаТаблицы.КПП);
		ИначеЕсли СтрокаТаблицы.ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ФСС Тогда
			Получатель.Вставить("type", XMLСтрока(СтрокаТаблицы.ТипПолучателя));			
		Иначе
			Получатель = Новый Структура;
			Получатель.Вставить("type", XMLСтрока(СтрокаТаблицы.ТипПолучателя));
			Получатель.Вставить("code", СтрокаТаблицы.КодПолучателя);
		КонецЕсли;
		
		Получатели.Добавить(Получатель);
	КонецЦикла;
	
	Возврат Получатели;
	
КонецФункции

Функция ПодготовитьИзменившиесяРеквизиты(ДокументЗаявление)
	
	ИзменившиесяРеквизиты = Новый Массив;
	Для Каждого ИзменившийсяРеквизит Из ДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления Цикл
		ИзменившиесяРеквизиты.Добавить(XMLСтрока(ИзменившийсяРеквизит.ИзмененныйРеквизит));		
	КонецЦикла;
	
	Возврат ИзменившиесяРеквизиты;
	
КонецФункции

Функция ПолучитьИдентификаторАбонента(ДокументЗаявление)
	
	ИдентификаторАбонента = "";
	Если ДокументЗаявление.ТипЗаявления = Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение Тогда
		ИдентификаторАбонента = ДокументЗаявление.УчетнаяЗапись.ИдентификаторАбонента;		
	КонецЕсли;
	
	Возврат ИдентификаторАбонента;
	
КонецФункции

Функция ПодготовитьФайлы(ДокументЗаявление)
	
	Файлы = Новый Массив;
	
	Если ДокументЗаявление.ПодписатьЭП Тогда
		
		Для Каждого ЭлектронныйДокумент Из ДокументЗаявление.ЭлектронныеДокументы Цикл

			ПрисоединенныйФайл = ЭлектронныйДокумент.Файл;
			
			Если ЭлектронныйДокумент.Документ = "Заявление_на_подключение" 
				ИЛИ ЭлектронныйДокумент.Документ = "Заявление_на_изменение" Тогда
				document = "Заявление";
			Иначе
				document = ЭлектронныйДокумент.Документ;
			КонецЕсли;
			
			Результат = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, Новый УникальныйИдентификатор, Истина);
			Файл = Новый Структура;
			Файл.Вставить("document", 	document);
			Файл.Вставить("data", 		ПолучитьИзВременногоХранилища(Результат.СсылкаНаДвоичныеДанныеФайла));
			Файл.Вставить("type", 		Результат.Расширение);
			
			Если Результат.ПодписанЭП Тогда
				
				ДвоичныеДанныеПодписи = ЭлектроннаяПодпись.УстановленныеПодписи(ПрисоединенныйФайл)[0].Подпись;
				Если ТипЗнч(ДвоичныеДанныеПодписи) = Тип("ХранилищеЗначения") Тогда
					ДвоичныеДанныеПодписи = ДвоичныеДанныеПодписи.Получить();
				КонецЕсли;
				Файл.Вставить("signature", ДвоичныеДанныеПодписи);
				
			КонецЕсли;
			
			Файлы.Добавить(Файл);
				
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Файлы;
	
КонецФункции

#КонецОбласти