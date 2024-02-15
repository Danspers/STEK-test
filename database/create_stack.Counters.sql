-- Счетчики
create table stack.Counters
(
   row_id int GENERATED ALWAYS AS IDENTITY ,
   name text not null,   -- Наименование счетчика
   acc_id int,				 -- row_id Лицевого
   service int not null, -- Услуга (100 - Холодная вода / 200 - Горячая Вода / 300 - Электричество / 400 - Отопление)
   tarif int not null,	 -- Тарифность счетчика (1,2,3) (Показания по скольким тарифам могут быть на счетчике 

   constraint PK_Counters
      primary key (row_id),
   constraint FK_Counters
      foreign key (acc_id)
      references stack.Accounts(row_id)
);