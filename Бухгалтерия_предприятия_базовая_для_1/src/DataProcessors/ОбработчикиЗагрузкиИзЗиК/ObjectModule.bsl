#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
//
// Данный модуль содержит экспортные процедуры обработчиков событий конвертации 
// и предназначен для отладки правил обмена. 
// После отладки рекомендуется внести соответствующие исправления обработчиков
// в базе «Конвертация данных 2.0» и заново сформировать файл правил.
//
////////////////////////////////////////////////////////////////////////////////
// ИСПОЛЬЗУЕМЫЕ СОКРАЩЕНИЯ ИМЕН ПЕРЕМЕННЫХ (АББРЕВИАТУРЫ)
//
//  ПКО  - правило конвертации объектов
//  ПКС  - правило конвертации свойств объектов
//  ПКГС - правило конвертации группы свойств объектов
//  ПКЗ  - правило конвертации значений объектов
//  ПВД  - правило выгрузки данных
//  ПОД  - правило очистки данных


////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБРАБОТКИ


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПЕРЕМЕННЫЕ МОДУЛЯ ДЛЯ НАПИСАНИЯ АЛГОРИТМОВ (ОБЩИЕ ДЛЯ ВЫГРУЗКИ И ЗАГРУЗКИ)

Перем Параметры;
Перем Правила;
Перем Алгоритмы;
Перем Запросы;
Перем УзелДляОбмена; // только для on-line обмена
Перем ОбщиеПроцедурыФункции;
Перем ДатаНачала;
Перем ДатаОкончания;
Перем ДатаВыгрузкиДанных; // только для on-line обмена
Перем КомментарийПриВыгрузкеДанных;
Перем КомментарийПриЗагрузкеДанных;


////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБРАБОТОК ОБМЕНА (ОБЩИЕ ДЛЯ ВЫГРУЗКИ И ЗАГРУЗКИ)

Перем одТипСтрока;                // Тип("Строка")
Перем одТипБулево;                // Тип("Булево")
Перем одТипЧисло;                 // Тип("Число")
Перем одТипДата;                  // Тип("Дата")
Перем одТипХранилищеЗначения;     // Тип("ХранилищеЗначения")
Перем одТипДвоичныеДанные;        // Тип("ДвоичныеДанные")
Перем одТипВидДвиженияНакопления; // Тип("ВидДвиженияНакопления")
Перем одТипУдалениеОбъекта;       // Тип("УдалениеОбъекта")
Перем одТипВидСчета;			  // Тип("ВидСчета")
Перем одТипТип;			  		  // Тип("Тип")
Перем одТипСоответствие;		  // Тип("Соответствие")

Перем одТипУзлаXML_КонецЭлемента;
Перем одТипУзлаXML_НачалоЭлемента;
Перем одТипУзлаXML_Текст;

Перем ЗначениеПустаяДата;


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ (ГЛОБАЛЬНЫЕ)


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ ОБЪЕКТОВ

Процедура ПКО_ПослеЗагрузки_ОтражениеЗарплатыВУчете(ФайлОбмена, Отказ, Ссылка, Объект, ПараметрыОбъекта, ОбъектМодифицирован, 
                                           ИмяТипаОбъекта, ОбъектНайден, НаборЗаписей) Экспорт

	Объект.Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ПКО_ПослеЗагрузки_СтатьиЗатрат(ФайлОбмена, Отказ, Ссылка, Объект, ПараметрыОбъекта, ОбъектМодифицирован, 
                                           ИмяТипаОбъекта, ОбъектНайден, НаборЗаписей) Экспорт

	Если Не ОбъектНайден Тогда
		Объект.Записать();
		УчетЗарплаты.ЗаполнитьНедостающиеРеквизитыЗагруженныхОбъектов(Объект) 
	КонецЕсли;

КонецПроцедуры

Процедура ПКО_ПоследовательностьПолейПоиска_ФизическиеЛица(НомерВариантаПоиска, СвойстваПоиска, ПараметрыОбъекта, ПрекратитьПоиск, 
                                           СсылкаНаОбъект, УстанавливатьУОбъектаВсеСвойстваПоиска, 
                                           СтрокаИменСвойствПоиска) Экспорт

	Если СвойстваПоиска["ЭтоГруппа"] = Истина Тогда
		СтрокаИменСвойствПоиска = "ЭтоГруппа, Наименование";
	Иначе
		СтрокаИменСвойствПоиска = "ЭтоГруппа, Наименование, ДатаРождения";
	КонецЕсли;

КонецПроцедуры

Процедура ПКО_ПослеЗагрузки_ПрочиеДоходыИРасходы(ФайлОбмена, Отказ, Ссылка, Объект, ПараметрыОбъекта, ОбъектМодифицирован, 
                                           ИмяТипаОбъекта, ОбъектНайден, НаборЗаписей) Экспорт

	Если Не ОбъектНайден Тогда
		Объект.Записать();
		УчетЗарплаты.ЗаполнитьНедостающиеРеквизитыЗагруженныхОбъектов(Объект) 
	КонецЕсли;

КонецПроцедуры

Процедура ПКО_ПослеЗагрузки_Контрагенты(ФайлОбмена, Отказ, Ссылка, Объект, ПараметрыОбъекта, ОбъектМодифицирован, 
                                           ИмяТипаОбъекта, ОбъектНайден, НаборЗаписей) Экспорт

	Если Не ОбъектНайден Тогда
		Объект.Записать();
		Объект.ГоловнойКонтрагент = Объект.Ссылка; 
		Объект.Записать();
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОНВЕРТАЦИИ СВОЙСТВ И ГРУПП СВОЙСТВ ОБЪЕКТОВ


////////////////////////////////////////////////////////////////////////////////
//                          !!!ВНИМАНИЕ!!! 
//            ИЗМЕНЯТЬ КОД В ЭТОМ БЛОКЕ (НИЖЕ) ЗАПРЕЩЕНО!
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ВЫЗОВ ОБЩИХ ПРОЦЕДУР И ФУНКЦИЙ


// Производит выгрузку объекта в соответствии с указанным правилом конвертации
//
// Параметры:
//  Источник				 - произвольный источник данных
//  Приемник				 - xml-узел объекта приемника
//  ВходящиеДанные			 - произвольные вспомогательные данные, передаваемые правилу
//                             для выполнения конвертации
//  ИсходящиеДанные			 - произвольные вспомогательные данные, передаваемые правилам
//                             конвертации свойств
//  ИмяПКО					 - имя правила конвертации, согласно которому осуществляется выгрузка
//  УзелСсылки				 - xml-узел ссылки объекта приемника
//  ТолькоПолучитьУзелСсылки - если Истина, то выгрузка объекта не производится, только формируется
//                             xml-узел ссылки
//  ПКО                      - ссылка на правило конвертации
//
// Возвращаемое значение:
//  xml-узел ссылки или значение приемника
//
Функция ВыгрузитьПоПравилу(Источник					= Неопределено,
						   Приемник					= Неопределено,
						   ВходящиеДанные			= Неопределено,
						   ИсходящиеДанные			= Неопределено,
						   ИмяПКО					= "")
						   
	Возврат ОбщиеПроцедурыФункции.ВыгрузитьПоПравилу(Источник, Приемник, ВходящиеДанные, ИсходящиеДанные, ИмяПКО);
	
КонецФункции

// Создает новый xml-узел
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
//
// Параметры: 
//  Имя            - Имя узла
//
// Возвращаемое значение:
//  Объект нового xml-узла
//
Функция СоздатьУзел(Имя)

	Возврат ОбщиеПроцедурыФункции.СоздатьУзел(Имя); 

КонецФункции

// Добавляет новый xml-узел к указанному узлу-родителю
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры: 
//  УзелРодитель   - xml-узел-родитель
//  Имя            - имя добавляемого узла
//
// Возвращаемое значение:
//  Новый xml-узел, добавленный к указанному узлу-родителю
//
Функция ДобавитьУзел(УзелРодитель, Имя)

	Возврат ОбщиеПроцедурыФункции.ДобавитьУзел(УзелРодитель, Имя); 

КонецФункции

// Копирует указанный xml-узел
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры: 
//  Узел           - копируемый узел
//
// Возвращаемое значение:
//  Новый xml - копия указанного узла
//
Функция КопироватьУзел(Узел)

	Возврат ОбщиеПроцедурыФункции.КопироватьУзел(Узел); 
	
КонецФункции 

// Устанавливает значение параметра "Загрузка" для свойства объекта "ОбменДанными".
//
// Параметры:
//  Объект   - объект, для которого устанавливается свойство
//  Значение - значение устанавливаемого свойства "Загрузка"
// 
Процедура УстановитьОбменДаннымиЗагрузка(Объект, Значение = Истина)

	ОбщиеПроцедурыФункции.УстановитьОбменДаннымиЗагрузка(Объект, Значение);
	
КонецПроцедуры

// Устанавливает атрибут указанного xml-узла
//
// Параметры: 
//  Узел           - xml-узел
//  Имя            - имя атрибута
//  Значение       - устанавливаемое значение
//
Процедура УстановитьАтрибут(Узел, Имя, Значение)
	
	ОбщиеПроцедурыФункции.УстановитьАтрибут(Узел, Имя, Значение);
	
КонецПроцедуры 

// Подчиняет xml-узел указанному узлу-родителю
//
// Параметры: 
//  УзелРодитель   - xml-узел-родитель
//  Узел           - подчиняемый узел 
//
Процедура ДобавитьПодчиненный(УзелРодитель, Узел)

	ОбщиеПроцедурыФункции.ДобавитьПодчиненный(УзелРодитель, Узел);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ОБЪЕКТОМ XMLЧтение

// Осуществляет запись элемента и его значения в указанный объект
//
// Параметры:
//  Объект         - объект типа XMLЗапись
//  Имя            - Строка. Имя элемента
//  Значение       - Значение элемента
// 
Процедура одЗаписатьЭлемент(Объект, Имя, Значение="")

	ОбщиеПроцедурыФункции.одЗаписатьЭлемент(Объект, Имя, Значение);	
	
КонецПроцедуры

// Читает значение атрибута по имени из указанного объекта, приводит значение
// к указанному примитивному типу
//
// Параметры:
//  Объект      - объект типа XMLЧтение, спозиционированный на начале элемента,
//                атрибут которого требуется получить
//  Тип         - Значение типа Тип. Тип атрибута
//  Имя         - Строка. Имя атрибута
//
// Возвращаемое значение:
//  Значение атрибута полученное по имени и приведенное к указанному типу
// 
Функция одАтрибут(Объект, Тип, Имя)
	
	Возврат ОбщиеПроцедурыФункции.одАтрибут(Объект, Тип, Имя);
		
КонецФункции
 
// Пропускает узлы xml до конца указанного элемента (по умолчанию текущего)
//
// Параметры:
//  Объект   - объект типа XMLЧтение
//  Имя      - имя узла, до конца которого пропускаем элементы
// 
Процедура одПропустить(Объект, Имя = "")
	
	ОбщиеПроцедурыФункции.одПропустить(Объект, Имя);
	
КонецПроцедуры // одПропустить() 

// Читает текст элемента и приводит значение к указанному типу
//
// Параметры:
//  Объект           - объект типа XMLЧтение, из которого осуществлется чтение
//  Тип              - тип получаемого значения
//  ИскатьПоСвойству - для ссылочных типов может быть указано свойство, по которому
//                     следует искать объект: "Код", "Наименование", <ИмяРеквизита>, "Имя" (предопределенного значения)
//
// Возвращаемое значение:
//  Значение xml-элемента, приведенное к соответствующему типу
//
Функция одЗначениеЭлемента(Объект, Тип, ИскатьПоСвойству = "", ОбрезатьСтрокуСправа = Истина)

	Возврат ОбщиеПроцедурыФункции.одЗначениеЭлемента(Объект, Тип, ИскатьПоСвойству, ОбрезатьСтрокуСправа);

КонецФункции // одЗначениеЭлемента() 

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ДАННЫМИ

// Возвращает строку - имя переданного значения перечисления.
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры:
//  Значение     - значение перечисления
//
// Возвращаемое значение:
//  Строка       - имя переданного значения перечисления.
//
Функция одИмяЗначенияПеречисления(Значение) 

    Возврат ОбщиеПроцедурыФункции.одИмяЗначенияПеречисления(Значение);
	
КонецФункции // одИмяЗначенияПеречисления()

// Определяет заполнено ли переданное значение
//
// Параметры: 
//  Значение       - значение, заполенение которого надо проверить
//
// Возвращаемое значение:
//  Истина         - значение не заполнено, ложь - иначе.
//
Функция одПустое(Значение, ЭтоNULL=Ложь)
	
	Возврат ОбщиеПроцедурыФункции.одПустое(Значение, ЭтоNULL);
	
КонецФункции // одПустое()

// Возвращает объект ОписаниеТипов, содержащий указанный тип.
//
// Параметры:
//  ЗначениеТипа - строка с именем типа или значение типа Тип.
//  
// Возвращаемое значение:
//  ОписаниеТипов
//
Функция одОписаниеТипа(ЗначениеТипа)
	
	Возврат ОбщиеПроцедурыФункции.одОписаниеТипа(ЗначениеТипа);

КонецФункции // одОписаниеТипа()

// Возвращает пустое (дефолтное) значение указанного типа
//
// Параметры:
//  Тип          - строка с именем типа или значение типа Тип.
//
// Возвращаемое значение:
//  Пустое значение указанного типа.
// 
Функция одПолучитьПустоеЗначение(Тип)

    Возврат ОбщиеПроцедурыФункции.одПолучитьПустоеЗначение(Тип);
	
КонецФункции // ПолучитьПустоеЗначение()

// Осуществляет простой поиск объекта информационной базы по указанному свойству.
//
// Параметры:
//  Менеджер       - менеджер искомого объекта;
//  Свойство       - свойство, по которому осуществляем поиск: Имя, Код, 
//                   Наименование или Имя индексируемого реквизита;
//  Значение       - значение свойства, по которому ищем объект.
//
// Возвращаемое значение:
//  Найденный объект информационной базы.
//
Функция одНайтиОбъектПоСвойству(Менеджер, Свойство, Значение, 
	                        НайденныйОбъектПоУникальномуИдентификатору = Неопределено, 
	                        ОбщаяСтруктураСвойств = Неопределено, ОбщиеСвойстваПоиска = Неопределено, 
	                        РежимПоискаОсновногоОбъекта = Истина, СтрокаЗапросаПоискаПоУникальномуИдентификатору = "")

	Возврат ОбщиеПроцедурыФункции.одНайтиОбъектПоСвойству(Менеджер, Свойство, Значение, 
	                                               НайденныйОбъектПоУникальномуИдентификатору,	
	                                               ОбщаяСтруктураСвойств, ОбщиеСвойстваПоиска, 
	                                               РежимПоискаОсновногоОбъекта, СтрокаЗапросаПоискаПоУникальномуИдентификатору);
	
КонецФункции // одНайтиОбъектПоСвойству() 

// Осуществляет простой поиск объекта информационной базы по указанному свойству.
//
// Параметры:
//  Стр            - Строка - значение свойства, по которому осуществляется 
//                   поиск объект;
//  Тип            - тип искомого объекта;
//  Свойство       - Строка - имя свойства, по-которому ищем объект.
//
// Возвращаемое значение:
//  Найденный объект информационной базы
//
Функция одПолучитьЗначениеПоСтроке(Стр, Тип, Свойство = "")

	Возврат ОбщиеПроцедурыФункции.одПолучитьЗначениеПоСтроке(Стр, Тип, Свойство);

КонецФункции // одПолучитьЗначениеПоСтроке()

// Возвращает строковое представление типа значения 
//
// Параметры: 
//  ЗначениеИлиТип - произвольное значение или значение типа тип
//
// Возвращаемое значение:
//  Строка - строковое представление типа значения
//
Функция одТипЗначенияСтрокой(ЗначениеИлиТип)

	Возврат ОбщиеПроцедурыФункции.одТипЗначенияСтрокой(ЗначениеИлиТип);
	
КонецФункции // одТипЗначенияСтрокой()

// Возвращает XML представление объекта ОписаниеТипов
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры:
//  ОписаниеТипов  - объект ОписаниеТипов, XML представление которого требуется получить
//
// Возвращаемое значение:
//  Строка - XML представление переданного объекта ОписаниеТипов
//
Функция одПолучитьXMLПредставлениеОписанияТипов(ОписаниеТипов) 

	Возврат ОбщиеПроцедурыФункции.одПолучитьXMLПредставлениеОписанияТипов(ОписаниеТипов);
	
КонецФункции // одПолучитьXMLПредставлениеОписанияТипов() 

////////////////////////////////////////////////////////////////////////////////
// РАБОТА СО СТРОКАМИ

