#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеСогласованиеРасходовНДДДУС.Форма.Форма2018_1";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2018_1";
	Стр.ОписаниеФормы = "В соответствии с приказом ФНС России от 24.12.2018 № ММВ-7-3/830@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Возврат ПечатьСразу_Форма2018_1(Объект);
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Возврат СформироватьМакет_Форма2018_1(Объект);
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Формат выгрузки не опубликован, проверка выгрузки не поддерживается'"));
	ВызватьИсключение "";
	
	Если ИмяФормы = "Форма2018_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2018_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2018_1" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2018_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2018_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2018_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Данные.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
		Данные.Вставить("ПодписантИмя", Объект.ПодписантИмя);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2018_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2018_1(СведенияОтправки)
	Префикс = "SR_UVOSVNALUGL";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2018_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИНН) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ИНН))
		Или СтрДлина(СокрЛП(Титульная.ИНН)) <> 10 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Титульная", "ИНН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КПП))
		Или СтрДлина(СокрЛП(Титульная.КПП)) <> 9 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан КПП", "Титульная", "КПП"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
		Если Не ЗначениеЗаполнено(Данные.ПодписантИмя) Или Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан подписант", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		КонецЕсли;
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО))
		Или СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации/ФИО физлица", "Титульная", "НаимОрг"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ПоМесту) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код по месту", "Титульная", "ПоМесту"));
	Иначе
		Если (Сред(Титульная.КПП, 5, 2) = "50" И (Титульная.ПоМесту <> "213"))
			Или ((Сред(Титульная.КПП, 5, 2) = "33" Или Сред(Титульная.КПП, 5, 2) = "57") И (Титульная.ПоМесту <> "247")) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан код по месту", "Титульная", "ПоМесту"));
		КонецЕсли;
	КонецЕсли;
	
	ЕстьЗаполненые = Ложь;
	Для Каждого Элт Из Данные.ДанныеМногостраничныхРазделов.Свед Цикл 
		Свед = Элт.Значение;
		Если Не ЗначениеЗаполнено(Свед.НалПериод)
			И Не ЗначениеЗаполнено(Свед.ОКТМО)
			И Не ЗначениеЗаполнено(Свед.СерЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НомЛицНедр)
			И Не ЗначениеЗаполнено(Свед.ВидЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НаимУчНедр) Тогда 
			
			Продолжить;
		КонецЕсли;
		
		ЕстьЗаполненые = Истина;
		Если Не ЗначениеЗаполнено(Свед.НалПериод) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый период", "Свед", "НалПериод", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.ОКТМО) 
			Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Свед.ОКТМО)) 
			Или (Не (СтрДлина(СокрЛП(Свед.ОКТМО)) = 8 Или СтрДлина(СокрЛП(Свед.ОКТМО)) = 11)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно заполнен ОКТМО", "Свед", "ОКТМО", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.СерЛицНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана серия лицензии", "Свед", "СерЛицНедр", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.НомЛицНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан номер лицензии", "Свед", "НомЛицНедр", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.ВидЛицНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан вид лицензии", "Свед", "ВидЛицНедр", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.НаимУчНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование", "Свед", "НаимУчНедр", Свед.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьЗаполненые Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнены сведения", "Свед", "ПрЗач", Данные.ДанныеМногостраничныхРазделов.Свед[0].Значение.УИД));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2018_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Ложь);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетностьПереопределяемый.КраткоеНазваниеПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ТлфПодп", Данные.ДанныеУведомления.Титульная.Тлф);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("НаимДок", Данные.ДанныеУведомления.Титульная.НаимДок);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2018_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2018_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	ДанныеУведомления.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
	ДанныеУведомления.Вставить("ПодписантИмя", Объект.ПодписантИмя);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2018_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2018_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2018_1");
	ЗаполнитьДанными_Форма2018_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ДополнитьПараметры_2018(Параметры)
	Если Параметры.ДанныеУведомления.Титульная.НомКорр = Неопределено Тогда 
		Параметры.ДанныеУведомления.Титульная.НомКорр = 0;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьДанными_Форма2018_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры_2018(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Узел, ПараметрыТекущейСтраницы = Неопределено, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если Стр.Тип = "А" Или Стр.Тип = "A" Или Стр.Тип = "П" Тогда
			Если ЗначениеЗаполнено(Стр.Ключ) Тогда
				ЗначениеПоказателя = Неопределено;
				Если ПараметрыТекущейСтраницы <> Неопределено И ПараметрыТекущейСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				ИначеЕсли ПараметрыТекущейСтраницы = Неопределено 
					И ЗначениеЗаполнено(Стр.Раздел)
					И ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Раздел, ЗначениеПоказателя) Тогда 
					Если ЗначениеПоказателя.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда
						РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда
				
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						Если УИДРодителя = Неопределено Или СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, СтрМнгч.Значение, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Стр, ПараметрыТекущейСтраницы, УИДРодителя)
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ПечатьСразу_Форма2018_1(Объект)
	ПечатнаяФорма = СформироватьМакет_Форма2018_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция СформироватьМакет_Форма2018_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.Вывести(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьМакет("МакетПредупреждениеОНевозможностиПечати"));
	Возврат ПечатнаяФорма;
