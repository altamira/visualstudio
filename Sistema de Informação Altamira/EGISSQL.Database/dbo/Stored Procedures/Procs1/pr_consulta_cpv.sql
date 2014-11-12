
create procedure pr_consulta_cpv
@ic_parametro int,
@cd_categoria_produto int,
@cd_grupo_estoque int,
@ic_tipo_mercado char(1), -- (I)nterno, (E)xterno, (S)MO, (T)odos
@ic_estoque char(1), -- (E)stoque, (C)omprado, (T)odos
@dt_inicial datetime,
@dt_final datetime,
@ic_id_coluna char(1)
as 

  SET NOCOUNT ON
  SET LOCK_TIMEOUT 300000

  declare @Produto varchar(20)
  declare @PV int
  declare @ItemPV int
  declare @QtdeNFS int
  declare @QtdePV int

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Consulta dos Produtos Faturados por Categoria
-------------------------------------------------------------------------------
begin

  -- TODOS OS PEDIDOS FATURADOS POR CATEGORIA
  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(ns.ic_smo_nota_saida,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,

    -- CLIENTE, NO CASO DE EXPORTAÇÃO
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,

    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    nsi.cd_categoria_produto as CodCategoria,

    cp.cd_mascara_categoria as Categoria,

    cp.nm_categoria_produto as NomeCategoria,

    case when (isnull(gp.ic_especial_grupo_produto,'N') = 'S') then
      'PVE '+cast(nsi.cd_pedido_venda as varchar(6))+'/'+cast(nsi.cd_item_pedido_venda as varchar(3))
    else
      isnull(p.nm_fantasia_produto, 'PVE '+cast(nsi.cd_pedido_venda as varchar(6))+'/'+cast(nsi.cd_item_pedido_venda as varchar(3)))
    end as Fantasia,

    nsi.nm_produto_item_nota as Produto,

    sum(nsi.qt_item_nota_saida) as QtdeNFS,

    sum(isnull(pvi.qt_item_pedido_venda,nsi.qt_item_nota_saida)) as QtdePV,

    -- FATURAMENTO NORMAL
    sum(case when (isnull(op.ic_zfm_operacao_fiscal,'N') = 'N') then 
          cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
        else 
          -- FATURAMENTO PARA ZONA FRANCA DE MANAUS - (INDUSTRIALIZACAO)
          case when (ns.cd_destinacao_produto = 1) then 
            cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) - 
             (cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) * 
              cast(str((isnull(nsi.pc_reducao_icms,0)/100),25,4) as decimal(25,4))) * 
              cast(str((isnull(nsi.pc_icms_desc_item,0)/100),25,4) as decimal(25,4)) + 
            cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
          else -- FATURAMENTO PARA ZONA FRANCA DE MANAUS - (USO PRÓPRIO)
            cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
          end
        end) as Total,

    cast(0 as float) as CodMP1,
    cast(0 as float) as CodMP2,
    cast(0 as float) as CodMP3,
    cast(0 as float) as CodMP4,
    cast(0 as float) as CodMP5,
    cast(0 as float) as CodMP6,
    cast(0 as float) as CodMP7,
    cast(0 as float) as CodMP8,
    cast(0 as float) as CodMP9,
    cast(0 as float) as CodMP10,
    cast(0 as float) as CodMP11,
    cast(0 as float) as CodMP12,
    cast(0 as float) as CodMP13,
    cast(0 as float) as CodMP14,
    cast(0 as float) as CodMP15,
    cast(0 as float) as CodMP16,
    cast(0 as float) as CodMP17,
    cast(0 as float) as CodMP18
  into #Faturados
  from Nota_Saida_Item nsi with(nolock) 
    inner join Nota_Saida ns with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal    
    inner join Categoria_Produto cp with(nolock) on cp.cd_categoria_produto = nsi.cd_categoria_produto
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = nsi.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = gp.cd_grupo_produto
    inner join vw_destinatario_rapida vw with(nolock) on ns.cd_tipo_destinatario = vw.cd_tipo_destinatario and
                                                         ns.cd_cliente = vw.cd_destinatario
    left outer join Pedido_Venda_Item pvi with(nolock) on pvi.cd_pedido_venda = nsi.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda
    left outer join Produto p with(nolock) on nsi.cd_produto = p.cd_produto
  where 
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    cp.cd_categoria_produto = case when isnull(@cd_categoria_produto,0) = 0 
                              then cp.cd_categoria_produto
                              else isnull(@cd_categoria_produto,0) end and
    ns.cd_status_nota <> 7 and

    op.ic_custo_operacao_fiscal = 'S' and
    isnull(cp.ic_vendas_categoria,'N') = 'S' and
   
    -- Somente filtrar se não for SMO
    case when (@ic_tipo_mercado <> 'S') then
      gpc.ic_custo else 'S' end = 'S' and

    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(ns.ic_smo_nota_saida,'N') 
        else 'N' end end = isnull(ns.ic_smo_nota_saida,'N') and
  
    -- Filtro para não buscar Grupos de Revenda
    isnull(gp.ic_revenda_grupo_produto,'N') = 'N'     

  group by isnull(gp.ic_especial_grupo_produto,'N'), 
    isnull(ns.ic_smo_nota_saida,'N'), isnull(vw.cd_tipo_mercado,1), 
    nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, nsi.cd_categoria_produto,
    cp.cd_mascara_categoria, cp.nm_categoria_produto,
    p.nm_fantasia_produto, nsi.nm_produto_item_nota, nsi.nm_fantasia_produto,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end

  union all

  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(ns.ic_smo_nota_saida,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,

    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,

    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    nsi.cd_categoria_produto as CodCategoria,
    '9.99.999' as Categoria,

    'COMPLEMENTO' as NomeCategoria,
    ' ' as Fantasia,
    isnull(nsi.nm_produto_item_nota, 'NFS '+cast(ns.cd_nota_saida as varchar(6))) as Produto,

    sum(isnull(nsi.qt_item_nota_saida,1)) as QtdeNFS,

    sum(isnull(pvi.qt_item_pedido_venda,isnull(nsi.qt_item_nota_saida,1))) as QtdePV,

    -- FATURAMENTO NORMAL
    ns.vl_total as Total,

    cast(0 as float) as CodMP1,
    cast(0 as float) as CodMP2,
    cast(0 as float) as CodMP3,
    cast(0 as float) as CodMP4,
    cast(0 as float) as CodMP5,
    cast(0 as float) as CodMP6,
    cast(0 as float) as CodMP7,
    cast(0 as float) as CodMP8,
    cast(0 as float) as CodMP9,
    cast(0 as float) as CodMP10,
    cast(0 as float) as CodMP11,
    cast(0 as float) as CodMP12,
    cast(0 as float) as CodMP13,
    cast(0 as float) as CodMP14,
    cast(0 as float) as CodMP15,
    cast(0 as float) as CodMP16,
    cast(0 as float) as CodMP17,
    cast(0 as float) as CodMP18
  from Nota_Saida ns with(nolock) 
    left outer join Nota_Saida_Item nsi with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on isnull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal) = op.cd_operacao_fiscal    
    inner join vw_destinatario_rapida vw with(nolock) on ns.cd_tipo_destinatario = vw.cd_tipo_destinatario and
                                                         ns.cd_cliente = vw.cd_destinatario
    left outer join Pedido_Venda_Item pvi with(nolock) on pvi.cd_pedido_venda = nsi.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda
  where 
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.cd_status_nota <> 7 and

    isnull(op.ic_custo_operacao_fiscal,'N') = 'S' and

    ((isnull(nsi.cd_item_nota_saida,0) = 0) or 
     (isnull(op.ic_complemento_op_fiscal,'N') = 'S')) and
    
    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(ns.ic_smo_nota_saida,'N') 
        else 'N' end end = isnull(ns.ic_smo_nota_saida,'N')        

  group by ns.vl_total, isnull(ns.ic_smo_nota_saida,'N'), 
    isnull(vw.cd_tipo_mercado,1), nsi.cd_pedido_venda, 
    ns.cd_nota_saida, 
    nsi.cd_item_pedido_venda, nsi.cd_categoria_produto,
    nsi.nm_fantasia_produto, nsi.nm_produto_item_nota,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end

  order by Categoria, Fantasia

  -- MATERIAS PRIMAS E PESOS POR PV
  create table #PVMP (
    PV int,
    ItemPV int,
    MP int null,
    PesoBruto float null)

  declare cMP cursor for
  select Fantasia, PV, ItemPV, QtdeNFS, QtdePV from #Faturados order by 1, 2

  open cMP

  fetch next from cMP into @Produto, @PV, @ItemPV, @QtdeNFS, @QtdePV

  while @@fetch_status = 0
  begin

    insert into #PVMP
    select @PV, @ItemPV, isnull(cd_materia_prima,0),   
      sum(qt_peso_bruto / qt_item_pedido_venda * @QtdeNFS)
    from dbo.fn_materia_prima_pedido(@PV, @ItemPV, 'N', @dt_inicial, @dt_final)
    where isnull(qt_peso_bruto,0) <> 0 and
      case when @ic_estoque = 'T' then ic_arvore_produto
      else @ic_estoque end = ic_arvore_produto    
    group by isnull(cd_materia_prima,0)

    fetch next from cMP into @Produto, @PV, @ItemPV, @QtdeNFS, @QtdePV

  end

  close cMP
  deallocate cMP

  -- COLUNAS DA CONSULTA
  select identity(int, 1, 1) as ID, isnull(MP,0) as MP
  into #Coluna
  from #PVMP
  where (isnull(MP,0) <> 0)
  group by isnull(MP,0)
  order by isnull(MP,0)

  if (@ic_id_coluna = 'S')
  begin

    select col.ID, case when (isnull(col.MP,0) = 0) 
                   then 'INDEFINIDA' 
                   else mp.nm_fantasia_mat_prima end as MP
    from #Coluna col 
      left outer join Materia_Prima mp with(nolock) on col.MP = mp.cd_mat_prima
    order by col.ID

  end
  else
  begin

    update #Faturados
    set CodMP1 = isnull(pvmp.PesoBruto,0)
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 1 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP2 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 2 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP3 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 3 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP4 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 4 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP5 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 5 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP6 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 6 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP7 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 7 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP8 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 8 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP9 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 9 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP10 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 10 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP11 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 11 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP12 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 12 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP13 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 13 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP14 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 14 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP15 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 15 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP16 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 16 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP17 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 17 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Faturados
    set CodMP18 = pvmp.PesoBruto 
    from #Faturados fat
      inner join #PVMP pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #Coluna col on pvmp.MP = col.MP
    where col.ID = 18 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    if (@ic_estoque = 'T') 
      select Tipo, Cliente, CodCategoria,
        Categoria, NomeCategoria, Fantasia, Produto, sum(QtdeNFS) as QtdeNFS, sum(Total) as Total,   
        sum(CodMP1) as CodMP1, sum(CodMP2) as CodMP2, sum(CodMP3) as CodMP3, 
        sum(CodMP4) as CodMP4, sum(CodMP5) as CodMP5, sum(CodMP6) as CodMP6,
        sum(CodMP7) as CodMP7, sum(CodMP8) as CodMP8, sum(CodMP9) as CodMP9, 
        sum(CodMP10) as CodMP10, sum(CodMP11) as CodMP11, sum(CodMP12) as CodMP12, 
        sum(CodMP13) as CodMP13, sum(CodMP14) as CodMP14, sum(CodMP15) as CodMP15, 
        sum(CodMP16) as CodMP16, sum(CodMP17) as CodMP17, sum(CodMP18) as CodMP18, 

        sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
            CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
            CodMP15+ CodMP16 + CodMP17 + CodMP18) as PesoTotal
      from #Faturados
      group by Tipo, Cliente, CodCategoria, Categoria, NomeCategoria, Fantasia, Produto
      order by Tïpo, Categoria, Cliente, Fantasia
    else
      select Tipo, Cliente, CodCategoria,
        Categoria, NomeCategoria, Fantasia, Produto, sum(QtdeNFS) as QtdeNFS, sum(Total) as Total,   
        sum(CodMP1) as CodMP1, sum(CodMP2) as CodMP2, sum(CodMP3) as CodMP3, 
        sum(CodMP4) as CodMP4, sum(CodMP5) as CodMP5, sum(CodMP6) as CodMP6,
        sum(CodMP7) as CodMP7, sum(CodMP8) as CodMP8, sum(CodMP9) as CodMP9, 
        sum(CodMP10) as CodMP10, sum(CodMP11) as CodMP11, sum(CodMP12) as CodMP12, 
        sum(CodMP13) as CodMP13, sum(CodMP14) as CodMP14, sum(CodMP15) as CodMP15, 
        sum(CodMP16) as CodMP16, sum(CodMP17) as CodMP17, sum(CodMP18) as CodMP18, 

        sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
            CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
            CodMP15+ CodMP16 + CodMP17 + CodMP18) as PesoTotal
      from #Faturados
      group by Tipo, Cliente, CodCategoria, Categoria, NomeCategoria, Fantasia, Produto
      having sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
                 CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
                 CodMP15+ CodMP16 + CodMP17 + CodMP18) > 0
      order by Tïpo, Categoria, Cliente, Fantasia    

  end

