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
	
	Если ЗначениеЗаполнено(Параметры.Кратность) Тогда
		Если Параметры.Кратность <> Перечисления.ДоступныеПериодыОтчета.День Тогда
			Элементы.ВыбратьДень.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Период, НачалоПериода, КонецПериода, ОграничениеСнизу, ИмяКоманды");
	
	ИнициализироватьСвойстваПериода();
	
	ДатаНачалаГода = НачалоГода(КонецПериода);
	
	НастроитьФормуПоОграничениюПериода(ЭтотОбъект);
	
	// Определим имя активного периода
	Если НачалоДня(НачалоПериода) = НачалоДня(КонецПериода) Тогда
		ИмяТекущегоЭлемента = "ВыбратьДень";
	ИначеЕсли НачалоМесяца(НачалоПериода) = НачалоМесяца(КонецПериода) Тогда
		НомерМесяца = Месяц(НачалоПериода);
		ИмяТекущегоЭлемента = "ВыбратьМесяц" + НомерМесяца;
	ИначеЕсли НачалоКвартала(НачалоПериода) = НачалоКвартала(КонецПериода) Тогда
		НомерМесяца = Месяц(НачалоПериода);
		НомерКвартала = Цел((НомерМесяца + 3) / 3);
		ИмяТекущегоЭлемента = "ВыбратьКвартал" + НомерКвартала;
	ИначеЕсли НачалоГода(НачалоПериода) = НачалоГода(КонецПериода) Тогда
		НомерМесяцаНачала = Месяц(НачалоПериода);
		НомерМесяцаКонца  = Месяц(КонецПериода);
		Если НомерМесяцаНачала <= 3 И НомерМесяцаКонца <= 6 Тогда
			ИмяТекущегоЭлемента = "ВыбратьПолугодие";
		ИначеЕсли НомерМесяцаНачала <= 3 И НомерМесяцаКонца <= 9 Тогда
			ИмяТекущегоЭлемента = "Выбрать9Месяцев";
		Иначе
			ИмяТекущегоЭлемента = "ВыбратьГод";
		КонецЕсли;
	Иначе
		ИмяТекущегоЭлемента = "ВыбратьГод";
	КонецЕсли;
	
	ТекущийЭлемент = Элементы[ИмяТекущегоЭлемента];
	УстановитьКартинкуПереходаКСтандартномуПериоду();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОчиститьПериод(Команда)
	
	НачалоПериода = Дата(1, 1, 1);
	КонецПериода = Дата(1, 1, 1);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтандартномуВариантуПериода(Команда)
	
	РезультатВыбора = Новый Структура("ВладелецФормы, ИмяКоманды");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтотОбъект);
	РезультатВыбора.Вставить("ВариантПериода", ПредопределенноеЗначение("Перечисление.ВариантыПериода.Стандартный"));
	РезультатВыбора.Вставить("Событие", Команда.Имя);
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаГодНазад(Команда)
	
	ДатаНачалаГода = НачалоГода(ДатаНачалаГода - 1);
	
	НастроитьФормуПоОграничениюПериода(ЭтотОбъект);
	
	ТекущийЭлемент = Элементы[ИмяТекущегоЭлемента];
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаГодВперед(Команда)
	
	ДатаНачалаГода = КонецГода(ДатаНачалаГода) + 1;
	
	НастроитьФормуПоОграничениюПериода(ЭтотОбъект);
	
	ТекущийЭлемент = Элементы[ИмяТекущегоЭлемента];
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц1(Команда)
	
	ВыбратьМесяц(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц2(Команда)
	
	ВыбратьМесяц(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц3(Команда)
	
	ВыбратьМесяц(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц4(Команда)
	
	ВыбратьМесяц(4);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц5(Команда)
	
	ВыбратьМесяц(5);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц6(Команда)
	
	ВыбратьМесяц(6);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц7(Команда)
	
	ВыбратьМесяц(7);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц8(Команда)
	
	ВыбратьМесяц(8);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц9(Команда)
	
	ВыбратьМесяц(9);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц10(Команда)
	
	ВыбратьМесяц(10);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц11(Команда)
	
	ВыбратьМесяц(11);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМесяц12(Команда)
	
	ВыбратьМесяц(12);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал1(Команда)
	
	ВыбратьКвартал(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал2(Команда)
	
	ВыбратьКвартал(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал3(Команда)
	
	ВыбратьКвартал(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал4(Команда)
	
	ВыбратьКвартал(4);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДень(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НачалоПериода",    НачалоПериода);
	ПараметрыФормы.Вставить("КонецПериода",     КонецПериода);
	ПараметрыФормы.Вставить("ОграничениеСнизу", ОграничениеСнизу);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьДеньЗавершение", ЭтотОбъект);
	ОткрытьФорму(
		"ХранилищеНастроек.ХранилищеВариантовОтчетов.Форма.ВыборФинансовогоПериодаДень", 
		ПараметрыФормы, 
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПолугодие(Команда)
	
	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = КонецМесяца(ДобавитьМесяц(НачалоПериода, 5));
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать9Месяцев(Команда)

	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = Дата(Год(ДатаНачалаГода), 9 , 30);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГод(Команда)

	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = КонецГода(ДатаНачалаГода);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьСвойстваПериода()
	
	Если ЗначениеЗаполнено(Период.ДатаНачала) Тогда 
		НачалоПериода = Период.ДатаНачала;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Период.ДатаОкончания) Тогда 
		КонецПериода = Период.ДатаОкончания;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода  = КонецМесяца(ТекущаяДатаСеанса());
		НачалоПериода = НачалоМесяца(КонецПериода);
	КонецЕсли;
	
	Если ОграничениеСнизу > КонецПериода Тогда
		КонецПериода  = КонецМесяца(ОграничениеСнизу);
		НачалоПериода = НачалоМесяца(ОграничениеСнизу);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборПериода()
	
	КонецПериода = КонецДня(КонецПериода);
	Период.ДатаНачала = НачалоПериода;
	Период.ДатаОкончания = КонецПериода;

	РезультатВыбора = Новый Структура("ВладелецФормы, Период, НачалоПериода, КонецПериода");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтотОбъект);
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыбратьМесяц(НомерМесяца)
	
	НачалоПериода = Дата(Год(ДатаНачалаГода), НомерМесяца, 1);
	КонецПериода  = КонецМесяца(НачалоПериода);
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал(НомерКвартала)
	
	НачалоПериода = Дата(Год(ДатаНачалаГода), 1 + (НомерКвартала - 1) * 3, 1);
	
	КонецПериода  = КонецКвартала(НачалоПериода);
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДеньЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		НачалоПериода = Результат.НачалоПериода;
		КонецПериода  = Результат.КонецПериода;
		ВыполнитьВыборПериода();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФормуПоОграничениюПериода(Форма)
	
	Если Не ЗначениеЗаполнено(Форма.ОграничениеСнизу) Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ОграничениеСнизу < Форма.ДатаНачалаГода
		И Не Форма.ВыбранныйГодОграничен Тогда
		Возврат;
	КонецЕсли;
	
	ПервыйГод = (НачалоГода(Форма.ОграничениеСнизу) = Форма.ДатаНачалаГода);
	
	// Выбор года
	Форма.ВыбранныйГодОграничен = ПервыйГод;
	
	Форма.Элементы.ПерейтиНаГодНазадДоступно.Видимость   = Не ПервыйГод;
	Форма.Элементы.ПерейтиНаГодНазадНедоступно.Видимость = ПервыйГод; // картинка ВыборСтандартногоПериодаНедоступнаяКнопка
	
	// Выбор квартала
	МинимальныйКвартал = ?(Не ПервыйГод, 1, Месяц(КонецКвартала(Форма.ОграничениеСнизу)) / 3);
	
	ИменаКварталыНарастающимИтогом = Новый Соответствие;
	ИменаКварталыНарастающимИтогом.Вставить(2, "ВыбратьПолугодие");
	ИменаКварталыНарастающимИтогом.Вставить(3, "Выбрать9Месяцев");
	ИменаКварталыНарастающимИтогом.Вставить(4, "ВыбратьГод");
	
	Для НомерКвартала = 1 По 4 Цикл
		
		ВыбиратьКвартал = (НомерКвартала >= МинимальныйКвартал);
		
		Форма.Элементы["ВыбратьКвартал" + НомерКвартала].Доступность = ВыбиратьКвартал;
		
		ИмяНарастающимИтогом = ИменаКварталыНарастающимИтогом[НомерКвартала];
		Если ИмяНарастающимИтогом <> Неопределено Тогда
			Форма.Элементы[ИмяНарастающимИтогом].Доступность = ВыбиратьКвартал;
		КонецЕсли;
		
	КонецЦикла;
		
	// Выбор месяца
	МинимальныйМесяц = ?(Не ПервыйГод, 1, Месяц(Форма.ОграничениеСнизу));
	Для НомерМесяца = 1 По 12 Цикл
		Форма.Элементы["ВыбратьМесяц" + НомерМесяца].Доступность = (НомерМесяца >= МинимальныйМесяц);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкуПереходаКСтандартномуПериоду()
	
	КартинкаПереходаКСтандартномуПериоду = БиблиотекаКартинок.Календарь;
	
	Элементы.ПерейтиКСтандартномуВариантуПериода.Картинка = КартинкаПереходаКСтандартномуПериоду;
	Элементы.ПерейтиКСтандартномуВариантуПериода.Отображение = ОтображениеКнопки.Картинка;
	
КонецПроцедуры

#КонецОбласти