// Разбирает строку на две части: до подстроки разделителя и после.
//
// Параметры:
//  Стр          - разбираемая строка;
//  Разделитель  - подстрока-разделитель:
//  Режим        - 0 - разделитель в возвращаемые подстроки не включается;
//                 1 - разделитель включается в левую подстроку;
//                 2 - разделитель включается в правую подстроку.
//
// Возвращаемое значение:
//  Правая часть строки - до символа-разделителя.
// 
Функция ОтделитьРазделителем(Стр, Знач Разделитель, Режим=0)

    Возврат ОбщиеПроцедурыФункции.ОтделитьРазделителем(Стр, Разделитель, Режим);
	
КонецФункции // ОтделитьРазделителем()

// Преобразует значения из строки в массив, используя указанный разделитель
//
// Параметры:
//  Стр            - Разбираемая строка
//  Разделитель    - подстрока разделитель
//
// Возвращаемое значение:
//  Массив значений
// 
Функция МассивИзСтроки(Знач Стр, Разделитель=",")

	Возврат ОбщиеПроцедурыФункции.МассивИзСтроки(Стр, Разделитель);

КонецФункции // МассивИзСтроки() 

Функция ПолучитьСтроковыйНомерБезПрефиксов(Номер)
	
	Возврат ОбщиеПроцедурыФункции.ПолучитьСтроковыйНомерБезПрефиксов(Номер);
	
КонецФункции

// Разбирает строку, выделяя из нее префикс и числовую часть.
//
// Параметры:
//  Стр            - Строка. Разбираемая строка;
//  ЧисловаяЧасть  - Число. Переменная, в которую возвратится числовая часть строки;
//  Режим          - Строка. Если "Число", то возвратит числовую часть, иначе - префикс.
//
// Возвращаемое значение:
//  Префикс строки
//
Функция ПолучитьПрефиксЧислоНомера(Знач Стр, ЧисловаяЧасть = "", Режим = "")

	Возврат ОбщиеПроцедурыФункции.ПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть, Режим);

КонецФункции

// Приводит номер (код) к требуемой длине. При этом выделяется префикс
// и числовая часть номера, остальное пространство между префиксом и
// номером заполняется нулями.
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры:
//  Стр          - преобразовываемая строка;
//  Длина        - требуемая длина строки.
//
// Возвращаемое значение:
//  Строка       - код или номер, приведенная к требуемой длине.
// 
Функция ПривестиНомерКДлине(Знач Стр, Длина, ДобавлятьНулиЕслиДлинаНеМеньшеТекущейДлиныНомера = Истина, Префикс = "") 

	Возврат ОбщиеПроцедурыФункции.ПривестиНомерКДлине(Стр, Длина, ДобавлятьНулиЕслиДлинаНеМеньшеТекущейДлиныНомера, Префикс);

КонецФункции // ПривестиНомерКДлине()

// Добавляет к префиксу номера или кода подстроку
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры:
//  Стр          - Строка. Номер или код;
//  Добавок      - добаляемая к префиксу подстрока;
//  Длина        - требуемая результрирующая длина строки;
//  Режим        - "Слева" - подстрока добавляется слева к префиксу, иначе - справа.
//
// Возвращаемое значение:
//  Строка       - номер или код, к префиксу которого добавлена указанная подстрока.
//
Функция ДобавитьКПрефиксу(Знач Стр, Добавок = "", Длина = "", Режим = "Слева") 

	Возврат ОбщиеПроцедурыФункции.ДобавитьКПрефиксу(Стр, Добавок, Длина, Режим); 

КонецФункции // ДобавитьКПрефиксу()

// Дополняет строку указанным символом до указанной длины.
//
// Параметры: 
//  Стр          - дополняемая строка;
//  Длина        - требуемая длина результирующей строки;
//  Чем          - символ, которым дополняется строка.
//
// Возвращаемое значение:
//  Строка, дополненная указанным символом до указанной длины.
//
Функция одДополнитьСтроку(Стр, Длина, Чем = " ") 
	
	Возврат ОбщиеПроцедурыФункции.одДополнитьСтроку(Стр, Длина, Чем);

КонецФункции // одДополнитьСтроку() 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФАЙЛОМ ОБМЕНА

