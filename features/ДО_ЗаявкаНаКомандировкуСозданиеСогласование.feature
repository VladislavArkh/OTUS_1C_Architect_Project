﻿#language: ru

@tree

Функционал: <Создание документа Заявка на командировку>

Я хочу
проверить, что документ Заявка на командировку создается и согласуется
чтобы не было ошибок данных  

Сценарий: Ввод документа Заявка на командировку

	*Создание и проведение нового документа
		И В командном интерфейсе я выбираю "ОТУС" "Заявки на командировку"
		Тогда открылось окно "Заявки на командировку"
		И в таблице 'СписокДокументов' я нажимаю на кнопку с именем 'СписокДокументовСоздать'
		Тогда открылось окно "Заявка на командировку (создание)"
		И из выпадающего списка с именем 'Сотрудник' я выбираю по строке "ВА Виноградова Валентина Игоревна"
		И из выпадающего списка с именем 'Организация' я выбираю по строке "ВА ПАО \"РОСТЕЛЕКОМ\""
		И я нажимаю кнопку выбора у поля с именем 'ДатаНачала'
		И в поле с именем 'ДатаНачала' я ввожу текст "16.11.2024"
		И я нажимаю кнопку выбора у поля с именем 'ДатаОкончания'
		И в поле с именем 'ДатаОкончания' я ввожу текст "25.11.2024"
		И из выпадающего списка с именем 'Организация' я выбираю по строке "ВА ПАО \"РОСТЕЛЕКОМ\""
		И из выпадающего списка с именем 'Партнер' я выбираю по строке "ва ростелеком"
		И в поле с именем 'МестоНазначения' я ввожу текст "ВА Место назначения"
		И в поле с именем 'Цель' я ввожу текст "ВА Цель поездки"
		И из выпадающего списка с именем 'Подразделение' я выбираю по строке "Группа мониторинга"
		И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
		И я жду закрытия окна "Заявка на командировку (создание) *" в течение 20 секунд
	
	* Согласование документа
		Когда открылось окно "Заявки на командировку"
		И в таблице 'СписокДокументов' я выбираю текущую строку
		Тогда открылось окно "Заявка на командировку * от * (16.11.2024 - * ВА Место назначения)"
		И из выпадающего списка с именем 'Статус' я выбираю точное значение "Согласовано"
		И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
		И я жду закрытия окна "Заявка на командировку * от * (16.11.2024 - * ВА Место назначения) *" в течение 20 секунд

	* Проверка заполнения		
		
		Тогда открылось окно "Заявки на командировку"
		И в таблице 'СписокДокументов' я выбираю текущую строку
		
		Тогда элемент формы с именем 'БронироватьБилетыОбратно' стал равен "Нет"
		И элемент формы с именем 'БронироватьБилетыТуда' стал равен "Нет"
		И элемент формы с именем 'БронироватьДопИнформация' стал равен ""
		И элемент формы с именем 'БронироватьМестоПроживания' стал равен ""
		И элемент формы с именем 'БронироватьМестоТрансфераОбратно' стал равен ""
		И элемент формы с именем 'БронироватьМестоТрансфераТуда' стал равен ""
		И элемент формы с именем 'БронироватьМестПроживания' стал равен "1"
		И элемент формы с именем 'БронироватьПоездОбратно' стал равен "Нет"
		И элемент формы с именем 'БронироватьПоездТуда' стал равен "Нет"
		И элемент формы с именем 'БронироватьПрибытиеОбратно' стал равен ""
		И элемент формы с именем 'БронироватьПрибытиеОбратноНеПозже' стал равен <25.11.2024 00:00>
		И у элемента формы с именем 'БронироватьПрибытиеОбратноНеПозже' текст редактирования стал равен <25.11.2024 00:00>
		И элемент формы с именем 'БронироватьПрибытиеТуда' стал равен ""
		И элемент формы с именем 'БронироватьПрибытиеТудаНеПозже' стал равен <16.11.2024 00:00>
		И у элемента формы с именем 'БронироватьПрибытиеТудаНеПозже' текст редактирования стал равен <16.11.2024 00:00>
		И элемент формы с именем 'БронироватьПроживание' стал равен "Нет"
		И элемент формы с именем 'БронироватьПроживаниеДатаНачала' стал равен <  .  .    >
		И у элемента формы с именем 'БронироватьПроживаниеДатаНачала' текст редактирования стал равен "  .  .    "
		И элемент формы с именем 'БронироватьПроживаниеДатаОкончания' стал равен <  .  .    >
		И у элемента формы с именем 'БронироватьПроживаниеДатаОкончания' текст редактирования стал равен "  .  .    "
		И элемент формы с именем 'БронироватьСамолетОбратно' стал равен "Нет"
		И элемент формы с именем 'БронироватьСамолетТуда' стал равен "Нет"
		И элемент формы с именем 'БронироватьТрансферОбратно' стал равен "Нет"
		И элемент формы с именем 'БронироватьТрансферТуда' стал равен "Нет"
		И элемент формы с именем 'БронироватьУбытиеОбратно' стал равен ""
		И элемент формы с именем 'БронироватьУбытиеОбратноНеРаньше' стал равен <25.11.2024 00:00>
		И у элемента формы с именем 'БронироватьУбытиеОбратноНеРаньше' текст редактирования стал равен <25.11.2024 00:00>
		И элемент формы с именем 'БронироватьУбытиеТуда' стал равен ""
		И элемент формы с именем 'БронироватьУбытиеТудаНеРаньше' стал равен <16.11.2024 00:00>
		И у элемента формы с именем 'БронироватьУбытиеТудаНеРаньше' текст редактирования стал равен <16.11.2024 00:00>
		И элемент формы с именем 'Валюта' стал равен "руб."
		И элемент формы с именем 'ДатаНачала' стал равен <16.11.2024>
		И у элемента формы с именем 'ДатаНачала' текст редактирования стал равен "16.11.2024"
		И элемент формы с именем 'ДатаОкончания' стал равен <25.11.2024>
		И у элемента формы с именем 'ДатаОкончания' текст редактирования стал равен "25.11.2024"
		И элемент формы с именем 'ДатаПлатежа' стал равен <  .  .    >
		И у элемента формы с именем 'ДатаПлатежа' текст редактирования стал равен "  .  .    "
		И элемент формы с именем 'Декорация1' стал равен "Декорация1"
		И элемент формы с именем 'Закрыта' стал равен "Нет"
		И элемент формы с именем 'ИнформацияОБронировании' стал равен ""
		И элемент формы с именем 'Комментарий' стал равен ""
		И элемент формы с именем 'КомментарийРасходов' стал равен ""
		И элемент формы с именем 'КтоРешил' стал равен "Архипов Владислав Федорович"
		И элемент формы с именем 'МестоНазначения' стал равен "ВА Место назначения"
		И элемент формы с именем 'НадписьСостояниеБронирования' стал равен ""
		И элемент формы с именем 'НадписьФактическаяОплата' стал равен ""
		И элемент формы с именем 'Организация' стал равен "ВА ПАО \"РОСТЕЛЕКОМ\""
		И элемент формы с именем 'Ответственный' стал равен "Горелова Инна Сергеевна"
		И элемент формы с именем 'Партнер' стал равен "ВА РОСТЕЛЕКОМ ПАО - Бурятский филиал"
		И элемент формы с именем 'Подразделение' стал равен "Группа мониторинга"
		И элемент формы с именем 'ПочтовыйАдрес' стал равен ""
		И элемент формы с именем 'ПредполагаемаяСуммаРасходов' стал равен <0,00>
		И у элемента формы с именем 'ПредполагаемаяСуммаРасходов' текст редактирования стал равен "0,00"
		И элемент формы с именем 'Проект' стал равен ""
		И элемент формы с именем 'Сотрудник' стал равен "ВА Виноградова Валентина Игоревна"
		Тогда в таблице 'Сотрудники' количество строк "равно" 0
		И элемент формы с именем 'СписокФизЛиц' стал равен "Нет"
		И элемент формы с именем 'Статус' стал равен "Согласовано"
		И элемент формы с именем 'Телефон' стал равен ""
		И элемент формы с именем 'ФормаОплаты' стал равен "В любой форме"
		И у элемента формы с именем 'ФормаОплаты' текст редактирования стал равен "В любой форме"
		И элемент формы с именем 'Цель' стал равен "ВА Цель поездки"
		И элемент формы с именем 'ЧислоДней' стал равен "10"
		И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
		И я жду закрытия окна "Заявка на командировку * от * (16.11.2024 - * ВА Место назначения)" в течение 20 секунд

	* Установка пометки на удаление
		Когда открылось окно "Заявки на командировку"
		И я выбираю пункт контекстного меню с именем 'СписокДокументовКонтекстноеМенюУстановитьПометкуУдаления' на элементе формы с именем 'СписокДокументов'
		Тогда открылось окно "1С:Предприятие"
		И я нажимаю на кнопку с именем 'Button0'

	* Исключить из объектов интеграции
		И В командном интерфейсе я выбираю "НСИ" "Объекты интеграции"
		Тогда открылось окно "Объекты интеграции: Объекты интеграции"
		И в таблице 'Список' я активизирую поле с именем 'Организация'
		И в таблице 'Список' я нажимаю на кнопку с именем 'СписокНайти'
		Тогда открылось окно "Найти"
		И из выпадающего списка с именем 'Pattern' я выбираю по строке "ВА ПАО \"РОСТЕЛЕКОМ\""
		И я нажимаю на кнопку с именем 'Find'
		Тогда открылось окно "Объекты интеграции: Объекты интеграции"
		И пока в таблице "Список" количество строк ">" 0 Тогда		
			И в таблице 'Список' я удаляю строку
			Тогда открылось окно "1С:Предприятие"
			И я нажимаю на кнопку с именем 'Button0'
			
						
				
				
				
								
						
		
