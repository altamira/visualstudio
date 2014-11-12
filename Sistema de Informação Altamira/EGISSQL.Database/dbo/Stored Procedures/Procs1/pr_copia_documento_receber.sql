
-------------------------------------------------------------------------------
--sp_helptext pr_copia_documento_receber
-------------------------------------------------------------------------------
--pr_copia_documento_receber
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cópia de Documento a Receber
--Data             : 22.11.2007
--Alteração        : 12.12.2008 - Douglas / Carlos - Finalização da procedure
------------------------------------------------------------------------------
create procedure pr_copia_documento_receber
@cd_documento_receber int         = 0, --Documento Origem
@cd_identificacao     varchar(25) = ''

as

if @cd_documento_receber>0 and @cd_identificacao<>'' 
begin
  select
    *
  into 
    #documento_receber
  from  
    documento_receber 
  where 
    cd_documento_receber = @cd_documento_receber and
    @cd_identificacao not in ( select cd_identificacao from documento_receber )

  --gera novo numero interno

  declare @Tabela            varchar(80)
  declare @cd_documento_novo int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(80))

  -- campo chave utilizando a tabela de códigos  
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_novo output  

  while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_novo)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_novo output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'
  end


  --update do novo código e identificação

  update
    #documento_receber
  set
    cd_documento_receber = @cd_documento_novo,
    cd_identificacao     = @cd_identificacao


  --gera cópia do documento

  insert into
    documento_receber
  select
    *
  from
    #documento_receber

  --Libero o novo código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'

end