// Сохраняет в файл указанный xml-узел
//
// Параметры:
//  Узел           - xml-узел, сохранямый в файл
//
Процедура ЗаписатьВФайл(Узел)

	ОбщиеПроцедурыФункции.ЗаписатьВФайл(Узел);

КонецПроцедуры // ЗаписатьВФайл()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ПРАВИЛАМИ ОБМЕНА

// Осуществляет поиск правила конвертации по имени или в соответствии с типом
// переданного объекта
//
// Параметры:
//  Объект         - Объект-источник, для которого ищем правило конвертации
//  ИмяПравила     - имя правила конвертации
//
// Возвращаемое значение:
//  Ссылка на правило конвертации (строка в таблице правил)
// 
Функция НайтиПравило(Объект, ИмяПравила="")

	Возврат ОбщиеПроцедурыФункции.НайтиПравило(Объект, ИмяПравила);

КонецФункции


////////////////////////////////////////////////////////////////////////////////
//

Процедура ПередатьИнформациюОЗаписиВПриемник(ИнформацияДляЗаписиВФайл, СтрокаОшибкиВБазеПриемнике = "")
	
	ОбщиеПроцедурыФункции.ПередатьИнформациюОЗаписиВПриемник(ИнформацияДляЗаписиВФайл, СтрокаОшибкиВБазеПриемнике);
	
КонецПроцедуры

Процедура ПередатьОдинПараметрВПриемник(Имя, ИсходноеЗначениеПараметра, ПравилоКонвертации = "")
	
	ОбщиеПроцедурыФункции.ПередатьОдинПараметрВПриемник(Имя, ИсходноеЗначениеПараметра, ПравилоКонвертации);
	
КонецПроцедуры

Процедура ПередатьДополнительныеПараметрыВПриемник()
	
	ОбщиеПроцедурыФункции.ПередатьДополнительныеПараметрыВПриемник();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// КОНСТРУКТОР И ДЕСТРУКТОР ОБРАБОТКИ

Процедура Конструктор(Владелец) Экспорт

	Параметры             = Владелец.Параметры;
	ОбщиеПроцедурыФункции = Владелец;
	Запросы               = Владелец.Запросы;
	Правила               = Владелец.Правила;
	
	КомментарийПриВыгрузкеДанных = Владелец.КомментарийПриВыгрузкеДанных;
	КомментарийПриЗагрузкеДанных = Владелец.КомментарийПриЗагрузкеДанных;
	
	
	//переменная для универсального обмена
	Попытка
		ДатаНачала = Владелец.ДатаНачала;
	Исключение
	КонецПопытки;
	
	//переменная для универсального обмена
	Попытка
		ДатаОкончания = Владелец.ДатаОкончания;
	Исключение
	КонецПопытки;
	
	//переменная для on-line обмена
	Попытка
		ДатаВыгрузкиДанных = Владелец.ДатаВыгрузкиДанных;
	Исключение
	КонецПопытки;
	
	//переменная для on-line обмена
	Попытка
		УзелДляОбмена = Владелец.УзелДляОбмена;
	Исключение
	КонецПопытки;
	
	// Типы
	одТипСтрока                = Тип("Строка");
	одТипБулево                = Тип("Булево");
	одТипЧисло                 = Тип("Число");
	одТипДата                  = Тип("Дата");
	одТипХранилищеЗначения     = Тип("ХранилищеЗначения");
	одТипДвоичныеДанные        = Тип("ДвоичныеДанные");
	одТипВидДвиженияНакопления = Тип("ВидДвиженияНакопления");
	одТипУдалениеОбъекта       = Тип("УдалениеОбъекта");
	одТипВидСчета			   = Тип("ВидСчета");
	одТипТип                   = Тип("Тип");
	одТипСоответствие          = Тип("Соответствие");
	
	ЗначениеПустаяДата		   = Дата('00010101');
	
	// Типы узлов xml
	одТипУзлаXML_КонецЭлемента  = ТипУзлаXML.КонецЭлемента;
	одТипУзлаXML_НачалоЭлемента = ТипУзлаXML.НачалоЭлемента;
	одТипУзлаXML_Текст          = ТипУзлаXML.Текст;
	
	Алгоритмы = Новый Структура;
	

КонецПроцедуры


Процедура Деструктор() Экспорт
	
	ОбщиеПроцедурыФункции = Неопределено;
	
КонецПроцедуры

#КонецЕсли