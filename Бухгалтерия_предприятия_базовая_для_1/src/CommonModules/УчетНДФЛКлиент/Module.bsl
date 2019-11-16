#Область СлужебныйПрограммныйИнтерфейс

// См. ЗарплатаКадрыКлиент.НастройкиТипа.
Процедура ПриОпределенииНастроекТипа(Тип, НастройкиТипа) Экспорт
	
	Если Тип = Тип("ДокументСсылка.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ")
		Или Тип = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		
		НастройкиТипа.ПоказыватьКомандыРаботыСФайлами = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Для переданного описания ячейки рег.отчета выбирает подходящий отчет-расшифровку,
// настраивает соотв. вариант и получает подготовленную к показу форму отчета.
// Параметры:
//	ИДОтчета - Строка - идентификатор отчета (совпадает с именем объекта метаданных).
// 	ИДРедакцииОтчета - Строка - идентификатор редакции формы отчета (совпадает с именем формы объекта метаданных).
//  ИДИменПоказателей - Массив - массив идентификаторов имен показателей, по которым формируется расшифровка.
//  ПараметрыОтчета - Структура - структура параметров отчета, необходимых для формирования расшифровки.
// 
Функция ФормаРасшифровкиРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета) Экспорт
	
	Если Не ЗначениеЗаполнено(ИДИменПоказателей) Тогда
		Возврат Неопределено
	КонецЕсли;
	
	ИмяПоказателя = ИДИменПоказателей[0];
	ИмяНабораДанных = "";
	ИмяОтчетаРасшифровки = "";
	ИмяРасчета = "";
	
	Если ИДОтчета = "РегламентированныйОтчет6НДФЛ" Тогда
		Если ИДРедакцииОтчета = "ФормаОтчета2016Кв1" Или ИДРедакцииОтчета = "ФормаОтчета2017Кв4" Тогда
			ИмяОтчетаРасшифровки = "Расшифровка6НДФЛ";
			ИмяРасчета = ?(ПараметрыОтчета.ДатаКонцаПериодаОтчета < '20170101', "РасчетПоказателей_6НДФЛ_2016Кв1", "РасчетПоказателей_6НДФЛ_2017Кв1");
			ПараметрыОтчета.Вставить("ИмяСКД");
			Если ИмяПоказателя = "П000020013002" Тогда
				ИмяПоказателя = "П000020013001" 
			ИначеЕсли ИмяПоказателя = "П000020014002" Тогда
				ИмяПоказателя = "П000020014001"
			КонецЕсли;
			Если ИДИменПоказателей[0] <> ИмяПоказателя Тогда
				ИДИменПоказателей.Вставить(0,ИмяПоказателя);
			КонецЕсли;
			ДополнитьПараметрыОтчета6НДФЛ(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		КонецЕсли;
	Иначе
		
	КонецЕсли;
	
	// Подготовка отчета-расшифровки к показу.
	Если ЗначениеЗаполнено(ИмяОтчетаРасшифровки) И ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИсточникРасшифровки","УчетНДФЛ");
		ПараметрыОтчета.Вставить("ИмяОтчетаРасшифровки",ИмяОтчетаРасшифровки);
		ПараметрыОтчета.Вставить("ИмяРасчета",ИмяРасчета);
		ПараметрыОтчета.Вставить("ИДИменПоказателей",ИДИменПоказателей);
		
		ФормаРасшифровки = ПолучитьФорму("ОбщаяФорма.РасшифровкаРегламентированногоОтчетаЗарплата", ПараметрыОтчета);
		Возврат ФормаРасшифровки
		
	КонецЕсли;
	
	Возврат Неопределено
	
КонецФункции

// Процедура открывает общую форму, показывающую, какие вычеты были применены при расчете НДФЛ в документе.
//
// Параметры:
//	Организация									- СправочникСсылка.Организации
//	Владелец									- УправляемаяФорма, элемент, в который необходимо возвратить результат оповещения.
//	МесяцНачисления								- Дата
//	СотрудникФизическоеЛицо						- СправочникСсылка.Сотрудники
//												- СправочникСсылка.ФизическиеЛица
//	НеРаспределятьПоИсточникамФинансирования	- Булево, Истина - если распределение производится документом.
//
// Возвращаемое значение
//	Форма при закрытии отправляет оповещение владельцу, с которым передается содержимое ТЧ НДФЛ и
//	ПримененныеВычетыНаДетейИИмущественные.
//
Процедура ОткрытьФормуПодробнееОРасчетеНДФЛ(Организация, Владелец, МесяцНачисления, СотрудникФизическоеЛицо, НеРаспределятьПоИсточникамФинансирования = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура;       

	ПараметрыФормы.Вставить("ТолькоПросмотр", Владелец.ТолькоПросмотр);
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("СведенияОбНДФЛ", Владелец.СведенияОбНДФЛ());
	ПараметрыФормы.Вставить("МесяцНачисления", МесяцНачисления);
	ПараметрыФормы.Вставить("СотрудникФизическоеЛицо", СотрудникФизическоеЛицо);
	ПараметрыФормы.Вставить("ДокументСсылка", Владелец.Объект.Ссылка);
	
	Если НеРаспределятьПоИсточникамФинансирования Тогда
		ПараметрыФормы.Вставить("НеРаспределятьПоИсточникамФинансирования", Истина);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПодробнееОРасчетеНДФЛ", ПараметрыФормы, Владелец);
	
КонецПроцедуры

#Область ПанельПримененныеВычеты

Процедура ФормаПодробнееОРасчетеНДФЛНДФЛВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ОписаниеТаблицыНДФЛ, МесяцНачисления, Организация) Экспорт
	
	УчетНДФЛКлиентВнутренний.ФормаПодробнееОРасчетеНДФЛНДФЛВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ОписаниеТаблицыНДФЛ, МесяцНачисления, Организация);
	
