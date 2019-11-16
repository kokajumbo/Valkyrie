#Область СлужебныйПрограммныйИнтерфейс

// Начинает загрузку данных из формы, отображающей эти данные.
//
// Параметры:
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, в контексте которой может быть выполнено фоновое задание
// 
// Возвращаемое значение:
//  Структура - см. НовыйРезультатНачалаЗагрузки() - информация для дальнейших действий формы
//
Функция НачатьЗагрузку(ИдентификаторФормы) Экспорт
	
	Настройка = Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ИспользуемаяНастройкаSmartway();
	Если Не ЗначениеЗаполнено(Настройка) Тогда
		Возврат НовыйРезультатНачалаЗагрузки("ЗагрузкаНевозможна");
	КонецЕсли;
	
	// Возможно, загрузка данных была недавно инициирована
	// Отложим повторную попытку
	ИнтервалСледующейЗагрузки = ОбменДаннымиСВнешнимиСистемамиБПКлиентСервер.ИнтервалОперативнойЗагрузкиДанных() 
		- Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.АктуальностьДанных(Настройка);
	Если ИнтервалСледующейЗагрузки > 0 Тогда
		Результат = НовыйРезультатНачалаЗагрузки("НачатьПозже");
		Результат.Интервал = ИнтервалСледующейЗагрузки;
		Возврат Результат;
	КонецЕсли;
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Оперативная загрузка данных внешней системы'");
	ПараметрыВыполненияВФоне.КлючФоновогоЗадания         = Настройка;
	ПараметрыВыполненияВФоне.ОжидатьЗавершение           = 0;
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("Настройка", Настройка);
	
	Результат = НовыйРезультатНачалаЗагрузки("ДлительнаяОперация");
	Результат.ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагрузитьВФоне",
		ПараметрыМетода,
		ПараметрыВыполненияВФоне);
		
	Возврат Результат;
	
КонецФункции

Функция НовыйРезультатНачалаЗагрузки(КодРезультата)
	
	РезультатНачалаЗагрузки = Новый Структура;
	РезультатНачалаЗагрузки.Вставить("КодРезультата", КодРезультата); // "ЗагрузкаНевозможна", "НачатьПозже", "ДлительнаяОперация"
	Если КодРезультата = "НачатьПозже" Тогда
		РезультатНачалаЗагрузки.Вставить("Интервал", 0);
	ИначеЕсли КодРезультата = "ДлительнаяОперация" Тогда
		РезультатНачалаЗагрузки.Вставить("ДлительнаяОперация"); // Результат ДлительныеОперации.ВыполнитьВФоне
	КонецЕсли;
	
	Возврат РезультатНачалаЗагрузки;
	
КонецФункции

// Обработчик регламентного задания (в сервисе - задания очереди)
//
Процедура ЗагрузитьПоРасписанию() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗагрузкаДанныхВнешнихСистем);
	
	Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагрузитьПоРасписанию();
	
КонецПроцедуры

#КонецОбласти
