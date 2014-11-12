
CREATE PROCEDURE pr_consulta_compra_cliente
-------------------------------------------------------------------
--pr_consulta_compra_cliente
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	       2004
-------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Daniel Carrasco Neto
--Banco de Dados       : EgisSQL
--Objetivo             : Consulta de Compras por Cliente.
--Data                 : 02/09/2002
--Atualizado           : 27/08/2003 - Incluído campo Máscara - Daniel C Neto
--                     : 16.09.2003 - Adicionado campos referentes a Matéria Prima, caso o produto tiver o mesmo. - Daniel Duela
--                     : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 14.08.2006 - Consulta de Serviços - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------

@nm_fantasia_cliente varchar(15),
@dt_inicial    datetime,
@dt_final      datetime

AS

SELECT DISTINCT
	   c.nm_fantasia_cliente,
           pci.cd_pedido_compra, 
           pci.cd_item_pedido_compra, 
           pci.dt_item_pedido_compra, 
           pci.qt_item_pedido_compra, 
           IsNull(pci.nm_fantasia_produto, nm_item_prodesp_ped_compr) as 'nm_fantasia_produto', 

           cast(case when pci.ic_pedido_compra_item='P'
             then pci.nm_produto
             else case when isnull(pci.cd_servico,0)>0 then s.nm_servico
                                                      else pci.ds_item_pedido_compra end
           end as varchar(260)) as Descricao,

           case when pci.cd_materia_prima is null then null else
             mp.nm_mat_prima end as 'Materia_Prima',

           pci.nm_medbruta_mat_prima,
           pci.nm_medacab_mat_prima,
           pci.vl_item_unitario_ped_comp, 
           pvi.cd_pedido_venda, 
           pvi.cd_item_pedido_venda, 
           pvi.dt_item_pedido_venda,
           pp.cd_processo,
           dbo.fn_mascara_produto(pci.cd_produto) as 'cd_mascara_produto'

FROM       Pedido_Compra_Item pci 
           INNER JOIN Pedido_Venda pv ON 
             pv.cd_pedido_venda = pci.cd_pedido_venda 
           INNER JOIN Pedido_Venda_Item pvi ON 
             pvi.cd_pedido_venda = pv.cd_pedido_venda 
           INNER JOIN Cliente c on 
             c.cd_cliente = pv.cd_cliente 
           LEFT OUTER JOIN Processo_Producao pp ON 
             pvi.cd_pedido_venda = pp.cd_pedido_venda
           left outer join Materia_Prima mp     on mp.cd_mat_prima=pci.cd_materia_prima
           left outer join Servico s            on s.cd_servico   =pci.cd_servico

where     (c.nm_fantasia_cliente like @nm_fantasia_cliente + '%') and
          pci.dt_item_pedido_compra between @dt_inicial and @dt_final and 
          pvi.dt_cancelamento_item is null

order by  c.nm_fantasia_cliente,
          pp.cd_processo
