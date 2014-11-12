
create procedure pr_registro_cadastro_fornecedor
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_cadastro_fornecedor int

set @qt_cadastro_fornecedor = 0

select  
  @qt_cadastro_fornecedor = count(dt_cadastro_fornecedor)
from 
  Fornecedor
where
  dt_cadastro_fornecedor between @dt_inicial and @dt_final  


--Resultado

select 
  @qt_cadastro_fornecedor as 'RegistroCadastroFornecedor'


