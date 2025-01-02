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
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СостояниеУчетнойЗаписиDSS);
	МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.СостояниеУчетнойЗаписиDSS).Включен = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Следующие процедуры и функции предназначены для интеграции с 1С-Отчетность

// Формирует данные об активной учетной записи облачной подписи. Данные могут использоваться для формирования отчета 
// или технологических данных.
//
// Параметры:
//  НастройкиПользователя - см. СервисКриптографииDSS.НастройкиПользователяПоУмолчанию
//
// Возвращаемое значение:
//  Структура:
//    * Таблицы - Структура:
//        ** ОсновныеДанные - ТаблицаЗначений
//        ** ПараметрыПодключения - ТаблицаЗначений
//        ** СписокОпераций - ТаблицаЗначений
//        ** Сертификаты - ТаблицаЗначений
//        ** ТипыПодписи - ТаблицаЗначений
//        ** УдостоверяющиеЦентры - ТаблицаЗначений
//        ** Криптопровайдеры - ТаблицаЗначений
//        ** УдостоверяющиеЦентры - ТаблицаЗначений
//
Функция СформироватьДанныеСостоянияУчетнойЗаписи(НастройкиПользователя) Экспорт
	
	ВсеТаблицы  = Новый Структура;
	Если НастройкиПользователя = Неопределено Тогда
		ВсеТаблицы.Вставить("ОсновныеДанные", ТаблицаОсновныеДанные());
		ВсеТаблицы.Вставить("ПараметрыПодключения", ТаблицаПараметрыПодключения());
		ВсеТаблицы.Вставить("СписокОпераций", ТаблицаСписокОпераций());
		ВсеТаблицы.Вставить("Сертификаты", ТаблицаСписокСертификатов());
		ВсеТаблицы.Вставить("СерверыШтамповВремени", ТаблицаСерверовШтамповВремени());
		ВсеТаблицы.Вставить("ТипыПодписи", ТаблицаСписокТиповПодписи());
		ВсеТаблицы.Вставить("УдостоверяющиеЦентры", ТаблицаСписокУдостоверяющихЦентров());
		ВсеТаблицы.Вставить("Криптопровайдеры", ТаблицаСписокКриптопровайдеров());
	Иначе	
		ВсеТаблицы.Вставить("ОсновныеДанные", ЗаполнитьОсновныеДанные(НастройкиПользователя));
		ВсеТаблицы.Вставить("ПараметрыПодключения", ЗаполнитьПараметрыПодключения(НастройкиПользователя));
		ВсеТаблицы.Вставить("СписокОпераций", ЗаполнитьСписокОпераций(НастройкиПользователя));
		ВсеТаблицы.Вставить("Сертификаты", ЗаполнитьСписокСертификатов(НастройкиПользователя));
		ВсеТаблицы.Вставить("СерверыШтамповВремени", ЗаполнитьСписокСерверовШтамповВремени(НастройкиПользователя));
		ВсеТаблицы.Вставить("ТипыПодписи", ЗаполнитьСписокТиповПодписей(НастройкиПользователя));
		ВсеТаблицы.Вставить("УдостоверяющиеЦентры", ЗаполнитьСписокУдостоверяющихЦентров(НастройкиПользователя));
		ВсеТаблицы.Вставить("Криптопровайдеры", ЗаполнитьСписокКриптопровайдеров(НастройкиПользователя));
	КонецЕсли;	

	Результат	= Новый Структура;
	Результат.Вставить("Таблицы", ВсеТаблицы);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПростойТип(Вид, ДлинаОбщая = 0, Знаков = 0)
	
	Результат = Неопределено;
	
	Если Вид = "Строка" Тогда
		Результат = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ДлинаОбщая));
	ИначеЕсли Вид = "Булево" Тогда
		Результат = Новый ОписаниеТипов("Булево");
	КонецЕсли;	
		
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЗакрытыеДанные(НастройкиПользователя, ОписаниеДанных)
	
	Результат = СервисКриптографииDSSСлужебный.ПолучитьЗакрытыеДанные(НастройкиПользователя.УникальныйИдентификатор, ОписаниеДанных);
	Возврат Результат;
	
