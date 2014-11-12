
create procedure pr_conta_banco_transferencia
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias Pereira da Silva
--Banco de Dados: EgisSql
--Objetivo: Transferência entre Contas Bancárias
--Data: 26/03/2003
--Atualizado: 28/03/2003 - Incluído parâmetro de Destino de Plano_Financeiro - Daniel C. Neto.
--            08/03/2003 - Incluído Histórico de Transferência Padrão - ELIAS
-- 18.06.2007 - Acerto do Histórico de transferência - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@ic_parametro             int,
@dt_transferencia         datetime,
@cd_conta_banco_origem    int,
@cd_conta_banco_destino   int,
@vl_transferencia         float,
@nm_historico_lancamento  varchar(100),
@cd_plano_financeiro      int,
@cd_plano_financeiro_dest int = 0, 
@cd_historico_financeiro  int,
@cd_usuario               int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Transferência entre contas
-------------------------------------------------------------------------------
  begin

    declare @nm_historico_debito  varchar(100)
    declare @nm_historico_credito varchar(100)
    declare @cd_empresa_debito int
    declare @cd_empresa_credito int

    declare @Tabela varchar(100)
    declare @cd_lancamento int
    
    -- Gerando o Histórico Padrão de Transferência (Débito)

    select 
      @nm_historico_debito = 'Transf. p/ Conta '+
                             cast(b.cd_numero_banco as varchar)+'/'+
                             cast(a.cd_numero_agencia_banco as varchar)+'/'+
                             cast(c.nm_conta_banco as varchar),
      @cd_empresa_credito = c.cd_empresa
    from
      Conta_Agencia_Banco c,
      Banco b,
      Agencia_Banco a
    where
      c.cd_conta_banco   = @cd_conta_banco_destino and
      b.cd_banco         = c.cd_banco and
      a.cd_banco         = c.cd_banco and
      a.cd_agencia_banco = c.cd_agencia_banco

    -- Gerando o Histórico Padrão de Transferência (Crédito)

    select 
      @nm_historico_credito = 'Transf. da Conta '+
                              cast(b.cd_numero_banco as varchar)+'/'+
                              cast(a.cd_numero_agencia_banco as varchar)+'/'+
                              cast(c.nm_conta_banco as varchar),
      @cd_empresa_debito = c.cd_empresa
    from
      Conta_Agencia_Banco c,
      Banco b,
      Agencia_Banco a
    where
      c.cd_conta_banco = @cd_conta_banco_origem and
      b.cd_banco = c.cd_banco and
      a.cd_banco = c.cd_banco and
      a.cd_agencia_banco = c.cd_agencia_banco

    set @Tabela = Db_Name() + '.dbo.Conta_Banco_Lancamento'

    -- Pega Código do Lançamento de Transferência de Origem 
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output

    -- Grava o Lançamento de Origem
    insert into
      Conta_Banco_Lancamento
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
       ic_transferencia_conta,
       cd_empresa)
    values
      (@cd_lancamento,
       @dt_transferencia,
       @vl_transferencia,
       @nm_historico_debito,       
       @cd_conta_banco_origem,
       @cd_plano_financeiro,
       2,  -- SAÍDA
       @cd_historico_financeiro,
       1,  -- REAL       
       @cd_usuario,
       getDate(),
       2,    -- Realizado      
       'N',  -- Lançamento não conciliado
       'S',  -- Lançamento de Transferência
       @cd_empresa_debito)  

    -- Libera o Código do Lançamento de Origem
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'	

    -- Pega Código do Lançamento de Transferência de Destino
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output

    -- Grava o Lançamento de Destino
    insert into
      Conta_Banco_Lancamento
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
       ic_transferencia_conta,
       cd_empresa)
    values
      (@cd_lancamento,
       @dt_transferencia,
       @vl_transferencia,
       @nm_historico_credito,       
       @cd_conta_banco_destino,
       @cd_plano_financeiro_dest,
       1,  -- ENTRADA
       @cd_historico_financeiro,
       1,  -- REAL       
       @cd_usuario,
       getDate(),
       2, -- Realizado      
       'N',  -- Lançamento não conciliado
       'S',  -- Lançamento de Transferência
       @cd_empresa_credito)
       
    -- Libera o Código do Lançamento de Destino
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'	

  end

