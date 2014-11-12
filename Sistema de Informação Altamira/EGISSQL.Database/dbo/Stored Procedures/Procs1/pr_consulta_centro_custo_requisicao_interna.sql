
create procedure pr_consulta_centro_custo_requisicao_interna
@cd_centro_custo      int,
@dt_inicial           datetime,
@dt_final             datetime
as

--Aplicação

  select 
    p.cd_mascara_produto                   as 'Codigo',
    p.nm_fantasia_produto                  as 'Produto',
    p.nm_produto	                   as 'Descricao',
    isnull(ri.qt_item_req_interna,0)       as 'Quantidade',
		isnull(ri.qt_entregue_req_interna,0)   as 'Entregue',
    isnull(ri.ic_estoque_req_interna,'N')  as 'Baixado',
    ri.dt_item_estoque_req                 as 'DataBaixa',
    ap.nm_centro_custo                     as 'CentroCusto',
    r.dt_requisicao_interna                as 'Data',
    r.cd_requisicao_interna                as 'Requisicao',
    ri.cd_item_req_interna                 as 'Item',  
    --ri.dt_estoque_req_interna            as 'DataEstoque',
    ri.nm_obs_req_interna                  as 'Observacao',
    d.nm_departamento                      as 'Departamento',
    isnull(pc.vl_custo_produto,0)          as 'CustoReposicao',
    isnull(pc.vl_custo_contabil_produto,0) as 'CustoContabil',
    isnull(ri.qt_item_req_interna*
           pc.vl_custo_contabil_produto,0) as 'CustoTotal',
    mr.nm_motivo_req_interna

  from
    Requisicao_Interna r                  with (nolock) 
    inner join Requisicao_Interna_Item ri with (nolock) on r.cd_requisicao_interna = ri.cd_requisicao_interna
    left outer join Centro_Custo ap       with (nolock) on ap.cd_centro_custo = r.cd_centro_custo
    left outer join Produto p             with (nolock) ON ri.cd_produto           = p.cd_produto     
    left outer join Departamento d        with (nolock) on d.cd_departamento       = r.cd_departamento 
    left outer join Produto_Custo pc      with (nolock) on pc.cd_produto           = ri.cd_produto
    left outer join Motivo_Req_interna mr with (nolock) on mr.cd_motivo_req_interna = r.cd_motivo_req_interna

  where 
    ((r.cd_centro_custo  = @cd_centro_custo) or (@cd_centro_custo = 0)) and 
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )
    
  --select * from produto_custo

order by
    ap.nm_centro_custo,
    r.dt_requisicao_interna desc    

--sp_help Produto

 
