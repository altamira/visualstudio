
CREATE PROCEDURE pr_compra_materia_prima_periodo

---------------------------------------------------
--pr_compra_materia_prima_periodo
---------------------------------------------------
--GBS - Global Business Solution               2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s): Daniel Carrasco 
--Banco de Dados: EGISSQL
--Objetivo: Consultar Compras de Matéria Prima Analítico / Sintético
--Data       : 01/10/2004 
--             15/03/2005 - Ajustes Gerais - Daniel C. Neto.
--             01.08.2005 - Revisão Geral - Carlos Fernandes
--             19/09/2005 - Ajustes na Listagem de Compras de Matéria-Prima - ELIAS
--             20/09/2005 - Desenvolvimento da Listagem de Roscas (Específico para a Polimold) - ELIAS
--             21/09/2005 - Desenvolvimento da Listagem de Devolução de Matéria-Prima - ELIAS
--             28/09/2005 - Ajustes no Relatório de Compras de Matéria-Prima - ELIAS
--             29/09/2005 - Ajustes no Relatório de Roscas - ELIAS
--             17/10/2005 - Acerto para aparecer sempre PV <NumPv) quando Especial - ELIAS
--             20/10/2005 - Ajuste para listar NFE de Importação, mesmo sem Vlr. Comercial - ELIAS
--             07/11/2005 - Passa a buscar dados do PEPS para identificar se Especial ou Padrão e
--                          o Valor de Custo. - ELIAS
--             08/11/2005 - Ajuste para não retornar Movimentação de Terceiros - ELIAS
--             20/02/2006 - Ajuste para buscar Rosca da NFE caso não tenha sido informado no PC - ELIAS
--                          Passa a utilizar a fase no Tipo da Requisição para indicar que é MP - ELIAS
--             08/03/2006 - Ajuste na Listagem de Devoluções para cálculo correto do Unitário e Total - ELIAS
--             06/04/2006 - Acerto para buscar o Produto que baixa em outro estoque - ELIAS
--             10/05/2006 - Ajuste no Relatório de Compras para buscar o PV Origem quando um PV foi
--                          cancelado e reposto por outro. - ELIAS
--             11/09/2006 - Ajuste para filtrar como Matéria-Prima também os Produtos configurados
--                          conforme flag no Produto Custo. - ELIAS
----------------------------------------------------------------------------------
@ic_parametro     integer,
@dt_inicial       datetime,
@dt_final         datetime,
@cd_materia_prima integer,
@ic_sub_total     char(1) = 'N'

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Tipo de Consulta Analítica - TODOS OS ITENS
-------------------------------------------------------------------------------
begin

  select --distinct
    -- case when (isnull(pci.cd_produto,0) <> 0) then 'P' else 'E' end as Tipo,
    -- case when (isnull(pci.cd_produto,0) <> 0) or (isnull(pci.cd_pedido_venda,0) = 0) then 'P' else 'E' end as Tipo,
    case when (isnull(peps.cd_documento_entrada_peps,'') = '') then 'E' else 'P' end as Tipo,
    ne.dt_receb_nota_entrada                              as Data,
    vw.nm_fantasia                                        as Fornecedor,
    ne.cd_nota_entrada                                    as NE,
    nei.cd_item_nota_entrada                              as ItemNE,
    case when (isnull(pci.cd_produto,0) <> 0) or (isnull(pci.cd_pedido_venda,0) = 0) then    
      case when (isnull(pci.cd_produto,0) > 0) then
        case when (isnull(pci.nm_placa,'') <> '') then pci.nm_placa else p.nm_fantasia_produto end
      else 
        case when (isnull(pci.cd_produto,0) = 0) then
          case when (isnull(pci.nm_placa,'') <> '') then pci.nm_placa else p.nm_fantasia_produto end 
        else
          case when (isnull(pci.cd_pedido_venda,0) = 0) then p.nm_fantasia_produto else        
            'PV '+cast(pci.cd_pedido_venda as varchar) end  
        end
      end
    else
      'PV '+cast(pci.cd_pedido_venda as varchar)
    end as Placa, 
    mp.nm_fantasia_mat_prima                              as Aco,
    nei.nm_produto_nota_entrada                           as Descricao, 
    nei.qt_item_nota_entrada                              as Qtde,
    isnull(nei.qt_pesbru_nota_entrada,0)                  as PesoBruto,      
    isnull(nei.qt_pesliq_nota_entrada,0)                  AS PesoLiquido,

    case when (isnull(peps.cd_documento_entrada_peps,'') = '') then 
      -- SE IMPORTAÇÃO
      case when (op.ic_importacao_op_fiscal = 'S') then
        cast(cast(isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2)) * 
              (case when (isnull(nei.qt_pesbru_nota_entrada,0) = 0) 
               then 1 
             else 
               cast(nei.qt_pesbru_nota_entrada as decimal(25,2)) 
             end) as decimal(25,2)) 
      else
        cast((cast(isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2)) * 
              cast(((100-isnull(nei.pc_icms_nota_entrada,0))/100) as decimal(25,2))) /
               (case when (isnull(nei.qt_pesbru_nota_entrada,0) = 0) then 1 
                else cast(nei.qt_pesbru_nota_entrada as decimal(25,2)) end) as decimal(25,2)) 
      end
    else
      cast(peps.vl_custo_total_peps /
           (case when (isnull(nei.qt_pesbru_nota_entrada,0) = 0) then 1 
            else cast(nei.qt_pesbru_nota_entrada as decimal(25,2)) end) as decimal(25,2))
    end as VlItem,

    isnull(nei.vl_total_nota_entr_item,0)                 AS VlTotal,
    pci.cd_pedido_venda                                   as PV,
    tp.sg_tipo_pedido                                     as TipoPV,

    case when (isnull(peps.cd_documento_entrada_peps,'') = '') then   
      -- SE IMPORTAÇÃO
      case when (op.ic_importacao_op_fiscal = 'S') then
        cast(isnull(vl_total_nota_entr_item,0) as decimal(25,2))
      else
        cast(cast(isnull(vl_total_nota_entr_item,0) as decimal(25,2)) *
             cast(((100-nei.pc_icms_nota_entrada)/100) as decimal(25,2)) as decimal(25,2))
      end                                                   
    else
      peps.vl_custo_total_peps 
    end as CustoTotal,

    pci.cd_pedido_compra                                  as PC,
    pci.cd_requisicao_compra                              as RC,
    fp.nm_fase_produto                                    as Fase
  from Nota_Entrada ne 
    left outer join vw_Destinatario_Rapida vw on vw.cd_destinatario = ne.cd_fornecedor and
                                                 vw.cd_tipo_destinatario = ne.cd_tipo_destinatario 
    left outer join Nota_Entrada_Item nei on ne.cd_nota_entrada = nei.cd_nota_entrada and
                                             ne.cd_fornecedor = nei.cd_fornecedor and
                                             ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal	and
                                             ne.cd_operacao_fiscal = nei.cd_operacao_fiscal 
    left outer join Produto p on p.cd_produto = nei.cd_produto 
    left outer join Nota_Entrada_Peps peps on peps.cd_documento_entrada_peps = cast(nei.cd_nota_entrada as varchar) and
                                              peps.cd_item_documento_entrada = nei.cd_item_nota_entrada and
                                              peps.cd_fornecedor = nei.cd_fornecedor and
                                              peps.cd_produto = isnull(p.cd_produto_baixa_estoque, nei.cd_produto) 
    left outer join Pedido_Compra_Item pci on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                              nei.cd_item_pedido_compra = pci.cd_item_pedido_compra 
    left outer join Requisicao_Compra rc on pci.cd_requisicao_compra = rc.cd_requisicao_compra 
    left outer join Tipo_Requisicao tr on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao 
    left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto and
                                        pc.ic_mat_prima_produto = 'S'
    left outer join Materia_Prima mp on (case when (isnull(pci.cd_materia_prima,0) = 0) then
                                           pc.cd_mat_prima
                                         else pci.cd_materia_prima
                                         end) = mp.cd_mat_prima 
    left outer join Pedido_Venda pv on pv.cd_pedido_venda = pci.cd_pedido_venda 
    left outer join Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido 
    left outer join Operacao_Fiscal op on op.cd_operacao_fiscal = ne.cd_operacao_fiscal 
    left outer join Fase_Produto fp on peps.cd_fase_produto = fp.cd_fase_produto
  where 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    -- NÃO ENTRAR ROSCAS
    (isnull(pci.cd_produto, isnull(nei.cd_produto,0)) <> 53786) and
    -- SOMENTE MATÉRIA-PRIMA
    mp.cd_mat_prima = (case when isnull(@cd_materia_prima,0) = 0 then isnull(mp.cd_mat_prima,0)
                       else @cd_materia_prima end) and
    -- Não trazer quando Entrada de Terceiros
    (isnull(ic_terceiro_op_fiscal,'N') = 'N') and

    -- Somente de Compra ou Importação
    ((isnull(op.ic_importacao_op_fiscal,'N') = 'S') or  
    -- Somente Fase 1 - Bruto 
    (op.ic_comercial_operacao = 'S')) and 
    -- Se Importação, qualquer Fase ou
    ((isnull(op.ic_importacao_op_fiscal,'N') = 'S') or  
    -- Somente Fase 1 - Bruto 
    (isnull(peps.cd_fase_produto, isnull(tr.cd_fase_produto, 1)) = 1)) and 

    -- Placa não pode ser vazia
    case when (isnull(pci.cd_produto,0) <> 0) or (isnull(pci.cd_pedido_venda,0) = 0) then    
      case when (isnull(pci.cd_produto,0) > 0) then
        case when (isnull(pci.nm_placa,'') <> '') then pci.nm_placa else p.nm_fantasia_produto end
      else 
        case when (isnull(pci.cd_produto,0) = 0) then
          case when (isnull(pci.nm_placa,'') <> '') then pci.nm_placa else p.nm_fantasia_produto end 
        else
          case when (isnull(pci.cd_pedido_venda,0) = 0) then p.nm_fantasia_produto else        
            'PV '+cast(pci.cd_pedido_venda as varchar) end  
        end
      end
    else
      'PV '+cast(pci.cd_pedido_venda as varchar)
    end is not null
  order by 
    case when (isnull(peps.cd_documento_entrada_peps,'') = '') then 'E' else 'P' end desc,
    mp.nm_fantasia_mat_prima,
    ne.dt_receb_nota_entrada,
    NE

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Tipo de Consulta Sintética
-------------------------------------------------------------------------------
begin

  SELECT 
    mp.nm_fantasia_mat_prima  as nm_mat_prima, 
    case when (isnull(pci.cd_produto,0) <> 0) then 'P' else 'E' end as ic_tipo_mat_prima, 
    sum(nei.qt_pesbru_nota_entrada) as qt_item_nota_entrada, 


    case when (isnull(tp.ic_pedido_mat_prima,'N') = 'N') then
      sum(cast(cast(isnull(nei.vl_item_nota_entrada,0) as decimal(25,2)) *
           cast(((100-nei.pc_icms_nota_entrada)/100) as decimal(25,2)) as decimal(25,2)) *
           cast(isnull(nei.qt_pesbru_nota_entrada,0) as decimal(25,4)))      
    else
      sum(cast(cast(isnull(vl_total_nota_entr_item,0) as decimal(25,2)) *
           cast(((100-nei.pc_icms_nota_entrada)/100) as decimal(25,2)) as decimal(25,2)))
    end                                                   as vl_item_nota_entrada

  INTO #TEMP

  FROM    
    Nota_Entrada ne	LEFT OUTER JOIN
    Nota_Entrada_Item nei ON ne.cd_nota_entrada = nei.cd_nota_entrada and
                             ne.cd_fornecedor = nei.cd_fornecedor and
                             ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal	LEFT OUTER JOIN
    Nota_Entrada_Peps peps on peps.cd_documento_entrada_peps = cast(nei.cd_nota_entrada as varchar) and
                              peps.cd_item_documento_entrada = nei.cd_item_nota_entrada and
                              peps.cd_fornecedor = nei.cd_fornecedor and
                              peps.cd_produto = nei.cd_produto LEFT OUTER JOIN 
    Pedido_Compra_Item pci  ON nei.cd_pedido_compra = pci.cd_pedido_compra and
                               nei.cd_item_pedido_compra = pci.cd_item_pedido_compra	LEFT OUTER JOIN
    Requisicao_Compra rc on pci.cd_requisicao_compra = rc.cd_requisicao_compra LEFT OUTER JOIN
    Tipo_Requisicao tr on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao LEFT OUTER JOIN
    produto_Custo pc on pc.cd_produto = nei.cd_produto and
                                        pc.ic_mat_prima_produto = 'S' left outer join
    Materia_Prima mp ON (case when (isnull(pci.cd_materia_prima,0) = 0) then
                           pc.cd_mat_prima
                         else pci.cd_materia_prima
                         end) = mp.cd_mat_prima left outer join
    Pedido_Venda pv  on pv.cd_pedido_venda = pci.cd_pedido_venda LEFT OUTER JOIN
    Tipo_Pedido tp   on tp.cd_tipo_pedido = pv.cd_tipo_pedido left outer join
    Operacao_Fiscal op on op.cd_operacao_fiscal = ne.cd_operacao_fiscal                        
  WHERE 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and

    (isnull(pci.cd_produto, isnull(nei.cd_produto,0)) <> 53786) and  -- NÃO ENTRA ROSCA

    -- Se Importação, qualquer Fase ou
    ((isnull(op.ic_importacao_op_fiscal,'N') = 'S') or  
    -- Somente Fase 1 - Bruto 
    (isnull(peps.cd_fase_produto, isnull(tr.cd_fase_produto, 1)) = 1)) and  

    mp.cd_mat_prima = (case when isnull(@cd_materia_prima,0) = 0 then mp.cd_mat_prima
                       else @cd_materia_prima end)        
  group by 
    case when (isnull(pci.cd_produto,0) <> 0) then 'P' else 'E' end,
    isnull(tp.ic_pedido_mat_prima,'N'),
    isnull(op.ic_importacao_op_fiscal,'N'),
    isnull(peps.cd_fase_produto, isnull(tr.cd_fase_produto, 1)),
    mp.nm_fantasia_mat_prima

  select identity(int,1,1) as cd_item, nm_mat_prima, ic_tipo_mat_prima, sum(qt_item_nota_entrada) as qt_item_nota_entrada,
    sum(vl_item_nota_entrada) as vl_item_nota_entrada, cast(null as float) as prcnt
  into #TEMP_COMPRA_MATERIA_PRIMA_PERIODO
  from #TEMP
  group by 
    nm_mat_prima, ic_tipo_mat_prima
  ORDER BY 
    ic_tipo_mat_prima desc,
    nm_mat_prima


  UPDATE #TEMP_COMPRA_MATERIA_PRIMA_PERIODO
  SET vl_item_nota_entrada = 0 
  WHERE vl_item_nota_entrada is null

  UPDATE #TEMP_COMPRA_MATERIA_PRIMA_PERIODO
  SET prcnt = (vl_item_nota_entrada * 100) / 
                (select sum(vl_item_nota_entrada) from 
                                                    #TEMP_COMPRA_MATERIA_PRIMA_PERIODO )

  if @ic_sub_total = 'S'
  begin
    declare @qt_total_item float,
            @vl_total_item float,
            @cd_item_max   int

    set @qt_total_item =    ( select  sum(IsNull(qt_item_nota_entrada,0))
                              from #TEMP_COMPRA_MATERIA_PRIMA_PERIODO )
    set @vl_total_item =    ( select  sum(IsNull(vl_item_nota_entrada,0))
                              from #TEMP_COMPRA_MATERIA_PRIMA_PERIODO )
    set @cd_item_max =    IsNull(( select  max(cd_item)
                                   from #TEMP_COMPRA_MATERIA_PRIMA_PERIODO ),0) + 1

    set IDENTITY_INSERT #TEMP_COMPRA_MATERIA_PRIMA_PERIODO ON

    insert into #TEMP_COMPRA_MATERIA_PRIMA_PERIODO
    ( cd_item, nm_mat_prima, ic_tipo_mat_prima, qt_item_nota_entrada, vl_item_nota_entrada, prcnt)
    values
    (@cd_item_max + 1,
     'TOTAL:',
     '',
     @qt_total_item,
     @vl_total_item,
     100 )
  end

  SELECT * FROM #TEMP_COMPRA_MATERIA_PRIMA_PERIODO order by cd_item

end
-------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Somente Itens de Produto = ROSCAS
-------------------------------------------------------------------------------
begin

  SELECT -- DISTINCT
    ne.dt_receb_nota_entrada                              as Data,
    f.nm_fantasia_fornecedor                              as Fornecedor,
    ne.cd_nota_entrada                                    as NE,

    case when (isnull(nei.qt_pesbru_nota_entrada,0) = 0)
      then nei.qt_item_nota_entrada
      else nei.qt_pesbru_nota_entrada end                 as Qtde,

    (nei.vl_item_nota_entrada *
      ((100-nei.pc_icms_nota_entrada)/100))               as VlItem,
  
    (nei.vl_item_nota_entrada *
      ((100-nei.pc_icms_nota_entrada)/100) *
      case when (isnull(nei.qt_pesbru_nota_entrada,0) = 0)
      then nei.qt_item_nota_entrada
      else nei.qt_pesbru_nota_entrada end)                as CustoTotal

  INTO #Roscas
  FROM    
    Nota_Entrada ne	LEFT OUTER JOIN
    Fornecedor f ON	ne.cd_fornecedor = f.cd_fornecedor LEFT OUTER JOIN
    Nota_Entrada_Item nei ON ne.cd_nota_entrada = nei.cd_nota_entrada and
                             ne.cd_fornecedor = nei.cd_fornecedor and
                             ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                             ne.cd_operacao_fiscal = nei.cd_operacao_fiscal LEFT OUTER JOIN
    Pedido_Compra_Item pci  ON nei.cd_pedido_compra = pci.cd_pedido_compra and
                               nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
  WHERE 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    isnull(pci.cd_produto, nei.cd_produto) = 53786 -- SOMENTE ROSCAS
   ORDER BY 
     ne.dt_receb_nota_entrada,
     NE

  select Data, Fornecedor, NE, avg(VlItem) as VlItem, sum(Qtde) as Qtde, sum(CustoTotal) as CustoTotal
  from #Roscas 
  group by Data, Fornecedor, NE

end
-------------------------------------------------------------------------------
else if @ic_parametro = 4    -- Tipo de Consulta Analítica - DEVOLUÇÕES
-------------------------------------------------------------------------------
begin

select 
  ns.dt_nota_saida as Data,
  vw.nm_fantasia as Destinatario,
  ns.cd_nota_saida as NFS,
  nsi.ds_item_nota_saida as Produto,
  nsi.qt_item_nota_saida as Qtde,
  nsi.qt_bruto_item_nota_saida as PesoBruto,

  cast(cast(isnull(nsi.vl_unitario_item_nota,0) as decimal(25,2)) * 
       ((100-isnull(nsi.pc_icms,0))/100) as decimal(25,2)) as VlItem,

  case when (um.ic_fator_conversao = 'P') or (isnull(nsi.qt_bruto_item_nota_saida,0) = 0) then 
    cast(cast(isnull(nsi.vl_unitario_item_nota,0) as decimal(25,2)) *
         ((100-nsi.pc_icms)/100) *
         cast(isnull(nsi.qt_item_nota_saida,0) as decimal(25,2)) as decimal(25,4)) 
  else
    cast(cast(isnull(nsi.vl_unitario_item_nota,0) as decimal(25,2)) *
         ((100-nsi.pc_icms)/100) *
         isnull(nsi.qt_bruto_item_nota_saida,0) as decimal(25,4)) 
  end as CustoTotal     


from 
  Nota_Saida ns inner join 
  Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida inner join
  Operacao_Fiscal op on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal inner join
  vw_Destinatario_Rapida vw on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                         vw.cd_destinatario = ns.cd_cliente inner join
  Unidade_Medida um on nsi.cd_unidade_medida = um.cd_unidade_medida
where
  isnull(op.ic_devmp_operacao_fiscal,'N') = 'S' and
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.dt_cancel_nota_saida is null 
order by 
  ns.cd_nota_saida

end

