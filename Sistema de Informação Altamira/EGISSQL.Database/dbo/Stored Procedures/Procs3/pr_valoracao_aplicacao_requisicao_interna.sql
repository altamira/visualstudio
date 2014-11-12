
create procedure pr_valoracao_aplicacao_requisicao_interna
@ic_parametro         int      = 1,
@cd_aplicacao_produto int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''
as

--select * from movimento_estoque (vl_custo_contabil_produto)
--select * from produto_fechamento
--select * from tipo_movimento_estoque

  select 
    me.cd_produto,
    max(me.vl_custo_contabil_produto) as vl_custo_contabil_produto
  into
    #MovimentoEntrada
  from
    Movimento_Estoque me with (nolock)
  where
    cd_tipo_movimento_estoque = 1               and
    isnull(me.vl_custo_contabil_produto,0)>0
  group by
    me.cd_produto

if @ic_parametro = 1
begin
  select 
    identity(int,1,1)                      as 'cd_controle',
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

    case when isnull(me.vl_custo_contabil_produto,0)>0 
    then
        isnull(me.vl_custo_contabil_produto,0)
     else
       case when isnull(pc.vl_custo_contabil_produto,0) > 0 
       then
          isnull(pc.vl_custo_contabil_produto,0)
       else
          isnull(em.vl_custo_contabil_produto,0)
       end
    end                                    as 'CustoContabil',

    isnull(ri.qt_item_req_interna*
    case when isnull(me.vl_custo_contabil_produto,0)>0 
    then
        isnull(me.vl_custo_contabil_produto,0)
     else
       case when isnull(pc.vl_custo_contabil_produto,0) > 0 
       then
          isnull(pc.vl_custo_contabil_produto,0)
       else
          isnull(em.vl_custo_contabil_produto,0)
       end
    end,0 )                                 
                                           as 'CustoTotal',
    um.sg_unidade_medida

  into
    #AplicacaoRequisicao    
  from
    Requisicao_Interna r                  with (nolock)
    inner join Requisicao_Interna_Item ri with (nolock) on r.cd_requisicao_interna = ri.cd_requisicao_interna
    left outer join Aplicacao_Produto ap  with (nolock) on ap.cd_aplicacao_produto = r.cd_aplicacao_produto
    left outer join Produto p             with (nolock) on ri.cd_produto           = p.cd_produto     
    left outer join Departamento d        with (nolock) on d.cd_departamento       = r.cd_departamento 
    left outer join Produto_Custo pc      with (nolock) on pc.cd_produto           = ri.cd_produto
    left outer join Movimento_Estoque me  with (nolock) on cast(me.cd_documento_movimento as int ) = r.cd_requisicao_interna and
                                             cd_tipo_documento_estoque = 5
                                             and me.cd_produto          = ri.cd_produto        
    left outer join #MovimentoEntrada em  with (nolock) on em.cd_produto            = ri.cd_produto

    left outer join Unidade_Medida    um  with (nolock) on um.cd_unidade_medida     = ri.cd_unidade_medida

--select * from requisicao_interna_item

--select top 10 * from movimento_estoque vl_custo_contabil_estoque
-- select * from movimento_estoque where cd_documento_movimento = 22324
-- select * from tipo_documento_estoque

  where 
    ((r.cd_aplicacao_produto  = @cd_aplicacao_produto) or (@cd_aplicacao_produto = 0)) and 
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )
  order by
    ap.nm_aplicacao_produto,
    r.dt_requisicao_interna desc    

select
  *
from
  #AplicacaoRequisicao
order by
    Aplicacao,
    Data desc    


end

-----------------------------------------------------------------------------------
--Resumo
-----------------------------------------------------------------------------------

