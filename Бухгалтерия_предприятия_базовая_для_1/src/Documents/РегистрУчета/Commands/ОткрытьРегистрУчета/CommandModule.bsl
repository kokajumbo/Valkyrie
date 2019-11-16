
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СвойстваФайла = ПолучитьСвойстваПрисоединенногоФайла(ПараметрКоманды);
	
	Если НЕ СвойстваФайла.ФайлРегистраУчетаПрисоединен Тогда
		
		СообщениеОбОшибке = СтрШаблон(НСтр("ru='%1 не содержит присоединенного файла'"), СвойстваФайла.РегистрУчета);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваФайла.РегистрУчета);
		
		Возврат;
		
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОткрытьФайл(СвойстваФайла.ДанныеФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСвойстваПрисоединенногоФайла(ДокументРегистр)
	
	Возврат Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(ДокументРегистр, Истина);
	
КонецФункции

#КонецОбласти
