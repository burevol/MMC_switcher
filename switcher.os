#Использовать v8find
#Использовать 1commands

Перем Ф;
Перем ВЫСОТА_КНОПКИ;
Перем ШИРИНА_КНОПКИ;
Перем ШИРИНА_ОТСТУПА;
Перем ВЫСОТА_ОТСТУПА;
Перем СписокПлатформ;
Перем КоличествоКнопок;

Процедура НачальныеУстановки()
   
    ВЫСОТА_КНОПКИ = 30;
    ШИРИНА_КНОПКИ = 75;
    ВЫСОТА_ОТСТУПА = 10;
    ШИРИНА_ОТСТУПА = 10;
    ПодключитьВнешнююКомпоненту("OneScriptForms.dll");
    Ф = Новый ФормыДляОдноСкрипта();
    СписокПлатформ = ПолучитьСоответствиеПлатформ();
    КоличествоКНопок = СписокПлатформ.Количество();

КонецПроцедуры

Функция ПолучитьСоответствиеПлатформ()

    СоответствиеПлатформ = Новый Соответствие;

    СписокУстановленныхПлатформ = Платформа1С.ПолучитьТаблицуУстановленныхВерсий();
    Для Каждого УстановленнаяВерсия Из СписокУстановленныхПлатформ Цикл
        ПутьКПредприятию = Платформа1С.ПутьКПредприятию(УстановленнаяВерсия.НомерВерсии, УстановленнаяВерсия.Разрядность);
        ФайлПредприятия = Новый Файл(ПутьКПредприятию);
        СоответствиеПлатформ.Вставить(УстановленнаяВерсия.НомерВерсии, ФайлПредприятия.Путь)
    КонецЦикла;

    Возврат СоответствиеПлатформ;
КонецФункции

Функция ПриНажатииКнопки() Экспорт
    ИмяФайла = Ф.АргументыСобытия.Параметр + "radmin.dll";
    Если Новый Файл(ИмяФайла).Существует() Тогда
        Команда = Новый Команда;
        Команда.УстановитьСтрокуЗапуска("powershell Start ""regsvr32.exe"" -Verb RunAs -Argument '""""""" + ИмяФайла + """""""' ");
        КодВозврата = Команда.Исполнить();
        Сообщить(КодВозврата);
        Сообщить(Команда.ПолучитьВывод());
    Иначе
        Ф.ОкноСообщений().Показать("Не найдена библиотека управления сервером", "Ошибка", Ф.КнопкиОкнаСообщений.ОК, Ф.ЗначокОкнаСообщений.Восклицание);
    КонецЕсли;
КонецФункции

Процедура ОтобразитьКнопки(Группа)

    Индекс = 0;
    Для Каждого Платформа Из СписокПлатформ Цикл
        Кнопка = Группа.ЭлементыУправления.Добавить(Ф.Кнопка());
        Кнопка.Границы = Ф.Прямоугольник(ШИРИНА_ОТСТУПА, ВЫСОТА_КНОПКИ * Индекс + ВЫСОТА_ОТСТУПА, ШИРИНА_КНОПКИ, ВЫСОТА_КНОПКИ);
        Кнопка.Текст = Платформа.Ключ;
        Кнопка.Нажатие = Ф.Действие(ЭтотОбъект, "ПриНажатииКнопки", Платформа.Значение);
        Индекс = Индекс + 1;
    КонецЦикла;

КонецПроцедуры

Функция СоздатьГруппуКнопок(ФормаПриложения)
    ГруппаКнопок = Ф.РамкаГруппы();
    ГруппаКнопок.Родитель = ФормаПриложения;
    ГруппаКнопок.Границы = Ф.Прямоугольник(
        ШИРИНА_ОТСТУПА, 
        ВЫСОТА_ОТСТУПА, 
        ШИРИНА_КНОПКИ + ШИРИНА_ОТСТУПА * 2, 
        КоличествоКНопок * ВЫСОТА_КНОПКИ + КоличествоКНопок * ВЫСОТА_ОТСТУПА);

    Возврат ГруппаКнопок;
КонецФункции

НачальныеУстановки();

Форма1 = Ф.Форма();
Форма1.Текст = "Переключатель версий MMC консоли";
Форма1.Отображать = Истина;
Форма1.Ширина = ШИРИНА_КНОПКИ + ШИРИНА_ОТСТУПА * 4;
Форма1.Высота =  КоличествоКНопок * ВЫСОТА_КНОПКИ + КоличествоКНопок * ВЫСОТА_ОТСТУПА + 60;
Форма1.Показать();
Форма1.Активизировать();

ГруппаКнопок = СоздатьГруппуКнопок(Форма1);
ОтобразитьКнопки(ГруппаКнопок);
Ф.ЗапуститьОбработкуСобытий();
