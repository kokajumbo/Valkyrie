#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	ТипРегистратора = ТипЗнч(Регистратор);
	
	ПроводкиВведеныПользователем = ТипРегистратора = Тип("ДокументСсылка.ОперацияБух")
		ИЛИ (ОбщегоНазначения.ЕстьРеквизитОбъекта("РучнаяКорректировка", Регистратор.Метаданные())
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Регистратор, "РучнаяКорректировка"));
	
	Если НЕ ПроводкиВведеныПользователем Тогда
		ОбработатьПроводкиНалоговогоУчета(ЭтотОбъект, Регистратор);
	КонецЕсли;
	
	ОчиститьНеИспользуемыеСуммы(ЭтотОбъект, Регистратор);
	ПривестиПустыеЗначенияСубконтоСоставногоТипа(ЭтотОбъект);
	
	ОчиститьСубконтоСпособУчетаНДС(ЭтотОбъект, Регистратор);
	
	Если ПроводкиВведеныПользователем Тогда
		// Проанализируем ручные проводки и зарегистрируем при необходимости 
		// договоры из них к отложенному расчету.
		УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентамиПередЗаписьюХозрасчетный(
			ЭтотОбъект, 
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Субконто составного типа

Процедура ПривестиПустыеЗначенияСубконтоСоставногоТипа(Проводки)
	
	КэшВидыСоставныхСубконто = Новый Соответствие;
	
	Для Каждого Проводка Из Проводки Цикл
		
		Для Каждого Субконто Из Проводка.СубконтоДт Цикл
			
			Если НЕ ЗначениеЗаполнено(Субконто.Значение) 
				И Субконто.Значение <> Неопределено 
				И СоставнойТипСубконто(Субконто.Ключ, КэшВидыСоставныхСубконто) Тогда
				Проводка.СубконтоДт.Вставить(Субконто.Ключ, Неопределено);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого Субконто Из Проводка.СубконтоКт Цикл
			
			Если НЕ ЗначениеЗаполнено(Субконто.Значение) 
				И Субконто.Значение <> Неопределено 
				И СоставнойТипСубконто(Субконто.Ключ, КэшВидыСоставныхСубконто) Тогда
				Проводка.СубконтоКт.Вставить(Субконто.Ключ, Неопределено);
			КонецЕсли;
			
		КонецЦикла;
				
	КонецЦикла;
	
КонецПроцедуры

Функция СоставнойТипСубконто(ВидСубконто, КэшВидыСоставныхСубконто)
	
	Составной = КэшВидыСоставныхСубконто.Получить(ВидСубконто);
	
	Если Составной = Неопределено Тогда
		Составной = ВидСубконто.ТипЗначения.Типы().Количество() > 1;
		КэшВидыСоставныхСубконто.Вставить(ВидСубконто, Составной);
	КонецЕсли;
	
	Возврат Составной;
	
КонецФункции

// Особенности налогового учета

Процедура ОбработатьПроводкиНалоговогоУчета(Проводки, Регистратор)
	
	СуммыНалоговогоУчетаЗаполнены = // Проводки созданы алгоритмом, который рассчитывает суммы НУ
		ЭтотОбъект.ДополнительныеСвойства.Свойство("СуммыНалоговогоУчетаЗаполнены") 
		И ЭтотОбъект.ДополнительныеСвойства.СуммыНалоговогоУчетаЗаполнены = Истина;
	
	Если НЕ СуммыНалоговогоУчетаЗаполнены Тогда
		ЗаполнитьСуммыНалоговогоУчета(Проводки);
	КонецЕсли;
	
	ОтразитьДоходыРасходыНеУчитываемыеВНалоговомУчете(Проводки);
	
КонецПроцедуры
	
Процедура ОчиститьНеИспользуемыеСуммы(Проводки, Регистратор)
	
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ВводНачальныхОстатков") Тогда 
		Возврат;  // Для записи остатков налогового учета при переходе с УСН на общую систему
	КонецЕсли;
	
	СменаНалоговогоУчета = Ложь;
	Если Проводки.ДополнительныеСвойства.Свойство("СменаНалоговогоУчета", СменаНалоговогоУчета) и СменаНалоговогоУчета Тогда
		Возврат; 
	КонецЕсли;
	
	КэшУчетнойПолитики = Неопределено; // См. ДанныеУчетнойПолитики()
	
	Для Каждого Проводка Из ЭтотОбъект Цикл
		
		ДанныеУчетнойПолитики = ДанныеУчетнойПолитики(Проводка.Организация, Проводка.Период, КэшУчетнойПолитики);
		
		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль Тогда
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУКт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРКт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРКт);
			Продолжить;
		КонецЕсли;
	
		// Налог на прибыль уплачивается
		
		Если НЕ ДанныеУчетнойПолитики.ПоддержкаПБУ18 Тогда
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРКт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРКт);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСуммыНалоговогоУчета(Проводки)
	
	КэшУчетнойПолитики = Неопределено; // См. ДанныеУчетнойПолитики()
	СчетаЦелевогоФинансирования = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ЦелевоеФинансирование); // 86
	СчетаНДС                    = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.НДС);                   // 68.02
	СчетаПрочиеРасходы          = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ПрочиеРасходы);         // 91.02
	СчетСпецодеждаВЭксплуатацииВспомогательный   = ПланыСчетов.Хозрасчетный.СпецодеждаВЭксплуатацииВспомогательный;                    // 10.11.1
	СчетСпецоснасткаВЭксплуатацииВспомогательный = ПланыСчетов.Хозрасчетный.СпецоснасткаВЭксплуатацииВспомогательный;                  // 10.11.2
	СчетНДСНачисленныйПоОтгрузке                 = ПланыСчетов.Хозрасчетный.НДСНачисленныйПоОтгрузке;                                  // 76.ОТ
	СчетаАмортизацияОсновныхСредств = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.АмортизацияОсновныхСредств); // 02
	
	ТипПрочиеДоходыИРасходы = Тип("СправочникСсылка.ПрочиеДоходыИРасходы");
	ПрочиеДоходыИРасходыИсключения = Неопределено;
	
	Для Каждого Проводка Из ЭтотОбъект Цикл
		
		ДанныеУчетнойПолитики = ДанныеУчетнойПолитики(Проводка.Организация, Проводка.Период, КэшУчетнойПолитики);
		
		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль Тогда
			Продолжить;
		КонецЕсли;
	
		Если Проводка.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СчетДт = Проводка.СчетДт;
		СчетКт = Проводка.СчетКт;
		
		Если СчетаЦелевогоФинансирования.Найти(СчетДт) <> Неопределено
			Или СчетаЦелевогоФинансирования.Найти(СчетКт) <> Неопределено Тогда
			// Налоговые суммы по этим счетам рассчитываются в первичном документе по особым правилам
			Продолжить;
		КонецЕсли;
		
		Если СчетДт = СчетСпецодеждаВЭксплуатацииВспомогательный
		 Или СчетКт = СчетСпецодеждаВЭксплуатацииВспомогательный
		 Или СчетДт = СчетСпецоснасткаВЭксплуатацииВспомогательный
		 Или СчетКт = СчетСпецоснасткаВЭксплуатацииВспомогательный Тогда
			// Налоговые суммы по этим счетам рассчитываются в первичном документе по особым правилам
			Продолжить;
		КонецЕсли;
		
		Если СчетаАмортизацияОсновныхСредств.Найти(СчетДт) <> Неопределено
			И СчетаАмортизацияОсновныхСредств.Найти(СчетКт) <> Неопределено Тогда
			// Налоговые суммы по этим счетам рассчитываются в первичном документе по особым правилам
			Продолжить;
		КонецЕсли;
		
		// НДС, предъявленный покупателю, не учитывается в НУ (п. 19 ст. 270 НК)
		Если (СчетКт = СчетНДСНачисленныйПоОтгрузке
			Или СчетаНДС.Найти(СчетКт) <> Неопределено)   // Отсекаем заведомо не начисление НДС
		   И СчетаПрочиеРасходы.Найти(СчетДт) <> Неопределено Тогда
		   	// Рассматриваем только проводки вида Дт 91 Кт 68,
			// потому что на счете 90 есть отдельный субсчет, на котором не ведется налоговый учет.
			// Как правило, проводка Дт 91 Кт 68 начисляет НДС при реализации, но есть исключения:
			ЭтоИсключение = Ложь;
			Для Каждого Субконто Из Проводка.СубконтоДт Цикл
				Если ТипЗнч(Субконто.Значение) = ТипПрочиеДоходыИРасходы Тогда
					
					Если ПрочиеДоходыИРасходыИсключения = Неопределено Тогда
						ПрочиеДоходыИРасходыИсключения = ПолучитьПрочиеДоходыИРасходыИсключения();
					КонецЕсли;
					Если ПрочиеДоходыИРасходыИсключения[Субконто.Значение] = Истина Тогда
					
						ЭтоИсключение = Истина;
						Прервать;
						
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
			Если Не ЭтоИсключение Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетДт);
		Если СвойстваСчета.НалоговыйУчет 
			И Проводка.СуммаНУДт = 0 
			И Проводка.СуммаПРДт = 0 
			И Проводка.СуммаВРДт = 0 Тогда
			
			Проводка.СуммаНУДт = Проводка.Сумма;
			
		КонецЕсли;
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетКт);
		Если СвойстваСчета.НалоговыйУчет 
			И Проводка.СуммаНУКт = 0
			И Проводка.СуммаПРКт = 0
			И Проводка.СуммаВРКт = 0 Тогда
			
			Проводка.СуммаНУКт = Проводка.Сумма;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтразитьДоходыРасходыНеУчитываемыеВНалоговомУчете(Проводки)
	                                                                                                    
	СчетДоходыНеУчитываемые                   = ПланыСчетов.Хозрасчетный.ДоходыНеУчитываемые;                   // НЕ.04
	СчетРасчетыСПерсоналомПоОплатеТруда       = ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда;       // 70      
	СчетВнереализационныеРасходыНеУчитываемые = ПланыСчетов.Хозрасчетный.ВнереализационныеРасходыНеУчитываемые; // НЕ.03
	СчетВыплатыВпользуФизЛицПоП_1_48          = ПланыСчетов.Хозрасчетный.ВыплатыВпользуФизЛицПоП_1_48;          // НЕ.01.1
	СчетДругиеВыплатыПоП_1_48                 = ПланыСчетов.Хозрасчетный.ДругиеВыплатыПоП_1_48;                 // НЕ.01.9
	
	ПустойСчет     = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	ПустойПрочийДР = Справочники.ПрочиеДоходыИРасходы.ПустаяСсылка();
	ТипПрочиеДоходыИРасходы = Тип("СправочникСсылка.ПрочиеДоходыИРасходы");
	СчетаСтроительствоОбъектовОсновныхСредств = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств); // 08.03
	СчетаПрочиеДоходы = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ПрочиеДоходы); // 91.01
	ВидСубконтоПрочиеДоходыИРасходы = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы;
	ВидСубконтоСтатьиЗатрат = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат;
	
	ПрочиеДоходыИРасходыВнереализационные = Неопределено;
	
	// Удалим проводки по забалансовым счетам учета доходов и расходов
	ПроводкиКУдалению = Новый Массив;
	Для Каждого Проводка Из Проводки Цикл
		
		Если Проводка.СчетКт = СчетДоходыНеУчитываемые
			Или Проводка.СчетДт = СчетВнереализационныеРасходыНеУчитываемые
			Или Проводка.СчетДт = СчетВыплатыВпользуФизЛицПоП_1_48
			Или Проводка.СчетДт = СчетДругиеВыплатыПоП_1_48 Тогда
			// Такие проводки формируем только в этой процедуре
			ПроводкиКУдалению.Добавить(Проводка);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Проводка Из ПроводкиКУдалению Цикл
		Проводки.Удалить(Проводка);
	КонецЦикла;
	
	// Найдем проводки по доходам и расходам, не учитываемым в налоговом учете
	
	ПроводкиПоДоходам = Новый Массив;
	ПроводкиПоРасходам = Новый Массив;
	
	КэшУчетнойПолитики = Неопределено; // См. ДанныеУчетнойПолитики()
	
	Для Каждого Проводка Из ЭтотОбъект Цикл
		
		ДанныеУчетнойПолитики = ДанныеУчетнойПолитики(Проводка.Организация, Проводка.Период, КэшУчетнойПолитики);
	
		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль Тогда
			Продолжить;
		КонецЕсли;
		
		АнализируемыйСчет     = Проводка.СчетКт;
		АнализируемыеСубконто = Проводка.СубконтоКт;
		ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль = Ложь;
		Если ЗначениеЗаполнено(АнализируемыйСчет)
		   И БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(АнализируемыйСчет).НалоговыйУчет
		   И АнализируемыеСубконто.Количество() <> 0
		   И СчетаПрочиеДоходы.Найти(АнализируемыйСчет) <> Неопределено Тогда
		   
			Для Каждого Субконто Из АнализируемыеСубконто Цикл
				Если Субконто.Ключ = ВидСубконтоПрочиеДоходыИРасходы Тогда 
					
					Если НЕ НалоговыйУчетПовтИсп.ВидДоходовРасходовУчитывается(Субконто.Значение) Тогда
						ПроводкиПоДоходам.Добавить(Проводка);
						ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
		   
		КонецЕсли;
		
		АнализируемыйСчет     = Проводка.СчетДт;
		АнализируемыеСубконто = Проводка.СубконтоДт;
		Если Не ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль
		   И ЗначениеЗаполнено(АнализируемыйСчет)
		   И БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(АнализируемыйСчет).НалоговыйУчет
		   И АнализируемыеСубконто.Количество() <> 0
		   И СчетаСтроительствоОбъектовОсновныхСредств.Найти(АнализируемыйСчет) = Неопределено Тогда
		   
			Для Каждого Субконто Из АнализируемыеСубконто Цикл
				Если Субконто.Ключ = ВидСубконтоПрочиеДоходыИРасходы Тогда 
					
					Если Не НалоговыйУчетПовтИсп.ВидДоходовРасходовУчитывается(Субконто.Значение) Тогда
						ПроводкиПоРасходам.Добавить(Проводка);
						Прервать;
					КонецЕсли;
					
				ИначеЕсли Субконто.Ключ = ВидСубконтоСтатьиЗатрат Тогда 
					
					Если Не НалоговыйУчетПовтИсп.СтатьяЗатратУчитывается(Субконто.Значение) Тогда
						ПроводкиПоРасходам.Добавить(Проводка);
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
		   
		КонецЕсли;
		
	КонецЦикла;
	
	// Обработаем не учитываемые доходы:
	// - обеспечим, чтобы они не отражались в налоговом учете
	// - добавим проводки по забалансовому учету
	
	Для Каждого Проводка Из ПроводкиПоДоходам Цикл
		
		ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУКт, Проводка.СуммаПРКт);
		
		СуммаНеУчитываемыхДоходов = Проводка.Сумма 
			- ?(Проводка.СуммаВРДт = NULL, 0, Проводка.СуммаВРДт)
			- ?(Проводка.СуммаПРДт = NULL, 0, Проводка.СуммаПРДт);
		
		Если СуммаНеУчитываемыхДоходов = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Организация = Проводка.Организация;
		НоваяПроводка.Период      = Проводка.Период;
		НоваяПроводка.Содержание  = Проводка.Содержание;
		НоваяПроводка.СчетКт      = СчетДоходыНеУчитываемые;
		НоваяПроводка.СуммаНУКт   = СуммаНеУчитываемыхДоходов;
		
	КонецЦикла;
		
	// Обработаем не учитываемые расходы (также, как и доходы)
	Для Каждого Проводка Из ПроводкиПоРасходам Цикл
		
		ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУДт, Проводка.СуммаПРДт);
		
		СуммаНеУчитываемыхРасходов = Проводка.Сумма 
			- ?(Проводка.СуммаВРКт = NULL, 0, Проводка.СуммаВРКт)
			- ?(Проводка.СуммаПРКт = NULL, 0, Проводка.СуммаПРКт);
		
		Если СуммаНеУчитываемыхРасходов = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// анализируем проводку на принадлежность к внереализационным доходам и расходам
		ЭтоВнереализационныеДоходыРасходы = Ложь;
		Если Проводка.СчетКт <> ПустойСчет 
		   И СчетаПрочиеДоходы.Найти(Проводка.СчетКт) <> Неопределено Тогда
		   
			Для Каждого Субконто Из Проводка.СубконтоКт Цикл
				Если ТипЗнч(Субконто.Значение) = ТипПрочиеДоходыИРасходы Тогда
					
					Если ПрочиеДоходыИРасходыВнереализационные = Неопределено Тогда
						ПрочиеДоходыИРасходыВнереализационные = ПолучитьПрочиеДоходыИРасходыВнереализационные();
					КонецЕсли;
					Если ПрочиеДоходыИРасходыВнереализационные[Субконто.Значение] = Истина Тогда
						ЭтоВнереализационныеДоходыРасходы = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			
			Для Каждого Субконто Из Проводка.СубконтоДт Цикл
				Если ТипЗнч(Субконто.Значение) = ТипПрочиеДоходыИРасходы Тогда
					
					Если ПрочиеДоходыИРасходыВнереализационные = Неопределено Тогда
						ПрочиеДоходыИРасходыВнереализационные = ПолучитьПрочиеДоходыИРасходыВнереализационные();
					КонецЕсли;
					Если ПрочиеДоходыИРасходыВнереализационные[Субконто.Значение] = Истина Тогда
						ЭтоВнереализационныеДоходыРасходы = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЭтоВнереализационныеДоходыРасходы Тогда
			СчетЗабалансовогоУчета = СчетВнереализационныеРасходыНеУчитываемые;
		ИначеЕсли СчетРасчетыСПерсоналомПоОплатеТруда = Проводка.СчетДт
		 Или СчетРасчетыСПерсоналомПоОплатеТруда = Проводка.СчетКт Тогда
			СчетЗабалансовогоУчета = СчетВыплатыВпользуФизЛицПоП_1_48;
		Иначе
			СчетЗабалансовогоУчета = СчетДругиеВыплатыПоП_1_48;
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Организация = Проводка.Организация;
		НоваяПроводка.Период      = Проводка.Период;
		НоваяПроводка.Содержание  = Проводка.Содержание;
		НоваяПроводка.СчетДт      = СчетЗабалансовогоУчета;
		НоваяПроводка.СуммаНУДт   = СуммаНеУчитываемыхРасходов;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьСуммуЕслиЗаполнена(Сумма, КорректируемаяСумма = 0)
	
	// Если сумма не заполнена, то не будем ее менять, чтобы не спровоцировать перезапись фактически неизменного набора.
	// Если сумма заполнена, то ее обнулим за счет корректируемой суммы.
	// Например, это используется, когда важно очистить сумму НУ за счет суммы ПР.
	
	Если Не ЗначениеЗаполнено(Сумма) Тогда // Может быть NULL, если набор редактируется вручную
		Возврат;
	КонецЕсли;
	
	КорректируемаяСумма = КорректируемаяСумма + Сумма;
	
	Сумма = 0;
	
КонецПроцедуры

Функция ДанныеУчетнойПолитики(Организация, Период, Кэш = Неопределено)
	
	// У разных проводок набора период и организация могут быть разными.
	// При этом проводок может быть в наборе много, но у большинства из них период и организация одинаковые.
	// Для того, чтобы сократить время на получение сведений учетной политики для каждой строки набора,
	// организуем свой кэш с данными учетной политики.
	
	Если Кэш = Неопределено Тогда
		Кэш = Новый ТаблицаЗначений;
		Кэш.Колонки.Добавить("Организация", 				Новый ОписаниеТипов("СправочникСсылка.Организации"));
		Кэш.Колонки.Добавить("Период",      				Новый ОписаниеТипов("Дата"));
		Кэш.Колонки.Добавить("ПлательщикНалогаНаПрибыль",   Новый ОписаниеТипов("Булево"));
		Кэш.Колонки.Добавить("ПоддержкаПБУ18",              Новый ОписаниеТипов("Булево"));
		Кэш.Индексы.Добавить("Организация,Период");
	КонецЕсли;
	
	Поиск = Новый Структура;
	Поиск.Вставить("Организация", Организация);
	Поиск.Вставить("Период",      Период);
	
	РезультатПоиска = Кэш.НайтиСтроки(Поиск);
	Если РезультатПоиска.Количество() = 0 Тогда
		
		// Нет в кэше - добавим
		НоваяСтрока = Кэш.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Поиск);
		
		Если УчетнаяПолитика.Существует(Организация, Период) Тогда
			НоваяСтрока.ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Период);
			НоваяСтрока.ПоддержкаПБУ18 = УчетнаяПолитика.ПоддержкаПБУ18(Организация, Период);
		Иначе
			// Если нет учетной политики, то считаем, что все включено, 
			// для того, чтобы избежать потери данных, подготовленным прикладным кодом.
			// Это может быть полезно, например, при вводе начальных остатков.
			// В этом случае документ сам заботится о правильности интерпретации учетной политики.
			НоваяСтрока.ПлательщикНалогаНаПрибыль = Истина;
			НоваяСтрока.ПоддержкаПБУ18            = Истина;
		КонецЕсли;
		
		РезультатПоиска.Добавить(НоваяСтрока);
		
	КонецЕсли;
	
	Возврат РезультатПоиска[0];
	
