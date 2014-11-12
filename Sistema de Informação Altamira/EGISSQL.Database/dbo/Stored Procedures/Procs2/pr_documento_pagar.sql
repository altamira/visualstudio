
CREATE PROCEDURE pr_documento_pagar
@ic_parametro             int,
@ic_bordero               char(1),  -- operação c/ Borderô (S)/Operação s/ Borderô (N)
@cd_documento_pagar       int,
@cd_item_pagamento        int,
@dt_pagamento_documento   datetime,
@vl_pagamento_documento   numeric(25,2),
@cd_identifica_documento  varchar(50),
@vl_juros_documento_pagar numeric(25,2),
@vl_desconto_documento    numeric(25,2),
@vl_abatimento_documento  numeric(25,2),
@cd_recibo_documento      varchar(10),
@cd_tipo_pagamento        int,
@nm_obs_documento_pagar   varchar(50),
@ic_deposito_conta        char(1),
@cd_usuario               int = 0,
@cd_conta_banco           int = 0,
@cd_tipo_caixa            int = null

as

  declare @cd_tp_pagto_bordero     int
  declare @ic_bordero_baixado      char(1)
  declare @ic_caixa_tipo_pagamento char(1)
  declare @cd_situacao_documento   int

  -- carrega tipo de pagamento (Borderô)
  -- select * from tipo_pagamento_documento

  select
    @cd_situacao_documento = isnull(cd_situacao_documento,0)
  from
    Situacao_Documento_pagar with (nolock) 
  where
    isnull(ic_situacao_documento,'N')='S'

  select
    @cd_tp_pagto_bordero   = cd_tipo_pagamento
    --@cd_situacao_documento = cd_situacao_documento
  from
    tipo_pagamento_documento with (nolock) 
  where                         
    upper(substring(sg_tipo_pagamento, 1, 6)) = 'BORDER'
    
begin transaction

-------------------------------------------------------------------------------
-- verifica se documento esta vinculado a bordero
-------------------------------------------------------------------------------
/*  if exists(select 
              d.cd_identifica_documento 
            from
              documento_pagar_pagamento d
            left outer join
              bordero b
            on
              d.cd_identifica_documento = b.cd_bordero
            where
              d.cd_documento_pagar = @cd_documento_pagar and
              d.cd_tipo_pagamento = @cd_tp_pagto_bordero and
              b.ic_baixado_bordero = 'S') 
    begin
      raiserror('Documento vinculado a Borderô já Liquidado! Operação não Permitida.', 16, 1)
      goto TrataErro
    end  */

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- inserção de pagamento
-------------------------------------------------------------------------------
begin

    -- variaveis usadas na inserção
    declare @cd_item_novo int
    set     @cd_item_novo = 0

    -- documento já baixado
    if(select
         isnull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0) as 'vl_saldo_documento_pagar'
       from
         documento_Pagar with (nolock) 
       where
         cd_documento_pagar = @cd_documento_pagar) = 0
      begin
        raiserror('Documento já liquidado, Operação Abortada !!!',16,1)
        goto TrataErro
      end
    else
      -- valor pago maior que saldo do documento
      if @vl_pagamento_documento > (select
                                    (cast(vl_saldo_documento_pagar as decimal(25,2))+
                                    cast(isnull(vl_desconto_documento,0) as decimal(25,2))+
                                    cast(isnull(vl_abatimento_documento,0) as decimal(25,2))-
                                    cast(isnull(vl_juros_documento,0) as decimal(25,2))) as 'vl_saldo_documento_pagar'
                                  from
                                    documento_Pagar
                                  where
                                    cd_documento_pagar = @cd_documento_pagar)
        begin
          raiserror('Valor do Pagamento é Superior ao Saldo a Pagar', 16, 1)
          goto TrataErro
        end
      else
        begin

          -- novo código de item
          select 
            @cd_item_novo = isnull(max(cd_item_pagamento),0)+1
          from
            documento_pagar_pagamento with (nolock) 
          where
            cd_documento_pagar = @cd_documento_pagar

          -- gravacao do pagamento
          insert into
            Documento_Pagar_Pagamento
            (
            cd_documento_pagar,
            cd_item_pagamento,
            dt_pagamento_documento,
            vl_pagamento_documento,
            cd_identifica_documento,
            vl_juros_documento_pagar,
            vl_desconto_documento,
            vl_abatimento_documento,
            cd_recibo_documento,
            cd_tipo_pagamento,
            nm_obs_documento_pagar,
            ic_deposito_conta,
            dt_fluxo_doc_pagar_pagto,
            cd_usuario,
            dt_usuario,
            cd_conta_banco, 
            cd_tipo_caixa
            )    
          values
            (
            @cd_documento_pagar,
            @cd_item_novo,
            @dt_pagamento_documento,
            @vl_pagamento_documento,
            @cd_identifica_documento,
            isnull(@vl_juros_documento_pagar, 0.00),
            isnull(@vl_desconto_documento, 0.00),
            isnull(@vl_abatimento_documento, 0.00),
            @cd_recibo_documento,
            @cd_tipo_pagamento,
            @nm_obs_documento_pagar,
            @ic_deposito_conta,
            null,
            @cd_usuario,
            getdate(),
            @cd_conta_banco,
            @cd_tipo_caixa)

          -- atualizando documento (somente atualizar saldo se não for borderô)

          if @ic_bordero = 'N' 
            begin
              if (isnull(@vl_pagamento_documento,0) = 0)
                update
                  documento_pagar
                set
                  cd_situacao_documento    = @cd_situacao_documento,
                  vl_saldo_documento_pagar = (select 
                                                cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar'
                                              from
                                                documento_pagar with (nolock) 
                                              where
                                                cd_documento_pagar = @cd_documento_pagar) -
                                              ((isnull(@vl_juros_documento_pagar, 0) -
                                                isnull(@vl_desconto_documento, 0) -
                                                isnull(@vl_abatimento_documento, 0))),
                  cd_usuario = @cd_usuario,
                  dt_usuario = getDate()
                where
                  cd_documento_pagar = @cd_documento_pagar    
              else      
                update
                  documento_pagar
                set
                  cd_situacao_documento    = @cd_situacao_documento,
                  vl_saldo_documento_pagar = (select 
                                                cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar'
                                              from
                                                documento_pagar with (nolock) 
                                              where
                                                cd_documento_pagar = @cd_documento_pagar) +

                                              ((isnull(@vl_desconto_documento, 0) +
                                                isnull(@vl_abatimento_documento, 0) -
                                                isnull(@vl_juros_documento_pagar, 0)) -

                                               (isnull(@vl_pagamento_documento,0))),
                  cd_usuario = @cd_usuario,
                  dt_usuario = getDate()
                where
                  cd_documento_pagar = @cd_documento_pagar    
            end

/*            update
              documento_Pagar
            set
              vl_saldo_documento_pagar = (select
                                            cast(vl_saldo_documento_pagar as decimal(25,2))
                                          from
                                            Documento_Pagar
                                          where
                                            cd_documento_Pagar = @cd_documento_pagar)- 
                                           (@vl_pagamento_documento + 
                                           isnull(@vl_juros_documento_pagar, 0) -
                                           isnull(@vl_desconto_documento, 0) -
                                           isnull(@vl_abatimento_documento, 0)),
              cd_usuario = @cd_usuario,
              dt_usuario = getdate()
            where
              cd_documento_pagar = @cd_documento_pagar
  */  
        end

  end 

