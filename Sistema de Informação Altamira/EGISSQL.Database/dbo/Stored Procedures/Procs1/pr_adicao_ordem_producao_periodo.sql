
-------------------------------------------------------------------------------
--sp_helptext pr_adicao_ordem_producao_periodo
-------------------------------------------------------------------------------
--pr_adicao_ordem_producao_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Adição nas Ordens de Produção
--Data             : 01.01.2009
--Alteração        : 
--
-- 09.02.2009 - Complemento das informações - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_adicao_ordem_producao_periodo
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from processo_padrao
--select * from processo_producao

select
--    identity(int,1,1) as 'cd_chave',
    pp.cd_processo,
    pp.dt_processo,
    pp.cd_identifica_processo,
    pp.cd_usuario,
    pp.dt_usuario,
    pp.cd_fase_produto,
    pp.cd_status_processo,
    pp.qt_planejada_processo,
    pp.dt_entrega_processo,
    pp.cd_produto,
    pp.cd_pedido_venda,
    pp.cd_item_pedido_venda,
    cast(pp.ds_processo as varchar(2000))as 'ds_processo',
    pp.dt_liberacao_processo,
    pp.dt_canc_processo,
    pp.dt_encerramento_processo,
    pp.cd_processo_padrao,
    pp2.nm_identificacao_processo,
    pp2.nm_processo_padrao,
    sp.sg_status_processo,
    sp.nm_status_processo,
    fp.sg_fase_produto,
    ppa.cd_produto_adicao,
    case when isnull(ic_estorna_estoque,'N')='N' then
      ppa.qt_adicao
    else
      ppa.qt_adicao * -1
    end                                 as qt_adicao,

    case when isnull(ic_estorna_estoque,'N')='S' then
      ppa.qt_adicao
    else
      0.00
    end                                 as qt_estorno,

    ppa.nm_motivo_adicao,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida,
    isnull(pc.vl_custo_produto,0)        as vl_custo_produto,
    ppa.dt_usuario,
    u.nm_fantasia_usuario,
    ppe.qt_programada,
    ppe.qt_real_embalada,
    te.nm_tipo_embalagem
     
--select * from tipo_embalagem

  from
    Processo_Producao pp                            with (nolock) 
    left outer join Processo_Padrao pp2             with (nolock) on (pp.cd_processo_padrao = pp2.cd_processo_padrao) 
    left outer join Status_Processo sp              with (nolock) on (pp.cd_status_processo = sp.cd_status_processo)
    left outer join Fase_produto fp                 with (nolock) on (pp.cd_fase_produto    = fp.cd_fase_produto)    
    left outer join Processo_Producao_Adicao ppa    with (nolock) on ppa.cd_processo        = pp.cd_processo
    left outer join Produto p                       with (nolock) on p.cd_produto           = ppa.cd_produto
    left outer join Unidade_Medida um               with (nolock) on um.cd_unidade_medida   = p.cd_unidade_medida
    left outer join egisadmin.dbo.usuario  u        with (nolock) on u.cd_usuario           = ppa.cd_usuario
    left outer join Processo_Producao_Embalagem ppe with (nolock) on ppe.cd_processo        = pp.cd_processo --and
                                                                     --ppe.cd_produto         = pp.cd_produto 
    left outer join Tipo_Embalagem te               with (nolock) on te.cd_tipo_embalagem   = ppe.cd_tipo_embalagem
    left outer join Produto_Custo pc                with (nolock) on pc.cd_produto          = p.cd_produto

  where 
    pp.dt_processo      between @dt_inicial and @dt_final and 
    pp.dt_canc_processo is null


order by
   pp.dt_processo

--select * from processo_producao_embalagem
--select * from processo_producao_adicao

