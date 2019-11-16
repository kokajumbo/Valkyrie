
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстРекомендацияПриОшибке = ТекстРекомендацияПриОшибке();
	Элементы.ТекстРекомендаций.Заголовок = ТекстРекомендацияПриОшибке;
	Элементы.ВключениеСинхронизацииТекстРекомендаций.Заголовок = ТекстРекомендацияПриОшибке;
	Элементы.СохранениеНастроекТекстРекомендаций.Заголовок = ТекстРекомендацияПриОшибке;
	
	ЦветГруппыЗаписи = ЦветаСтиля.ОценкаРискаНалоговойПроверкиФонЕстьОснованияЦвет;
	
	ДлительнаяОперацияПриОткрытии = ЗапуститьПроверкуПодключенияВФоне(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДлительнаяОперацияПриОткрытии <> Неопределено Тогда
		
		ОжидатьЗавершенияПроверкиДоступностиСинхронизацииВФоне(ДлительнаяОперацияПриОткрытии);
		ДлительнаяОперацияПриОткрытии = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru = 'Настройки были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КоличествоДнейДоНапоминанияПриИзменении(Элемент)
	
	ЗаголовокВремениНапоминания = ЗаголовокВремениНапоминания(КоличествоДнейДоНапоминания);
	УстановитьОтображениеНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НапоминатьОСобытииПриИзменении(Элемент)
	
	УстановитьОтображениеНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНапоминанияПриИзменении(Элемент)
	
	УстановитьОтображениеНастроек(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьКод(Команда)
	
	НавигационнаяСсылкаНаСайтGoogle = АдресЗапросаНаПодтверждениеДоступа();
	ОбщегоНазначенияКлиент.ПерейтиПоСсылке(НавигационнаяСсылкаНаСайтGoogle);
	
КонецПроцедуры

&НаКлиенте
Процедура Включить(Команда)
	
	ВключитьСинхронизациюСКалендарем();
	
КонецПроцедуры

&НаКлиенте
Процедура Отключить(Команда)
	
	ОтключитьСинхронизациюСКалендарем();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступ(Команда)
	
	ДлительнаяОперация = ЗапуститьПроверкуПодключенияВФоне(Истина);
	Если ДлительнаяОперация <> Неопределено Тогда
		ОжидатьЗавершенияПроверкиДоступностиСинхронизацииВФоне(ДлительнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьСинхронизациюПовторно(Команда)
	
	ОтключитьСинхронизациюСКалендарем();
	
	НавигационнаяСсылкаНаСайтGoogle = АдресЗапросаНаПодтверждениеДоступа();
	ОбщегоНазначенияКлиент.ПерейтиПоСсылке(НавигационнаяСсылкаНаСайтGoogle);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьИзменения(Команда)
	
	Если КоличествоДнейДоНапоминания < 29 Тогда
		
		ДлительнаяОперация = ЗапуститьЗаписьНастроекНапоминанийВФоне();
		Если ДлительнаяОперация <> Неопределено Тогда
			ОжидатьЗавершенияЗаписиНастроекНапоминанийВФоне(ДлительнаяОперация, Ложь);
		КонецЕсли;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Можно указать не более 28 дней до наступления события'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КоличествоДнейДоНапоминания");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзменения(Команда)
	
	ОтменитьИзмененияНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьСостояниеПодключения(Форма, Состояние, ТекстОшибки)
	
	Элементы = Форма.Элементы;
	
	Форма.ТекстОшибки = ТекстОшибки;
	
	СинхронизацияОтключена = Состояние = "СинхронизацияОтключена";
	СинхронизацияВключена  = Состояние = "СинхронизацияВключена";
	ВыполняетсяДлительнаяОперация = 
		Состояние = "ПроверкаДоступа" ИЛИ Состояние = "ВыполняетсяПодключениеКСервису" ИЛИ Состояние = "ЗаписьНастроекНапоминаний";
	ОшибкаПриСинхронизации = Состояние = "ОшибкаПриСинхронизации";
	ОшибкаПриСохраненииНастроек = Состояние = "ОшибкаПриСохраненииНастроек";
	
	ПроизошлаОшибка = ЗначениеЗаполнено(ТекстОшибки);
	
	Если НЕ (СинхронизацияОтключена ИЛИ СинхронизацияВключена 
		ИЛИ ВыполняетсяДлительнаяОперация ИЛИ ОшибкаПриСинхронизации) Тогда
		ВызватьИсключение НСтр("ru = 'При отражении состояния подключения возникла ошибка'");
	КонецЕсли;
	
	Элементы.ГруппаСинхронизацияОтключена.Видимость = СинхронизацияОтключена;
	Элементы.Включить.КнопкаПоУмолчанию             = СинхронизацияОтключена;
	Элементы.ГруппаОжидание.Видимость               = ВыполняетсяДлительнаяОперация;
	Элементы.ГруппаСинхронизацияВключена.Видимость  = СинхронизацияВключена;
	Элементы.ГруппаОшибкаСинхронизации.Видимость    = ОшибкаПриСинхронизации;
	
	Элементы.ГруппаВключениеСинхронизацииТекстОшибки.Видимость = СинхронизацияОтключена И ПроизошлаОшибка;
	
	Если СинхронизацияВключена Тогда
		УстановитьОтображениеНастроек(Форма);
	КонецЕсли;
	
	Если Состояние = "ПроверкаДоступа" Тогда
		Форма.СостояниеОжидания = НСтр("ru = 'Выполняется проверка доступа к календарю...'");
	ИначеЕсли Состояние = "ЗаписьНастроекНапоминаний" Тогда
		Форма.СостояниеОжидания = НСтр("ru = 'Обновляются напоминания в календаре...'");
	Иначе
		Форма.СостояниеОжидания = НСтр("ru = 'Выполняется подключение...'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресЗапросаНаПодтверждениеДоступа()
	
	Возврат СинхронизацияСКалендаремGoogle.АдресЗапросаНаПодтверждениеДоступа();
	
КонецФункции

&НаКлиенте
Процедура ВключитьСинхронизациюСКалендарем()
	
	Если Не ЗначениеЗаполнено(КодРазрешения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите код разрешения для доступа к календарю'"), , "КодРазрешения");
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ВключитьСинхронизациюСКалендаремВФоне();
	Если ДлительнаяОперация <> Неопределено Тогда
		ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьНаКлиентеВключениеСинхронизацииВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВключитьСинхронизациюСКалендаремВФоне()
	
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("КодРазрешения", КодРазрешения);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
		НСтр("ru = 'Включение синхронизации с календарем Google'"));
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"СинхронизацияСКалендаремGoogle.ВключитьСинхронизациюВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);
	
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "ВыполняетсяПодключениеКСервису", "");
		
		Возврат ДлительнаяОперация;
		
	Иначе
		
		ЗавершитьВключениеСинхронизацииВФоне(ДлительнаяОперация);
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОтключитьСинхронизациюСКалендарем()
	
	СинхронизацияСКалендаремGoogle.ОтключитьСинхронизацию();
	КодРазрешения = "";
	ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияОтключена", "");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНаКлиентеПроверкуДоступностиСинхронизацииВФоне(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	ЗавершитьПроверкуДоступностиСинхронизацииВФоне(ДлительнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПроверкуДоступностиСинхронизацииВФоне(ДлительнаяОперация)
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		
		РезультатПроверки = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если РезультатПроверки.СинхронизацияДоступна Тогда
			ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияВключена", "");
		Иначе
			ОтобразитьСостояниеПодключения(ЭтотОбъект, "ОшибкаПриСинхронизации", РезультатПроверки.ТекстОшибки);
		КонецЕсли;
	Иначе
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "ОшибкаПриСинхронизации", ДлительнаяОперация.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНаКлиентеВключениеСинхронизацииВФоне(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	ЗавершитьВключениеСинхронизацииВФоне(ДлительнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьВключениеСинхронизацииВФоне(ДлительнаяОперация)
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		
		РезультатПодключения = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если РезультатПодключения.Статус = "СинхронизацияВключена" Тогда
			Пользователь = Пользователи.ТекущийПользователь();
			НастройкиСинхронизации = СинхронизацияСКалендаремGoogle.НастройкиСинхронизации(Пользователь);
			Если НастройкиСинхронизации.Включено Тогда
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиСинхронизации);
				ЗаголовокВремениНапоминания = ЗаголовокВремениНапоминания(КоличествоДнейДоНапоминания);
			КонецЕсли;
			ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияВключена", "");
		Иначе
			КодРазрешения = "";
			ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияОтключена", РезультатПодключения.ТекстОшибки);
		КонецЕсли;
		
	Иначе
		
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияОтключена", ДлительнаяОперация.КраткоеПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьПроверкуПодключенияВФоне(ВыполнитьСинхронизацию)
	
	Пользователь = Пользователи.ТекущийПользователь();
	НастройкиСинхронизации = СинхронизацияСКалендаремGoogle.НастройкиСинхронизации(Пользователь);
	Если НастройкиСинхронизации.Включено Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиСинхронизации);
		ЗаголовокВремениНапоминания = ЗаголовокВремениНапоминания(КоличествоДнейДоНапоминания);
		
		ДлительнаяОперация = ПроверитьДоступностьСинхронизацииВФоне(ВыполнитьСинхронизацию);
		Если ДлительнаяОперация.Статус = "Выполняется" Тогда
			ОтобразитьСостояниеПодключения(ЭтотОбъект, "ПроверкаДоступа", "");
			Возврат ДлительнаяОперация;
		Иначе
			ЗавершитьПроверкуДоступностиСинхронизацииВФоне(ДлительнаяОперация);
		КонецЕсли;
		
	Иначе
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияОтключена", "");
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ОжидатьЗавершенияПроверкиДоступностиСинхронизацииВФоне(ДлительнаяОперация)
	
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьНаКлиентеПроверкуДоступностиСинхронизацииВФоне", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьДоступностьСинхронизацииВФоне(ВыполнитьСинхронизацию)
	
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("ВыполнитьСинхронизациюПослеПроверки", ВыполнитьСинхронизацию);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
		НСтр("ru = 'Проверка доступа к календарю Google'"));
	ПараметрыВыполненияВФоне.Вставить("ОжидатьЗавершение", 0);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"СинхронизацияСКалендаремGoogle.ПроверитьДоступностьСинхронизацииВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);
	
КонецФункции

&НаСервере
Функция ЗаписатьНастройкиНапоминанийВФоне()
	
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("Пользователь",                Пользователи.ТекущийПользователь());
	ПараметрыПроцедуры.Вставить("НапоминатьОСобытии",          НапоминатьОСобытии);
	ПараметрыПроцедуры.Вставить("КоличествоДнейДоНапоминания", КоличествоДнейДоНапоминания);
	ПараметрыПроцедуры.Вставить("ВремяНапоминания",            ВремяНапоминания);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
		НСтр("ru = 'Применение настроек синхронизации для календаря Google'"));
	// Ожидаем завершения задания секунду.
	// Это легкая операция и для большинства случаев этого должно хватить.
	// Если не хватит - скорее всего возникли какие-то проблемы.
	ПараметрыВыполненияВФоне.Вставить("ОжидатьЗавершение", 1);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"СинхронизацияСКалендаремGoogle.ЗаписатьНастройкиНапоминанийВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокВремениНапоминания(КоличествоДней)
	
	ПараметрыПредметаИсчисления = НСтр("ru = 'день, дня, дней'");
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 в'"),
		СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДней, ПараметрыПредметаИсчисления, Ложь));
	