-------------------------------------------------------------------------------
else if @ic_parametro = 2 -- exclusão de pagamento
-------------------------------------------------------------------------------
  begin

    -- Só há necessidade de verificar se foi baixado se o pagamento for de borderô.
    if @cd_tipo_pagamento = 1     
      set @ic_bordero_baixado = (select 
	 	                   b.ic_baixado_bordero 
     		 	         from
			           bordero b,
			           documento_pagar_pagamento p
  	                         where
                                   p.cd_documento_pagar = @cd_documento_pagar and
                                   cast(b.cd_bordero as varchar) = p.cd_identifica_documento and
 				   p.cd_tipo_pagamento = 1)
    else
      set @ic_bordero_baixado = 'S'           
    
    -- apaga pagamento
    delete from
      documento_pagar_pagamento
    where
      @cd_documento_pagar = cd_documento_pagar and
      @cd_item_pagamento  = cd_item_pagamento


    if @ic_bordero_baixado = 'S' 
      -- atualiza documento
      -- Modificado por Carrasco.
      update
        documento_pagar
      set
        cd_situacao_documento    = 1,
        vl_saldo_documento_pagar = (select 
                                      cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar'
                                    from
                                      documento_pagar 
                                    where
                                      cd_documento_pagar = @cd_documento_pagar) +
                                    (@vl_pagamento_documento), ---
--                                     isnull(@vl_juros_documento_pagar, 0) +
--                                     isnull(@vl_desconto_documento, 0) +
--                                     isnull(@vl_abatimento_documento, 0)),
        cd_usuario = @cd_usuario,
        dt_usuario = getDate()
      where
        cd_documento_pagar = @cd_documento_pagar


  end
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- alteração do pagamento
-------------------------------------------------------------------------------
  begin

    declare @vl_pagamento_antigo  numeric(25,2)
    
    set @vl_pagamento_antigo  = 0.00
    
    -- guarda valor líquido antigo
    select 
      @vl_pagamento_antigo = isnull(vl_pagamento_documento,0)+
                             isnull(vl_juros_documento_pagar,0)-
                             isnull(vl_desconto_documento,0)-
                             isnull(vl_abatimento_documento,0)
    from
      documento_pagar_pagamento

    where
      cd_documento_pagar = @cd_documento_pagar and
      cd_item_pagamento  = @cd_item_pagamento
    
    -- altera pagamento
    update
      documento_pagar_pagamento
    set
      dt_pagamento_documento   = @dt_pagamento_documento,
      vl_pagamento_documento   = isnull(@vl_pagamento_documento, 0.00),
      cd_identifica_documento  = @cd_identifica_documento,
      vl_juros_documento_pagar = isnull(@vl_juros_documento_pagar, 0.00),
      vl_desconto_documento    = isnull(@vl_desconto_documento, 0.00),
      vl_abatimento_documento  = isnull(@vl_abatimento_documento, 0.00),
      cd_recibo_documento      = @cd_recibo_documento,
      cd_tipo_pagamento        = @cd_tipo_pagamento,
      nm_obs_documento_pagar   = @nm_obs_documento_pagar, 
      ic_deposito_conta        = @ic_deposito_conta,
      cd_usuario               = @cd_usuario,
      dt_usuario               = getDate(),
      cd_conta_banco           = @cd_conta_banco,
      cd_tipo_caixa            = @cd_tipo_caixa
    where
      cd_documento_pagar = @cd_documento_pagar and
      cd_item_pagamento = @cd_item_pagamento


    -- atualiza documento

    -- o flag ic_bordero = 'N' significa que o bordero foi baixado ou o tipo de
    -- pagamento é diferente de bordero e portanto deverá ser calculado o
    -- novo saldo. Para que não ocorra o acerto do saldo na modificação
    -- dos dados do pagamento com bordero indique 'S' - Elias 16/05/2002
    if ((@cd_tipo_pagamento <> 1) or
       ((@cd_tipo_pagamento = 1) and (@dt_pagamento_documento is not null)))
      begin

        if (isnull(@vl_pagamento_documento,0) = 0)
          begin

            update
              documento_pagar
            set
              vl_saldo_documento_pagar = (select 
                                            cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar'
                                          from
                                            documento_pagar 
                                          where
                                            cd_documento_pagar = @cd_documento_pagar) -
                                          ((isnull(@vl_juros_documento_pagar, 0) -
                                            isnull(@vl_desconto_documento, 0) -
                                            isnull(@vl_abatimento_documento, 0)) - @vl_pagamento_antigo),
              cd_usuario = @cd_usuario,
              dt_usuario = getdate()
            where
              cd_documento_pagar = @cd_documento_pagar    
          end
        else
          begin
            update
              documento_pagar
            set 
              vl_saldo_documento_pagar = vl_documento_pagar - (select 
                                                                 sum(vl_pagamento_documento)
                                                               from
                                                                 documento_pagar_pagamento 
                                                               where
                                                                 cd_documento_pagar = @cd_documento_pagar),
              cd_usuario = @cd_usuario,
              dt_usuario = getdate()
            where
              cd_documento_pagar = @cd_documento_pagar   
          end
      end
    else 
      begin
  
        if ((select
               b.ic_baixado_bordero
             from
               documento_pagar_pagamento p with (nolock)  
             left outer join 
               bordero b
             on
               b.cd_bordero = p.cd_identifica_documento
             where
               p.cd_tipo_pagamento = 1 and
               p.cd_documento_pagar = @cd_documento_pagar) = 'S')
           begin
                       
             update
               documento_pagar
             set
               vl_saldo_documento_pagar = (select 
                                             cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar'
                                           from
                                             documento_pagar 
                                           where
                                             cd_documento_pagar = @cd_documento_pagar) -
                                           (isnull(@vl_pagamento_documento,0) - @vl_pagamento_antigo),
               cd_usuario = @cd_usuario,
               dt_usuario = getdate()
             where
               cd_documento_pagar = @cd_documento_pagar    

           end
      end
  end   
-------------------------------------------------------------------------------
else if @ic_parametro = 4 -- exclusão do documento
-------------------------------------------------------------------------------
  begin

    -- verifica se documento foi pago, mesmo parcialmente.
    if exists(select * from 
                documento_pagar_pagamento
              where
                cd_documento_pagar = @cd_documento_pagar)
      begin
        raiserror('Documento Liquidado! Deleção Cancelada!', 16, 1)
        goto TrataErro
      end  

    -- exclusão dos pagamentos
    delete from
      documento_pagar_pagamento
    where
      cd_documento_pagar = @cd_documento_pagar

    -- exclusão do documento
    delete from
      documento_pagar
    where
      cd_documento_pagar = @cd_documento_pagar

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 5  -- atualização do saldo na exclusão de valor
-------------------------------------------------------------------------------
  begin

    -- verifica se documento foi pago, mesmo parcialmente.
    if exists(select * from 
                documento_pagar_pagamento with (nolock) 
              where
                cd_documento_pagar = @cd_documento_pagar)
      begin
        raiserror('Documento Liquidado! Deleção Cancelada!', 16, 1)
        goto TrataErro
      end  

    update
      documento_pagar
    set
      vl_saldo_documento_pagar = @vl_pagamento_documento -
                                 (select 
                                    isnull(sum(vl_pagamento_documento),0) -
                                    isnull(sum(vl_juros_documento_pagar),0) +
                                    isnull(sum(vl_desconto_documento),0) +
                                    isnull(sum(vl_abatimento_documento),0)
                                 from
                                   documento_pagar_pagamento with (nolock) 
                                 where
                                   cd_documento_pagar = @cd_documento_pagar),
      cd_usuario = @cd_usuario,
      dt_usuario = getDate()
    where  
      cd_documento_pagar = @cd_documento_pagar
  end  
else
  return


  -- atualizando banco de dados    
  TrataErro:
    if @@ERROR = 0

      begin
        commit tran
      end
    else
      begin
        --raiserror(@@ERROR, 16, 1)
        rollback tran
      end

