
-------------------------------------------------------------------------------
--pr_copia_cotacao_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 08.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_cotacao_fornecedor
@cd_cotacao_origem     int = 0,
@cd_fornecedor         int = 0,
@cd_contato_fornecedor int = 0,
@cd_usuario            int = 0

as

declare @Tabela		     varchar(50)
declare @cd_cotacao          int


if @cd_cotacao_origem>0 
begin
  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Cotacao' as varchar(50))

  -- campo chave utilizando a tabela de códigos
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_cotacao', @codigo = @cd_cotacao output

  --Montagem das Tabelas Auxiliares
 
  select
    *
  into 
    #Cotacao
  from
    Cotacao
  where
    cd_cotacao = @cd_cotacao_origem

  select
    *
  into
    #CotacaoItem
  from
    Cotacao_Item
  where
    cd_cotacao = @cd_cotacao_origem

  --Atualização das Tabelas Auxiliares para Gravação

  update
    #Cotacao
  set
    cd_cotacao               = @cd_cotacao,
    dt_cotacao               = dbo.fn_data(getdate()),
    cd_fornecedor            = @cd_fornecedor,
    ic_lista_cotacao         = 'N',
    dt_fechamento_cotacao    = null,
    ic_pedido_compra_cotacao = 'N',
    cd_usuario               = @cd_usuario,
    dt_usuario               = dbo.fn_data(getdate()),
    ic_listado_cotacao       = 'N',
    ic_retorno_fornecedor    = 'N',
    dt_retorno_fornecedor    = null
  where
    cd_cotacao = @cd_cotacao_origem

  update
    #CotacaoItem
  set
    cd_cotacao               = @cd_cotacao,
    cd_usuario               = @cd_usuario,
    dt_usuario               = dbo.fn_data(getdate()),
    ic_pedido_compra_cotacao = 'N',
    ic_fechar_negocio        = 'N'
    
  where
    cd_cotacao = @cd_cotacao_origem

  
  --select * from Cotacao
  --select * from Cotacao_Item

  --Grava a Cotação

  insert into
    Cotacao
  select
    * 
  from
    #Cotacao

  --Grava os Itens da Cotação
 
  insert into
    Cotacao_Item
  select
    * 
  from
    #CotacaoItem 
  
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_cotacao, 'D'

  select @cd_cotacao 
end
