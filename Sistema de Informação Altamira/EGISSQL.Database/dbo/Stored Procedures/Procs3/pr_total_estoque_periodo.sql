
-------------------------------------------------------------------------------
--pr_total_estoque_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 30.03.2005
--Atualizado       : 30.03.2005
--------------------------------------------------------------------------------------------------
create procedure pr_total_estoque_periodo
@dt_inicial datetime,
@dt_final   datetime
as

select
  sum(ps.qt_saldo_atual_produto * pc.vl_custo_produto) as TotalEstoquePeriodo
from 
  produto_saldo ps 
  left outer join produto_custo pc on pc.cd_produto = ps.cd_produto
where
  ps.qt_saldo_atual_produto >0  


