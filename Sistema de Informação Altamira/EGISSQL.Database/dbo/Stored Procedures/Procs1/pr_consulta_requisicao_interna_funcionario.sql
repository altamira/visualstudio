
--sp_helptext pr_consulta_requisicao_interna_funcionario

create procedure pr_consulta_requisicao_interna_funcionario


@cd_funcionario       int       = 0,                --Contem o R.e do funcionário.
@dt_inicial           datetime  = '',
@dt_final             datetime  = ''

--@ic_parametro int         = 1,   sfp
--Tabelas de Funcionário
--select * from funcionario_documento
--select * from funcionario
--f.cd_empresa,
--    f.cd_funcionario,
--    f.nm_funcionario,
--    f.nm_fantasia_funcionario,
--    f.cd_chapa_funcionario,
--from 
--    funcionario f   with (nolock)      
--    left outer join Departamento         dp with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
--where (f.nm_funcionario like @nm_fantasia + '%')
--from 
--    funcionario f                           with (nolock) 
--    left outer join Departamento         dp with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
--where (cd_chapa_funcionario like @nm_fantasia + '%')
as

--Aplicação

  select 
    p.cd_mascara_produto                               as 'Codigo',
    p.nm_fantasia_produto                              as 'Produto',
    p.nm_produto	                               as 'Descricao',
    isnull(ri.qt_item_req_interna,0)                   as 'Quantidade',

--    isnull(ri.qt_entregue_req_interna,0)               as 'Entregue',

    case when isnull(rb.qt_baixa_requisicao,0)>0 then
       rb.qt_baixa_requisicao
    else
      case when isnull(ri.qt_entregue_req_interna,0)>0 
      then
         ri.qt_entregue_req_interna
      else
         ri.qt_item_req_interna
      end 
    end                                                as 'Entregue',

    --Saldo------------------------------------------------------------------------------------
 
    ri.qt_item_req_interna - 
    case when isnull(rb.qt_baixa_requisicao,0)>0 then
       rb.qt_baixa_requisicao
    else         
       isnull(ri.qt_entregue_req_interna,0)
    end                                                as 'Saldo',

    isnull(rb.qt_baixa_requisicao,0)                   as 'Baixa',



    isnull(ri.ic_estoque_req_interna,'N')  as 'Baixado',
    case when rb.dt_baixa_requisicao is not null then
      rb.dt_baixa_requisicao
    else
      ri.dt_item_estoque_req  
    end                                    as 'DataBaixa',

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
--    f.cd_funcionario                       as 'Re-Requisitante',
    f.nm_funcionario                        as 'Funcionario', 
    mr.nm_motivo_req_interna,
    sr.nm_status_requisicao

--funcionario

--select * from requisicao_interna

  from
    Requisicao_Interna r                           with (nolock) 
    inner join Requisicao_Interna_Item ri          with (nolock) on r.cd_requisicao_interna   = ri.cd_requisicao_interna

    left outer join requisicao_interna_baixa rb with (nolock) on rb.cd_requisicao_interna = ri.cd_requisicao_interna and
                                                                 rb.cd_item_req_interna   = ri.cd_item_req_interna


    left join funcionario f                        with (nolock) on f.cd_funcionario          = case when isnull(rb.cd_funcionario,0)>0 then
                                                                                                  rb.cd_funcionario
                                                                                                 else
                                                                                                  r.cd_funcionario   --lazaro
                                                                                                 end

    left  outer join Aplicacao_Produto ap          with (nolock) on ap.cd_aplicacao_produto   = r.cd_aplicacao_produto
    left  outer join Produto p                     with (nolock) on ri.cd_produto             = p.cd_produto     
    left  outer join Departamento d                with (nolock) on d.cd_departamento         = r.cd_departamento 
    left  outer join Produto_Custo pc              with (nolock) on pc.cd_produto             = ri.cd_produto
    left  outer join Motivo_Req_interna mr         with (nolock) on mr.cd_motivo_req_interna  = r.cd_motivo_req_interna
    left  outer join Status_Requisicao_Interna sr  with (nolock) on sr.cd_status_requisicao   = r.cd_status_requisicao


        
  where 
    --((r.cd_aplicacao_produto  = @cd_aplicacao_produto) or (@cd_aplicacao_produto = 0)) and 
    --(r.dt_requisicao_interna between @dt_inicial and @dt_final )
    isnull(r.cd_funcionario,0) = case when isnull(@cd_funcionario,0) = 0 then isnull(r.cd_funcionario,0) else @cd_funcionario end 
    and 
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )


 

order by
    --ap.nm_aplicacao_produto,
    r.cd_requisicao_interna,
    r.dt_requisicao_interna desc    


--select * from vw_baixa_requisicao_interna
 
