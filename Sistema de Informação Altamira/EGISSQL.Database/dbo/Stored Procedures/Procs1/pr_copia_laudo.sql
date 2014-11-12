
--use egissql
-------------------------------------------------------------------------------
--sp_helptext pr_copia_laudo
-------------------------------------------------------------------------------
--pr_copia_laudo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : 
--Data             : 08.11.2010
--Alteração        : 
--
-- 02.12.2010 - novo campo do lote do fabricante - Carlos Fernandes
-- 08.12.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_copia_laudo
@cd_laudo_origem int = 0


as


if @cd_laudo_origem>0 
begin

  declare @Tabela		     varchar(80)
  declare @cd_laudo                  int
  declare @dt_laudo                  datetime

  set @dt_laudo = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

  set @Tabela   = cast(DB_NAME()+'.dbo.Laudo' as varchar(80))
  set @cd_laudo = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_laudo', @codigo = @cd_laudo output
	
  while exists(Select top 1 'x' from Laudo
               where cd_laudo = @cd_laudo
               order by cd_laudo)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_laudo', @codigo = @cd_laudo output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_laudo, 'D'
  end

  select
    *
  into
    #Laudo
  from
    Laudo with (Nolock) 
  where
    cd_laudo = @cd_laudo_origem



  update
    #Laudo
  set
    cd_laudo        = @cd_laudo,
    dt_laudo        = @dt_laudo,
    cd_lote_interno = ''


  insert into Laudo
  select * from #laudo
  where
    cd_laudo not in ( select cd_laudo from laudo )



  --Complementar com outras tabelas---------------------------------------------------

  select
    *
  into
    #Laudo_Caracteristica
  from
    Laudo_Caracteristica
  where
    cd_laudo = @cd_laudo_origem
  
  update
    #Laudo_Caracteristica
  set
    cd_laudo = @cd_laudo


  insert into
    Laudo_Caracteristica
  select * from #Laudo_Caracteristica


  select
    *
  into
    #Laudo_Aplicacao
  from
    Laudo_Aplicacao
  where
    cd_laudo = @cd_laudo_origem
  
  update
    #Laudo_Aplicacao
  set
    cd_laudo = @cd_laudo


  insert into
    Laudo_Aplicacao
  select * from #Laudo_Aplicacao


  -- Produto Químico ----------------------------------------------

  select
    *
  into
    #Laudo_Produto_Quimico
  from
    Laudo_Produto_Quimico
  where
    cd_laudo = @cd_laudo_origem
  
  update
    #Laudo_Produto_Quimico
  set
    cd_laudo = @cd_laudo


  insert into
    Laudo_Produto_Quimico
  select * from #Laudo_Produto_Quimico


  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_laudo, 'D'


  drop table #Laudo_Produto_Quimico
  drop table #Laudo_Aplicacao
  drop table #Laudo_Caracteristica
  drop table #Laudo

  select @cd_laudo as 'cd_laudo'


end


--select * from laudo

