
CREATE PROCEDURE pr_consulta_nota_por_vendedor
  @ic_parametro int      = 0,
  @dt_inicial 	datetime = '',
  @dt_final 	datetime = '',
  @cd_vendedor	int      = 0

AS

  --Devolução do Mês Anterior

  select     
    ns.cd_vendedor, 
    v.nm_fantasia_vendedor, 
--    ns.cd_nota_saida, 
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
            ns.cd_identificacao_nota_saida
          else
            ns.cd_nota_saida                              
    end                   as cd_nota_saida,

    ns.dt_nota_saida, 
    ns.cd_tipo_destinatario,
    ns.cd_cliente,
    wd.nm_fantasia, 
    cl.nm_fantasia_cliente, 

--     isnull(ns.vl_produto,0)    as vl_produto,
--     isnull(ns.vl_servico,0)    as vl_servico,
--     isnull(ns.vl_ipi,0)        as vl_ipi,
--     isnull(ns.vl_icms,0)       as vl_icms, 
--     isnull(ns.vl_icms_subst,0) as vl_icms_subst,
--     isnull(ns.vl_total,0)      as vl_total,
--    ns.vl_frete,
--    ns.vl_seguro,

    0.00    as vl_produto,
    0.00    as vl_servico,
    0.00    as vl_ipi,
    0.00    as vl_icms, 
    0.00    as vl_icms_subst,
    0.00    as vl_total,
    0.00    as vl_frete,
    0.00    as vl_seguro,

    cg.nm_cliente_grupo,
    ns.nm_mot_cancel_nota_saida,
    ns.dt_cancel_nota_saida,

    0.00                           as vl_devolucao_periodo,

    case when dt_cancel_nota_saida is not null 
    then    
       isnull(ns.vl_total,0)
    else
       0.00 
    end                            as vl_devolucao_mes_anterior,

    max(cc.nm_categoria_cliente)   as nm_categoria_cliente,
    max(nsi.cd_pedido_venda)       as cd_pedido_venda,
    ns.sg_estado_nota_saida

--select sg_estado_nota_saida,* from nota_saida

  into
    #Nota_Saida_Devolucao

  from
    vendedor v                                  with (nolock) 
    left outer join nota_saida 		ns 	with (nolock) on 	ns.cd_vendedor          = v.cd_vendedor
    left outer join nota_saida_item 	nsi     with (nolock) on 	nsi.cd_nota_saida       = ns.cd_nota_saida
    left outer join vw_destinatario 	wd      with (nolock) on 	wd.cd_destinatario      = ns.cd_cliente and 
						                        wd.cd_tipo_destinatario = ns.cd_tipo_destinatario 
    left outer join operacao_fiscal 	opf     with (nolock) on 	opf.cd_operacao_fiscal  = ns.cd_operacao_fiscal
    left outer join cliente 		cl 	with (nolock) on 	cl.cd_cliente           = ns.cd_cliente
    left outer join cliente_grupo 	cg 	with (nolock) on 	cg.cd_cliente_grupo     = cl.cd_cliente_grupo
    left outer join categoria_cliente   cc      with (nolock) on      cc.cd_categoria_cliente = cl.cd_categoria_cliente

  where
    ns.cd_status_nota <> 7 	     and
    v.cd_vendedor     = case when @cd_vendedor = 0 then v.cd_vendedor else @cd_vendedor end and
    ns.dt_cancel_nota_saida is not null and
    ns.dt_cancel_nota_saida between @dt_inicial and @dt_final and
    isnull(opf.ic_comercial_operacao,'N') = 'S'   and
    ns.dt_nota_saida < @dt_inicial

  group by 
    ns.cd_vendedor, 
    v.nm_fantasia_vendedor, 
    ns.dt_nota_saida, 
    ns.cd_nota_saida, 
    ns.cd_identificacao_nota_saida,
    ns.vl_produto, 
    ns.vl_servico,
    ns.vl_ipi, 
    ns.vl_icms, 
    ns.vl_icms_subst, 
    ns.vl_frete,
    ns.vl_seguro,
    wd.nm_fantasia, 
    cl.nm_fantasia_cliente,
    ns.nm_mot_cancel_nota_saida, 
    ns.dt_cancel_nota_saida, 
    ns.cd_status_nota,
    ns.cd_tipo_destinatario,
    ns.cd_cliente,
    ns.vl_total,
    cg.nm_cliente_grupo,
    ns.sg_estado_nota_saida


  order by 
    ns.cd_vendedor, 
    ns.cd_nota_saida

  --select * from #Nota_Saida_Devolucao
  --select * from nota_saida

  select     
    ns.cd_vendedor, 
    v.nm_fantasia_vendedor, 
--    ns.cd_nota_saida, 
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
            ns.cd_identificacao_nota_saida
          else
            ns.cd_nota_saida                              
    end                        as cd_nota_saida,

    ns.dt_nota_saida, 
    ns.cd_tipo_destinatario,
    ns.cd_cliente,
    wd.nm_fantasia, 
    cl.nm_fantasia_cliente, 
    isnull(ns.vl_produto,0)    as vl_produto,
    isnull(ns.vl_servico,0)    as vl_servico,
    isnull(ns.vl_ipi,0)        as vl_ipi,
    isnull(ns.vl_icms,0)       as vl_icms, 
    isnull(ns.vl_icms_subst,0) as vl_icms_subst,
    isnull(ns.vl_total,0)      as vl_total,
    isnull(ns.vl_frete,0)      as vl_frete,
    isnull(ns.vl_seguro,0)     as vl_seguro,

    cg.nm_cliente_grupo,
    ns.nm_mot_cancel_nota_saida,
    ns.dt_cancel_nota_saida,

    case when dt_cancel_nota_saida is not null 
    then    
       isnull(ns.vl_total,0)
    else
       0.00 
    end                            as vl_devolucao_periodo,

    0.00                           as vl_devolucao_mes_anterior,

    max(cc.nm_categoria_cliente)   as nm_categoria_cliente,
    max(nsi.cd_pedido_venda)       as cd_pedido_venda,
    ns.sg_estado_nota_saida

  into
    #Nota_Saida

  from
    vendedor v                                  with (nolock) 
    left outer join nota_saida 		ns 	with (nolock) on 	ns.cd_vendedor          = v.cd_vendedor
    left outer join nota_saida_item 	nsi     with (nolock) on 	nsi.cd_nota_saida       = ns.cd_nota_saida
    left outer join vw_destinatario 	wd      with (nolock) on 	wd.cd_destinatario      = ns.cd_cliente and 
						                        wd.cd_tipo_destinatario = ns.cd_tipo_destinatario 
    left outer join operacao_fiscal 	opf     with (nolock) on 	opf.cd_operacao_fiscal  = ns.cd_operacao_fiscal
    left outer join cliente 		cl 	with (nolock) on 	cl.cd_cliente           = ns.cd_cliente
    left outer join cliente_grupo 	cg 	with (nolock) on 	cg.cd_cliente_grupo     = cl.cd_cliente_grupo
    left outer join categoria_cliente   cc      with (nolock) on      cc.cd_categoria_cliente = cl.cd_categoria_cliente

  where
    ns.cd_status_nota <> 7 	     and
    v.cd_vendedor     = case when @cd_vendedor = 0 then v.cd_vendedor else @cd_vendedor end and
    ns.dt_nota_saida  between @dt_inicial and @dt_final and
    isnull(opf.ic_comercial_operacao,'N') = 'S'   

  group by 
    ns.cd_vendedor, 
    v.nm_fantasia_vendedor, 
    ns.dt_nota_saida, 
    ns.cd_nota_saida, 
    ns.cd_identificacao_nota_saida,
    ns.vl_produto, 
    ns.vl_servico,
    ns.vl_ipi, 
    ns.vl_icms, 
    ns.vl_icms_subst, 
    ns.vl_frete,
    ns.vl_seguro,
    wd.nm_fantasia, 
    cl.nm_fantasia_cliente,
    ns.nm_mot_cancel_nota_saida, 
    ns.dt_cancel_nota_saida, 
    ns.cd_status_nota,
    ns.cd_tipo_destinatario,
    ns.cd_cliente,
    ns.vl_total,
    cg.nm_cliente_grupo,
    ns.sg_estado_nota_saida

  order by 
    ns.cd_vendedor, 
    ns.cd_nota_saida


  --Mostra as Tabelas 
  select
    ns.*
  from 
    #Nota_Saida ns
  union all 
    select
      ns.*
    from 
      #Nota_Saida_Devolucao ns
    order by 
      ns.cd_vendedor, 
      ns.cd_nota_saida

