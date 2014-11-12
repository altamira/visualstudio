
--use egissql
-------------------------------------------------------------------------------
--sp_helptext pr_gera_laudo_item_guia_fracionamento
-------------------------------------------------------------------------------
--pr_gera_laudo_item_guia_fracionamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Geração do Laudo da Guia de Fracionamento
--
--Data             : 18.11.2010
--Alteração        : 
--
-- 02.12.2010 - Ajustes Diversos - Carlos Fernandes
-- 08.12.2010 - Verificação - Carlos Fernandes
-- 09.12.2010 - Datas do Laudo - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_laudo_item_guia_fracionamento
@cd_guia_fracionamento      int = 0,
@cd_item_guia_fracionamento int = 0,
@cd_usuario                 int = 0
as


if @cd_guia_fracionamento>0 
begin

  declare @Tabela		     varchar(80)
  declare @cd_laudo                  int
  declare @dt_laudo                  datetime
  declare @cd_laudo_origem           int
  declare @dt_hoje                   datetime

  set @dt_hoje  = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
 
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
    @cd_laudo_origem = isnull(cd_laudo,0)
  from
    guia_fracionamento with (nolock)
  where
    cd_guia_fracionamento = @cd_guia_fracionamento

  select
    *
  into
    #Laudo
  from
    Laudo with (nolock)
  where
    cd_laudo = @cd_laudo_origem

  declare @qt_laudo        float
  declare @cd_produto          int
  declare @cd_lote_interno     varchar(25)
  declare @nm_fantasia_produto varchar(30)

  --select * from guia_fracionamento_item
  --select * from produto_fracionamento

  select 
    @qt_laudo              = isnull(qt_fracionada,0),
    @cd_produto            = isnull(pf.cd_produto_fracionado,0),
    @cd_lote_interno       = isnull(cd_lote_fracionamento,''),
    @nm_fantasia_produto   = p.nm_fantasia_produto

  from
    guia_fracionamento_item gfi              with (nolock) 
    left outer join produto_fracionamento pf with (nolock) on pf.cd_produto_fracionamento = gfi.cd_produto_fracionamento
    left outer join produto p                with (nolock) on p.cd_produto                = pf.cd_produto_fracionado


  where
    gfi.cd_guia_fracionamento      = @cd_guia_fracionamento       and
    gfi.cd_item_guia_fracionamento = @cd_item_guia_fracionamento  
    
  
  --select * from laudo

  update
    #Laudo
  set
    cd_laudo         = @cd_laudo,
    dt_laudo         = @dt_laudo,
    cd_lote_interno  = @cd_lote_interno,
    cd_usuario       = @cd_usuario,
    cd_produto       = @cd_produto,
    qt_laudo         = @qt_laudo,
    nm_produto_laudo = @nm_fantasia_produto,

    dt_fabricacao    = case when dt_fabricacao is null then
                         @dt_hoje
                       else
                         dt_fabricacao
                       end,

    dt_validade      = case when dt_validade is null then
                         @dt_hoje
                       else
                         dt_validade
                       end


    
  --select * from guia_fracionamento_item
  --select * from laudo

  insert into Laudo
  select * from #laudo
  where
    cd_laudo not in ( select cd_laudo from laudo with (nolock) )



  --Complementar com outras tabelas---------------------------------------------------

  select
    *
  into
    #Laudo_Caracteristica
  from
    Laudo_Caracteristica with (nolock)
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
    Laudo_Aplicacao with (nolock)
  where
    cd_laudo = @cd_laudo_origem
  
  update
    #Laudo_Aplicacao
  set
    cd_laudo = @cd_laudo


  insert into
    Laudo_Aplicacao
  select * from #Laudo_Aplicacao


  -- Produto Químico ----------------------------------------------------------------

  select
    *
  into
    #Laudo_Produto_Quimico
  from
    Laudo_Produto_Quimico with (nolock)
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

  -------------------------------------------------------------------------------

  update
    guia_fracionamento_item
  set
    cd_laudo = @cd_laudo
  where
    cd_guia_fracionamento = @cd_guia_fracionamento    

  --------------------------------------------------------------------------------

  drop table #Laudo_Produto_Quimico
  drop table #Laudo_Aplicacao
  drop table #Laudo_Caracteristica
  drop table #Laudo

  --select @cd_laudo as 'cd_laudo'

end


--select * from laudo

