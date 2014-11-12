
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE pr_doc_pagar_plano_financeiro
-------------------------------------------------------------------------------- 
--GBS - Global Business Solution                2003 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)      : Daniel C. Neto 
--Banco de Dados : EGISSQL 
--Objetivo       : Trazer valores de plano financeiro rateado em documentos.
--Data           : 05/03/2004
------------------------------------------------------------------------------ 

@dt_inicial          datetime,
@dt_final            datetime,
@cd_plano_financeiro int

as 

declare @cd_plano_financeiro_pai int,
		@vl_plano_financeiro float

select     

  pf.cd_plano_financeiro, 
  pf.cd_plano_financeiro_pai, 
  pf.nm_conta_plano_financeiro, 
  pf.sg_conta_plano_financeiro, 
  pf.cd_mascara_plano_financeiro, 
  --Calculando valor emitido no período tirando os cancelamentos
  (select 
     IsNull(sum(dpf.vl_plano_financeiro),0) 
   from 
     Documento_Pagar_Plano_Financ dpf INNER JOIN
     Documento_Pagar dp ON dpf.cd_documento_pagar = dp.cd_documento_pagar 
   where
     dpf.cd_plano_financeiro = pf.cd_plano_financeiro and
     dp.dt_vencimento_documento between @dt_inicial and @dt_final and
     dp.dt_cancelamento_documento is null ) as 'vl_plano_financeiro',

  pf.nm_rotina_atualizacao, 
  pf.cd_grupo_financeiro, 
  pf.cd_usuario, 
  pf.dt_usuario, 
  pf.cd_lancamento_padrao,
  pf.cd_centro_receita,
  pf.ic_conta_analitica , 
  pf.pc_liq_plano_financeiro, 
  pf.cd_centro_custo 

into #Plano

from         
  plano_financeiro pf left outer join
  grupo_financeiro gf on pf.cd_grupo_financeiro = gf.cd_grupo_financeiro
order by 
  pf.cd_mascara_plano_financeiro

------------------------------------------------
-- Pegando todas as que não são contas analíticas.
------------------------------------------------
select * into #PlanoPai from #Plano where ic_conta_analitica = 'N'

--Cria um cursor para atualizar as contas pais
while exists ( select 'x' from #PlanoPai)
begin
  set @cd_plano_financeiro_pai = 
    ( select top 1 cd_plano_financeiro
      from #PlanoPai
      order by len(cd_mascara_plano_financeiro) desc )

	Select 
	   @vl_plano_financeiro = sum(IsNull(vl_plano_financeiro,0))
	from
		#Plano
	where
		cd_plano_financeiro_pai = @cd_plano_financeiro_pai
	
	update 
		#Plano
	set
    vl_plano_financeiro = @vl_plano_financeiro
	where
		cd_plano_financeiro = @cd_plano_financeiro_pai

	delete from #PlanoPai where cd_plano_financeiro = @cd_plano_financeiro_pai

end


SELECT     
  pf.cd_plano_financeiro, 
  dpf.pc_plano_financeiro, 
  dpf.vl_plano_financeiro, 
  dp.cd_identificacao_document, 
  dp.dt_emissao_documento_paga, 
  dp.dt_vencimento_documento, 
  dp.vl_documento_pagar, 
  dp.cd_nota_fiscal_entrada, 
  dp.cd_serie_nota_fiscal_entr, 
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.nm_observacao_documento

into #PlanoDocumento

FROM         
  #Plano pf INNER JOIN
  Documento_Pagar_Plano_Financ dpf ON dpf.cd_plano_financeiro = pf.cd_plano_financeiro INNER JOIN
  Documento_Pagar dp ON dpf.cd_documento_pagar = dp.cd_documento_pagar
where
  dp.dt_vencimento_documento between @dt_inicial and @dt_final and
  dp.dt_cancelamento_documento is null and
  ( ( dpf.cd_plano_financeiro = @cd_plano_financeiro ) or
    ( @cd_plano_financeiro = 0) )


select
  pd.*,
  cast(pf.cd_mascara_plano_financeiro as varchar(30))+' - '+ pf.nm_conta_plano_financeiro as 'PLANOFINANCEIRO',
  pf.cd_mascara_plano_financeiro, 
  pf.nm_conta_plano_financeiro,
  IsNull(pf.ic_conta_analitica,'N') as ic_conta_analitica,
  pf.vl_plano_financeiro as vl_total_plano
from
  #Plano pf left outer join
  #PlanoDocumento pd on pd.cd_plano_financeiro = pf.cd_plano_financeiro
order by
 pf.cd_mascara_plano_financeiro,
 pd.dt_vencimento_documento



