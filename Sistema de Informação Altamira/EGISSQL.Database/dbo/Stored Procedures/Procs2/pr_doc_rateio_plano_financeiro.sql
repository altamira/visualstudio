
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE pr_doc_rateio_plano_financeiro
-------------------------------------------------------------------------------- 
--GBS - Global Business Solution                2003 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)      : Daniel C. Neto 
--Banco de Dados : EGISSQL 
--Objetivo       : Trazer valores de plano financeiro por rateio de documentos.
--Data           : 16/02/2004
------------------------------------------------------------------------------ 

@dt_inicial          datetime,
@dt_final            datetime,
@cd_plano_financeiro int

as 

declare @cd_plano_financeiro_temp int,
		@vl_plano_financeiro_previsto float,
		@vl_plano_financeiro_realizado float,
    @vl_emitido_periodo float

SELECT     
  dpf.cd_plano_financeiro, 
  dpf.pc_plano_financeiro, 
  dpf.vl_plano_financeiro, 
  dp.cd_identificacao_document, 
  dp.dt_emissao_documento_paga, 
  dp.dt_vencimento_documento, 
  dp.vl_documento_pagar, 
  dp.cd_nota_fiscal_entrada, 
  dp.cd_serie_nota_fiscal_entr, 
  cast(pf.cd_mascara_plano_financeiro as varchar(30))+' - '+ pf.nm_conta_plano_financeiro as 'PLANOFINANCEIRO',
  pf.cd_mascara_plano_financeiro, 
  pf.nm_conta_plano_financeiro,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.nm_observacao_documento,
  IsNull(pf.ic_conta_analitica,'N') as ic_conta_analitica,
  pf.cd_plano_financeiro_pai
into #PlanoFinanceiro

FROM         
  Documento_Pagar_Plano_Financ dpf INNER JOIN
  Documento_Pagar dp ON dpf.cd_documento_pagar = dp.cd_documento_pagar INNER JOIN
  Plano_Financeiro pf ON dpf.cd_plano_financeiro = pf.cd_plano_financeiro
where
   dp.dt_vencimento_documento between @dt_inicial and @dt_final and 
   dp.dt_cancelamento_documento is null and
   ( ( dpf.cd_plano_financeiro = @cd_plano_financeiro ) or
     ( @cd_plano_financeiro = 0) )
order by
 pf.cd_mascara_plano_financeiro,
 dp.dt_vencimento_documento






------------------------------------------------
-- Pegando todas as que não são contas analíticas.
------------------------------------------------
select * into #PlanoFinanceiroPai from #PlanoFinanceiro where ic_conta_analitica = 'N'

--Cria um cursor para atualizar as contas pais
declare crPlano cursor for
   select cd_plano_financeiro
   from #PlanoFinanceiroPai
   order by len(cd_mascara_plano_financeiro) desc

open crPlano

FETCH NEXT FROM crPlano INTO @cd_plano_financeiro_temp
while @@FETCH_STATUS = 0 
begin
	Select 
	   @vl_plano_financeiro_previsto = sum(IsNull(vl_plano_financeiro,0))
	from
		#PlanoFinanceiro
	where
		cd_plano_financeiro_pai = @cd_plano_financeiro_temp
	
	update 
		#PlanoFinanceiro
	set
		vl_plano_financeiro = @vl_plano_financeiro_previsto
	where
		cd_plano_financeiro = @cd_plano_financeiro	

	FETCH NEXT FROM crPlano INTO @cd_plano_financeiro_temp
end
CLOSE crPlano
DEALLOCATE crPlano

select * from #PlanoFinanceiro order by cd_mascara_plano_financeiro

