#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ОбновитьЭлементСправочника("ЗП80ПД",	"Педагогическая деятельность в школах и других учреждениях для детей всех педагогических работников");
	ОбновитьЭлементСправочника("ЗП80РК",	"Педагогическая деятельность в школах и других учреждениях для детей в качестве директоров");
	ОбновитьЭлементСправочника("ЗП81ГД",	"Лечебная и иная работа по охране здоровья населения в городах");
	ОбновитьЭлементСправочника("ЗП81СМ",	"Лечебная и иная работа по охране здоровья населения в сельской местности");
	ОбновитьЭлементСправочника("ИНСПЕКТ",	"Работники, проводящие инспектирование летного состава в испытательных полетах");
	ОбновитьЭлементСправочника("ИСПКЛС1",	"Работа в качестве летчика-испытателя 1 класса");
	ОбновитьЭлементСправочника("ИТС",		"Работа в инженерно-техническом составе по обслуживанию воздушных судов");
	ОбновитьЭлементСправочника("ИТСИСП",	"Инженерно–технический состав, совершающий полеты по испытаниям");
	ОбновитьЭлементСправочника("ИТСМАВ",	"Инженерно–технический состав, совершающий полеты по испытаниям на воздушных судах маневренной авиаци");
	ОбновитьЭлементСправочника("ЛЕТИСП",	"Летно-испытательный состав");
	ОбновитьЭлементСправочника("НОРМАПР",	"Парашютисты, выполнившие годовую норму прыжков с поршневых самолетов");
	ОбновитьЭлементСправочника("НОРМСП",	"Парашютисты, выполнившие годовую норму спусков (подъемов) с поршневых самолетов");
	ОбновитьЭлементСправочника("ОПЫТИСП",	"Работа в качестве летчика (пилота)-испытателя, штурмана-испытателя и парашютиста-испытателя");
	ОбновитьЭлементСправочника("РЕАКТИВН",	"Парашютисты, выполнившие годовую норму прыжков с реактивных самолетов и вертолетов");
	ОбновитьЭлементСправочника("САМОЛЕТ",	"Работа в летном составе на самолетах гражданской авиации");
	ОбновитьЭлементСправочника("СПЕЦАВ",	"Работа в летном составе на вертолетах, в авиации специального применения");
	ОбновитьЭлементСправочника("УВД",		"Работа по управлению воздушным движением");
	ОбновитьЭлементСправочника("ХИРУРГД",	"Связанная с хирургией лечебная работа в городах");
	ОбновитьЭлементСправочника("ХИРУРСМ",	"Связанная с хирургией лечебная работа в сельской местности");

КонецПроцедуры

Процедура ОбновитьЭлементСправочника(ИмяПредопределенныхДанных, Наименование)
	
	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ОснованияДосрочногоНазначенияПенсииДляСЗВК." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Элемент = Справочники.ОснованияДосрочногоНазначенияПенсииДляСЗВК.СоздатьЭлемент();
		Элемент.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;
	
	Элемент.Код = ИмяПредопределенныхДанных;
	Элемент.Наименование = Наименование;
	
	Элемент.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	Элемент.ОбменДанными.Загрузка = Истина;
	Элемент.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли

