
-------------------------------------------------------------------------------
--sp_helptext pr_gera_pendencia_pedido_venda
-------------------------------------------------------------------------------
--pr_gera_pendencia_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração das Pendências do Pedido de Venda
--                   Entrada Automática de Pedido ou Manual
--                     
--Data             : 24.09.2008
--Alteração        : 
--02.12.2008 - Ajustes - Carlos Fernandes
--06.01.2009 - Item do Pedido de Venda - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_pendencia_pedido_venda
@cd_pedido_venda       int         = 0,
@cd_tipo_pendencia     int         = 0,
@cd_usuario            int         = 0,
@nm_obs_tipo_pendencia varchar(40) = '',
@cd_item_pedido_venda  int         = 0

as

--pedido_venda_pendencia

if @cd_pedido_venda > 0 and @cd_tipo_pendencia > 0
begin

  declare @cd_pedido_pendencia int
 
  select 
    @cd_pedido_pendencia =  max( isnull(cd_pedido_pendencia,0) )
  from
    pedido_venda_pendencia with (nolock) 
 
  if @cd_pedido_pendencia = 0 or @cd_pedido_pendencia is null    
     set @cd_pedido_pendencia = 0

  set @cd_pedido_pendencia = @cd_pedido_pendencia + 1

  insert into 
    pedido_venda_pendencia
  select
    @cd_pedido_venda       as cd_pedido_venda,
    @cd_tipo_pendencia     as cd_tipo_pendenca,
    @nm_obs_tipo_pendencia as nm_obs_tipo_pendencia,
    null                   as cd_usuario_liberacao,
    null                   as dt_liberacao_pendencia,
    @cd_usuario            as cd_usuario,
    getdate()              as dt_usuario,
    @cd_item_pedido_venda  as cd_item_pedido_venda,
    @cd_pedido_pendencia   as cd_pedido_pendencia

--   where
--     @cd_pedido_pendencia not in ( select cd_pedido_pendencia from pedido_venda_pendencia )

end


--select * from tipo_pendencia_financeira

