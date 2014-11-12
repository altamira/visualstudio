
CREATE PROCEDURE pr_consulta_pedido_compra_maquina

------------------------------------------------------------------------------------------------------
--pr_consulta_pedido_compra_maquina
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Pedido de Compra por Máquina.
--Data          : 22/08/2002
--Atualizado    : 04/10/2002
--                27/08/2003 - Incluído Máscara do Produto - Daniel C. Neto.
--                16.09.2003 - Adicionado campos referentes a Matéria Prima, caso o produto tiver o mesmo. - Daniel Duela
--                14.08.2006 - Acerto da consulta de serviço - Carlos Fernandes
--                20.08.2006 - Ajustes - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@cd_maquina       int,
@dt_inicial       datetime,
@dt_final         datetime,
@cd_pedido_compra int

AS

    select
      f.nm_fantasia_fornecedor,
      m.nm_fantasia_maquina,
      um.cd_unidade_medida,
      um.sg_unidade_medida,
      pci.dt_item_pedido_compra,
      pci.vl_total_item_pedido_comp,
      pci.cd_pedido_compra,
      pci.cd_item_pedido_compra,
      pci.dt_item_canc_ped_Compra,
      pci.nm_item_motcanc_ped_compr,
      case when isnull(pci.cd_produto,0)>0 
           then IsNull(p.nm_fantasia_produto, pci.nm_item_prodesp_ped_compr)
           else case when isnull(pci.cd_servico,0)>0 then s.nm_servico else pci.nm_item_prodesp_ped_compr end
           end     as 'Produto',

--      IsNull(pci.ds_item_pedido_compra, pci.ds_item_prodesp_ped_compr) as 'Descricao',

      cast(case when pci.ic_pedido_compra_item='P'
           then pci.nm_produto
           else case when isnull(pci.cd_servico,0)>0 then s.nm_servico
                                                     else cast(isnull(pci.ds_item_pedido_compra,pci.ds_item_prodesp_ped_compr) as varchar) end
      end as varchar(260)) as Descricao,

      case when pci.cd_materia_prima is null then null else
        mp.nm_mat_prima end as 'Materia_Prima',
      pci.nm_medbruta_mat_prima,
      pci.nm_medacab_mat_prima,
      pci.qt_item_pedido_compra,
      pci.qt_item_pesliq_ped_compra,
      pci.qt_item_pesbr_ped_compra,
      pci.vl_item_unitario_ped_comp,
      pci.vl_custo_item_ped_compra,
      pci.dt_item_nec_ped_compra,
      nei.cd_nota_entrada,
      nei.cd_item_nota_entrada,
      nei.qt_item_nota_entrada,
      nei.dt_nota_entrada,
      pci.qt_saldo_item_ped_compra,
      rii.qt_item_requisicao_compra,
      pci.cd_pedido_venda,
      cc.nm_centro_custo,
      dbo.fn_mascara_produto(pci.cd_produto) as 'cd_mascara_produto'
    from Pedido_Compra_Item pci 
      left outer join Pedido_Compra pc 
      on pc.cd_pedido_compra = pci.cd_pedido_compra 
      left outer join Fornecedor f     
      on f.cd_fornecedor = pc.cd_fornecedor         
      left outer join Maquina m        
      on m.cd_maquina = pci.cd_maquina            
      left outer join Produto p        
      on p.cd_produto = pci.cd_produto              
      left outer join Requisicao_Compra_Item rii
      on (rii.cd_requisicao_compra = pci.cd_requisicao_compra) and
         (rii.cd_item_requisicao_compra = pci.cd_requisicao_compra_item)
      left outer join Nota_Saida_Entrada_Item nei 
      on (nei.cd_pedido_compra = pci.cd_pedido_compra) and 
         (nei.cd_item_pedido_compra = pci.cd_item_pedido_compra)
      left outer join Centro_Custo cc on
        cc.cd_centro_custo=pci.cd_centro_custo
      left outer join Materia_Prima mp on
        mp.cd_mat_prima=pci.cd_materia_prima 
      left outer join unidade_medida um on um.cd_unidade_medida = pci.cd_unidade_medida
      left outer join servico s         on s.cd_servico         = pci.cd_servico
  where 
    ( (pci.cd_maquina = @cd_maquina) or 
      (@cd_maquina = 0) ) and
    (pci.dt_item_pedido_compra between @dt_inicial and @dt_final) and
    ( (pci.cd_maquina is not null) and 
      (pci.cd_maquina <> 0) )and
    ( (pci.cd_pedido_compra = @cd_pedido_compra) or
      (@cd_pedido_compra = 0) )

  order by    
    m.nm_fantasia_maquina,
    pci.cd_pedido_compra,
    pci.dt_item_pedido_compra desc,
    pci.cd_item_pedido_compra    
      
