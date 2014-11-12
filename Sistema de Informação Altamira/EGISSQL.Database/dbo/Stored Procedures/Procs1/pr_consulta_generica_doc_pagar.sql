

CREATE PROCEDURE pr_consulta_generica_doc_pagar
------------------------------------------------------------------
--pr_consulta_generica_doc_pagar
------------------------------------------------------------------ 
--GBS - Global Business Solution Ltda                         2004
------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000 
--Autor(es)            : Daniel C. Neto 
--Banco de Dados       : EGISSQL 
--Objetivo             : Consultar Duplicatas a Pagar
--Data                 : 30/10/2002 
-- Atualizado          : 20/12/2002 - Inclusão de campo Identificação de Pagamento - Daniel C. Neto.
--                     : 10/04/2003 - Estrutura da SP para validação de valor - DUELA         
--                     : 17/07/2003 - Adicionado GROUP somente pelo Documento (Sem repetição por Pagamento)       
--                     : 07/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
-- 31.03.2010 - Novo Campo - Código do Plano Financeiro - Carlos Fernandes
------------------------------------------------------------------------------ 

@ic_emissao         int,  -- 1 para Sim, 0 para Não
@dt_inicial_emissao datetime,
@dt_final_emissao   datetime,

@ic_vencimento   int,
@dt_inicial_venc datetime,
@dt_final_venc   datetime,

@ic_pagamento     int,
@dt_inicial_pagto datetime,
@dt_final_pagto   datetime,

@ic_canc_dev         int,
@dt_inicial_canc_dev datetime,
@dt_final_canc_dev   datetime,

/* Atencão! Valores para tipo de favorecido:
    - 1 - Empresa Diversa
    - 2 - Funcionario
    - 3 - Fornecedor
    - 4 - Contrato   */

@cd_tipo_favorecido int,
@cd_favorecido      varchar(30),

@cd_tipo_documento   int,
@cd_classificacao    int,
@cd_plano_financeiro int,
@cd_tipo_pagamento   int,
@cd_centro_custo     int = 0,

 
@ic_aberto  int, -- 1 para Sim, 0 para Não
@ic_vencido int,

@cd_ordem int -- 0 para Emissão, 1 para Vencimento, 2 para Pagamento, 3 para Favorecido, 4 para Identificacao

AS 

declare @SQL       varchar(8000)
declare @SQLTemp   varchar(8000) 
declare @SQL_COND  varchar(8000)
declare @SQL_ORDEM varchar(8000)
declare @ic_rateio int

  set @ic_rateio = dbo.fn_ver_uso_custom('RATEIO')
 
    

set @SQLTemp =''

set @SQL = ' SELECT  distinct ' +
    'd.cd_documento_pagar, ' +
    'd.cd_identificacao_document, ' +
    'd.dt_vencimento_documento, ' +
    'case when cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) <> 0.00 then ' +
    '  (d.vl_documento_pagar + isnull(d.vl_juros_documento,0) - isnull(d.vl_abatimento_documento,0) - ' +
    ' isnull(d.vl_desconto_documento,0)) ' +
    ' else (sum(p.vl_pagamento_documento) + sum(isnull(p.vl_juros_documento_pagar,0)) - ' +
    ' sum(isnull(p.vl_abatimento_documento,0)) - sum(isnull(p.vl_desconto_documento,0))) ' +
    ' end as vl_documento_pagar, ' + 
    ' max(p.dt_pagamento_documento) as dt_pagamento_documento , ' +
    ' case when count(p.cd_documento_pagar)>1 then ''Vários'' '+
    ' else (select tp.sg_tipo_pagamento from Tipo_Pagamento_documento tp ' + 
    ' where tp.cd_tipo_pagamento = max(p.cd_tipo_pagamento)) end as nm_tipo_pagamento, ' +
    ' (select pf.sg_conta_plano_financeiro from Plano_Financeiro pf ' +
    ' where pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro,d.cd_plano_financeiro) ) as sg_plano_financeiro, ' +
    ' (select tc.sg_tipo_conta_pagar from Tipo_Conta_pagar tc ' +
    ' where tc.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar) as nm_tipo_conta_pagar, ' +
    ' d.dt_emissao_documento_paga, ' +
    ' d.dt_cancelamento_documento, ' +
    '  case when (isnull(d.cd_empresa_diversa, 0) <> 0) then ' + 
               + ' cast((select top 1 z.sg_empresa_diversa from empresa_diversa z ' + 
	         ' where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50)) ' +
           'when (isnull(d.cd_contrato_pagar, 0) <> 0) then ' + 
               + ' cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w ' + 
                 ' where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50)) ' +
           'when (isnull(d.cd_funcionario, 0) <> 0) then ' + 
                 ' cast((select top 1 k.nm_funcionario from funcionario k ' + 
                 ' where k.cd_funcionario = d.cd_funcionario) as varchar(50))' +
           ' when (isnull(d.nm_fantasia_fornecedor, '''') <> '''') then ' + 
                 ' cast((select top 1 o.nm_fantasia_fornecedor from fornecedor o ' +
                 ' where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50)) ' +  
    ' end as nm_favorecido, case when count(p.cd_documento_pagar)>1 then ''Vários'' else max(p.cd_identifica_documento) end as cd_identifica_documento, '
		 + ' dcc.pc_centro_custo,dcc.vl_centro_custo, '  
		 + ' dpf.pc_plano_financeiro, dpf.vl_plano_financeiro, '  
		 + ' cc.nm_centro_custo, d.nm_cancelamento_documento, '  
                 + ' max(cpf.cd_mascara_plano_financeiro) as cd_mascara_plano_financeiro, max(cpf.nm_conta_plano_financeiro) as nm_conta_plano_financeiro '
         	 + ' from Documento_Pagar d with (nolock) left outer join ' 
                 + 'Documento_Pagar_Pagamento p on p.cd_documento_pagar = d.cd_documento_pagar left outer join '
                 + 'documento_pagar_centro_custo dcc on case when ' + cast(@ic_rateio as varchar) + ' = 0 then 0 else dcc.cd_documento_pagar end = d.cd_documento_pagar left outer join '
                 + 'documento_pagar_plano_financ dpf on case when ' + cast(@ic_rateio as varchar) + ' = 0 then 0 else dpf.cd_documento_pagar end = d.cd_documento_pagar left outer join '
                 + 'centro_custo cc on cc.cd_centro_custo = IsNull(dcc.cd_centro_custo,d.cd_centro_custo) '
                 + ' left outer join Plano_Financeiro cpf on cpf.cd_plano_financeiro = d.cd_plano_financeiro '


-- Condições.
set @SQL_COND = ' where ' 
if @ic_canc_dev = 1
  set @SQL_COND = @SQL_COND + ' d.dt_cancelamento_documento BETWEEN ' + '''' + cast(@dt_inicial_canc_dev as varchar(20))+ '''' + 
		    ' AND ' + '''' + cast(@dt_final_canc_dev as varchar(20)) + '''' 
else
  set @SQL_COND = @SQL_COND + ' d.dt_cancelamento_documento is null '

if @ic_emissao = 1 
  set @SQL_COND = @SQL_COND + ' and d.dt_emissao_documento_paga BETWEEN ' + '''' + cast(@dt_inicial_emissao as varchar(20)) + ''''  
		    + ' AND ' + '''' + cast(@dt_final_emissao as varchar(20)) + ''''
if @ic_vencimento = 1 
  set @SQL_COND = @SQL_COND + ' and d.dt_vencimento_documento BETWEEN ' + '''' + cast(@dt_inicial_venc as varchar(20)) +  '''' +
		    ' AND ' + '''' + cast(@dt_final_venc as varchar(20)) + ''''
if @ic_pagamento = 1 
  set @SQL_COND = @SQL_COND + ' and p.dt_pagamento_documento BETWEEN ' + '''' + cast(@dt_inicial_pagto as varchar(20))+ '''' + 
		    ' AND ' + '''' + cast(@dt_final_pagto as varchar(20)) + ''''


if @cd_tipo_favorecido = 1
  set @SQL_COND = @SQL_COND + ' and d.cd_empresa_diversa = ' + @cd_favorecido 

if @cd_tipo_favorecido = 2 
  set @SQL_COND = @SQL_COND + ' and d.cd_funcionario = ' + @cd_favorecido


if @cd_tipo_favorecido = 3 
  set @SQL_COND = @SQL_COND + ' and d.cd_fornecedor = ' + @cd_favorecido

