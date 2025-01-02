﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму создания резервной копии.
//
// Параметры:
//    Параметры - Структура - параметры формы создания резервной копии.
//
Процедура ОткрытьФормуРезервногоКопирования(Параметры = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.РазделениеВключено()
	 Или Не ДоступноРезервноеКопирование() Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().РезервноеКопированиеИБ;
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияГлобальныхПеременных(Настройки);
	ПроверитьРезервноеКопированиеИБ(Настройки);
	Если Настройки.ПроведеноВосстановление Тогда
		ТекстОповещения = НСтр("ru = 'Восстановление данных проведено успешно.'");
		ПоказатьОповещениеПользователя(НСтр("ru = 'Данные восстановлены.'"), , ТекстОповещения);
	КонецЕсли;
	
	ВариантОповещения = Настройки.ПараметрОповещения;
	Если ВариантОповещения = "НеОповещать" Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		ПоказыватьПредупреждение = Ложь;
		РезервноеКопированиеИБКлиентПереопределяемый.ПриОпределенииНеобходимостиПоказаПредупрежденийОРезервномКопировании(ПоказыватьПредупреждение);
	Иначе
		ПоказыватьПредупреждение = Истина;
	КонецЕсли;
	
	Если ПоказыватьПредупреждение
		И (ВариантОповещения = "Просрочено" Или ВариантОповещения = "ЕщеНеНастроено") Тогда
		ОповеститьПользователяОРезервномКопировании(ВариантОповещения);
	КонецЕсли;
	
	ПодключитьОбработчикОжиданияРезервногоКопирования();
	
КонецПроцедуры

// Параметры:
//  Отказ - см. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.Отказ
//  Предупреждения - см. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.Предупреждения
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		Возврат;
#КонецЕсли
	
	Если Не ОбщегоНазначенияКлиент.ЭтоWindowsКлиент()
	 Или Не ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая()
	 Или ОбщегоНазначенияКлиент.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = СтандартныеПодсистемыКлиент.ПараметрКлиента();
	
	Если Не Параметры.РезервноеКопированиеИБПриЗавершенииРаботы.ДоступностьРолейОповещения
		Или Не Параметры.РезервноеКопированиеИБПриЗавершенииРаботы.ВыполнятьПриЗавершенииРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПредупреждения = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
	ПараметрыПредупреждения.ТекстФлажка = НСтр("ru = 'Выполнить резервное копирование'");
	ПараметрыПредупреждения.Приоритет = 50;
	ПараметрыПредупреждения.ТекстПредупреждения = НСтр("ru = 'Запланировано резервное копирование при завершении работы.'");
	
	ДействиеПриУстановленномФлажке = ПараметрыПредупреждения.ДействиеПриУстановленномФлажке;
	ДействиеПриУстановленномФлажке.Форма = "Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных";
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимРаботы", "ВыполнитьПриЗавершенииРаботы");
	ДействиеПриУстановленномФлажке.ПараметрыФормы = ПараметрыФормы;
	
	Предупреждения.Добавить(ПараметрыПредупреждения);
	
КонецПроцедуры

// См. ИнтеграцияПодсистемБСПКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме.
Процедура ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат) Экспорт
	
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
		Результат = Истина;
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияПодсистемБСПКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию.
Процедура ПриПредложенииПользователюСоздатьРезервнуюКопию() Экспорт
	
	ОткрытьФормуРезервногоКопирования();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЗначенияГлобальныхПеременных(Настройки) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПроцессВыполняется");
	Результат.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования");
	Результат.Вставить("ДатаПоследнегоРезервногоКопирования");
	Результат.Вставить("ПараметрОповещения");
	ЗаполнитьЗначенияСвойств(Результат, Настройки);
	Результат.Вставить("РасписаниеЗначение", ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Настройки.РасписаниеКопирования));
	ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ", Результат);
	
КонецПроцедуры

