
-------------------------------------------------------------------------------
--pr_programacao_entrega_compras
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Montar um mapa de entregas de pedidos de compra em aberto.
--Data             : 09/03/2007
--Alteração        : 03.03.2009 - Ajuste e Complemento dos Campos - Carlos Fernandes
------------------------------------------------------------------------------------
create procedure pr_programacao_entrega_compras
  @ic_parametro int = 1,
  @dt_inicial   datetime = '',
  @dt_final     datetime = ''
as

  select
    pc.cd_pedido_compra,
    pc.dt_pedido_compra,
    f.nm_fantasia_fornecedor,
    pci.cd_item_pedido_compra,
    pci.qt_item_pedido_compra,
    pci.qt_saldo_item_ped_compra,
    pci.qt_dia_entrega_item_ped,
    pci.dt_entrega_item_ped_compr,
    pc.dt_nec_pedido_compra,
    pci.vl_item_unitario_ped_comp,
    case when isnull(pci.cd_servico,0)>0 then
      case when cast(pci.ds_item_pedido_compra as varchar(50))=''
           then cast(s.nm_servico as varchar(50))
           else cast(pci.ds_item_pedido_compra as varchar(50))
      end
      else   
           pci.nm_produto
    end as nm_produto,  
    IsNull(pci.nm_fantasia_produto,s.nm_servico) as nm_fantasia_produto,  
    case when isnull(pci.cd_servico,0)>0 then
      cast(pci.cd_servico as varchar(25)) 
    else
      case when isnull(pci.cd_produto,0) = 0 
           then cast(s.cd_grupo_produto as varchar(20) )
           else p.cd_mascara_produto end 
    end as cd_mascara_produto,
    pci.dt_item_canc_ped_compra,
    pci.qt_item_entrada_ped_compr,
    pci.vl_total_item_pedido_comp,
    plc.nm_plano_compra,
    cc.nm_centro_custo,
    c.nm_fantasia_comprador,
    d.nm_departamento,
    um.sg_unidade_medida,
    pci.cd_pedido_venda,
    pci.cd_item_pedido_venda,
    pci.cd_requisicao_compra,
    pci.cd_requisicao_compra_item

--select * from pedido_compra_item

  from
    pedido_compra_item pci      with (nolock) 
    inner join pedido_compra pc with (nolock) on pc.cd_pedido_compra = pci.cd_pedido_compra
    left  join fornecedor f     with (nolock) on f.cd_fornecedor = pc.cd_fornecedor
    left  join Plano_Compra plc with (nolock) on plc.cd_plano_compra = case 
                                                           when isnull(pci.cd_plano_compra,0)=0 then
                                                             isnull(pc.cd_plano_compra,0)
                                                           else
                                                             pci.cd_plano_compra
                                                         end
    left  join Centro_Custo cc  on cc.cd_centro_custo  = case 
                                                           when isnull(pci.cd_centro_custo,0)=0 then
                                                             isnull(pc.cd_centro_custo,0)
                                                           else
                                                             pci.cd_centro_custo
                                                         end
    left  join servico s         on s.cd_servico = pci.cd_servico
    left  join Produto p         on p.cd_produto = pci.cd_produto
    left  join Comprador c       on c.cd_comprador = pc.cd_comprador
    left  join Departamento d    on d.cd_departamento = pc.cd_departamento
    left  join Unidade_Medida um on um.cd_unidade_medida = pci.cd_unidade_medida
  where
    isnull(pci.qt_saldo_item_ped_compra,0) > 0 and
    pci.dt_entrega_item_ped_compr between @dt_inicial and @dt_final and
    pci.dt_item_canc_ped_compra is null

  order by
    pci.dt_entrega_item_ped_compr

