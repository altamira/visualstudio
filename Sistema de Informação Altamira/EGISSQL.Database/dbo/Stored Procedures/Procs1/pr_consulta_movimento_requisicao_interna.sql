
create procedure pr_consulta_movimento_requisicao_interna
@cd_aplicacao_produto int         = 0,
@dt_inicial           datetime    = '',
@dt_final             datetime    = '',
@nm_fantasia_produto  varchar(25) = '',
@ic_quebra            char(1)     = 'A',
@ic_tipo_pesquisa     char(1)     = 'F' -- F = Fantasia / C = Cliente

as

  select 
    p.cd_mascara_produto                   as 'Codigo',
    p.nm_fantasia_produto                  as 'Produto',
    p.nm_produto	                   as 'Descricao',
    isnull(ri.qt_item_req_interna,0) *
    case when isnull(pf.qt_produto_fracionado,0)>0 
         then pf.qt_produto_fracionado 
         else 1 end                        as 'Quantidade',
    isnull(ri.qt_entregue_req_interna,0)   as 'Entregue',
    isnull(ri.ic_estoque_req_interna,'N')  as 'Baixado',
    ri.dt_item_estoque_req                 as 'DataBaixa',
    ap.nm_aplicacao_produto                as 'Aplicacao',
    r.dt_requisicao_interna                as 'Data',
    r.cd_requisicao_interna                as 'Requisicao',
    ri.cd_item_req_interna                 as 'Item',  
    ri.nm_obs_req_interna                  as 'Observacao',
    d.nm_departamento                      as 'Departamento',
    isnull(pc.vl_custo_produto,0)          as 'CustoReposicao',
    isnull(pc.vl_custo_contabil_produto,0) as 'CustoContabil',
    isnull(ri.qt_item_req_interna*
           pc.vl_custo_contabil_produto,0) as 'CustoTotal',
    mri.nm_motivo_req_interna              as 'MotivoRI',
    isnull(lp.nm_ref_lote_produto,'')      as 'Lote',
    u.nm_fantasia_usuario                  as 'Usuario'
  into
    #Movimento_RI
  from
    Requisicao_Interna r                      with (nolock) inner join
    Requisicao_Interna_Item ri                with (nolock) on r.cd_requisicao_interna   = ri.cd_requisicao_interna
    left outer join Aplicacao_Produto ap      with (nolock) on ap.cd_aplicacao_produto   = r.cd_aplicacao_produto
    left outer join Produto p                 with (nolock) on ri.cd_produto             = p.cd_produto     
    left outer join Departamento d            with (nolock) on d.cd_departamento         = r.cd_departamento 
    left outer join Produto_Custo pc          with (nolock) on pc.cd_produto             = ri.cd_produto
    left outer join Motivo_Req_Interna mri    with (nolock) on mri.cd_motivo_req_interna = r.cd_motivo_req_interna
    left outer join Lote_Produto lp           with (nolock) on lp.nm_ref_lote_produto    = ri.cd_lote_produto
    left outer join [EgisAdmin].dbo.Usuario u with (nolock) on u.cd_usuario              = ri.cd_usuario
    --Fracionamento
    left outer join produto_fracionamento pf  with (nolock) on pf.cd_produto_fracionado = ri.cd_produto
  where 
    isnull(r.cd_aplicacao_produto,0) = case when isnull(@cd_aplicacao_produto,0)=0 then isnull(r.cd_aplicacao_produto,0) else @cd_aplicacao_produto end and
    (( isnull(@nm_fantasia_produto,'')='') or ( case @ic_tipo_pesquisa
                                                  when 'F' then p.nm_fantasia_produto
                                                  when 'C' then p.cd_mascara_produto
                                                end like @nm_fantasia_produto + '%')) and
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )
  order by
    ap.nm_aplicacao_produto,
    r.dt_requisicao_interna desc    

  if isnull(@ic_quebra,'A')='A'
  begin
     select * from #Movimento_RI order by Aplicacao, Data desc
  end
  else
  begin
     select * from #Movimento_RI order by Produto, Data desc
  end

--select * from requisicao_interna_item

