////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиент: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает настройку обмена с банком или открывает существующую.
// Если банк не известен системе, то открывается форма новой настройки обмена с банком,
// в которой заполнена только Организация и Банк.
// Если банк известен системе, но не поддерживает автоматическое получение настроек,
// то предлагается выбор файла настроек, загружает настройки из файла
// и открывает заполненную форму настроек обмена с банком.
// Если банк известен системе и поддерживает автоматическое получение настроек,
// то настройка создается автоматически и производится тест настроек.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - ссылка на организацию.
//  Банк - СправочникСсылка.КлассификаторБанков - ссылка на банк.
//  НомерБанковскогоСчета - Строка - номер банковского счета.
//  ОбработчикОповещения - ОписаниеОповещения - содержит описание процедуры,
//   которая будет вызвана после создания настройки обмена с банком, не вызывается если настройка обмена уже существует. Параметры процедуры:
//    * НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - созданная настройка обмена с банком.
//    * ДополнительныеПараметры - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура ОткрытьСоздатьНастройкуОбмена(Организация, Банк, НомерБанковскогоСчета = "", ОбработчикОповещения = Неопределено) Экспорт
	
	ЕстьПравоПросмотраНастройкиЭДО = Ложь; ФОВключенаСейчас = Ложь; ЕстьПравоНастройкиЭДО = Ложь;
	
	ТекущаяНастройка = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(
		Организация, Банк, Истина, Истина, ЕстьПравоПросмотраНастройкиЭДО, ЕстьПравоНастройкиЭДО, ФОВключенаСейчас);
		
	ТекстСообщения = НСтр("ru = 'Недостаточно прав для настройки прямого обмена с банком.
								|Обратитесь к администратору.'");
		
	Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
		Если Не ЕстьПравоПросмотраНастройкиЭДО Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		Если ФОВключенаСейчас Тогда
			Если ОбработчикОповещения <> Неопределено Тогда
				ВыполнитьОбработкуОповещения(ОбработчикОповещения, ТекущаяНастройка);
			КонецЕсли;
			Возврат
		ИначеЕсли НЕ ФОВключенаСейчас И НЕ ЕстьПравоНастройкиЭДО Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		ПоказатьЗначение( , ТекущаяНастройка);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("Банк", Банк);
	ПараметрыФормы.Вставить("НомерБанковскогоСчета", НомерБанковскогоСчета);
	
	ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.ПомощникСозданияНастройкиОбмена", ПараметрыФормы, , , , ,
		ОбработчикОповещения);
	
КонецПроцедуры