КонецПроцедуры

Процедура НДФЛПередНачаломИзменения(Форма, ТекущиеДанные, Отказ) Экспорт
	
	УчетНДФЛКлиентВнутренний.НДФЛПередНачаломИзменения(Форма, ТекущиеДанные, Отказ);
	
КонецПроцедуры

Процедура НДФЛПередУдалением(Форма, НДФЛТекущиеДанные, Отказ) Экспорт
	
	УчетНДФЛКлиентВнутренний.НДФЛПередУдалением(Форма, НДФЛТекущиеДанные, Отказ);
	
КонецПроцедуры

Процедура НДФЛПриАктивизацииСтроки(Форма) Экспорт
	
	УчетНДФЛКлиентВнутренний.НДФЛПриАктивизацииСтроки(Форма);
	
КонецПроцедуры

Процедура НДФЛПриНачалеРедактирования(Форма, ТекущиеДанные, НоваяСтрока, Копирование) Экспорт
	
	РасчетЗарплатыКлиент.СтрокаРасчетаПриНачалеРедактирования(Форма, "НДФЛ", ТекущиеДанные, НоваяСтрока, Копирование);
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаКлиенте();
	
	УчетНДФЛКлиентСервер.НазначитьИдентификаторСтрокеНДФЛ(ТекущиеДанные, Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "МаксимальныйИдентификаторСтрокиНДФЛ"], НоваяСтрока);
	
	Если Копирование ИЛИ НоваяСтрока Тогда
		НДФЛПриАктивизацииСтроки(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура НДФЛПриОкончанииРедактирования(Форма) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаКлиенте();
	ИмяГруппыФормыПанелиВычеты = ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты;
	
	НДФЛТекущиеДанные = УчетНДФЛКлиентСервер.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
	
	НДФЛТекущиеДанные["ПримененныйВычетЛичный"] 						= Форма[ИмяГруппыФормыПанелиВычеты + "ПримененныйВычетЛичный"];
	НДФЛТекущиеДанные["ПримененныйВычетЛичныйКодВычета"] 				= Форма[ИмяГруппыФормыПанелиВычеты + "ПримененныйВычетЛичныйКодВычета"];
	НДФЛТекущиеДанные["ПримененныйВычетЛичныйКЗачетуВозврату"] 			= Форма[ИмяГруппыФормыПанелиВычеты + "ПримененныйВычетЛичныйКЗачетуВозврату"];
	НДФЛТекущиеДанные["ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета"] = Форма[ИмяГруппыФормыПанелиВычеты + "ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета"];
	
	УчетНДФЛКлиентСервер.ЗаполнитьПредставлениеВычетовЛичныхСтрокиНДФЛ(Форма, НДФЛТекущиеДанные, ОписаниеПанелиВычеты);
	Форма[ИмяГруппыФормыПанелиВычеты + "ПредставлениеВычетовЛичных"] = НДФЛТекущиеДанные.ПредставлениеВычетовЛичных;
	
	НДФЛПриАктивизацииСтроки(Форма);
	
КонецПроцедуры

Процедура НДФЛУстановитьДоступностьЭлементовЛичныхВычетов(Форма) Экспорт
	
	УчетНДФЛКлиентВнутренний.НДФЛУстановитьДоступностьЭлементовЛичныхВычетов(Форма)
	
КонецПроцедуры

Процедура ВычетыПриНачалеРедактирования(СтрокаПримененныеВычетыНаДетейИИмущественные, НоваяСтрока, СтрокаИсточникЗаполнения) Экспорт
	
	Если Не НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаПримененныеВычетыНаДетейИИмущественные, СтрокаИсточникЗаполнения);
	СтрокаПримененныеВычетыНаДетейИИмущественные.МесяцПериодаПредоставленияВычета = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(СтрокаПримененныеВычетыНаДетейИИмущественные, "МесяцПериодаПредоставленияВычета", "МесяцПериодаПредоставленияВычетаСтрокой");	
	
