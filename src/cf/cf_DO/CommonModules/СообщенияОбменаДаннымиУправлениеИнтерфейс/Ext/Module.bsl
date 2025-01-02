﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Manage/3.0.1.1";
	
КонецФункции

// Текущая (используемая вызывающим кодом) версия интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - версия интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "3.0.1.1";
	
КонецФункции

// Название программного интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - название программного интерфейса сообщений.
//
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ExchangeManage";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//   МассивОбработчиков - Массив из ОбщийМодуль - коллекция модулей, содержащих обработчики.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияОбменаДаннымиУправлениеОбработчикСообщения_2_1_2_1);
	МассивОбработчиков.Добавить(СообщенияОбменаДаннымиУправлениеОбработчикСообщения_3_0_1_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//   МассивОбработчиков - Массив из ОбщийМодуль - коллекция модулей, содержащих обработчики.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияОбменаДаннымиУправлениеОбработчикТрансляции_2_1_2_1);
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}SetupExchangeStep1
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеНастроитьОбменШаг1(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep1");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}SetupExchangeStep2
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеНастроитьОбменШаг2(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep2");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}DownloadMessage
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеЗагрузитьСообщениеОбмена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DownloadMessage");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}GetData
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеПолучитьДанныеКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetData");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}GetCommonNodsData
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеПолучитьОбщиеДанныеУзловКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetCommonNodsData");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}GetCorrespondentParams
//
// Параметры:
//   ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//                                получается тип сообщения.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - тип объекта сообщения.
//
Функция СообщениеПолучитьПараметрыУчетаКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetCorrespondentParams");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
