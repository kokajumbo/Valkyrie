#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
    	Возврат;
    КонецЕсли;
	
	ИспользоватьДокументыПоступленияИП = Значение
		И Константы.ИспользоватьДокументыПоступления.Получить();
	Константы.ИспользоватьДокументыПоступленияИП.Установить(ИспользоватьДокументыПоступленияИП);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
