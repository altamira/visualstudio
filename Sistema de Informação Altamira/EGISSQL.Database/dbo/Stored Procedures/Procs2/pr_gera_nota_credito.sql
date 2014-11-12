
CREATE PROCEDURE pr_gera_nota_credito
@ic_parametro               int,
@cd_item_cred_nota_saida    int,
@cd_item_nota_credito       int,
@nm_obs_nota_saida_credito  varchar(40),
@cd_nota_credito            int,
@cd_nota_saida              int,
@cd_cliente                 int,
@dt_nota_credito             datetime,
@dt_vencimento              datetime,
@vl_item_nota_credito     numeric(15,2),
@dt_pagamento               datetime,
@vl_nota_credito            numeric(15,2),
@vl_pagamento               decimal(25,2),
@dt_cancelamento            datetime,
@nm_motivo_cancelamento     varchar(30),
@cd_documento_receber       int,
@cd_usuario                 int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Geração da Nota de Crédito
-------------------------------------------------------------------------------
  begin

    begin transaction

      insert into Nota_Credito (
        cd_nota_credito,
        cd_cliente,
        dt_emissao_nota_credito,
        dt_vencto_nota_credito,
        dt_pagamento_nota_credito,
        vl_nota_credito,
        vl_pagamento_nota_credito,
        ic_emitida_nota_credito,
        dt_cancelamento_nota_cred,
        nm_motivo_cancelamento,
        dt_usuario,
        cd_usuario )
     values (
        @cd_nota_credito,
        @cd_cliente,
        @dt_nota_credito,
        @dt_vencimento,
        null,
        @vl_nota_credito,
        null,
        'N',
        null,
        null,
        getDate(),
        @cd_usuario)

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- Gerar o documento da nota de Crédito
-------------------------------------------------------------------------------
  begin

    begin transaction

      insert into Nota_Credito_Item (
        cd_nota_credito,
        cd_item_nota_credito,
        cd_nota_saida,
        vl_item_nota_credito,
	nm_item_obs_nota_credito,
        cd_documento_receber,
        dt_usuario,
        cd_usuario )
      values (
        @cd_nota_credito,
        @cd_item_nota_credito,
        @cd_nota_saida,
        @vl_item_nota_credito,
        @nm_obs_nota_saida_credito,
        @cd_documento_receber,
        getDate(),
        @cd_usuario )

     update
        Nota_Saida_Credito
     set ic_nota_credito =  'S'
     where
        cd_nota_saida = @cd_nota_saida and
        cd_item_cred_nota_saida = @cd_item_nota_credito
    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 3   -- Atualiza o status Emitido da Nota de Crédito
-------------------------------------------------------------------------------
  begin

    begin transaction

      update
        Nota_Credito
      set
        ic_emitida_nota_credito = 'S'
      where
        cd_nota_credito = @cd_nota_credito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end


-------------------------------------------------------------------------------
else if @ic_parametro = 4 -- pagamento da nota de Crédito , a Implantar
-------------------------------------------------------------------------------
  begin

    begin transaction

      -- verifica se aconteceu o pagamento
      if (select
            dt_pagamento_nota_credito
          from
            nota_credito
          where
          cd_nota_credito = @cd_nota_credito) <> null
      return

      update
        nota_credito
      set
        vl_pagamento_nota_credito = @vl_pagamento,
        dt_pagamento_nota_credito = @dt_pagamento
      where
        cd_nota_credito = @cd_nota_credito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 5 -- exclusão da nota de Crédito
-------------------------------------------------------------------------------
  begin

    begin transaction

      -- verifica se aconteceu o pagamento, ainda vai ser implantado

      if (select
            dt_pagamento_nota_credito
          from
           nota_credito
          where
           cd_nota_credito = @cd_nota_credito) <> null
          return

      delete from
        Nota_Credito
      where
        cd_nota_credito = @cd_nota_credito

--      delete from -- Ainda vai ser definido como será feita a exclusão.
--        Nota_Saida_Credito
--     where
  --     cd_nota_credito = @cd_nota_credito

      delete from
        Nota_Credito_Item
      where
        cd_nota_credito = @cd_nota_credito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end


-------------------------------------------------------------------------------
else if @ic_parametro = 6 -- cancelamento da nota de crédito
-------------------------------------------------------------------------------
  begin

    begin transaction

      update
        nota_credito
      set
        dt_cancelamento_nota_cred = @dt_cancelamento,
        nm_motivo_cancelamento    = @nm_motivo_cancelamento
      where
        cd_nota_credito = @cd_nota_credito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end