end 
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Consulta dos Produtos Devolvidos por Categoria
-------------------------------------------------------------------------------
begin

  -- TODOS OS PEDIDOS FATURADOS POR CATEGORIA
  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(ns.ic_smo_nota_saida,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,

    -- CLIENTE, NO CASO DE EXPORTAÇÃO
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,

    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    nsi.cd_categoria_produto as CodCategoria,
    cp.cd_mascara_categoria as Categoria,
    cp.nm_categoria_produto as NomeCategoria,

    case when (isnull(gp.ic_especial_grupo_produto,'N') = 'S') then
      'PVE '+cast(nsi.cd_pedido_venda as varchar(6))+'/'+cast(nsi.cd_item_pedido_venda as varchar(3))
    else
      isnull(p.nm_fantasia_produto, 'PVE '+cast(nsi.cd_pedido_venda as varchar(6))+'/'+cast(nsi.cd_item_pedido_venda as varchar(3)))
    end as Fantasia,

    nsi.nm_produto_item_nota as Produto,
    sum(nsi.qt_devolucao_item_nota) as QtdeNFS,
    sum(isnull(pvi.qt_item_pedido_venda,nsi.qt_devolucao_item_nota)) as QtdePV,
    -- FATURAMENTO NORMAL
    sum(case when (isnull(op.ic_zfm_operacao_fiscal,'N') = 'N') then 
          cast(str(isnull((nsi.vl_total_item  / 
                           nsi.qt_item_nota_saida * 
                           nsi.qt_devolucao_item_nota),0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
        else 
          -- FATURAMENTO PARA ZONA FRANCA DE MANAUS - (INDUSTRIALIZACAO)
          case when (ns.cd_destinacao_produto = 1) then 
            cast(str(isnull((nsi.vl_total_item  / 
                             nsi.qt_item_nota_saida * 
                             nsi.qt_devolucao_item_nota),0),25,2) as decimal(25,2)) - 
             (cast(str(isnull((nsi.vl_total_item  / 
                               nsi.qt_item_nota_saida * 
                               nsi.qt_devolucao_item_nota),0),25,2) as decimal(25,2)) * 
              cast(str((isnull(nsi.pc_reducao_icms,0)/100),25,4) as decimal(25,4))) * 
              cast(str((isnull(nsi.pc_icms_desc_item,0)/100),25,4) as decimal(25,4)) + 
            cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
          else -- FATURAMENTO PARA ZONA FRANCA DE MANAUS - (USO PRÓPRIO)
            cast(str(isnull((nsi.vl_total_item  / 
                             nsi.qt_item_nota_saida * 
                             nsi.qt_devolucao_item_nota),0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
          end
        end) as Total,
    cast(0 as float) as CodMP1,
    cast(0 as float) as CodMP2,
    cast(0 as float) as CodMP3,
    cast(0 as float) as CodMP4,
    cast(0 as float) as CodMP5,
    cast(0 as float) as CodMP6,
    cast(0 as float) as CodMP7,
    cast(0 as float) as CodMP8,
    cast(0 as float) as CodMP9,
    cast(0 as float) as CodMP10,
    cast(0 as float) as CodMP11,
    cast(0 as float) as CodMP12,
    cast(0 as float) as CodMP13,
    cast(0 as float) as CodMP14,
    cast(0 as float) as CodMP15,
    cast(0 as float) as CodMP16,
    cast(0 as float) as CodMP17,
    cast(0 as float) as CodMP18
  into #Devolvidos
  from Nota_Saida_Item nsi with(nolock) 
    inner join Nota_Saida ns with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal    
    inner join Categoria_Produto cp with(nolock) on cp.cd_categoria_produto = nsi.cd_categoria_produto
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = nsi.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = gp.cd_grupo_produto
    inner join vw_destinatario_rapida vw with(nolock) on ns.cd_tipo_destinatario = vw.cd_tipo_destinatario and
                                                         ns.cd_cliente = vw.cd_destinatario
    left outer join Pedido_Venda_Item pvi with(nolock) on pvi.cd_pedido_venda = nsi.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda    
    left outer join Produto p with(nolock) on nsi.cd_produto = p.cd_produto
  where 
    nsi.dt_restricao_item_nota between @dt_inicial and @dt_final and
    cp.cd_categoria_produto = case when isnull(@cd_categoria_produto,0) = 0 
                              then cp.cd_categoria_produto
                              else isnull(@cd_categoria_produto,0) end and
    ns.cd_status_nota <> 7 and
    op.ic_custo_operacao_fiscal = 'S' and
    isnull(cp.ic_vendas_categoria,'N') = 'S' and
    gpc.ic_custo = 'S' and
    isnull(nsi.qt_devolucao_item_nota,0) <> 0 and

    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(ns.ic_smo_nota_saida,'N') 
        else 'N' end end = isnull(ns.ic_smo_nota_saida,'N')and
  
    -- Filtro para não buscar Grupos de Revenda
    isnull(gp.ic_revenda_grupo_produto,'N') = 'N'

  group by isnull(gp.ic_especial_grupo_produto,'N'), 
    isnull(ns.ic_smo_nota_saida,'N'), isnull(vw.cd_tipo_mercado,1), 
    nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, nsi.cd_categoria_produto,
    cp.cd_mascara_categoria, cp.nm_categoria_produto,
    p.nm_fantasia_produto, nsi.nm_produto_item_nota, nsi.nm_fantasia_produto,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end

  union all

  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(ns.ic_smo_nota_saida,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,

    -- CLIENTE, NO CASO DE EXPORTAÇÃO
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,

    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    nsi.cd_categoria_produto as CodCategoria,
    '9.99.999' as Categoria,
    'COMPLEMENTO' as NomeCategoria,
    ' ' as Fantasia,
    isnull(nsi.nm_produto_item_nota, 'NFS '+cast(ns.cd_nota_saida as varchar(6))) as Produto,

    sum(isnull(nsi.qt_item_nota_saida,1)) as QtdeNFS,

    sum(isnull(pvi.qt_item_pedido_venda,isnull(nsi.qt_item_nota_saida,1))) as QtdePV,

    -- FATURAMENTO NORMAL
    ns.vl_total as Total,

    cast(0 as float) as CodMP1,
    cast(0 as float) as CodMP2,
    cast(0 as float) as CodMP3,
    cast(0 as float) as CodMP4,
    cast(0 as float) as CodMP5,
    cast(0 as float) as CodMP6,
    cast(0 as float) as CodMP7,
    cast(0 as float) as CodMP8,
    cast(0 as float) as CodMP9,
    cast(0 as float) as CodMP10,
    cast(0 as float) as CodMP11,
    cast(0 as float) as CodMP12,
    cast(0 as float) as CodMP13,
    cast(0 as float) as CodMP14,
    cast(0 as float) as CodMP15,
    cast(0 as float) as CodMP16,
    cast(0 as float) as CodMP17,
    cast(0 as float) as CodMP18
  from Nota_Saida ns with(nolock) 
    left outer join Nota_Saida_Item nsi with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on isnull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal) = op.cd_operacao_fiscal    
    inner join vw_destinatario_rapida vw with(nolock) on ns.cd_tipo_destinatario = vw.cd_tipo_destinatario and
                                                         ns.cd_cliente = vw.cd_destinatario
    left outer join Pedido_Venda_Item pvi with(nolock) on pvi.cd_pedido_venda = nsi.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda
  where 
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.cd_status_nota <> 7 and

    isnull(nsi.qt_devolucao_item_nota,0) <> 0 and

    isnull(op.ic_custo_operacao_fiscal,'N') = 'S' and

    ((isnull(nsi.cd_item_nota_saida,0) = 0) or 
     (isnull(op.ic_complemento_op_fiscal,'N') = 'S')) and
    
    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(ns.ic_smo_nota_saida,'N') 
        else 'N' end end = isnull(ns.ic_smo_nota_saida,'N')
        
  group by ns.vl_total, isnull(ns.ic_smo_nota_saida,'N'), 
    isnull(vw.cd_tipo_mercado,1), nsi.cd_pedido_venda, 
    ns.cd_nota_saida, 
    nsi.cd_item_pedido_venda, nsi.cd_categoria_produto,
    nsi.nm_fantasia_produto, nsi.nm_produto_item_nota,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end

  order by CodCategoria, Fantasia

  -- MATERIAS PRIMAS E PESOS POR PV
  create table #PVMPDevolvido (
    PV int,
    ItemPV int,
    MP int null,
    PesoBruto float null)

  declare cMPDevolvido cursor for
  select PV, ItemPV, QtdeNFS, QtdePV from #Devolvidos order by 1, 2

  open cMPDevolvido

  fetch next from cMPDevolvido into @PV, @ItemPV, @QtdeNFS, @QtdePV

  while @@fetch_status = 0
  begin

    insert into #PVMPDevolvido
      select @PV, @ItemPV, isnull(cd_materia_prima,0),   
      sum(qt_peso_bruto / qt_item_pedido_venda * @QtdeNFS)
    from dbo.fn_materia_prima_pedido(@PV, @ItemPV, 'N', @dt_inicial, @dt_final)
    where isnull(qt_peso_bruto,0) <> 0 and
      case when @ic_estoque = 'T' then ic_arvore_produto
      else @ic_estoque end = ic_arvore_produto
    group by cd_materia_prima

    fetch next from cMPDevolvido into @PV, @ItemPV, @QtdeNFS, @QtdePV

  end

  close cMPDevolvido
  deallocate cMPDevolvido

  -- COLUNAS DA CONSULTA
  select identity(int, 1, 1) as ID, MP
  into #ColunaDevolvido
  from #PVMPDevolvido
  where (isnull(MP,0) <> 0)
  group by MP  
  order by MP

  if (@ic_id_coluna = 'S')
  begin

    select col.ID, isnull(mp.nm_fantasia_mat_prima,'INDEFINIDA') as MP
    from #ColunaDevolvido col 
      left outer join Materia_Prima mp with(nolock) on col.MP = mp.cd_mat_prima
    order by col.ID

  end
  else
  begin

    update #Devolvidos
    set CodMP1 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 1 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP2 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 2 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP3 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 3 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP4 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 4 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP5 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 5 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP6 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 6 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP7 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 7 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP8 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 8 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP9 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 9 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP10 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 10 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP11 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 11 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP12 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 12 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP13 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 13 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP14 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 14 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP15 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 15 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP16 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 16 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP17 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 17 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #Devolvidos
    set CodMP18 = pvmp.PesoBruto 
    from #Devolvidos fat
      inner join #PVMPDevolvido pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaDevolvido col on pvmp.MP = col.MP
    where col.ID = 18 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    if (@ic_estoque = 'T') 
      select Tipo, Cliente, CodCategoria,
        Categoria, NomeCategoria, Fantasia, Produto, sum(QtdeNFS) as QtdeNFS, sum(Total) as Total,   
        sum(CodMP1) as CodMP1, sum(CodMP2) as CodMP2, sum(CodMP3) as CodMP3, 
        sum(CodMP4) as CodMP4, sum(CodMP5) as CodMP5, sum(CodMP6) as CodMP6,
        sum(CodMP7) as CodMP7, sum(CodMP8) as CodMP8, sum(CodMP9) as CodMP9, 
        sum(CodMP10) as CodMP10, sum(CodMP11) as CodMP11, sum(CodMP12) as CodMP12, 
        sum(CodMP13) as CodMP13, sum(CodMP14) as CodMP14, sum(CodMP15) as CodMP15, 
        sum(CodMP16) as CodMP16, sum(CodMP17) as CodMP17, sum(CodMP18) as CodMP18, 

        sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
            CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
            CodMP15+ CodMP16 + CodMP17 + CodMP18 ) as PesoTotal
      from #Devolvidos
      group by Tipo, Cliente, CodCategoria, Categoria, NomeCategoria, Fantasia, Produto
      order by Tipo, Cliente, Categoria, Fantasia
    else
      select Tipo, Cliente, CodCategoria,
        Categoria, NomeCategoria, Fantasia, Produto, sum(QtdeNFS) as QtdeNFS, sum(Total) as Total,   
        sum(CodMP1) as CodMP1, sum(CodMP2) as CodMP2, sum(CodMP3) as CodMP3, 
        sum(CodMP4) as CodMP4, sum(CodMP5) as CodMP5, sum(CodMP6) as CodMP6,
        sum(CodMP7) as CodMP7, sum(CodMP8) as CodMP8, sum(CodMP9) as CodMP9, 
        sum(CodMP10) as CodMP10, sum(CodMP11) as CodMP11, sum(CodMP12) as CodMP12, 
        sum(CodMP13) as CodMP13, sum(CodMP14) as CodMP14, sum(CodMP15) as CodMP15, 
        sum(CodMP16) as CodMP16, sum(CodMP17) as CodMP17, sum(CodMP18) as CodMP18, 

        sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
            CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
            CodMP15+ CodMP16 + CodMP17 + CodMP18 ) as PesoTotal
      from #Devolvidos
      group by Tipo, Cliente, CodCategoria, Categoria, NomeCategoria, Fantasia, Produto
      having sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
                 CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
                 CodMP15+ CodMP16 + CodMP17 + CodMP18) > 0
      order by Tipo, Cliente, Categoria, Fantasia      
     
  end

end 
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Consulta dos Materiais por Grupo de Estoque e Categoria
-------------------------------------------------------------------------------
begin

  -- TODOS OS PEDIDOS FATURADOS POR GRUPO DE ESTOQUE E CATEGORIA
  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(ns.ic_smo_nota_saida,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,

    -- CLIENTE, NO CASO DE EXPORTAÇÃO
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,

    nsi.cd_categoria_produto as CodCategoria,
    cp.cd_mascara_categoria as Categoria,
    cp.nm_categoria_produto as NomeCategoria,
    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    sum(nsi.qt_item_nota_saida) as QtdeNFS
  into #FaturadosMatSec
  from Nota_Saida_Item nsi with(nolock) 
    inner join Nota_Saida ns with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal    
    inner join Categoria_Produto cp with(nolock) on cp.cd_categoria_produto = nsi.cd_categoria_produto
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = nsi.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = gp.cd_grupo_produto
    inner join vw_destinatario_rapida vw on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                            vw.cd_destinatario = ns.cd_cliente
    left outer join Produto p with(nolock) on p.cd_produto = nsi.cd_produto
  where 
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.cd_status_nota <> 7 and
    op.ic_custo_operacao_fiscal = 'S' and
    isnull(cp.ic_vendas_categoria,'N') = 'S' and

    -- Somente filtrar se não for SMO
    case when (@ic_tipo_mercado <> 'S') then
      gpc.ic_custo else 'S' end = 'S' and

    case when (isnull(p.cd_produto,0) <> 0) then
      isnull(p.ic_producao_produto,'N') 
    else 'S' end = 'S' and

    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(ns.ic_smo_nota_saida,'N') 
        else 'N' end end = isnull(ns.ic_smo_nota_saida,'N') and
  
    -- Filtro para não buscar Grupos de Revenda
    isnull(gp.ic_revenda_grupo_produto,'N') = 'N'

  group by isnull(ns.ic_smo_nota_saida,'N'), isnull(vw.cd_tipo_mercado,1), 
    nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, nsi.cd_categoria_produto, 
    cp.cd_mascara_categoria, cp.nm_categoria_produto, nsi.nm_fantasia_produto,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end


  -- MATERIAS PRIMAS E PESOS POR PV
  create table #PVMatSec (
    PV int,
    ItemPV int,
    CodProduto int,
    QtdeNFS decimal(25,3))

  declare cMatSec cursor for
  select PV, ItemPV, QtdeNFS
  from #FaturadosMatSec order by 1, 2

  open cMatSec

  fetch next from cMatSec into @PV, @ItemPV, @QtdeNFS

  while @@fetch_status = 0
  begin

    insert into #PVMatSec
    select @PV, @ItemPV, cd_produto, (qt_produto * @QtdeNFS)
    from dbo.fn_material_secundario_pedido(@PV, @ItemPV)
    where cd_grupo_estoque = case when @cd_grupo_estoque = 0 
                             then cd_grupo_estoque
                             else @cd_grupo_estoque end and
      case when @ic_estoque = 'T' then ic_arvore_produto
      else @ic_estoque end = ic_arvore_produto

    fetch next from cMatSec into @PV, @ItemPV, @QtdeNFS

  end

  close cMatSec
  deallocate cMatSec

  select distinct
    fat.Tipo,
    fat.Cliente,
    ge.cd_grupo_estoque as CodGrupoEstoque, 
    ge.nm_grupo_estoque as GrupoEstoque,
    fat.CodCategoria, fat.Categoria, fat.NomeCategoria,
    gp.cd_grupo_produto as CodGrupoProduto, 
    gp.nm_grupo_produto as GrupoProduto,
    p.nm_fantasia_produto as Fantasia,
    p.cd_mascara_produto as Mascara,
    p.nm_produto as Produto,
    sum(pv.QtdeNFS) as QtdeNFS,
    isnull((ppc.vl_mat_prima_fornecedor -
           (ppc.vl_mat_prima_fornecedor *
            dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_mat_prima_fornecedor) / 100)), 0) as CustoUnitario,
--     isnull((ppc.vl_produto_preco_compra - 
--             (ppc.vl_produto_preco_compra * 
--              dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_base_preco) / 100)), 0) as CustoUnitario,
    (sum(pv.QtdeNFS) * isnull((ppc.vl_mat_prima_fornecedor - 
                              (ppc.vl_mat_prima_fornecedor * 
                               dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_mat_prima_fornecedor) / 100)), 0)) as CustoTotal