// Проверяет необходимость запуска автоматического резервного копирования
// в процессе работы пользователя, а также повторного оповещения после игнорировании первоначального.
//
Процедура ОбработчикОжиданияЗапуска() Экспорт
	
	Если Не ДоступноРезервноеКопирование() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая()
	   И НеобходимостьАвтоматическогоРезервногоКопирования() Тогда
		
		ПровестиРезервноеКопирование();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		ПоказыватьПредупреждение = Ложь;
		РезервноеКопированиеИБКлиентПереопределяемый.ПриОпределенииНеобходимостиПоказаПредупрежденийОРезервномКопировании(ПоказыватьПредупреждение);
	Иначе
		ПоказыватьПредупреждение = Истина;
	КонецЕсли;
	
	ВариантОповещения = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"].ПараметрОповещения;
	Если ПоказыватьПредупреждение
		И (ВариантОповещения = "Просрочено" Или ВариантОповещения = "ЕщеНеНастроено") Тогда
		ОповеститьПользователяОРезервномКопировании(ВариантОповещения);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет необходимость проведения автоматического резервного копирования.
//
// Возвращаемое значение:
//   Булево - Истина, если необходима, Ложь - иначе.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования()
	
	Настройки = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	Если Настройки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РасписаниеЗначение = Неопределено;
	Если Настройки.ПроцессВыполняется
		ИЛИ НЕ Настройки.Свойство("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования")
		ИЛИ НЕ Настройки.Свойство("РасписаниеЗначение", РасписаниеЗначение)
		ИЛИ НЕ Настройки.Свойство("ДатаПоследнегоРезервногоКопирования") Тогда
		Возврат Ложь;
	КонецЕсли;
	Если РасписаниеЗначение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаПроверки = ОбщегоНазначенияКлиент.ДатаСеанса();
	ДатаСледующегоКопирования = Настройки.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	Если ДатаСледующегоКопирования = '29990101' Или ДатаСледующегоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, Настройки.ДатаПоследнегоРезервногоКопирования);
КонецФункции

// Запускает резервное копирование по расписанию.
// 
Процедура ПровестиРезервноеКопирование()
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Да", НСтр("ru = 'Да'"));
	Кнопки.Добавить("Нет", НСтр("ru = 'Нет'"));
	Кнопки.Добавить("Отложить", НСтр("ru = 'Отложить на 15 минут'"));
	
	ОписаниеОповещение = Новый ОписаниеОповещения("ПровестиРезервноеКопированиеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещение, НСтр("ru = 'Все готово для выполнения резервного копирования по расписанию.
		|Выполнить резервное копирование сейчас?'"),
		Кнопки, 30, "Да", НСтр("ru = 'Резервное копирование по расписанию'"), "Да");
	
КонецПроцедуры

Процедура ПровестиРезервноеКопированиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыполнитьРезервноеКопирование = РезультатВопроса = "Да" Или РезультатВопроса = КодВозвратаДиалога.Таймаут;
	ОтложитьРезервноеКопирование = РезультатВопроса = "Отложить";
	
	СледующаяДата = РезервноеКопированиеИБВызовСервера.ДатаСледующегоАвтоматическогоКопирования(ОтложитьРезервноеКопирование);
	Настройки = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	Настройки.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = СледующаяДата;
	
	Если ВыполнитьРезервноеКопирование Тогда
		ПараметрыФормы = Новый Структура("РежимРаботы", "ВыполнитьСейчас");
		ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// При старте системы проверяет, первый ли это запуск после проведения резервного копирования. 
// Если да - выводит форму обработчика с результатами резервного копирования.
//
// Параметры:
//  Параметры - Структура - параметры резервного копирования.
//
Процедура ПроверитьРезервноеКопированиеИБ(Параметры)
	
	Если Не Параметры.ПроведеноКопирование Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РучнойЗапускПоследнегоРезервногоКопирования Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("РежимРаботы", ?(Параметры.РезультатКопирования, "УспешноВыполнено", "НеВыполнено"));
		ПараметрыФормы.Вставить("ИмяФайлаРезервнойКопии", Параметры.ИмяФайлаРезервнойКопии);
		ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", ПараметрыФормы);
		
	Иначе
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"),
			"e1cib/command/ОбщаяКоманда.ПоказатьРезультатРезервногоКопирования",
			НСтр("ru = 'Резервное копирование проведено успешно'"), БиблиотекаКартинок.ДиалогИнформация);
		РезервноеКопированиеИБВызовСервера.УстановитьЗначениеНастройки("ПроведеноКопирование", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// По результатам анализа параметров резервного копирования выдает соответствующее оповещение.
//
// Параметры: 
//   ВариантОповещения - Строка - результат проверки на посылку оповещения.
//
Процедура ОповеститьПользователяОРезервномКопировании(ВариантОповещения)
	
	ТекстПояснения = "";
	Если ВариантОповещения = "Просрочено" Тогда
		
		ТекстПояснения = НСтр("ru = 'Автоматическое резервное копирование не было выполнено.'"); 
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"),
			"e1cib/app/Обработка.РезервноеКопированиеИБ", ТекстПояснения, БиблиотекаКартинок.ДиалогВосклицание);
		
	ИначеЕсли ВариантОповещения = "ЕщеНеНастроено" Тогда
		
		ИмяФормыНастроек = "e1cib/app/Обработка.НастройкаРезервногоКопированияИБ/";
		ТекстПояснения = НСтр("ru = 'Рекомендуется настроить резервное копирование информационной базы.'"); 
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"),
			ИмяФормыНастроек, ТекстПояснения, БиблиотекаКартинок.ДиалогВосклицание);
			
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	РезервноеКопированиеИБВызовСервера.УстановитьДатуПоследнегоНапоминания(ТекущаяДата);
	
КонецПроцедуры

// Возвращает тип события журнала регистрации для данной подсистемы.
//
// Возвращаемое значение:
//   Строка - тип события журнала регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Резервное копирование информационной базы'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции

// Получение параметров аутентификации пользователя для обновления.
// Создает виртуального пользователя, если в этом есть необходимость.
//
// Возвращаемое значение
//  Структура       - параметры виртуального пользователя.
//
Функция ПараметрыАутентификацииАдминистратораОбновления(ПарольАдминистратора) Экспорт
	
	Результат = Новый Структура("ИмяПользователя, ПарольПользователя, СтрокаПодключения, СтрокаСоединенияИнформационнойБазы");
	
	ТекущиеСоединения = СоединенияИБВызовСервера.ИнформацияОСоединениях(Истина,
		ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	Если Не ТекущиеСоединения.ЕстьАктивныеПользователи Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.ИмяПользователя    = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().ИмяТекущегоПользователя;
	Результат.ПарольПользователя = СтрокаUnicode(ПарольАдминистратора);
	Результат.СтрокаПодключения  = "Usr=""{0}"";Pwd=""{1}""";
	Возврат Результат;
	
КонецФункции

Функция СтрокаUnicode(Строка) Экспорт
	
	Результат = "";
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		
		Символ = Формат(КодСимвола(Сред(Строка, НомерСимвола, 1)), "ЧГ=0");
		Символ = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Символ, 4);
		Результат = Результат + Символ;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Проверят возможность подключения к информационной базе.
//
Процедура ПроверитьДоступКИнформационнойБазе(ПарольАдминистратора, Знач Оповещение) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("ПарольАдминистратора", ПарольАдминистратора);
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьДоступКИнформационнойБазеПослеРегистрацииCOM", ЭтотОбъект, Контекст);
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь, Оповещение);
	
КонецПроцедуры

Процедура ПроверитьДоступКИнформационнойБазеПослеРегистрацииCOM(Зарегистрировано, Контекст) Экспорт
	
	Оповещение = Контекст.Оповещение;
	ПарольАдминистратора = Контекст.ПарольАдминистратора;
	
	РезультатПодключения = РезультатПодключения();
	
	Если Зарегистрировано Тогда 
		
		ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
		
		ПараметрыПодключения = ОбщегоНазначенияКлиентСервер.СтруктураПараметровДляУстановкиВнешнегоСоединения();
		ПараметрыПодключения.КаталогИнформационнойБазы = СтрРазделить(СтрокаСоединенияИнформационнойБазы(), """")[1];
		ПараметрыПодключения.ИмяПользователя = ПараметрыРаботыКлиентаПриЗапуске.ИмяТекущегоПользователя;
		ПараметрыПодключения.ПарольПользователя = ПарольАдминистратора;
		
		Результат = ОбщегоНазначенияКлиент.УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
		
		Если Результат.ОшибкаПодключенияКомпоненты Тогда
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				СобытиеЖурналаРегистрации(),"Ошибка", Результат.ПодробноеОписаниеОшибки, , Истина);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(РезультатПодключения, Результат);
		
		Результат.Соединение = Неопределено; // Разрываем соединение.
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, РезультатПодключения);
	
КонецПроцедуры

Функция РезультатПодключения()
	
	Результат = Новый Структура;
	Результат.Вставить("ОшибкаПодключенияКомпоненты", Ложь);
	Результат.Вставить("КраткоеОписаниеОшибки", "");
	
	Возврат Результат;
	
КонецФункции

// Подключение глобального обработчика ожидания.
//
Процедура ПодключитьОбработчикОжиданияРезервногоКопирования() Экспорт
	
	ПодключитьОбработчикОжидания("ОбработчикДействийРезервногоКопирования", 60);
	
КонецПроцедуры

// Отключение глобального обработчика ожидания.
//
Процедура ОтключитьОбработчикОжиданияРезервногоКопирования() Экспорт
	
	ОтключитьОбработчикОжидания("ОбработчикДействийРезервногоКопирования");
	
КонецПроцедуры

Функция КоличествоСекундВПериоде(Период, ТипПериода)
	
	Если ТипПериода = "День" Тогда
		Множитель = 3600 * 24;
	ИначеЕсли ТипПериода = "Неделя" Тогда
		Множитель = 3600 * 24 * 7; 
	ИначеЕсли ТипПериода = "Месяц" Тогда
		Множитель = 3600 * 24 * 30;
	ИначеЕсли ТипПериода = "Год" Тогда
		Множитель = 3600 * 24 * 365;
	КонецЕсли;
	
	Возврат Множитель * Период;
	
КонецФункции

#Если Не ВебКлиент И Не МобильныйКлиент Тогда

Процедура УдалитьРезервныеКопииПоНастройке() Экспорт
	
	ФиксированныеПараметрыРезервногоКопированияИБ = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РезервноеКопированиеИБ;
	КаталогХранения = ФиксированныеПараметрыРезервногоКопированияИБ.КаталогХраненияРезервныхКопий;
	ПараметрыУдаления = ФиксированныеПараметрыРезервногоКопированияИБ.ПараметрыУдаления;
	Если ПараметрыУдаления.ТипОграничения = "ХранитьВсе" Или КаталогХранения = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	// АПК:566-выкл код никогда не выполнится в браузере.
	Попытка
		Файл = Новый Файл(КаталогХранения);
		Если НЕ Файл.ЭтоКаталог() Тогда
			Возврат;
		КонецЕсли;
		
		ФайлыРезервныхКопий = НайтиФайлы(КаталогХранения, "backup????_??_??_??_??_??*", Ложь);
		СписокУдаляемыхФайлов = Новый Массив;
		
		Если ПараметрыУдаления.ТипОграничения = "ПоПериоду" Тогда
			Для Каждого ЭлементФайл Из ФайлыРезервныхКопий Цикл
				ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
				ЗначениеВСекундах = КоличествоСекундВПериоде(ПараметрыУдаления.ЗначениеВЕдиницахИзмерения, 
					ПараметрыУдаления.ЕдиницаИзмеренияПериода);
				ПроизводитьУдаление = ((ТекущаяДата - ЗначениеВСекундах) > ЭлементФайл.ПолучитьВремяИзменения());
				Если ПроизводитьУдаление Тогда
					СписокУдаляемыхФайлов.Добавить(ЭлементФайл.ПолноеИмя);
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ФайлыРезервныхКопий.Количество() > ПараметрыУдаления.КоличествоКопий Тогда
			СписокФайлов = Новый СписокЗначений;
			СписокФайлов.ЗагрузитьЗначения(ФайлыРезервныхКопий);
			
			Для Каждого Файл Из СписокФайлов Цикл
				Файл.Представление = Файл.Значение.ПолноеИмя;
				Файл.Значение = Файл.Значение.ПолучитьВремяИзменения();
			КонецЦикла;
			
			СписокФайлов.СортироватьПоЗначению(НаправлениеСортировки.Возр);
			
			Для Индекс = 0 По СписокФайлов.Количество() - ПараметрыУдаления.КоличествоКопий - 1 Цикл
				СписокУдаляемыхФайлов.Добавить(СписокФайлов[Индекс].Представление);
			КонецЦикла;
		КонецЕсли;
		
		Для Каждого УдаляемыйФайл Из СписокУдаляемыхФайлов Цикл
			Попытка
				УдалитьФайлы(УдаляемыйФайл);
			Исключение
				ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
					НСтр("ru = 'Не удалось провести очистку каталога с резервными копиями.'") + Символы.ПС 
					+ ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
			КонецПопытки;
		КонецЦикла;
		
	Исключение
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
			НСтр("ru = 'Не удалось провести очистку каталога с резервными копиями.'") + Символы.ПС 
			+ ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
	КонецПопытки;
	
	// АПК:566-вкл
	
КонецПроцедуры

Функция КодировкаФайловПрограммыРезервногоКопированияИБ() Экспорт
	
	// wscript.exe может работать только с файлами в кодировке UTF-16 LE.
	Возврат КодировкаТекста.UTF16;
	
КонецФункции

// Возвращает параметры скрипта резервного копирования.
//
// Возвращаемое значение:
//   Структура - структура скрипта резервного копирования.
//
Функция КлиентскиеПараметрыРезервногоКопирования() Экспорт
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИмяФайлаПрограммы", СтандартныеПодсистемыКлиент.ИмяИсполняемогоФайлаПриложения());
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации", НСтр("ru = 'Резервное копирование ИБ'"));
	
	// Вызов КаталогВременныхФайлов вместо ПолучитьИмяВременногоФайла, так как каталог не должен удаляться 
	// автоматически при завершении клиентского приложения.
	КаталогВременныхФайловОбновления = КаталогВременныхФайлов() + "1Cv8Backup." + Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=ггММддЧЧммсс") + "\";
	СтруктураПараметров.Вставить("КаталогВременныхФайловОбновления", КаталогВременныхФайловОбновления);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Процедура НеОстанавливатьВыполнениеСценариев() Экспорт
	
	Оболочка = Новый COMОбъект("Wscript.Shell");
	Оболочка.RegWrite("HKCU\Software\Microsoft\Internet Explorer\Styles\MaxScriptStatements", 1107296255, "REG_DWORD");

КонецПроцедуры

#КонецЕсли

Функция ДоступноРезервноеКопирование()
	
#Если ВебКлиент Или МобильныйКлиент Тогда
	Возврат Ложь;
#Иначе
	Возврат ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
#КонецЕсли
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//    * КаталогПрограммы - Строка
//    * ИмяФайлаПрограммы - Строка
//    * СобытиеЖурналаРегистрации - Строка
//    * ИмяCOMСоединителя - Строка
//    * ЭтоБазоваяВерсияКонфигурации - Строка
//    * ПараметрыСкрипта - Строка
//    * ПараметрыЗапускаПредприятия - Строка
//
Функция ОбщиеПараметрыСкрипта() Экспорт
	
	ПараметрыСкрипта = Новый Структура;
	ПараметрыСкрипта.Вставить("КаталогПрограммы"            , "");
	ПараметрыСкрипта.Вставить("ИмяФайлаПрограммы"           , "");
	ПараметрыСкрипта.Вставить("СобытиеЖурналаРегистрации"   , "");
	ПараметрыСкрипта.Вставить("ИмяCOMСоединителя"           , "");
	ПараметрыСкрипта.Вставить("ЭтоБазоваяВерсияКонфигурации", "");
	ПараметрыСкрипта.Вставить("ПараметрыСкрипта"            , "");
	ПараметрыСкрипта.Вставить("ПараметрыЗапускаПредприятия" , "");
	Возврат ПараметрыСкрипта;
	
КонецФункции	

#КонецОбласти
