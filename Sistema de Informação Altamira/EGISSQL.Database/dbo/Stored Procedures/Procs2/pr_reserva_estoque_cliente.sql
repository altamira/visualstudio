


CREATE    PROCEDURE pr_reserva_estoque_cliente
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : moris Korich
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Reserva no Estoque por Cliente
--Data          : 07/12/2004
--Atualizado    : 08/12/2004
---------------------------------------------------
@nm_fantasia_cliente        varchar(40), 
@dt_inicial                    datetime, 
@dt_final                      datetime

AS

begin 

  select 
    me.dt_movimento_estoque as 'Data',
    
    Case 
      When IsNull(gp.cd_mascara_grupo_produto, '') = ''
      then IsNull(p.cd_mascara_produto, '')
      Else dbo.fn_formata_mascara(IsNull(gp.cd_mascara_grupo_produto, ''), IsNull(p.cd_mascara_produto, ''))
    End as 'Código',

    pvi.nm_fantasia_produto as 'Fantasia',
    pvi.nm_produto_pedido as 'Descrição',
    un.sg_unidade_medida 'UN',
    pvi.qt_item_pedido_venda as 'Quantidade',
    pv.cd_pedido_venda as 'Pedido',
    pv.dt_pedido_venda as 'Emissão',
    pvi.cd_item_pedido_venda as 'Item',
    pvi.qt_saldo_pedido_venda as 'Saldo',
    (pvi.qt_saldo_pedido_venda*pvi.vl_unitario_item_pedido) as 'Valor'
  from 
    pedido_venda pv
  inner join 
    cliente clie on clie.cd_cliente=pv.cd_cliente
  inner join 
    pedido_venda_item pvi on pvi.cd_pedido_venda=pv.cd_pedido_venda
  inner join 
    movimento_estoque me on me.cd_documento_movimento=pvi.cd_pedido_venda
    and me.cd_item_documento=pvi.cd_item_pedido_venda
    and me.cd_produto=pvi.cd_produto
  inner join 
    produto p on p.cd_produto=me.cd_produto
  inner join 
    grupo_produto gp on gp.cd_grupo_produto=p.cd_grupo_produto  
  inner join 
    unidade_medida un on un.cd_unidade_medida=pvi.cd_unidade_medida
  where 
    pv.cd_status_pedido<>7 
    and me.cd_tipo_documento_estoque=7
    and pvi.ic_reserva_item_pedido='S'
    and me.cd_tipo_movimento_estoque='2'
    and pvi.qt_saldo_pedido_venda>0 
    and me.dt_movimento_estoque between @dt_inicial and @dt_final
    and clie.nm_fantasia_cliente=@nm_fantasia_cliente
  order by 
    me.dt_movimento_estoque,
    pv.cd_pedido_venda,
    pvi.cd_item_pedido_venda


end