--     (sum(pv.QtdeNFS) * isnull((ppc.vl_produto_preco_compra - 
--                               (ppc.vl_produto_preco_compra * 
--                                dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_base_preco) / 100)), 0)) as CustoTotal
  from
    #PVMatSec pv 
    inner join #FaturadosMatSec fat on pv.PV = fat.PV and
                                       pv.ItemPV = fat.ItemPV
    inner join Produto p with(nolock) on pv.CodProduto = p.cd_produto
    inner join Produto_Custo pc with(nolock) on p.cd_produto = pc.cd_produto
    left outer join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Grupo_Produto_Custo gpc with(nolock) on p.cd_grupo_produto = gpc.cd_grupo_produto
    left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = isnull(pc.cd_grupo_estoque, gpc.cd_grupo_estoque)
    left outer join Materia_Prima_Fornecedor_Custo ppc with(nolock) on ppc.cd_produto = p.cd_produto and
                                                                       dt_mat_prima_fornecedor between @dt_inicial and @dt_final
--     left outer join Produto_Preco_Compra ppc with(nolock) on ppc.cd_produto = p.cd_produto and
--                                                              ppc.dt_base_preco between @dt_inicial and @dt_final
  group by 
    fat.Tipo, fat.Cliente, ge.cd_grupo_estoque, ge.nm_grupo_estoque,
    fat.CodCategoria, fat.Categoria, fat.NomeCategoria,
    gp.cd_grupo_produto, gp.nm_grupo_produto,
    p.nm_fantasia_produto, p.cd_mascara_produto,
    p.cd_produto, p.nm_produto, ppc.dt_mat_prima_fornecedor, ppc.vl_mat_prima_fornecedor, 