КонецПроцедуры

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность.
// Параметры - (см. РегламентированнаяОтчетностьКлиентПереопределяемый.Печать).
//	 
Процедура ПечатьДокументаОтчетности(Ссылка, ИмяМакетаДляПечати, СтандартнаяОбработка) Экспорт
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		СтандартнаяОбработка = Истина;
	КонецЕсли;		
КонецПроцедуры	

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность.
// Параметры - (см. РегламентированнаяОтчетностьКлиентПереопределяемый.Выгрузить).
//	 
Процедура ВыгрузитьДокументОтчетности(Ссылка) Экспорт
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		ДанныеФайла = ЗарплатаКадрыВызовСервера.ПолучитьДанныеФайла(Ссылка, Новый УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.СохранитьФайлКак(ДанныеФайла);	
	КонецЕсли;	
	
КонецПроцедуры	

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность.
// Параметры - (см. РегламентированнаяОтчетностьКлиентПереопределяемый.СоздатьНовыйОбъект).
//	 
Процедура СоздатьНовыйДокументОтчетности(Организация, Тип, СтандартнаяОбработка) Экспорт
	Если Тип = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		СтандартнаяОбработка = Истина;
	КонецЕсли;	
КонецПроцедуры	

Процедура ФормаПодробнееОРасчетеНДФЛОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	УчетНДФЛКлиентВнутренний.ФормаПодробнееОРасчетеНДФЛОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

Процедура МожноИзменятьПримененныеВычеты(Форма, Отказ) Экспорт
	
	УчетНДФЛКлиентВнутренний.МожноИзменятьПримененныеВычеты(Форма, Отказ);
	
КонецПроцедуры

Функция ВычетыИзменены(Форма, ТекущиеДанные, ОтменаРедактирования) Экспорт
	
	Если Не ОтменаРедактирования
		И ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.Свойство("КодВычета")
			И ТекущиеДанные.Свойство("КодВычетаПредыдущий") Тогда
			Если ТекущиеДанные.КодВычета <> ТекущиеДанные.КодВычетаПредыдущий Тогда
				Возврат Истина;
			КонецЕсли; 
		КонецЕсли; 
		
		Если ТекущиеДанные.Свойство("РазмерВычета")
			И ТекущиеДанные.Свойство("РазмерВычетаПредыдущий") Тогда
			Если ТекущиеДанные.РазмерВычета <> ТекущиеДанные.РазмерВычетаПредыдущий Тогда
				Возврат Истина;
			КонецЕсли; 
		КонецЕсли; 
		
		Если ТекущиеДанные.Свойство("СуммаВычета")
			И ТекущиеДанные.Свойство("СуммаВычетаПредыдущая") Тогда
			Если ТекущиеДанные.СуммаВычета <> ТекущиеДанные.СуммаВычетаПредыдущая Тогда
				Возврат Истина;
			КонецЕсли; 
		КонецЕсли; 
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Обработчики событий тч вычеты.

Процедура ПримененныеВычетыНаДетейИИмущественныеПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	МожноИзменятьПримененныеВычеты(Форма, Отказ);
	
	Если Не Отказ Тогда
		Элемент.ТекущиеДанные.КодВычетаПредыдущий = Элемент.ТекущиеДанные.КодВычета;
		Элемент.ТекущиеДанные.РазмерВычетаПредыдущий = Элемент.ТекущиеДанные.РазмерВычета;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПримененныеВычетыКДоходам(Форма, Элемент, Отказ) Экспорт
	
	МожноИзменятьПримененныеВычеты(Форма, Отказ);
	
	Если Не Отказ Тогда
		Элемент.ТекущиеДанные.СуммаВычетаПредыдущая = Элемент.ТекущиеДанные.СуммаВычета;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФормаПодробнееОРасчетеНДФЛПерераспределитьНДФЛ(СтрокаНДФЛ, РаботаВБюджетномУчреждении) Экспорт
	
	УчетНДФЛКлиентВнутренний.ФормаПодробнееОРасчетеНДФЛПерераспределитьНДФЛ(СтрокаНДФЛ, РаботаВБюджетномУчреждении);
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Процедура УстановитьОтборыПримененныхВычетов(Форма, НДФЛТекущиеДанные) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаКлиенте();
	
	ГруппаФормыПанельВычеты = Форма.Элементы.Найти(ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты);
	
	Если ГруппаФормыПанельВычеты = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	НастраиваемыеПанели = ОписаниеПанелиВычеты.НастраиваемыеПанели;
	
	ВычетыНаДетейИИмущественные = НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные");
	Если ВычетыНаДетейИИмущественные <> Неопределено Тогда
		
		СтруктураОтбораПримененныеВычетыНаДетейИИмущественные = Новый Структура("ИдентификаторСтрокиНДФЛ");
		Если НДФЛТекущиеДанные <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураОтбораПримененныеВычетыНаДетейИИмущественные, НДФЛТекущиеДанные);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			ГруппаФормыПанельВычеты.Имя + "ВычетыНаДетейИИмущественные",
			"ОтборСтрок",
			Новый ФиксированнаяСтруктура(СтруктураОтбораПримененныеВычетыНаДетейИИмущественные));
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			ГруппаФормыПанельВычеты.Имя + "ВычетыНаДетейИИмущественные",
			"ТолькоПросмотр",
			(НДФЛТекущиеДанные = Неопределено));
		
	КонецЕсли;
	
	ВычетыКДоходам = НастраиваемыеПанели.Получить("ВычетыКДоходам");
	Если ВычетыКДоходам <> Неопределено Тогда
		
		СтруктураОтбораВычетыПримененныеКДоходам = Новый Структура("ФизическоеЛицо,Подразделение,ВычетПримененныйКДоходам");
		Если НДФЛТекущиеДанные <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтруктураОтбораВычетыПримененныеКДоходам, НДФЛТекущиеДанные);
			СтруктураОтбораВычетыПримененныеКДоходам.ВычетПримененныйКДоходам = Истина;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			ГруппаФормыПанельВычеты.Имя + "ВычетыКДоходам",
			"ОтборСтрок",
			Новый ФиксированнаяСтруктура(СтруктураОтбораВычетыПримененныеКДоходам));
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			ГруппаФормыПанельВычеты.Имя + "ВычетыКДоходам",
			"ТолькоПросмотр",
			(НДФЛТекущиеДанные = Неопределено));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьПримененныеВычетыНаДетейИИмущественные(Форма) Экспорт
	
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаКлиенте();
	
	МассивИменТаблицВычетов = Новый Массив;
	
	Если ОписаниеПанелиВычеты.НастраиваемыеПанели["ВычетыНаДетей"] <> Неопределено Тогда
		МассивИменТаблицВычетов.Добавить(ОписаниеПанелиВычеты.НастраиваемыеПанели["ВычетыНаДетей"]);
	КонецЕсли; 
	
	Если ОписаниеПанелиВычеты.НастраиваемыеПанели["ВычетыИмущественные"] <> Неопределено Тогда
		Если МассивИменТаблицВычетов.Найти(ОписаниеПанелиВычеты.НастраиваемыеПанели["ВычетыИмущественные"]) <> Неопределено Тогда
			МассивИменТаблицВычетов.Добавить(ОписаниеПанелиВычеты.НастраиваемыеПанели["ВычетыИмущественные"]);
		КонецЕсли;
	КонецЕсли;
	
	ИдентификаторУдаляемойСтрокиСтрокиНДФЛ = Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "ИдентификаторУдаляемойСтрокиСтрокиНДФЛ"];
	Для каждого ИмяТаблицыВычетов Из МассивИменТаблицВычетов Цикл
		НайденныеСтроки = Форма.Объект[ИмяТаблицыВычетов].НайтиСтроки(Новый Структура("ИдентификаторСтрокиНДФЛ", ИдентификаторУдаляемойСтрокиСтрокиНДФЛ));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Форма.Объект[ИмяТаблицыВычетов].Удалить(НайденнаяСтрока);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура СправкиНДФЛПриИзмененииФиксируемогоЗначения(Форма, ДанныеСправки, ПутькДанным) Экспорт
	ДанныеСправки["Фикс" + ПутькДанным] = Истина;
	УчетНДФЛКлиентСервер.СправкиНДФЛУстановитьСвойстваЭлементовСФиксациейДанных(Форма, ДанныеСправки, Форма.ДокументПроведен);
	УчетНДФЛКлиентСервер.СправкиНДФЛУстановитьИнфонадписьИсправления(Форма.ИнфоНадписьИсправления, ДанныеСправки, Форма.ДокументПроведен);
