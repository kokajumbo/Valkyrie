////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными в модели сервиса".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события формы ПриЧтенииНаСервере, который
// встраивается в формы элементов данных
// (элементов справочников, документов, записей регистров, и др.),
// чтобы заблокировать форму, если это попытка изменения неразделенных данных,
// получаемых из приложения, в автономном рабочем месте.
//
// Параметры:
//	ТекущийОбъект - Объект, который зачитывается
//	ТолькоПросмотр - Булево - Свойство ТолькоПросмотр формы.
//
Процедура ОбъектПриЧтенииНаСервере(ТекущийОбъект, ТолькоПросмотр) Экспорт
	
	Если Не ТолькоПросмотр Тогда
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекущийОбъект));
		АвтономнаяРаботаСлужебный.ОпределитьВозможностьИзмененияДанных(ОбъектМетаданных, ТолькоПросмотр);
		
	КонецЕсли;
	
КонецПроцедуры

// Отключает автоматическую синхронизацию между приложением в интернете
// и автономным рабочим местом в случаях когда, не задан пароль для установки подключения.
//
// Параметры:
//	Источник - Запись регистра сведений "Настройки транспорта обмена", которая была изменена.
//
Процедура ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете(Источник) Экспорт
	АвтономнаяРаботаСлужебный.ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете(Источник);
КонецПроцедуры

// Читает и устанавливает настройку предупреждение о продолжительной синхронизации АРМ
// Параметры:
//     ЗначениеФлага     - Булево - устанавливаемое значение флага
//     ОписаниеНастройки - Структура - принимает значение для описания настройки.
//
Функция ФлагНастройкиВопросаОДолгойСинхронизации(ЗначениеФлага = Неопределено, ОписаниеНастройки = Неопределено) Экспорт
	Возврат АвтономнаяРаботаСлужебный.ФлагНастройкиВопросаОДолгойСинхронизации(ЗначениеФлага, ОписаниеНастройки);
КонецФункции

// Возвращает адрес для восстановления пароля учетной записи приложения в интернете
//
Функция АдресДляВосстановленияПароляУчетнойЗаписи() Экспорт
	Возврат АвтономнаяРаботаСлужебный.АдресДляВосстановленияПароляУчетнойЗаписи();
КонецФункции

// Настраивает автономное рабочее место при первом запуске.
// Заполняет состав пользователей и другие настройки.
// Вызывается перед авторизацией пользователя. Может потребоваться перезапуск.
//
// Параметры:
//   Параметры - Структура - структура параметров.
// 
Функция ПродолжитьНастройкуАвтономногоРабочегоМеста(Параметры) Экспорт
	
	Если Не АвтономнаяРаботаСлужебный.НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Попытка
		АвтономнаяРаботаСлужебный.ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске();
		Параметры.Вставить("ПерезапуститьПослеНастройкиАвтономногоРабочегоМеста");
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		Параметры.Вставить("ОшибкаПриНастройкеАвтономногоРабочегоМеста",
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
