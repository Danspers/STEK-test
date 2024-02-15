## Описание

Даны таблицы:
- Лицевые счета (иерархическая таблица). Лицевой счет ссылается на квартиру, квартира на дом. В квартире/доме может быть несколько лицевых, лицевой может быть привязан к дому.
- Счетчики
- Показания счетчиков
  - В таблице хранятся показаний счетчика за расчетный месяц. Показание в месяце может отсутствовать , возможен случай 2 и более показаний по счетчику. в этом случае суммарное потребление это сумма расходов всех показаний за месяц.
  - Тариф используется для учета потребления в определенный момент дня (день/ночь - для 2-х тарифного ) (пик,полупик,ночь - для 3-х тарифного) суммарным расходом по лицевому за месяц будет сумма расхода по всем тарифам счетчика
  - Поле дата хранит в себе дату показаний , необходимо для определения последнего показания . при наличии 2 и более показаний в 1 месяце.

В тексте заданий используется диалект _PostgreSQL_.

## Задание №1

Написать функцию `stack.select_count_pok_by_service`. Она получает строкой номера услуг и дату, а возвращает количество показаний по услуге для каждого лицевого счёта. Результатом вызова функции должна быть таблица с 3 колонками:
- `acc` (Лицевой счет)
- `serv` (Услуга)
- `count` (Количество показаний)

Примеры вызова функции:
```SQL
select * from stack.select_count_pok_by_service('300','20230201')
--number|service|count
--111	 300	 2
--144	 300	 1
--211	 300	 2
--222	 300	 2
--233	 300	 1
--244	 300	 1
--255	 300	 3
--266	 300	 3
--277	 300	 2
--288	 300	 4
--301	 300	 1
```

## Задание №2

Написать функцию `select_value_by_house_and_month`. Она получает номер дома и месяц
и возвращает все лицевые в этом доме , для лицевых выводятся все счетчики с суммарным расходом за месяц ( суммирую все показания тарифов)
Результатом вызова
функции должна быть таблица с 3 колонками:

- `acc` (Лицевой счет)
- `name` (Наименование счетчика)
- `value` (Расход)

Примеры вызова функции:
```SQL
select * from stack.select_last_pok_by_service(1,'20230201')

--number|name|value
--111	Счетчик на воду	          150
--111	Счетчик на отопление	  -50
--111	Счетчик на электричество   80
--122	Счетчик на воду	          105
--122	Счетчик на отопление	    0
--133	Счетчик на воду	          900
--133	Счетчик на отопление	   -1
--144	Счетчик на воду	            0
--144	Счетчик на отопление	   10
--144	Счетчик на электричество  100
```

## Задание №3
Написать функцию `stack.select_last_pok_by_acc`. Она получает номер лицевого
и возвращает дату,тариф,объем последнего показания по каждой услуге
Результатом вызова
функции должна быть таблица с 5 колонками:
- `acc` (Лицевой счет)
- `serv` (Услуга)
- `date` (Дата показания)
- `tarif` (Тариф показания)
- `value` (Объем)

Примеры вызова функции:
```SQL
select * from select_last_pok_by_acc(144)

--acc|serv|date|tarif|value|
--144	100	2023-02-21	1	0
--144	200	2023-02-27	1	0
--144	300	2023-02-28	1	100
--144	400	2023-02-26	1	10
```

```SQL
select * from select_last_pok_by_acc(266)
--266	300	2023-02-27	1	-90
--266	300	2023-02-27	2	0
--266	300	2023-02-27	3	13
```