КонецПроцедуры	

Процедура СправкиНДФЛПриИзмененииУдостоверенияЛичности(Форма, ДанныеСправки) Экспорт
	СправкиНДФЛПриИзмененииФиксируемогоЗначения(Форма, ДанныеСправки, "ВидДокумента");
	СправкиНДФЛПриИзмененииФиксируемогоЗначения(Форма, ДанныеСправки, "СерияДокумента");
	СправкиНДФЛПриИзмененииФиксируемогоЗначения(Форма, ДанныеСправки, "НомерДокумента");
КонецПроцедуры	

Процедура СправкиНДФЛГражданствоПриИзменении(Форма, ДанныеСправки) Экспорт
	СправкиНДФЛПриИзмененииФиксируемогоЗначения(Форма, ДанныеСправки, "Гражданство");
	УчетНДФЛКлиентСервер.СправкиНДФЛУстановитьПризнакНаличияГражданства(Форма, ДанныеСправки);
КонецПроцедуры	

Процедура СправкиНДФЛЛицБезГражданстваПриИзменении(Форма, ДанныеСправки) Экспорт
	Если Форма.ЛицоБезГражданства = 1 Тогда
		ДанныеСправки.Гражданство = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
		Форма.Элементы.Гражданство.Доступность = Ложь;
	Иначе
		Форма.Элементы.Гражданство.Доступность = Истина;	
	КонецЕсли;
	
	СправкиНДФЛПриИзмененииФиксируемогоЗначения(Форма, ДанныеСправки, "Гражданство");	
