///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРКРиски".
// ОбщийМодуль.СПАРКРискиКлиентСерверПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет свойства контрагента в форме или подписках на события.
//
// Параметры:
//	КонтрагентОбъект - ДанныеФормыСтруктура, СправочникОбъект - данные контрагента;
//	Форма - УправляемаяФорма - форма, из которой вызывается обработчик.
//		Если вызывается вне формы, тогда значение Неопределено;
//	СвойстваКонтрагента - Структура - в параметре возвращаются свойства контрагента:
//		* ИНН - Строка - ИНН контрагента. Значение по умолчанию - пустая строка;
//		* ПодлежитПроверке - Булево - в параметре необходимо возвратить Истина, если контрагент
//			подлежит проверке в сервисе 1СПАРК Риски, Ложь - в противном случае.
//			Важно. Сервис 1СПАРК Риски предоставляет информацию только по не иностранным
//			юридическим лицам;
//			Значение по умолчанию - Ложь;
//		* СвояОрганизация - Булево - признак того, что контрагент является собственным.
//			Значение по умолчанию - Ложь.
//			Свойство может быть использовано для отбора данных в отчетах.
//
Процедура ПриОпределенииСвойствКонтрагентаВОбъекте(КонтрагентОбъект, Форма, СвойстваКонтрагента) Экспорт
	
	СвойстваКонтрагента.ИНН = КонтрагентОбъект.ИНН;
	СвойстваКонтрагента.ПодлежитПроверке = Не КонтрагентОбъект.ЭтоГруппа
		И КонтрагентОбъект.ЮридическоеФизическоеЛицо =
			ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо")
		И НЕ КонтрагентОбъект.ОбособленноеПодразделение;
	
КонецПроцедуры

#Область ИндексыСПАРККонтрагента

// Выводит информацию об индексах СПАРК Риски в элемент управления.
// В случае, если информации нет в кэше, то инициируется фоновое задание.
// Если передан ИНН, то информация получается напрямую из веб-сервиса без фонового задания.
//
// Параметры:
//  РезультатИндексыКонтрагента - Структура - ключи описаны в СПАРКРискиКлиентСервер.НовыйДанныеИндексов();
//  КонтрагентОбъект            - Объект, Неопределено - заполняется в том случае, если форма - это форма элемента справочника, а не форма документа.
//  Контрагент                  - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  Форма                       - УправляемаяФорма - форма, в которой необходимо вывести информацию об индексах СПАРК Риски.
//  ИспользованиеРазрешено      - Булево - признак разрешения использования функциональности;
//  Параметры                   - Структура - прочие параметры;
//  СтандартнаяОбработка        - Булево - если вернуть сюда Ложь, то стандартная обработка не будет происходить.
//
Процедура ОтобразитьИндексыСПАРК(
			РезультатИндексыКонтрагента,
			КонтрагентОбъект,
			Контрагент,
			Форма,
			ИспользованиеРазрешено,
			Параметры,
			СтандартнаяОбработка) Экспорт
	
	СПАРКРискиКлиентСерверБП.ОтобразитьИндексыСПАРК(
			РезультатИндексыКонтрагента,
			КонтрагентОбъект,
			Контрагент,
			Форма,
			ИспользованиеРазрешено,
			Параметры,
			СтандартнаяОбработка);
	
КонецПроцедуры

// Возвращает информацию об индексах СПАРК Риски в виде структуры форматированных строк.
// В случае, если информации нет в кэше, то инициируется фоновое задание.
// Если передан ИНН, то информация получается напрямую из веб-сервиса без фонового задания.
//
// Параметры:
//  ПредставленияИндексов - Структура - сюда необходимо передать форматированные строки, если необходимо переопределение;
//  РезультатИндексыКонтрагента - Структура, Неопределено - результата выполнения функции ИндексыСПАРККонтрагента
//                                 (ключи описаны в СПАРКРискиКлиентСервер.НовыйДанныеИндексов()),
//                                 или Неопределено, если необходимо вызвать эту функцию;
//  Контрагент - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  Форма      - УправляемаяФорма - форма, в которой необходимо вывести информацию об индексах СПАРК Риски;
//  СтандартнаяОбработка - Булево - если вернуть сюда Ложь, то стандартная обработка не будет происходить.
//
Процедура ПолучитьПредставленияИндексов(
			ПредставленияИндексов,
			РезультатИндексыКонтрагента,
			Контрагент,
			Форма,
			СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти
