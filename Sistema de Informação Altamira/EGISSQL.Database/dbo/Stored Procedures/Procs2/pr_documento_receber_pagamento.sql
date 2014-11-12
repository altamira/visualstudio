
CREATE PROCEDURE pr_documento_receber_pagamento

@ic_parametro			int,
@cd_documento_receber 		int,
@cd_item_documento_receber	int,
@dt_pagamento_documento		datetime,
@vl_pagamento_documento		float,
@vl_juros_pagamento		float,
@vl_desconto_documento		float,
@vl_abatimento_documento	float,
@vl_despesa_bancaria		float,
@cd_recibo_documento		varchar(20),
@ic_tipo_abatimento		char(1),
@ic_tipo_liquidacao		char(1),
@vl_reembolso_documento		float,
@vl_credito_pendente		float,
@ic_desconto_comissao		char(1),
@cd_usuario			int,
@dt_usuario			datetime,
@nm_obs_documento		varchar(60),
@cd_tipo_liquidacao             int,
@cd_banco                       int,
@cd_conta_banco                 int = 0,
@cd_lancamento                  int = 0,
@cd_tipo_caixa                  int = 0

AS

-----------------------------------------------------------------------------------------

declare @vl_liquido_pagamento float
declare @vl_saldo_documento   float
declare @vl_pagamento_total   float

--Calculando valor líquido pagamento
set @vl_liquido_pagamento = (@vl_pagamento_documento - @vl_juros_pagamento + @vl_desconto_documento
                           + @vl_abatimento_documento - @vl_despesa_bancaria - @vl_reembolso_documento
                           - @vl_credito_pendente)


begin transaction
-----------------------------------------------------------------------------------------
if @ic_parametro = 1  --Consulta dos Pagamentos de Um Documento a Receber Informado
-----------------------------------------------------------------------------------------
begin
  select
    p.cd_documento_receber,
    p.cd_item_documento_receber,
    p.dt_pagamento_documento,
    p.vl_pagamento_documento,
    p.vl_juros_pagamento,
    p.vl_desconto_documento,
    p.vl_abatimento_documento,
    p.vl_despesa_bancaria,
    p.cd_recibo_documento,
    p.ic_tipo_abatimento,
    p.ic_tipo_liquidacao,
    p.vl_reembolso_documento,
    p.vl_credito_pendente,
    p.ic_desconto_comissao,
    p.cd_usuario,
    p.dt_usuario,
    p.nm_obs_documento, 
    p.cd_tipo_liquidacao,
    p.cd_banco,
    p.cd_conta_banco,
    p.cd_lancamento,
    p.cd_tipo_caixa,
    (select top 1 
       ch.nm_cheque_receber
     from
       Cheque_Receber_Composicao chr with (nolock) 
       inner join Cheque_Receber ch  with (nolock) on ch.cd_cheque_receber = chr.cd_cheque_receber 
     where
       chr.cd_documento_receber = p.cd_documento_receber ) as nm_cheque_receber
  from
    Documento_Receber_Pagamento p with (nolock) 
  where
    p.cd_documento_receber = @cd_documento_receber

  order by
    cd_item_documento_receber

end

else
-----------------------------------------------------------------------------------------
if @ic_parametro = 2  --Inserção de pagamento para documento informado
-----------------------------------------------------------------------------------------
begin

  --Verificando se documento informado existe
  if not exists(select
                  cd_documento_receber
                from
                  Documento_Receber with (nolock) 
                where
                  cd_documento_receber = @cd_documento_receber)
  begin
    raiserror('Documento não cadastrado!', 16, 1)
    goto TrataErro    
  end
  else
    --Verificando se documento está cancelado
    if (select
          dt_cancelamento_documento
        from
          Documento_receber with (nolock) 
        where
          cd_documento_receber = @cd_documento_receber) is not null
    begin
      raiserror('Documento está cancelado!', 16, 1)
      goto TrataErro
    end
    else

