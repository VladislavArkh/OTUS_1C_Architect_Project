﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СертификатыЭлектроннойПодписи");
	НастройкиВарианта.Описание = НСтр("ru = 'Сертификаты электронной подписи действующие в этом году.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЗаканчиваетсяСрокДействия");
	НастройкиВарианта.Описание = НСтр("ru = 'Сертификаты, у которых заканчивается срок действия.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТребуетсяВыпускСертификатаФЛ");
	НастройкиВарианта.Описание = НСтр("ru = 'Сертификаты сотрудников, выпущенные коммерческими УЦ, которым требуется выпуск сертификата физического лица.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СертификатыСотрудников");
	НастройкиВарианта.Описание = НСтр("ru = 'Сертификаты сотрудников.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТребуетсяМЧД");
	НастройкиВарианта.Описание = НСтр("ru = 'Сертификаты, для которых требуется МЧД.'");
		
КонецПроцедуры

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Если КлючВарианта = "ТребуетсяМЧД" ИЛИ КлючВарианта = "ЗаканчиваетсяСрокДействия" Тогда
		Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	КонецЕсли;
	Настройки.ФормироватьСразу = Истина;
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.ОпределитьОбъектыСКомандамиОтчетов.
Процедура ПриОпределенииОбъектовСКомандамиОтчетов(Объекты) Экспорт
	
	Объекты.Добавить(Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет настройки интеграции отчета с механизмами конфигурации. 
//
// Параметры:
//  НастройкиПрограммногоИнтерфейса - см. ПодключаемыеКоманды.НастройкиПодключаемогоОбъекта
//
Процедура ПриОпределенииНастроек(НастройкиПрограммногоИнтерфейса) Экспорт
	
	НастройкиПрограммногоИнтерфейса.НастроитьВариантыОтчета = Истина;
	НастройкиПрограммногоИнтерфейса.ОпределитьНастройкиФормы = Истина;
	НастройкиПрограммногоИнтерфейса.ДобавитьКомандыОтчетов = Истина;
	НастройкиПрограммногоИнтерфейса.Размещение.Добавить(Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#КонецЕсли