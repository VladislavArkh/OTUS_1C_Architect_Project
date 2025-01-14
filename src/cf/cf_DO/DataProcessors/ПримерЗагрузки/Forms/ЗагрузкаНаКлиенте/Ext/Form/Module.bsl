﻿#Область ПодключитьКомпоненту    

&НаКлиенте
Процедура ПодключитьКомпонентуТест(Команда)
	Подключить();
КонецПроцедуры

&НаКлиенте
Асинх Процедура Подключить()
    Подключено = Ждать ПодключитьВнешнююКомпонентуАсинх("ОбщийМакет.PinkRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native);
    
    Если Подключено Тогда
    	ПоказатьПредупреждение(, "Компонента подключена");
    Иначе
        Ждать УстановитьВнешнююКомпонентуАсинх("ОбщийМакет.PinkRabbitMQ");
        Подключено = Ждать ПодключитьВнешнююКомпонентуАсинх("ОбщийМакет.PinkRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native);
        Если Подключено Тогда
            ПоказатьПредупреждение(, "Компонента подключена");
        Иначе
            ПоказатьПредупреждение(, "Не удалось подключить внешнюю компоненту");
        КонецЕсли;
    КонецЕсли;
КонецПроцедуры 

#КонецОбласти

#Область Взаимодействие    
&НаКлиенте
Асинх Процедура ПроверитьПодключение(Команда)
	Настройки = ПолучитьНастройки();
	
	Компонента = Ждать RebbitMQКлиент.ПолучитьКомпоненту();
	
	RebbitMQКлиентСервер.ПроверитьПодключение(Компонента, Настройки);	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ОтправитьСообщение(Команда)  
	ИмяТочкиОбмена = "DO";
	КлючМаршрута = "key";
	ОтправляемоеСообщение = Сообщение; 
	
	Компонента = Ждать RebbitMQКлиент.ПолучитьКомпоненту();
	
	Компонента.Connect("localhost", 5672, "guest", "guest", "/");
	Компонента.BasicPublish(ИмяТочкиОбмена, КлючМаршрута, ОтправляемоеСообщение, 0, Ложь);   
	Сообщить("Отправили сообщение " + ОтправляемоеСообщение);
	
	////////////////////////////работают оба варианта/////////////////////////////////////////////////////
	
	//Настройки = ПолучитьНастройки();
	//
	//Компонента = Ждать RebbitMQКлиент.ПолучитьКомпоненту();
	//
	//RebbitMQКлиентСервер.ОтправитьСообщение(Компонента, Настройки, Сообщение);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПолучитьСообщение(Команда) 
	ИмяОчереди = "projectDO";
	
	НеЖдать = Ложь; //noConfirm
	ТегСообщения = 0;
	ОтветноеСообщение = "";
	
	Компонента = Ждать RebbitMQКлиент.ПолучитьКомпоненту();
	
	Компонента.Connect("localhost", 5672, "guest", "guest", "/");
	Потребитель = Компонента.BasicConsume(ИмяОчереди, "", НеЖдать, Ложь, 0);
	Если Компонента.BasicConsumeMessage("", ОтветноеСообщение, ТегСообщения, 100) Тогда
		Компонента.BasicAck(ТегСообщения);
		Сообщить(СтрШаблон("Из очереди прочитано сообщение %1 с тегом %2", ОтветноеСообщение, ТегСообщения));
		Ответ = ОтветноеСообщение;
		ОтветноеСообщение = "";
		ТегСообщения = 0;
	Иначе
		Сообщить("Очередь пуста");
	КонецЕсли;
	Компонента.BasicCancel("");

	/////////////////////////////работают оба варианта////////////////////////////////////////////////////
	
	//Настройки = ПолучитьНастройки();
	//
	//Компонента = Ждать RebbitMQКлиент.ПолучитьКомпоненту();
	//
	//Ответ = RebbitMQКлиентСервер.ПрочитатьСообщение(Компонента, Настройки);
КонецПроцедуры

#КонецОбласти

#Область Служебные  

&НаСервере
Функция ПолучитьНастройки()
	Настройки = RebbitMQСервер.ПолучитьНастройкиПодключенияИзРегистра();
	Возврат Настройки;
КонецФункции

#КонецОбласти

