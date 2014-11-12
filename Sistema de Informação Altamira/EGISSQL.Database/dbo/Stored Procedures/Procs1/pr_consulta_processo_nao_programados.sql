
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_processo_nao_programados
-------------------------------------------------------------------------------
--pr_consulta_processo_nao_programados
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Ordens de Produção / Processo de Fabricação
--                   Não programados no Marpa de Produção - APSNET
--Data             : 02.11.2007
--Alteração        : 10.11.2007 - Colocação de um parâmetro para identicar se existe operações
-- 04.01.2008 - Acerto do Status do Processo - Carlos Fernandes
-- 25.03.2010 - Não Mostrar OP's canceladas e Op's Encerradas - Carlos Fernandes/Luis
----------------------------------------------------------------------------------------------
create procedure pr_consulta_processo_nao_programados
as

--select * from status_processo

set dateformat dmy

select    
  pp.cd_processo, 
  pp.cd_identifica_processo,
  pp.dt_processo, 
  isnull(pp.ic_libprog_processo,'N')   as ic_libprog_processo,
  pp.ic_prog_mapa_processo,
  pv.dt_cancelamento_pedido,
  pv.ds_cancelamento_pedido,
  isnull(pp.ic_mapa_processo,'N')       as ic_mapa_processo, 
  cast(pp.ds_processo as varchar(2000)) as ds_processo, 
  pp.dt_prog_processo,
  pp.dt_liberacao_processo,
  pp.nm_mp_processo_producao,
  u.nm_fantasia_usuario                 as nm_fantasia_usuario_mapa_processo,
  pp.cd_pedido_venda, 
  pp.cd_item_pedido_venda, 
  pv.dt_pedido_venda,
  c.nm_fantasia_cliente, 
  IsNull(pvi.nm_produto_pedido, prod.nm_produto)              as nm_produto_pedido, 
  IsNull(pvi.qt_item_pedido_venda, pp.qt_planejada_processo)  as qt_item_pedido_venda, 
  isnull(pvi.dt_entrega_cliente,pvi.dt_entrega_vendas_pedido) as dt_entrega_cliente,	
  pvi.dt_entrega_fabrica_pedido,
  pc.nm_item_desenho_projeto,
  p.cd_interno_projeto,
  pc.nm_item_desenho_projeto + ' / ' + cast(pcm.cd_projeto_material as varchar) 
                                                              as 'Material',

  cast(pvi.ds_produto_pedido_venda as varchar(2000)) as ds_observacao_pedido_item, 

  (select top 1 rci.dt_item_nec_req_compra  
  from Requisicao_Compra_Item rci with (nolock) 
  where pp.cd_pedido_venda = rci.cd_pedido_venda and
        pp.cd_item_pedido_venda = rci.cd_item_pedido_venda)   as dt_mp_processo,

  pp.dt_alt_processo,
  pp.nm_alteracao_processo,
 
  prod.cd_mascara_produto,
  prod.nm_fantasia_produto,
  um.sg_unidade_medida,
  sp.nm_status_processo,
  ( select top 1 'S' from processo_producao_composicao ppp where ppp.cd_processo = pp.cd_processo and
                                                                 isnull(ppp.cd_maquina,0)>0 ) as ic_operacao

from
  Processo_Producao pp                    with(nolock)
  left outer join Pedido_Venda pv         with(nolock) on pp.cd_pedido_venda = pv.cd_pedido_venda 
  left outer join Pedido_Venda_Item pvi   with(nolock) on pp.cd_pedido_venda = pvi.cd_pedido_venda and
                                                          pp.cd_item_pedido_venda=pvi.cd_item_pedido_venda
  left outer join Cliente c               with(nolock) on pv.cd_cliente = c.cd_cliente
  left outer join EgisAdmin.dbo.Usuario u with(nolock) on isnull(pp.cd_usuario_mapa_processo,pp.cd_usuario) = u.cd_usuario 
  left outer join Projeto_Composicao pc   with(nolock) on pp.cd_projeto = pc.cd_projeto and 
                                                          pp.cd_item_projeto = pc.cd_item_projeto
  left outer join projeto p               with(nolock) on pp.cd_projeto = p.cd_projeto  
  left outer join Projeto_Composicao_Material pcm 
                                          with(nolock) on  pp.cd_projeto = pcm.cd_projeto and 
                                                           pp.cd_item_projeto = pcm.cd_item_projeto and 
                                                           pp.cd_projeto_material = pcm.cd_projeto_material
  left outer join Produto prod            with(nolock) on pp.cd_produto = prod.cd_produto
  left outer join Grupo_Produto gp        with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
  left outer join Unidade_Medida um       with(nolock) on um.cd_unidade_medida = isnull(prod.cd_unidade_medida,isnull(pvi.cd_unidade_medida,gp.cd_unidade_medida) )
  left outer join Status_Processo sp      with(nolock) on sp.cd_status_processo = pp.cd_status_processo  
where     
  IsNull(pv.dt_cancelamento_pedido,'') = ''  and 
  isnull(pvi.dt_cancelamento_item, '') = ''  and 
  isnull(sp.ic_programacao,'S')        = 'S' and
  pp.dt_prog_processo is null                and
  pp.dt_canc_processo is null                and --Não pode estar Cancelado
  sp.cd_status_processo <> 5                     --Não Pode estar Encerrado

order by  
  pp.dt_processo desc, pp.cd_processo




