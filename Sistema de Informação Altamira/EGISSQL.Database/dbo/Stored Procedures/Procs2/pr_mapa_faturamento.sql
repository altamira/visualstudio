
CREATE PROCEDURE pr_mapa_faturamento

  @cd_parametro                 int,      -- Parâmetro de montagem das consultas
  @dt_faturamento_diario    	datetime, -- Data da Venda Diária
  @dt_inicial         		datetime, -- Data Inicial
  @dt_final           		datetime  -- Data Final

as

if @cd_parametro = 1 -- Padrão Egis 
begin

select

  substring(cast((gc.cd_grupo_categoria+100000000)as char(10)),2,8)+' - '+gc.nm_grupo_categoria as nm_grupo_categoria,

  cp.cd_mascara_categoria,
  cp.sg_categoria_produto,
  cp.nm_categoria_produto,
  
  --Consultando faturamento do dia em quantidade
  isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where 
    isnull(ofi.ic_analise_op_fiscal,'N')='S' and
    nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  = @dt_faturamento_diario and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) as qt_faturamento_dia,

  --Consultando faturamento do dia em valor
  isnull((select sum(vl_total_item)
   from Nota_Saida ns with (nolock) 
                      left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
                      left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal


   where
    isnull(ofi.ic_analise_op_fiscal,'N')='S' and
    nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  = @dt_faturamento_diario and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) as vl_faturamento_dia,

  --Consultando faturamento bruto em quantidade no período informado
  isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida       = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) as qt_faturamento_bruto,

  --Consultando faturamento bruto em valor no período informado
  isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida       = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) as vl_faturamento_bruto,

  --Consultando devoluções em quantidade no período informado
  isnull((select sum(nsi.qt_devolucao_item_nota)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0) as qt_devolvido_periodo,

  --Consultando devoluções em valor no período informado
  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where 
    isnull(ofi.ic_analise_op_fiscal,'N')='S' and
    nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0) as vl_devolvido_periodo,

  --Consultando devoluções do mês anterior ao período informado em quantidade

  (select 
   case when month(@dt_inicial) = 1 then
     isnull((select sum(nsi.qt_devolucao_item_nota)
     from Nota_Saida ns with (nolock)
     left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
     left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
     where 
       isnull(ofi.ic_analise_op_fiscal,'N')='S' and
       nsi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = 12 and  year(ns.dt_nota_saida) = year(@dt_inicial) -1 and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
   else
     isnull((select sum(nsi.qt_devolucao_item_nota)
     from Nota_Saida ns with (nolock) 
     left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
     left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

     where
       isnull(ofi.ic_analise_op_fiscal,'N')='S' and
       nsi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = month(@dt_inicial) - 1 and  year(ns.dt_nota_saida) = year(@dt_inicial) and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)   
   end)                                         as qt_devolvido_mes_anterior,


  --Consultando devoluções do mês anterior ao período informado em valor

  (select 
   case when month(@dt_inicial) = 1 then
     isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
     from Nota_Saida ns with (nolock)
     left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
     left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
 
     where 
       isnull(ofi.ic_analise_op_fiscal,'N')='S' and
       nsi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = 12 and  year(ns.dt_nota_saida) = year(@dt_inicial) -1 and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
   else
     isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
     from Nota_Saida ns with (nolock) 
     left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
     left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

     where 
       isnull(ofi.ic_analise_op_fiscal,'N')='S' and
       nsi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = month(@dt_inicial) - 1 and  year(ns.dt_nota_saida) = year(@dt_inicial) and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
   end)                                        as vl_devolvido_mes_anterior,

  --Consultando faturamento líquido no período em quantidade (qt_faturamento_bruto - qt_devolvido_periodo)

  (isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where 
    isnull(ofi.ic_analise_op_fiscal,'N')='S' and
    nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -
  isnull((select sum(nsi.qt_devolucao_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)) as qt_faturamento_liquido,

  --Consultando faturamento líquido no período em valor (vl_faturamento_bruto - vl_devolvido_periodo)
  (isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        inner join operacao_fiscal ope on ns.cd_operacao_fiscal = ope.cd_operacao_fiscal  
   where 
         isnull(ope.ic_analise_op_fiscal,'N')='S' and
         nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and
         ope.ic_comercial_operacao = 'S'),0) -
  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock) left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        inner join operacao_fiscal ope on ns.cd_operacao_fiscal = ope.cd_operacao_fiscal  
   where
        isnull(ope.ic_analise_op_fiscal,'N')='S' and
        nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and 
        ic_status_item_nota_saida in ('P', 'D') and ope.ic_comercial_operacao = 'S'),0)) as vl_faturamento_liquido,

  --Consultando percentual de faturamento líquido no período da categoria corrente

  ((isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -
  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)) * 100) / 
   case when   
  ((isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
--   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and nsi.cd_categoria_produto in (select cd_categoria_produto from Categoria_Produto)),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
--   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D') and nsi.cd_categoria_produto in (select cd_categoria_produto from Categoria_Produto)),0))) = 0 then 1 
  else   
  ((isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
--   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and nsi.cd_categoria_produto in (select cd_categoria_produto from Categoria_Produto)),0) -
  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
--   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D') and nsi.cd_categoria_produto in (select cd_categoria_produto from Categoria_Produto)),0))) end as pc_faturamento_liquido,

  --Buscando a Meta de Faturamento em quantidade do Período na categoria
   isnull((select sum(qt_fat_meta_categoria)
    from Meta_Categoria_Produto
    where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),0) as qt_meta_faturamento,

  --Buscando a Meta de Faturamento em valor do Período na categoria
   isnull((select sum( isnull(vl_fat_meta_categoria,0) )
    from Meta_Categoria_Produto
    where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),0) as vl_meta_faturamento,

  --Calculando o percentual atingido da meta em quantidade (qt_faturamento_liquido / qt_meta_faturamento * 100)
  ((isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal
   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)) /

  isnull((select sum( isnull(qt_fat_meta_categoria,0) )
   from Meta_Categoria_Produto
   where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),1) * 100) as pc_qtd_atingido_meta,

  --Calculando o percentual atingido da meta em valor (vl_faturamento_liquido / vl_meta_faturamento * 100)
  ((isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)) /

   isnull((select sum(isnull(vl_fat_meta_categoria,0) )
    from Meta_Categoria_Produto
    where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),1) * 100) as pc_vlr_atingido_meta,

  --Calculando média diária em quantidade em função dos dias transcorridos (qt_faturamento_liquido / Quantidade de dias úteis)
  ((isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)) /
   (select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S')) as qt_media_diaria,

  --Calculando média diária em valor em função dos dias transcorridos (vl_faturamento_liquido / Quantidade de dias úteis)
  (  (isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)) /

   (select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S')) as vl_media_diaria,

  --Calculando o valor da projeção para cada categoria (vl_media_diaria * (dias úteis - dias transcorridos) + vl_faturamento_liquido)
  ((isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) /
   (select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S'))*
   ((select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S') - 
   (select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_faturamento_diario and ic_util = 'S')) +
  (isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0))) as vl_projecao_faturamento,

  --Calculando o percentual da projeção em relação a meta da categoria (vl_projecao_faturamento/vl_fat_meta_categoria*100)
  ((isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock)
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) /

   (select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S'))*
   ((select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S') - 
   (select count('x')
    from  Agenda 
    where dt_agenda between @dt_inicial and @dt_faturamento_diario and ic_util = 'S')) +
  (isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) -

  isnull((select sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota)
   from Nota_Saida ns with (nolock) 
   left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_fiscal ofi on ofi.cd_operacao_fiscal = nsi.cd_operacao_fiscal

   where 
     isnull(ofi.ic_analise_op_fiscal,'N')='S' and
     nsi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0))) /

   isnull((select sum(isnull(vl_fat_meta_categoria,0))
    from Meta_Categoria_Produto
    where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),1) * 100 as pc_projecao_faturamento,

   cast(null as VarChar(15)) as 'cd_cor_relatorio_categ',
   cast(null as VarChar(06)) as 'lbl_acima_abaixo',
   cast(null as float)       as 'vl_acima_abaixo'

from
  Categoria_Produto cp
  left outer join Grupo_Categoria gc on cp.cd_grupo_categoria = gc.cd_grupo_categoria

-- where cp.ic_vendas_categoria='S'

order by 
  cp.cd_mascara_categoria,
  cp.nm_categoria_produto

end



--***************************************************************************************
-- Parametro = 2 (Polimold)
--***************************************************************************************



if @cd_parametro = 2 -- Mapa Polimold
begin

declare @cd_dias_uteis      int
declare @cd_dias_decorridos int
declare @dt_base_decorridos datetime

set @dt_base_decorridos =
case when @dt_final < getdate() then @dt_final else getdate() end

set @cd_dias_uteis = (select count('x')
                      from  agenda 
                      where Month(dt_agenda) = Month(@dt_inicial) and ic_util = 'S')

set @cd_dias_decorridos = (select count('x')
                           from  agenda 
                           where dt_agenda between @dt_inicial and @dt_base_decorridos and ic_util = 'S')

select

  substring(cast((gc.cd_grupo_categoria+100000000)as char(10)),2,8) + 
     ' - ' + gc.nm_grupo_categoria as nm_grupo_categoria,

  cp.cd_categoria_produto,
  cp.cd_mascara_categoria,
  cp.nm_categoria_produto,
  cp.sg_categoria_produto,
  cp.cd_ordem_categoria as 'OrdemAuxiliar',
  
  --Consultando faturamento do dia em quantidade

  qt_faturamento_dia = 
  cast(isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer Join Pedido_Venda_Item pvi on 
        nsi.cd_pedido_venda = pvi.cd_pedido_venda and
        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  = @dt_faturamento_diario and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) as int),

  --Consultando faturamento do dia em valor

  vl_faturamento_dia =
  isnull((select sum(vl_total_item)
   from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer Join Pedido_Venda_Item pvi on 
        nsi.cd_pedido_venda = pvi.cd_pedido_venda and
        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  = @dt_faturamento_diario and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0),

  --Consultando faturamento bruto em quantidade no período informado

  qt_faturamento_bruto = 
  cast(isnull((select sum(nsi.qt_item_nota_saida)
   from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer Join Pedido_Venda_Item pvi on 
        nsi.cd_pedido_venda = pvi.cd_pedido_venda and
        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0) as int),

  --Consultando faturamento bruto em valor no período informado

  vl_faturamento_bruto =
  isnull((select sum(nsi.vl_total_item)
   from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer Join Pedido_Venda_Item pvi on 
        nsi.cd_pedido_venda = pvi.cd_pedido_venda and
        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is null and ns.cd_status_nota <> 7),0),

  --Consultando devoluções em quantidade no período informado

  qt_devolvido_periodo =
  cast(isnull((select sum(case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida else nsi.qt_devolucao_item_nota end)
   from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer Join Pedido_Venda_Item pvi on 
        nsi.cd_pedido_venda = pvi.cd_pedido_venda and
        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is not null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0) as int),

  --Consultando devoluções em valor no período informado

  vl_devolvido_periodo =
  isnull((select sum((case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida else nsi.qt_devolucao_item_nota end) * nsi.vl_unitario_item_nota)
   from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer Join Pedido_Venda_Item pvi on 
        nsi.cd_pedido_venda = pvi.cd_pedido_venda and
        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and ns.dt_nota_saida  between @dt_inicial and @dt_final and nsi.dt_cancel_item_nota_saida is not null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0),

  --Consultando devoluções do mês anterior ao período informado em quantidade

  qt_devolvido_mes_anterior = 
  cast((select 
        case when month(@dt_inicial) = 1 then
          isnull((select sum(case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida else nsi.qt_devolucao_item_nota end)
          from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
               Left Outer Join Pedido_Venda_Item pvi on 
               nsi.cd_pedido_venda = pvi.cd_pedido_venda and
               nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
          where pvi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = 12 and  year(ns.dt_nota_saida) = year(@dt_inicial) -1 and nsi.dt_cancel_item_nota_saida is not null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
        else
          isnull((select sum(case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida else nsi.qt_devolucao_item_nota end)
          from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
               Left Outer Join Pedido_Venda_Item pvi on 
               nsi.cd_pedido_venda = pvi.cd_pedido_venda and
               nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
          where pvi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = month(@dt_inicial) - 1 and  year(ns.dt_nota_saida) = year(@dt_inicial) and nsi.dt_cancel_item_nota_saida is not null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
        end
       ) as int),

  --Consultando devoluções do mês anterior ao período informado em valor

  vl_devolvido_mes_anterior =
  (select 
     case when month(@dt_inicial) = 1 then
       isnull((select sum((case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida else nsi.qt_devolucao_item_nota end) * nsi.vl_unitario_item_nota)
       from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
            Left Outer Join Pedido_Venda_Item pvi on 
            nsi.cd_pedido_venda = pvi.cd_pedido_venda and
            nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
       where pvi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = 12 and  year(ns.dt_nota_saida) = year(@dt_inicial) -1 and nsi.dt_cancel_item_nota_saida is not null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
     else
       isnull((select sum((case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida else nsi.qt_devolucao_item_nota end) * nsi.vl_unitario_item_nota)
       from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
            Left Outer Join Pedido_Venda_Item pvi on 
            nsi.cd_pedido_venda = pvi.cd_pedido_venda and
            nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                                                   
       where pvi.cd_categoria_produto = cp.cd_categoria_produto and month(ns.dt_nota_saida) = month(@dt_inicial) - 1 and  year(ns.dt_nota_saida) = year(@dt_inicial) and nsi.dt_cancel_item_nota_saida is not null and ns.cd_status_nota <> 7 and ic_status_item_nota_saida in ('P', 'D')),0)
     end
  ),

  --Buscando a Meta de Faturamento em quantidade do Período na categoria

  qt_meta_faturamento = 
  isnull((select sum(qt_fat_meta_categoria)
   from Meta_Categoria_Produto
   where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),0),

  --Buscando a Meta de Faturamento em valor do Período na categoria

  vl_meta_faturamento = 
  isnull((select sum(vl_fat_meta_categoria)
   from Meta_Categoria_Produto
   where cd_categoria_produto = cp.cd_categoria_produto and dt_inicial_meta_categoria >= @dt_inicial and dt_final_meta_categoria <= @dt_final),0)

into #TmpFaturamentoAux

from
  Categoria_Produto cp 
  left outer join Grupo_Categoria gc on cp.cd_grupo_categoria = gc.cd_grupo_categoria

-- where cp.ic_fatura_categoria = 'S'

order by 
  cp.cd_mascara_categoria,
  cp.nm_categoria_produto

--
-- Executa totais ref. query anterior
--

declare @cd_ordem_total_nacional int

set @cd_ordem_total_nacional = (select OrdemAuxiliar 
                                from #TmpFaturamentoAux
                                where sg_categoria_produto = 'TOTAL NACIONAL')

--
-- Realiza cálculos 
--

select 

  nm_grupo_categoria,
  cd_categoria_produto,
  cd_mascara_categoria,
  nm_categoria_produto,
  sg_categoria_produto,
  qt_faturamento_dia,
  vl_faturamento_dia,
  qt_faturamento_bruto,
  vl_faturamento_bruto,
  qt_devolvido_periodo,
  vl_devolvido_periodo,
  qt_devolvido_mes_anterior,
  vl_devolvido_mes_anterior,
  qt_meta_faturamento,
  vl_meta_faturamento, 

  qt_faturamento_liquido = 
  cast(isnull(qt_faturamento_bruto,0) - isnull(qt_devolvido_periodo,0) - isnull(qt_devolvido_mes_anterior,0) as int),

  --Consultando faturamento líquido no período em valor (vl_faturamento_bruto - vl_devolvido_periodo)

  vl_faturamento_liquido = 
  isnull(vl_faturamento_bruto,0) - isnull(vl_devolvido_periodo,0) - isnull(vl_devolvido_mes_anterior,0),

  --Calculando o percentual atingido da meta em quantidade (qt_faturamento_liquido / qt_meta_faturamento * 100)

  pc_qtd_atingido_meta = 
  case when (qt_faturamento_bruto > 0) and (qt_meta_faturamento > 0) then
     (isnull(qt_faturamento_bruto,0) - isnull(qt_devolvido_periodo,0) - isnull(qt_devolvido_mes_anterior,0)) / qt_meta_faturamento * 100
  else 0 end,

  --Calculando média diária em quantidade em função dos dias transcorridos (qt_faturamento_liquido / Quantidade de dias úteis)

  qt_media_diaria =
  case when qt_faturamento_bruto > 0 then
     (isnull(qt_faturamento_bruto,0) - isnull(qt_devolvido_periodo,0) - isnull(qt_devolvido_mes_anterior,0)) / @cd_dias_uteis
  else 0 end,

  --Calculando média diária em valor em função dos dias transcorridos (vl_faturamento_liquido / Quantidade de dias úteis)

  vl_media_diaria =
  case when (vl_faturamento_bruto > 0) then
     (isnull(vl_faturamento_bruto,0) - isnull(vl_devolvido_periodo,0) - isnull(vl_devolvido_mes_anterior,0)) / @cd_dias_uteis
  else 0 end,

  --Calculando o valor da projeção para cada categoria (vl_media_diaria * (dias úteis - dias transcorridos) + vl_faturamento_liquido)

  vl_projecao_faturamento = 
  case when (vl_faturamento_bruto > 0) then
     (isnull(vl_faturamento_bruto,0) - isnull(vl_devolvido_periodo,0) - isnull(vl_devolvido_mes_anterior,0)) / @cd_dias_uteis *
     (@cd_dias_uteis - @cd_dias_decorridos) +
     (isnull(vl_faturamento_bruto,0) - isnull(vl_devolvido_periodo,0) - isnull(vl_devolvido_mes_anterior,0))
  else 0 end
 
into #TmpFaturamento

from 
   #TmpFaturamentoAux

--
--
-- Inicia montagem de nova disposição dos dados das categorias
--
--

select 
   a.cd_grupo_categoria           as 'GrupoPai',
   a.cd_categoria_produto         as 'CategoriaPai',
   a.cd_grupo_categoria_mapa      as 'GrupoFilho',
   a.cd_categoria_produto_mapa    as 'CategoriaFilho',
   a.cd_cor_relatorio_categ       as 'CorPai',
   b.cd_mascara_categoria         as 'MascaraPai',
   isnull(b.sg_resumo_categoria,
          b.sg_categoria_produto) as 'SiglaPai',
   b.nm_categoria_produto         as 'NomeCategoriaPai',
   b.cd_soma_categoria            as 'SomaPai',
   b.cd_ordem_categoria           as 'OrdemPai'

into #TmpMapaCategoriaPai

from 
     Mapa_Categoria_Produto a,
     Categoria_Produto b 

where a.cd_tipo_mapa_categoria = 1 and
      a.cd_grupo_categoria     = b.cd_grupo_categoria and
      a.cd_categoria_produto   = b.cd_categoria_produto and
      b.ic_impressao_categoria = 'S'

order by b.cd_ordem_categoria

--
-- Liga novamente com categoria para buscar siglas e outros dados dos "filhos"
--

select a.GrupoPai,
       a.MascaraPai,
       a.SiglaPai,
       a.NomeCategoriaPai,
       a.SomaPai,
       a.OrdemPai,
       a.CorPai,
       b.cd_mascara_categoria         as 'MascaraFilho',
       isnull(b.sg_resumo_categoria,
              b.sg_categoria_produto) as 'SiglaFilho',
       b.cd_soma_categoria            as 'SomaFilho',
       b.cd_ordem_categoria           as 'OrdemFilho',
       b.ic_impressao_categoria       as 'ImpressaoFilho',
       c.*

into #TmpFinal

from #TmpMapaCategoriaPai a,
     Categoria_Produto b,
     #TmpFaturamento c

where a.GrupoFilho           = b.cd_grupo_categoria and
      a.CategoriaFilho       = b.cd_categoria_produto and
      b.cd_categoria_produto = c.cd_categoria_produto
      
order by a.OrdemPai

--
-- Query final
--

select SiglaPai                                          as sg_categoria_produto,
       Max(OrdemPai)                                     as OrdemPai, 
       Max(GrupoPai)                                     as cd_grupo_categoria,
       Max(MascaraPai)                                   as cd_mascara_categoria,
       Max(CorPai)                                       as cd_cor_relatorio_categ,
       Max(nm_grupo_categoria)                           as nm_grupo_categoria,
       Max(NomeCategoriaPai)                             as nm_categoria_produto,
       Sum(cast(qt_faturamento_dia as float))            as qt_faturamento_dia,
       Sum(vl_faturamento_dia)                           as vl_faturamento_dia,
       Sum(cast(qt_faturamento_bruto as float))          as qt_faturamento_bruto,
       Sum(vl_faturamento_bruto)                         as vl_faturamento_bruto,
       Sum(cast(qt_devolvido_periodo as float))          as qt_devolvido_periodo,
       Sum(vl_devolvido_periodo)                         as vl_devolvido_periodo,
       Sum(cast(qt_devolvido_mes_anterior as float))     as qt_devolvido_mes_anterior, 
       Sum(vl_devolvido_mes_anterior)                    as vl_devolvido_mes_anterior,
       Sum(cast(qt_faturamento_liquido as float))        as qt_faturamento_liquido,
       Sum(vl_faturamento_liquido)                       as vl_faturamento_liquido,
       Sum(qt_meta_faturamento)                          as qt_meta_faturamento,
       Sum(vl_meta_faturamento)                          as vl_meta_faturamento,
       Sum(cast(round(pc_qtd_atingido_meta,0) as float)) as pc_qtd_atingido_meta,
       --Calculando o percentual atingido da meta em valor (vl_faturamento_liquido / vl_meta_faturamento * 100)
       pc_vlr_atingido_meta = 
       case when (Sum(vl_faturamento_bruto) > 0) and (Sum(vl_meta_faturamento) > 0) then
          (isnull(Sum(vl_faturamento_bruto),0) - isnull(Sum(vl_devolvido_periodo),0) - isnull(Sum(vl_devolvido_mes_anterior),0)) / 
             Sum(vl_meta_faturamento) * 100
       else 0 end,
       Sum(cast(round(qt_media_diaria,0) as float))      as qt_media_diaria,
       Sum(vl_media_diaria)                              as vl_media_diaria,
       Sum(vl_projecao_faturamento)                      as vl_projecao_faturamento,
       --Calculando o percentual da projeção em relação a meta da categoria (vl_projecao_faturamento / vl_fat_meta_categoria * 100)
       pc_projecao_faturamento =
       case when (Sum(vl_projecao_faturamento) > 0) and (Sum(vl_meta_faturamento) > 0) then
          Sum(vl_projecao_faturamento) / Sum(vl_meta_faturamento) * 100
       else 0 end,
       tmp_vl_acima_abaixo = 
       case when (Max(SiglaPai) = 'TOTAL NACIONAL') then
         ((Sum(Vl_Meta_Faturamento)/Max(@cd_dias_uteis)) * @cd_dias_decorridos)-Sum(Vl_Faturamento_Liquido) else 0 end,
   
       --Consultando percentual de faturamento líquido no período da categoria corrente

       pc_faturamento_liquido =
       case when (sum(vl_faturamento_liquido) > 0) then
          case when Max(OrdemPai) <= @cd_ordem_total_nacional then
             (sum(vl_faturamento_liquido) / 
             (select Sum(vl_faturamento_liquido)  
              from #TmpFinal
              where SiglaPai = 'TOTAL NACIONAL')) * 100
          else 0 end
       else 0 end

-------
into #TmpTermino
-------
from #TmpFinal
-------
group by SiglaPai

declare @vl_acima_abaixo float
set @vl_acima_abaixo = 0

select @vl_acima_abaixo = @vl_acima_abaixo + tmp_vl_acima_abaixo 
from #TmpTermino 

select *,
       @vl_acima_abaixo as 'vl_acima_abaixo',
       lbl_acima_abaixo =
       case when @vl_acima_abaixo < 0 then 'ACIMA '
       else 'ABAIXO' end

-------
from #TmpTermino
-------
order by OrdemPai

end

