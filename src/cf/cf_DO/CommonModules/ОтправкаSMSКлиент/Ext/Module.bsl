﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму для отправки нового SMS.
//
// Параметры:
//  НомераПолучателей - Массив из Структура:
//   * Телефон - Строка - номер получателя в формате +<КодСтраны><КодDEF><номер>;
//   * Представление - Строка - представление номера телефона;
//   * ИсточникКонтактнойИнформации - СправочникСсылка - владелец номера телефона.
//  
//  Текст - Строка - текст сообщения, длиной не более 1000 символов.
//  
//  ДополнительныеПараметры - Структура - дополнительные параметры отправки SMS:
//   * ИмяОтправителя - Строка - имя отправителя, которое будет отображаться вместо номера у получателей;
//   * ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
//
Процедура ОтправитьSMS(НомераПолучателей, Текст, ДополнительныеПараметры) Экспорт
	
	СтандартнаяОбработка = Истина;
	ОтправкаSMSКлиентПереопределяемый.ПриОтправкеSMS(НомераПолучателей, Текст, ДополнительныеПараметры, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		
		ПараметрыОтправки = ПараметрыОтправки();
		ПараметрыОтправки.НомераПолучателей = НомераПолучателей;
		ПараметрыОтправки.Текст             = Текст;
		
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОтправки, ДополнительныеПараметры);
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьНовоеSMSПроверкаНастроекВыполнена", ЭтотОбъект, ПараметрыОтправки);
		ПроверитьНаличиеНастроекДляОтправкиSMS(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму настроек отправки SMS.
// 
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - процедура, которую нужно выполнить после закрытия формы настроек.
//
Процедура ОткрытьФормуНастроек(ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS", , , , , , ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Если у пользователя нет настроек для отправки SMS, то в зависимости от прав либо показывает
// форму настройки SMS, либо выводит сообщение о невозможности отправки.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения - процедура, в которую необходимо передать выполнение кода после проверки.
//
Процедура ПроверитьНаличиеНастроекДляОтправкиSMS(ОбработчикРезультата)
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	Если ПараметрыРаботыКлиента.ДоступнаОтправкаSMS Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	Иначе
		Если ПользователиКлиент.ЭтоПолноправныйПользователь() Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНастройкиSMS", ЭтотОбъект, ОбработчикРезультата);
			ОткрытьФормуНастроек(ОписаниеОповещения);
		Иначе
			ТекстСообщения = НСтр("ru = 'Для отправки SMS требуется произвести настройку параметров подключения
				|Обратитесь к администратору.'");
			ПоказатьПредупреждение(, ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеНастройкиSMS(Результат, ОбработчикРезультата) Экспорт
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	Если ПараметрыРаботыКлиента.ДоступнаОтправкаSMS Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	КонецЕсли;
КонецПроцедуры

// Продолжение процедуры ОтправитьSMS.
Процедура СоздатьНовоеSMSПроверкаНастроекВыполнена(ОтправкаSMSНастроена, ПараметрыОтправки) Экспорт
	
	Если Не ОтправкаSMSНастроена Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия")
		И ПараметрыРаботыКлиента.ИспользоватьПрочиеВзаимодействия Тогда
		
		МодульВзаимодействияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВзаимодействияКлиент");
		ПараметрыФормы = МодульВзаимодействияКлиент.ПараметрыФормыОтправкиSMS();
		ПараметрыФормы.Адресаты = ПараметрыОтправки.НомераПолучателей;
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыОтправки);
		МодульВзаимодействияКлиент.ОткрытьФормуОтправкиSMS(ПараметрыФормы);
	Иначе
		ОткрытьФорму("ОбщаяФорма.ОтправкаSMS", ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//  Структура - дополнительные параметры отправки SMS:
//   * ИмяОтправителя - Строка - имя отправителя, которое будет отображаться вместо номера у получателей;
//   * ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой;
//   * Предмет - ЛюбаяСсылка - предмет, с которым связана отправка SMS.
//
Функция ПараметрыОтправки()
	
	Результат = Новый Структура;
	Результат.Вставить("НомераПолучателей", "");
	Результат.Вставить("Текст", "");
	Результат.Вставить("ИмяОтправителя", "");
	Результат.Вставить("ПеревестиВТранслит", Ложь);
	Результат.Вставить("Предмет", Неопределено);
	
	Возврат Результат;
	
КонецФункции















#КонецОбласти