КонецФункции

&НаСервере
Функция ТекстРекомендацияПриОшибке()
	
	МассивТекстаРекомендаций = Новый Массив;
	Если ОбщегоНазначения.РазделениеВключено()
		ИЛИ ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		МассивТекстаРекомендаций.Добавить(НСтр("ru = 'Попробуйте включить синхронизацию повторно.'"));
	Иначе
		МассивТекстаРекомендаций.Добавить(НСтр("ru = 'Проверьте настройки'") + " ");
		МассивТекстаРекомендаций.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'прокси-сервера'"),,,, "e1cib/app/ОбщаяФорма.ПараметрыПроксиСервера"));
		МассивТекстаРекомендаций.Добавить(" " + НСтр("ru = 'или попробуйте включить синхронизацию повторно.'"));
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(МассивТекстаРекомендаций);
	
КонецФункции

&НаСервере
Процедура ОтменитьИзмененияНастроек()
	
	Пользователь = Пользователи.ТекущийПользователь();
	НастройкиСинхронизации = СинхронизацияСКалендаремGoogle.НастройкиСинхронизации(Пользователь);
	Если НастройкиСинхронизации.Включено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиСинхронизации);
		ЗаголовокВремениНапоминания = ЗаголовокВремениНапоминания(КоличествоДнейДоНапоминания);
	КонецЕсли;
	
	Модифицированность = Ложь;
	УстановитьОтображениеНастроек(ЭтотОбъект);
	
	ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияВключена", "");
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьЗаписьНастроекНапоминанийВФоне()
	
	ДлительнаяОперация = ЗаписатьНастройкиНапоминанийВФоне();
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "ЗаписьНастроекНапоминаний", "");
		Возврат ДлительнаяОперация;
	Иначе
		ЗавершитьЗаписьНастроекНапоминанийВФоне(ДлительнаяОперация);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗавершитьЗаписьНастроекНапоминанийВФоне(ДлительнаяОперация)
	
	Модифицированность = Ложь;
	УстановитьОтображениеНастроек(ЭтотОбъект);
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "СинхронизацияВключена", "");
	Иначе
		ОтобразитьСостояниеПодключения(ЭтотОбъект, "ОшибкаПриСохраненииНастроек", ДлительнаяОперация.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеНастроек(Форма)
	
	Элементы = Форма.Элементы;
	Если Форма.Модифицированность Тогда
		Элементы.ГруппаСинхронизацияВключенаНапоминания.ЦветФона = Форма.ЦветГруппыЗаписи;
		Элементы.ГруппаПрименить.Видимость = Истина;
	Иначе
		Элементы.ГруппаСинхронизацияВключенаНапоминания.ЦветФона = Новый Цвет;
		Элементы.ГруппаПрименить.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.КоличествоДнейДоНапоминания.Доступность = Форма.НапоминатьОСобытии;
	Элементы.ВремяНапоминания.Доступность = Форма.НапоминатьОСобытии;
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершенияЗаписиНастроекНапоминанийВФоне(ДлительнаяОперация, ЗакрыватьПослеВыполнения)
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ПараметрыОповещения = Новый Структура("ЗакрыватьПослеВыполнения", ЗакрыватьПослеВыполнения);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьНаКлиентеЗаписьНастроекНапоминанийВФоне", ЭтотОбъект, ПараметрыОповещения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНаКлиентеЗаписьНастроекНапоминанийВФоне(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	ЗавершитьЗаписьНастроекНапоминанийВФоне(ДлительнаяОперация);
	
	Если ДополнительныеПараметры.ЗакрыватьПослеВыполнения Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		
		ДлительнаяОперация = ЗапуститьЗаписьНастроекНапоминанийВФоне();
		Если ДлительнаяОперация <> Неопределено Тогда
			ОжидатьЗавершенияЗаписиНастроекНапоминанийВФоне(ДлительнаяОперация, Истина);
		Иначе
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
