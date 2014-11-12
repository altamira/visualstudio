
-------------------------------------------------------------------------------
--sp_helptext pr_contabilizacao_baan_ativo_fixo
-------------------------------------------------------------------------------
--pr_contabilizacao_baan_ativo_fixo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Contabilização do Ativo Fixo para o Sistema BAAN
--Data             : 17.05.2007
--Alteração        : 
--                 : 
--                 : 
-------------------------------------------------------------------------------
create procedure pr_contabilizacao_baan_ativo_fixo
@ic_parametro    int      = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int      = 0

as

-------------------------------------------------------------------------------
--Débito
-------------------------------------------------------------------------------

select

  --Débito

  d.cd_mascara_conta                    as CONTA,
  cc.cd_mascara_centro_custo            as SETOR,
  cast(null as varchar)                 as PROJETO,
  cast(null as varchar)                 as CCUSTO,
  a.vl_ativo_contabilizacao             as VALOR,
  'D'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  rtrim(ltrim(a.nm_historico_ativo))+' '+
  rtrim(ltrim(a.nm_complemento_ativo))  as HISTORICO

into
  #AtivoBaanDebito
from
  Ativo_Contabilizacao a
  left outer join plano_conta d   on d.cd_conta         = a.cd_conta_debito
  left outer join Centro_Custo cc on cc.cd_centro_custo = a.cd_centro_custo

where
  a.dt_ativo_contabilizacao between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0
order by
  a.dt_ativo_contabilizacao

-------------------------------------------------------------------------------
--Crédito
-------------------------------------------------------------------------------

select

  --Crédito

  c.cd_mascara_conta                    as CONTA,
  cc.cd_mascara_centro_custo            as SETOR,
  null                                  as PROJETO,
  null                                  as CCUSTO,
  a.vl_ativo_contabilizacao             as VALOR,
  'C'                                   as TIPO,
  null                                  as FORNEC,
  null                                  as CLIENTE,
  rtrim(ltrim(a.nm_historico_ativo))+' '+
  rtrim(ltrim(a.nm_complemento_ativo))  as HISTORICO

into
  #AtivoBaanCredito
from
  Ativo_Contabilizacao a
  left outer join plano_conta c   on c.cd_conta         = a.cd_conta_credito
  left outer join Centro_Custo cc on cc.cd_centro_custo = a.cd_centro_custo

where
  a.dt_ativo_contabilizacao between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0
order by
  a.dt_ativo_contabilizacao

insert into
  #AtivoBaanDebito
select
  * 
from
  #AtivoBaanCredito

select * from #AtivoBaanDebito  
  
 

