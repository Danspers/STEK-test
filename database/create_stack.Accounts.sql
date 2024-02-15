-- Лицевые счета
create table stack.Accounts
(
   row_id int GENERATED ALWAYS AS IDENTITY ,
   parent_id int, -- row_id родительской записи
   number int,		-- Номер лицевого счета
   type int,		-- Тип записи (1 - Дом, 2- Квартира, 3 - Лицевой счет)

   constraint PK_Accounts
      primary key (row_id),
   constraint FK_Accounts_Folder 
      foreign key (parent_id) 
      references stack.Accounts(row_id)
      on delete no action
      on update no action
);