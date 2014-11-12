
CREATE PROCEDURE pr_consulta_diario_perda

@cd_proposta int,
@dt_inicial  datetime,
@dt_final    datetime,
@cd_vendedor int = 0,
@cd_tipo_mercado int = 0  
AS

  select 
    c.nm_fantasia_cliente,
    ci.dt_item_consulta,
    cip.cd_consulta,
    cip.cd_item_consulta,
    ci.nm_fantasia_produto,
    cip.dt_perda_consulta,
    ci.qt_item_consulta,
    v.nm_fantasia_vendedor,
    con.nm_concorrente,
    cip.vl_perda_consulta,
    mp.nm_motivo_perda,
    ci.vl_unitario_item_consulta,
    ci.qt_item_consulta * ci.vl_unitario_item_consulta as TotalItem,
    ra.nm_ramo_atividade
  from
    Consulta_Item_Perda cip with (nolock)                                               left outer join
    Consulta_Itens ci       with (nolock) on ci.cd_consulta      = cip.cd_consulta and 
                                             ci.cd_item_consulta = cip.cd_item_consulta left outer join
    Consulta cons           with (nolock) on cons.cd_consulta    = cip.cd_consulta      left outer join
    Vendedor v              with (nolock) on v.cd_vendedor       = cons.cd_vendedor     left outer join
    Concorrente con         with (nolock) on con.cd_concorrente  = cip.cd_concorrente   left outer join
    Cliente c               with (nolock) on c.cd_cliente        = cons.cd_cliente      left outer join
    Motivo_Perda mp         with (nolock) on mp.cd_motivo_perda  = cip.cd_motivo_perda  left outer join
    Ramo_Atividade ra       with (nolock) on ra.cd_ramo_atividade = c.cd_ramo_atividade 
  where
    (ci.cd_consulta = @cd_proposta) or ( (@cd_proposta = 0) and ci.dt_item_consulta between @dt_inicial and @dt_final) and
    isnull(cons.cd_vendedor,0)  = ( case when isnull(@cd_vendedor,0) = 0 then     isnull(cons.cd_vendedor,0) else @cd_vendedor end) and
    isnull(c.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(c.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 


