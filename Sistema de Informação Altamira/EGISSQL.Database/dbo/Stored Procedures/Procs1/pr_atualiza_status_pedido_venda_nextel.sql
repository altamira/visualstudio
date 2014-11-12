
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_status_pedido_venda_nextel
-------------------------------------------------------------------------------
--pr_atualiza_status_pedido_venda_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 07.05.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualiza_status_pedido_venda_nextel
@cd_pedido_venda int = 0
as

if @cd_pedido_venda > 0 
begin

  if not exists ( select top 1 cd_pedido_venda
              from
                pedido_venda_status with (nolock) 
              where
                cd_pedido_venda = @cd_pedido_venda )

  begin
    insert into
      pedido_venda_status
    select
      @cd_pedido_venda,
      'S',
      null,
      getdate()

  end
  else
    --Atualiza o Flag do Status
    update
      pedido_venda_status
    set
      ic_status_pedido = 'S'
    where
      cd_pedido_venda = @cd_pedido_venda
            

end

--select * from pedido_venda_status

