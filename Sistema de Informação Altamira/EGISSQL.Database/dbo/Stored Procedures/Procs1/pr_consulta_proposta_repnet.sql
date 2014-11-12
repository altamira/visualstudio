
CREATE PROCEDURE pr_consulta_proposta_repnet
@dt_inicial       datetime,
@dt_final         datetime,
@cd_vendedor	    int = 0,
@cd_consulta_repnet int = 0,
@somente_n_fechadas   varchar(1) = 'N',
@cd_usuario 		int = 0
AS

SELECT
	cast(ci.cd_consulta as varchar) + '.' + cast(ci.cd_item_consulta as varchar) as cd_id,
	v.nm_fantasia_vendedor,
	cl.nm_fantasia_cliente,
	ci.cd_item_consulta,
	ci.nm_fantasia_produto,
	ci.qt_item_consulta,
	ci.cd_pedido_venda,
	ci.cd_item_pedido_venda,
	ci.vl_unitario_item_consulta,
	ci.vl_lista_item_consulta,
	ci.qt_dia_entrega_consulta,
	ci.ic_orcamento_consulta,
	ci.dt_orcamento_liberado_con,	
	c.cd_consulta,
	c.ic_operacao_triangular,
	c.cd_consulta_representante,
	ci.cd_item_consulta_represe,
	c.dt_consulta,
	ci.dt_perda_consulta_itens,
        case 
	  when cr.cd_consulta is null then 0
	  else 1
	end as ic_solicita_fechamento
From
	Consulta c with (nolock)
	inner join Vendedor v with (nolock)
	on 
	--Só filtra proposta de representante e que sejam permitidas
	IsNull(c.cd_consulta_representante,0) > 0 and
	c.cd_vendedor = v.cd_vendedor
	inner join Cliente cl with (nolock)
	on c.cd_cliente = cl.cd_cliente
	inner join Consulta_Itens ci with (nolock)
	on c.cd_consulta = ci.cd_consulta
	left outer join Consulta_Item_repnet cr with (nolock) on
	  ci.cd_consulta = cr.cd_consulta and
          ci.cd_item_consulta = cr.cd_item_consulta
where	
	--Força para que caso a consulta do representante venha a ser informada traga a proposta, independente desta
	--ter sido dado como perdida, caso contrário será apresentada apenas as propostas que não foram perdidas
	( 1 = 
		( case IsNull(@cd_consulta_repnet,0)
		  when 0 then 
			(case when ci.dt_perda_consulta_itens is null then 1 else 0 end )
		  else
			1
		  end )) and
	--Número da consulta do representante
	c.cd_consulta_representante = ( case IsNull(@cd_consulta_repnet,0)
			    		  when 0 then 
					    c.cd_consulta_representante
			    		  else
					    @cd_consulta_repnet
			  		end ) and
	--Código do Vendedor
	IsNull(c.cd_representante,0) = ( case IsNull(@cd_consulta_repnet,0)
					    when 0 then 
						case IsNull(@cd_vendedor,0)
					    	  when 0 then 
						    IsNull(c.cd_representante,0)
					    	  else
						    @cd_vendedor
				  		end
					    else
						IsNull(c.cd_representante,0)
					  end ) and
	--Data da proposta
	c.dt_consulta between ( case IsNull(@cd_consulta_repnet,0)
			    		  when 0 then 
					    @dt_inicial
			    		  else
					    c.dt_consulta
			  		end ) and
				( case IsNull(@cd_consulta_repnet,0)
			    		  when 0 then 
					    @dt_final
			    		  else
					    c.dt_consulta
			  		end ) and
        --Verifica se a proposta está aguardando fechamento
	IsNull(cr.cd_consulta,0) = ( case IsNull(@somente_n_fechadas,'N')
			    		  when 'S' then 
					    cr.cd_consulta --Sem o IsNull Força busca
			    		  else
					    IsNull(cr.cd_consulta,0)
			  		end ) and
	 --Caso tenha sido definido somente não fechadas
         IsNull(ci.cd_pedido_venda,0) = ( case IsNull(@somente_n_fechadas,'N')
			    		  when 'S' then 
					    0 --Sem o IsNull Força busca
			    		  else
					    IsNull(ci.cd_pedido_venda,0)
			  		end ) and
	--Filtra os casos de consultas específicas para usuários de internet
	dbo.fn_vendedor_consulta_internet(@cd_usuario, c.cd_consulta) = 'S'

