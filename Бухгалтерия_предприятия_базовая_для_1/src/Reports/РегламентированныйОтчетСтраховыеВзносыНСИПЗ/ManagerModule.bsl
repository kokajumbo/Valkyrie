#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение N 1 к Постановлению Фонда социального страхования Российской Федерации от 15.10.2008 N 209.";
	НоваяФорма.РедакцияФормы      = "от 15.10.2008 N 209.";
	НоваяФорма.ДатаНачалоДействия = '2008-10-01';
	НоваяФорма.ДатаКонецДействия  = '2012-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к письму Фонда социального страхования РФ от 02.06.2014 № 17-03-18/05-7094.";
	НоваяФорма.РедакцияФормы      = "от 02.06.2014 № 17-03-18/05-7094.";
	НоваяФорма.ДатаНачалоДействия = '2014-01-01';
	НоваяФорма.ДатаКонецДействия  = '2015-06-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв3";
	НоваяФорма.ОписаниеОтчета     = "Приложение 2 к письму ФСС РФ от 02.07.2015 № 02-09-11/16-10779.";
	НоваяФорма.РедакцияФормы      = "от 02.07.2015 № 02-09-11/16-10779.";
	НоваяФорма.ДатаНачалоДействия = '2015-07-01';
	НоваяФорма.ДатаКонецДействия  = '2016-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение 1 к письму ФСС РФ от 20.02.2017 № 02-09-11/16-05-3685.";
	НоваяФорма.РедакцияФормы      = "от 02.07.15 № 02-09-11/16-10779.";
	НоваяФорма.ДатаНачалоДействия = '2017-01-01';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к письму Фонда социального страхования РФ от 25.01.2013 № 15-03-11/07-859";
	НоваяФорма.РедакцияФормы      = "от 25.01.2013 № 15-03-11/07-859.";
	НоваяФорма.ДатаНачалоДействия = '2013-01-01';
	НоваяФорма.ДатаКонецДействия  = '2014-03-31';
    
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	ФормаОтчета2008Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159990", '2008-10-15', "209",                 "ФормаОтчета2008Кв4");
	ФормаОтчета2013Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159990", '2013-01-25', "15-03-11/07-859",     "ФормаОтчета2013Кв1");
	ФормаОтчета2014Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159990", '2014-06-02', "17-03-18/05-7094",    "ФормаОтчета2014Кв1");
	ФормаОтчета2015Кв3 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159990", '2015-07-02', "02-09-11/16-10779",   "ФормаОтчета2015Кв3");
	ФормаОтчета2017Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1159990", '2017-02-20', "02-09-11/16-05-3685", "ФормаОтчета2017Кв1");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли