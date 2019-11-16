#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ЗарплатаОтраженаВБухучете = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ТребуетсяУтверждениеДокумента = Документы.ОтражениеЗарплатыВБухучете.ТребуетсяУтверждениеДокументаБухгалтером(Организация);
	
	Если Не ТребуетсяУтверждениеДокумента Или ЗарплатаОтраженаВБухучете Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОценочныеОбязательстваЗарплатаКадры") Тогда
			 
			МодульРезервОтпусков = ОбщегоНазначения.ОбщийМодуль("РезервОтпусковПереопределяемый");
			РезервыРассчитываются = Истина;
			МодульРезервОтпусков.ПолучитьЗначениеРезервыРассчитываются(РезервыРассчитываются);
			
			Если РезервыРассчитываются Тогда
				МодульРезервОтпусков = ОбщегоНазначения.ОбщийМодуль("РезервОтпусков");
				НастройкиРезервовОтпусков = МодульРезервОтпусков.НастройкиРезервовОтпусков(Организация, ПериодРегистрации);
				Если НастройкиРезервовОтпусков.ФормироватьРезервОтпусковБУ Тогда
					ТаблицаВыплатаОтпусковЗаСчетРезерва = ОтражениеЗарплатыВБухучете.НоваяТаблицаНачисленныеОтпуска();
					Для каждого СтрокаТЧ Из ВыплатаОтпусковЗаСчетРезерва Цикл
						ЗаполнитьЗначенияСвойств(ТаблицаВыплатаОтпусковЗаСчетРезерва.Добавить(),СтрокаТЧ);
					КонецЦикла;
					МодульРезервОтпусков.СформироватьДвиженияВыплатаОтпусковЗаСчетРезерва(Движения, Отказ, Организация, ПериодРегистрации, ТаблицаВыплатаОтпусковЗаСчетРезерва);
					ДвиженияВыплатаОтпусковЗаСчетРезерва = Движения.ОценочныеОбязательстваПоСотрудникам.Выгрузить();
					МодульРезервОтпусков.СформироватьДвиженияСписаниеРезерваОтпусков(Движения, Отказ, Организация, ПериодРегистрации, ДвиженияВыплатаОтпусковЗаСчетРезерва);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТаблицаНачисленныйНДФЛ = НачисленныйНДФЛ.Выгрузить();
		ОтражениеЗарплатыВБухучете.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Организация, ПериодРегистрации, ТаблицаНачисленныйНДФЛ);
		
		ДанныеДляОтражения = Новый Структура;
		ДанныеДляОтражения.Вставить("НачисленнаяЗарплатаИВзносы", НачисленнаяЗарплатаИВзносы.Выгрузить());
		ДанныеДляОтражения.Вставить("НачисленныйНДФЛ", ТаблицаНачисленныйНДФЛ);
		ДанныеДляОтражения.Вставить("УдержаннаяЗарплата", УдержаннаяЗарплата.Выгрузить());
		
		ОтражениеЗарплатыВБухучетеПереопределяемый.СформироватьДвижения(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляОтражения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаОтраженаВБухучете = Ложь;
	Бухгалтер = Справочники.Пользователи.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти


#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли