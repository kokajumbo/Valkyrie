
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия30.ПолучитьМакет("ПодробнаяИнформацияПоОбмену");
	
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru = 'Информация о синхронизации данных с Управление нашей фирмой, редакция 1'");
	
КонецПроцедуры