if @ic_parametro = 2
begin
  
  -- Pegando o total para gerar o percentual
  declare @vl_total float

  select 
    @vl_total = isnull(sum(ri.qt_item_req_interna *
                       case when isnull(me.vl_custo_contabil_produto,0)>0 
                       then
                         isnull(me.vl_custo_contabil_produto,0)
                       else
                         case when isnull(pc.vl_custo_contabil_produto,0) > 0 
                              then
                                isnull(pc.vl_custo_contabil_produto,0)
                              else
                                isnull(em.vl_custo_contabil_produto,0)
                              end
                       end),0 )                                                                         

  from
    Requisicao_Interna r 
    inner join Requisicao_Interna_Item ri  with (nolock) on r.cd_requisicao_interna = ri.cd_requisicao_interna
    left outer join Aplicacao_Produto ap   with (nolock) on ap.cd_aplicacao_produto = r.cd_aplicacao_produto
    left outer join Produto_Custo pc       with (nolock) on pc.cd_produto           = ri.cd_produto
    left outer join Movimento_Estoque me   with (nolock) on cast(me.cd_documento_movimento as int ) = r.cd_requisicao_interna and
                                             cd_tipo_documento_estoque = 5
                                             and me.cd_produto = ri.cd_produto        
    left outer join #MovimentoEntrada em  with (nolock) on em.cd_produto            = ri.cd_produto

  where 
    ((r.cd_aplicacao_produto  = @cd_aplicacao_produto) or (@cd_aplicacao_produto = 0)) and 
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )

  select 
    ap.nm_aplicacao_produto                                            as 'Aplicacao',
    isnull(sum(ri.qt_item_req_interna),0)                              as 'Quantidade',
--    isnull(sum(pc.vl_custo_contabil_produto),0)                        as 'CustoContabil',
--    isnull(sum(ri.qt_item_req_interna*pc.vl_custo_contabil_produto),0) as 'CustoTotal',

    sum(case when isnull(me.vl_custo_contabil_produto,0)>0 
    then
        isnull(me.vl_custo_contabil_produto,0)
     else
       case when isnull(pc.vl_custo_contabil_produto,0) > 0 
       then
          isnull(pc.vl_custo_contabil_produto,0)
       else
          isnull(em.vl_custo_contabil_produto,0)
       end
    end)                                    as 'CustoContabil',

    sum(isnull(ri.qt_item_req_interna*
    case when isnull(me.vl_custo_contabil_produto,0)>0 
    then
        isnull(me.vl_custo_contabil_produto,0)
     else
       case when isnull(pc.vl_custo_contabil_produto,0) > 0 
       then
          isnull(pc.vl_custo_contabil_produto,0)
       else
          isnull(em.vl_custo_contabil_produto,0)
       end
    end,0 ))                                 
                                           as 'CustoTotal',

    case 
      when isnull(@vl_total,0) > 0 then
        --isnull(( sum(ri.qt_item_req_interna*pc.vl_custo_contabil_produto) / @vl_total ) * 100 ,0)

        isnull( (sum (isnull(ri.qt_item_req_interna*
                      case when isnull(me.vl_custo_contabil_produto,0)>0 
                           then
                                isnull(me.vl_custo_contabil_produto,0)
                           else
                                case when isnull(pc.vl_custo_contabil_produto,0) > 0 
                                then
                                  isnull(pc.vl_custo_contabil_produto,0)
                                else
                                  isnull(em.vl_custo_contabil_produto,0)
                                end
                           end,0)
                      / @vl_total * 100)),0)
      else
        0.00
    end as 'Perc'
  from
    Requisicao_Interna r                  with (nolock)
    inner join Requisicao_Interna_Item ri with (nolock) on r.cd_requisicao_interna = ri.cd_requisicao_interna
    left outer join Aplicacao_Produto ap  with (nolock) on ap.cd_aplicacao_produto = r.cd_aplicacao_produto
    left outer join Produto_Custo pc      with (nolock) on pc.cd_produto           = ri.cd_produto
    left outer join Movimento_Estoque me  with (nolock) on cast(me.cd_documento_movimento as int ) = r.cd_requisicao_interna and
                                             cd_tipo_documento_estoque = 5
                                             and me.cd_produto = ri.cd_produto        
    left outer join #MovimentoEntrada em  with (nolock) on em.cd_produto            = ri.cd_produto

  where 
    ((r.cd_aplicacao_produto  = @cd_aplicacao_produto) or (@cd_aplicacao_produto = 0)) and 
    (r.dt_requisicao_interna between @dt_inicial and @dt_final )
  group by
    ap.nm_aplicacao_produto
  order by
    ap.nm_aplicacao_produto

end
 
