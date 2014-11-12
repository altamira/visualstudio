
create procedure pr_gera_contabilizacao_nota_debito

@cd_nota_debito int,      -- Código da Nota de Débito
@cd_usuario     int,      -- Usuário,
@dt_inicial     datetime,
@dt_final       datetime

as


declare @cd_lancamento_padrao         int
declare @vl_contab_documento          money
declare @cd_conta_debito              int
declare @cd_conta_credito             int
declare @cd_historico_contabil        int
declare @vl_pagamento_nota_debito     money
declare @dt_pagamento_nota_debito     datetime
declare @dt_cancelamento_nota_debi datetime

declare @cd_lote_contabil          int
declare @ic_razao_cliente_empresa  char(1)
declare @cd_conta_cliente          int
declare @cd_cliente                int
declare @nm_atributo               varchar(25)
declare @nm_historico_documento    varchar(40)
declare @cd_identificacao          varchar(25)
declare @nm_fantasia_cliente       varchar(15)

set @cd_conta_debito       = 0
set @cd_conta_credito      = 0
set @cd_historico_contabil = 0
set @cd_lote_contabil      = 0
set @nm_atributo           = ''
set @nm_historico_documento= ''
set @nm_fantasia_cliente   = ''

   
-- Seleciona o documento para contabilização
select 
  @dt_pagamento_nota_debito    = nd.dt_pagamento_nota_debito,
  @dt_cancelamento_nota_debi   = nd.dt_cancelamento_nota_debi,
  @vl_pagamento_nota_debito    = nd.vl_nota_debito, 
  @cd_cliente                  = nd.cd_cliente,
  @nm_fantasia_cliente         = c.nm_fantasia_cliente
from
  Nota_Debito nd
left outer join cliente c on
  c.cd_cliente = nd.cd_cliente
where
  nd.cd_nota_debito     = @cd_nota_debito  and
  nd.dt_pagamento_nota_debito between @dt_inicial and @dt_final

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
    Cliente
  Where 
      cd_cliente = @cd_cliente
end

----------------------------------------------
--Consistências para Gerar a Contabilização
----------------------------------------------

-- Checa o cancelamento da nota de debito
if @dt_cancelamento_nota_debi is not null -- (se foi cancelado...)
begin
  set @vl_contab_documento = @vl_pagamento_nota_debito
  set @nm_atributo         = 'cd_nota_debito'
  set @nm_historico_documento= '-ND. '+cast(@cd_nota_debito as varchar(10))+' '+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_nota_debito @cd_nota_debito,
                                                   @dt_pagamento_nota_debito,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario
end


--Contabilização do Cliente
if @cd_conta_cliente > 0
begin
  set @vl_contab_documento   = @vl_pagamento_nota_debito                              
  set @nm_atributo           = 'cd_nota_debito'
  set @cd_conta_debito       = 0
  set @cd_conta_credito      = @cd_conta_cliente
  set @nm_historico_documento= '-ND. '+cast(@cd_nota_debito as varchar(10))+' '+@nm_fantasia_cliente

  -- Essa stored procedure insere na tabela documento_receber_contabil
  exec pr_grava_geracao_contabilizacao_nota_debito @cd_nota_debito,
                                                   @dt_pagamento_nota_debito,
                                                   @vl_contab_documento,
                                                   @nm_atributo,
                                                   @cd_conta_debito,
                                                   @cd_conta_credito,      
                                                   @nm_historico_documento, 
                                                   @cd_usuario

end