КонецПроцедуры	

Процедура СправкиНДФЛУстановитьСтарыеЗначенияКонтролируемыхПолей(РедактируемыеДанные, СтарыеЗначенияКонтролируемыхПолей, КонтролируемыеПоля, Раздел) Экспорт
	КонтролируемыеПоляРаздела = КонтролируемыеПоля[Раздел];
	
	Если РедактируемыеДанные = Неопределено Тогда
		СтарыеЗначенияКонтролируемыхПолейРаздела = Новый Соответствие;
		СтарыеЗначенияКонтролируемыхПолей.Вставить(Раздел, СтарыеЗначенияКонтролируемыхПолейРаздела);
		
		Для Каждого Поле Из КонтролируемыеПоляРаздела Цикл
			СтарыеЗначенияКонтролируемыхПолейРаздела.Вставить(Поле, Неопределено);		
		КонецЦикла;		
	Иначе			
		СтарыеЗначенияКонтролируемыхПолейРаздела = СтарыеЗначенияКонтролируемыхПолей.Получить(Раздел);
		Если СтарыеЗначенияКонтролируемыхПолейРаздела = Неопределено Тогда
			СтарыеЗначенияКонтролируемыхПолейРаздела = Новый Соответствие;
			СтарыеЗначенияКонтролируемыхПолей.Вставить(Раздел, СтарыеЗначенияКонтролируемыхПолейРаздела);
		КонецЕсли;
		
		Для Каждого Поле Из КонтролируемыеПоляРаздела Цикл
			СтарыеЗначенияКонтролируемыхПолейРаздела.Вставить(Поле, РедактируемыеДанные[Поле]);		
		КонецЦикла;		
	КонецЕсли;	
