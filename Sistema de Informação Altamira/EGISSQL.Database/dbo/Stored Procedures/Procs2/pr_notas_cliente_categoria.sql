

--pr_notas_cliente_categoria
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei  / Carlos Cardoso Fernandes       
--Consulta de Notas Fiscais por Cliente e Categoria
--Data         : 04.08.2000
--Atualizado   : 01.08.2002 - Migração para o bco. EgisSql (Duela)
--------------------------------------------------------------------------------------

create procedure pr_notas_cliente_categoria
@nm_fantasia_cliente varchar(15),
@cd_mapa varchar(10),
@dt_inicial datetime,
@dt_final datetime
as

select ns.cd_nota_saida, 
       ns.dt_nota_saida,
       nsi.cd_item_nota_saida, 
       nsi.qt_item_nota_saida,
       nsi.nm_produto_item_nota,
       (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) as 'total',
       nsi.cd_pedido_venda,
       nsi.cd_item_pedido_venda
from
  Nota_Saida ns, 
  Nota_Saida_Item nsi, 
  Pedido_Venda pv, 
  Pedido_Venda_Item pvi, 
  Operacao_Fiscal op 
where
  (ns.dt_nota_saida between @dt_inicial and @dt_final)  and
   ns.nm_fantasia_destinatario = @nm_fantasia_cliente    and
   ns.cd_operacao_fiscal      = op.cd_operacao_fiscal   and
   op.ic_comercial_operacao = 'S'                       and
   ns.cd_nota_saida=nsi.cd_nota_saida                   and
   isnull(nsi.ic_status_item_nota_saida,'')<>'C'          and
   (nsi.dt_cancel_item_nota_saida is null or nsi.dt_cancel_item_nota_saida>@dt_final) and
   (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)>0 and
    nsi.cd_pedido_venda=pvi.cd_pedido_venda             and
    pv.cd_pedido_venda=pvi.cd_pedido_venda              and
    nsi.cd_item_pedido_venda=pvi.cd_item_pedido_venda   and
    pvi.ic_smo_item_pedido_venda='N'

order by total desc



