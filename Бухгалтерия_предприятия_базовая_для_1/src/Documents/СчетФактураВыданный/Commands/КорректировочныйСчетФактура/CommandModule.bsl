&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытияДокумента = УчетНДСКлиент.ПараметрыКорректировкиСчетаФактурыВыданного(ПараметрКоманды);
	
	ОткрытьФорму("Документ."+ПараметрыОткрытияДокумента.ИмяДокумента+".ФормаОбъекта", ПараметрыОткрытияДокумента.ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