--    p.cd_produto, p.nm_produto, ppc.dt_base_preco, ppc.vl_produto_preco_compra, 
    pc.vl_custo_produto
  order by 1, 2, 4, 7


end
-------------------------------------------------------------------------------
else if @ic_parametro = 4  -- Devolução dos Materiais por Grupo de Estoque e Categoria
-------------------------------------------------------------------------------
begin

  -- TODOS OS PEDIDOS FATURADOS POR CATEGORIA
  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(ns.ic_smo_nota_saida,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,
    -- CLIENTE, NO CASO DE EXPORTAÇÃO
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,
    nsi.cd_categoria_produto as CodCategoria,
    cp.cd_mascara_categoria as Categoria,
    cp.nm_categoria_produto as NomeCategoria,
    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    sum(nsi.qt_item_nota_saida) as QtdeNFS
  into #DevolvidosMatSec
  from Nota_Saida_Item nsi with(nolock) 
    inner join Nota_Saida ns with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal    
    inner join Categoria_Produto cp with(nolock) on cp.cd_categoria_produto = nsi.cd_categoria_produto
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = nsi.cd_grupo_produto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = gp.cd_grupo_produto
    inner join vw_destinatario_rapida vw with(nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                                         vw.cd_destinatario = ns.cd_cliente
    left outer join Produto p with(nolock) on nsi.cd_produto = p.cd_produto
  where 
    nsi.dt_restricao_item_nota between @dt_inicial and @dt_final and
    ns.cd_status_nota <> 7 and
    op.ic_custo_operacao_fiscal = 'S' and
    isnull(cp.ic_vendas_categoria,'N') = 'S' and
    gpc.ic_custo = 'S' and
    isnull(nsi.qt_devolucao_item_nota,0) <> 0 and

    case when (isnull(p.cd_produto,0) <> 0) then
      isnull(p.ic_producao_produto,'N') 
    else 'S' end = 'S' and

    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(ns.ic_smo_nota_saida,'N') 
        else 'N' end end = isnull(ns.ic_smo_nota_saida,'N')and
  
    -- Filtro para não buscar Grupos de Revenda
    isnull(gp.ic_revenda_grupo_produto,'N') = 'N'

  group by isnull(ns.ic_smo_nota_saida,'N'), isnull(vw.cd_tipo_mercado,1), 
    nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, nsi.cd_categoria_produto,
    cp.cd_mascara_categoria, cp.nm_categoria_produto,
    nsi.nm_fantasia_produto,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end


  -- MATERIAS PRIMAS E PESOS POR PV
  create table #PVMatSecDev (
    PV int,
    ItemPV int,
    CodProduto int,
    QtdeNFS decimal(25,3))

  declare cMatSecDev cursor for
  select PV, ItemPV, QtdeNFS
  from #DevolvidosMatSec order by 1, 2

  open cMatSecDev

  fetch next from cMatSecDev into @PV, @ItemPV, @QtdeNFS

  while @@fetch_status = 0
  begin

    insert into #PVMatSecDev
    select @PV, @ItemPV, cd_produto, (qt_produto * @QtdeNFS)
    from dbo.fn_material_secundario_pedido(@PV, @ItemPV)
    where cd_grupo_estoque = case when @cd_grupo_estoque = 0 
                             then cd_grupo_estoque
                             else @cd_grupo_estoque end 

    fetch next from cMatSecDev into @PV, @ItemPV, @QtdeNFS

  end

  close cMatSecDev
  deallocate cMatSecDev

  select distinct
    fat.Tipo,
    fat.Cliente,
    ge.cd_grupo_estoque as CodGrupoEstoque, 
    ge.nm_grupo_estoque as GrupoEstoque,
    fat.CodCategoria, fat.Categoria, fat.NomeCategoria,
    gp.cd_grupo_produto as CodGrupoProduto, 
    gp.nm_grupo_produto as GrupoProduto,
    p.nm_fantasia_produto as Fantasia,
    p.cd_mascara_produto as Mascara,
    p.nm_produto as Produto,
    sum(pv.QtdeNFS) as QtdeNFS,

    isnull((ppc.vl_mat_prima_fornecedor -
           (ppc.vl_mat_prima_fornecedor *
            dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_mat_prima_fornecedor) / 100)), 0) as CustoUnitario,
--     isnull((ppc.vl_produto_preco_compra - 
--             (ppc.vl_produto_preco_compra * 
--              dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_base_preco) / 100)), 0) as CustoUnitario,
    (sum(pv.QtdeNFS) * isnull((ppc.vl_mat_prima_fornecedor - 
                              (ppc.vl_mat_prima_fornecedor * 
                               dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_mat_prima_fornecedor) / 100)), 0)) as CustoTotal
--     (sum(pv.QtdeNFS) * isnull((ppc.vl_produto_preco_compra - 
--                               (ppc.vl_produto_preco_compra * 
--                                dbo.fn_imposto_produto_cpv(p.cd_produto, ppc.dt_base_preco) / 100)), 0)) as CustoTotal

  from
    #PVMatSecDev pv 
    inner join #DevolvidosMatSec fat on pv.PV = fat.PV and
                                        pv.ItemPV = fat.ItemPV
    inner join Produto p with(nolock) on pv.CodProduto = p.cd_produto
    inner join Produto_Custo pc with(nolock) on p.cd_produto = pc.cd_produto
    left outer join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Grupo_Produto_Custo gpc with(nolock) on p.cd_grupo_produto = gpc.cd_grupo_produto
    left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = isnull(pc.cd_grupo_estoque, gpc.cd_grupo_estoque)
    left outer join Materia_Prima_Fornecedor_Custo ppc with(nolock) on ppc.cd_produto = p.cd_produto and
                                                                       dt_mat_prima_fornecedor between @dt_inicial and @dt_final
