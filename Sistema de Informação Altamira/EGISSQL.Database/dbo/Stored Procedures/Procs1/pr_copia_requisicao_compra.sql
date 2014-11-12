
-------------------------------------------------------------------------------
--sp_helptext pr_copia_requisicao_compra
-------------------------------------------------------------------------------
--pr_copia_requisicao_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cópia da Requisição de Compra
--Data             : 27.08.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_copia_requisicao_compra
@cd_requisicao_compra int = 0

as

--

if @cd_requisicao_compra > 0 
begin

  --gera novo numero interno

  declare @Tabela            varchar(80)
  declare @cd_documento_novo int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Requisicao_Compra' as varchar(80))

  -- campo chave utilizando a tabela de códigos  
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_requisicao_compra', @codigo = @cd_documento_novo output  

  while exists(Select top 1 'x' from Requisicao_Compra where cd_requisicao_compra = @cd_documento_novo)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_requisicao_compra', @codigo = @cd_documento_novo output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'
  end

  --Requisição de Compra

  select
    *
  into
    #requisicao_compra

  from
    requisicao_compra with (nolock) 

  where
    cd_requisicao_compra = @cd_requisicao_compra

  --Item da Requisição de Compra

  select
    *
  into
    #requisicao_compra_item

  from
    requisicao_compra_item with (nolock) 

  where
    cd_requisicao_compra = @cd_requisicao_compra


  --Atualiza o Número da Requisição

  update
    #requisicao_compra
  set
    cd_requisicao_compra = @cd_documento_novo

  update
    #requisicao_compra_item
  set
    cd_requisicao_compra = @cd_documento_novo


  --Gera a Cópia da Requisição de Compra

  insert into
    requisicao_compra
  select
    *
  from
    #requisicao_compra

  --Itens da Requisição de Compra

  insert into
    requisicao_compra_item
  select
    *
  from
    #requisicao_compra_item

  --Liberação de Ajuste dos flag para novo processamento desta requisição copiada
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'
  

end


