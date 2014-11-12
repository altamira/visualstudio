
create procedure pr_registro_cadastro_cliente
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_cadastro_cliente int

select  
  @qt_cadastro_cliente = count(dt_cadastro_cliente)
from 
  Cliente
where
  dt_cadastro_cliente between @dt_inicial and @dt_final  

select @qt_cadastro_cliente as 'RegistroCadastroCliente'


