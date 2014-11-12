
CREATE PROCEDURE pr_consulta_pedido_compra_categoria_aberto

--------------------------------------------------------------------------------------------------------
--pr_consulta_pedido_compra_categoria_aberto
--------------------------------------------------------------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Mostrar os pedidos de compra em aberto por Categoria
--Data: 31/05/2002
--Atualizado: Alterado para filtra por Plano de Compra - 06/08/2002
--            Daniel C. Neto.
--            29/01/2003 - Ajustado Filtro, trazer todos - Daniel C. Neto.
-- 28/08/2003 - Incluído Máscara do Produto - Daniel C. Neto.
-- 14/10/2003 - Acerto no Filtro. - Daniel C. Neto.
-- 16/10/2003 - Incluído Nota de Entrada, Item, Data e quantidade recebida.
-- 14.08.2006 - Serviço na grid - Carlos Fernandes
-- 20.08.2006 - Ajustes do serviço - Carlos Fernandes
-- 14.02.2007 - Adicionando Plano de Compras - Anderson
--------------------------------------------------------------------------------------------------------
@dt_base      datetime,
@cd_categoria int = 0
AS

--------------------------------------------------------
if @cd_categoria = 0  -- Todas as categorias
--------------------------------------------------------

begin

  select 
    f.nm_fantasia_fornecedor,
    f.nm_razao_social,
    p.dt_pedido_compra,
    p.cd_pedido_compra,
    um.sg_unidade_medida,
    i.cd_item_pedido_compra,
    i.qt_item_pedido_compra,
    i.qt_item_pesliq_ped_compra,
    i.qt_item_pesbr_ped_compra,
    i.qt_saldo_item_ped_compra,
    i.vl_item_unitario_ped_comp,
    i.nm_medbruta_mat_prima,
    i.nm_medacab_mat_prima,
    p.vl_total_pedido_compra,
    isnull(isnull(i.cd_produto, i.cd_servico),0)		as cd_produto,
    isnull(pd.cd_mascara_produto, s.cd_mascara_servico)		as cd_mascara_produto,
    isnull(pd.nm_fantasia_produto, s.nm_servico)		as nm_fantasia_produto,	
    --cast(isnull(pd.ds_produto, s.ds_servico)as varchar(2000))	as ds_produto,
    cast(case when i.ic_pedido_compra_item='P'
              then i.nm_produto
              else case when isnull(i.cd_servico,0)>0 then s.nm_servico
                                                      else i.ds_item_pedido_compra end
    end as varchar(2000)) as ds_produto,
    ni.cd_nota_entrada,
    ni.cd_item_nota_entrada,
    ne.dt_receb_nota_entrada,
    ni.qt_item_nota_entrada,
    pc.nm_plano_compra
   
    --select * from pedido_compra_item

  From        
    Pedido_Compra p 
    left outer join Fornecedor f          on p.cd_fornecedor          = f.cd_fornecedor 
    left outer join Pedido_Compra_Item i  on p.cd_pedido_compra       = i.cd_pedido_compra 
    left outer join Status_Pedido sp      on p.cd_status_pedido       =  sp.cd_status_pedido 
    Left Outer Join Produto pd            on pd.cd_produto            = i.cd_produto 
    left outer join Servico s             on s.cd_servico             = i.cd_servico 
    left outer join unidade_medida um     on um.cd_unidade_medida     =  i.cd_unidade_medida 
    left outer join Nota_Entrada_Item ni  on ni.cd_pedido_compra      = p.cd_pedido_compra and
                                             ni.cd_item_Pedido_compra = i.cd_item_pedido_compra and
                                             ni.cd_fornecedor         = p.cd_fornecedor
    left outer join Nota_entrada ne       on ne.cd_nota_entrada       = ni.cd_nota_entrada and
                                             ne.cd_fornecedor         = ne.cd_fornecedor 
    left outer join Plano_Compra pc       on p.cd_plano_compra        = pc.cd_plano_compra
		 
  where
      IsNull(p.cd_status_pedido,0) <> 14 and
      p.dt_pedido_compra >= @dt_base

end else 
begin

  select 
    f.nm_fantasia_fornecedor,
    f.nm_razao_social,
    p.dt_pedido_compra,
    p.cd_pedido_compra,
    um.sg_unidade_medida,
    i.cd_item_pedido_compra,
    i.qt_item_pedido_compra,
    i.qt_item_pesliq_ped_compra,
    i.qt_item_pesbr_ped_compra,
    i.qt_saldo_item_ped_compra,
    i.vl_item_unitario_ped_comp,
    i.nm_medbruta_mat_prima,
    i.nm_medacab_mat_prima,
    p.vl_total_pedido_compra,
    isnull(pd.cd_produto, s.cd_servico)				as cd_produto,
    isnull(pd.cd_mascara_produto, s.cd_mascara_servico)		as cd_mascara_produto,
    isnull(pd.nm_fantasia_produto, s.nm_servico)		as nm_fantasia_produto,	
--    cast(isnull(pd.ds_produto, s.ds_servico)as varchar(2000))	as ds_produto,
    cast(case when i.ic_pedido_compra_item='P'
              then i.nm_produto
              else case when isnull(i.cd_servico,0)>0 then s.nm_servico
                                                      else i.ds_item_pedido_compra end
    end as varchar(2000)) as ds_produto,

    ni.cd_nota_entrada,
    ni.cd_item_nota_entrada,
    ne.dt_receb_nota_entrada,
    ni.qt_item_nota_entrada,
    pc.nm_plano_compra
  From        
    Pedido_Compra p 
    left outer join Fornecedor f         on p.cd_fornecedor = f.cd_fornecedor 
    left outer join Pedido_Compra_Item i on p.cd_pedido_compra = i.cd_pedido_compra 
    left outer join Status_Pedido sp     on p.cd_status_pedido =  sp.cd_status_pedido 
    Left Outer Join Produto pd           on pd.cd_produto = i.cd_produto 
    left outer join Servico s            on s.cd_servico = i.cd_servico 
    left outer join unidade_medida um    on um.cd_unidade_medida =  i.cd_unidade_medida 
    left outer join Nota_Entrada_Item ni on ni.cd_pedido_compra = p.cd_pedido_compra and
			                    ni.cd_item_Pedido_compra = i.cd_item_pedido_compra and
			                    ni.cd_fornecedor = p.cd_fornecedor 
    left outer join Nota_entrada ne      on ne.cd_nota_entrada = ni.cd_nota_entrada and
		                            ne.cd_fornecedor   = ne.cd_fornecedor 
    left outer join Plano_Compra pc      on p.cd_plano_compra  = pc.cd_plano_compra

  where
      p.cd_plano_compra            = @cd_categoria and
      IsNull(p.cd_status_pedido,0) <> 14 and
      p.dt_pedido_compra           >= @dt_base

end

  
