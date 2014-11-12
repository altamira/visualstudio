
create procedure pr_consulta_aplicacao_requisicao_interna
@cd_aplicacao_produto int,
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
    ap.nm_aplicacao_produto                as 'Aplicacao',
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
    mr.nm_motivo_req_interna,
    r.cd_funcionario,
    f.nm_funcionario,
    r.cd_status_requisicao,
    sr.nm_status_requisicao


--select * from requisicao_interna

  from
    Requisicao_Interna r                  with (nolock) 
    inner join Requisicao_Interna_Item ri with (nolock) on r.cd_requisicao_interna  = ri.cd_requisicao_interna
    left outer join Aplicacao_Produto ap  with (nolock)  on ap.cd_aplicacao_produto = r.cd_aplicacao_produto
    left outer join Produto p             with (nolock) ON ri.cd_produto            = p.cd_produto     
    left outer join Departamento d        with (nolock) on d.cd_departamento        = r.cd_departamento 
    left outer join Produto_Custo pc      with (nolock) on pc.cd_produto            = ri.cd_produto
    left outer join Motivo_Req_interna mr with (nolock) on mr.cd_motivo_req_interna = r.cd_motivo_req_interna
    left outer join Funcionario        f         with (nolock) on f.cd_funcionario          = r.cd_funcionario
    left outer join Status_Requisicao_Interna sr with (nolock) on sr.cd_status_requisicao   = r.cd_status_requisicao

  where 
    ((r.cd_aplicacao_produto  = @cd_aplicacao_produto) or (@cd_aplicacao_produto = 0)) and 
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )
    
  --select * from produto_custo

order by
    ap.nm_aplicacao_produto,
    r.dt_requisicao_interna desc    

--sp_help Produto

 
