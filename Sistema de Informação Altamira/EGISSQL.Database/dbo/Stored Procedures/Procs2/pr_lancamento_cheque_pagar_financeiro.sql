
create procedure pr_lancamento_cheque_pagar_financeiro
@ic_parametro    int,
@cd_cheque_pagar int,
@cd_banco        int,
@cd_conta_banco  int,
@cd_usuario      int = 0

as

  declare @cd_lancamento           int
  declare @dt_lancamento           datetime
  declare @vl_lancamento           float
  declare @nm_historico_lancamento varchar(40)
  declare @cd_plano_financeiro     int  
  declare @ic_baixado              char(1)

  declare @nm_tabela               varchar(50)
  declare @cd_empresa              int

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Na Inclusão / Modificação do Cheque
-------------------------------------------------------------------------------
begin

  -- seleciona a empresa
  select
    @cd_empresa = cd_empresa
  from
    Conta_Agencia_Banco
  where
    cd_conta_banco = @cd_conta_banco

  -- seleciona o cheque

  select
    @dt_lancamento           = dt_liquidacao_cheque,
    @vl_lancamento           = vl_cheque_pagar,
    @nm_historico_lancamento = case when (isnull(nm_favorecido,'') = '') then
                                 'Cheque '+cast(cd_cheque_pagar as varchar)
                               else
                                 'Cheque '+cast(cd_cheque_pagar as varchar) + ' - ' +
                                 nm_favorecido
                               end,
    @ic_baixado              = isnull(ic_baixado_cheque_pagar,'N'),
    @cd_lancamento           = cd_lancamento,
    @cd_plano_financeiro     = isnull((select top 1 
                                     isnull(d.cd_plano_financeiro,0)
                                   from 
                                     documento_pagar d,
                                     documento_pagar_pagamento p
                                   where
                                     d.cd_documento_pagar = p.cd_documento_pagar and
                                     p.cd_tipo_pagamento  = 2 and
                                     p.cd_identifica_documento = cast(@cd_cheque_pagar as varchar(30))),0)

--Alterado Carlos/Robson - 10.08.2007
--                                   (select 
--                                      isnull(cd_plano_financeiro,0) 
--                                    from 
--                                      parametro_financeiro
--                                    where
--                                      cd_empresa = dbo.fn_empresa()))

  from
    cheque_pagar
  where
    cd_cheque_pagar = @cd_cheque_pagar and
    cd_banco        = @cd_banco

  -- caso esteja baixado então modificar de PREVISTO p/ REALIZADO

  if @ic_baixado = 'S' 
    begin

      -- localiza o lançamento e muda-o de PREVISTO p/ REALIZADO
      if exists(select top 1 'x' from conta_banco_lancamento where cd_lancamento = @cd_lancamento)
        begin

          -- Exclui ele do PREVISTO
          delete from
            conta_banco_lancamento
          where
            cd_lancamento = @cd_lancamento

          -- Inclui como Realizado
          insert into Conta_Banco_Lancamento
            (cd_lancamento,
             dt_lancamento,
             vl_lancamento,
             nm_historico_lancamento,
             cd_conta_banco,
             cd_plano_financeiro,
             cd_tipo_operacao, 
             cd_historico_financeiro,
             cd_moeda,
             cd_usuario,
             dt_usuario,
             cd_tipo_lancamento_fluxo,
             ic_lancamento_conciliado,
             cd_empresa)
          select
             @cd_lancamento,
             @dt_lancamento,
             @vl_lancamento,
             @nm_historico_lancamento,
             @cd_conta_banco,
             @cd_plano_financeiro,
             2,  -- Débito
             null,
             1,  -- Real
             @cd_usuario,
             getDate(),
             2,  -- Realizado
             'N',
             @cd_empresa
        end


      else
        -- inclui um novo lançamento
        begin

          -- geração do código único da Conta_Banco_Lancamento
          set @nm_tabela = cast(DB_NAME()+'.dbo.Conta_Banco_Lancamento' as varchar(50))
          exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_lancamento', @codigo = @cd_lancamento output

          insert into Conta_Banco_Lancamento
            (cd_lancamento,
             dt_lancamento,
             vl_lancamento,
             nm_historico_lancamento,
             cd_conta_banco,
             cd_plano_financeiro,
             cd_tipo_operacao, 
             cd_historico_financeiro,
             cd_moeda,
             cd_usuario,
             dt_usuario,
             cd_tipo_lancamento_fluxo,
             ic_lancamento_conciliado,
             cd_empresa)
          select
             @cd_lancamento,
             @dt_lancamento,
             @vl_lancamento,
             @nm_historico_lancamento,
             @cd_conta_banco,
             @cd_plano_financeiro,
             2,  -- Débito
             null,
             1,  -- Real
             @cd_usuario,
             getDate(),
             2,  -- Realizado
             'N',
             @cd_empresa

          -- liberação do código gerado p/ PegaCodigo
          exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_lancamento, 'D'

        end             
    end
  else
    begin

      -- localiza o lançamento e acerta o valor do cheque
      -- (Os cheques podem ser modificados no SCP antes de baixados através da elaboração 
      --  num cheque existente e ainda não baixado de documentos novos)
      if exists(select top 1 'x' from conta_banco_lancamento where cd_lancamento = @cd_lancamento)
        begin

          update
            conta_banco_lancamento
          set
            vl_lancamento = @vl_lancamento
          where 
            cd_lancamento = @cd_lancamento

        end
      else
        begin      
       

          -- Incluíndo um Lançamento como Previsto                  

          -- geração do código único do pedido_venda_historico
          set @nm_tabela = cast(DB_NAME()+'.dbo.Conta_Banco_Lancamento' as varchar(50))
          exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_lancamento', @codigo = @cd_lancamento output

          insert into Conta_Banco_Lancamento
            (cd_lancamento,
             dt_lancamento,
             vl_lancamento,
             nm_historico_lancamento,
             cd_conta_banco,
             cd_plano_financeiro,
             cd_tipo_operacao, 
             cd_historico_financeiro,
             cd_moeda,
             cd_usuario,
             dt_usuario,
             cd_tipo_lancamento_fluxo,
             ic_lancamento_conciliado,
             cd_empresa)
          select
             @cd_lancamento,
             @dt_lancamento,
             @vl_lancamento,
             @nm_historico_lancamento,
             @cd_conta_banco,
             @cd_plano_financeiro,
             2,  -- Débito
             null,
             1,  -- Real
             @cd_usuario,
             getDate(),
             1,  -- Previsto
             'S',
             @cd_empresa

           -- liberação do código gerado p/ PegaCodigo
          exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_lancamento, 'D'


        end
    end

  -- Atualiza o campo de lançamento no cheque
  update
    cheque_pagar 
  set
    cd_lancamento = @cd_lancamento
  where
    cd_cheque_pagar = @cd_cheque_pagar and
    cd_banco = @cd_banco

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- Deleção de Lançamento
-------------------------------------------------------------------------------
begin

  -- encontra o código do lançamento
  select
    @cd_lancamento = cd_lancamento
  from
    cheque_pagar 
  where
    cd_cheque_pagar = @cd_cheque_pagar and
    cd_banco        = @cd_banco

  -- apaga o registro de lancamento
  delete from
    Conta_Banco_Lancamento
  where
    cd_lancamento = @cd_lancamento

end  

  
