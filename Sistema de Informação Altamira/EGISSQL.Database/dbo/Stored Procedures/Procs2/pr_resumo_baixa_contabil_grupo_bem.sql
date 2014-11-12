
-------------------------------------------------------------------------------
--pr_resumo_baixa_contabil_grupo_bem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : Egissql
--Objetivo         : Resumo Contábil de Baixa por Grupo de Bem
--Data             : 18.01.2007
------------------------------------------------------------------------------
create procedure pr_resumo_baixa_contabil_grupo_bem
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_grupo_bem int      = 0

as

select
  pc.cd_conta,
  pc.cd_mascara_conta                as ContaAtivo,
  pc.nm_conta                        as Descricao,
  max(gb.nm_grupo_bem)               as Grupo,
  sum(isnull(vb.vl_original_bem,0))  as Baixa
into
  #ResumoContabilAtivo
from
  Plano_Conta pc 
  inner join Bem b             on b.cd_conta      = pc.cd_conta
  inner join Valor_Bem vb      on vb.cd_bem       = b.cd_bem
  left outer join Grupo_Bem gb on gb.cd_grupo_bem = b.cd_grupo_bem 
where
  isnull(b.cd_grupo_bem,0) = case when isnull(@cd_grupo_bem,0)=0 then b.cd_grupo_bem else isnull(@cd_grupo_bem,0) end and
  b.dt_baixa_bem between @dt_inicial and @dt_final
group by
  pc.cd_conta,
  pc.cd_mascara_conta,
  pc.nm_conta        
order by
  pc.cd_mascara_conta 

select
  cd_conta,
  ContaAtivo,
  Descricao,
  cast(Baixa as decimal(25,2)) as Baixa,
  Grupo
from
  #ResumoContabilAtivo
order by 
  ContaAtivo