КонецФункции

Функция ДобавитьЗаголовок(ТаблицаДанных, ЗаголовокСтроки, ЗначениеСтроки)
	
	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(ЗначениеСтроки) Тогда
		Результат = ТаблицаДанных.Добавить();
		Результат.Заголовок = ЗаголовокСтроки + ":";
		Результат.Значение = СокрЛП(ЗначениеСтроки);
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаОсновныеДанные()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Заголовок", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Значение", ПростойТип("Строка"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаПараметрыПодключения()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Заголовок", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Значение", ПростойТип("Строка"));

	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаСписокОпераций()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Имя", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Подтверждать", ПростойТип("Строка"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаСписокСертификатов()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("ОбщееИмя", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Отпечаток", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("ДатаНачала", ПростойТип("Дата"));
	ТаблицаДанных.Колонки.Добавить("ДатаОкончания", ПростойТип("Дата"));
	ТаблицаДанных.Колонки.Добавить("Просрочен", ПростойТип("Булево"));

	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаСерверовШтамповВремени()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Имя", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Адрес", ПростойТип("Строка"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаСписокТиповПодписи()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Имя", ПростойТип("Строка"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаСписокУдостоверяющихЦентров()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Имя", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Идентификатор", ПростойТип("Строка"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ТаблицаСписокКриптопровайдеров()
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Имя", ПростойТип("Строка"));
	ТаблицаДанных.Колонки.Добавить("Идентификатор", ПростойТип("Строка", 36));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗаполнитьОсновныеДанные(НастройкиПользователя)
	
	ТаблицаДанных = ТаблицаОсновныеДанные();
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	СертификатАутентификации = ЗначениеЗаполнено(ПолучитьЗакрытыеДанные(НастройкиПользователя, "СертификатАвторизации"));
	
	ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Учетная запись'", КодЯзыка), НастройкиПользователя.Ссылка);
	ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Способ авторизации'", КодЯзыка), НастройкиПользователя.ПервичнаяАутентификация);
	
	Если НастройкиПользователя.ПервичнаяАутентификация = Перечисления.СпособыАвторизацииDSS.Первичный_СертификатАвторизации Тогда
		ДобавитьЗаголовок(ТаблицаДанных, 
			НСтр("ru = 'Сертификат авторизации'", КодЯзыка), 
			?(СертификатАутентификации, НСтр("ru = 'Не указан'", КодЯзыка), НСтр("ru = 'В безопасном хранилище'", КодЯзыка)));
	КонецЕсли;	
	
	ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Телефон'", КодЯзыка), СервисКриптографииDSSКлиентСервер.ПредставлениеТелефона(НастройкиПользователя.Телефон));
	ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Электронная почта'", КодЯзыка), СервисКриптографииDSSКлиентСервер.ПредставлениеАдресаПочты(НастройкиПользователя.ЭлектроннаяПочта));
	ДобавитьЗаголовок(ТаблицаДанных,  НСтр("ru = 'Срок действия маркера'", КодЯзыка), НастройкиПользователя.ТокенАвторизации.СрокДействия);
	
	Возврат ТаблицаДанных;
	
КонецФункции	

Функция ЗаполнитьПараметрыПодключения(НастройкиПользователя)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	ТаблицаДанных = ТаблицаПараметрыПодключения();
	
	Если НЕ СервисКриптографииDSSСлужебный.ПроверитьПраво("ЭкземплярыСервераDSS") Тогда
		Возврат ТаблицаДанных;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭкземплярыСервераDSS.АдресСервера КАК АдресСервера,
	|	ЭкземплярыСервераDSS.СервисИдентификации КАК СервисИдентификации,
	|	ЭкземплярыСервераDSS.СервисПодписи КАК СервисПодписи,
	|	ЭкземплярыСервераDSS.СервисПроверки КАК СервисПроверки,
	|	ЭкземплярыСервераDSS.СервисАудита КАК СервисАудита,
	|	ЭкземплярыСервераDSS.СервисОбработкиДокументов КАК СервисОбработкиДокументов,
	|	ЭкземплярыСервераDSS.ИдентификаторЦИ КАК ИдентификаторЦИ,
	|	ЭкземплярыСервераDSS.ИдентификаторСЭП КАК ИдентификаторСЭП,
	|	ЭкземплярыСервераDSS.АдресЛичногоКабинета КАК АдресЛичногоКабинета,
	|	ЭкземплярыСервераDSS.ТаймАут КАК ТаймАут,
	|	ЭкземплярыСервераDSS.ВерсияАПИ КАК ВерсияАПИ
	|ИЗ
	|	Справочник.УчетныеЗаписиDSS КАК УчетныеЗаписиDSS
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭкземплярыСервераDSS КАК ЭкземплярыСервераDSS
	|		ПО УчетныеЗаписиDSS.Владелец = ЭкземплярыСервераDSS.Ссылка
	|ГДЕ
	|	УчетныеЗаписиDSS.Ссылка = &УчетнаяЗапись";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("УчетнаяЗапись", НастройкиПользователя.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Сервер'", КодЯзыка), Выборка.АдресСервера);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Сервер ЦИ'", КодЯзыка), Выборка.СервисИдентификации);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Сервер СЭП'", КодЯзыка), Выборка.СервисПодписи);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Сервер проверки'", КодЯзыка), Выборка.СервисПроверки);
		Если ЗначениеЗаполнено(Выборка.СервисАудита) Тогда
			ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Сервер аудита'", КодЯзыка), Выборка.СервисАудита);
		КонецЕсли;	
		Если ЗначениеЗаполнено(Выборка.СервисОбработкиДокументов) Тогда
			ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Сервер обработки документов'", КодЯзыка), Выборка.СервисОбработкиДокументов);
		КонецЕсли;	
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Идентификатор ЦИ'", КодЯзыка), Выборка.ИдентификаторЦИ);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Идентификатор СЭП'", КодЯзыка), Выборка.ИдентификаторСЭП);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Личный кабинет'", КодЯзыка), Выборка.АдресЛичногоКабинета);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Тайм-аут'", КодЯзыка), Выборка.ТаймАут);
		ДобавитьЗаголовок(ТаблицаДанных, НСтр("ru = 'Версия АПИ'", КодЯзыка), Выборка.ВерсияАПИ);
	КонецЕсли;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗаполнитьСписокОпераций(НастройкиПользователя)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	// "ru = 'Список подтверждаемых операций'"
	
	ТаблицаДанных = ТаблицаСписокОпераций();
	
	ПредставлениеОперации = Новый Соответствие();
	ПредставлениеОперации.Вставить("ВыпускМаркера", НСтр("ru = 'Выпуск маркера'", КодЯзыка));
	ПредставлениеОперации.Вставить("ПодписьДокумента", НСтр("ru = 'Подпись документа'", КодЯзыка));
	ПредставлениеОперации.Вставить("ПодписьПакета", НСтр("ru = 'Подпись пакета документов'", КодЯзыка));
	ПредставлениеОперации.Вставить("Расшифрование", НСтр("ru = 'Расшифрование'", КодЯзыка));
	ПредставлениеОперации.Вставить("ЗапросНаСертификат", НСтр("ru = 'Формирование запроса на сертификат'", КодЯзыка));
	ПредставлениеОперации.Вставить("СменаПинКода", НСтр("ru = 'Смена пин-кода к закрытому ключу'", КодЯзыка));
	ПредставлениеОперации.Вставить("ОбновлениеСертификата", НСтр("ru = 'Обновление сертификата'", КодЯзыка));
	ПредставлениеОперации.Вставить("ОтзывСертификата", НСтр("ru = 'Отзыв сертификата'", КодЯзыка));
	ПредставлениеОперации.Вставить("ПриостановкаСертификата", НСтр("ru = 'Приостановка сертификата'", КодЯзыка));
	ПредставлениеОперации.Вставить("ВосстановлениеСертификата", НСтр("ru = 'Восстановление сертификата'", КодЯзыка));
	ПредставлениеОперации.Вставить("УдалениеСертификата", НСтр("ru = 'Удаление сертификата'", КодЯзыка));
	ПредставлениеОперации.Вставить("ДоступККлючу", НСтр("ru = 'Доступ к ключу'", КодЯзыка));
	
	ВесьСписок = НастройкиПользователя.Политика.Действия;
	
	Для Каждого СтрокаКлюча Из ВесьСписок Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.Имя = ПредставлениеОперации[СтрокаКлюча.Ключ];
		НоваяСтрока.Подтверждать = ?(СтрокаКлюча.Значение.Подтверждать, НСтр("ru = 'Подтверждать'", КодЯзыка), "");
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗаполнитьСписокСертификатов(НастройкиПользователя)
	
	ТаблицаДанных = ТаблицаСписокСертификатов();
	
	ВесьСписок = НастройкиПользователя.Сертификаты;
	РабочаяДата = ТекущаяДатаСеанса();
	
	Для Каждого СтрокаКлюча Из ВесьСписок Цикл
		Сертификат = СтрокаКлюча.Значение;
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.ОбщееИмя = Сертификат.Представление;
		НоваяСтрока.Отпечаток = Сертификат.Отпечаток;
		НоваяСтрока.ДатаНачала = Сертификат.ДатаНачала;
		НоваяСтрока.ДатаОкончания = Сертификат.ДатаОкончания;
		НоваяСтрока.Просрочен = РабочаяДата > Сертификат.ДатаОкончания;
		
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗаполнитьСписокСерверовШтамповВремени(НастройкиПользователя)
	
	ТаблицаДанных = ТаблицаСерверовШтамповВремени();
	
	ВесьСписок = НастройкиПользователя.Политика.СервераШтамповВремени;
	
	Для Каждого СтрокаМассива Из ВесьСписок Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.Имя = СтрокаМассива.Имя;
		НоваяСтрока.Адрес = СтрокаМассива.Адрес;
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗаполнитьСписокТиповПодписей(НастройкиПользователя)
	
	ТаблицаДанных = ТаблицаСписокТиповПодписи();
	
	ВсеТипы	= СервисКриптографииDSSКлиентСервер.ПолучитьТипыПодписей();
	ВесьСписок = НастройкиПользователя.Политика.ТипыПодписей;
	
	Для Каждого СтрокаМассива Из ВесьСписок Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.Имя = ВсеТипы[СтрокаМассива];
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции	

// Формирует таблицу УЦ
//
// Параметры:
//  НастройкиПользователя - см. СервисКриптографииDSS.НастройкиПользователяПоУмолчанию
//
Функция ЗаполнитьСписокУдостоверяющихЦентров(НастройкиПользователя)
	
	ТаблицаДанных = ТаблицаСписокУдостоверяющихЦентров();
	
	ВесьСписок = НастройкиПользователя.Политика.УЦ;
	
	Для Каждого СтрокаКлюча Из ВесьСписок Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.Имя = СтрокаКлюча.Имя;
		НоваяСтрока.Идентификатор = СтрокаКлюча.Идентификатор;
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗаполнитьСписокКриптопровайдеров(НастройкиПользователя)
	
	ТаблицаДанных = ТаблицаСписокКриптопровайдеров();
	
	ВесьСписок = НастройкиПользователя.Политика.Криптопровайдеры;
	
	Для Каждого СтрокаКлюча Из ВесьСписок Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.Имя = СтрокаКлюча.Описание;
		НоваяСтрока.Идентификатор = СтрокаКлюча.Идентификатор;
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

#КонецОбласти

#КонецЕсли