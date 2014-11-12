
CREATE  PROCEDURE pr_consulta_proposta_cliente
-------------------------------------------------------------------------------
--pr_consulta_proposta_cliente
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                     2004
-------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Carlos Cardoso Fernandes
--                         Fabio Cesar Magalhães
--Banco de Dados         : EGISSQL
--Objetivo               : Consultar de Propostas Comerciais em Aberto por Cliente
--Data                   : 19.01.2004
--Atualização            : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                         25.05.2005 - Verificação do Período
--                         03.05.2006 - Acertos Diversos - Complemento
--
--------------------------------------------------------------------------------
@cd_cliente    int = 0,
@dt_inicial    datetime,
@dt_final      datetime

AS
Begin

  Select
	  cast(ci.cd_consulta as varchar) + '.' + cast(ci.cd_item_consulta as varchar) as cd_ident,
	  IsNull(c.ic_fatsmo_consulta,'N') as ic_smo,
		ci.cd_consulta,
    ci.cd_item_consulta,	  
		c.dt_consulta,
		case ic_consulta_item 
     when 'P' then
       ci.nm_fantasia_produto
     else
       (Select top 1 nm_servico from Servico where cd_servico = ci.cd_servico)
    end as nm_fantasia_item,
	  ci.nm_produto_consulta,
    ci.qt_item_consulta,
    ci.vl_unitario_item_consulta,
		ci.vl_lista_item_consulta,
		ci.pc_desconto_item_consulta,
		ci.qt_dia_entrega_consulta,
		ci.dt_entrega_consulta,
		ci.cd_os_consulta,
		ci.cd_posicao_consulta,
		ve.nm_vendedor as nm_vendedor_ext,
		vi.nm_vendedor as nm_vendedor_int,
    (select top 1 nm_contato_cliente from cliente_contato 
		 where cd_cliente = c.cd_cliente and cd_contato = c.cd_contato) as nm_contato_cliente,

   ci.cd_pedido_venda,
   ci.cd_item_pedido_venda,
   pvi.dt_item_pedido_venda,
   ci.dt_perda_consulta_itens,
   ci.cd_motivo_perda,
   mp.nm_motivo_perda,
   cp.nm_categoria_produto

--select * from consulta_itens

from
  Consulta c inner join 
  Consulta_Itens ci on c.cd_consulta = ci.cd_consulta 
                       --and
                       --ci.cd_pedido_venda is null and ci.cd_motivo_perda is null               
  left outer join Vendedor ve           on  c.cd_vendedor           = ve.cd_vendedor 
  left outer join Vendedor vi           on  c.cd_vendedor_interno   = vi.cd_vendedor
  left outer join Motivo_Perda mp       on mp.cd_motivo_perda       = ci.cd_motivo_perda
  left outer join Categoria_Produto cp  on cp.cd_categoria_produto  = ci.cd_categoria_produto
  left outer join Pedido_Venda_Item pvi on pvi.cd_pedido_venda      = ci.cd_pedido_venda and
                                           pvi.cd_item_pedido_venda = ci.cd_item_pedido_venda
where
    c.cd_cliente = @cd_cliente and
    c.dt_consulta between @dt_inicial and @dt_final 
    
    --Carlos 03.05.2006  
    --and isnull(cd_pedido_venda,0)=0                     
    --and --Somente propostas em Aberto
    --ci.dt_perda_consulta_itens is null

order by
    c.dt_consulta desc
end
