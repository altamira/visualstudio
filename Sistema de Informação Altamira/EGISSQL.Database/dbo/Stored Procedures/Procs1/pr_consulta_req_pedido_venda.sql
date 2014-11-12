
--------------------------------------------------------------------------------
CREATE PROCEDURE pr_consulta_req_pedido_venda
-------------------------------------------------------------------------------- 
--GBS - Global Business Solution                2003 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)      : Daniel C. Neto 
--Banco de Dados : EGISSQL 
--Objetivo       : Consultar Requisições por Pedido de Venda.
--Data           : 12/08/2003
--Atualização    : 21/01/2004 - Inserção dos campos referentes a Medida Bruta e Medida Acabada - DANIEL DUELA
--               : 27.08.2005 - Dados da Nota Fiscal de Entrada - Carlos Fernandes
----------------------------------------------------------------------------------- 

@ic_parametro        int,  
@cd_filtro           int 

as 

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta de Requisições de Compra por Pedido de Venda
-------------------------------------------------------------------------------

begin

select distinct
  rc.cd_requisicao_compra, 
  rc.dt_emissao_req_compra, 
  rc.dt_necessidade_req_compra, 
  um.cd_unidade_medida,
  um.sg_unidade_medida,
  pci.qt_item_pesliq_ped_compra,
  tr.nm_tipo_requisicao, 
  mr.nm_motivo_requisicao, 
  dp.nm_destinacao_produto, 
  ap.nm_aplicacao_produto, 
  d.nm_departamento, 
  us.nm_fantasia_usuario,
  cc.nm_centro_custo,
  cli.nm_fantasia_cliente,
  v.nm_fantasia_vendedor,
  pv.dt_pedido_venda
from
  Requisicao_Compra_Item rci 
inner join Requisicao_Compra rc on
  rci.cd_requisicao_compra = rc.cd_requisicao_compra 
left outer join Tipo_Requisicao tr on
  rc.cd_tipo_requisicao = tr.cd_tipo_requisicao 
left outer join Motivo_Requisicao mr on
  rc.cd_motivo_requisicao = mr.cd_motivo_requisicao 
left outer join Destinacao_Produto dp on
  rc.cd_destinacao_produto = dp.cd_destinacao_produto 
left outer join Aplicacao_Produto ap on
  rc.cd_aplicacao_produto = ap.cd_aplicacao_produto 
left outer join Departamento d on
  rc.cd_departamento = d.cd_departamento 
left outer join EGISADMIN.dbo.Usuario us on
  rci.cd_usuario = us.cd_usuario 
left outer join Centro_Custo cc on 
  cc.cd_centro_custo = rc.cd_centro_custo 
left outer join Pedido_Venda pv on 
  pv.cd_pedido_venda = rci.cd_pedido_venda 
left outer join Cliente cli on 
  cli.cd_cliente = pv.cd_cliente 
left outer join Vendedor v on 
  v.cd_vendedor = pv.cd_vendedor 
left outer join Pedido_compra_item pci on 
  pci.cd_requisicao_compra = rci.cd_requisicao_compra 
left outer join Unidade_Medida um on 
  um.cd_unidade_medida = rci.cd_unidade_medida 
where
  rci.cd_pedido_venda = @cd_filtro
order by
  rc.cd_requisicao_compra desc
end

---------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Filtro por Requisição
---------------------------------------------------------------------------------
begin

select
  rci.cd_item_requisicao_compra, 
  rci.nm_prod_requisicao_compra, 
  dbo.fn_mascara_produto(rci.cd_produto) as cd_mascara_produto, 
  rci.qt_item_requisicao_compra, 
  um.sg_unidade_medida, 
  rci.dt_item_nec_req_compra, 
  rci.qt_liquido_req_compra, 
  rci.qt_bruto_req_compra,
  rci.ds_item_requisicao_compra,
  (select top 1 x.cd_pedido_compra 
   from Pedido_Compra_Item x
   where 
     x.cd_requisicao_compra = rci.cd_requisicao_compra and
     x.cd_requisicao_compra_item = rci.cd_item_requisicao_compra ) as 'cd_pedido_compra',
  (select top 1 x.cd_item_pedido_compra
   from Pedido_Compra_Item x
   where
     x.cd_requisicao_compra = rci.cd_requisicao_compra and
     x.cd_requisicao_compra_item = rci.cd_item_requisicao_compra ) as 'cd_item_pedido_compra',
  (select top 1 x.qt_item_pesliq_ped_compra
   from Pedido_Compra_Item x
   where
     x.cd_requisicao_compra = rci.cd_requisicao_compra and
     x.cd_requisicao_compra_item = rci.cd_item_requisicao_compra ) as 'qt_item_pesliq_ped_compra',     
  (select top 1 x.vl_item_unitario_ped_comp
   from Pedido_Compra_Item x
   where 
     x.cd_requisicao_compra = rci.cd_requisicao_compra and
     x.cd_requisicao_compra_item = rci.cd_item_requisicao_compra ) as 'vl_compra',
  cast(0 as float) as 'pc_aliq_icms',
  (select top 1 f.nm_fantasia_fornecedor
   from Fornecedor f 
   inner join Pedido_Compra pc on 
     pc.cd_fornecedor = f.cd_fornecedor 
   inner join Pedido_Compra_Item pci on 
     pci.cd_pedido_compra = pc.cd_pedido_compra 
   where 
     pci.cd_requisicao_compra = rci.cd_requisicao_compra and
     pci.cd_requisicao_compra_item = rci.cd_item_requisicao_compra ) as 'nm_fantasia_fornecedor',
  rci.nm_medacab_mat_prima,
  rci.nm_medbruta_mat_prima,
  (select top 1 ine.cd_nota_entrada
   from Nota_Entrada_Item ine,
        Pedido_Compra_item x
   where 
     x.cd_requisicao_compra = rci.cd_requisicao_compra and
     x.cd_requisicao_compra_item = rci.cd_item_requisicao_compra and 
     x.cd_pedido_compra = ine.cd_pedido_compra and
     x.cd_item_pedido_compra= ine.cd_item_pedido_compra) as 'cd_nota_entrada',

  (select top 1 ine.dt_item_receb_nota_entrad
   from Nota_Entrada_Item ine,
        Pedido_Compra_item x
   where 
     x.cd_requisicao_compra = rci.cd_requisicao_compra and
     x.cd_requisicao_compra_item = rci.cd_item_requisicao_compra and 
     x.cd_pedido_compra = ine.cd_pedido_compra and
     x.cd_item_pedido_compra= ine.cd_item_pedido_compra) as 'dt_nota_entrada'

from
  Requisicao_Compra_Item rci 
left outer join Unidade_Medida um on
  rci.cd_unidade_medida = um.cd_unidade_medida 
where
  rci.cd_requisicao_compra = @cd_filtro
end

