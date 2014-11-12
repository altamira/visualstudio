
CREATE PROCEDURE pr_baixar_documento_receber
@cd_documento_receber 	int,
@cd_identificacao 	varchar(25),
@ic_tipo_abatimento 	char(1),  -- (P)arcial, (T)otal
@ic_tipo_liquidacao 	char(1), -- (L)iquidacao Normal, (D)evolucao, (C)ancelamento
@dt_baixa 		datetime,
@ic_desconto_comissao 	char(1),
@vl_pagamento 		numeric(25,2),
@vl_juros 		numeric(25,2),
@vl_desconto 		numeric(25,2),
@vl_abatimento 		numeric(25,2),
@vl_reembolso 		numeric(25,2),
@vl_despesa_bancaria 	numeric(25,2),
@vl_credito_pendente 	numeric(25,2),
@nm_cancelamento 	varchar(60),
@cd_recibo 		varchar(20),
@cd_usuario 		int,
@nm_obs_documento 	varchar(50)

as
begin

  declare @cd_item_documento int
  declare @vl_baixa numeric(25,2)
  declare @vl_saldo_anterior numeric(25,2)
  declare @ic_baixa char(1)

  set @cd_item_documento = 0
  set @vl_baixa = 0.00
  set @vl_saldo_anterior = 0.00
  set @ic_baixa = ''

  -- verificar se título já foi baixado
  if (select 
        cast(str(vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento' 
      from
        Documento_receber
      where
        cd_documento_receber = @cd_documento_receber) = 0
    begin
      raiserror('Documento já liquidado! Operação Abortada!',16,1)
      return
    end
  else
    -- verificar se já foi cancelado/devolvido
    if (select
          dt_cancelamento_documento
        from
          Documento_receber
        where
          cd_documento_receber = @cd_documento_receber) is not null
      begin
        raiserror('Documento já cancelado/devolvido! Operação Abortada!', 16, 1)
        return
      end
    else
      -- (D)evolucao ou (C)ancelamento
      if @ic_tipo_liquidacao in ('D','C')
        update
          Documento_receber
        set
          vl_saldo_documento = ((select 
                                  sum(vl_pagamento_documento)
                                from
                                  Documento_receber_pagamento
                                where
                                  cd_documento_receber = @cd_documento_receber) -
                                  vl_documento_receber),
          dt_cancelamento_documento = @dt_baixa,
          nm_cancelamento_documento = @nm_cancelamento,
          cd_usuario = @cd_usuario,
          dt_usuario = getDate() 
        where
          cd_documento_receber = @cd_documento_receber 
      else  
        begin
        
          -- valor total da baixa
          set @vl_baixa = (@vl_pagamento -
                           @vl_juros +
                           @vl_desconto +
                           @vl_abatimento -
                           @vl_reembolso -
                           @vl_despesa_bancaria -
                           @vl_credito_pendente)
 
--          select @vl_baixa
 
          -- saldo anterior
          select 
            @vl_saldo_anterior = cast(str(vl_saldo_documento,25,2) as decimal(25,2))
          from 
            Documento_receber 
          where 
            cd_documento_receber = @cd_documento_receber 

          --select @vl_saldo_anterior

          -- liquidacao (P)arcial
          if (@vl_baixa < @vl_saldo_anterior)
            begin
              set @ic_baixa = 'P'
              update
                Documento_receber
              set
                vl_saldo_documento = (cast(str(vl_saldo_documento,25,2) as decimal(25,2)) - @vl_baixa),
                cd_usuario = @cd_usuario,
                dt_usuario = getDate() 
              from
                Documento_receber
              where
                cd_documento_receber = @cd_documento_receber
            end
            -- liquidacao (T)otal
          else 
            if (@vl_saldo_anterior = @vl_baixa)
              begin
                set @ic_baixa = 'T'
                update
                  Documento_receber
                set
                  vl_saldo_documento = 0.00,
                  cd_usuario = @cd_usuario,
                  dt_usuario = getDate() 
                from
                  Documento_receber
                where
                  cd_documento_receber = @cd_documento_receber
              end
            else
              -- não permitir liquidação de valor superior ao saldo
              begin
                raiserror('Valor da Baixa Superior ao Saldo do Documento!', 16, 1)
                return
              end

          -- encontrando código do ítem
          select 
            @cd_item_documento = (isnull(max(cd_item_documento_receber),0)+1)
          from
            Documento_receber_pagamento
          where
            cd_documento_receber = @cd_documento_receber

          -- criar registro de pagamento do documento
          insert into Documento_receber_pagamento (
            cd_documento_receber,
            cd_item_documento_receber,
            dt_pagamento_documento,
            vl_pagamento_documento,
            vl_juros_pagamento,
            vl_desconto_documento,
            vl_abatimento_documento,
            vl_despesa_bancaria,
            cd_recibo_documento,
            ic_tipo_abatimento,
            ic_tipo_liquidacao,
            vl_reembolso_documento,
            vl_credito_pendente,
            ic_desconto_comissao,
            cd_usuario,
            dt_usuario,
            nm_obs_documento)                
          values(
            @cd_documento_receber, 
            @cd_item_documento,
            @dt_baixa,
            @vl_pagamento,
            @vl_juros,
            @vl_desconto,
            @vl_abatimento,
            @vl_despesa_bancaria,
            @cd_recibo,
            @ic_tipo_abatimento,
            @ic_baixa,
            @vl_reembolso,
            @vl_credito_pendente,
            @ic_desconto_comissao,
            @cd_usuario,
            getDate(),
            @nm_obs_documento)      

      end         
  


end

