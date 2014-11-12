

/****** Object:  Stored Procedure dbo.pr_gera_nota_debito    Script Date: 13/12/2002 15:08:31 ******/

CREATE  PROCEDURE pr_gera_nota_debito 
@ic_parametro               int,
@cd_nota_debito             int,
@cd_documento_receber       int,
@cd_cliente                 int,
@dt_nota_debito             datetime,
@dt_vencimento              datetime,
@dt_pagamento               datetime,
@vl_nota_debito             numeric(15,2),
@vl_pagamento               decimal(25,2),
@dt_cancelamento            datetime,
@nm_motivo_cancelamento     varchar(30),
@qt_dia_atraso_nota_debito  int,
@vl_juros_nota_debito       numeric(15,2),
@cd_usuario                 int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Geração da Nota de Débito
-------------------------------------------------------------------------------
  begin

    begin transaction
 
      insert into Nota_Debito (
        cd_nota_debito, 
        cd_cliente,
        dt_nota_debito, 
        dt_vencimento_nota_debito,
        dt_pagamento_nota_debito, 
        vl_nota_debito,
        vl_pagamento_nota_debito, 
        ic_emissao_nota_debito,
        dt_cancelamento_nota_debi, 
        nm_cancelamento_nota_debi,
        dt_usuario, 
        cd_usuario )
     values ( 
        @cd_nota_debito, 
        @cd_cliente, 
        @dt_nota_debito, 
        @dt_vencimento, 
        null, 
        @vl_nota_debito, 
        null, 
        'S', 
        null, 
        null,
        getDate(), 
        @cd_usuario)

    if @@ERROR = 0
      commit tran
    else
      rollback tran

    update
      empresa
    set
      cd_nota_debito_empresa = @cd_nota_debito
    where
      cd_empresa = dbo.fn_empresa()

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- Gerar o documento da nota de débito
-------------------------------------------------------------------------------
  begin

    begin transaction


      insert into Documento_Nota_Debito (
        cd_nota_debito, 
        cd_documento_receber,
        vl_documento_nota_debito,
        qt_dia_atraso_nota_debito, 
        vl_juros_nota_debito,
        dt_usuario, 
        cd_usuario )
      values ( 
        @cd_nota_debito, 
        @cd_documento_receber,
        @vl_nota_debito,
        @qt_dia_atraso_nota_debito, 
        @vl_juros_nota_debito,
        getDate(), 
        @cd_usuario )

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 3   -- Atualiza o status Emitido da Nota de Débito
-------------------------------------------------------------------------------
  begin

    begin transaction
    
      update
        Nota_ebito
      set
        ic_emissao_nota_debito = 'S'
      where
        cd_nota_debito = @cd_nota_debito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end 
-------------------------------------------------------------------------------
else if @ic_parametro = 4 -- pagamento da nota de débito
-------------------------------------------------------------------------------
  begin

    begin transaction
  
      -- verifica se aconteceu o pagamento
      if (select 
            dt_pagamento_nota_debito 
          from 
            nota_debito 
          where 
          cd_nota_debito = @cd_nota_debito) <> null
      return

      update 
        nota_debito
      set 
        vl_pagamento_nota_debito = @vl_pagamento,
        dt_pagamento_nota_debito = @dt_pagamento
      where
        cd_nota_debito = @cd_nota_debito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end       
-------------------------------------------------------------------------------
else if @ic_parametro = 5 -- exclusão da nota de debito
-------------------------------------------------------------------------------
  begin

    begin transaction
  
      -- verifica se aconteceu o pagamento
      if (select 
            dt_pagamento_nota_debito 
          from 
            nota_debito 
          where 
            cd_nota_debito = @cd_nota_debito) <> null
        return

      delete from
        nota_debito
      where
        cd_nota_debito = @cd_nota_debito

      delete from
        documento_nota_debito
      where
        cd_nota_debito = @cd_nota_debito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end    
-------------------------------------------------------------------------------
else if @ic_parametro = 6 -- cancelamento da nota de débito
-------------------------------------------------------------------------------
  begin

    begin transaction
 
      update
        nota_debito
      set
        dt_cancelamento_nota_debi = @dt_cancelamento,
        nm_cancelamento_nota_debi = @nm_motivo_cancelamento
      where
        cd_nota_debito = @cd_nota_debito

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end