if @cd_tipo_favorecido = 4
  set @SQL_COND = @SQL_COND + ' and d.cd_contrato_pagar = ' + @cd_favorecido

if @cd_tipo_documento <> 0
  set @SQL_COND = @SQL_COND + ' and d.cd_tipo_documento = ' + cast(@cd_tipo_documento as varchar(20))

if @cd_classificacao <> 0
  set @SQL_COND = @SQL_COND + ' and d.cd_tipo_conta_pagar = ' + cast(@cd_classificacao as varchar(20))
  
if @cd_plano_financeiro <> 0
  set @SQL_COND = @SQL_COND + ' and IsNull(dpf.cd_plano_financeiro,d.cd_plano_financeiro) = ' + cast(@cd_plano_financeiro as varchar(20))
 
if @cd_tipo_pagamento <> 0 
  set @SQL_COND = @SQL_COND + ' and p.cd_tipo_pagamento = ' + cast(@cd_tipo_pagamento as varchar(20))

if @ic_aberto = 1 
  set @SQL_COND = @SQL_COND + ' and IsNull(d.vl_saldo_documento_pagar,0) > 0 '

if @ic_vencido = 1 
  set @SQL_COND = @SQL_COND + ' and d.dt_vencimento_documento < ' + '''' + cast((GetDate() - 1 ) as varchar(20)) + '''' + 
		              ' and d.vl_saldo_documento_pagar > 0 '
if @cd_centro_custo <> 0 
  set @SQL_COND = @SQL_COND + ' and cc.cd_centro_custo = ' + cast(@cd_centro_custo as varchar)
-- Group
set @SQL_ORDEM = ' group by  d.cd_documento_pagar, d.cd_identificacao_document, '+
 ' d.dt_vencimento_documento, d.vl_documento_pagar, d.vl_juros_documento, '+
 ' d.vl_abatimento_documento, d.vl_desconto_documento, d.vl_saldo_documento_pagar, '+
 ' d.cd_plano_financeiro, d.cd_tipo_conta_pagar, '+
 ' d.dt_emissao_documento_paga, d.dt_cancelamento_documento, d.cd_empresa_diversa, '+
 ' d.cd_empresa_diversa, d.cd_contrato_pagar, d.nm_fantasia_fornecedor, '+
 ' dcc.pc_centro_custo,dcc.vl_centro_custo, ' + 
 ' dpf.pc_plano_financeiro, dpf.vl_plano_financeiro, ' + 
 ' d.cd_funcionario, dpf.cd_plano_financeiro, cc.nm_centro_custo, d.nm_cancelamento_documento '

-- Ordem 
set @SQL_ORDEM = @SQL_ORDEM + ' order by '

if @cd_ordem = 0 -- Emissão.
  set @SQL_ORDEM = @SQL_ORDEM + ' d.dt_emissao_documento_paga, d.dt_vencimento_documento, ' + 
		   ' p.dt_pagamento_documento, d.nm_favorecido, d.cd_identificacao_document ' 

if @cd_ordem = 1 -- Vencimento
  set @SQL_ORDEM = @SQL_ORDEM + ' d.dt_vencimento_documento, d.dt_emissao_documento_paga,  ' + 
		   ' p.dt_pagamento_documento, d.nm_favorecido, d.cd_identificacao_document ' 

if @cd_ordem = 2 -- Pagamento
  set @SQL_ORDEM = @SQL_ORDEM + ' p.dt_pagamento_documento, d.dt_emissao_documento_paga, d.dt_vencimento_documento, ' + 
		   ' d.nm_favorecido, d.cd_identificacao_document ' 

if @cd_ordem = 3 -- Favorecido
  set @SQL_ORDEM = @SQL_ORDEM + ' d.nm_favorecido, d.dt_emissao_documento_paga, d.dt_vencimento_documento, ' + 
		   ' p.dt_pagamento_documento, d.cd_identificacao_document ' 

if @cd_ordem = 4 -- Identificacao
  set @SQL_ORDEM = @SQL_ORDEM + ' d.cd_identificacao_document, d.dt_emissao_documento_paga, d.dt_vencimento_documento, ' + 
		   ' p.dt_pagamento_documento, d.nm_favorecido  ' 



print (@SQLTemp + @SQL + @SQL_COND + @SQL_ORDEM)

exec ( @SQLTemp + @SQL + @SQL_COND + @SQL_ORDEM)

