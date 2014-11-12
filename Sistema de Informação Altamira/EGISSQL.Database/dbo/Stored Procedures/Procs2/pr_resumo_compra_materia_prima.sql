
--------------------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Francisco Leite Neto
--Banco de Dados   : EGISSQL
--Objetivo         : Trazer  o Resumo dos dados da Materia Prima
--                 : Filtrada por data
--                   orçamentos : Bases, Moldes e Placas
--Data             : 28/01/2004
--Atualizados      :
--------------------------------------------------------------



CREATE PROCEDURE pr_resumo_compra_materia_prima
@nm_fantasia_mat_prima varchar(30),
@dt_inicial         datetime,
@dt_final           datetime
as

select
    mp.nm_fantasia_mat_prima                as 'NomeMateriaPrima',
    mp.vl_materia_prima                    as 'Precokg',
    sum(pci.qt_item_pesbr_ped_compra)      as 'QtdeKg', 
    sum(pci.vl_total_item_pedido_comp)     as 'valorcomprado',
    sum(nei.vl_total_nota_entr_item)       as 'ValorRecebido'
from 
  Materia_Prima mp Left outer join
  Pedido_Compra_Item pci on pci.cd_materia_prima = mp.cd_mat_prima Left outer join
  Nota_Entrada_Item nei on  nei.cd_produto = pci.cd_produto and
                            nei.cd_pedido_compra = pci.cd_pedido_compra and
                            nei.cd_item_pedido_compra = pci.cd_item_pedido_compra and
                            nei.cd_unidade_medida = mp.cd_unidade_medida 
where
    mp.nm_fantasia_mat_prima like '%'+ @nm_fantasia_mat_prima + '%' and
    pci.dt_item_pedido_compra between @dt_inicial and @dt_final
group by
  mp.nm_fantasia_mat_prima, mp.vl_materia_prima
order by
    mp.nm_fantasia_mat_prima