КонецПроцедуры	

Процедура СправкиНДФЛПриОкончанииРедактирования(Форма, ДанныеСправки, РедактируемыеДанные, СтарыеЗначенияКонтролируемыхПолей, КонтролируемыеПоля, Раздел) Экспорт
	Если РедактируемыеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	КонтролируемыеПоляРаздела = КонтролируемыеПоля[Раздел];	
	СтарыеЗначенияКонтролируемыхПолейРаздела = СтарыеЗначенияКонтролируемыхПолей[Раздел];
	
	Для Каждого Поле Из КонтролируемыеПоляРаздела Цикл
		Если РедактируемыеДанные[Поле] <> СтарыеЗначенияКонтролируемыхПолейРаздела[Поле] Тогда
			Если Раздел = "Уведомление" Тогда
				ДанныеСправки.ФиксУведомление = Истина	
			Иначе	
				ДанныеСправки.ФиксНалоги = Истина;
			КонецЕсли;	
		КонецЕсли;	
		СтарыеЗначенияКонтролируемыхПолейРаздела.Вставить(Поле, РедактируемыеДанные[Поле]);
	КонецЦикла;	
КонецПроцедуры	

Процедура СправкиНДФЛРегистрацияВНалоговомОрганеОткрытие(Форма, СтандартнаяОбработка) Экспорт
	Если ЗначениеЗаполнено(Форма.Объект.РегистрацияВНалоговомОргане) Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытия = Новый Структура("Ключ", Форма.Объект.РегистрацияВНалоговомОргане);
		
		ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.ФормаОбъекта", ПараметрыОткрытия);
	КонецЕсли;	
