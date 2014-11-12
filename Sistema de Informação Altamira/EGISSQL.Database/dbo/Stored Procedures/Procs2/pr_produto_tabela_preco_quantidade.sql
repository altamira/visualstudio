
-------------------------------------------------------------------------------
--sp_helptext pr_produto_tabela_preco_quantidade
-------------------------------------------------------------------------------
--pr_produto_tabela_preco_quantidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Localiza a Tabela de Preço do Produto
--Data             : 19.11.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_produto_tabela_preco_quantidade
@cd_produto int   = 0,
@qt_produto float = 0

as

--select * from tabela_preco_produto
  
-- select
--   t.cd_produto,
--   t.cd_tabela_preco,
--   t.vl_tabela_produto,
--   t.qt_tabela_produto
-- into
--   #TabelaPreco
-- from
--   tabela_preco_produto t with (nolock)
-- where
--   t.cd_produto = @cd_produto
-- order by
--   t.qt_tabela_produto

declare @cd_tabela_preco   int
declare @vl_tabela_produto float

select
  top 1
  --@qt_produto = qt_tabela_preco
  @cd_tabela_preco   = cd_tabela_preco,
  @vl_tabela_produto = vl_tabela_produto
from
  Tabela_Preco_Produto with (nolock) 
where
  cd_produto = @cd_produto           and
  @qt_produto <=  qt_tabela_produto
order by
  qt_tabela_produto 

-- select
--   *
-- from
--   #TabelaPreco
-- order by
--   qt_tabela_produto 

select 
  @cd_tabela_preco   as cd_tabela_preco,
  @vl_tabela_produto as vl_tabela_produto,
  @qt_produto        as qt_tabela_produto



