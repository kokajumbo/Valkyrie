#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ИмяФормыПлатежногоДокумента(СпособОплаты) Экспорт
	
	Если СпособОплаты = Перечисления.СпособыУплатыНалогов.БанковскийПеревод Тогда
		
		Возврат "Документ.ПлатежноеПоручение.Форма.ФормаДокументаНалоговая";
		
	ИначеЕсли СпособОплаты = Перечисления.СпособыУплатыНалогов.НаличнымиПоКвитанции Тогда
		
		Возврат "Документ.РасходныйКассовыйОрдер.ФормаОбъекта";
		
	КонецЕсли;
	
КонецФункции

#КонецЕсли