// Отправляет запрос выписки в банк, а после получения выписки вызывает оповещение о выборе.
// для формы или элемента формы, указанного в параметре Владелец.
// Может возвращать ДокументСсылка.СообщениеОбменСБанками или Массив с элементами указанного типа.
//
// Параметры:
//  НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - текущая настройка обмена с банком;
//  ДатаНачала - Дата - начало периода запроса.
//  ДатаОкончания - Дата - окончание периода запроса.
//  Владелец - УправляемаяФорма, ЭлементФормы - получатель оповещения о выборе элемента - выписки банка.
//  НомерСчета - Строка - номер банковского счета организации. Если не указан, то запрос по всем счетам.
//  ОткрыватьФормуУточненияПериода - Булево - не используется, оставлено в целях обратной совместимости.
//
Процедура ПолучитьВыпискуБанка(НастройкаОбмена, ДатаНачала, Знач ДатаОкончания, Владелец, НомерСчета = Неопределено, ОткрыватьФормуУточненияПериода = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(НастройкаОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если ДатаНачала > ТекущаяДатаСеанса Тогда
		СообщениеТекст = НСтр("ru = 'Дата начала периода запроса не должна быть позднее текущей даты.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеТекст, , "НачалоПериода");
		Возврат;
	КонецЕсли;
	
	Если ДатаОкончания > КонецДня(ТекущаяДатаСеанса) Тогда
		СообщениеТекст = НСтр("ru = 'Дата конца периода запроса не должна быть позднее текущей даты.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеТекст, , "КонецПериода");
		Возврат;
	КонецЕсли;
	
	Если ДатаНачала > ДатаОкончания Тогда
		СообщениеТекст = НСтр("ru = 'Дата начала периода запроса не должна быть позднее даты конца периода.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеТекст, , "НачалоПериода");
		Возврат;
	КонецЕсли;
	
	Если КонецДня(ДатаОкончания) = КонецДня(ТекущаяДатаСеанса) Тогда
		ДатаОкончания = ТекущаяДатаСеанса;
	Иначе
		ДатаОкончания = КонецДня(ДатаОкончания);
	КонецЕсли;
	
	РеквизитыНастройкиОбмена = Новый Структура("Недействительна, ПрограммаБанка, ИмяВнешнегоМодуля,
		|ИспользуетсяКриптография, АутентификацияПоСертификату, ДополнительнаяОбработка, ПравоВыполненияОбмена");
	ОбменСБанкамиСлужебныйВызовСервера.ПолучитьЗначенияРеквизитовНастройкиОбмена(
		НастройкаОбмена, РеквизитыНастройкиОбмена);
	
	Если РеквизитыНастройкиОбмена.Недействительна Тогда
		ТекстСообщения = НСтр("ru = 'Настройка обмена недействительна, операция невозможна.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Не РеквизитыНастройкиОбмена.ПравоВыполненияОбмена Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав на выполнение обмена с банком через сервис 1С:ДиректБанк.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("НастройкаОбмена", НастройкаОбмена);
	Параметры.Вставить("НомерСчета", НомерСчета);
	Параметры.Вставить("ДатаНачала", ДатаНачала);
	Параметры.Вставить("ДатаОкончания", ДатаОкончания);
	Параметры.Вставить("Владелец", Владелец);
	Параметры.Вставить("РеквизитыНастройкиОбмена", РеквизитыНастройкиОбмена);
	
	Если РеквизитыНастройкиОбмена.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезВК") Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ПродолжитьПолучениеВыпискиПослеПодготовкиЗапросовЧерезВК", ОбменСБанкамиСлужебныйКлиент, Параметры);
		ПараметрыЗапроса = ОбменСБанкамиКлиентСервер.ПараметрыПолученияВыпискиБанка();
		ПараметрыЗапроса.ДатаНачала = ДатаНачала;
		ПараметрыЗапроса.ДатаОкончания = ДатаОкончания;
		ПараметрыЗапроса.НомерСчета = НомерСчета;
		ОбменСБанкамиСлужебныйКлиент.ПодготовитьЗапросыВыписокДляОтправкиЧерезВК(
			Оповещение, НастройкаОбмена, ПараметрыЗапроса);
	ИначеЕсли РеквизитыНастройкиОбмена.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку") Тогда
		ОбработчикПослеПодключения = Новый ОписаниеОповещения(
			"ПолучитьВыпискуЧерезДополнительнуюОбработку", ОбменСБанкамиСлужебныйКлиент, Параметры);
		ОбменСБанкамиСлужебныйКлиент.ПолучитьВнешнийМодульЧерезДополнительнуюОбработку(
			ОбработчикПослеПодключения,  РеквизитыНастройкиОбмена.ДополнительнаяОбработка);
	ИначеЕсли РеквизитыНастройкиОбмена.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн") Тогда
		
		ГотовыеВыписки = ОбменСБанкамиСлужебныйВызовСервера.ГотовыеВыпискиСбербанка(
			НастройкаОбмена, ДатаНачала, ДатаОкончания, НомерСчета);
			
		Если ГотовыеВыписки.Количество() Тогда
			Параметры.Вставить("ГотовыеВыписки", ГотовыеВыписки);
			ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения(
				"ПолучитьВыпискуСбербанкаПослеВопросаОбИхНаличии", ОбменСБанкамиСлужебныйКлиент, Параметры);
			ТекстВопроса = НСтр("ru = 'В базе уже есть выписки банка за указанный период.
									|Загрузить выписки из базы или получить новые из банка?'");
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(Истина, НСтр("ru = 'Загрузить из базы'"));
			Кнопки.Добавить(Ложь, НСтр("ru = 'Получить из банка'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			Заголовок = НСтр("ru = 'Выбор способа получения выписки'");
			ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, Кнопки, , Истина, Заголовок);
		Иначе
			Если РеквизитыНастройкиОбмена.ИспользуетсяКриптография Тогда
				ОповещениеПослеАутентификацииНаТокене = Новый ОписаниеОповещения(
					"ОпределитьСертификатПодписиПослеАутентификацииНаТокенеСбербанк", ОбменСБанкамиСлужебныйКлиент, Параметры);
				ОбменСБанкамиСлужебныйКлиент.АутентифицироватьсяНаТокенеСбербанка(
					ОповещениеПослеАутентификацииНаТокене, РеквизитыНастройкиОбмена.ИмяВнешнегоМодуля, НастройкаОбмена);
			Иначе
				Обработчик = Новый ОписаниеОповещения(
					"ПолучитьВыпискиПослеБазовойАутентификацииСбербанк", ОбменСБанкамиСлужебныйКлиент, Параметры);
				ОбменСБанкамиСлужебныйКлиент.ВыполнитьАутентификациюПоЛогинуСбербанк(
					Обработчик, РеквизитыНастройкиОбмена.ИмяВнешнегоМодуля, НастройкаОбмена, НастройкаОбмена);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли РеквизитыНастройкиОбмена.ИспользуетсяКриптография Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ПослеПолученияОтпечатковПолучитьВыпискуБанка", ОбменСБанкамиСлужебныйКлиент, Параметры);
		ЭлектроннаяПодписьКлиент.ПолучитьОтпечаткиСертификатов(Оповещение, Истина, Ложь);
	Иначе
		МассивОтпечатковСертификатов = Новый Соответствие;
		ОбменСБанкамиСлужебныйКлиент.ПослеПолученияОтпечатковПолучитьВыпискуБанка(МассивОтпечатковСертификатов, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Отправляет подготовленные документы в банк и получает новые.
// Если параметры не переданы то выполняется синхронизация по всем настройкам с банками.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация из расчетного счета.
//  Банк - СправочникСсылка.КлассификаторБанков - банк из расчетного счета.
//
Процедура СинхронизироватьСБанком(Организация = Неопределено, Банк = Неопределено) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если НЕ ОбменСБанкамиСлужебныйВызовСервера.ПравоВыполненияОбмена(Истина) Тогда
			Возврат;
		ИначеЕсли НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменСБанками") Тогда
			ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ТекстСообщенияОНеобходимостиНастройкиСистемы("РАБОТАСБАНКАМИ");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Банк) Тогда
		НастройкаОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(Организация, Банк, Ложь, Ложь);
		МассивНастроекОбмена = Новый Массив;
		Если ЗначениеЗаполнено(НастройкаОбмена) Тогда
			МассивНастроекОбмена.Добавить(НастройкаОбмена);
		КонецЕсли;
	Иначе
		МассивНастроекОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкиОбмена(Организация, Банк);
	КонецЕсли;
	
	Если МассивНастроекОбмена.Количество() > 1 Тогда
		ПараметрыФормы = Новый Структура("МассивНастроекОбмена", МассивНастроекОбмена);
		ОткрытьФорму("Обработка.ОбменСБанками.Форма.Синхронизация", ПараметрыФормы, , , , , ,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли МассивНастроекОбмена.Количество() = 1 Тогда
		ОбменСБанкамиСлужебныйКлиент.СинхронизироватьСБанком(Новый ОписаниеОповещения, МассивНастроекОбмена.Получить(0), Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура создает, подписывает и отправляет электронный документ.
//
// Параметры:
//  ПараметрКоманды - ДокументСсылка, Массив - ссылки на документы ИБ, которые необходимо отправить в банк.
//  СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - электронный документ, который надо подписать, отправить.
//
Процедура СформироватьПодписатьОтправитьЭД(ПараметрКоманды, СообщениеОбмена = Неопределено) Экспорт
	
	МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(ПараметрКоманды);
	Если МассивСсылок = Неопределено Тогда
		Если СообщениеОбмена = Неопределено Тогда
			Возврат;
		Иначе
			МассивСсылок = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	
	ОбменСБанкамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "СформироватьПодписатьОтправить", СообщениеОбмена);
	
КонецПроцедуры

// Процедура отправляет повторно электронный документ.
//
// Параметры:
//  ПараметрКоманды - СсылкаНаОбъект - ссылка на объект ИБ, электронные документы которого нужно отправить,
//  СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение, которые нужно отправить.
//
Процедура ОтправитьПовторноЭД(ПараметрКоманды, СообщениеОбмена = Неопределено) Экспорт
	
	МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(ПараметрКоманды);
	Если МассивСсылок = Неопределено Тогда
		Если СообщениеОбмена = Неопределено Тогда
			Возврат;
		Иначе
			МассивСсылок = Новый Массив;
		КонецЕсли;
	КонецЕсли;
	
	ОбменСБанкамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "ОтправитьПовторно", СообщениеОбмена);
	
КонецПроцедуры

// Открывает актуальный ЭД по документу ИБ
//
// Параметры:
//  ПараметрКоманды - ДокументСсылка- ссылка на документ ИБ;
//  Источник - УправляемаяФорма - Форма источник;
//  ПараметрыОткрытия - Структура - дополнительные параметры просмотра.
//
Процедура ОткрытьАктуальныйЭД(ПараметрКоманды, Источник = Неопределено, ПараметрыОткрытия = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если НЕ ОбменСБанкамиСлужебныйВызовСервера.ПравоЧтенияДанных(Истина) Тогда
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(ПараметрКоманды);
	Если МассивСсылок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеВладельцевИСообщенийОбмена = ОбменСБанкамиСлужебныйВызовСервера.СообщенияОбменаПоВладельцам(МассивСсылок);
	Для Каждого ТекЭл Из МассивСсылок Цикл
		
		СсылкаНаСообщениеОбмена = СоответствиеВладельцевИСообщенийОбмена.Получить(ТекЭл);
		Если ЗначениеЗаполнено(СсылкаНаСообщениеОбмена) Тогда
			Если ТипЗнч(ПараметрыОткрытия) = Тип("ПараметрыВыполненияКоманды") Тогда
				ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(
					СсылкаНаСообщениеОбмена, ПараметрыОткрытия, ПараметрыОткрытия.Источник);
			Иначе
				ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(СсылкаНаСообщениеОбмена, , Источник);
			КонецЕсли;
			
		Иначе
			ТекстШаблона = НСтр("ru = '%1. Актуальный электронный документ не найден.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстШаблона, ТекЭл);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Открывает форму со списком электронных документов для данного владельца.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - Ссылка на объект ИБ, электронные документы которого надо увидеть или сообщение обмена.
//  ПараметрыОткрытия - Структура - дополнительные параметры просмотра списка электронных документов.
//
Процедура ОткрытьСписокЭД(СсылкаНаОбъект, ПараметрыОткрытия = Неопределено) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если НЕ ОбменСБанкамиСлужебныйВызовСервера.ПравоЧтенияДанных(Истина) Тогда
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОбъектОтбора", СсылкаНаОбъект);
	Если ПараметрыОткрытия = Неопределено Тогда
		ОткрытьФорму(
			"Документ.СообщениеОбменСБанками.Форма.СписокЭД", ПараметрыФормы, , СсылкаНаОбъект.УникальныйИдентификатор());
	Иначе
		Окно = Неопределено;
		Если ТипЗнч(ПараметрыОткрытия) = Тип("ПараметрыВыполненияКоманды") Тогда
			Окно = ПараметрыОткрытия.Окно;
		КонецЕсли;
		ОткрытьФорму("Документ.СообщениеОбменСБанками.Форма.СписокЭД", ПараметрыФормы,
			ПараметрыОткрытия.Источник, СсылкаНаОбъект.УникальныйИдентификатор(), Окно);
	КонецЕсли;
	
КонецПроцедуры

// Процедура создает новый электронный документ.
//
// Параметры:
//  ПараметрКоманды - СсылкаНаОбъект - ссылка на объект ИБ, электронные документы которого надо отправить.
//  Показывать - Булево - признак того что созданный документ будет показан пользователю.
//
Процедура СформироватьНовыйЭД(ПараметрКоманды, Показывать=Истина) Экспорт
	
	МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(ПараметрКоманды);
	Если МассивСсылок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Показывать Тогда
		ОбменСБанкамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "СформироватьПоказать");
	Иначе
		ОбменСБанкамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "Сформировать");
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из одноименной процедуры модуля ЭлектроннаяПодписьКлиентПереопределяемый.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//  * ОжидатьПродолжения   - Булево - (возвращаемое значение) - если Истина, тогда дополнительная проверка
//                            будет выполнятся асинхронно, продолжение возобновится после выполнения оповещения.
//                            Начальное значение Ложь.
//  * Оповещение           - ОписаниеОповещения - обработка, которую нужно вызывать для продолжения
//                              после асинхронного выполнения дополнительной проверки.
//  * Сертификат           - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
//  * Проверка             - Строка - имя проверки, добавленное в процедуре ПриСозданииФормыПроверкаСертификата
//                              общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * МенеджерКриптографии - МенеджерКриптографии - подготовленный менеджер криптографии для
//                              выполнения проверки.
//                         - Неопределено - если стандартные проверки отключены в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * ОписаниеОшибки       - Строка - (возвращаемое значение) - описание ошибки, полученной при выполнении проверки.
//                              Это описание сможет увидеть пользователь при нажатии на картинку результата.
//  * ЭтоПредупреждение    - Булево - (возвращаемое значение) - вид картинки Ошибка/Предупреждение 
//                            начальное значение Ложь.
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	Если Параметры.Проверка = "УстановкаПодписиСбербанк" Тогда
		Параметры.ОжидатьПродолжения = Истина;
		ПроверитьУстановкуПодписиСбербанк(Параметры.Оповещение, Параметры.Сертификат, Параметры);
	ИначеЕсли Параметры.Проверка = "ПроверкаПодписиСбербанк" Тогда
		Параметры.ОжидатьПродолжения = Истина;
		ПроверитьПодписьСбербанк(Параметры.Оповещение, Параметры.Сертификат, Параметры);
	ИначеЕсли Параметры.Проверка = "УстановкаПодписиЧерезВК" Тогда
		Параметры.ОжидатьПродолжения = Истина;
		ПроверитьУстановкуПодписиЧерезВК(Параметры.Оповещение, Параметры.Сертификат, Параметры);
	ИначеЕсли Параметры.Проверка = "ПроверкаПодписиЧерезВК" Тогда
		Параметры.ОжидатьПродолжения = Истина;
		ПроверитьПодписьЧерезВК(Параметры.Оповещение, Параметры.Сертификат, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму списка настроек обмена с отбором по организации или банку.
//
// Параметры:
//  СсылкаНаОбъект - СправочникСсылка - ссылка на объект отбора. Ссылка должна быть только на организацию или банк.
//
Процедура ОткрытьНастройкиDirectBankСОтбором(СсылкаНаОбъект) Экспорт
	
	НазваниеСправочникаБанки = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ИмяПрикладногоСправочника("Банки");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаБанки) Тогда
		НазваниеСправочникаБанки = "КлассификаторБанков";
	КонецЕсли;
	
	НазваниеСправочникаОрганизации = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ИмяПрикладногоСправочника(
		"Организации");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаОрганизации) Тогда
		НазваниеСправочникаОрганизации = "Организации";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(СсылкаНаОбъект) = Тип("СправочникСсылка." + НазваниеСправочникаОрганизации) Тогда
		ПараметрыФормы.Вставить("Организация", СсылкаНаОбъект);
	ИначеЕсли ТипЗнч(СсылкаНаОбъект) = Тип("СправочникСсылка." + НазваниеСправочникаБанки) Тогда
		ПараметрыФормы.Вставить("Банк", СсылкаНаОбъект);
	КонецЕсли;

	ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

// Процедура обрабатывает нажатие ссылки форматированной строки рекламы 1С:ДиректБанк.
//
// Параметры:
//  НавигационнаяСсылка - Строка - текст навигационной ссылки;
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ОбработкаНавигационнойСсылкиРекламыДиректБанк(НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	ОчиститьСообщения();
	Если НавигационнаяСсылка = "ОткрытьПомощникСозданияНастройкиОбмена" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытия = Новый Структура("УпрощенныйРежимНастройки", Истина);
		ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.ПомощникСозданияНастройкиОбмена", ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обновляет отображение контекстной рекламы 1С:ДиректБанк при оповещении формы.
//
// Параметры:
//  ИмяСобытия - Строка - идентификатор сообщения оповещения формы;
//  ГруппаРекламы - ГруппаФормы - группа элементов контекстной рекламы;
//  ДекорацияТекстРекламы - ДекорацияФормы - декорация, в заголовке которой отображается текст рекламы.
//
Процедура ОбновитьРекламуДиректБанк(ИмяСобытия, ГруппаРекламы, ДекорацияТекстРекламы) Экспорт
	
	Если ИмяСобытия = "ИзмененаНастройкаОбмена" Тогда
		ОбменСБанкамиКлиентСервер.ПоказатьРекламуДиректБанк(ГруппаРекламы, ДекорацияТекстРекламы);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обрабатывает нажатие на рекламную ссылку на форме печати БСП.
//
// Параметры:
//  НавигационнаяСсылка - Строка - текст навигационной ссылки;
//  МассивСсылок - Массив - ссылка на объекты ИБ, которые передали на печать.
//
Процедура ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, МассивСсылок) Экспорт
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		
		ДанныеБанковскогоСчета = ОбменСБанкамиСлужебныйВызовСервера.ПолучитьДанныеБанковскогоСчетаИзДокумента(МассивСсылок[0]);
		
		Если ДанныеБанковскогоСчета <> Неопределено Тогда
			ТекущаяНастройка = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(
				ДанныеБанковскогоСчета.Организация, ДанныеБанковскогоСчета.Банк, Истина, Ложь);
		Иначе
			ТекущаяНастройка = Неопределено;
		КонецЕсли;
			
		Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
			ПоказатьЗначение( , ТекущаяНастройка);	
		Иначе
			ОткрытьФорму("Обработка.ОбменСБанками.Форма.ПредложениеПодключить1СДиректБанк", ДанныеБанковскогоСчета);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму просмотра электронного документа.
//
// Параметры:
//  СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение, в которому привязан открываемый электронный документ.
//
Процедура ОткрытьФормуПросмотраЭлектронногоДокумента(СообщениеОбмена) Экспорт
	
	ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(СообщениеОбмена);
	
КонецПроцедуры

// Обрабатывает событие нажатия на гиперссылку в форме списка платежных документов
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.СообщениеОбменСБанками - сообщение обмена с банком
//  СтандартнаяОбработка - Булево - признак стандартной обработки нажатия на ссылку.
//
Процедура ПриНажатииНаГиперссылку(ДокументСсылка, СтандартнаяОбработка) Экспорт

	ОчиститьСообщения();
	
	РеквизитыЭД = ОбменСБанкамиСлужебныйВызовСервера.РеквизитыЭлектронногоДокумента(ДокументСсылка);
	Если Не ЗначениеЗаполнено(РеквизитыЭД) Тогда // не используется прямой обмен с банком
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(РеквизитыЭД.Состояние)
		ИЛИ РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.НеСформирован") Тогда
		СформироватьНовыйЭД(ДокументСсылка, Ложь);
	ИначеЕсли РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.ТребуетсяОтправка") Тогда
		СформироватьПодписатьОтправитьЭД(ДокументСсылка);
	ИначеЕсли РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.ТребуетсяПодтверждение") Тогда
		Если РеквизитыЭД.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен") Тогда
			ТекстСообщения = НСтр("ru = 'Подтвердить платеж можно только в личном кабинете банка.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Иначе
			СформироватьПодписатьОтправитьЭД(ДокументСсылка);
		КонецЕсли;
	ИначеЕсли РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.Аннулирован")
		ИЛИ РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.Отклонен")
		ИЛИ РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.ОшибкаПередачи") Тогда
		ПараметрыФормы = Новый Структура("СообщениеОбмена", РеквизитыЭД.СообщениеОбмена);
		ОткрытьФорму("Документ.СообщениеОбменСБанками.Форма.ПричинаОтклонения", ПараметрыФормы);
	ИначеЕсли РеквизитыЭД.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияОбменСБанками.НаПодписи") Тогда
		МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(ДокументСсылка);
		ОбменСБанкамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "Подписать");
	Иначе
		ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(РеквизитыЭД.СообщениеОбмена);
	КонецЕсли;
	
КонецПроцедуры

// Включает автоматическое получение выписки.
//
// Параметры:
//  Оповещение - ОписаниеОповещение - оповещение, вызываемое после выполнения процедуры. Параметры выполнение:
//    Результат - Булево - если Истина, то автоматическое получение выписки подключено успешно.
//  Организация - ОпределяемыйТип.Организация - ссылка на организацию.
//  Банк - ОпределяемыйТип.БанкОбменСБанками - ссылка на банк.
//
Процедура ВключитьАвтоматическоеПолучениеВыписки(Оповещение, Организация, Банк) Экспорт
	
	ЕстьПравоНастройки = Ложь;
	НастройкаОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(
		Организация, Банк, Истина, Истина, , ЕстьПравоНастройки);
	
	Если Не ЕстьПравоНастройки Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав на выполнение настройки обмена с банком через сервис 1С:ДиректБанк.
									|Обратитесь к администратору.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НастройкаОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Отсутствует действующая настройка обмена с банком через сервис 1С:ДиректБанк'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ОповещениеПрикладногоРешения", Оповещение);
	ПараметрыФормы = Новый Структура("НастройкаОбмена", НастройкаОбмена);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеВключенияАвтоматическогоПолученияВыписки", ОбменСБанкамиСлужебныйКлиент, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.АвтоматическоеПолучениеВыписки", ПараметрыФормы, , , , ,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Отключает автоматическое получение выписки.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - ссылка на организацию.
//  Банк - ОпределяемыйТип.БанкОбменСБанками - ссылка на банк.
//
// Возвращаемое значение:
//  Булево - Истина, если автоматическое получение выписки было отключено.
// 
Функция ОтключитьАвтоматическоеПолучениеВыписки(Организация, Банк) Экспорт
	
	ЕстьПравоНастройки = Ложь;
	НастройкаОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(
		Организация, Банк, Истина, Истина, , ЕстьПравоНастройки);
	
	Если Не ЕстьПравоНастройки Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав на выполнение настройки обмена с банком через сервис 1С:ДиректБанк.
									|Обратитесь к администратору.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НастройкаОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Отсутствует действующая настройка обмена с банком через сервис 1С:ДиректБанк'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	ОбменСБанкамиСлужебныйВызовСервера.ОстановитьАвтоматическоеПолучениеВыписки(НастройкаОбмена);
	
	Возврат Истина
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет механизм установки подписи для сертификата сбербанка
// 
// Параметры:
//    Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после установки подписи.
//    Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на сертификат.
//    Контекст - Структура - контекст из ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата.
//
Процедура ПроверитьУстановкуПодписиСбербанк(Оповещение, Сертификат, Контекст)

	ИмяВнешнегоМодуля = Неопределено;
	НастройкаОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбменаПоСертификату(Сертификат, ИмяВнешнегоМодуля);
	Если Не ЗначениеЗаполнено(НастройкаОбмена) Тогда
		ОписаниеОшибки = НСтр("ru = 'Не найдена действующая настройка обмена с сервисом 1С:ДиректБанка с данным сертификатом'");
		Контекст.ОписаниеОшибки = ОписаниеОшибки;
		ВыполнитьОбработкуОповещения(Оповещение, Контекст);
		Возврат;
	КонецЕсли;
	Параметры = Новый Структура;
	Параметры.Вставить("ОповещениеПослеПодписания", Оповещение);
	Параметры.Вставить("Сертификат", Сертификат);
	Параметры.Вставить("Контекст", Контекст);
	Параметры.Вставить("ИмяВнешнегоМодуля", ИмяВнешнегоМодуля);
		
	ОповещениеПослеАутентификации = Новый ОписаниеОповещения(
		"ПроверитьУстановкуПодписиПослеАутентификацииНаТокенеСбербанк", ОбменСБанкамиСлужебныйКлиент, Параметры);

	ОбменСБанкамиСлужебныйКлиент.АутентифицироватьсяНаТокенеСбербанка(
		ОповещениеПослеАутентификации, ИмяВнешнегоМодуля, НастройкаОбмена, Истина);
	
КонецПроцедуры

// Проверяет механизм установки подписи для сертификата сбербанка
// 
// Параметры:
//    Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после установки подписи.
//    Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на сертификат.
//    Контекст - Структура - контекст из ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата.
//
Процедура ПроверитьПодписьСбербанк(Оповещение, Сертификат, Контекст)

	Подпись = ОбменСБанкамиСлужебныйКлиент.ЗначениеИзКэшаСбербанк("ТестоваяПодпись");
	ИмяМодуля = Неопределено;
	НастройкаОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбменаПоСертификату(Сертификат, ИмяМодуля);
	
	Если Не ЗначениеЗаполнено(Подпись) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПодписиBase64 = "JiMxMDU4OyYjMTA3NzsmIzEwODk7JiMxMDkwOw==";
	
	РеквизитыСертификата = Новый Структура("ДанныеСертификата");
	ОбменСБанкамиСлужебныйВызовСервера.ПолучитьЗначенияРеквизитовСертификата(Сертификат, РеквизитыСертификата);
		
	Параметры = Новый Структура;
	Параметры.Вставить("ОповещениеПослеТестаПодписиСертификата", Оповещение);
	Параметры.Вставить("Контекст", Контекст);
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗавершитьТестПодписиСертификатаСбербанк", ОбменСБанкамиСлужебныйКлиент, Параметры);
	
	ОбменСБанкамиСлужебныйКлиент.ПроверитьПодписьНаТокенеСбербанк(
		Оповещение, СтрокаПодписиBase64, Подпись, РеквизитыСертификата.ДанныеСертификата, ИмяМодуля);
		
КонецПроцедуры

// Проверяет механизм установки подписи для сертификата, загруженного через ВК
// 
// Параметры:
//    Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после установки подписи.
//    Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на сертификат.
//    Контекст - Структура - контекст из ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата.
//
Процедура ПроверитьУстановкуПодписиЧерезВК(Оповещение, Сертификат, Контекст)

	НастройкаОбмена = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбменаПоСертификату(Сертификат);
	Если Не ЗначениеЗаполнено(НастройкаОбмена) Тогда
		ОписаниеОшибки = НСтр("ru = 'Не найдена действующая настройка обмена с сервисом 1С:ДиректБанк с данным сертификатом'");
		Контекст.ОписаниеОшибки = ОписаниеОшибки;
		ВыполнитьОбработкуОповещения(Оповещение, Контекст);
		Возврат;
	КонецЕсли;
	Параметры = Новый Структура;
	Параметры.Вставить("ОповещениеПослеПодписания", Оповещение);
	Параметры.Вставить("Сертификат", Сертификат);
	Параметры.Вставить("Контекст", Контекст);
	
	ОповещениеПослеПодключенияВК = Новый ОписаниеОповещения(
		"АутентификацияНаКлючеПослеПодключенияВК", ОбменСБанкамиСлужебныйКлиент, Параметры);
	
	ОбменСБанкамиСлужебныйКлиент.ПодключитьИИнициализироватьВК(ОповещениеПослеПодключенияВК, НастройкаОбмена);
	
КонецПроцедуры

// Проверяет механизм проверки подписи для сертификата, загруженного через ВК
// 
// Параметры:
//    Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после установки подписи.
//    Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на сертификат.
//    Контекст - Структура - контекст из ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата.
//
Процедура ПроверитьПодписьЧерезВК(Оповещение, Сертификат, Контекст)

	Подпись = ПараметрыПриложения.Получить("ЭлектронноеВзаимодействие.ОбменСБанками.ДанныеПодписиВК");
	ПодключаемыйМодуль = ПараметрыПриложения.Получить("ЭлектронноеВзаимодействие.ОбменСБанками.ПодключаемыйМодуль");
	
	Если Не ЗначениеЗаполнено(Подпись) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПодписиBase64 = "JiMxMDU4OyYjMTA3NzsmIzEwODk7JiMxMDkwOw==";
	
	РеквизитыСертификата = Новый Структура("ДанныеСертификата");
	ОбменСБанкамиСлужебныйВызовСервера.ПолучитьЗначенияРеквизитовСертификата(Сертификат, РеквизитыСертификата);
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОповещениеПослеТестаПодписиЧерезВК", Оповещение);
	Параметры.Вставить("Контекст", Контекст);
	
	ОповещениеПослеПроверкиПодписи = Новый ОписаниеОповещения(
		"ЗавершитьТестСертификатаЧерезВК", ОбменСБанкамиСлужебныйКлиент, Параметры);
	
	ОбменСБанкамиСлужебныйКлиент.ПроверитьПодписьЧерезВК(ОповещениеПослеПроверкиПодписи, ПодключаемыйМодуль,
		СтрокаПодписиBase64, РеквизитыСертификата.ДанныеСертификата, Подпись);
		
КонецПроцедуры

#КонецОбласти

