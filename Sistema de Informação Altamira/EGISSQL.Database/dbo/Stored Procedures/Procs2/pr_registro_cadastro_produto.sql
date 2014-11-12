
create procedure pr_registro_cadastro_produto
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_cadastro_produto int

select  
  @qt_cadastro_produto = count(dt_cadastro_produto)
from 
  Produto
where
  dt_cadastro_produto between @dt_inicial and @dt_final  

select @qt_cadastro_produto as 'RegistroCadastroProduto'


