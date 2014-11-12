Create procedure pr_ranking_produto_comprado
-----------------------------------------------------------------------------------  
--GBS - Global Business Sollution S/A                                          2003  
-----------------------------------------------------------------------------------  
--Stored Procedure : SQL Server Microsoft 2000    
-----------------------------------------------------------------------------------  
--Autor      : Douglas de Paula Lopes
--Objetivo   : Ranking de Compras/Produto  
--Data       : 15.09.2008
--Alteração  : 
-----------------------------------------------------------------------------------  
@dt_inicial      datetime = '',  
@dt_final        datetime = '',
@cd_moeda        int = 1 
as 

declare @vl_moeda float  
  
set @vl_moeda = (case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 
                   1  
                 else 
                   dbo.fn_vl_moeda(@cd_moeda) 
                 end)   

select distinct
  p.cd_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  sum(pci.qt_item_pedido_compra)                                                       as TotalItensGrupo, 
  sum(p.qt_peso_liquido)                                                               as TotalPesoLiquidoGrupo,
  sum(p.qt_peso_bruto)                                                                 as TotalPesoBrutoGrupo,
  sum(pci.qt_item_pedido_compra * isnull(pci.vl_item_unitario_ped_comp,0)/ @vl_moeda)  as ValorTotalGrupo,
  sum(pci.qt_item_pedido_compra * isnull(pcc.vl_custo_produto,0)/ @vl_moeda)           as TotalCustoProdutoGrupo,
  max(pc.dt_pedido_Compra)                                                             as 'UltimaCompra',
  sum(pci.qt_item_pedido_compra*(pci.vl_item_unitario_ped_comp)/ @vl_moeda)            as 'Compra'  
into 
  #pedido_compra
from
  pedido_compra                                pc  with(nolock)
  inner join pedido_compra_item                pci with(nolock) on pci.cd_pedido_compra = pc.cd_pedido_compra
  inner join produto                           p   with(nolock) on p.cd_produto         = pci.cd_produto
  left outer join unidade_medida               um  with(nolock) on um.cd_unidade_medida = pci.cd_unidade_medida
  left outer join produto_custo                pcc with(nolock) on pcc.cd_produto       = pci.cd_produto
where
  pci.dt_item_canc_ped_compra is null and
  pci.qt_item_pedido_compra * isnull(pci.vl_item_unitario_ped_comp,0) > 0 and
  isnull(pc.vl_total_pedido_compra,0) > 0 and 
  pc.dt_pedido_compra between @dt_inicial and @dt_final
group by
  p.cd_categoria_produto,
  p.cd_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida
order by
  TotalItensGrupo desc

  declare @qt_total_categ int  
  declare @vl_total_categ float  
     
  set @qt_total_categ = @@rowcount       
  set @vl_total_categ     = 0  

select
  @vl_total_categ = @vl_total_categ + Compra  
from  
  #pedido_compra  

select
  pc.*,
  p.cd_mascara_produto
into
  #Pedido_compra2
from
  #pedido_compra pc
  left outer join produto p on p.cd_produto = pc.cd_produto
   
select 
  cd_produto,
  cd_mascara_produto,
  nm_fantasia_produto,
  nm_produto,
  sg_unidade_medida,
  TotalItensGrupo, 
  TotalPesoLiquidoGrupo,
  TotalPesoBrutoGrupo,
  ValorTotalGrupo,
  UltimaCompra,
  TotalCustoProdutoGrupo,
  (pc.Compra/@vl_total_categ)*100 as 'Perc'
into
  #pedido_compra_aux  
from
  #Pedido_compra2 pc
order by
  Perc desc

select * from #pedido_compra_aux

drop table #pedido_compra
drop table #Pedido_compra2
drop table #pedido_compra_aux

