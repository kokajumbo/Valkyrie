
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытияДокумента = УчетНДСКлиент.ПараметрыКорректировочнойСправки(ПараметрКоманды);
	
	ОткрытьФорму("Документ."+ПараметрыОткрытияДокумента.ИмяДокумента+".ФормаОбъекта", ПараметрыОткрытияДокумента.ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
