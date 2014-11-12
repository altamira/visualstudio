
-------------------------------------------------------------------------------
--pr_nota_saida_itinerario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consultar Notas por Itinerário
--Data             : 14/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_nota_saida_itinerario
@cd_itinerario int,
@ic_param int

as

if @ic_param = 1 --lista analitica
  begin

    select 
	    ns.vl_total,
 	    ns.cd_nota_saida,
	    ns.dt_entrega_nota_saida,
 	    ns.dt_saida_nota_saida,
	    ns.dt_nota_saida,
	    ns.ds_obs_compl_nota_saida, 
 	    ns.qt_ord_entrega_nota_saida,
	    ns.vl_frete, 
	    i.nm_itinerario,
	    i.cd_itinerario,
	    v.nm_vendedor,
	    c.nm_fantasia_cliente,
	    pv.cd_pedido_venda,
	    trp.nm_fantasia
	  
	
    from nota_saida ns left outer join
	  itinerario i on  i.cd_itinerario = ns.cd_itinerario left outer join
	  cliente c on c.cd_cliente = ns.cd_cliente left outer join
	  vendedor v on v.cd_vendedor = c.cd_vendedor left outer join
	  pedido_venda pv on pv.cd_pedido_venda = ns.cd_pedido_venda left outer join
	  transportadora trp on trp.cd_transportadora = ns.cd_transportadora

    where
          IsNull(i.cd_itinerario,0) = 
          case 
             When isnull(@cd_itinerario,0) = 0 then 
                IsNull(i.cd_itinerario,0) 
             else 
               @cd_itinerario
             end
    order by i.cd_itinerario
	
  end

else if @ic_param = 2  -- listagem do resumo
  begin	
	--Cálculo Percentual
	declare @vl_total_resumo decimal(25,2)
	select 
     		@vl_total_resumo = isnull(sum(vl_total),1)
        from
      		nota_saida	    

	    select 
		ns.vl_total,
		ns.vl_frete,
		i.nm_itinerario,
		i.cd_itinerario,
		cast(((isnull(vl_total,1)/@vl_total_resumo) * 100) as decimal(25,2)) as Percentual,
		count(ns.cd_nota_saida) as Qtde
		
	from nota_saida ns left outer join
	     itinerario i on  i.cd_itinerario = ns.cd_itinerario

	where
          IsNull(i.cd_itinerario,0) = 
          case 
             When isnull(@cd_itinerario,0) = 0 then 
                IsNull(i.cd_itinerario,0) 
             else 
               @cd_itinerario
             end
       group by 
           ns.vl_total, ns.vl_frete, i.nm_itinerario, i.cd_itinerario

        order by i.cd_itinerario

end 
