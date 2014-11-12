
create procedure pr_gera_contabilizacao_doc_receber

@cd_documento_receber      int      = 0,      -- Código do Documento a Receber
@cd_item_documento_receber int      = 0,  -- Código do Item do Documento
@ic_tipo_atualizacao       char(1)  = 'M',  -- Manual / Retorno do Banco
@cd_usuario                int      = 0,      -- Usuário,
@dt_inicial                datetime = '',
@dt_final                  datetime = ''

as

declare @cd_banco                   int
declare @cd_lancamento_padrao       int
declare @vl_contab_documento        money
declare @cd_conta_debito            int
declare @cd_conta_debito_liquidacao int
declare @cd_conta_credito           int
declare @cd_historico_contabil      int
declare @vl_documento_receber       money
declare @vl_pagamento_documento     money
declare @vl_juros_documento         money
declare @vl_desconto_documento      money
declare @vl_abatimento_documento    money
declare @vl_despesa_bancaria        money
declare @vl_credito_pendente        money
declare @dt_pagamento_documento     datetime
declare @dt_cancelamento_documento  datetime
declare @dt_devolucao_documento     datetime
declare @cd_lote_contabil           int
declare @ic_razao_cliente_empresa   char(1)
declare @cd_conta_cliente           int
declare @cd_cliente                 int
declare @nm_atributo                varchar(25)
declare @cd_nota_saida              int
declare @nm_historico_documento     varchar(40)
declare @cd_identificacao           varchar(25)
declare @nm_fantasia_cliente        varchar(15)
declare @cd_tipo_liquidacao         int

set @cd_conta_debito            = 0
set @cd_conta_credito           = 0
set @cd_conta_debito_liquidacao = 0
set @cd_historico_contabil      = 0

set @cd_lote_contabil      = 0
set @nm_atributo           = ''
set @nm_historico_documento= ''
set @nm_fantasia_cliente   = ''
   
-- Seleciona o documento para contabilização

select 
  @cd_banco                   = isnull(dp.cd_banco,0),
  @dt_pagamento_documento     = dp.dt_pagamento_documento,
  @dt_cancelamento_documento  = d.dt_cancelamento_documento,
  @dt_devolucao_documento     = d.dt_devolucao_documento,
  @vl_documento_receber       = d.vl_documento_receber,
  @vl_pagamento_documento     = dp.vl_pagamento_documento, 
  @vl_juros_documento         = dp.vl_juros_pagamento, 
  @vl_desconto_documento      = dp.vl_desconto_documento,
  @vl_abatimento_documento    = dp.vl_abatimento_documento,
  @vl_despesa_bancaria        = dp.vl_despesa_bancaria,
  @vl_credito_pendente        = dp.vl_credito_pendente,
  @cd_cliente                 = d.cd_cliente,
  @cd_identificacao           = d.cd_identificacao,
  @cd_nota_saida              = d.cd_nota_saida,
  @nm_fantasia_cliente        = c.nm_fantasia_cliente,
  @cd_tipo_liquidacao         = dp.cd_tipo_liquidacao,
  @cd_conta_debito_liquidacao = isnull(tl.cd_conta,0)
from
  documento_receber d with (nolock) 
  left outer join documento_receber_pagamento dp  on dp.cd_documento_receber = d.cd_documento_receber  
  left outer join cliente c                       on c.cd_cliente            = d.cd_cliente
  left outer join tipo_liquidacao tl              on tl.cd_tipo_liquidacao   = dp.cd_tipo_liquidacao
where
  d.cd_documento_receber     = @cd_documento_receber  and
  (dp.cd_item_documento_receber = @cd_item_documento_receber or @cd_item_documento_receber=0) and
  ((dp.dt_pagamento_documento between @dt_inicial and @dt_final) or
   (d.dt_devolucao_documento between @dt_inicial and @dt_final))

--Checa o Parâmetro Contabil para saber se a Contabilização :
--Única ou por Cliente

select 
  @ic_razao_cliente_empresa = isnull(ic_razao_cliente_empresa,'N'),
  @cd_conta_cliente         = cd_conta_cliente
from
  Parametro_Financeiro
where
  cd_empresa = dbo.fn_empresa() -- funcao que pega a empresa automaticamente.


--Checa se o código contábil é por cliente
if @ic_razao_cliente_empresa = 'N'
begin
  --Busca o Código no Cadastro do Cliente
  select @cd_conta_cliente = cd_conta
  from
    Cliente with (nolock) 
  Where 
      cd_cliente = @cd_cliente
end

--------------------------------------------------------
--Consistências para Gerar a Contabilização
--------------------------------------------------------

--select @cd_banco

-- TIPO DE LIQUIDAÇÃO C/ BANCO

