
--sp_helptext pr_composicao_plano_financeiro

--------------------------------------------------------------------------------
CREATE PROCEDURE pr_composicao_plano_financeiro
-------------------------------------------------------------------------------- 
--GBS - Global Business Solution                2007 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EGISSQL 
--Objetivo         : Montagem 
--Data             : 18.07.2007
--Alteração	   : 18.07.2007 
----------------------------------------------------------------------------------------------------------------- 

@cd_plano_financeiro int      = 0,  
@dt_inicial          datetime = '',  
@dt_final            datetime = '' 
  
as   
  
--select * from conta_banco_lancamento  
  
select       
  pf.cd_plano_financeiro,   
  pf.nm_conta_plano_financeiro,   
  pf.sg_conta_plano_financeiro,   
  pf.cd_mascara_plano_financeiro,   
  0.00 as Competencia,
  0.00 as Previsto,
  0.00 as Realizado
  
into #PlanoMovimento  
  
from           
  plano_financeiro pf 
  left outer join  grupo_financeiro gf on pf.cd_grupo_financeiro = gf.cd_grupo_financeiro  
where
  pf.cd_plano_financeiro = case when @cd_plano_financeiro = 0 then pf.cd_plano_financeiro else @cd_plano_financeiro end
order by   
  pf.cd_mascara_plano_financeiro  
  
select 
  *
from
  #PlanoMovimento
order by   
  cd_mascara_plano_financeiro  

