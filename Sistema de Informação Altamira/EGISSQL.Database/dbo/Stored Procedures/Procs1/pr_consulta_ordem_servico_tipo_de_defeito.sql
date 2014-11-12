
-------------------------------------------------------------------------------
--pr_consulta_ordem_servico_tipo_de_defeito
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consultar OS por defeito
--Data             : 06/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_ordem_servico_tipo_de_defeito

@cd_tipo_defeito_cliente integer,
@dt_inicial              datetime,
@dt_final                datetime

AS

select 
      os.cd_tipo_defeito_cliente,
      os.vl_total_ordem_servico,
      osi.nm_servico_produto_item,
      osi.cd_ordem_servico,
      osi.cd_item_ordem_servico, 
      td.nm_tipo_defeito,
      t.nm_tecnico,
      c.nm_fantasia_cliente,
      os.*

From   Ordem_Servico os
         left outer join Cliente c 
       on c.cd_cliente = os.cd_cliente
         left outer join Tecnico t
       on t.cd_tecnico = os.cd_tecnico  
         left outer join Tipo_Defeito td
       on td.cd_tipo_defeito = os.cd_tipo_defeito_cliente 
	 left outer join Ordem_Servico_Item osi
       on osi.cd_ordem_servico = os.cd_ordem_servico

Where 
      os.dt_ordem_servico between @dt_inicial and @dt_final and      
      IsNull(os.cd_tipo_defeito_cliente,0) = 
      case 
       When isnull(@cd_tipo_defeito_cliente,0) = 0 then 
         IsNull(os.cd_tipo_defeito_cliente,0) 
       else 
         @cd_tipo_defeito_cliente 
      end

