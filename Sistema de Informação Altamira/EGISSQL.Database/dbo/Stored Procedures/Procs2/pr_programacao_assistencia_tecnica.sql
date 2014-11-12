
-------------------------------------------------------------------------------
--pr_programacao_assistencia_tecnica
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consultar a programação de assistência técnica por ordem de serviço
--Data             : 18/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_programacao_assistencia_tecnica
@cd_os int,
@cd_painel int

as

if @cd_painel = 0
begin

	 select os.cd_ordem_servico,
		os.dt_ordem_servico,
		os.vl_total_ordem_servico,
		os.ic_fat_ordem_servico,
		cast(case when isnull((cast( GetDate() - os.dt_entrega_ordem_servico as int )),0) > 0 
		then 'S'
		else 'N'
		end as char) as 'Atraso',
		c.nm_fantasia_cliente,
		t.nm_tecnico,
		cp.nm_condicao_pagamento,
		ta.nm_tipo_atendimento,
		tp.nm_tipo_prioridade,
		tna.nm_tipo_nivel_atendimento,
		pv.ic_pedido_venda,
		sos.cd_status_ordem_servico

 	from ordem_servico os 
	left outer join cliente c 	           	on c.cd_cliente = os.cd_cliente 
	left outer join tecnico t 	           	on t.cd_tecnico = os.cd_tecnico 
	left outer join condicao_pagamento cp      	on cp.cd_condicao_pagamento  = os.cd_condicao_pagamento 
	left outer join tipo_atendimento ta        	on ta.cd_tipo_atendimento = os.cd_tipo_atendimento 
	left outer join tipo_prioridade tp         	on tp.cd_tipo_prioridade = os.cd_tipo_prioridade 
	left outer join tipo_nivel_atendimento tna 	on tna.cd_tipo_nivel_atendimento = os.cd_tipo_nivel_atendimento 
	left outer join status_ordem_servico sos   	on sos.cd_status_ordem_servico = os.cd_status_ordem_servico
	left outer join ordem_servico_componente osc 	on osc.cd_ordem_servico = os.cd_ordem_servico
	left outer join pedido_venda pv			on pv.cd_pedido_venda = osc.cd_pedido_venda
	
	 where
        	  IsNull(os.cd_ordem_servico,0) = 
	          case 
        	     When isnull(@cd_os,0) = 0 then 
                	IsNull(os.cd_ordem_servico,0) 
	             else 
        	       @cd_os
	             end
		  and os.cd_ordem_servico > 0

	    order by os.cd_ordem_servico

end
else begin

	 select os.cd_ordem_servico,
		os.vl_total_ordem_servico,
		osi.cd_item_ordem_servico,
		osi.qt_item_ordem_servico,
		osi.vl_item_ordem_servico,
		osi.nm_servico_produto_item
		
	
 	from ordem_servico os left outer join
		ordem_servico_item osi on osi.cd_ordem_servico = os.cd_ordem_servico
	
	where
        	  IsNull(os.cd_ordem_servico,0) = 
	          case 
        	     When isnull(@cd_os,0) = 0 then 
                	IsNull(os.cd_ordem_servico,0) 
	             else 
        	       @cd_os
	             end
		  and os.cd_ordem_servico > 0

	    order by os.cd_ordem_servico asc

end


