#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ФормированиеЗаписейКнигиПродаж.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
    
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УчетНДС.СФормироватьДвиженияНачислениеНДСНачислениеНДСПоРеализации(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаПоРеализации, Движения, Отказ);
		
	УчетНДС.СформироватьДвиженияНачислитьНДССПолученногоАванса(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаНДССАвансов, Движения, Отказ);
			
	УчетНДС.СФормироватьДвиженияНачислениеНДСПоНДСНачисленномуКУплате(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаНачисленКУплате, Движения, Отказ);
		
	Документы.ФормированиеЗаписейКнигиПродаж.СформироватьДвиженияВосстановлениеНДСПоВыданнымАвансам(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаВосстановленПоАвансам, Движения, Отказ);
			
	УчетНДС.СФормироватьДвиженияНачислениеНДСВосстановлениеНДС(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаВосстановлениеПоДругимОперациям, Движения, Отказ);
		
	УчетНДС.СФормироватьДвиженияНачислениеНДСНеОтражаютсяВКниге(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаНДСНеОтражаетсяВКниге, Движения, Отказ);
		
	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СформироватьДвиженияФактВыполненияРегламентнойОперации(
		ПараметрыПроведения.ДанныеРегламентнойОперации, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СброситьФактВыполненияОперации(Ссылка);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
		
	Реализация0 = Ложь;
	ДокументСозданВПомощнике = Ложь;

	Реализация.Очистить();
	Авансы.Очистить();
	НачисленКУплате.Очистить();
	НеОтражаетсяВКниге.Очистить();
	Восстановлен.Очистить();
	ВосстановленПоАвансам.Очистить();
	
КонецПроцедуры

Функция НеобходимостьПокупателяВСтрокеТаблицы(Строка)

	Возврат УчетНДСПереопределяемый.НеобходимоУказаниеКонтрагентаДляСчетаФактуры(Строка.СчетФактура, Строка.ВидЦенности);

КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Реализация.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("Авансы.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("НачисленКУплате.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("ВосстановленПоАвансам.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("Восстановлен.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("Реализация.Покупатель");
	МассивНепроверяемыхРеквизитов.Добавить("Авансы.Покупатель");
	МассивНепроверяемыхРеквизитов.Добавить("НачисленКУплате.Покупатель");
	МассивНепроверяемыхРеквизитов.Добавить("Восстановлен.Покупатель");
	
	Если НЕ Реализация0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Реализация.Состояние"); 
	КонецЕсли; 
	
	Для Каждого Строка Из Реализация Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Покупатель) И НеобходимостьПокупателяВСтрокеТаблицы(Строка) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Покупатель", 
				Строка.НомерСтроки, "Реализация");
				
				Префикс = "Реализация[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "Покупатель";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли; 
			
		Если Строка.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(Строка.КорректируемыйПериод) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Корректируемый период", 
				Строка.НомерСтроки, "Реализация");
				
				Префикс = "Реализация[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "КорректируемыйПериод";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;	
		
	КонецЦикла;	

	Для Каждого Строка Из Авансы Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Покупатель) И НеобходимостьПокупателяВСтрокеТаблицы(Строка) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Покупатель", 
				Строка.НомерСтроки, "Авансы");
				
				Префикс = "Авансы[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "Покупатель";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли; 
		
		Если Строка.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(Строка.КорректируемыйПериод) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Корректируемый период", 
				Строка.НомерСтроки, "Авансы");
				
				Префикс = "Авансы[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "КорректируемыйПериод";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;	
			
	КонецЦикла;	

	Для Каждого Строка Из НачисленКУплате Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Покупатель) И НеобходимостьПокупателяВСтрокеТаблицы(Строка) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Покупатель", 
				Строка.НомерСтроки, "НачисленКУплате");
				
				Префикс = "НачисленКУплате[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "Покупатель";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли; 
		
		Если Строка.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(Строка.КорректируемыйПериод) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Корректируемый период", 
				Строка.НомерСтроки, "Начислен к уплате");
				
				Префикс = "НачисленКУплате[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "КорректируемыйПериод";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;	
			
	КонецЦикла;	
 
	Для Каждого Строка Из ВосстановленПоАвансам Цикл
		
		Если Строка.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(Строка.КорректируемыйПериод) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Корректируемый период", 
				Строка.НомерСтроки, "Восстановлен по авансам");
				
				Префикс = "ВосстановленПоАвансам[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "КорректируемыйПериод";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;	
			
	КонецЦикла;	
		
	Для Каждого Строка Из Восстановлен Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Покупатель) И НеобходимостьПокупателяВСтрокеТаблицы(Строка) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Покупатель", 
				Строка.НомерСтроки, "Восстановлен");
				
				Префикс = "Восстановлен[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "Покупатель";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли; 
		
		Если Строка.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(Строка.КорректируемыйПериод) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", "Корректируемый период", 
				Строка.НомерСтроки, "Восстановлен");
				
				Префикс = "Восстановлен[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				Поле = Префикс + "КорректируемыйПериод";
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;	
			
	КонецЦикла;	
    	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
КонецПроцедуры


#КонецЕсли