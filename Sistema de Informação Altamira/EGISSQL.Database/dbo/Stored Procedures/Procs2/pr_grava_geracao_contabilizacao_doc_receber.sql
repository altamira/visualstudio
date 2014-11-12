
create procedure pr_grava_geracao_contabilizacao_doc_receber

@cd_documento_receber   int,         -- Código do Documento a Receber
@dt_pagamento_documento datetime,    -- Data de pagamento do documento
@vl_contab_documento    float,       -- Valor de contabilização (docto.,juros,cancelamento,etc.)
@nm_atributo            varchar(25), -- Nome do campo a ser localizado em tipo de contabilização
@cd_conta_debito        int,         -- Conta contábil a débito
@cd_conta_credito       int,         -- Conta contábil a crédito 
@nm_historico_documento varchar(40), -- Complemento do Histórico
@cd_usuario             int          -- Usuário

as

declare @cd_lancamento_padrao      int
declare @cd_historico_contabil     int
declare @cd_lote_contabil          int
declare @nm_tabela                 varchar(50)
declare @cd_item_documento_receber int

set @cd_historico_contabil     = 0
set @cd_lote_contabil          = 0

-- Nome da Tabela usada na geração e liberação de códigos
set @nm_tabela = cast(DB_NAME()+'.dbo.Documento_Receber_Contabil' as varchar(50))
set @cd_item_documento_receber = 0

  --Busca do Lançamento Padrão 

  select
    @cd_lancamento_padrao  = lp.cd_lancamento_padrao,
    @cd_historico_contabil = lp.cd_historico_contabil,
    @cd_conta_debito       = case when lp.cd_conta_debito>0  and @cd_conta_debito = 0 then lp.cd_conta_debito  else @cd_conta_debito  end,
    @cd_conta_credito      = case when lp.cd_conta_credito>0 then lp.cd_conta_credito else @cd_conta_credito end,
    @cd_lote_contabil      = lp.cd_lote_contabil_padrao
   from
    tipo_contabilizacao tc,
    lancamento_padrao lp
  where
    tc.nm_atributo            = @nm_atributo and
    tc.cd_tipo_contabilizacao = lp.cd_tipo_contabilizacao

--print @nm_atributo
--print @cd_lancamento_padrao
--print @cd_historico_contabil
--print @cd_conta_debito
--print @cd_conta_credito

-- Checa os parâmetros para validar a inserção

  if ((@cd_conta_credito      is not null) or
      (@cd_conta_debito       is not null)) and
      (@cd_historico_contabil is not null) and  
      (@cd_lancamento_padrao  is not null)  
  begin

    --Insert o Lançamento Contábil do Juros

    exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_item_contab_documento', @codigo = @cd_item_documento_receber output

    insert into Documento_Receber_Contabil
      ( cd_documento_receber,
        cd_item_contab_documento,
        dt_contab_documento,
        cd_lancamento_padrao,
        cd_conta_credito,
        cd_conta_debito,
        vl_contab_documento,
        cd_historico_contabil,
        nm_historico_documento,
        ic_sct_contab_documento,
        cd_usuario,
        dt_usuario)  
    Values
      ( @cd_documento_receber,
        @cd_item_documento_receber,
        @dt_pagamento_documento,
        @cd_lancamento_padrao,
        @cd_conta_credito,   
        @cd_conta_debito, 
        @vl_contab_documento,
        @cd_historico_contabil,        
        @nm_historico_documento,
        'N',
        @cd_usuario,
        getdate() )
 
    -- liberação do código gerado p/ PegaCodigo
    exec EgisADMIN.dbo.sp_LiberaCodigo 'EgisSQL.Dbo.Documento_Receber_Contabil', @cd_item_documento_receber, 'D'

    --Atualiza o Módulo de Contabilidade
    --Movimento_Contabil
    --cd_empresa
    --cd_exercicio
    --cd_lote
    --cd_lancamento_contabil  -- pega codigo
    --dt_lancamento_contabil
    --cd_reduzido_debito
    --cd_reduzido_credito
    --vl_lancamento_contabil
    --cd_historico_contabil
    --ds_historico_contabil
    --cd_usuario
    --dt_usuario
  end

