﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Настраивает форму объекта для работы подсистемы:
// - добавляет реквизит ПараметрыЗапретаРедактированияРеквизитов для хранения внутренних данных
// - добавляет команду и кнопку РазрешитьРедактированиеРеквизитовОбъекта (если есть права).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения:
//    * ПараметрыЗапретаРедактированияРеквизитов - ТаблицаЗначений:
//        ** ИмяРеквизита - Строка
//        ** Представление - Строка
//        ** РедактированиеРазрешено - Булево
//        ** БлокируемыеЭлементы - Массив
//        ** ПравоРедактирования - Булево
//        ** ЭтоРеквизитФормы - Булево
//  Ссылка - ЛюбаяСсылка
//  ГруппаДляКнопкиЗапрета - ГруппаФормы
//  ЗаголовокКнопкиЗапрета - ГруппаФормы
//
Процедура ПодготовитьФорму(Форма, Ссылка, ГруппаДляКнопкиЗапрета, ЗаголовокКнопкиЗапрета) Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка");
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	ОписаниеТиповМассив = Новый ОписаниеТипов("СписокЗначений");
	
	// Добавление реквизитов на форму.
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПолноеИмяОбъектаРазблокированияРеквизитов", Новый ОписаниеТипов("Строка")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПолноеИмяФормыРазблокированияРеквизитов",   Новый ОписаниеТипов("Строка")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПараметрыЗапретаРедактированияРеквизитов",  Новый ОписаниеТипов("ТаблицаЗначений")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИмяРеквизита",            ОписаниеТиповСтрока, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Представление",           ОписаниеТиповСтрока, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РедактированиеРазрешено", ОписаниеТиповБулево, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("БлокируемыеЭлементы",     ОписаниеТиповМассив, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПравоРедактирования",     ОписаниеТиповБулево, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ЭтоРеквизитФормы",        ОписаниеТиповБулево, "ПараметрыЗапретаРедактированияРеквизитов"));
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	МетаданныеОбъекта = Ссылка.Метаданные();
	Форма.ПолноеИмяОбъектаРазблокированияРеквизитов = МетаданныеОбъекта.ПолноеИмя();
	ОбъектМетаданныхФорма = МетаданныеОбъекта.Формы.Найти("РазблокированиеРеквизитов");
	Если ОбъектМетаданныхФорма <> Неопределено Тогда
		Форма.ПолноеИмяФормыРазблокированияРеквизитов = ОбъектМетаданныхФорма.ПолноеИмя();
	КонецЕсли;
	
	БлокируемыеРеквизиты = БлокируемыеРеквизитыОбъектаИЭлементыФормы(МетаданныеОбъекта.ПолноеИмя());
	ВсеРеквизитыБезПраваРедактирования = Истина;
	
	ЗаполнитьОписаниеБлокируемыхРеквизитов(Форма.ПараметрыЗапретаРедактированияРеквизитов,
		МетаданныеОбъекта, БлокируемыеРеквизиты, ВсеРеквизитыБезПраваРедактирования, Форма);
	
	ЗаполнитьСвязанныеЭлементы(Форма);
	
	// Добавление команды и кнопки, если есть права.
	Если Пользователи.РолиДоступны("РедактированиеРеквизитовОбъектов")
	   И ПравоДоступа("Редактирование", МетаданныеОбъекта)
	   И НЕ ВсеРеквизитыБезПраваРедактирования Тогда
		
		// Добавление команды
		Команда = Форма.Команды.Добавить("РазрешитьРедактированиеРеквизитовОбъекта");
		Команда.Заголовок = ?(ПустаяСтрока(ЗаголовокКнопкиЗапрета), НСтр("ru = 'Разрешить редактирование реквизитов'"), ЗаголовокКнопкиЗапрета);
		Команда.Действие = "Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта";
		Команда.Картинка = БиблиотекаКартинок.РазрешитьРедактированиеРеквизитовОбъекта;
		Команда.ИзменяетСохраняемыеДанные = Истина;
		
		// Добавление кнопки
		РодительскаяГруппа = ?(ГруппаДляКнопкиЗапрета <> Неопределено, ГруппаДляКнопкиЗапрета, Форма.КоманднаяПанель);
		Кнопка = Форма.Элементы.Добавить("РазрешитьРедактированиеРеквизитовОбъекта", Тип("КнопкаФормы"), РодительскаяГруппа);
		Кнопка.ПоложениеВКоманднойПанели = ПоложениеКнопкиВКоманднойПанели.ВДополнительномПодменю;
		Кнопка.ИмяКоманды = "РазрешитьРедактированиеРеквизитовОбъекта";
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для процедуры ПодготовитьФорму.
Процедура ЗаполнитьОписаниеБлокируемыхРеквизитов(Описание, МетаданныеОбъекта, БлокируемыеРеквизиты,
			ВсеРеквизитыБезПраваРедактирования, Форма = Неопределено) Экспорт
	
	РеквизитыФормы = Неопределено;
	
	Для Каждого БлокируемыйРеквизит Из БлокируемыеРеквизиты Цикл
		Если Не ЗначениеЗаполнено(БлокируемыйРеквизит.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеРеквизита = Описание.Добавить();
		
		ОписаниеРеквизита.ИмяРеквизита = БлокируемыйРеквизит.Имя;
		
		Для Каждого БлокируемыйЭлемент Из БлокируемыйРеквизит.ЭлементыФормы Цикл
			ОписаниеРеквизита.БлокируемыеЭлементы.Добавить(СокрЛП(БлокируемыйЭлемент));
		КонецЦикла;
		
		ЭтоПланСчетов = ОбщегоНазначения.ЭтоПланСчетов(МетаданныеОбъекта);
		ЕстьСтандартныеТабличныеЧасти = ЭтоПланСчетов Или ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеОбъекта);
		
		МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.Реквизиты.Найти(ОписаниеРеквизита.ИмяРеквизита);
		Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено И ЭтоПланСчетов Тогда
			МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.ПризнакиУчета.Найти(ОписаниеРеквизита.ИмяРеквизита);
		КонецЕсли;
		СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть = Ложь;
		
		Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено Тогда
			МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.ТабличныеЧасти.Найти(ОписаниеРеквизита.ИмяРеквизита);
			
			Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено
			   И ЕстьСтандартныеТабличныеЧасти
			   И ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеТабличныеЧасти, ОписаниеРеквизита.ИмяРеквизита) Тогда
					МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.СтандартныеТабличныеЧасти[ОписаниеРеквизита.ИмяРеквизита];
					СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть = Истина;
			КонецЕсли;
			Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено Тогда
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ОписаниеРеквизита.ИмяРеквизита) Тогда
					МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.СтандартныеРеквизиты[ОписаниеРеквизита.ИмяРеквизита];
					СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено Тогда
			Если Форма = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если РеквизитыФормы = Неопределено Тогда
				РеквизитыФормы = Новый Соответствие;
				Для Каждого РеквизитФормы Из Форма.ПолучитьРеквизиты() Цикл
					РеквизитыФормы.Вставить(РеквизитФормы.Имя, РеквизитФормы.Заголовок);
				КонецЦикла;
			КонецЕсли;
			
			ОписаниеРеквизита.Представление = РеквизитыФормы[ОписаниеРеквизита.ИмяРеквизита];
			ОписаниеРеквизита.ЭтоРеквизитФормы = Истина;
			
			ОписаниеРеквизита.ПравоРедактирования = Истина;
			ВсеРеквизитыБезПраваРедактирования = Ложь;
		Иначе
			ОписаниеРеквизита.Представление = МетаданныеРеквизитаИлиТабличнойЧасти.Представление();
			
			Если СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть Тогда
				ПравоРедактирования = ПравоДоступа("Редактирование", МетаданныеОбъекта, , МетаданныеРеквизитаИлиТабличнойЧасти.Имя);
			Иначе
				ПравоРедактирования = ПравоДоступа("Редактирование", МетаданныеРеквизитаИлиТабличнойЧасти);
			КонецЕсли;
			Если ПравоРедактирования Тогда
				ОписаниеРеквизита.ПравоРедактирования = Истина;
				ВсеРеквизитыБезПраваРедактирования = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Для процедуры ПодготовитьФорму.
// Дополняет массив блокируемых элементов формы связанными элементами.
//
Процедура ЗаполнитьСвязанныеЭлементы(Форма)
	
	Отбор = Новый Структура("ИмяРеквизита, ЭтоРеквизитФормы", "", Ложь);
	
	Для Каждого ЭлементФормы Из Форма.Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы")
		   И ЭлементФормы.Вид <> ВидПоляФормы.ПолеНадписи
		 Или ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
		
			РазложенныйПутьКДанным = СтрРазделить(ЭлементФормы.ПутьКДанным, ".", Ложь);
			
			Если РазложенныйПутьКДанным.Количество() > 2 Тогда
				Продолжить;
			ИначеЕсли РазложенныйПутьКДанным.Количество() = 2 Тогда
				Отбор.ИмяРеквизита = РазложенныйПутьКДанным[1];
				Отбор.ЭтоРеквизитФормы = Ложь;
			Иначе
				Отбор.ИмяРеквизита = РазложенныйПутьКДанным[0];
				Отбор.ЭтоРеквизитФормы = Истина;
			КонецЕсли;
			Строки = Форма.ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(Отбор);
			Если Строки.Количество() > 0 Тогда
				Строки[0].БлокируемыеЭлементы.Добавить(ЭлементФормы.Имя);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ОбъектыСЗаблокированнымиРеквизитами()
	
	Объекты = Новый Соответствие;
	ИнтеграцияПодсистемБСП.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	
	Возврат Объекты;
	
КонецФункции

// Возвращает список реквизитов и табличных частей объекта, по которым установлен запрет редактирования,
// а также связанные с ними элементы формы.
// 
// Параметры:
//  ИмяОбъекта - Строка - полное имя объекта метаданных.
//
// Возвращаемое значение:
//  Массив из см. ЗапретРедактированияРеквизитовОбъектов.НовыйБлокируемыйРеквизит
//
Функция БлокируемыеРеквизитыОбъектаИЭлементыФормы(ИмяОбъекта) Экспорт
	
	Результат = Новый Массив;
	
	Объекты = ОбъектыСЗаблокированнымиРеквизитами();
	Если Объекты[ИмяОбъекта] = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	БлокируемыеРеквизиты = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта).ПолучитьБлокируемыеРеквизитыОбъекта();
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииЗаблокированныхРеквизитов(ИмяОбъекта, БлокируемыеРеквизиты);
	
	Для Каждого БлокируемыйРеквизит Из БлокируемыеРеквизиты Цикл
		Если ТипЗнч(БлокируемыйРеквизит) <> Тип("Структура") Тогда
			ЧастиСтроки = СтрРазделить(БлокируемыйРеквизит, ";");
			НовыйБлокируемыйРеквизит = ЗапретРедактированияРеквизитовОбъектов.НовыйБлокируемыйРеквизит();
			НовыйБлокируемыйРеквизит.Имя = СокрЛП(ЧастиСтроки[0]);
			Если ЧастиСтроки.Количество() > 1 Тогда
				Для Каждого ИмяЭлемента Из СтрРазделить(ЧастиСтроки[1], ",", Ложь) Цикл
					НовыйБлокируемыйРеквизит.ЭлементыФормы.Добавить(СокрЛП(ИмяЭлемента));
				КонецЦикла;
			КонецЕсли;
			Если ЧастиСтроки.Количество() > 2 Тогда
				НовыйБлокируемыйРеквизит.Группа = СокрЛП(ЧастиСтроки[2]);
			КонецЕсли;
			Результат.Добавить(НовыйБлокируемыйРеквизит);
		Иначе
			Результат.Добавить(БлокируемыйРеквизит);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
