
-------------------------------------------------------------------------------
--pr_depreciacao_contabil_analitico_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Bens do Ativo por Conta Contábil - Analítico
--Data             : 28.12.2006
------------------------------------------------------------------------------
create procedure pr_depreciacao_contabil_analitico_ativo
@dt_inicial            datetime = '',
@dt_final              datetime = '',
@cd_conta              int      = 0,
@cd_tipo_calculo_ativo int = 1
as

--select * from grupo_bem
--select * from valor_bem

select
  pc.cd_conta,
  pc.cd_mascara_conta                as ContaAtivo,
  pc.nm_conta                        as Descricao,
  gb.nm_grupo_bem                    as Grupo,
  b.cd_bem,
  b.cd_patrimonio_bem                as Patrimonio,
  b.nm_bem                           as Bem,                           
  cast(isnull(cb.vl_calculo_bem,0)  
  as decimal(25,2))                  as Depreciacao
  --Data de Aquisição
  --Fornecedor
  --Nota
  --Serie
  --Centro de Custo
  --Departamento  
  --Localização
  --Planta
  
from
  Plano_Conta pc 
  inner join Bem b               on b.cd_conta      = pc.cd_conta
  left outer join Grupo_Bem gb   on gb.cd_grupo_bem = b.cd_grupo_bem      
  left outer join Calculo_Bem cb on cb.cd_bem       = b.cd_bem   and
                                    dt_calculo_bem  = @dt_final  and
                                    cd_tipo_calculo_ativo = @cd_tipo_calculo_ativo
where
  pc.cd_conta = case when @cd_conta = 0 then pc.cd_conta else @cd_conta end

order by
  pc.cd_conta,
  b.cd_patrimonio_bem


--select cd_conta,cd_grupo_bem,* from bem
--select * from bem
--select * from plano_conta
 
