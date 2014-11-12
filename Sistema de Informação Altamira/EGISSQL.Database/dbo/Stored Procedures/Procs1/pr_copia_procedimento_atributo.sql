
-------------------------------------------------------------------------------
--sp_helptext pr_copia_procedimento_atributo
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cópia dos Atributos do Procedimento
--Data             : 18.12.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_procedimento_atributo
@cd_procedimento      int = 0,
@cd_procedimento_novo int = 0

as

if @cd_procedimento>0 and @cd_procedimento_novo>0
begin

  select
    * 
  into
    #Procedimento_Atributo
  from procedimento_atributo
  where
    cd_procedimento = @cd_procedimento

  update
    #Procedimento_Atributo
  set
    cd_procedimento = @cd_procedimento_novo

  insert into
    procedimento_atributo
  select
    *
  from
    #Procedimento_Atributo

  drop table #procedimento_atributo

  select
    *
  from
    procedimento_atributo
  where
    cd_procedimento = @cd_procedimento_novo

end