if @cd_banco > 0
begin
  -- Débito = @cd_conta_debito
  set @cd_conta_debito       = 0
  set @cd_conta_credito      = 0
  set @vl_contab_documento   = @vl_pagamento_documento
  set @nm_atributo           = 'cd_banco'
  set @nm_historico_documento= ''

  select @cd_conta_debito

  select @cd_conta_debito = isnull(cd_conta,0)
  from
     Banco with (nolock) 
  where
     cd_banco = @cd_banco

  --Verifica se existe conta especial por Tipo de Liquidação

  if @cd_conta_debito_liquidacao>0 
  begin
    set @cd_conta_debito = @cd_conta_debito_liquidacao
  end

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- DINHEIRO

if @cd_tipo_liquidacao=10 and @dt_devolucao_documento is null
begin
  set @vl_contab_documento   = @vl_pagamento_documento
  set @nm_atributo           = 'vl_pagamento_documento'
  set @nm_historico_documento= 'S/NF.............N/NF'+cast(@cd_nota_saida as varchar(10))
--  set @nm_historico_documento='-DUPL.'+@cd_identificacao+'-'+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end


-- TIPO DE LIQUIDAÇÃO (DEVOLUÇÃO)

if @cd_tipo_liquidacao=1 and @dt_devolucao_documento is null
begin
  set @vl_contab_documento   = @vl_pagamento_documento
  set @nm_atributo           = 'dt_devolucao_documento'
  set @nm_historico_documento= 'S/NF.............N/NF'+cast(@cd_nota_saida as varchar(10))

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- TIPO DE LIQUIDAÇÃO (LUCROS E PERDAS)

if @cd_tipo_liquidacao=5 and @dt_devolucao_documento is null
begin
  set @vl_contab_documento   = @vl_pagamento_documento
  set @nm_atributo           = 'vl_lucro_perda'
  set @nm_historico_documento= 'DA CTA., REF.VLRS.INFERIORES R$ 0,00'

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- TIPO DE LIQUIDAÇÃO (DESCONTO)

if @cd_tipo_liquidacao=9 and @dt_devolucao_documento is null
begin
  set @vl_contab_documento   = @vl_pagamento_documento
  set @nm_atributo           = 'vl_desconto_documento'
  set @nm_historico_documento= @cd_identificacao + '' + @nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Checa o cancelamento do documento

if @dt_cancelamento_documento is not null -- (se foi cancelado...)
begin
  set @vl_contab_documento = @vl_pagamento_documento
  set @nm_atributo         = 'dt_cancelamento_documento'
  set @nm_historico_documento= ''

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Checa a devolução do documento

if @dt_devolucao_documento is not null -- (se foi devolvido)
begin
  set @vl_contab_documento   = @vl_documento_receber
  set @cd_conta_debito       = 0
  set @cd_conta_credito      = 0
  set @nm_atributo           = 'dt_devolucao_documento'
  set @nm_historico_documento= 'S/NF.............N/NF'+cast(@cd_nota_saida as varchar(10))

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_devolucao_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Verifica se Existe Juros para Contabilizar

if @vl_juros_documento > 0 
begin
  set @vl_contab_documento   = @vl_juros_documento
  set @nm_atributo           = 'vl_juros_pagamento'
  set @cd_conta_debito       = 0
  set @nm_historico_documento='-DUPL.'+@cd_identificacao+'-'+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Desconto

if @vl_desconto_documento > 0
begin
  set @vl_contab_documento   = @vl_desconto_documento
  set @nm_atributo           = 'vl_abatimento_documento'
  set @cd_conta_credito      = 0
  set @nm_historico_documento= '-DUPL.'+@cd_identificacao+'-'+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Abatimento

if @vl_abatimento_documento > 0 
begin
  set @vl_contab_documento   = @vl_abatimento_documento
  set @nm_atributo           = 'vl_abatimento_documento'
  set @cd_conta_credito      = 0
  set @nm_historico_documento= '-DUPL.'+@cd_identificacao+'-'+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil

  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Despesa Bancária

if @vl_despesa_bancaria > 0
begin
  set @vl_contab_documento   = @vl_despesa_bancaria
  set @nm_atributo           = 'vl_despesa_bancaria'
  set @cd_conta_credito      = 0
  set @nm_historico_documento= '-DUPL.'+@cd_identificacao+'-'+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

-- Crédito Pendente

if @vl_credito_pendente > 0
begin
  set @vl_contab_documento   = @vl_credito_pendente
  set @nm_atributo           = 'vl_credito_pendente'
  set @nm_historico_documento= '-DUPL.'+@cd_identificacao+'-'+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end

--Contabilização do Cliente

if @cd_conta_cliente > 0 and @cd_banco >0
begin

  set @vl_contab_documento   =  ( @vl_pagamento_documento
                               - @vl_juros_documento
                               + @vl_desconto_documento
                               + @vl_abatimento_documento
                               - @vl_despesa_bancaria
                               - @vl_credito_pendente)
  set @nm_atributo           = 'cd_cliente'
  set @cd_conta_debito       = 0
  set @cd_conta_credito      = @cd_conta_cliente
  set @nm_historico_documento= ''

  -- Essa stored procedure insere na tabela documento_receber_contabil

  exec pr_grava_geracao_contabilizacao_doc_receber @cd_documento_receber,
                                                   @dt_pagamento_documento,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario

end

