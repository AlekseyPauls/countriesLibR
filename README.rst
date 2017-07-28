============================================
countriesLibR - нормализация названия страны
============================================

--------
Описание
--------

Данный пакет предназначен для нормализации (нахождения корректного) названия страны посредством работы с прилагающейся простейшей базой данных.

---------
Установка
--------- 

С помощью пакета devtools: 

**devtools::install_github("AlekseyPauls/countriesLibR")**

Также есть возможность скачать архив дистрибьюции countriesLibR_1.0.tar.gz из директории dist.

-------
Справка
-------

Чтобы получить информацию о функциях и датасете данного пакета, используйте следующие команды:

?normalize_country_name - функция нормализации

?match_country_name - функция добавления в базу данных

?del_country_name - функция удаления из базы данных

?countries_db - база данных

----------------------
Функции и их аргументы
----------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Нормализация страны - normalize_country_name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Функция имеет вид: **normalize_country_name(posnames, dif_acc=0.2)**

Принимает на вход один обязательный аргумент **posnames** (от "possible names", вектор значений типа **character**) - нормализуемое название, и один необязательный - 
**dif_acc** (от difference accuracy) типа **float** - параметр точности при поиске подходящего ключа в библиотеке, принимающий значения от **0.0** до **1.0** 
(по умолчанию - **0.2**, чем меньше параметр, тем выше точность).

Выдает вектор значений типа **character**, содержащий либо общее название страны, либо "None", если выполнение прошло успешно. Если была 
допущена ошибка в аргументах, то вектор единичный и содержит **"Invalid arguments"**.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Добавление возможного названия страны - match_country_name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Функция имеет вид: **match_country_name(posnames, realnames, priorities="2")**

Принимает на вход два обязательных аргумента **posnames** и **realnames** (векторы типа **character**) - возможные и 
корректные названия соответственно, и один необязательный - **priorities** (вектор типа **character**) - приоритеты ключей, принимающие 
значения **"1"** или **"2"** (по умолчанию - **"2"**) и определяющие, что содержится в ключе: название, сокращение, индекс или 
перевод названия страны, если приоритет равен **"1"**, и все остальное, если приоритет равен **"2"**. Так как большинство ключей, 
подходящих под приоритет **"1"**, уже в базе, то возможно задать приоритет по умолчанию равный **"2"**. 

Выдает единичный вектор **"Invalid argument type"**, если хотя бы один из аргументов задан неправильно (имеет 
некорректный тип или значение) и **"Success"** если добавление прошло успешно.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Удаление возможного названия страны - del_country_name
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Функция имеет вид: **del_country_name(posnames)**

Принимает на вход один обязательный аргумент **posnames** (вектор типа **character**) - возможные названия, которые 
нужно удалить из базы данных.

Выдает единичный вектор **"Invalid argument type"**, если аргумент задан неправильно (имеет некорректный тип или значение) и **"Success"**, если удаление прошло успешно.

----------
Применение
----------

Код, используемый для демонстрации возможностей модуля::

    library(countriesLibR)

    # Вывод корректных названий для вариантов из списка:
    test <- c("USA", "US", "Amurica!!!", "NewYork", "Untgd States of America", "Paris, USA", "agagagag")
    normalize_country_name(test)
    print("-------------------------------------------------------------")
    # Добавление значения
    print("Проверка AddCountryTest на существование: ")
    normalize_country_name("AddCountryTest")
    print("Добавление AddCountryTest: ")
    match_country_name("AddCountryTest", "AddCountryTest")
    print("Проверка AddCountryTest на существование: ")
    normalize_country_name("AddCountryTest")
    print("-------------------------------------------------------------")
    # Удаление значения
    print("Проверка AddCountryTest на существование: ")
    normalize_country_name("AddCountryTest")
    print("Удаление AddCountryTest: ")
    del_country_name("AddCountryTest")
    print("Проверка AddCountryTest на существование: ")
    normalize_country_name("AddCountryTest")
    print("-------------------------------------------------------------")
    # Демонстрация низкой и высокой точности
    print("Testing variant: ololo")
    print("0.7 (low) accurate: ")
    normalize_country_name("ololo", 0.7)
    print("0.2 (standard) accurate: ")
    normalize_country_name("ololo")
    print("0.1 (high) accurate: ")
    normalize_country_name("ololo", 0.1)
    print("Testing variant: Rassiy")
    print("0.7 (low) accurate: ")
    normalize_country_name("Rassiy", 0.7)
    print("0.2 (standard) accurate: ")
    normalize_country_name("Rassiy")
    print("0.1 (high) accurate: ")
    normalize_country_name("Rassiy", 0.1)


