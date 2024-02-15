-- Показания счетчиков
create table stack.Meter_Pok
(
   row_id int GENERATED ALWAYS AS IDENTITY ,
   acc_id int,				-- row_id Лицевого
   counter_id int,		-- row_id счетчика
   value int not null,  -- Расход 
   date date not null,	-- Дата показания
   month date not null, -- Месяц показания
   tarif int not null,	-- Тариф (для 1 тарифного счетчика = 0 ;
                        --        для 2 тарифного счетчика = 0 или 1 ;
                        --        для 3 тарифного счетчика = 0 или 1 или 2 )

   constraint PK_Meter_Pok
      primary key  (row_id),
   constraint FK_Meter_Acc
      foreign key (acc_id) 
      references stack.Accounts(row_id) ,
   constraint FK_Meter_Counters
      foreign key (counter_id) 
      references stack.Counters(row_id)
);