КонецФункции

Функция ПолучитьПрочиеДоходыИРасходыВнереализационные()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеДоходыИРасходы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрочиеДоходыИРасходы КАК ПрочиеДоходыИРасходы
	|ГДЕ
	|	ПрочиеДоходыИРасходы.ВидПрочихДоходовИРасходов = ЗНАЧЕНИЕ(Перечисление.ВидыПрочихДоходовИРасходов.ПрочиеВнереализационныеДоходыРасходы)";

	Выборка = Запрос.Выполнить().Выбрать();
	
	ПрочиеДоходыИРасходыВнереализационные = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		ПрочиеДоходыИРасходыВнереализационные.Вставить(Выборка.Ссылка, Истина);
	КонецЦикла;

	Возврат ПрочиеДоходыИРасходыВнереализационные;
	
КонецФункции

Функция ПолучитьПрочиеДоходыИРасходыИсключения()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрочиеДоходыИРасходы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрочиеДоходыИРасходы КАК ПрочиеДоходыИРасходы
	|ГДЕ
	|	(ПрочиеДоходыИРасходы.ВидПрочихДоходовИРасходов = ЗНАЧЕНИЕ(Перечисление.ВидыПрочихДоходовИРасходов.КурсовыеРазницыПоРасчетамВУЕ)
	|			ИЛИ ПрочиеДоходыИРасходы.ВидПрочихДоходовИРасходов = ЗНАЧЕНИЕ(Перечисление.ВидыПрочихДоходовИРасходов.НалогиИСборы)
	|			ИЛИ ПрочиеДоходыИРасходы.ВидПрочихДоходовИРасходов = ЗНАЧЕНИЕ(Перечисление.ВидыПрочихДоходовИРасходов.РасходыПоПередачеТоваровБезвозмездноИДляСобственныхНужд))";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПрочиеДоходыИРасходыИсключения = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		ПрочиеДоходыИРасходыИсключения.Вставить(Выборка.Ссылка, Истина);
	КонецЦикла;
	
	Возврат ПрочиеДоходыИРасходыИсключения;
	
