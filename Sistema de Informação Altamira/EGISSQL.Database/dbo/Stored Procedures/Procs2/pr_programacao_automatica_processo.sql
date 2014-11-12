
-----------------------------------------------------------------------------------
--pr_programacao_automatica_processo
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a Consulta dos Processos que não foram programados no
--                   Mapa, e executa a Programação Automática
--                   
--
--Data             : 16.05.2004
--Alteração        : 12.06.2004
--                   17/06/2004 - Incluído campo de seleção. - Daniel C. Neto.                   
--                   18/06/2004 - Acerto para filtrar por data de liberação - Daniel C. Neto.
--                   19/06/2004 - Acerto da Data de Início da Programação
--                   13.07.2004 - Acertos Diversos  
--                   13.08.2007 - Verificação - Carlos Fernandes
--                   20.08.2007 - Novo flag para consulta de todos os processo ou somente programados - Carlos
--                   04.09.2007 - Flag do status do Processo - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------
create procedure pr_programacao_automatica_processo
@ic_parametro int      = 0, 
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@ic_consulta  char(1)  = 'S', --S=Todos / N=Abertos
@cd_processo  int      = 0

as

begin

  declare @qt_dia_inicio_operacao int

  select
    @qt_dia_inicio_operacao = isnull(qt_dia_inicio_operacao,0)
  
  from
    Parametro_Manufatura
  where
    cd_empresa = dbo.fn_empresa()


  --Dados para programação automática
  --select * from processo_producao_composicao

  select 
    0                                  as Sel,
    p.cd_processo, 
    p.dt_processo,
    isnull(p.qt_prioridade_processo,0) as qt_prioridade_processo,
    p.dt_liberacao_processo,
    p.dt_mp_processo,
    isnull(p.dt_entrega_processo,pvi.dt_entrega_vendas_pedido) as dt_entrega_processo,

    --Data de Início do Processo
    case when p.dt_inicio_processo is not null then p.dt_inicio_processo 
                                               else isnull(p.dt_mp_processo,getdate()) + 
                                                    @qt_dia_inicio_operacao 
                                               end as 'dt_inicio_processo',

    operacao = ( case 
                 isnull( (select top 1 cd_processo 
                          from 
                            processo_producao_composicao
                          where cd_processo = p.cd_processo order by cd_seq_processo) ,0) when 0
                  then 'N'
                  else 'S' end ),

    p.qt_planejada_processo,
    p.cd_produto,
    isnull(pro.nm_produto,pvi.nm_produto_pedido ) as nm_produto,
    isnull(p.cd_pedido_venda,0)                   as cd_pedido_venda,
    isnull(p.cd_item_pedido_venda,0)              as cd_item_pedido_venda,
    isnull(p.cd_projeto,0)                        as cd_projeto,
    isnull(p.cd_item_projeto,0)                   as cd_item_projeto,
    isnull(p.ic_mapa_processo,'N')                as ic_mapa_processo,
    pvi.dt_entrega_vendas_pedido,
    pvi.dt_entrega_fabrica_pedido,
    pvi.qt_saldo_pedido_venda,
    pvi.dt_cancelamento_item,
--  pvi.nm_produto_pedido,
    c.nm_fantasia_cliente,
    pv.cd_vendedor,
    v.nm_fantasia_vendedor,
    p.dt_entrega_prog_processo,
    p.dt_prog_processo,
    pro.cd_mascara_produto,
    pro.nm_fantasia_produto,
    pj.cd_interno_projeto,
    pjc.nm_projeto_composicao,
    pjm.nm_esp_projeto_material,
    fp.nm_fase_produto,
    sp.nm_status_processo

--    pro.nm_produto
  into
    #Programacao

  from 
    processo_producao p                            with (nolock)
    left outer join pedido_venda pv                with (nolock)  on pv.cd_pedido_venda       = p.cd_pedido_venda
    left outer join cliente c                      with (nolock)  on c.cd_cliente             = pv.cd_cliente   
    left outer join pedido_venda_item pvi          with (nolock)  on pvi.cd_pedido_venda      = pv.cd_pedido_venda and
                                                                     pvi.cd_item_pedido_venda = p.cd_item_pedido_venda
    left outer join vendedor v                      with (nolock) on v.cd_vendedor            = pv.cd_vendedor
    left outer join produto pro                     with (nolock) on pro.cd_produto           = p.cd_produto
    left outer join Projeto         pj              with (nolock) on pj.cd_projeto            = p.cd_projeto
    left outer join Projeto_Composicao pjc          with (nolock) on pjc.cd_projeto           = p.cd_projeto and
                                                                     pjc.cd_item_projeto      = p.cd_item_projeto    
    left outer join Projeto_Composicao_Material pjm with (nolock) on pjm.cd_projeto           = p.cd_projeto and
                                                                     pjm.cd_item_projeto      = p.cd_item_projeto and
                                                                     pjm.cd_projeto_material  = p.cd_projeto_material
     left outer join Fase_Produto fp          with (nolock)       on fp.cd_fase_produto       = p.cd_fase_produto
     left outer join Status_Processo sp       with (nolock)       on sp.cd_status_processo    = p.cd_status_processo 


  where
    p.cd_processo = case when @cd_processo = 0 then p.cd_processo else @cd_processo end and
    isnull( p.ic_libprog_processo,'N'  ) = 'S' and
    isnull( p.ic_prog_mapa_processo,'N') = 'N' and
    p.dt_canc_processo is null                 and
    p.dt_liberacao_processo is not null        and
    p.dt_liberacao_processo between ( case when @ic_parametro = 1 and @cd_processo = 0 
                                                         then @dt_inicial 
                                                         else p.dt_liberacao_processo end ) and

                                    ( case when @ic_parametro = 1 and @cd_processo = 0 
                                                         then @dt_final 
                                                         else p.dt_liberacao_processo end ) and
    isnull(sp.ic_programacao,'S') = 'S'

--     and
--    
--     p.dt_prog_processo = (case when @ic_consulta='N' then null else p.dt_prog_processo end )
    
  order by
    p.qt_prioridade_processo,
    p.dt_entrega_processo,
    isnull(p.dt_mp_processo,pvi.dt_entrega_vendas_pedido)

  --deleta os Pedidos de Venda Cancelados 

  delete from #programacao where isnull(cd_pedido_venda,0)>0 and dt_cancelamento_item is not null

  --deleta os Pedidos de Venda Faturado

  delete from #programacao where isnull(cd_pedido_venda,0)>0 and isnull(qt_saldo_pedido_venda,0)=0

  if @ic_consulta = 'N'
  begin
    delete from #programacao where dt_prog_processo is not null
  end

  if @ic_consulta = 'P'
  begin
    delete from #programacao where dt_prog_processo is null
  end

  --Mostra a Tabela 

  select
    *
  from
    #Programacao
  order by
    operacao desc,
    qt_prioridade_processo,
    dt_entrega_processo,
    isnull(dt_mp_processo,dt_entrega_vendas_pedido)


end

