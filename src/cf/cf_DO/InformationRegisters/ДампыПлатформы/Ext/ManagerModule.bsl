﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДампыДляУдаления() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДампыПлатформы.ДатаРегистрации,
		|	ДампыПлатформы.ВариантДампа,
		|	ДампыПлатформы.ВерсияПлатформы,
		|	ДампыПлатформы.ИмяФайла
		|ИЗ
		|	РегистрСведений.ДампыПлатформы КАК ДампыПлатформы
		|ГДЕ
		|	ДампыПлатформы.ИмяФайла <> &ИмяФайла";
	
	Запрос.УстановитьПараметр("ИмяФайла", "");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДампыДляУдаления = Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДампДляУдаления = Новый Структура;
		ДампДляУдаления.Вставить("ДатаРегистрации", ВыборкаДетальныеЗаписи.ДатаРегистрации);
		ДампДляУдаления.Вставить("ВариантДампа", ВыборкаДетальныеЗаписи.ВариантДампа);
		ДампДляУдаления.Вставить("ВерсияПлатформы", ВыборкаДетальныеЗаписи.ВерсияПлатформы);
		ДампДляУдаления.Вставить("ИмяФайла", ВыборкаДетальныеЗаписи.ИмяФайла);
		
		ДампыДляУдаления.Добавить(ДампДляУдаления);
	КонецЦикла;

	Возврат ДампыДляУдаления;
КонецФункции

Процедура ИзменитьЗапись(Запись) Экспорт
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ДатаРегистрации = Запись.ДатаРегистрации;
	МенеджерЗаписи.ВариантДампа = Запись.ВариантДампа;
	МенеджерЗаписи.ВерсияПлатформы = Запись.ВерсияПлатформы;
	МенеджерЗаписи.ИмяФайла = Запись.ИмяФайла;
	МенеджерЗаписи.Записать();
КонецПроцедуры

Функция ПолучитьЗарегистрированныеДампы(Дампы) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДампыПлатформы.ИмяФайла
		|ИЗ
		|	РегистрСведений.ДампыПлатформы КАК ДампыПлатформы
		|ГДЕ
		|	ДампыПлатформы.ИмяФайла В(&Дампы)";
	
	Запрос.УстановитьПараметр("Дампы", Дампы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДампыЕсть = Новый Соответствие;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДампыЕсть.Вставить(ВыборкаДетальныеЗаписи.ИмяФайла, Истина);
	КонецЦикла;
	
	Возврат ДампыЕсть;
КонецФункции

Функция ПолучитьТопВариантов(ДатаНачала, ДатаОкончания, Количество, Знач ВерсияПлатформы = Неопределено, ПереименовыватьКолонки = Ложь) Экспорт
	ДатаНачалаМС = (ДатаНачала - Дата(1,1,1)) * 1000;
	ДатаОкончанияМС = (ДатаОкончания - Дата(1,1,1)) * 1000;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ВариантДампа,
		|	КоличествоВариантов
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДампыПлатформы.ВариантДампа КАК ВариантДампа,
		|		КОЛИЧЕСТВО(1) КАК КоличествоВариантов
		|	ИЗ
		|		РегистрСведений.ДампыПлатформы КАК ДампыПлатформы
		|	ГДЕ
		|		ДампыПлатформы.ДатаРегистрации МЕЖДУ &ДатаНачалаМС И &ДатаОкончанияМС
		|		И &УслВерсияПлатформы
		|	СГРУППИРОВАТЬ ПО
		|		ДампыПлатформы.ВариантДампа
		|	) КАК Выборка
		|УПОРЯДОЧИТЬ ПО
		|	КоличествоВариантов УБЫВ
		|";
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "1000", Формат(Количество, "ЧГ=0"));
	Запрос.УстановитьПараметр("ДатаНачалаМС", ДатаНачалаМС);
	Запрос.УстановитьПараметр("ДатаОкончанияМС", ДатаОкончанияМС);
	Если ВерсияПлатформы <> Неопределено Тогда
		ВерсияПлатформыЧисло = ЦентрМониторингаСлужебный.ВерсияПлатформыВЧисло(ВерсияПлатформы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УслВерсияПлатформы", "ДампыПлатформы.ВерсияПлатформы = &ВерсияПлатформы");
		Запрос.УстановитьПараметр("ВерсияПлатформы", ВерсияПлатформыЧисло);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УслВерсияПлатформы", "ИСТИНА");
	КонецЕсли;
	ТаблицаДампов = Запрос.Выполнить().Выгрузить();
	Если ПереименовыватьКолонки Тогда	
		ТаблицаДампов.Колонки[0].Имя = "dumpVariant";
		ТаблицаДампов.Колонки[1].Имя = "quantity";
	КонецЕсли;                                     
	Возврат ТаблицаДампов;
КонецФункции

#КонецОбласти

#КонецЕсли