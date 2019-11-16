
#Область ПрограммныйИнтерфейс

// Возвращает данные, необходимые для выполнения операции закрытия кассовой смены
//
// Параметры:
//  РабочееМесто - СправочникСсылка.РабочиеМеста, Неопределено - рабочее место, для которого выполняется операция
//                 закрытия смены, может принимать значение Неопределено, если отсутствует подключаемое оборудование
//  КлючФормы - УникальныйИдентификатор - см. НовыеДанныеЗакрытияКассовойСмены
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - в случае интерактивного вызова операции закрытия смены
//                        с вызывающей формы передается КомпоновщикНастроек, используемый для возможной подстановки значений
//                        из настроенных на форме отборов
//
// Возвращаемое значение:
//  Структура - входящие параметры для операции закрытия кассовой смены, см. НовыеДанныеЗакрытияКассовойСмены
//
Функция ДанныеЗакрытияКассовойСмены(РабочееМесто, КлючФормы, КомпоновщикНастроек) Экспорт
	
	ДанныеЗакрытия = НовыеДанныеЗакрытияКассовойСмены();
	
	ДанныеЗакрытия.ОткрытыеСмены = ОткрытыеСмены(РабочееМесто);
	ДанныеЗакрытия.КлючФормы = КлючФормы;
	
	КоличествоОткрытыхСмен = ДанныеЗакрытия.ОткрытыеСмены.Количество();
	Если КоличествоОткрытыхСмен = 1
		Или (Не Справочники.Организации.ИспользуетсяНесколькоОрганизаций() И КоличествоОткрытыхСмен > 0) Тогда
		// Если открытые смены есть только по одной организации, то сразу используем ее в качестве организации по-умолчанию и
		// определим данные кассира
		Организация = ДанныеЗакрытия.ОткрытыеСмены[0].Организация;
		ДанныеЗакрытия.Кассир = ПредставлениеКассира(Организация);
		ДанныеЗакрытия.Организация = Организация;
	Иначе
		// Если в форме, из которой происходит вызов операции закрытия кассовой смены, установлен отбор по организации,
		// то используем значение отбора для организации по-умолчанию
		ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(КомпоновщикНастроек);
		Если ЗначенияЗаполнения.Свойство("Организация") Тогда
			ДанныеЗакрытия.Организация = ЗначенияЗаполнения.Организация;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеЗакрытия;
	
КонецФункции

// Функция - Сформировать отчеты о розничных продажах
//
// Параметры:
//  Организация - СправочникСсылка.Организации - в формируемые отчеты о розничных продажах попадут чеки с установленным
//                                               отбором по данной организации
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - кассовое устройство по которому будет установлен отбор
//                                                                        на чеки, попадающие в формируемые отчеты о розничных продажах
//
// Возвращаемое значение:
//  Массив - Созданные отчеты о розничных продажах (ДокументСсылка.ОтчетОРозничныхПродажах)
//
Функция СформироватьОтчетыОРозничныхПродажах(Организация, ИдентификаторУстройства) Экспорт

	Возврат Документы.РозничнаяПродажа.СформироватьОтчетыОРозничныхПродажах(Организация, ИдентификаторУстройства);

КонецФункции

// Возвращает картинку, обозначающую состояние кассовой смены
//
// Параметры:
//  СменаОткрыта - Булево - Истина, если кассовая смена открыта
//
// Возвращаемое значение:
//  Картинка - из библиотеки картинок, соответствует переданному состоянию кассовой смены (смена открыта или закрыта)
//
Функция ПиктограммаСостоянияКассовойСмены(СменаОткрыта) Экспорт
	
	Если СменаОткрыта Тогда
		Возврат БиблиотекаКартинок.СообщениеСервиса;
	Иначе
		Возврат БиблиотекаКартинок.ЗакрытаяКассоваяСмена;
	КонецЕсли;
	
КонецФункции

// Заполняет имя кассира, предварительно определив организацию по-умолчанию
//
// Возвращаемое значение:
//  Строка - представление кассира для заполнения в кассовых документах
//
Функция ПредставлениеКассираДляОрганизацииПоУмолчанию() Экспорт
	
	ТипыОборудования = МенеджерОборудованияКлиентСерверБП.ТипыКонтрольноКассовойТехники();
	Организация = ОбщегоНазначенияБПВызовСервера.ОрганизацияПодключаемогоОборудованияПоУмолчанию(ТипыОборудования);
	Возврат ПредставлениеКассира(Организация);
	
КонецФункции

