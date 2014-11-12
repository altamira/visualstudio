CREATE PROCEDURE pr_consulta_contrato_fornecimento
-------------------------------------------------------------------------------
--pr_consulta_contrato_fornecimento
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          	           2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Fabio Cesar Magalhães
--Banco de Dados        : Egissql
--Objetivo              : Lista os contratos de fornecimento
--Data                  : 22/10/2002
--Atualização           : 14/12/2004 - Acerto do Cabeçalho - Sérgio Caedoso
--Atualização           : 23/02/2007 - Mudando order By para Data Desc, Contrato Desc - Anderson
--------------------------------------------------------------------------------
@cd_cliente  as integer,
@cd_vendedor as integer,
@dt_inicial  as DateTime,
@dt_final    as DateTime,
@cd_contrato_interno as varchar(20),
@cd_contrato_fornecimento int
AS

declare @SSQL varchar(2000)

set @SSQL =   'SELECT   '
	    + 'cf.cd_contrato_fornecimento, '
	    + '(Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = cf.cd_cliente) as nm_fantasia_cliente, '
	    + '(Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = cf.cd_vendedor) as nm_fantasia_vendedor, '
	    + 'cf.dt_contrato_fornecimento, '
	    + 'cf.cd_contrato_interno, '
	    + '(Select top 1 nm_condicao_pagamento from condicao_pagamento where cd_condicao_pagamento = cf.cd_condicao_pagamento) as nm_condicao_pagamento, '
	    + '(Select top 1 nm_destinacao_produto from Destinacao_Produto where cd_destinacao_produto = cf.cd_destinacao_produto) as nm_destinacao_produto, '
	    + 'cf.dt_inicial_contrato, '
	    + 'cf.dt_final_contrato '
	    + 'FROM '
	    + 'Contrato_Fornecimento cf '
	    + 'where '
   	    if @cd_contrato_interno <> ''
               set @SSQL  = @SSQL + 'cf.cd_contrato_interno = ' + QuoteName(@cd_contrato_interno,'''')
	    else if @cd_contrato_fornecimento > 0
               set @SSQL  = @SSQL + 'cf.cd_contrato_fornecimento = ' + cast(@cd_contrato_fornecimento as varchar)
	    else
	       set @SSQL  = @SSQL + 'dt_contrato_fornecimento between ' + 
     	                    + QuoteName(cast(@dt_inicial as varchar),'''') + ' and ' + QuoteName(cast(@dt_final as varchar),'''')

   if @cd_cliente > 0
      set @SSQL  = @SSQL + ' and cf.cd_cliente = ' + cast(@cd_cliente as varchar)   

   if @cd_vendedor > 0
   begin
      set @SSQL  = @SSQL + ' and cf.cd_vendedor = ' + cast(@cd_vendedor as varchar)   
   end

   set @SSQL  = @SSQL + 'order by cf.dt_contrato_fornecimento desc, cf.cd_contrato_fornecimento desc'

--   print @SSQL

   Exec(@SSQL)

