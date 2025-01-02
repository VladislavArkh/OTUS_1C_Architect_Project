﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеПодтверждения	= Параметры.ДанныеПодтверждения;
	
	Элементы.ДекорацияОписание.Заголовок = Параметры.ОписаниеОшибки;
	Элементы.Повторить.Видимость = Параметры.РежимПовторения;
	
	УстановитьКартинку("ДиалогСтоп");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Повторить(Команда)
	
	ПовторитьОтправку(ДанныеПодтверждения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ТекущееПодтверждение - см. СервисКриптографииDSSПодтверждениеСервер.ДанныеВторичнойАвторизацииПоУмолчанию 
//	
&НаКлиенте
Процедура ПовторитьОтправку(ТекущееПодтверждение)
	
	ТекущееПодтверждение.ЭтапЦикла = "Начало";
	
	ПараметрыЗакрытия = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Истина);
	ТекущееПодтверждение.Идентификатор = ТекущееПодтверждение.ИдентификаторТранзакции;
	ПараметрыЗакрытия.Вставить("ДанныеПодтверждения", ТекущееПодтверждение);
	
	ЗакрытьФорму(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрыЗакрытия = Неопределено)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыЗакрытия = Неопределено Тогда
		ПараметрыЗакрытия = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь, "ОтказПользователя");
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинку(ИмяКартинки)
	
	НашлиКартинку = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы(ИмяКартинки);
	
	Если НашлиКартинку.Вид <> ВидКартинки.Пустая Тогда
		Элементы.ДекорацияОшибка.Картинка = НашлиКартинку;
	Иначе
		Элементы.ДекорацияОшибка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
