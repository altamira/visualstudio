
-------------------------------------------------------------------------------
--pr_consulta_ordem_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Mostar dados da Os
--Data             : 08/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_ordem_servico

@dt_Inicial DateTime,
@dt_Final   DateTime,
@cd_cliente Integer,
@cd_tecnico Integer, 
@cd_status  integer

AS
Select
      osi.vl_total_ordem_serv_item,
      osi.cd_item_ordem_servico,
      osi.qt_item_ordem_servico,
      osi.vl_item_ordem_servico,
      p.nm_fantasia_produto,
      osi.cd_item_ordem_servico,
      os.dt_ordem_Servico,
      t.nm_fantasia_tecnico, 
      c.nm_fantasia_cliente,
      os.*
 
        
From 
      Ordem_Servico os
      left outer join Cliente c
        on c.cd_cliente = os.cd_cliente
      left outer join Tecnico t 
        on t.cd_tecnico = os.cd_tecnico  
      left outer join Ordem_Servico_Item osi
        on osi.cd_ordem_servico = os.cd_ordem_servico
      left outer join Produto p 
        on p.cd_produto = osi.cd_servico_Produto

Where
(      IsNull(os.dt_ordem_servico,0) >=  
      case 
       When isnull(@dt_Inicial,0) = 0 then 
         IsNull(@dt_Inicial,0) 
       else 
         @dt_Inicial 
      end 

      and

      IsNull(os.dt_ordem_servico,0) <= 
      case 
       When isnull(@dt_Final,0) = 0 then 
         IsNull(@dt_Final,0) 
       else 
         @dt_Final 
      end
)
--      and
--       
--       IsNull(os.cd_cliente,0) = 
--       case 
--        When isnull(@cd_Cliente,0) = 0 then 
--          IsNull(@cd_Cliente,0) 
--        else 
--          @cd_Cliente 
--       end 
-- 
--       and
-- 
--       IsNull(os.cd_tecnico,0) = 
--       case 
--        When isnull(@cd_Tecnico,0) = 0 then 
--          IsNull(@cd_Tecnico,0) 
--        else 
--          @cd_Tecnico 
--       end 
-- 
--       and
-- 
--       IsNull(os.cd_status_ordem_servico ,0) = 
--       case 
--        When isnull(@cd_Status,0) = 0 then 
--          IsNull(@cd_Status,0) 
--        else 
--          @cd_Status 
--       end
               

