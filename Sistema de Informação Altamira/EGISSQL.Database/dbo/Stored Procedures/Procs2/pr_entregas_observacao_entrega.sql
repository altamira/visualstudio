

/****** Object:  Stored Procedure dbo.pr_entregas_observacao_entrega    Script Date: 13/12/2002 15:08:29 ******/



CREATE  PROCEDURE pr_entregas_observacao_entrega
-------------------------------------------------------
--GBS Global Business Solution Ltda                2002
--Stored Procedure: Microsoft SQL Server           2000
--Autor(es): Luciano
--Objetivo: Listar todas as entregas pela observação
--Data: 08/04/2002
--Atualizado: Igor Gama - 22/07/2002
-------------------------------------------------------
@cd_observacao_entrega int,
@dt_inicial    datetime,
@dt_final      datetime

AS
  select
    o.cd_observacao_entrega,          --Pbservacao
    o.nm_observacao_entrega,          --Pbservacao
    n.dt_entrega_nota_saida,		--Entrega
    n.dt_saida_nota_saida,		--Saida
    n.cd_nota_saida,			--NF
    n.dt_nota_saida,			--Emissao
    c.nm_fantasia_cliente,		--Cliente
    v.nm_fantasia_vendedor,
    v.nm_vendedor,			--Vendedor
    v.sg_vendedor,
    n.vl_frete,
    n.vl_total,			--Valor
    p.cd_pedido_venda,                --Pedido Venda 	
    e.nm_entregador,                  --Entregador
    t.nm_transportadora               --Transportadora
  from
    nota_saida n 
  left outer join
    observacao_entrega o
      on n.cd_observacao_entrega = o.cd_observacao_entrega
  left outer join
    vendedor v
      on n.cd_vendedor = v.cd_vendedor
  left outer join
    entregador e
      on n.cd_entregador = e.cd_entregador
  left outer join
    transportadora t
      on n.cd_transportadora = t.cd_transportadora
  left outer join
    pedido_venda p
      on n.cd_pedido_venda = p.cd_pedido_venda
  left outer join
    Cliente c
      on n.cd_cliente = c.cd_cliente
 where
   n.dt_saida_nota_saida between @dt_inicial and @dt_final and
   n.dt_cancel_nota_saida is null and
   o.cd_observacao_entrega is not null and
--    n.dt_entrega_nota_saida is not null and
   ((o.cd_observacao_entrega = @cd_observacao_entrega) or 
   (@cd_observacao_entrega = 0))
 order by
   o.nm_observacao_entrega asc,  
   n.dt_saida_nota_saida desc,
   n.cd_nota_saida asc
   





