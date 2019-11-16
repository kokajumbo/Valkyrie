
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаВарианты.ТолькоПросмотр = 
		НЕ ПравоДоступа("Изменение", Метаданные.Константы.ПодготовитьДанныеКПередачеВОФД);
		
	ПодготовитьДанныеКПередачеВОФД = ?(Константы.ПодготовитьДанныеКПередачеВОФД.Получить(), 1, 0);
КонецПроцедуры
#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ОтображениеКартинкиВариантПечатиЧека",Новый Структура("ИмяКартинки", "ВариантПечатиЧекаПолный"),ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ОтображениеКартинкиВариантПечатиЧека",Новый Структура("ИмяКартинки", "ВариантПечатиЧекаТолькоОплата"),ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЧековВариант1ПриИзменении(Элемент)
	УстановитьЗначениеКонстанты(ПодготовитьДанныеКПередачеВОФД);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЧековВариант2ПриИзменении(Элемент)
	УстановитьЗначениеКонстанты(ПодготовитьДанныеКПередачеВОФД);
КонецПроцедуры
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
&НаСервереБезКонтекста
Процедура УстановитьЗначениеКонстанты(ПодготовитьДанныеКПередачеВОФД)

	Константы.ПодготовитьДанныеКПередачеВОФД.Установить(ПодготовитьДанныеКПередачеВОФД);

КонецПроцедуры 
#КонецОбласти 