КонецПроцедуры	

Процедура КодДоходаПриИзменении(Форма, ГодНалоговогоПериода, ИмяТаблицы, КодДоходаИмяРеквизита, ИмяПоляКодВычета, КодВычетаИмяРеквизита, СуммаВычетаИмяРеквизита = "") Экспорт
	ДанныеТекущейСтроки = Форма.Элементы[ИмяТаблицы].ТекущиеДанные;
	КодДохода = ДанныеТекущейСтроки[КодДоходаИмяРеквизита];
	
	ОписаниеКодаДохода = УчетНДФЛКлиентПовтИсп.ПолучитьОписаниеКодаДохода(КодДохода);		
	
	СоответствиеДоступныхВычетовДоходам = УчетНДФЛКлиентПовтИсп.ВычетыКДоходам(ГодНалоговогоПериода);
	
	МассивДоступныхВычетов = СоответствиеДоступныхВычетовДоходам.Получить(КодДохода);
	
	Если МассивДоступныхВычетов <> Неопределено Тогда 
		Форма.Элементы[ИмяПоляКодВычета].СписокВыбора.ЗагрузитьЗначения(МассивДоступныхВычетов);
	КонецЕсли;	
		
	ДанныеТекущейСтроки[КодВычетаИмяРеквизита] = ОписаниеКодаДохода.ВычетПоУмолчанию;
	
	Если СуммаВычетаИмяРеквизита <> "" Тогда 
		ДанныеТекущейСтроки[СуммаВычетаИмяРеквизита] = 0;		
	КонецЕсли;
КонецПроцедуры

Процедура КодДоходаАктивацииСтроки(Форма, ГодНалоговогоПериода, ИмяТаблицы, КодДоходаИмяРеквизита, ИмяПоляКодВычета) Экспорт
	ДанныеТекущейСтроки = Форма.Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда 
		КодДохода = ДанныеТекущейСтроки[КодДоходаИмяРеквизита];
	
		СоответствиеДоступныхВычетовДоходам = УчетНДФЛКлиентПовтИсп.ВычетыКДоходам(ГодНалоговогоПериода);
		
		МассивДоступныхВычетов = СоответствиеДоступныхВычетовДоходам.Получить(КодДохода);

		Если МассивДоступныхВычетов <> Неопределено Тогда 
			Форма.Элементы[ИмяПоляКодВычета].СписокВыбора.ЗагрузитьЗначения(МассивДоступныхВычетов);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

Процедура ДополнитьПараметрыОтчета6НДФЛ(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "01" Тогда
		НомерПодраздела = Лев(НомерСтроки, 2);
		Если НомерСтроки = "020" Или НомерСтроки = "025" Тогда
			ИмяНабораДанных = "Раздел1Доходы"
		ИначеЕсли НомерСтроки = "030" Тогда
			ИмяНабораДанных = "Раздел1Вычеты"
		ИначеЕсли ЗначениеЗаполнено(НомерСтроки) И НомерСтроки <> "060" Тогда
			ИмяНабораДанных = "Раздел1Налоги"
		КонецЕсли;
	ИначеЕсли Раздел = "02" И (НомерСтроки = "130" Или НомерСтроки = "140") Тогда	
		ИмяНабораДанных = "Раздел2"
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
			
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Разд. %1, поле %2'"),
			Формат(Число(Раздел), "ЧРД=."),
			НомерСтроки);
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "Сумма";
		Если Раздел = "01" Тогда
			Если НомерСтроки = "030" Тогда
				ЗаголовокПоля = "Сумма вычета"
			ИначеЕсли НомерСтроки = "020" Или НомерСтроки = "025" Тогда
				ЗаголовокПоля = "Сумма дохода"
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля", ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
