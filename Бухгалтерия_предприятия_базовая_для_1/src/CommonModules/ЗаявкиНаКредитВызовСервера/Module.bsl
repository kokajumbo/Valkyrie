#Область ПрограммныйИнтерфейс

// Возвращает структуру с информацией о сервисе по кредитам.
// 
// Возвращаемое значение:
//	Структура - см. УниверсальныйОбменСБанками.СведенияОСервисе().
//
Функция СведенияОСервисе() Экспорт

	Возврат УниверсальныйОбменСБанками.СведенияОСервисе(Перечисления.СервисыОбменаСБанками.ЗаявкиНаКредит);

КонецФункции

// Получает массив непрочитанных сообщений от банков по заявкам на кредит текущего пользователя
//
// Параметры:
//  ПовторятьЗапрос - Булево - определяет, нужно ли позже вызвать функцию еще раз 
// 
// Возвращаемое значение:
//   - Массив - массив структур, содержащих описание нового состояния заявки на кредит
//
Функция НовыеСообщенияОтБанков(ПовторятьЗапрос) Экспорт

	Возврат РегистрыСведений.СостояниеЗаявокНаКредит.НовыеСообщенияОтБанков(ПовторятьЗапрос);

КонецФункции

// Возвращает ключ записи регистра сведений СостояниеЗаявокНаКредит
//
// Параметры:
//  ЗначенияКлюча - Структура - структура со свойствами:
//									- ЗаявкаНаКредит
//									- Организация
//									- Банк
// 
// Возвращаемое значение:
//   - РегистрСведенийКлючЗаписи.СостояниеЗаявокНаКредит
//
Функция КлючЗаписиСостоянияЗаявки(ЗначенияКлюча) Экспорт

	Возврат РегистрыСведений.СостояниеЗаявокНаКредит.СоздатьКлючЗаписи(ЗначенияКлюча);

КонецФункции

// По переданным значениям ключа находит запись регистра сведений СостояниеЗаявокНаКредит, определяет,
// требуется ли расшифровка, и в параметр Транзакция помещает ссылку на зашифрованную транзакцию
//
// Параметры:
//  ЗначенияКлюча - Структура - структура со свойствами:
//									- ЗаявкаНаКредит
//									- Организация
//									- Банк
//  Транзакция - СправочникСсылка.ТранзакцииОбменаСБанками - переменная, в которую помещается ссылка на зашифрованную транзакцию
// 
// Возвращаемое значение:
//   - Булево - Истина - запись существует и требует расшифровки
//
Функция ТребуетсяРасшифровкаСообщения(ЗначенияКлюча, Транзакция) Экспорт

	Запись = РегистрыСведений.СостояниеЗаявокНаКредит.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, ЗначенияКлюча);
	
	Запись.Прочитать();
			
	Если НЕ Запись.Выбран() ИЛИ НЕ ЗначениеЗаполнено(Запись.Транзакция) Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Транзакция = Запись.Транзакция;
	
	Возврат Запись.ТребуетсяРасшифровка;

КонецФункции

#КонецОбласти
