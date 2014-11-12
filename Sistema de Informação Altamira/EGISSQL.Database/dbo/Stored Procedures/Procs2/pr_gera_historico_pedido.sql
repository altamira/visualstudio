
-------------------------------------------------------------------------------
--sp_helptext pr_gera_historico_pedido
-------------------------------------------------------------------------------
--pr_gera_historico_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Histórico de pedido de Venda
--Data             : 27.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_historico_pedido
@ic_parametro         int         = 0,
@cd_pedido_venda      int         = 0,
@cd_item_pedido_venda int         = 0,
@cd_historico_pedido  int         = 0,
@dt_historico         datetime    = '',
@nm_historico_1       varchar(50) = '',
@nm_historico_2       varchar(50) = '',
@nm_historico_3       varchar(50) = '',
@nm_historico_4       varchar(50) = '',
@cd_usuario           int         = 0

as

--Inclusão do Histórico

if @ic_parametro = 1
begin

  declare @Tabela		      varchar(80)
  declare @cd_pedido_venda_historico  int 

  -- Nome da Tabela usada na geração e liberação de códigos

  set @Tabela          = cast(DB_NAME()+'.dbo.Pedido_Venda_Historico' as varchar(80))
  set @cd_pedido_venda_historico = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda_historico', @codigo = @cd_pedido_venda_historico output
	
  while exists(Select top 1 'x' from pedido_venda_historico where cd_pedido_venda_historico = @cd_pedido_venda_historico)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda_historico', @codigo = @cd_pedido_venda_historico output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda_historico, 'D'
  end

  --select * from pedido_venda_historico 
  select @cd_pedido_venda_historico

  if not exists( select top 1 cd_pedido_venda_historico from pedido_venda_historico 
                 where
                   cd_pedido_venda_historico = @cd_pedido_venda_historico )
  begin
    --select * from historico_pedido
    select 
      @nm_historico_1 = isnull(nm_historico_pedido,@nm_historico_1)
    from
      historico_pedido 
    where
      cd_historico_pedido = @cd_historico_pedido

  --pedido_venda_historico

  select
    @cd_pedido_venda_historico as cd_pedido_venda_historico,
    @cd_pedido_venda           as cd_pedido_venda,
    @dt_historico              as dt_pedido_venda_historico,
    @cd_historico_pedido       as cd_historico_pedido,
    @nm_historico_1            as nm_pedido_venda_histor_1,
    @nm_historico_2            as nm_pedido_venda_histor_2,
    @nm_historico_3            as nm_pedido_venda_histor_3,
    @nm_historico_4            as nm_pedido_venda_histor_4,
    null                       as cd_tipo_status_pedido,
    @cd_item_pedido_venda      as cd_item_pedido_venda,
    null                       as cd_modulo,
    null                       as cd_departamento,
    @cd_historico_pedido       as cd_processo,
    @cd_usuario                as cd_usuario,
    getdate()                  as dt_usuario,
    @nm_historico_1            as nm_pedido_venda_historico_1,
    @nm_historico_2            as nm_pedido_venda_historico_2,
    @nm_historico_3            as nm_pedido_venda_historico_3,
    @nm_historico_4            as nm_pedido_venda_historico_4

  into
    #pedido_venda_historico

  insert into
    pedido_venda_historico
  select
     *
  from
     #pedido_venda_historico

  drop table #pedido_venda_historico

  end 

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda_historico, 'D'

end