--     left outer join Produto_Preco_Compra ppc with(nolock) on ppc.cd_produto = p.cd_produto and
--                                                              ppc.dt_base_preco between @dt_inicial and @dt_final
  group by 
    fat.Tipo, fat.Cliente, ge.cd_grupo_estoque, ge.nm_grupo_estoque,
    fat.CodCategoria, fat.Categoria, fat.NomeCategoria,
    gp.cd_grupo_produto, gp.nm_grupo_produto,
    p.nm_fantasia_produto, p.cd_mascara_produto,
    p.cd_produto, p.nm_produto, ppc.dt_mat_prima_fornecedor, ppc.vl_mat_prima_fornecedor, 
--    p.cd_produto, p.nm_produto, ppc.dt_base_preco, ppc.vl_produto_preco_compra, 
    pc.vl_custo_produto
  order by 1, 2, 4, 7

end
-------------------------------------------------------------------------------
else if @ic_parametro = 5  -- Consulta dos Produtos Comprados após Faturamento
-------------------------------------------------------------------------------
begin


  select distinct ns.cd_nota_saida as NFS, 
    ns.ic_smo_nota_saida as SMO, 
    ns.cd_tipo_destinatario as TipoDestinatario, 
    ns.cd_cliente as Destinatario,
    nsi.cd_pedido_venda as PV,
    nsi.cd_item_pedido_venda as ItemPV,
    nsi.cd_categoria_produto as CodCategoria,
    nsi.cd_operacao_fiscal as CFOP,
    nsi.nm_produto_item_nota as Produto,
    nsi.nm_fantasia_produto as Fantasia,
    nsi.cd_produto as CodProduto,
    nsi.cd_grupo_produto as CodGrupoProduto,    
    sum(nsi.qt_item_nota_saida) as QtdeNFS,

    -- FATURAMENTO NORMAL
    sum(case when (isnull(op.ic_zfm_operacao_fiscal,'N') = 'N') then 
          cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
          cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
        else 
          -- FATURAMENTO PARA ZONA FRANCA DE MANAUS - (INDUSTRIALIZACAO)
          case when (ns.cd_destinacao_produto = 1) then 
            cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) - 
             (cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) * 
              cast(str((isnull(nsi.pc_reducao_icms,0)/100),25,4) as decimal(25,4))) * 
              cast(str((isnull(nsi.pc_icms_desc_item,0)/100),25,4) as decimal(25,4)) + 
            cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
          else -- FATURAMENTO PARA ZONA FRANCA DE MANAUS - (USO PRÓPRIO)
            cast(str(isnull(nsi.vl_total_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_frete_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_seguro_item,0),25,2) as decimal(25,2)) + 
            cast(str(isnull(nsi.vl_desp_acess_item,0),25,2) as decimal(25,2))
          end
        end) as Total

  into #NFPosFaturamento
  from (select distinct nsi.cd_nota_saida, nsi.cd_item_nota_saida
        from Pedido_Compra_Item pci with(nolock) 
          inner join Nota_Entrada_Item nei with(nolock) on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                           nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
          inner join Pedido_Venda_Item pvi with(nolock) on pci.cd_pedido_venda = pvi.cd_pedido_venda and
                                                           pci.cd_item_pedido_venda = pvi.cd_item_pedido_venda
          inner join Nota_Saida_Item nsi with(nolock) on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                                         nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
          inner join Nota_Saida ns with(nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
        where nei.dt_item_receb_nota_entrad > nsi.dt_nota_saida and
          isnull(nei.cd_produto,0) <> 53786 and pvi.dt_cancelamento_item is null and
          nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final and
          ns.cd_status_nota <> 7) aux
    inner join Nota_Saida_Item nsi on nsi.cd_nota_saida = aux.cd_nota_saida and
                                      nsi.cd_item_nota_saida = aux.cd_item_nota_saida
    inner join Nota_Saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
    inner join Operacao_Fiscal op with(nolock) on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal    
  group by ns.cd_nota_saida, ns.ic_smo_nota_saida, ns.cd_tipo_destinatario, 
    ns.cd_cliente, nsi.cd_pedido_venda, nsi.cd_item_pedido_venda,
    nsi.cd_categoria_produto, nsi.cd_operacao_fiscal,
    nsi.nm_produto_item_nota, nsi.cd_produto, nsi.nm_fantasia_produto, nsi.cd_grupo_produto

  select
    case when (@ic_tipo_mercado = 'T') then 
      case when isnull(nsi.SMO,'N') = 'S' then 'S' else
        case when isnull(vw.cd_tipo_mercado,1) = 1 then 'I' else 'E' end
      end
    else @ic_tipo_mercado end as Tipo,
    -- CLIENTE, NO CASO DE EXPORTAÇÃO
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia
    else
      'Todos Clientes'
    end as Cliente,
    nsi.PV,
    nsi.ItemPV,
    nsi.CodCategoria,
    cp.cd_mascara_categoria as Categoria,
    cp.nm_categoria_produto as NomeCategoria,
    case when (isnull(gp.ic_especial_grupo_produto,'N') = 'S') then
      'PVE '+cast(nsi.PV as varchar(6))+'/'+cast(nsi.ItemPV as varchar(3))
    else
      nsi.Fantasia
    end as Fantasia,
    nsi.Produto,
    sum(nsi.QtdeNFS) as QtdeNFS,
    sum(nsi.Total) as Total, 
    cast(0 as float) as CodMP1,
    cast(0 as float) as CodMP2,
    cast(0 as float) as CodMP3,
    cast(0 as float) as CodMP4,
    cast(0 as float) as CodMP5,
    cast(0 as float) as CodMP6,
    cast(0 as float) as CodMP7,
    cast(0 as float) as CodMP8,
    cast(0 as float) as CodMP9,
    cast(0 as float) as CodMP10,
    cast(0 as float) as CodMP11,
    cast(0 as float) as CodMP12,
    cast(0 as float) as CodMP13,
    cast(0 as float) as CodMP14,
    cast(0 as float) as CodMP15,
    cast(0 as float) as CodMP16,
    cast(0 as float) as CodMP17,
    cast(0 as float) as CodMP18
  into #CompradoApos
  from (select * from #NFPosFaturamento) nsi
    inner join Operacao_Fiscal op with(nolock) on nsi.CFOP = op.cd_operacao_fiscal    
    inner join Categoria_Produto cp with(nolock) on cp.cd_categoria_produto = nsi.CodCategoria
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = nsi.CodGrupoProduto
    inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = gp.cd_grupo_produto
    inner join vw_destinatario_rapida vw on nsi.TipoDestinatario = vw.cd_tipo_destinatario and
                                            nsi.Destinatario = vw.cd_destinatario
  where 
    cp.cd_categoria_produto = case when isnull(@cd_categoria_produto,0) = 0 
                              then cp.cd_categoria_produto
                              else isnull(@cd_categoria_produto,0) end and
    op.ic_custo_operacao_fiscal = 'S' and
    isnull(cp.ic_vendas_categoria,'N') = 'S' and
    gpc.ic_custo = 'S' and
  
    -- Filtro por Tipo de Mercado (Interno ou Externo)
    case when (@ic_tipo_mercado = 'I') then 1 else
      case when (@ic_tipo_mercado = 'E') then 2 else
        isnull(vw.cd_tipo_mercado,0) end end = isnull(vw.cd_tipo_mercado,0) and
  
    -- Filtro para não buscar Grupos de Revenda
    isnull(gp.ic_revenda_grupo_produto,'N') = 'N' and

    -- Filtro por SMO (Sim/Não)
    case when (@ic_tipo_mercado = 'S') then 'S' else
      case when (@ic_tipo_mercado = 'T') then isnull(nsi.SMO,'N') 
        else 'N' end end = isnull(nsi.SMO,'N') 

  group by isnull(gp.ic_especial_grupo_produto,'N'), 
    isnull(nsi.SMO,'N'), isnull(vw.cd_tipo_mercado,1), 
    nsi.PV, nsi.ItemPV, nsi.CodCategoria,
    cp.cd_mascara_categoria, cp.nm_categoria_produto,
    nsi.Fantasia, nsi.Produto, nsi.Fantasia,
    case when isnull(vw.cd_tipo_mercado,1) = 2 then 
      vw.nm_fantasia else 'Todos Clientes' end

  order by CodCategoria, Fantasia

  -- MATERIAS PRIMAS E PESOS POR PV
  create table #PVMPApos (
    PV int,
    ItemPV int,
    MP int null,
    PesoBruto float null)

  declare cMP cursor for
  select PV, ItemPV, QtdeNFS from #CompradoApos order by 1, 2

  open cMP

  fetch next from cMP into @PV, @ItemPV, @QtdeNFS

  while @@fetch_status = 0
  begin

    insert into #PVMPApos                                     -- Não multiplicar pela Quantidade da NFS quando Pós Faturamento
    select @PV, @ItemPV, cd_materia_prima, sum(qt_peso_bruto) -- * case when ic_ficha_medida = 'S' then 1 else @QtdeNFS end)
    from dbo.fn_materia_prima_pedido(@PV, @ItemPV, 'S', @dt_inicial, @dt_final)
    where isnull(qt_peso_bruto,0) <> 0 and
      case when @ic_estoque = 'T' then ic_arvore_produto
      else @ic_estoque end = ic_arvore_produto    
    group by cd_materia_prima

    fetch next from cMP into @PV, @ItemPV, @QtdeNFS

  end

  close cMP
  deallocate cMP

  -- COLUNAS DA CONSULTA
  select identity(int, 1, 1) as ID, isnull(MP,0) as MP
  into #ColunaApos
  from #PVMPApos
  where (isnull(MP,0) <> 0)
  group by isnull(MP,0)  
  order by isnull(MP,0)

  if (@ic_id_coluna = 'S')
  begin

    select col.ID, isnull(mp.nm_fantasia_mat_prima,'INDEFINIDA') as MP
    from #ColunaApos col 
      left outer join Materia_Prima mp with(nolock) on col.MP = mp.cd_mat_prima
    order by col.ID

  end
  else
  begin

    update #CompradoApos
    set CodMP1 = isnull(pvmp.PesoBruto,0)
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 1 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP2 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 2 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP3 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 3 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP4 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 4 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP5 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 5 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP6 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 6 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP7 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 7 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP8 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 8 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP9 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                               pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 9 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP10 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 10 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP11 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 11 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP12 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 12 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP13 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 13 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP14 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 14 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP15 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 15 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP16 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 16 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP17 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 17 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    update #CompradoApos
    set CodMP18 = pvmp.PesoBruto 
    from #CompradoApos fat
      inner join #PVMPApos pvmp on pvmp.PV = fat.PV and
                                   pvmp.ItemPV = fat.ItemPV
      inner join #ColunaApos col on pvmp.MP = col.MP
    where col.ID = 18 and
      (isnull(pvmp.PesoBruto,0) <> 0)

    select Tipo, Cliente, CodCategoria,
      Categoria, NomeCategoria, Fantasia, Produto, sum(QtdeNFS) as QtdeNFS, sum(Total) as Total,   
      sum(CodMP1) as CodMP1, sum(CodMP2) as CodMP2, sum(CodMP3) as CodMP3, 
      sum(CodMP4) as CodMP4, sum(CodMP5) as CodMP5, sum(CodMP6) as CodMP6,
      sum(CodMP7) as CodMP7, sum(CodMP8) as CodMP8, sum(CodMP9) as CodMP9, 
      sum(CodMP10) as CodMP10, sum(CodMP11) as CodMP11, sum(CodMP12) as CodMP12, 
      sum(CodMP13) as CodMP13, sum(CodMP14) as CodMP14, sum(CodMP15) as CodMP15, 
      sum(CodMP16) as CodMP16, sum(CodMP17) as CodMP17, sum(CodMP18) as CodMP18, 
      sum(CodMP1 + CodMP2 + CodMP3 + CodMP4 + CodMP5+ CodMP6 + CodMP7 +
          CodMP8 + CodMP9 + CodMP10 + CodMP11 + CodMP12 + CodMP13 + CodMP14 + 
          CodMP15+ CodMP16 + CodMP17 + CodMP18) as PesoTotal
    from #CompradoApos
    group by Tipo, Cliente, CodCategoria, Categoria, NomeCategoria, Fantasia, Produto
    order by Tïpo, Cliente, Categoria, Fantasia

  end

end 