Вывод при выполнении данного кода::

    [1] "United States" "United States" "United States" "United States" "United States" "United States"
    [7] "None"
    [1] "-------------------------------------------------------------"
    [1] "Проверка AddCountryTest на существование: "
    [1] "None"
    [1] "Добавление AddCountryTest: "
    [1] "Success"
    [1] "Проверка AddCountryTest на существование: "
    [1] "AddCountryTest"
    [1] "-------------------------------------------------------------"
    [1] "Проверка AddCountryTest на существование: "
    [1] "AddCountryTest"
    [1] "Удаление AddCountryTest: "
    [1] "Success"
    [1] "Проверка AddCountryTest на существование: "
    [1] "None"
    [1] "-------------------------------------------------------------"
    [1] "Testing variant: ololo"
    [1] "0.7 (low) accurate: "
    [1] "Solomon Islands"
    [1] "0.2 (standard) accurate: "
    [1] "None"
    [1] "0.1 (high) accurate: "
    [1] "None"
    [1] "Testing variant: Rassiy"
    [1] "0.7 (low) accurate: "
    [1] "Russia"
    [1] "0.2 (standard) accurate: "
    [1] "Russia"
    [1] "0.1 (high) accurate: "
    [1] "None"

Как видно из результатов, функции делают именно то, что заявлено в их описании.

-----
Тесты
-----

В пакет встроены тесты, позволяющие проверить его функциональность при внесении изменений. Далее идут тесты и их описание:

#. normalize_country_name of simple name - проверяет работу функции **normalize_country_name** на простых входных данных

#. normalize_country_name and punctuation sensitivity - проверяет удаление пунктуации в функции **normalize_country_name**

#. normalize_country_name of upper register - проверяет работу функции **normalize_country_name** на входной строке в верхнем регистре

#. normalize_country_name of low register - проверяет работу функции **normalize_country_name** на входной строке в нижнем регистре

#. normalize_country_name and missed letter - проверяет исправление опечатки типа "пропущенная буква" в функции **normalize_country_name**

#. normalize_country_name and excess letter - проверяет исправление опечатки типа "лишняя буква" в функции **normalize_country_name**

#. normalize_country_name and another letter - проверяет исправление опечатки типа "неправильная буква" в функции **normalize_country_name**

#. normalize_country_name of simple two words name - проверяет работу функции **normalize_country_name** с входной строкой из 2-х слов (разделитель - пробел)

#. normalize_country_name and excess word name - проверяет работу функции **normalize_country_name** с входной строкой из 2-х слов, одно из которых - лишнее

#. normalize_country_name of american_paris_like_construction - проверяет работу приоритета в функции **normalize_country_name**

#. normalize_country_name and standard accuracy result - проверяет вывод функции **normalize_country_name** для несуществующего имени при стандартной точности

#. normalize_country_name and correct accuracy - проверяет ввозможность ввода корректного необязательного аргумента **dif_acc** в функции **normalize_country_name**

#. normalize_country_name and incorrect accuracy type - проверяет ввозможность ввода некорректного (тип) необязательного аргумента **dif_acc** в функции **normalize_country_name**

#. normalize_country_name and incorrect accuracy value - проверяет ввозможность ввода некорректного (значение) необязательного аргумента **dif_acc** в функции **normalize_country_name**

#. normalize_country_name and incorrect posnames - проверяет ввозможность ввода некорректного обязательного аргумента **posnames** в функции **normalize_country_name**

#. del_country_name of non existing object - проверяет удаление несуществующего ключа в функции **del_country_name**

#. match_country_name of simple name - проверяет добавление нового ключа и значения в функции **match_country_name**

#. del_country_name of existing object - проверяет удаление существующего ключа в функции **del_country_name**

#. match_country_name and correct priority - проверяет добавление нового ключа и значения в функции **match_country_name**, причем необязательный аргумент **priority** корректен

#. match_country_name and incorrect priority - проверяет добавление нового ключа и значения в функции **match_country_name**, причем необязательный аргумент **priority** некорректен

#. match_country_name and incorrect keys and values length - проверяет добавление нового ключа и значения в функции **match_country_name**, причем длины аргументов **posnames** и "realnames" неравны
