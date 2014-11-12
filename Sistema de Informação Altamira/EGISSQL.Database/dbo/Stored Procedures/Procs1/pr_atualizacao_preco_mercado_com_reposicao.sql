
-------------------------------------------------------------------------------
--pr_atualizacao_preco_mercado_com_reposicao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Atualização do Preço de Mercado com o Preço de Reposição
--Data             : 07.01.2006
--Atualizado       : 07.01.2006
--------------------------------------------------------------------------------------------------
create procedure pr_atualizacao_preco_mercado_com_reposicao
--@dt_inicial datetime,
--@dt_final   datetime

as

--select * from produto_custo

update
  produto_custo
set
  vl_custo_previsto_produto = isnull(vl_custo_produto,0)