// Возвращает представление кассира, для заполнения в кассовых документах
//
// Параметры:
//  Организация - СправочникСсылка.Организации - данные кассира будут получены с отбором по переданной организации
//
// Возвращаемое значение:
//  Строка - текстовое представление данных кассира
//
Функция ПредставлениеКассира(Организация) Экспорт
	
	ДанныеКассира = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛицаТекущегоПользователя(Организация);
	Если ДанныеКассира.Представление <> Неопределено Тогда
		Кассир = СтрШаблон(НСтр("ru = '%1 %2'"), Строка(ДанныеКассира.Должность), ДанныеКассира.Представление);
	Иначе
		Кассир = НСтр("ru = 'Администратор'"); // в чеке обязательно должно быть заполнено представление кассира, иначе
		                                       // при печати драйвер кассового аппарата вернет ошибку. Если у пользователя
		                                       // не заполнен реквизит "Физическое лицо", данные кассира будут пустыми, в
		                                       // этом случае воспользуемся принятым в библиотеке подключаемого оборудования
		                                       // представлением по-умолчанию "Администратор"
	КонецЕсли;
	Возврат Кассир;
	
КонецФункции

// Проверяет наличие у пользователя необходимых прав для выполнения операций с кассовой сменой
//
// Возвращаемое значение:
//  Булево - Истина, если у пользователя есть все необходимые права
//
Функция ДоступноУправлениеКассовойСменой() Экспорт
	
	Возврат ПравоДоступа("Добавление", Метаданные.Документы.КассоваяСмена)
		И ПравоДоступа("Чтение", Метаданные.Справочники.ПодключаемоеОборудование)
		И ПравоДоступа("Чтение", Метаданные.Справочники.РабочиеМеста);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыеДанныеЗакрытияКассовойСмены()
	
	ДанныеЗакрытия = Новый Структура;
	ДанныеЗакрытия.Вставить("Организация",   Справочники.Организации.ПустаяСсылка()); // организация,
	                                                                     // используемая по-умолчанию
	ДанныеЗакрытия.Вставить("ОткрытыеСмены", Новый Массив); // для каждой открытой кассовой смены массив содержит
	                                                        // структуру со следующими свойствами:
	                                         // * Организация - СправочникСсылка.Организация - организация открытой
                                             //                 кассовой смены
	                                         // * ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - 
	                                         //                 ссылка на экземпляр подключаемого оборудования, к которому
	                                         //                 относится открытая кассовая смена
	ДанныеЗакрытия.Вставить("Кассир",        ""); // информация о кассире, которая выводится в кассовые документы
	ДанныеЗакрытия.Вставить("КлючФормы",     Новый УникальныйИдентификатор); // уникальный идентификатор формы,
	                                         // из которой произошел вызов операции закрытия кассовой смены
	Возврат ДанныеЗакрытия;
	
КонецФункции

Функция ОткрытыеСмены(РабочееМесто)
	
	// Возможен сценарий работы, при котором пользователь, не подключая кассу, пробивает продажи отдельными
	// чеками и формирует на их основании отчеты о розничных продажах, используя операцию закрытия кассовой смены.
	// Поскольку в описаном сценарии документ "Кассовая смена" не формируется (т.к. кассовое устройство по факту
	// отсутствует) происходит обращение непосредственно к чекам (документ "Розничная продажа") и в этом случае
	// чеки могут отбираться за любой период. Основным условием отбора является отбор по реквизиту
	// "ОтчетОРозничныхПродажах", этот реквизит входит в состав критерия отбора "СвязанныеДокументы", поэтому его
	// не требуется дополнительно индексировать
	//
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	КассоваяСмена.ФискальноеУстройство КАК ИдентификаторУстройства,
	|	КассоваяСмена.Организация КАК Организация
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|	И КассоваяСмена.ФискальноеУстройство.РабочееМесто = &РабочееМесто
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РозничнаяПродажа.ИдентификаторУстройства,
	|	РозничнаяПродажа.Организация
	|ИЗ
	|	Документ.РозничнаяПродажа КАК РозничнаяПродажа
	|ГДЕ
	|	РозничнаяПродажа.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|	И РозничнаяПродажа.Проведен
	|	И РозничнаяПродажа.ИдентификаторУстройства = ЗНАЧЕНИЕ(Справочник.ПодключаемоеОборудование.ПустаяСсылка)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	
	// Массив структур используется для совместимости с процедурой "ЗакрытьСмену", общего модуля
	// "КассовыеСменыКлиентБП", а также для передачи его в качестве параметра в форму "ФормаЗакрытиеСмены"
	// документа "РозничнаяПродажа"
	//
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

#КонецОбласти







