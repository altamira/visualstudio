
--sp_helptext pr_apuracao_pis_cofins_depreciacao

-------------------------------------------------------------------------------
--pr_resumo_local_apuracao_pis_cofins_depreciacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 28.04.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_apuracao_pis_cofins_depreciacao
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from bem
--select * from tipo_bem
--select * from centro_custo
--select * from valor_bem
--select * from valor_bem_fechamento

--Buscar da Tabela de Imposto / Imposto_Aliquota

declare @pc_pis    decimal(25,2)
declare @pc_cofins decimal(25,2)

set @pc_pis    = (1.65/100)
set @pc_cofins = (7.6/100)


select
 
  b.cd_bem,
  b.cd_patrimonio_bem,
  b.nm_bem,
  cc.cd_centro_custo,
  cc.cd_mascara_centro_custo,
  cc.nm_centro_custo,
  case when isnull(vb.pc_producao_bem,0)>0 
  then
    vb.pc_producao_bem
  else
    cc.pc_producao_ativo end                                       as pc_producao_ativo,

  isnull(vbf.vl_depreciacao_bem,0)                                 as vl_depreciacao_bem,

  vbf.vl_depreciacao_bem * 
      (case when isnull(vb.pc_producao_bem,0)>0 
      then vb.pc_producao_bem 
      else cc.pc_producao_ativo end /100) * @pc_cofins             as cofins,

  vbf.vl_depreciacao_bem *
       (case when isnull(vb.pc_producao_bem,0)>0 
      then vb.pc_producao_bem 
      else cc.pc_producao_ativo end /100) * @pc_pis                as pis,

  vbf.vl_depreciacao_bem * 
      (case when isnull(vb.pc_producao_bem,0)>0 
      then vb.pc_producao_bem 
      else cc.pc_producao_ativo end /100) * @pc_cofins +

  vbf.vl_depreciacao_bem * 
      (case when isnull(vb.pc_producao_bem,0)>0 
      then vb.pc_producao_bem 
      else cc.pc_producao_ativo end /100) * @pc_pis                as Credito

from
  bem b                                    with (nolock) 
  inner join Centro_Custo cc               with (nolock) on cc.cd_centro_custo    = b.cd_centro_custo
  inner join Valor_Bem vb                  with (nolock) on vb.cd_bem             = b.cd_bem
  left outer join Tipo_Bem tb              with (nolock) on tb.cd_tipo_bem        = b.cd_tipo_bem
  left outer join Valor_Bem_Fechamento vbf with (nolock) on vbf.dt_bem_fechamento = @dt_final and
                                                            vbf.cd_bem            = b.cd_bem
where
  isnull(tb.ic_pis_cofins_tipo_bem,'N') = 'S' and
  isnull(vbf.vl_depreciacao_bem,0) > 0        and
  isnull(b.cd_tipo_bem,0)>0
order by
  cc.cd_mascara_centro_custo,
  b.cd_patrimonio_bem