КонецФункции

Процедура НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеСогласованиеРасходовНДДДУС.ПолучитьМакет(ИмяМакета);
	Исключение
		Возврат;
	КонецПопытки;
	
	НомСтр = НомСтр + 1;
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
		ИначеЕсли КЗ.Значение = Неопределено Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ, МакетПФ.Области, "-");
		КонецЕсли;
	КонецЦикла;
	
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
	ЗаполнитьЗначенияСвойств(МакетПФ.Параметры, СтруктураДанныхСтраницы);
	ПечатнаяФорма.Вывести(МакетПФ);
КонецПроцедуры

Процедура НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПарам, ПечатнаяФорма, НомСтр, ИННКПП)
	МакетыПФ = СтрПарам.МакетыПФ;
	ИмяМакета = СтрПарам.ИмяМакета;
	
	Если Не ЗначениеЗаполнено(МакетыПФ) И Не ЗначениеЗаполнено(ИмяМакета) Тогда 
		Для Каждого СтрПодч Из СтрПарам.Строки Цикл
			НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПодч, ПечатнаяФорма, НомСтр, ИННКПП);
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МакетыПФ) Тогда 
		МассивИменМакетов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МакетыПФ, ";");
	Иначе 
		МассивИменМакетов = Новый Массив;
		МассивИменМакетов.Добавить("ПФ_" + ИмяМакета);
	КонецЕсли;
	
	Если СтруктураПараметров.ДанныеУведомления.Свойство(СтрПарам.ИДНаименования) Тогда 
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл 
			СтруктураДанныхСтраницы = СтруктураПараметров.ДанныеУведомления[СтрПарам.ИДНаименования];
			Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(СтруктураДанныхСтраницы) Тогда
				НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП);
				Если СтрПарам.ИДНаименования = "Титульная" Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
					ПечатнаяФорма.Области.ЭлАдрес.Текст = СтруктураДанныхСтраницы.ЭлАдрес;
					Если Не ЗначениеЗаполнено(СтруктураДанныхСтраницы.НомерКорректировки) Тогда
						УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("0--", "НомерКорректировки", ПечатнаяФорма.Области);
					КонецЕсли;
				КонецЕсли;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2018_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2018_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	НомКоррСтр = ?(ЗначениеЗаполнено(СтруктураПараметров.ДанныеУведомления.Титульная.НомКорр), "" + СтруктураПараметров.ДанныеУведомления.Титульная.НомКорр + "---", "0--");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(НомКоррСтр, "НомКорр", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	НомСтр = 2;
	НапечататьЛистыРаздел1(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП);
	НапечататьЛистыРаздел23(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП);
	Возврат Листы;
КонецФункции

Процедура НапечататьЛистыРаздел1(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеСогласованиеРасходовНДДДУС.ПолучитьМакет("Печать_Форма2018_1_Раздел1");
		ОТЧ = Новый ОписаниеТипов("Число");
	Исключение
		Возврат;
	КонецПопытки;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.Вывести(МакетПФ);
	ТекИнд = 1;
	Для Каждого Элт Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Раздел1 Цикл
		Свед = Элт.Значение;
		Если Не ЗначениеЗаполнено(Свед.НалПериод)
			И Не ЗначениеЗаполнено(Свед.ОКТМО)
			И Не ЗначениеЗаполнено(Свед.СерЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НомЛицНедр)
			И Не ЗначениеЗаполнено(Свед.ВидЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НаимУчНедр) Тогда 
			
			Продолжить;
		КонецЕсли;
		
		ПФкс = "_" + ТекИнд;
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.НаимУчНедр, "НаимУчНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.НалПериод, "НалПериод" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.ОКТМО, "ОКТМО" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.СерЛицНедр, "СерЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.НомЛицНедр, "НомЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.ВидЛицНедр, "ВидЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		
		Если ТекИнд = 5 Тогда 
			ТекИнд = 1;
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
			НомСтр = НомСтр + 1;
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			ПечатнаяФорма.Вывести(МакетПФ);
			Продолжить;
		КонецЕсли;
		
		ТекИнд = ТекИнд + 1;
	КонецЦикла;
	
	Если ТекИнд <> 1 Тогда
		Пока ТекИнд <> 5 Цикл
			ПФкс = "_" + ТекИнд;
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "НаимУчНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "НалПериод" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "ОКТМО" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "СерЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "НомЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "ВидЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			ТекИнд = ТекИнд + 1;
		КонецЦикла;
		
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
		НомСтр = НомСтр + 1;
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	КонецЕсли;
КонецПроцедуры

Процедура НапечататьЛистыРаздел23(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП)
	Для Инд = 2 По 3 Цикл 
		МакетПФ = Отчеты.РегламентированноеУведомлениеСогласованиеРасходовНДДДУС.ПолучитьМакет("Печать_Форма2018_1_Раздел" + Инд);
		МакетПФПродолжение = Отчеты.РегламентированноеУведомлениеСогласованиеРасходовНДДДУС.ПолучитьМакет("Печать_Форма2018_1_Раздел" + Инд + "_Продолжение");
		Для Каждого Элт Из СтруктураПараметров.ДанныеМногостраничныхРазделов["Раздел" + Инд] Цикл
			Свед = Элт.Значение;
			Если Не ЗначениеЗаполнено(Свед.КодВидаРасходов) Тогда 
				Продолжить;
			КонецЕсли;
			
			МнгСтроки = СтруктураПараметров.ДанныеДопСтрокБД["МнгСтр" + (Инд-1)].НайтиСтроки(Новый Структура("УИД", Свед.УИД));
			ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
			ПечатнаяФорма.Вывести(МакетПФ);
			ТекИнд = 1;
			ЕстьЗаполненныеЛисты = Ложь;
			Для Каждого Стр Из МнгСтроки Цикл 
				Если Не ЗначениеЗаполнено(Стр.ИдентификаторНедр) Тогда 
					Продолжить;
				КонецЕсли;
				
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(Стр.ИдентификаторНедр, "ЧЦ=4; ЧВН=; ЧГ="), "ИдентификаторНедр_" + ТекИнд, ПечатнаяФорма.Области, "-");
				ТекИнд = ТекИнд + 1;
				
				Если ТекИнд = 161 Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(Свед.КодВидаРасходов, "ЧЦ=4; ЧГ="), "КодВидаРасходов", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.ПризнакОтнесения, "ПризнакОтнесения", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
					НомСтр = НомСтр + 1;
					УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
					ПечатнаяФорма.Вывести(МакетПФ);
					ТекИнд = 1;
					ЕстьЗаполненныеЛисты = Истина;
				КонецЕсли;
			КонецЦикла;
			
			Если ТекИнд <> 1 Или Не ЕстьЗаполненныеЛисты Тогда
				Пока ТекИнд <> 161 Цикл
					ПФкс = "_" + ТекИнд;
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "ИдентификаторНедр" + ПФкс, ПечатнаяФорма.Области, "-");
					ТекИнд = ТекИнд + 1;
				КонецЦикла;
				
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(Свед.КодВидаРасходов, "ЧЦ=4; ЧГ="), "КодВидаРасходов", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.ПризнакОтнесения, "ПризнакОтнесения", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
				НомСтр = НомСтр + 1;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Свед.Пояснения) Тогда
				ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
				ПечатнаяФорма.Вывести(МакетПФПродолжение);
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.Пояснения, "Пояснения", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
				НомСтр = НомСтр + 1;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
