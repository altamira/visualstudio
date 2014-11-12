
-------------------------------------------------------------------------------
--sp_helptext pr_gera_produto_inventario
-------------------------------------------------------------------------------
--pr_gera_produto_inventario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Tabela Produto Inventário
--                   Especifíco para cada cliente
--                   Sempre analisar antes de processar a procedure
--                   1o. Cliente - Industécnica
--Data             : 11.05.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_produto_inventario
@cd_usuario      int = 0,
@cd_fase_produto int = 0

as

--select * from temp_inv
--select * from tipo_movimento_estoque
--select * from produto_inventario

delete from produto_inventario

select
  p.cd_produto,
  case when qtd<0 then t.qtd * -1 
  else
   t.qtd end                 as qt_inventario,
  @cd_fase_produto           as cd_fase_produto,
  @cd_usuario                as cd_usuario,
  getdate()                  as dt_usuario,
  case when qtd<0 then 11 --saida
                  else 1  --entrada
  end                        as cd_tipo_movimento_estoque

into
  #produto_inventario 
from
  temp_inv t 
  inner join produto p on p.nm_fantasia_produto = t.fantasia

insert into
  produto_inventario
select
  *
from
  #produto_inventario

drop table #produto_inventario

select * from produto_inventario

--select * from tmp_inv
