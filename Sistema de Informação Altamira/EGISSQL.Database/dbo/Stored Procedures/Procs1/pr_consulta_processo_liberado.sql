
CREATE PROCEDURE pr_consulta_processo_liberado
-------------------------------------------------------------------
--pr_consulta_processo_liberado
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Daniel Carrasco Neto 
--Banco de Dados       : EgisSQL
--Objetivo             : Consulta de Processos Liberados para Programação.
--Data                 : 26/08/2002
--Atualizado           : 24/10/2003 - Acerto para evitar repetição de registros de acordo 
--                                    com o Pedido de Venda - Daniel Duela
--                     : 13/11/2003 - Acerto em erro de BLOB em referencia a campo tipo Text. - DUELA
--                     : 24/11/2003 - Inclusão de campos. - DUELA
--	               : 14/04/2004 - Remoção de IsNull do dt_entrega e do dt_mp_processo - Anderson
--                     : 23/04/2004 - Acerto no campo 'dt_mp_processo' - DUELA
--                     : 29/04/2004 - Inclusão dos campos 'dt_prog_processo', 'dt_entrega_fabrica_pedido',
--                                    'cd_usuario_mapa_processo' - DUELA
--                     : 09/06/2004 - Acertinho rápido na seleção de item da requisicao - Daniel C. Neto.
--                     : 16/06/2004 - Incluído filtro por liberação - Daniel C. Neto.
--                     : 22/07/2004 - Feito tratamento para tirar a hora da liberação. - Daniel C. Neto.
--                     : 08/08/2004 - Acerto pedido pelo Ludinei - Daniel C. Neto.
--                     : 11/08/2004 - Colocado ordem por liberação, se escolhido filtro de liberação - Daniel C. Neto.
--                     : 30/09/2004 - Incluído campos referentes a Alterações no Processo - Daniel C. Neto.
--                     : 04/01/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 10.04.2006 - Revisão - Carlos Fernandes 
--                     : 30.07.2007 - Acerto do Código/Fantasia do Produto - Carlos Fernandes
--                     : 05.09.2007 - Acerto do Status do Processo - Carlos Fernandes
--                     : 10.10.2007 - Verificação da Unidade de Medida - Carlos Fernandes
--15.03.2010 - Não Mostrar OP's canceladas e Op's Encerradas - Carlos Fernandes/Luis

------------------------------------------------------------------------------------------------------------------------

@ic_liberacao  char(1)     = 'N',
@cd_processo   varchar(15) = '',
@dt_inicial    datetime    = '',
@dt_final      datetime    = ''

AS

set dateformat dmy

select    
  pp.cd_processo, 
  pp.cd_identifica_processo,
  pp.dt_processo, 
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
  pc.nm_item_desenho_projeto + ' / ' + cast(pcm.cd_projeto_material as varchar)  as 'Material',

  cast(pvi.ds_produto_pedido_venda as varchar(2000)) as ds_observacao_pedido_item, 
/*
  (isnull((select top 1 dt_item_receb_nota_entrad
           from Nota_Entrada_Item
           where
             cd_requisicao_compra= (select top 1 rci.cd_requisicao_compra
                                    from Requisicao_Compra_Item rci
                                    where
                                      pp.cd_pedido_venda = rci.cd_pedido_venda and
                                      pp.cd_item_pedido_venda = rci.cd_pedido_venda) and
             cd_item_requisicao_compra= (select top 1 rci.cd_item_requisicao_compra
                                         from Requisicao_Compra_Item rci
                                         where
                                           pp.cd_pedido_venda = rci.cd_pedido_venda and
                                           pp.cd_item_pedido_venda = rci.cd_pedido_venda)),
          (select top 1 rci.dt_item_nec_req_compra  
           from Requisicao_Compra_Item rci
           where
             pp.cd_pedido_venda = rci.cd_pedido_venda and
             pp.cd_item_pedido_venda = rci.cd_item_pedido_venda)))
*/
(select top 1 rci.dt_item_nec_req_compra  
 from Requisicao_Compra_Item rci with (nolock) 
 where pp.cd_pedido_venda      = rci.cd_pedido_venda and
       pp.cd_item_pedido_venda = rci.cd_item_pedido_venda) as dt_mp_processo,
  pp.dt_alt_processo,
  pp.nm_alteracao_processo,
 
 prod.cd_mascara_produto,
 prod.nm_fantasia_produto,
 um.sg_unidade_medida,
 sp.nm_status_processo

