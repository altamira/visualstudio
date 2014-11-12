----------------------------------------------------------------------------------
--pr_composicao_saldo_fornecedor
----------------------------------------------------------------------------------
--Global Business Solution Ltda                                               2004
----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000  
--Autor(es)           : Carlos Cardoso Fernandes         
--Objetivo            : Composição de Saldos do Fornecedor
--Data                : 05.Novembro.2001
--Atualizado          : 12/03/2002 - Acerto no filtro quanto a faixa de data de pagamento.
--                                   Anteriormente trazia somente os docs em aberto. - ELIAS
--                    : 20/04/2002 - Migração p/ EGISSQL - Elias
--                    : 21/05/2002 - Migração p/ uso das tabelas do EGIS - Elias
--                    : 18/05/2004 - Acerto na coluna saldo que deve sempre trazer o que
--                                   foi pago até o periodo - ELIAS
--                    : 15/07/2004 - Acerto para retornar 0 quando vazio nos campos de valor (isnull) - ELIAS
--                                   Também foi incluído max na sentenca de comparação com o documento_pagar e seus
--                                   pagamentos que gerava erro de sub-query retornando mais do que um valor - ELIAS 
--                    : 07/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
-- 13/01/2005 - Não trazer documentos com saldo zerado - Daniel C. Neto.
-----------------------------------------------------------------------------------

create procedure pr_composicao_saldo_fornecedor 
@ic_parametro           int,
@nm_fantasia_fornecedor char(15),
@dt_inicial             datetime,
@dt_final               datetime
as 

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta apenas o fornecedor passado
-------------------------------------------------------------------------------
  begin

	declare @cd_fornecedor int

	select @cd_fornecedor = cd_fornecedor from Fornecedor
	where  nm_fantasia_fornecedor = @nm_fantasia_fornecedor

   	select	
		f.cd_fornecedor								as cd_fornecedor,
		f.nm_fantasia_fornecedor						as raz_cli,
		ner.cd_rem								as cd_rem,
		ner.dt_rem								as dt_rem,
		dp.cd_identificacao_document						as cd_documento_pagar,
		dp.dt_emissao_documento_paga						as dt_emissao,
		dp.dt_vencimento_documento						as dt_vencimento,
		dp.vl_documento_pagar							as vl_documento,
		dp.vl_saldo_documento_pagar 						as vl_saldo,
    		(isnull(dp.vl_documento_pagar,0) - 
		isnull(dp.vl_saldo_documento_pagar,0)) 					as Pagamento,
		cast(null as char(4)) 							as cd_serie
		
	from fornecedor f	
	inner join nota_entrada_registro	ner	on ner.cd_fornecedor		= f.cd_fornecedor
	inner join documento_pagar		dp	on dp.cd_nota_fiscal_entrada	= ner.cd_nota_entrada
	left join documento_pagar_pagamento	dpp	on dpp.cd_documento_pagar	= dp.cd_documento_pagar	

	where	f.cd_fornecedor		= @cd_fornecedor
	and	ner.dt_rem		between (@dt_inicial) and (@dt_final)

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- consulta geral (Todos os Fornecedores)
-------------------------------------------------------------------------------
  begin

   	select	
		f.cd_fornecedor								as cd_fornecedor,
		f.nm_fantasia_fornecedor						as raz_cli,
		ner.cd_rem								as cd_rem,
		ner.dt_rem								as dt_rem,
		dp.cd_identificacao_document						as cd_documento_pagar,
		dp.dt_emissao_documento_paga						as dt_emissao,
		dp.dt_vencimento_documento						as dt_vencimento,
		dp.vl_documento_pagar							as vl_documento,
		dp.vl_saldo_documento_pagar 						as vl_saldo,
    		(isnull(dp.vl_documento_pagar,0) - 
		isnull(dp.vl_saldo_documento_pagar,0)) 					as Pagamento,
		cast(null as char(4)) 							as cd_serie
		
	from fornecedor f	
	inner join nota_entrada_registro	ner	on ner.cd_fornecedor		= f.cd_fornecedor
	inner join documento_pagar		dp	on dp.cd_nota_fiscal_entrada	= ner.cd_nota_entrada
	left join documento_pagar_pagamento	dpp	on dpp.cd_documento_pagar	= dp.cd_documento_pagar	

	where	ner.dt_rem	between (@dt_inicial) and (@dt_final)

  end


