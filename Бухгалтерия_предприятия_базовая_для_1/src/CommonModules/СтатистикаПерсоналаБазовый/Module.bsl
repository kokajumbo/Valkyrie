////////////////////////////////////////////////////////////////////////////////
// Подсистема "Статистика персонала".
// Процедуры и функции, предназначенные для обслуживания форм статистической отчетности.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ОписаниеПоказателей_СтатистикаФормаП4_2013Кв1(ПоказателиОтчета) Экспорт
	
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П0001002В1", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П0001002А1", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000202", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000203", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000205", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000206", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000208", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000209", Истина, Ложь);
	ЗарплатаКадры.ДобавитьПоказательРегламентированнойОтчетности(ПоказателиОтчета, "П010000211", Истина, Ложь);
	
КонецПроцедуры

Процедура ЗначенияПоказателей_СтатистикаФормаП4_2013Кв1(ПараметрыОтчета, Контейнер) Экспорт
	
	П0001002В1 = "";
	П0001002А1 = "";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	
	// Исключение данных обособленных подразделений
	ИсключитьДанныеОбособленныхПодразделений = Ложь;
	ИсключаемыеПодразделения = Новый Массив;
	
	Если ПараметрыОтчета.Свойство("ИсключитьДанныеОбособленныхПодразделений")
		И ПараметрыОтчета.ИсключитьДанныеОбособленныхПодразделений = Истина Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ПодразделенияОрганизаций.Ссылка КАК Подразделение
			|ИЗ
			|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
			|ГДЕ
			|	ПодразделенияОрганизаций.ОбособленноеПодразделение";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			
			ИсключитьДанныеОбособленныхПодразделений = Истина;
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				ИсключаемыеПодразделения.Добавить(Выборка.Подразделение);
				
				Запрос.УстановитьПараметр("Родитель", Выборка.Подразделение);
				Запрос.Текст =
					"ВЫБРАТЬ
					|	ПодразделенияОрганизаций.Ссылка
					|ИЗ
					|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
					|ГДЕ
					|	ПодразделенияОрганизаций.Родитель В ИЕРАРХИИ(&Родитель)";
				
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
					ИсключаемыеПодразделения, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"), Истина);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Данные по обособленному подразделению
	ОбособленноеПодразделение = Неопределено;
	ПодразделенияОбособленного = Новый Массив;
	
	Если ПараметрыОтчета.Свойство("ОбособленноеПодразделение")
		И ПараметрыОтчета.ОбособленноеПодразделение <> Неопределено Тогда
		
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыОтчета.ОбособленноеПодразделение, "ОбособленноеПодразделение") Тогда
			
			ОбособленноеПодразделение = ПараметрыОтчета.ОбособленноеПодразделение;
			
			ПодразделенияОбособленного.Добавить(ОбособленноеПодразделение);
			
			Запрос.УстановитьПараметр("Родитель", ОбособленноеПодразделение);
			Запрос.Текст =
				"ВЫБРАТЬ
				|	ПодразделенияОрганизаций.Ссылка
				|ИЗ
				|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
				|ГДЕ
				|	ПодразделенияОрганизаций.Родитель В ИЕРАРХИИ(&Родитель)";
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				ПодразделенияОбособленного, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Организации.КодОКВЭД КАК КодОКВЭД,
		|	Организации.НаименованиеОКВЭД КАК НаименованиеОКВЭД
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		П0001002В1 = Выборка.КодОКВЭД;
		П0001002А1 = Выборка.НаименованиеОКВЭД;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоГода", 				НачалоГода(ПараметрыОтчета.ДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("ОкончаниеИнтервала", 		КонецМесяца(ПараметрыОтчета.ДатаКонцаПериодаОтчета));
	
	Отборы = Новый Массив;
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ДатаУвольнения", "<>", "ДАТАВРЕМЯ(1,1,1)");
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ДатаПриема", "<=", КонецМесяца(ПараметрыОтчета.ДатаКонцаПериодаОтчета));
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ГоловнаяОрганизация", "=", ЗарплатаКадры.ГоловнаяОрганизация(ПараметрыОтчета.Организация));
	
	ТекущиеКадровыеДанные = "ТекущаяОрганизация,ДатаУвольнения";
	
	Если ИсключитьДанныеОбособленныхПодразделений
		Или ОбособленноеПодразделение <> Неопределено Тогда
		
		ТекущиеКадровыеДанные = ТекущиеКадровыеДанные + ",ТекущееПодразделение";
		
	КонецЕсли;
	
	КадровыйУчет.СоздатьВТТекущиеКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, Ложь, Отборы, ТекущиеКадровыеДанные);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТекущиеКадровыеДанныеСотрудников.Сотрудник) КАК КоличествоСотрудников
		|ИЗ
		|	ВТТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|ГДЕ
		|	(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = &Организация
		|			ИЛИ ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация ЕСТЬ NULL )
		|	И ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)";
	
	Если ИсключитьДанныеОбособленныхПодразделений Тогда
		
		Запрос.УстановитьПараметр("ИсключаемыеПодразделения", ИсключаемыеПодразделения);
		Запрос.Текст = Запрос.Текст + "
			|	И НЕ ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение В (&ИсключаемыеПодразделения)";
		
	ИначеЕсли ОбособленноеПодразделение <> Неопределено Тогда
		
		Запрос.УстановитьПараметр("ПодразделенияОбособленного", ПодразделенияОбособленного);
		Запрос.Текст = Запрос.Текст + "
			|	И ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение В (&ПодразделенияОбособленного)";
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	Иначе
		
		ЗаполнятьП010000205ИП010000206 = Ложь;
		
		Если КонецДня(ПараметрыОтчета.ДатаКонцаПериодаОтчета) = КонецКвартала(ПараметрыОтчета.ДатаКонцаПериодаОтчета) Тогда
			ЗаполнятьП010000205ИП010000206 = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Результаты = СведенияОЧисленностиИВыплатах(
		ПараметрыОтчета.Организация,
		ПараметрыОтчета.ДатаНачалаПериодаОтчета,
		ПараметрыОтчета.ДатаКонцаПериодаОтчета,
		ИсключитьДанныеОбособленныхПодразделений,
		ИсключаемыеПодразделения,
		ПодразделенияОбособленного,
		Истина);
	
	КоличествоРезультатов = Результаты.Количество();
	
	СведенияОЧисленности = Результаты[КоличествоРезультатов-3].Выбрать();
	П010000202 = 0;
	П010000203 = 0;
	Пока СведенияОЧисленности.Следующий() Цикл
		П010000202 = П010000202 + СведенияОЧисленности.СреднесписочнаяЧисленность;
		П010000203 = П010000203 + СведенияОЧисленности.СреднесписочнаяЧисленностьСовместители;
	КонецЦикла;
	
	СведенияОСоциальныхВыплатах    = Результаты[КоличествоРезультатов-2].Выбрать();
	П010000211 = 0;
	Пока СведенияОСоциальныхВыплатах.Следующий() Цикл
		П010000211 = П010000211 + СведенияОСоциальныхВыплатах.ВыплатыСоциальногоХарактера;
	КонецЦикла;
	
	СведенияОЗаработнойПлате = Результаты[КоличествоРезультатов-1].Выбрать();
	П010000205 = 0;
	П010000206 = 0;
	П010000208 = 0;
	П010000209 = 0;
	Пока СведенияОЗаработнойПлате.Следующий() Цикл
		
		Если ЗаполнятьП010000205ИП010000206 Тогда
			П010000205 = П010000205 + СведенияОЗаработнойПлате.ОтработаноЧасов;
			П010000206 = П010000206 + СведенияОЗаработнойПлате.ОтработаноЧасовСовместитель;
		КонецЕсли;
		
		П010000208 = П010000208 + СведенияОЗаработнойПлате.Результат;
		П010000209 = П010000209 + СведенияОЗаработнойПлате.РезультатСовместитель;
		
	КонецЦикла;
	
	ПоляОтчета = Контейнер.ПолеТабличногоДокументаФормаОтчета;
	
	ПоляОтчета.П0001002В1 = П0001002В1;
	ПоляОтчета.П0001002А1 = П0001002А1;
	
	ПоляОтчета.П010000202 = Цел(П010000202);
	ПоляОтчета.П010000203 = Цел(П010000203 * 10) / 10;
	ПоляОтчета.П010000205 = П010000205;
	ПоляОтчета.П010000206 = П010000206;
	ПоляОтчета.П010000211 = П010000211;
	ПоляОтчета.П010000205 = П010000205;
	ПоляОтчета.П010000206 = П010000206;
	ПоляОтчета.П010000208 = П010000208;
	ПоляОтчета.П010000209 = П010000209;
	
КонецПроцедуры

Процедура ЗначенияПоказателей_СтатистикаФормаП4_2017Кв1(ПараметрыОтчета, Контейнер) Экспорт
	
	П0001002В1 = "";
	П0001002А1 = "";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	
	// Исключение данных обособленных подразделений
	ИсключитьДанныеОбособленныхПодразделений = Ложь;
	ИсключаемыеПодразделения = Новый Массив;
	
	Если ПараметрыОтчета.Свойство("ИсключитьДанныеОбособленныхПодразделений")
		И ПараметрыОтчета.ИсключитьДанныеОбособленныхПодразделений = Истина Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ПодразделенияОрганизаций.Ссылка КАК Подразделение
			|ИЗ
			|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
			|ГДЕ
			|	ПодразделенияОрганизаций.ОбособленноеПодразделение";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			
			ИсключитьДанныеОбособленныхПодразделений = Истина;
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				ИсключаемыеПодразделения.Добавить(Выборка.Подразделение);
				
				Запрос.УстановитьПараметр("Родитель", Выборка.Подразделение);
				Запрос.Текст =
					"ВЫБРАТЬ
					|	ПодразделенияОрганизаций.Ссылка
					|ИЗ
					|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
					|ГДЕ
					|	ПодразделенияОрганизаций.Родитель В ИЕРАРХИИ(&Родитель)";
				
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
					ИсключаемыеПодразделения, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"), Истина);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Данные по обособленному подразделению
	ОбособленноеПодразделение = Неопределено;
	ПодразделенияОбособленного = Новый Массив;
	
	Если ПараметрыОтчета.Свойство("ОбособленноеПодразделение")
		И ПараметрыОтчета.ОбособленноеПодразделение <> Неопределено Тогда
		
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыОтчета.ОбособленноеПодразделение, "ОбособленноеПодразделение") Тогда
			
			ОбособленноеПодразделение = ПараметрыОтчета.ОбособленноеПодразделение;
			
			ПодразделенияОбособленного.Добавить(ОбособленноеПодразделение);
			
			Запрос.УстановитьПараметр("Родитель", ОбособленноеПодразделение);
			Запрос.Текст =
				"ВЫБРАТЬ
				|	ПодразделенияОрганизаций.Ссылка
				|ИЗ
				|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
				|ГДЕ
				|	ПодразделенияОрганизаций.Родитель В ИЕРАРХИИ(&Родитель)";
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				ПодразделенияОбособленного, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Организации.КодОКВЭД2 КАК КодОКВЭД,
		|	Организации.НаименованиеОКВЭД2 КАК НаименованиеОКВЭД
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		П0001002В1 = Выборка.КодОКВЭД;
		П0001002А1 = Выборка.НаименованиеОКВЭД;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоГода", 				НачалоГода(ПараметрыОтчета.ДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("ОкончаниеИнтервала", 		КонецМесяца(ПараметрыОтчета.ДатаКонцаПериодаОтчета));
	
	Отборы = Новый Массив;
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ДатаУвольнения", "<>", "ДАТАВРЕМЯ(1,1,1)");
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ДатаПриема", "<=", КонецМесяца(ПараметрыОтчета.ДатаКонцаПериодаОтчета));
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ГоловнаяОрганизация", "=", ЗарплатаКадры.ГоловнаяОрганизация(ПараметрыОтчета.Организация));
	
	ТекущиеКадровыеДанные = "ТекущаяОрганизация";
	
	Если ИсключитьДанныеОбособленныхПодразделений
		Или ОбособленноеПодразделение <> Неопределено Тогда
		
		ТекущиеКадровыеДанные = ТекущиеКадровыеДанные + ",ТекущееПодразделение";
		
	КонецЕсли;
	
	КадровыйУчет.СоздатьВТТекущиеКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, Ложь, Отборы, ТекущиеКадровыеДанные);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТекущиеКадровыеДанныеСотрудников.Сотрудник) КАК КоличествоСотрудников
		|ИЗ
		|	ВТТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|ГДЕ
		|	(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = &Организация
		|			ИЛИ ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация ЕСТЬ NULL)";
	
	Если ИсключитьДанныеОбособленныхПодразделений Тогда
		
		Запрос.УстановитьПараметр("ИсключаемыеПодразделения", ИсключаемыеПодразделения);
		Запрос.Текст = Запрос.Текст + "
			|	И НЕ ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение В (&ИсключаемыеПодразделения)";
		
	ИначеЕсли ОбособленноеПодразделение <> Неопределено Тогда
		
		Запрос.УстановитьПараметр("ПодразделенияОбособленного", ПодразделенияОбособленного);
		Запрос.Текст = Запрос.Текст + "
			|	И ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение В (&ПодразделенияОбособленного)";
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	Иначе
		
		ЗаполнятьП010000205ИП010000206 = Ложь;
		
		Если КонецДня(ПараметрыОтчета.ДатаКонцаПериодаОтчета) = КонецКвартала(ПараметрыОтчета.ДатаКонцаПериодаОтчета) Тогда
			ЗаполнятьП010000205ИП010000206 = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	ДелитьНа1000 = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность") Тогда
		ВерсияБРО = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем().ПоИменам["РегламентированнаяОтчетность"].Версия;
		Если ВерсияЧислом(ВерсияБРО) < ВерсияЧислом("1.1.12.0") Тогда
			ДелитьНа1000 = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Результаты = СведенияОЧисленностиИВыплатах(
		ПараметрыОтчета.Организация,
		ПараметрыОтчета.ДатаНачалаПериодаОтчета,
		ПараметрыОтчета.ДатаКонцаПериодаОтчета,
		ИсключитьДанныеОбособленныхПодразделений,
		ИсключаемыеПодразделения,
		ПодразделенияОбособленного,
		ДелитьНа1000);
	
	КоличествоРезультатов = Результаты.Количество();
	
	СведенияОЧисленности = Результаты[КоличествоРезультатов-3].Выбрать();
	П010000202 = 0;
	П010000203 = 0;
	Пока СведенияОЧисленности.Следующий() Цикл
		П010000202 = П010000202 + СведенияОЧисленности.СреднесписочнаяЧисленность;
		П010000203 = П010000203 + СведенияОЧисленности.СреднесписочнаяЧисленностьСовместители;
	КонецЦикла;
	
	СведенияОСоциальныхВыплатах    = Результаты[КоличествоРезультатов-2].Выбрать();
	П010000211 = 0;
	Пока СведенияОСоциальныхВыплатах.Следующий() Цикл
		П010000211 = П010000211 + СведенияОСоциальныхВыплатах.ВыплатыСоциальногоХарактера;
	КонецЦикла;
	
	СведенияОЗаработнойПлате = Результаты[КоличествоРезультатов-1].Выбрать();
	П010000205 = 0;
	П010000206 = 0;
	П010000208 = 0;
	П010000209 = 0;
	Пока СведенияОЗаработнойПлате.Следующий() Цикл
		
		Если ЗаполнятьП010000205ИП010000206 Тогда
			П010000205 = П010000205 + СведенияОЗаработнойПлате.ОтработаноЧасов;
			П010000206 = П010000206 + СведенияОЗаработнойПлате.ОтработаноЧасовСовместитель;
		КонецЕсли;
		
		П010000208 = П010000208 + СведенияОЗаработнойПлате.Результат;
		П010000209 = П010000209 + СведенияОЗаработнойПлате.РезультатСовместитель;
		
	КонецЦикла;
	
	Попытка
	
		ПоляОтчета = Контейнер.ПолеТабличногоДокументаФормаОтчета;
		
		ПоляОтчета.П0001002В1 = П0001002В1;
		ПоляОтчета.П0001002А1 = П0001002А1;
		
		ПоляОтчета.П010000202 = Цел(П010000202);
		ПоляОтчета.П010000203 = Цел(П010000203 * 10) / 10;
		ПоляОтчета.П010000205 = П010000205;
		ПоляОтчета.П010000206 = П010000206;
		ПоляОтчета.П010000211 = П010000211;
		ПоляОтчета.П010000205 = П010000205;
		ПоляОтчета.П010000206 = П010000206;
		ПоляОтчета.П010000208 = П010000208;
		ПоляОтчета.П010000209 = П010000209;
	
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Порядок заполнения отчета устарел, рекомендуем обновить конфигурацию.%1'"), Символы.ПС);
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Отчет не заполнен.'");
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
КонецПроцедуры