from
  Processo_Producao pp                    with(nolock) 
  left outer join Pedido_Venda pv         with(nolock) on pp.cd_pedido_venda = pv.cd_pedido_venda 
  left outer join Pedido_Venda_Item pvi   with(nolock) on pp.cd_pedido_venda = pvi.cd_pedido_venda and
                                                          pp.cd_item_pedido_venda=pvi.cd_item_pedido_venda
  left outer join Cliente c               on pv.cd_cliente = c.cd_cliente
  left outer join EgisAdmin.dbo.Usuario u on isnull(pp.cd_usuario_mapa_processo,pp.cd_usuario) = u.cd_usuario 
  left outer join Projeto_Composicao pc   on pp.cd_projeto = pc.cd_projeto and 
                                             pp.cd_item_projeto = pc.cd_item_projeto
  left outer join projeto p               on pp.cd_projeto = p.cd_projeto  
  left outer join Projeto_Composicao_Material pcm on  pp.cd_projeto = pcm.cd_projeto and 
                                                      pp.cd_item_projeto = pcm.cd_item_projeto and 
                                                      pp.cd_projeto_material = pcm.cd_projeto_material
  left outer join Produto prod            on pp.cd_produto = prod.cd_produto
  left outer join Grupo_Produto gp        on gp.cd_grupo_produto = pvi.cd_grupo_produto
  left outer join Unidade_Medida um       on um.cd_unidade_medida = isnull(prod.cd_unidade_medida,isnull(pvi.cd_unidade_medida,gp.cd_unidade_medida) )
  left outer join Status_Processo sp      on sp.cd_status_processo = pp.cd_status_processo  
where     
  (IsNull(pp.cd_processo,'') = (case when isnull(@cd_processo,'') = '' then
                                IsNull(pp.cd_processo,'') else
                                isnull(@cd_processo,'') end ) and

  (case when @ic_liberacao = 'S' then
    IsNull(cast(convert(char(10), pp.dt_liberacao_processo, 103) as datetime),GetDate()) else
    IsNull(pp.dt_processo,GetDate()) end ) between 

   ( case when isnull(@cd_processo,'') = '' 
     then @dt_inicial else 
      (case when @ic_liberacao = 'S' then
       IsNull(cast(convert(char(10), pp.dt_liberacao_processo, 103) as datetime),GetDate()) else
       IsNull(pp.dt_processo,GetDate()) end ) end ) and 

   ( case when isnull(@cd_processo,'') = '' 
     then @dt_final else 
      (case when @ic_liberacao = 'S' then
       IsNull(cast(convert(char(10), pp.dt_liberacao_processo, 103) as datetime),GetDate()) else
       IsNull(pp.dt_processo,GetDate()) end ) end ) ) and

  IsNull(pv.dt_cancelamento_pedido,'') = '' and 
  --is null and 
  isnull(pvi.dt_cancelamento_item, '') = ''  and 
  isnull(pp.ic_libprog_processo,'N')   = 'S' 
  and
  isnull(sp.ic_programacao,'S')        = 'S'
  and
  pp.dt_canc_processo is null               --Não Pode estar Cancelado
  and
  pp.cd_status_processo <> 5                --Não Pode estar Encerrado

  --Carlos 10.04.2006
  --Não podemos checar o saldo do item do pedido de venda, porque nem sempre o processo de fabricação possuirá pedido

  --and	pvi.qt_saldo_pedido_venda > 0

order by  
  ( case when @ic_liberacao = 'S' then
         pp.dt_liberacao_processo
    else pvi.dt_entrega_cliente end ),

  ( case when @ic_liberacao = 'S' then
         pvi.dt_entrega_cliente
    else pp.dt_processo end ),

  pp.cd_processo

