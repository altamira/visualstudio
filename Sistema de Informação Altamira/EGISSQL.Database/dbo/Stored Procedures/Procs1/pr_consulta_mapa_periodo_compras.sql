
CREATE PROCEDURE pr_consulta_mapa_periodo_compras
@cd_grupo_compra     int,
@cd_plano_compra     int,
@dt_inicial          datetime,
@dt_final            datetime,
@ic_parametro        int -- 0 para emissão, 1 para entrega.
AS


  -- PEDIDOS COM DATA DE ENTREGA OU EMISSÃO NO PERÍODO
  -- SOMENTE OS QUE AINDA NÃO FORAM RECEBIDOS E QUE ESTÃO APROVADOS
  select 
    distinct
    pci.cd_pedido_compra                        as 'Pedido',
    pci.cd_item_pedido_compra                   as 'Item',
    pc.cd_plano_compra                          as 'CodPlano',
    pl.cd_mascara_plano_compra                  as 'PlanoCompra',    
    gc.nm_grupo_Compra                          as 'GrupoCompra',
    pl.nm_plano_compra                          as 'Descricao',
    case when IsNull(pci.pc_ipi,0) > 0 then
      pci.vl_total_item_pedido_comp + ((pci.vl_total_item_pedido_comp * pci.pc_ipi) / 100 )
    else
      pci.vl_total_item_pedido_comp end         as 'ValorComprado',
    cast(null as decimal(25,2))                 as 'ValorRecebido'
  into 
    #Mapa_Compra
  from 
    Pedido_Compra pc 
  left outer join 
    Pedido_Compra_item pci 
  on 
    pci.cd_pedido_compra = pc.cd_pedido_compra 
  left outer join
    Plano_Compra pl  
  on 
    pl.cd_plano_compra = pc.cd_plano_compra 
  left outer join
    Fornecedor fo 
  on 
    fo.cd_fornecedor = pc.cd_fornecedor      
  left outer join 
    Grupo_Compra gc
  on
    gc.cd_grupo_compra = pl.cd_grupo_compra
  where 
    (exists (select 'x' from pedido_compra_aprovacao pca where
             pca.cd_pedido_compra = pc.cd_pedido_compra and
             pca.cd_tipo_aprovacao = 1)) and
    ((pci.dt_item_pedido_compra between @dt_inicial and @dt_final and @ic_parametro = 0) or
    (pci.dt_entrega_item_ped_compr between @dt_inicial and @dt_final and @ic_parametro = 1 )) and
    ((pl.cd_plano_compra = @cd_plano_compra) or (@cd_plano_compra = 0)) and      
    (isnull(pl.ic_mapa_plano_compra,'S') = 'S') and  -- ELIAS 24/11/2003
    (pci.dt_item_canc_ped_compra is null) and (not exists (select top 1 'x' from Nota_Entrada_Item nei
                                                           where nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                                 nei.cd_item_pedido_compra = pci.cd_item_pedido_compra))

  -- PEDIDOS COM DATA DE RECEBIMENTO NO PERÍODO
  select 
    distinct
    pci.cd_pedido_compra                        as 'Pedido',
    pci.cd_item_pedido_compra                   as 'Item',
    pl.cd_mascara_plano_compra                  as 'PlanoCompra',
    pc.cd_plano_compra                          as 'CodPlano',
    gc.nm_grupo_Compra                          as 'GrupoCompra',
    pl.nm_plano_compra                          as 'Descricao',
    -- VALOR TOTAL RECEBIDO
    (select sum(isnull(nei.vl_item_nota_entrada,0) +
                isnull(nei.vl_ipi_nota_entrada,0)) 
     from Nota_Entrada_item nei
     where nei.cd_pedido_compra = pci.cd_pedido_compra and 
           nei.cd_item_pedido_compra = pci.cd_item_pedido_compra and
           nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final) as 'ValorRecebido'
  into
    #Mapa_Recebido
  from 
    Pedido_Compra pc
  inner join
    Pedido_Compra_item pci 
  on
    pc.cd_pedido_compra = pci.cd_pedido_compra
  inner join
    Nota_Entrada_Item nei
  on
    nei.cd_pedido_compra = pci.cd_pedido_compra and
    nei.cd_item_pedido_compra = pci.cd_item_pedido_compra 
  left outer join
    Plano_Compra pl  
  on 
    pl.cd_plano_compra = pc.cd_plano_compra 
  left outer join
    Fornecedor fo 
  on 
    fo.cd_fornecedor = pc.cd_fornecedor      
  left outer join 
    Grupo_Compra gc
  on
    gc.cd_grupo_compra = pl.cd_grupo_compra
  where
    nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final and
    ((pl.cd_plano_compra = @cd_plano_compra) or (@cd_plano_compra = 0)) and      
    (isnull(pl.ic_mapa_plano_compra,'S') = 'S')

  update #Mapa_Compra
  set ValorComprado = mp.ValorComprado,
      ValorRecebido = mr.ValorRecebido
  from
    #Mapa_Compra mp,
    #Mapa_Recebido mr
  where
    mp.Pedido = mr.Pedido and
    mp.Item = mr.Item

  delete from #Mapa_Recebido
  from
    #Mapa_Compra mp,
    #Mapa_Recebido mr
  where
    mp.Pedido = mr.Pedido and
    mp.Item = mr.Item

  insert into #Mapa_Compra
   (PlanoCompra,
    Descricao,
    CodPlano,
    GrupoCompra,
    ValorComprado,
    ValorRecebido)
  select
    PlanoCompra,
    Descricao,
    CodPlano,
    GrupoCompra,
    ValorRecebido,
    ValorRecebido
  from
    #Mapa_Recebido

  declare @vl_total decimal(25,2)
  declare @vl_total_recebido decimal(25,2)

  select 
    @vl_total = Sum(ValorComprado)
  from
    #Mapa_Compra

  select
    @vl_total_recebido = sum(ValorRecebido)
  from
    #Mapa_Compra

  select 
    GrupoCompra,
    PlanoCompra,
    Descricao,
    sum(ValorComprado) as ValorComprado,
    sum(ValorRecebido) as ValorRecebido,
    (select top 1 pco.vl_previsto_plano_compra from plano_compra_orcamento pco
     where pco.cd_plano_compra = CodPlano and
           pco.dt_final_plano_compra between @dt_inicial and @dt_final
     order by dt_final_plano_compra) as Estimado,
    cast((Isnull(sum(ValorComprado), 1) / @vl_total) * 100 as numeric(25,2)) as Porcent,
    cast((Isnull(sum(ValorRecebido), 1) / @vl_total_recebido) * 100 as numeric(25,2)) as PercRec    
  from
    #Mapa_Compra
  group by
    GrupoCompra,
    PlanoCompra,
    CodPlano,
    Descricao
  order by 
    PlanoCompra

