﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("УзелОбмена", УзелОбмена);
	
	// Получение текущего этапа
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Настройки.ПереходНаWS_Этап КАК ПереходНаWS_Этап,
		|	Настройки.ПереходНаWS_ОбластьДанных КАК ОбластьДанных,
		|	Настройки.ПереходНаWS_КонечнаяТочка КАК КонечнаяТочка,
		|	Настройки.ПереходНаWS_КонечнаяТочкаКорреспондента КАК КонечнаяТочкаКорреспондента
		|ИЗ
		|	РегистрСведений.ОбщиеНастройкиУзловИнформационныхБаз КАК Настройки
		|ГДЕ
		|	Настройки.УзелИнформационнойБазы = &УзелИнформационнойБазы";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ТекущийЭтап = Выборка.ПереходНаWS_Этап + 1;
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка, "ОбластьДанных,КонечнаяТочка,КонечнаяТочкаКорреспондента");
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Устанавливаем текущую таблицу переходов.
	ТаблицаПереходовПоСценарию();
	
	// Позиционируемся на первом шаге помощника.
	УстановитьПорядковыйНомерПерехода(1);
	
	ЗаполнитьТаблицуЭтаповПерехода();
	
	ОбновитьОтображениеЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Закрыть помощник?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы
		И ТекущийЭтап > 0 Тогда
		
		Оповестить("ЗакрытаФормаПомощникаПереходаНаИнтернетСоединение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельДекорации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода + 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаПерехода_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Если ТекущийЭтап = 1 Тогда
		ПриНачалеПолученияСпискаПриложений();
	ИначеЕсли ТекущийЭтап = 2 Тогда
		ПриНачалеОтключенияОтМС();
	ИначеЕсли ТекущийЭтап = 3 Тогда
		ПриНачалеНастройкиУзлаКорреспондента();
	ИначеЕсли ТекущийЭтап = 4 Тогда
		ПриНачалеНастройкиУзла();
	КонецЕсли;
	
КонецФункции

#Область ПолучениеНастроек

&НаКлиенте
Процедура ПриНачалеПолученияСпискаПриложений()
	
	ПараметрыОбработчика = Неопределено;
	ПродолжитьОжидание = Ложь;
	
	ПриНачалеПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание, УзелОбмена, ОбластьДанных);
		
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			
		ПодключитьОбработчикОжидания("ПриОжиданииПолученияСпискаПриложений",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	
	Иначе
		ПриЗавершенииПолученияСпискаПриложений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииПолученияСпискаПриложений()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		ПодключитьОбработчикОжидания("ПриОжиданииПолученияСпискаПриложений",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжидания = Неопределено;
		ПриЗавершенииПолученияСпискаПриложений();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	МодульПомощникНастройки.ПриОжиданииПолученияСпискаПриложений(
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриНачалеПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание, Узел, ОбластьДанных)
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПомощника = Новый Структура("Режим", "НастроенныеОбмены");
	
	МодульПомощникНастройки.ПриНачалеПолученияСпискаПриложений(ПараметрыПомощника,
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииПолученияСпискаПриложений()
	
	ПерейтиДалее = Истина;
	ПриЗавершенииПолученияСпискаПриложенийНаСервере(ПерейтиДалее);
	
	Если ПерейтиДалее Тогда
		ТекущийЭтап = ТекущийЭтап + 1;
		ОбновитьОтображениеЭтапов();
		ПриНачалеОтключенияОтМС();
	Иначе
		УстановитьПорядковыйНомерПерехода(1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииПолученияСпискаПриложенийНаСервере(ПерейтиДалее)
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		ПерейтиДалее = Ложь;
		Возврат;
	КонецЕсли;
	
	СтатусЗавершения = Неопределено;
	МодульПомощникНастройки.ПриЗавершенииПолученияСпискаПриложений(ПараметрыОбработчика, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		
		ОбщегоНазначения.СообщитьПользователю(СтатусЗавершения.СообщениеОбОшибке);
		ПерейтиДалее = Ложь;
		
	Иначе
		
		ТаблицаПриложений = СтатусЗавершения.Результат;
		СтрокаПриложение = ТаблицаПриложений.Найти(УзелОбмена, "Корреспондент");
		Если Не СтрокаПриложение = Неопределено Тогда
			
			КонечнаяТочка = СтрокаПриложение.КонечнаяТочка;
			ОбластьДанныхСтрока = XMLСтрока(СтрокаПриложение.ОбластьДанных);
			КонечнаяТочкаКорреспондента = СтрокаПриложение.КонечнаяТочкаКорреспондента;
			
			// Запись этапа
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("УзелИнформационнойБазы"					, УзелОбмена);
			СтруктураЗаписи.Вставить("ПереходНаWS_КонечнаяТочкаКорреспондента"	, КонечнаяТочкаКорреспондента);
			СтруктураЗаписи.Вставить("ПереходНаWS_ОбластьДанных"				, ОбластьДанныхСтрока);
			СтруктураЗаписи.Вставить("ПереходНаWS_КонечнаяТочка"				, КонечнаяТочка);
			СтруктураЗаписи.Вставить("ПереходНаWS_Этап"							, ТекущийЭтап);
			
			ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбщиеНастройкиУзловИнформационныхБаз");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОтключениеОтМС

&НаКлиенте
Процедура ПриНачалеОтключенияОтМС()
	
	ПродолжитьОжидание = Истина;
	
	ПриНачалеОтключенияОтМСНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыОбработчикаОжидания);
			
		ПодключитьОбработчикОжидания("ПриОжиданииОтключенияОтМС",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииОтключенияОтМС();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеОтключенияОтМСНаСервере(ПродолжитьОжидание)
	
	Настройки = Новый Структура;
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелОбмена);
			
	Настройки.Вставить("ИмяПланаОбмена",				ИмяПланаОбмена);
	Настройки.Вставить("ОбластьДанныхКорреспондента",	ОбластьДанных);
	
	МодульОтключенияОтМС = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
		
	Если МодульОтключенияОтМС = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	МодульОтключенияОтМС.ПриНачалеОтключенияОтМС(Настройки, ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииОтключенияОтМС()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииОтключенияОтМСНаСервере(ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		ПодключитьОбработчикОжидания("ПриОжиданииОтключенияОтМС",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжидания = Неопределено;  
		ПриЗавершенииОтключенияОтМС();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииОтключенияОтМС()
	
	СообщениеОбОшибке = "";
	ПерейтиДалее = Истина;
	
	ПриЗавершенииОтключенияОтМСНаСервере(ПерейтиДалее, СообщениеОбОшибке);
	
	Если ПерейтиДалее Тогда
		ТекущийЭтап = ТекущийЭтап + 1;
		ОбновитьОтображениеЭтапов();
		ПриНачалеНастройкиУзлаКорреспондента();
	Иначе
		УстановитьПорядковыйНомерПерехода(1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииОтключенияОтМСНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	МодульПомощникПерехода = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникПерехода = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ПродолжитьОжидание = Ложь;
	МодульПомощникПерехода.ПриОжиданииОтключенияОтМС(ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииОтключенияОтМСНаСервере(ПерейтиДалее, СообщениеОбОшибке)
	
	МодульПомощникПерехода = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникПерехода = Неопределено Тогда
		ПерейтиДалее = Ложь;
		Возврат;
	КонецЕсли;
	
	СтатусЗавершения = Неопределено;
	
	МодульПомощникПерехода.ПриЗавершенииОтключенияОтМС(ПараметрыОбработчика, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		
		ОбщегоНазначения.СообщитьПользователю(СтатусЗавершения.СообщениеОбОшибке);
		ПерейтиДалее = Ложь;
		
	Иначе
		
		ЗафиксироватьЭтапПерехода();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НастройкаУзлаКорреспондента

&НаКлиенте
Процедура ПриНачалеНастройкиУзлаКорреспондента()
	
	ДлительнаяОперация = ПриНачалеНастройкиУзлаКорреспондентаНаСервере();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершениеНастройкиКорреспондентаУзла", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания());
		
КонецПроцедуры

&НаСервере
Функция ПриНачалеНастройкиУзлаКорреспондентаНаСервере()
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(, 
		"Обработки.ПомощникСозданияОбменаДанными.ИзменитьТранспортУзлаКорреспондентаНаWS",
		УзелОбмена,
		КонечнаяТочка,
		КонечнаяТочкаКорреспондента,
		ОбластьДанных);
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеНастройкиКорреспондентаУзла(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
		
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		УстановитьПорядковыйНомерПерехода(1);
	Иначе	
		ТекущийЭтап = ТекущийЭтап + 1;
		ОбновитьОтображениеЭтапов();
		ЗафиксироватьЭтапПерехода();
		ПриНачалеНастройкиУзла();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НастройкаУзла

&НаКлиенте
Процедура ПриНачалеНастройкиУзла()
	
	ДлительнаяОперация = ПриНачалеНастройкиУзлаНаСервере();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершениеНастройкиУзла", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания());
		
КонецПроцедуры

&НаСервере
Функция ПриНачалеНастройкиУзлаНаСервере()
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(, 
		"Обработки.ПомощникСозданияОбменаДанными.ИзменитьТранспортУзлаНаWS",
		УзелОбмена,
		КонечнаяТочкаКорреспондента,
		ОбластьДанных);
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеНастройкиУзла(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
		
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		УстановитьПорядковыйНомерПерехода(1);
	Иначе	
		ТекущийЭтап = ТекущийЭтап + 1;
		ОбновитьОтображениеЭтапов();
		ОчиститьЭтапыПереходаВРегистре();
		ПодключитьОбработчикОжидания("ПослеЗавершенияВсехЭтапов",1,Истина); // Чтобы отобразился последний этап
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияВсехЭтапов()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗафиксироватьЭтапПерехода()
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы"		, УзелОбмена);
	СтруктураЗаписи.Вставить("ПереходНаWS_Этап"				, ТекущийЭтап);
	ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбщиеНастройкиУзловИнформационныхБаз");

КонецПроцедуры

&НаСервере
Процедура ОчиститьЭтапыПереходаВРегистре()
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы"					, УзелОбмена);
	СтруктураЗаписи.Вставить("ПереходНаWS_КонечнаяТочкаКорреспондента"	, Неопределено);
	СтруктураЗаписи.Вставить("ПереходНаWS_КонечнаяТочка"				, Неопределено);
	СтруктураЗаписи.Вставить("ПереходНаWS_ОбластьДанных"				, 0);
	СтруктураЗаписи.Вставить("ПереходНаWS_Этап"							, 0);			
	
	ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбщиеНастройкиУзловИнформационныхБаз");
				
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОжидания()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = "";
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Неопределено;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Ложь;
	Возврат ПараметрыОжидания;

КонецФункции

&НаКлиенте
Процедура ТаблицаПереходовПоСценарию()
	
	ТаблицаПереходов.Очистить();
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 1;
	Переход.ИмяОсновнойСтраницы	 	= "СтраницаНачало";
	Переход.ИмяСтраницыНавигации	= "СтраницаНавигацииНачало";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 2;
	Переход.ИмяОсновнойСтраницы	 	= "СтраницаПерехода";
	Переход.ИмяСтраницыНавигации	= "СтраницаНавигацииОжидание";
	Переход.ИмяОбработчикаПриОткрытии = "Подключаемый_СтраницаПерехода_ПриОткрытии";

	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 3;
	Переход.ИмяОсновнойСтраницы	 	= "СтраницаОкончание";
	Переход.ИмяСтраницыНавигации	= "СтраницаНавигацииОкончание";
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьЭтапПерехода(Название, Панель, Надпись, Текущая, Успешно)
	
	СтрокаЭтап = ЭтапыНастройки.Добавить();
	СтрокаЭтап.Название         = Название;
	СтрокаЭтап.Надпись          = Надпись;
	СтрокаЭтап.Панель           = Панель;
	СтрокаЭтап.СтраницаУспешно  = Успешно;
	СтрокаЭтап.СтраницаТекущий  = Текущая;
	
	Возврат СтрокаЭтап;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуЭтаповПерехода()
	
	ЭтапыНастройки.Очистить();
	
	ДобавитьЭтапПерехода("ПолучениеНастроек",
		Элементы.ПанельПолучениеНастроек.Имя,
		Элементы.ДекорацияПолучениеНастроек.Имя,
		Элементы.СтраницаПолучениеНастроекТекущий.Имя,
		Элементы.СтраницаПолучениеНастроекУспешно.Имя);
		
	ДобавитьЭтапПерехода("ОтключениеОтМС",
		Элементы.ПанельОтключениеОтМенеджераСервиса.Имя,
		Элементы.ДекорацияОтключениеОтМенеджераСервиса.Имя,
		Элементы.СтраницаОтключениеОтМенеджераСервисаТекущий.Имя,
		Элементы.СтраницаОтключениеОтМенеджераСервисаУспешно.Имя);
		
	ДобавитьЭтапПерехода("НастройкаКоррУзла",
		Элементы.ПанельНастройкаКоррУзла.Имя,
		Элементы.ДекорацияНастройкаКоррУзла.Имя,
		Элементы.СтраницаНастройкаКоррУзлаТекущий.Имя,
		Элементы.СтраницаНастройкаКоррУзлаУспешно.Имя);

	ДобавитьЭтапПерехода("НастройкаУзла",
		Элементы.ПанельНастройкаУзла.Имя,
		Элементы.ДекорацияНастройкаУзла.Имя,
		Элементы.СтраницаНастройкаУзлаТекущий.Имя,
		Элементы.СтраницаНастройкаУзлаУспешно.Имя);
		   	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеЭтапов()
	
	НомерСтроки = 1;
	Для Каждого Строка Из ЭтапыНастройки Цикл
		
		Панель = Элементы[Строка.Панель];
		
		Если НомерСтроки = ТекущийЭтап Тогда
			Элементы[Строка.Панель].ТекущаяСтраница = Элементы[Строка.СтраницаТекущий];
			Элементы[Строка.Надпись].Шрифт = Новый Шрифт(,,Истина);
		ИначеЕсли НомерСтроки < ТекущийЭтап Тогда
			Элементы[Строка.Панель].ТекущаяСтраница = Элементы[Строка.СтраницаУспешно];
			Элементы[Строка.Надпись].Шрифт = Новый Шрифт;
		Иначе
			Элементы[Строка.Надпись].Шрифт = Новый Шрифт;
		КонецЕсли; 
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

