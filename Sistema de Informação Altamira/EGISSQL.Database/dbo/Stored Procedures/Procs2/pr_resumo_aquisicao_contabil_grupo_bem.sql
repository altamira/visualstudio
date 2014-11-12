
-------------------------------------------------------------------------------
--pr_resumo_aquisicao_contabil_grupo_bem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo Contábil de Aquisição por Grupo de Bem
--Data             : 26.12.2006
--Alteração        : 26.12.2006
--Alteração        : 28.12.2006 - Adiciondo filtros - Anderson
--                 : 23.01.2007 - Valor Residual Bem - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_resumo_aquisicao_contabil_grupo_bem
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_grupo_bem int      = 0

as

--select * from grupo_bem
--select * from valor_bem

select
  pc.cd_conta,
  pc.cd_mascara_conta                as ContaAtivo,
  pc.nm_conta                        as Descricao,
  max(gb.nm_grupo_bem)               as Grupo,
  sum(isnull(vb.vl_original_bem,0))  as Aquisicao,
  sum(isnull(vb.vl_residual_bem,0))  as Residual
into
  #ResumoContabilAtivo
from
  Plano_Conta pc 
  inner join Bem b             on b.cd_conta      = pc.cd_conta
  inner join Valor_Bem vb      on vb.cd_bem       = b.cd_bem
  left outer join Grupo_Bem gb on gb.cd_grupo_bem = b.cd_grupo_bem 
where
  isnull(b.cd_grupo_bem,0) = case when isnull(@cd_grupo_bem,0)=0 then b.cd_grupo_bem else isnull(@cd_grupo_bem,0) end
group by
  pc.cd_conta,
  pc.cd_mascara_conta,
  pc.nm_conta        
order by
  pc.cd_mascara_conta 

--select cd_conta,cd_grupo_bem,* from bem
--select * from bem

select
  cd_conta,
  ContaAtivo,
  Descricao,
  cast(Aquisicao as decimal(25,2)) as Aquisicao,
  cast(Residual  as decimal(25,2)) as Residual,
  Grupo
from
  #ResumoContabilAtivo
order by 
  ContaAtivo