КонецФункции

// Раздельный учет НДС

Процедура ОчиститьСубконтоСпособУчетаНДС(Проводки, Регистратор)
	
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ВводНачальныхОстатков") 
	 ИЛИ ТипЗнч(Регистратор) = Тип("ДокументСсылка.ОперацияБух") Тогда 
		Возврат;  
	КонецЕсли;
	
	ПустойСпособУчетаНДС = Перечисления.СпособыУчетаНДС.ПустаяСсылка();
	ВидСубконтоСпособыУчетаНДС = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СпособыУчетаНДС;
	
	КэшУчетнойПолитики = Неопределено;
	
	Для Каждого Проводка Из Проводки Цикл
		
		РаздельныйУчетНДСНаСчете19 = ДанныеУчетнойПолитикиРаздельныйУчетНДСНаСчете19(
			Проводка.Организация, Проводка.Период, КэшУчетнойПолитики);
			
		Если РаздельныйУчетНДСНаСчете19 Тогда
			Продолжить;
		КонецЕсли;
			
		Для Каждого Субконто Из Проводка.СубконтоДт Цикл
			
			Если ВидСубконтоСпособыУчетаНДС = Субконто.Ключ
			   И ЗначениеЗаполнено(Субконто.Значение) Тогда
				Проводка.СубконтоДт.Вставить(Субконто.Ключ, ПустойСпособУчетаНДС);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого Субконто Из Проводка.СубконтоКт Цикл
			
			Если ВидСубконтоСпособыУчетаНДС = Субконто.Ключ
			   И ЗначениеЗаполнено(Субконто.Значение) Тогда
				Проводка.СубконтоКт.Вставить(Субконто.Ключ, ПустойСпособУчетаНДС);
			КонецЕсли;
			
		КонецЦикла;
				
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеУчетнойПолитикиРаздельныйУчетНДСНаСчете19(Организация, Период, Кэш = Неопределено)
	
	Если Кэш = Неопределено Тогда
		Кэш = Новый ТаблицаЗначений;
		Кэш.Колонки.Добавить("Организация", 				Новый ОписаниеТипов("СправочникСсылка.Организации"));
		Кэш.Колонки.Добавить("Период",      				Новый ОписаниеТипов("Дата"));
		Кэш.Колонки.Добавить("РаздельныйУчетНДСНаСчете19",	Новый ОписаниеТипов("Булево"));
		Кэш.Индексы.Добавить("Организация,Период");
	КонецЕсли;
	
	Поиск = Новый Структура;
	Поиск.Вставить("Организация", Организация);
	Поиск.Вставить("Период",      Период);
	
	РезультатПоиска = Кэш.НайтиСтроки(Поиск);
	Если РезультатПоиска.Количество() = 0 Тогда
		
		НоваяСтрока = Кэш.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Поиск);
		
		Если УчетнаяПолитика.Существует(Организация, Период) Тогда
			НоваяСтрока.РаздельныйУчетНДСНаСчете19 = УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Период);
		Иначе
			НоваяСтрока.РаздельныйУчетНДСНаСчете19 = Ложь;
		КонецЕсли;
		
		РезультатПоиска.Добавить(НоваяСтрока);
		
	КонецЕсли;
	
	Возврат РезультатПоиска[0].РаздельныйУчетНДСНаСчете19;
	
КонецФункции
	
#КонецЕсли