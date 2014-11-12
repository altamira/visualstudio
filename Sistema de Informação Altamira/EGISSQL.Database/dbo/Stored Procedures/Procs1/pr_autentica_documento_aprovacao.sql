
-------------------------------------------------------------------------------
--sp_helptext pr_autentica_documento_aprovacao
-------------------------------------------------------------------------------
--pr_autentica_documento_aprovacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 12.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_autentica_documento_aprovacao
@cd_documento_aprovacao      varchar(15) = '',
@ic_tipo_documento_aprovacao varchar(02) = ''

as

declare @cd_documento         int
declare @cd_documento_retorno int

set @cd_documento         = cast( @cd_documento_aprovacao as int )
set @cd_documento_retorno = 0

if @cd_documento_aprovacao<>'' 
begin


  if @ic_tipo_documento_aprovacao = 'RV'
  begin
    select
      @cd_documento_retorno = isnull(cd_requisicao_viagem,0)
    from
      requisicao_viagem rv with (nolock)
    where
      cd_requisicao_viagem = @cd_documento    
  
  end

end


select @cd_documento_retorno as cd_documento_retorno


