
-------------------------------------------------------------------------------
--sp_helptext pr_cliente_autorizado_nota
-------------------------------------------------------------------------------
--pr_cliente_autorizado_nota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Clientes Autorizados para Impressão de Notas Fiscais
--Data             : 30.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_cliente_autorizado_nota
@cd_cliente int = 0,
@nm_retorno varchar(100) output
as

  declare @cd_item_cliente int
  declare @nm_autorizado   varchar(100)

  set @cd_item_cliente = 0
  set @nm_autorizado   = ''


  select
     cd_item_cliente, 	
     cd_cpf_cliente
  into
     #cr
  from
    cliente_representante cr
  where
    cr.cd_cliente = @cd_cliente


  while exists( select top 1 cd_item_cliente from #cr )
  begin
    select top 1
      @cd_item_cliente = isnull(cd_item_cliente,0 ),
      @nm_autorizado   = @nm_autorizado + isnull(cd_cpf_cliente,'') + ' '
    from
      #cr

    delete from #cr where cd_item_cliente = @cd_item_cliente

  end


  set @nm_retorno = @nm_autorizado 


