﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Удаляет из строки последние символы, если они равны подстроке удаления,
// до тех пор, пока последние символы будут не равны подстроке удаления.   
//
// Параметры:
//  ВходящаяСтрока    - Строка - строка, которая будет обрабатываться.
//  ПодстрокаУдаления - Строка - подстрока, которая будет удалена из конца строки.
//  Разделитель       - Строка - если задан, то удаление происходит только в том случае, 
//                        если подстрока удаления находится целиком после разделителя.
//
// Возвращаемое значение:
//   Строка  - получившаяся в результате обработки строка.
//
Функция УдалитьПоследниеСимволыИзСтроки(ВходящаяСтрока, ПодстрокаУдаления, Разделитель = Неопределено) Экспорт

	Пока Прав(ВходящаяСтрока, СтрДлина(ПодстрокаУдаления)) = ПодстрокаУдаления Цикл

		Если Разделитель <> Неопределено Тогда
			Если СРЕД(ВходящаяСтрока, СтрДлина(ВходящаяСтрока) - СтрДлина(ПодстрокаУдаления) - СтрДлина(Разделитель),
				СтрДлина(Разделитель)) = Разделитель Тогда
				Возврат ВходящаяСтрока;
			КонецЕсли;
		КонецЕсли;
		ВходящаяСтрока = ЛЕВ(ВходящаяСтрока, СтрДлина(ВходящаяСтрока) - СтрДлина(ПодстрокаУдаления));

	КонецЦикла;

	Возврат ВходящаяСтрока;

КонецФункции

// Параметры:
//  Ключ  - УникальныйИдентификатор - ключ, на основе которого будет формироваться имя вопроса.
//
// Возвращаемое значение:
//  Строка
//
Функция ИмяВопроса(Знач Ключ) Экспорт

	Возврат "Вопрос_" + СтрЗаменить(Ключ, "-", "_");

КонецФункции

Функция КоличествоСимволовВИмениВопросаБезПостфикса() Экспорт
	
	КоличествоСимволовВПрефиксе = СтрДлина(ИмяВопроса(""));
	КоличествоСимволовВИдентификаторе = 36;
	
	Возврат КоличествоСимволовВПрефиксе + КоличествоСимволовВИдентификаторе;
	
КонецФункции

Процедура СформироватьНумерациюДерева(ДеревоАнкеты, ПреобразовыватьФормулировку = Ложь) Экспорт

	Если ДеревоАнкеты.ПолучитьЭлементы()[0].ТипСтроки = "Корень" Тогда
		ЗначимыеЭлементыДерева = ДеревоАнкеты.ПолучитьЭлементы()[0].ПолучитьЭлементы();
	Иначе
		ЗначимыеЭлементыДерева = ДеревоАнкеты.ПолучитьЭлементы();
	КонецЕсли;

	СформироватьНумерациюЭлементовДерева(ЗначимыеЭлементыДерева, 1, Новый Массив, ПреобразовыватьФормулировку);

КонецПроцедуры 

Процедура СформироватьНумерациюЭлементовДерева(СтрокиДерева, УровеньРекурсии, МассивПолныйКод,
	ПреобразовыватьФормулировку)

	Если МассивПолныйКод.Количество() < УровеньРекурсии Тогда
		МассивПолныйКод.Добавить(0);
	КонецЕсли;

	Для Каждого Элемент Из СтрокиДерева Цикл

		Если Элемент.ТипСтроки = "Вступление" Или Элемент.ТипСтроки = "Заключение" Тогда
			Продолжить;
		КонецЕсли;

		МассивПолныйКод[УровеньРекурсии - 1] = МассивПолныйКод[УровеньРекурсии - 1] + 1;
		Для инд = УровеньРекурсии По МассивПолныйКод.Количество() - 1 Цикл
			МассивПолныйКод[инд] = 0;
		КонецЦикла;

		ПолныйКод = СтрСоединить(МассивПолныйКод, ".");
		ПолныйКод = УдалитьПоследниеСимволыИзСтроки(ПолныйКод, ".0.", ".");

		Элемент.ПолныйКод = ПолныйКод;
		Если ПреобразовыватьФормулировку Тогда
			Элемент.Формулировка = Элемент.ПолныйКод + ". " + Элемент.Формулировка;
		КонецЕсли;

		ПодчиненныеЭлементыСтрокиДерева = Элемент.ПолучитьЭлементы();
		Если ПодчиненныеЭлементыСтрокиДерева.Количество() > 0 Тогда
			СформироватьНумерациюЭлементовДерева(ПодчиненныеЭлементыСтрокиДерева, ?(Элемент.ТипСтроки = "Вопрос",
				УровеньРекурсии, УровеньРекурсии + 1), МассивПолныйКод, ПреобразовыватьФормулировку);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция НайтиСтрокуВДанныхФормыДерево(ГдеИскать, Значение, Колонка, ИскатьВПодчиненных) Экспорт

	ЭлементыДерева = ГдеИскать.ПолучитьЭлементы();

	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева[Колонка] = Значение Тогда
			Возврат ЭлементДерева.ПолучитьИдентификатор();
		ИначеЕсли ИскатьВПодчиненных Тогда
			НайденныйИдентификаторСтроки =  НайтиСтрокуВДанныхФормыДерево(ЭлементДерева, Значение, Колонка,
				ИскатьВПодчиненных);
			Если НайденныйИдентификаторСтроки >= 0 Тогда
				Возврат НайденныйИдентификаторСтроки;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	Возврат -1;

КонецФункции

// Параметры:
//  ЭтоРаздел  - Булево - признак раздела.
//  ТипВопроса - ПеречислениеСсылка.ТипыВопросовШаблонаАнкеты.
//
// Возвращаемое значение:
//   Число
//
Функция ПолучитьКодКартинкиШаблонаАнкеты(ЭтоРаздел, ТипВопроса = Неопределено) Экспорт

	Если ЭтоРаздел Тогда
		Возврат 1;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Простой") Тогда
		Возврат 2;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") Тогда
		Возврат 4;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		Возврат 3;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный") Тогда
		Возврат 5;
	Иначе
		Возврат 0;
	КонецЕсли;

КонецФункции

// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//   ВидимостьТелаАнкеты - Булево
//
Процедура ПереключитьВидимостьГруппТелаАнкеты(Форма, ВидимостьТелаАнкеты) Экспорт

	Форма.Элементы.ГруппаТелоАнкеты.Видимость = ВидимостьТелаАнкеты;
	Форма.Элементы.ГруппаОжидание.Видимость   = Не ВидимостьТелаАнкеты;

	ПредыдущийРазделПодвал = Форма.Элементы.ПредыдущийРазделПодвал; // ПолеФормы
	ПредыдущийРазделПодвал.Доступность = ВидимостьТелаАнкеты;

	ПредыдущийРаздел = Форма.Элементы.ПредыдущийРаздел; // ПолеФормы
	ПредыдущийРаздел.Доступность = ВидимостьТелаАнкеты;

	СледующийРазделПодвал = Форма.Элементы.СледующийРазделПодвал; // ПолеФормы
	СледующийРазделПодвал.Доступность = ВидимостьТелаАнкеты;

	СледующийРаздел = Форма.Элементы.СледующийРаздел; // ПолеФормы
	СледующийРаздел.Доступность = ВидимостьТелаАнкеты;

КонецПроцедуры

#КонецОбласти