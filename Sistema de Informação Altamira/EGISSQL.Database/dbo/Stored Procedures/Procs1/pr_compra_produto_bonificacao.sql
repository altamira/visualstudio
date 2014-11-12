
-------------------------------------------------------------------------------
--sp_helptext pr_compra_produto_bonificacao
-------------------------------------------------------------------------------
--pr_compra_produto_bonificacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 18.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_compra_produto_bonificacao
@dt_inicial      datetime = '',  
@dt_final        datetime = ''
as

select
  pc.dt_pedido_compra,
  fon.nm_fantasia_fornecedor,
  pci.cd_pedido_compra,
  pci.cd_item_pedido_compra,
  pci.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  pci.qt_item_pedido_compra,
  p.qt_peso_bruto,
  pci.qt_item_pedido_compra * isnull(p.qt_peso_bruto,0) as Peso,
  pci.vl_item_unitario_ped_comp,
  pci.qt_item_pedido_compra * isnull(pci.vl_item_unitario_ped_comp,0) as TotalItem,
  ne.cd_nota_entrada,
  ne.dt_nota_entrada,
  nei.qt_item_nota_entrada as qt_volume_nota_entrada,
  fo.cd_mascara_operacao as CFOP,
  1 as cd_item
into
  #pedido_compra
from
  pedido_compra                      pc  with(nolock)
  inner join pedido_compra_item      pci with(nolock) on  pci.cd_pedido_compra      = pc.cd_pedido_compra
  left  outer join nota_entrada_item nei with(nolock) on (nei.cd_pedido_compra      = pci.cd_pedido_compra and
                                                          nei.cd_item_pedido_compra = pci.cd_item_pedido_compra)
                                                          and isnull(nei.ic_item_bonificacao,'N') = 'S' 

  left  outer join nota_entrada      ne  with(nolock) on (ne.cd_nota_entrada        = nei.cd_nota_entrada and
                                                          ne.cd_operacao_fiscal     = nei.cd_operacao_fiscal and
                                                          ne.cd_fornecedor          = nei.cd_fornecedor)
  left  outer join operacao_fiscal   fo  with(nolock) on  fo.cd_operacao_fiscal     = nei.cd_operacao_fiscal
  left  outer join fornecedor        fon with(nolock) on  fon.cd_fornecedor         = pc.cd_fornecedor
  left  outer join produto           p   with(nolock) on  p.cd_produto              = pci.cd_produto
  left  outer join unidade_medida    um  with(nolock) on  um.cd_unidade_medida      = pci.cd_unidade_medida
where
  pc.dt_pedido_compra between @dt_inicial and @dt_final and
  pci.dt_item_canc_ped_compra is null 

------
select   
  identity(smallint,1,1) as [id],  
  *  
into   
  #pedido_compra2  
from  
  #pedido_compra  
order by  
  cd_pedido_compra
------
declare numerador cursor
  
for 
  select 
    [id], 
    cd_pedido_compra 
  from 
    #pedido_compra2 
  order by 
    cd_pedido_compra

open numerador 
 
declare 
  @id int, 
  @cod int, 
  @cod_ant int, 
  @contador int

set @contador=1

fetch next from numerador into @id, @cod  

while (@@fetch_status<>-1)
  begin  
    set @cod_ant = @cod 
    update #pedido_compra2 set cd_item = @contador where [id]=@id
    fetch next from numerador into @id, @cod  
    if @cod <> @cod_ant   
      set @contador=1  
    else  
      set @contador=@contador+1 
  end  

close numerador
deallocate numerador
------

select 
  dt_pedido_compra,
  nm_fantasia_fornecedor,
  cd_pedido_compra,
  cd_item_pedido_compra,
  cd_mascara_produto,
  nm_fantasia_produto,
  nm_produto,
  sg_unidade_medida,
  qt_item_pedido_compra,
  qt_peso_bruto,
  Peso,
  vl_item_unitario_ped_comp,
  TotalItem,
  cd_nota_entrada,
  dt_nota_entrada,
  qt_volume_nota_entrada,
  CFOP,
  (select count(*) from #pedido_compra2 where cd_item = 1) as TotalPedidosBon,
  (select max(cd_item) from #pedido_compra2 where cd_pedido_compra = pc.cd_pedido_compra) as TotalItensBon,
  cd_item as ItensBon   
from
  #pedido_compra2 pc

drop table #pedido_compra
drop table #pedido_compra2
