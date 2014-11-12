
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_nota_saida_sem_operacao_fiscal
-------------------------------------------------------------------------------
--pr_consulta_nota_saida_sem_operacao_fiscal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta das Notas Fiscais de Saída e que não geraram 
--                   Operação Fiscal
--
--Data             : 23.04.2009
--Alteração        : 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
--
------------------------------------------------------------------------------
create procedure pr_consulta_nota_saida_sem_operacao_fiscal
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from nota_saida

select
--  ns.cd_nota_saida,

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
  end                                       as cd_nota_saida,

  ns.dt_nota_saida,
  ns.nm_fantasia_nota_saida,
  v.nm_fantasia_vendedor,
  vei.nm_veiculo,
  m.nm_motorista  

from
  Nota_Saida ns               with (nolock) 
  left outer join Vendedor v  with (nolock) on v.cd_vendedor  = ns.cd_vendedor
  left outer join Veiculo vei with (nolock) on vei.cd_veiculo = ns.cd_veiculo
  left outer join Motorista m with (nolock) on m.cd_motorista = ns.cd_motorista
where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  isnull(ns.cd_operacao_fiscal,0)=0
  


