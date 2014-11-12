
-------------------------------------------------------------------------------
--sp_helptext pr_demonstrativo_entrega
-------------------------------------------------------------------------------
--pr_demonstrativo_entrega
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Demonistrativo de Entrega de Notas
--
--Data             : 12.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_demonstrativo_entrega
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select
  ns.cd_veiculo,
  max(v.nm_veiculo)   as nm_veiculo,
  sum(vl_total)       as vl_total
from
  Nota_Saida ns 
  left outer join veiculo v on v.cd_veiculo = ns.cd_veiculo
where
  ns.dt_nota_saida between @dt_inicial and @dt_final
group by
  ns.cd_veiculo
order by
  2

