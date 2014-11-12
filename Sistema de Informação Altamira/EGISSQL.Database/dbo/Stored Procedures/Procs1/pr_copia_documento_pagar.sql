
-------------------------------------------------------------------------------
--sp_helptext pr_copia_documento_pagar
-------------------------------------------------------------------------------
--pr_copia_documento_pagar
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cópia de Documento a Pagar
--Data             : 17.12.2008
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_documento_pagar
@cd_documento_pagar int         = 0, --Documento Origem
@cd_identificacao     varchar(25) = ''

as

--select * from documento_pagar

if @cd_documento_pagar>0 and @cd_identificacao<>'' 
begin
  select
    *
  into 
    #documento_pagar
  from  
    documento_pagar with (nolock) 
  where 
    cd_documento_pagar = @cd_documento_pagar and
    @cd_identificacao not in ( select cd_identificacao_document from documento_pagar )

  --gera novo numero interno

  declare @Tabela            varchar(80)
  declare @cd_documento_novo int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(80))

  -- campo chave utilizando a tabela de códigos  
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_novo output  

  while exists(Select top 1 'x' from documento_pagar where cd_documento_pagar = @cd_documento_novo)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_novo output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'
  end


  --update do novo código e identificação

  update
    #documento_pagar
  set
    cd_documento_pagar          = @cd_documento_novo,
    cd_identificacao_document   = @cd_identificacao


  --gera cópia do documento

  insert into
    documento_pagar
  select
    *
  from
    #documento_pagar

  --Libero o novo código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'

end