-- Márcio - 03/06/05 - Comentado pois está verificação é feita  no Delphi, por uma flag
--      --Verificando se data informada para pagamento é superior ou igual a data de emissão do documento
 --      if @dt_pagamento_documento < (select dt_emissao_documento
--                                     from Documento_Receber
--                                     where cd_documento_receber = @cd_documento_receber)
--       begin
--         raiserror('Data de pagamento informada é inferior a data de emissão do documento!', 16, 1)
--         goto TrataErro
--       end
--     else
--       begin


          --Verificando se já existe item de pagamento

          if not exists(select
                          cd_item_documento_receber
                        from
                          Documento_Receber_Pagamento with (nolock) 
                        where
                          cd_documento_receber = @cd_documento_receber)

            set @cd_item_documento_receber = 1

          --Criando item para pagamento

          select
            @cd_item_documento_receber = cd_item_documento_receber + 1
          from
            Documento_Receber_Pagamento with (nolock) 
          where
            cd_documento_receber = @cd_documento_receber
  
          --Inserindo pagamento para documento
  
        insert into
            Documento_Receber_Pagamento
            (
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
            nm_obs_documento,
            cd_tipo_liquidacao,
            cd_banco,
            cd_conta_banco,
            cd_tipo_caixa
            )
          values
            (
            @cd_documento_receber,
            @cd_item_documento_receber,
            @dt_pagamento_documento,
            isnull(@vl_pagamento_documento, 0),
            isnull(@vl_juros_pagamento, 0),
            isnull(@vl_desconto_documento, 0),
            isnull(@vl_abatimento_documento, 0),
            isnull(@vl_despesa_bancaria, 0),
            @cd_recibo_documento,
            @ic_tipo_abatimento,
            @ic_tipo_liquidacao,
            isnull(@vl_reembolso_documento,0),
            isnull(@vl_credito_pendente, 0),
            @ic_desconto_comissao,
            @cd_usuario,
            @dt_usuario,
            @nm_obs_documento,
            @cd_tipo_liquidacao,	
            @cd_banco,
            @cd_conta_banco,
            @cd_tipo_caixa
            )

         -----------------------------------------------------------------------
         --Calculando novo saldo------------------------------------------------
         -----------------------------------------------------------------------

         set @vl_saldo_documento = (select
                                      isnull(vl_documento_receber,0)
                                    from
                                      Documento_Receber with (nolock) 
                                    where
                                      cd_documento_receber = @cd_documento_receber)

                                    --Todos os valores pagos para documento

                                      - isnull( (select sum(isnull(vl_pagamento_documento, 0) )
                                                     - sum(isnull(vl_juros_pagamento, 0)      )     
                                                     + sum(isnull(vl_desconto_documento, 0)   )
                                                     + sum(isnull(vl_abatimento_documento, 0) )
                                                     - sum(isnull(vl_despesa_bancaria, 0)     )
                                                     - sum(isnull(vl_reembolso_documento, 0)  )
                                                     + sum(isnull(vl_credito_pendente, 0)     )
                                               from Documento_Receber_Pagamento
                                               where cd_documento_receber = @cd_documento_receber),0)

          --Atualizando Documento_Receber

          update
            Documento_Receber
          set
            vl_saldo_documento      = cast(str(@vl_saldo_documento,25,2) as decimal(25,2)),
            vl_abatimento_documento = case when @vl_abatimento_documento>0 then 0 else vl_abatimento_documento end
          where
            cd_documento_receber = @cd_documento_receber

          -- caso o pagamento seja total atualizar os campos dt_pagto_document_receber e 
          -- vl_pagto_document_receber e o tipo de liquidação
          if @vl_saldo_documento = 0 
            begin

              -- Calculando o total de pagamentos
              set @vl_pagamento_total = (select sum(isnull(vl_pagamento_documento, 0))
                                           - sum(isnull(vl_juros_pagamento, 0))     
                                           + sum(isnull(vl_desconto_documento, 0))
                                           + sum(isnull(vl_abatimento_documento, 0))
                                           - sum(isnull(vl_despesa_bancaria, 0))
                                           - sum(isnull(vl_reembolso_documento, 0))
                                           - sum(isnull(vl_credito_pendente, 0))
                                         from Documento_Receber_Pagamento
                                         where cd_documento_receber = @cd_documento_receber)

              update
                Documento_Receber
              set
                dt_pagto_document_receber = @dt_pagamento_documento,
                vl_pagto_document_receber = @vl_pagamento_total,
                cd_tipo_liquidacao        = 4   -- recebimento
              where
                cd_documento_receber = @cd_documento_receber

             end
           
--    end  
end
else
-----------------------------------------------------------------------------------------
if @ic_parametro = 3  --Alteração de pagamento para documento informado
-----------------------------------------------------------------------------------------
begin

-- Márcio - 03/06/05 - Comentado pois está verificação é feita  no Delphi, por uma flag

      --Verificando se data informada para pagamento é superior ou igual a data de emissão do documento
--       if @dt_pagamento_documento < (select
--                                       dt_emissao_documento
--                                     from
--                                       Documento_Receber
--                                     where
--                                       cd_documento_receber = @cd_documento_receber)
--       begin
--         raiserror('Data de pagamento informada é inferior a data de emissão do documento!', 16, 1)
--         goto TrataErro
--       end
--       else
--       begin    


        --Alterando pagamento do documento informado
        update
          Documento_Receber_Pagamento
        set
          dt_pagamento_documento	= @dt_pagamento_documento,
          vl_pagamento_documento	= (isnull(@vl_pagamento_documento, 0)),
          vl_juros_pagamento		= isnull(@vl_juros_pagamento,0),
          vl_desconto_documento		= isnull(@vl_desconto_documento,0),    
          vl_abatimento_documento	= isnull(@vl_abatimento_documento,0),
          vl_despesa_bancaria		= isnull(@vl_despesa_bancaria,0),
          cd_recibo_documento		= @cd_recibo_documento,
          ic_tipo_abatimento		= @ic_tipo_abatimento,
          ic_tipo_liquidacao		= @ic_tipo_liquidacao,
          vl_reembolso_documento	= isnull(@vl_reembolso_documento,0),
          vl_credito_pendente		= isnull(@vl_credito_pendente, 0),
          ic_desconto_comissao		= @ic_desconto_comissao,
          cd_usuario			= @cd_usuario,
          dt_usuario			= @dt_usuario,
          nm_obs_documento 		= @nm_obs_documento,
          cd_tipo_liquidacao            = @cd_tipo_liquidacao,
          cd_banco                      = @cd_banco,
          cd_conta_banco                = @cd_conta_banco,
          cd_tipo_caixa                 = @cd_tipo_caixa
        where
          cd_documento_receber = @cd_documento_receber
          and cd_item_documento_receber = @cd_item_documento_receber
        
        --Calculando novo saldo
        set @vl_saldo_documento = (select
                                     vl_documento_receber
                                   from
                                     Documento_Receber
                                   where
                                     cd_documento_receber = @cd_documento_receber)
                                   - isnull((select sum(isnull(vl_pagamento_documento, 0))
                                   - sum(isnull(vl_juros_pagamento, 0))
                                   - sum(isnull(vl_despesa_bancaria, 0))
                                   - sum(isnull(vl_reembolso_documento, 0))
                                   + sum(isnull(vl_desconto_documento, 0))
                                   + sum(isnull(vl_abatimento_documento, 0))
                                   - sum(isnull(vl_credito_pendente, 0))
                                   from Documento_Receber_Pagamento
                                   where cd_documento_receber = @cd_documento_receber), 0)

        --Atualizando Documento_Receber
        update
          Documento_Receber
        set
          vl_saldo_documento = cast(str(@vl_saldo_documento,25,2) as decimal(25,2))
        where
          cd_documento_receber = @cd_documento_receber

        -- caso depois da alteração o documento ainda conter saldo limpar os 
        -- campos de pagamento total e o tipo de liquidação
        if @vl_saldo_documento <> 0 

          update
            Documento_receber
          set
            dt_pagto_document_receber = null,
            vl_pagto_document_receber = null,
            cd_tipo_liquidacao        = null
          -- ELIAS 25/05/2004
          where
            cd_documento_receber = @cd_documento_receber


--      end
end
else
-----------------------------------------------------------------------------------------
if @ic_parametro = 4  --Exclusão de pagamento para documento informado
-----------------------------------------------------------------------------------------
begin

  --Excluindo pagamento do documento informado
  delete from
    Documento_Receber_Pagamento
  where
    cd_documento_receber = @cd_documento_receber
    and cd_item_documento_receber = @cd_item_documento_receber

  --Calculando novo saldo
  set @vl_saldo_documento = (select
                               vl_documento_receber
                             from
                               Documento_Receber
                             where
                               cd_documento_receber = @cd_documento_receber)
                             - isnull((select sum(isnull(vl_pagamento_documento, 0))
                             + sum(isnull(vl_desconto_documento, 0))
                             + sum(isnull(vl_abatimento_documento, 0))
                             from Documento_Receber_Pagamento
                             where cd_documento_receber = @cd_documento_receber), 0)
  --Atualizando Documento_Receber
  update
    Documento_Receber
  set
    vl_saldo_documento = cast(str(@vl_saldo_documento,25,2) as decimal(25,2))
  where
    cd_documento_receber = @cd_documento_receber

  -- caso depois da exclusão o documento ainda conter saldo limpar os 
  -- campos de pagamento total e tipo de liquidação

  if @vl_saldo_documento <> 0 
    update
      Documento_receber
    set
      dt_pagto_document_receber = null,
      vl_pagto_document_receber = null,
      cd_tipo_liquidacao = null
    -- ELIAS 25/05/2004
    where
      cd_documento_receber = @cd_documento_receber


end

--Confima Transação Caso Não Tenha Ocorrido Nenhum Erro
TrataErro:
  if @@Error = 0
    commit transaction
  else
    rollback transaction