Функция СведенияОЧисленностиИВыплатах(Знач Организация, Знач ДатаНачала, Знач ДатаКонца, Знач ИсключитьДанныеОбособленныхПодразделений, Знач ИсключаемыеПодразделения, Знач ПодразделенияОбособленного, ДелитьНа1000)
	
	ВидыВыплатСоциальногоХарактера = Новый Массив;
	ВидыВыплатСоциальногоХарактера.Добавить(Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп9ст255);
	ВидыВыплатСоциальногоХарактера.Добавить(Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп12_1ст255);
	ВидыВыплатСоциальногоХарактера.Добавить(Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп13ст255);
	ВидыВыплатСоциальногоХарактера.Добавить(Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп16ст255);
	ВидыВыплатСоциальногоХарактера.Добавить("2710");
	ВидыВыплатСоциальногоХарактера.Добавить("2720");
	ВидыВыплатСоциальногоХарактера.Добавить("2760");
	ВидыВыплатСоциальногоХарактера.Добавить("2762");
	ВидыВыплатСоциальногоХарактера.Добавить("2510");
	
	ВидыИсключаемыхВыплат = Новый Массив;
	ВидВыплаты = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС");
	
	Если ВидВыплаты <> Неопределено Тогда
		ВидыИсключаемыхВыплат.Добавить(ВидВыплаты);
	КонецЕсли;
	
	ВидВыплаты = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС_НС");
	Если ВидВыплаты <> Неопределено Тогда
		ВидыИсключаемыхВыплат.Добавить(ВидВыплаты);
	КонецЕсли;
	
	ВидыИсключаемыхВыплат.Добавить("2300");
	
	ИсключаемыеКатегорииНачислений = Новый Массив;
	ИсключаемыеКатегорииНачислений.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста);
	ИсключаемыеКатегорииНачислений.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя);
	ИсключаемыеКатегорииНачислений.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве);
	ИсключаемыеКатегорииНачислений.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоПрофзаболевание);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",					Организация);
	Запрос.УстановитьПараметр("ВидыВыплатСоциальногоХарактера",	ВидыВыплатСоциальногоХарактера);
	Запрос.УстановитьПараметр("ВидыИсключаемыхВыплат",			ВидыИсключаемыхВыплат);
	Запрос.УстановитьПараметр("ИсключаемыеКатегорииНачислений", ИсключаемыеКатегорииНачислений);
	Запрос.УстановитьПараметр("ДелительСумм", ?(ДелитьНа1000, 1000, 1));
	
	ОкончаниеИнтервала = КонецМесяца(ДатаКонца);
	Запрос.УстановитьПараметр("ОкончаниеИнтервала",				ОкончаниеИнтервала);
	
	Если НачалоМесяца(ДатаНачала) = НачалоМесяца(ОкончаниеИнтервала) Тогда
		НачалоИнтервала = НачалоМесяца(ДатаНачала);
		Запрос.УстановитьПараметр("НачалоИнтервала",			НачалоИнтервала);
	Иначе
		НачалоИнтервала = НачалоГода(ДатаНачала);
		Запрос.УстановитьПараметр("НачалоИнтервала",			НачалоГода(ДатаНачала));
	КонецЕсли;
	
	// Создание таблицы дней
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТПериоды(
		Запрос.МенеджерВременныхТаблиц,
		НачалоИнтервала,
		ОкончаниеИнтервала,
		"ДЕНЬ",
		"Дата",
		"Календарь");
	
	// Получение сотрудников организации
	ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолучения.Организация = Организация;
	ПараметрыПолучения.НачалоПериода = НачалоИнтервала;
	ПараметрыПолучения.ОкончаниеПериода = ОкончаниеИнтервала;
	ПараметрыПолучения.КадровыеДанные = "ДатаПриема,ДатаУвольнения";
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ПараметрыПолучения);
	
	// Получение кадровых данных по дням периода
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизацииПоОсновномуМестуРаботы.Сотрудник,
		|	СотрудникиОрганизацииПоОсновномуМестуРаботы.ДатаПриема,
		|	СотрудникиОрганизацииПоОсновномуМестуРаботы.ДатаУвольнения,
		|	СписокДат.Дата КАК Дата
		|ПОМЕСТИТЬ ВТСотрудникиДаты
		|ИЗ
		|	Календарь КАК СписокДат
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК СотрудникиОрганизацииПоОсновномуМестуРаботы
		|		ПО (ИСТИНА)";
	
	Запрос.Выполнить();
	
	ОписательТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТСотрудникиДаты",
		"Сотрудник,Дата");
	
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательТаблиц, Истина, "Подразделение,ВидЗанятости");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиДаты.Сотрудник КАК Сотрудник,
		|	СотрудникиДаты.Дата КАК Дата,
		|	НАЧАЛОПЕРИОДА(СотрудникиДаты.Дата, МЕСЯЦ) КАК Месяц,
		|	ЛОЖЬ КАК Совместитель
		|ПОМЕСТИТЬ ВТДатыИСотрудники
		|ИЗ
		|	ВТСотрудникиДаты КАК СотрудникиДаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
		|			И СотрудникиДаты.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|			И (КадровыеДанныеСотрудников.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы))
		|			И (СотрудникиДаты.Дата >= СотрудникиДаты.ДатаПриема)
		|			И (СотрудникиДаты.Дата <= СотрудникиДаты.ДатаУвольнения
		|					И СотрудникиДаты.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
		|				ИЛИ СотрудникиДаты.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СотрудникиДаты.Сотрудник,
		|	СотрудникиДаты.Дата,
		|	НАЧАЛОПЕРИОДА(СотрудникиДаты.Дата, МЕСЯЦ),
		|	ИСТИНА
		|ИЗ
		|	ВТСотрудникиДаты КАК СотрудникиДаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
		|			И СотрудникиДаты.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|			И (КадровыеДанныеСотрудников.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Совместительство))
		|			И (СотрудникиДаты.Дата >= СотрудникиДаты.ДатаПриема)
		|			И (СотрудникиДаты.Дата <= СотрудникиДаты.ДатаУвольнения
		|					И СотрудникиДаты.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
		|				ИЛИ СотрудникиДаты.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1))";
	
	Если ИсключитьДанныеОбособленныхПодразделений И ИсключаемыеПодразделения.Количество() > 0 Тогда
		
		Запрос.УстановитьПараметр("ИсключаемыеПодразделения", ИсключаемыеПодразделения);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период",
			"ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
			|	И НЕ КадровыеДанныеСотрудников.Подразделение В (&ИсключаемыеПодразделения)");
		
	ИначеЕсли ПодразделенияОбособленного.Количество() > 0 Тогда
		
		Запрос.УстановитьПараметр("ПодразделенияОбособленного", ПодразделенияОбособленного);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период",
			"ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
			|	И КадровыеДанныеСотрудников.Подразделение В (&ПодразделенияОбособленного)");
		
	КонецЕсли;
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиДаты.Сотрудник КАК Сотрудник,
		|	СотрудникиДаты.Дата КАК Дата,
		|	НАЧАЛОПЕРИОДА(СотрудникиДаты.Дата, МЕСЯЦ) КАК Месяц
		|ПОМЕСТИТЬ ВТДатыИВнутренниеСовместители
		|ИЗ
		|	ВТСотрудникиДаты КАК СотрудникиДаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
		|			И СотрудникиДаты.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|			И (КадровыеДанныеСотрудников.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ВнутреннееСовместительство))
		|			И (СотрудникиДаты.Дата >= СотрудникиДаты.ДатаПриема)
		|			И (СотрудникиДаты.Дата <= СотрудникиДаты.ДатаУвольнения
		|					И СотрудникиДаты.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
		|				ИЛИ СотрудникиДаты.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1))";
	
	Если ИсключитьДанныеОбособленныхПодразделений И ИсключаемыеПодразделения.Количество() > 0 Тогда
		
		Запрос.УстановитьПараметр("ИсключаемыеПодразделения", ИсключаемыеПодразделения);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период",
			"ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
			|	И НЕ КадровыеДанныеСотрудников.Подразделение В (&ИсключаемыеПодразделения)");
		
	ИначеЕсли ПодразделенияОбособленного.Количество() > 0 Тогда
		
		Запрос.УстановитьПараметр("ПодразделенияОбособленного", ПодразделенияОбособленного);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период",
			"ПО СотрудникиДаты.Дата = КадровыеДанныеСотрудников.Период
			|	И КадровыеДанныеСотрудников.Подразделение В (&ПодразделенияОбособленного)");
		
	КонецЕсли;
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА СписокДат.Сотрудник ЕСТЬ НЕ NULL 
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоСотрудников,
		|	ДЕНЬ(КОНЕЦПЕРИОДА(СписокДат.Дата, МЕСЯЦ)) КАК ДнейВМесяце,
		|	СписокДат.Месяц,
		|	СписокДат.Совместитель
		|ПОМЕСТИТЬ ВТСредняяЧисленностьПоМесяцам
		|ИЗ
		|	ВТДатыИСотрудники КАК СписокДат
		|
		|СГРУППИРОВАТЬ ПО
		|	ДЕНЬ(КОНЕЦПЕРИОДА(СписокДат.Дата, МЕСЯЦ)),
		|	СписокДат.Месяц,
		|	СписокДат.Совместитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДатыИСотрудники.Сотрудник,
		|	ДатыИСотрудники.Месяц,
		|	ДатыИСотрудники.Совместитель
		|ПОМЕСТИТЬ ВТСписокСотрудниковИДат
		|ИЗ
		|	ВТДатыИСотрудники КАК ДатыИСотрудники
		|
		|СГРУППИРОВАТЬ ПО
		|	ДатыИСотрудники.Сотрудник,
		|	ДатыИСотрудники.Месяц,
		|	ДатыИСотрудники.Совместитель
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДатыИВнутренниеСовместители.Сотрудник,
		|	ДатыИВнутренниеСовместители.Месяц,
		|	ДатыИСотрудники.Совместитель
		|ИЗ
		|	ВТДатыИВнутренниеСовместители КАК ДатыИВнутренниеСовместители
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДатыИСотрудники КАК ДатыИСотрудники
		|		ПО ДатыИВнутренниеСовместители.Дата = ДатыИСотрудники.Дата
		|			И (ВЫРАЗИТЬ(ДатыИВнутренниеСовместители.Сотрудник КАК Справочник.Сотрудники).ФизическоеЛицо = ВЫРАЗИТЬ(ДатыИСотрудники.Сотрудник КАК Справочник.Сотрудники).ФизическоеЛицо)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДатыИВнутренниеСовместители.Сотрудник,
		|	ДатыИВнутренниеСовместители.Месяц,
		|	ДатыИСотрудники.Совместитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.Ссылка КАК Начисление
		|ПОМЕСТИТЬ ВТВидыИсключаемыхВыплат
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК Начисления
		|ГДЕ
		|	(Начисления.ВидНачисленияДляНУ В (&ВидыИсключаемыхВыплат)
		|			ИЛИ Начисления.КодДоходаНДФЛ.Код В (&ВидыИсключаемыхВыплат)
		|			ИЛИ Начисления.КатегорияНачисленияИлиНеоплаченногоВремени В (&ИсключаемыеКатегорииНачислений))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.Ссылка КАК Начисление
		|ПОМЕСТИТЬ ВТВидыНачисленийСоциальногоХарактера
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК Начисления
		|ГДЕ
		|	(Начисления.ВидНачисленияДляНУ В (&ВидыВыплатСоциальногоХарактера)
		|			ИЛИ Начисления.КодДоходаНДФЛ.Код В (&ВидыВыплатСоциальногоХарактера))";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НачисленияУдержанияПоСотрудникам.Сотрудник КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА ВЫРАЗИТЬ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание КАК ПланВидовРасчета.Начисления).КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска)
		|			ТОГДА 0
		|		ИНАЧЕ ОтработанноеВремяПоСотрудникам.ОтработаноЧасов
		|	КОНЕЦ КАК ОтработаноЧасов,
		|	НАЧАЛОПЕРИОДА(НачисленияУдержанияПоСотрудникам.Период, МЕСЯЦ) КАК МесяцНачисления,
		|	КОНЕЦПЕРИОДА(НачисленияУдержанияПоСотрудникам.Период, МЕСЯЦ) КАК ДатаКадровыхДанных,
		|	ВЫБОР
		|		КОГДА НачисленияУдержанияПоСотрудникам.Период >= &НачалоИнтервала
		|			ТОГДА НачисленияУдержанияПоСотрудникам.НачислениеУдержание
		|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовРасчета.Начисления.ПустаяСсылка)
		|	КОНЕЦ КАК Начисление,
		|	ВЫБОР
		|		КОГДА НачисленияУдержанияПоСотрудникам.Период >= &НачалоИнтервала
		|			ТОГДА НачисленияУдержанияПоСотрудникам.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Результат
		|ПОМЕСТИТЬ ВТНачислениеЗарплаты
		|ИЗ
		|	РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОтработанноеВремяПоСотрудникам КАК ОтработанноеВремяПоСотрудникам
		|		ПО НачисленияУдержанияПоСотрудникам.Регистратор = ОтработанноеВремяПоСотрудникам.Регистратор
		|			И НачисленияУдержанияПоСотрудникам.Сотрудник = ОтработанноеВремяПоСотрудникам.Сотрудник
		|			И НачисленияУдержанияПоСотрудникам.НачислениеУдержание = ОтработанноеВремяПоСотрудникам.Начисление
		|			И НачисленияУдержанияПоСотрудникам.ПериодДействия = ОтработанноеВремяПоСотрудникам.ПериодДействия
		|			И НачисленияУдержанияПоСотрудникам.ДатаНачала = ОтработанноеВремяПоСотрудникам.ДатаНачала
		|ГДЕ
		|	НачисленияУдержанияПоСотрудникам.Период МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоИнтервала, ГОД) И &ОкончаниеИнтервала
		|	И НачисленияУдержанияПоСотрудникам.Организация = &Организация
		|	И НачисленияУдержанияПоСотрудникам.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
		|	И НЕ НачисленияУдержанияПоСотрудникам.НачислениеУдержание В
		|				(ВЫБРАТЬ
		|					ВТВидыИсключаемыхВыплат.Начисление
		|				ИЗ
		|					ВТВидыИсключаемыхВыплат КАК ВТВидыИсключаемыхВыплат)";
	
	Если ИсключитьДанныеОбособленныхПодразделений И ИсключаемыеПодразделения.Количество() > 0 Тогда
		
		Запрос.Текст = Запрос.Текст + "
			|	И НЕ НачисленияУдержанияПоСотрудникам.Подразделение В (&ИсключаемыеПодразделения)";
		
	ИначеЕсли ПодразделенияОбособленного.Количество() > 0 Тогда
		
		Запрос.Текст = Запрос.Текст + "
			|	И НачисленияУдержанияПоСотрудникам.Подразделение В (&ПодразделенияОбособленного)";
		
	КонецЕсли;
		
	Запрос.Выполнить();
	
	ОписательТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТНачислениеЗарплаты", "Сотрудник,ДатаКадровыхДанных");
	
	ОписательТаблиц.ИмяВТКадровыеДанныеСотрудников = "ВТКадровыеДанныеСотрудниковНачислений";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательТаблиц, Истина, "ВидЗанятости");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанные.Период,
		|	КадровыеДанные.Сотрудник,
		|	КадровыеДанные.ВидЗанятости
		|ПОМЕСТИТЬ ВТДанныеСотрудниковНачислений
		|ИЗ
		|	ВТКадровыеДанныеСотрудниковНачислений КАК КадровыеДанные
		|ГДЕ
		|	КадровыеДанные.ВидЗанятости В (ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы), ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Совместительство))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КадровыеДанные.Период,
		|	КадровыеДанные.Сотрудник,
		|	КадровыеДанныеОсновных.ВидЗанятости
		|ИЗ
		|	ВТКадровыеДанныеСотрудниковНачислений КАК КадровыеДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудниковНачислений КАК КадровыеДанныеОсновных
		|		ПО КадровыеДанные.Период = КадровыеДанныеОсновных.Период
		|			И КадровыеДанные.ФизическоеЛицо = КадровыеДанныеОсновных.ФизическоеЛицо
		|			И (КадровыеДанныеОсновных.ВидЗанятости В (ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы), ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Совместительство)))
		|ГДЕ
		|	НЕ КадровыеДанные.ВидЗанятости В (ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы), ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Совместительство))";
	
	Запрос.Выполнить();
	
	// формирование результатов
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА СредняяЧисленностьПоМесяцам.Совместитель
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(СУММА(ВЫРАЗИТЬ(СредняяЧисленностьПоМесяцам.КоличествоСотрудников / СредняяЧисленностьПоМесяцам.ДнейВМесяце КАК ЧИСЛО(15, 0))) / КОЛИЧЕСТВО(СредняяЧисленностьПоМесяцам.Месяц), 0)
		|	КОНЕЦ КАК СреднесписочнаяЧисленность,
		|	ВЫБОР
		|		КОГДА СредняяЧисленностьПоМесяцам.Совместитель
		|			ТОГДА ЕСТЬNULL(СУММА(ВЫРАЗИТЬ(СредняяЧисленностьПоМесяцам.КоличествоСотрудников / СредняяЧисленностьПоМесяцам.ДнейВМесяце КАК ЧИСЛО(15, 1))) / КОЛИЧЕСТВО(СредняяЧисленностьПоМесяцам.Месяц), 0)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СреднесписочнаяЧисленностьСовместители
		|ИЗ
		|	ВТСредняяЧисленностьПоМесяцам КАК СредняяЧисленностьПоМесяцам
		|
		|СГРУППИРОВАТЬ ПО
		|	СредняяЧисленностьПоМесяцам.Совместитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ЕСТЬNULL(НачислениеЗарплаты.Результат, 0) / &ДелительСумм КАК ЧИСЛО(15, 1)) КАК ВыплатыСоциальногоХарактера,
		|	НачислениеЗарплаты.Сотрудник
		|ИЗ
		|	ВТНачислениеЗарплаты КАК НачислениеЗарплаты
		|ГДЕ
		|	НачислениеЗарплаты.Начисление В
		|			(ВЫБРАТЬ
		|				ВидыНачисленийСоциальногоХарактера.Начисление КАК Начисление
		|			ИЗ
		|				ВТВидыНачисленийСоциальногоХарактера КАК ВидыНачисленийСоциальногоХарактера)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НачислениеЗарплаты.Сотрудник,
		|	НачислениеЗарплаты.МесяцНачисления КАК Месяц,
		|	СУММА(ЕСТЬNULL(НачислениеЗарплаты.ОтработаноЧасов, 0)) КАК ОтработаноЧасов,
		|	СУММА(ВЫРАЗИТЬ(ЕСТЬNULL(НачислениеЗарплаты.Результат, 0) / &ДелительСумм КАК ЧИСЛО(15, 1))) КАК Результат,
		|	0 КАК ОтработаноЧасовСовместитель,
		|	0 КАК РезультатСовместитель,
		|	ЛОЖЬ КАК Совместитель
		|ИЗ
		|	ВТНачислениеЗарплаты КАК НачислениеЗарплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеСотрудниковНачислений КАК КадровыеДанные
		|		ПО НачислениеЗарплаты.Сотрудник = КадровыеДанные.Сотрудник
		|			И (КОНЕЦПЕРИОДА(НачислениеЗарплаты.МесяцНачисления, МЕСЯЦ) = КадровыеДанные.Период)
		|ГДЕ
		|	КадровыеДанные.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы)
		|
		|СГРУППИРОВАТЬ ПО
		|	НачислениеЗарплаты.Сотрудник,
		|	НачислениеЗарплаты.МесяцНачисления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НачислениеЗарплаты.Сотрудник,
		|	НачислениеЗарплаты.МесяцНачисления,
		|	0,
		|	0,
		|	СУММА(ЕСТЬNULL(НачислениеЗарплаты.ОтработаноЧасов, 0)),
		|	СУММА(ВЫРАЗИТЬ(ЕСТЬNULL(НачислениеЗарплаты.Результат, 0) / &ДелительСумм КАК ЧИСЛО(15, 1))),
		|	ИСТИНА
		|ИЗ
		|	ВТНачислениеЗарплаты КАК НачислениеЗарплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеСотрудниковНачислений КАК КадровыеДанные
		|		ПО НачислениеЗарплаты.Сотрудник = КадровыеДанные.Сотрудник
		|			И (КОНЕЦПЕРИОДА(НачислениеЗарплаты.МесяцНачисления, МЕСЯЦ) = КадровыеДанные.Период)
		|ГДЕ
		|	КадровыеДанные.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Совместительство)
		|
		|СГРУППИРОВАТЬ ПО
		|	НачислениеЗарплаты.Сотрудник,
		|	НачислениеЗарплаты.МесяцНачисления";
	
	Возврат Запрос.ВыполнитьПакет();
	
КонецФункции

// Преобразует строковое представление версии в числовое.
Функция ВерсияЧислом(СтрокаВерсии, МножительРазрядов = 1000)
	Результат = 0;
	Фрагменты = СтрРазделить(СтрокаВерсии, ".");
	Для Каждого ФрагментВерсии Из Фрагменты Цикл
		Результат = Результат * МножительРазрядов + Число(ФрагментВерсии);
	КонецЦикла;
	Возврат Результат;
КонецФункции

#КонецОбласти
