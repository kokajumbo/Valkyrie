
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДопустымыеВидыРасходовНУ = Новый ФиксированныйМассив(РегистрыСведений.МетодыОпределенияПрямыхРасходовПроизводстваВНУ.ДопустимыеВидыРасходовНУ());
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДопустымыеВидыРасходовНУ));
	
	СписокВыбора = Элементы.ВидРасходовНУ.СписокВыбора;
	СписокВыбора.Очистить();
	Для Каждого ВидРасходовНУ Из ДопустымыеВидыРасходовНУ Цикл
		СписокВыбора.Добавить(ВидРасходовНУ);
	КонецЦикла;
	
КонецПроцедуры
