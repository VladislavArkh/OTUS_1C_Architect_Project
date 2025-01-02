﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в формах списков которых
// будет выведена команда группового изменения выделенных объектов.
// см. ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные
// 
// Параметры:
//  Объекты - Массив из ОбъектМетаданных
//
// Пример:
//	Объекты.Добавить(Метаданные.Справочники.Номенклатура);
//	Объекты.Добавить(Метаданные.Справочники.Контрагенты);
//
Процедура ПриОпределенииОбъектовСКомандойГрупповогоИзмененияОбъектов(Объекты) Экспорт

	

КонецПроцедуры

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие из КлючИЗначение - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указано "*", значит, в модуле менеджера определены обе функции.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "*"); // определены обе функции.
//   Объекты.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
//   Объекты.Вставить(Метаданные.Справочники.Партнеры.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке
//		|РеквизитыНеРедактируемыеВГрупповойОбработке");
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	
	
КонецПроцедуры

// Определяет реквизиты объекта, которые разрешается редактировать с помощью обработки группового изменения реквизитов.
// По умолчанию все реквизиты объекта разрешено редактировать. Для ограничения списка реквизитов необходимо заполнить
// одну из коллекций РедактируемыеРеквизиты и НередактируемыеРеквизиты. Если заполнены обе коллекции, то для разрешения
// неоднозначности приоритет отдается в пользу коллекции НередактируемыеРеквизиты.
// 
// Параметры:
//  Объект - ОбъектМетаданных - объект, для которого устанавливается список редактируемых реквизитов.
//  РедактируемыеРеквизиты - Неопределено, Массив из Строка - имена редактируемых групповой обработкой реквизитов объекта.
//                                                            Значение игнорируется, если заполнен параметр НередактируемыеРеквизиты.
//  НередактируемыеРеквизиты - Неопределено, Массив из Строка - имена не редактируемых групповой обработкой реквизитов объекта.
// 
Процедура ПриОпределенииРедактируемыхРеквизитовОбъекта(Объект, РедактируемыеРеквизиты, НередактируемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти
