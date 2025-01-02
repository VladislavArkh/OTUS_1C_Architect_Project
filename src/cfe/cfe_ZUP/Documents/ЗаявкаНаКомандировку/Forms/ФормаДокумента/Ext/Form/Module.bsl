﻿
&НаСервере
Процедура ОТУС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ГруппаОТУС_ДО = ЭтаФорма.Элементы.Добавить("ГруппаОбычная", Тип("ГруппаФормы"),ЭтаФорма.Элементы.ОсновныеРеквизиты);
	ГруппаОТУС_ДО.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаОТУС_ДО.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаОТУС_ДО.ОтображатьЗаголовок = ЛОЖЬ; 
	ГруппаОТУС_ДО.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	
	НовыйЭлемент = ЭтаФорма.Элементы.Добавить("ОТУС_НомерВходящегоДокумента", Тип("ПолеФормы"),ГруппаОТУС_ДО);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.ОТУС_НомерВходящегоДокумента";
	НовыйЭлемент.Доступность = Ложь;
	
	НовыйЭлемент = ЭтаФорма.Элементы.Добавить("ОТУС_ДатаВходящегоДокумента", Тип("ПолеФормы"),ГруппаОТУС_ДО);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.Заголовок = "от";
	НовыйЭлемент.ПутьКДанным = "Объект.ОТУС_ДатаВходящегоДокумента";
	НовыйЭлемент.Доступность = Ложь;
КонецПроцедуры
