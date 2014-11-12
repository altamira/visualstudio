
-------------------------------------------------------------------------------
--pr_resumo_depreciacao_contabil_grupo_bem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql5
--Objetivo         : Resumo Contábil de Depreciação por Grupo de Bem
--Data             : 26.12.2006
--Alteração        : 26.12.2006
------------------------------------------------------------------------------
create procedure pr_resumo_depreciacao_contabil_grupo_bem
@dt_inicial            datetime = '',
@dt_final              datetime = '',
@cd_grupo_bem          int = 0,
@cd_tipo_calculo_ativo int = 1
as

--select * from grupo_bem
--select * from valor_bem
--select * from calculo_bem

select
  pc.cd_conta,
  pc.cd_mascara_conta               as ContaAtivo,
  pc.nm_conta                       as Descricao,
  sum(isnull(vb.vl_original_bem,0)) as Aquisicao,
  sum(isnull(vb.vl_baixa_bem,0))    as Baixa,
  sum(isnull(vb.vl_residual_bem,0)) as Residual,
  max(gb.nm_grupo_bem)              as Grupo,
  sum(isnull(cb.vl_calculo_bem,0))  as Depreciacao
into
  #ResumoContabilDepreciacaoAtivo

from
  Plano_Conta pc 
  inner join Bem b               on b.cd_conta      = pc.cd_conta
  inner join Valor_Bem vb        on vb.cd_bem       = b.cd_bem
  left outer join Grupo_Bem gb   on gb.cd_grupo_bem = b.cd_grupo_bem      
  left outer join Calculo_Bem cb on cb.cd_bem       = b.cd_bem   and
                                    dt_calculo_bem  = @dt_final  and
                                    cd_tipo_calculo_ativo = @cd_tipo_calculo_ativo
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
  cast(Aquisicao   as decimal(25,2)) as Aquisicao,
  cast(Baixa       as decimal(25,2)) as Baixa,
  cast(Depreciacao as decimal(25,2)) as Depreciacao,
  cast(Residual    as decimal(25,2)) as Residual,
  Grupo
from
  #ResumoContabilDepreciacaoAtivo
order by 
  ContaAtivo


  
