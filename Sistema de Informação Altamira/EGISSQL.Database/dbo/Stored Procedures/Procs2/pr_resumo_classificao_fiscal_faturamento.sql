
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_classificao_fiscal_faturamento
-------------------------------------------------------------------------------
--pr_resumo_classificao_fiscal_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo da Classificação Fiscal
--
--Data             : 12.08.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_resumo_classificao_fiscal_faturamento
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from nota_saida_item
--select * from classificacao_fiscal

select
  max(substring(cf.cd_mascara_classificacao,1,2)) as Grupo,
  cf.cd_classificacao_fiscal,
  cf.cd_mascara_classificacao,
  round(sum(cast(vl_total_item as numeric(25,2))),2)                     as vl_total
  
from
  nota_saida_item i                         with (nolock) 
  inner join nota_saida ns                  with (nolock) on ns.cd_nota_saida             = i.cd_nota_saida
  inner join classificacao_fiscal cf        with (nolock) on cf.cd_classificacao_fiscal   = i.cd_classificacao_fiscal
  left outer join Operacao_Fiscal op        with (nolock) on op.cd_operacao_fiscal        = i.cd_operacao_fiscal
  left outer join Grupo_Operacao_Fiscal gop with (nolock) on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.cd_status_nota <> 7                              
  and

--alterado em 03.06.2010 - Carlos Fernandes

  gop.cd_tipo_operacao_fiscal = 2                    and -- SAIDA
  isnull(op.ic_comercial_operacao,'N')='S'           and
  isnull(op.ic_analise_op_fiscal,'N') ='S'
  
--select * from operacao_fiscal

group by
  cf.cd_classificacao_fiscal,
  cf.cd_mascara_classificacao

order by
  cf.cd_mascara_classificacao

