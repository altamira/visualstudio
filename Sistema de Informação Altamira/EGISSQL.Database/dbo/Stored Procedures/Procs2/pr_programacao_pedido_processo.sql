
CREATE PROCEDURE pr_programacao_pedido_processo

----------------------------------------------------------------------
--pr_programacao_pedido_processo
----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                             2004
----------------------------------------------------------------------
--Stored Procedure   : Microsoft SQL Server 2000
--Autor(es)          : Daniel Carrasco Neto
--Banco de Dados     : EgisSQL
--Objetivo           : Consulta de Pedido para Processo
--Data               : 06/12/2002
--Atualizado         : 12/12/2002 - Acertos - Daniel C. Neto.
--                   : 05/04/2003 - Revisão - Carlos Cardoso Fernandes
--                   : 06/10/2003 - Acerto no filtro. 'ic_processo_produto' - Daniel Duela
--                   : 14/10/2003 - Inclusão do campo 'Processo_Fabricacao'
--                   : 21/10/2003 - Inclusão dos Campos N°Proposta, Item, Orçamento e Processista 
--                                  cd_consulta, cd_item_consulta, nm_vendedor e nm_processista respectivamente - Danilo
--                   : 29/10/2003 - Incluir um 'top 1' na select do campo Processo.
--                                  Poderia acarretar de trazer multiplos results sets 
--                                - Filtro por Empresa na select da Parametro_Manufatura - DANIEL DUELA
--                   : 12/11/2003 - Acertos nos campos Atraso/Vencimento/Dias conforme OS-SEP-121103-1343 - Daniel Duela.
--                   : 15/11/2003 - Validação no campo 'Prazo', caso esteja vazio a variavel '@qt_dia_aguardo' 
--                                  Adição da Coluna 'Atraso' - DANIEL DUELA
--                   : 21/01/2004 - Nova Validação para campo 'Prazo' e 'Atrasado'- DANIEL DUELA
--                   : 06/02/2004 - Acerto na validação dos campos referentes a Faturamento e Atraso - DANIEL DUELA
--                   : 12/04/2004 - Acerto na validação dos campos referentes a Prazo e Atraso - DANIEL DUELA
--                   : 01/06/2004 - Inclusão de filtros de tipo de pedido ( Abertos ou Todos ) e 
--                                - otimização da consulta tirando os Ors. - Daniel C. Neto.
--                   : 06/12/2004 - Inclusão do flag para identificar as Notas Fiscais Faturadas, porém Devolvidas
--                   : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--		     : 09/02/2005 - Mudança para order by Prazo - Clelson Camargo
--		     : 22/02/2005 - Acerto nos campos Prazo Vencido, Atrasado, Prazo
--			            Prazo Vencido -> Prazo de produção vencido em função do Paramatro_Manufatura.qt_dia_processo_aguardo
--				    Atrasado 	  -> Entrega atrasada em função da data de entrega do item do pedido de venda
--				    Coluna Prazo  -> Indica quantos dias o pedido de venda está aguardando faturamento
--				    Johnny/Elias
-- 07.06.2006        : Saldo Atual e Estoque Mínimo do Produto na Consulta - Carlos Fernandes   
--                   : 06/07/2006 - Trazer os itens que são produzidos e que fazem parte da composição do item
--                                  do pedido de venda - Paulo Souza
--                   : 06.10.2006 - Código do produto/Desenho/Revisão - Carlos Fernandes
--                   : 26.10.2006 - Consulta de Pedidos de Serviço que não estava mostrando - Carlos Fernandes
--                   : 20.01.2007 - Adicionado ic_libprog_processo - Anderson Messias
--                   : 23.02.2007 - Adicionado flag para identificação do pedido com desconto não Liberado - Carlos
--                   : 26.04.2007 - Requisição de Compra - Carlos Fernandes
-- 01.04.2008 - Ajuste do Pedido de Produto/Serviço - Carlos Fernandes
-- 18.10.2008 - Complemento das Informações - Carlos Fernandes
-- 09.08.2009 - Nota / Data nota - Carlos Fernandes
-- 21.10.2010 - Número da Nota Fiscal - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------

@cd_pedido      int,
@dt_inicial     datetime,
@dt_final       datetime,
@ic_tipo_filtro char(1) = 'T'

AS

declare @qt_dia_aguardo  int
declare @cd_fase_produto int 

select 
  @qt_dia_aguardo = isnull(qt_dia_processo_aguardo , 0)
from 
  parametro_manufatura with (nolock) 
where 
  cd_empresa=dbo.fn_empresa()


--Fase do Produto Padrão

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock) 
where 
  cd_empresa=dbo.fn_empresa()

--select * from produto

select distinct
  pvi.qt_saldo_pedido_venda,
  pv.cd_pedido_venda, 
  pvi.cd_item_pedido_venda,
  0                              as cd_id_item_pedido_venda,
  pvi.dt_item_pedido_venda, 
  pvi.qt_item_pedido_venda, 
  pvi.dt_entrega_vendas_pedido, 
  pvi.dt_entrega_fabrica_pedido,
  pvi.dt_reprog_item_pedido,
  pvi.vl_unitario_item_pedido, 
  case 
    when isnull(pvi.cd_servico,0) > 0 then 
      case 
        when cast(pvi.ds_produto_pedido_venda as varchar(50)) <> '' then 
          cast(pvi.ds_produto_pedido_venda as varchar(50)) 
        else isnull(pvi.nm_produto_pedido,s.nm_servico)
      end
    else IsNull(pvi.nm_produto_pedido, p.nm_produto)
  End as nm_produto_pedido,
--   case 
--     when pvi.cd_servico > 0 then
--       cast(pvi.ds_produto_pedido_venda as varchar(50))
--     else
--       pvi.nm_produto_pedido
--   end as nm_produto_pedido,
  isnull(pvi.nm_fantasia_produto,s.nm_servico) as nm_fantasia_produto,
  ve.nm_fantasia_vendedor                      as nm_fant_ve, 
  vi.nm_fantasia_vendedor                      as nm_fant_vi,

  --Indica quantidade de dias que o pedido de venda está aguardando pelo faturamento.
  case when (isnull(pvi.qt_saldo_pedido_venda,0) = 0) then
    0  
  else
    Datediff(d,pv.dt_pedido_venda,GetDate()) end as 'Prazo',

  case when (isnull(pvi.dt_entrega_vendas_pedido,'')=''  or
             isnull(pvi.qt_saldo_pedido_venda,0) = 0) then
    0  
  else
    Datediff(d, GetDate(), pvi.dt_entrega_vendas_pedido) end as 'Atraso',

  cli.nm_fantasia_cliente,

  (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as 'VlrTotal',
  pvi.ic_orcamento_pedido_venda                            as 'Orcado',

  case when 
    Datediff(d, GetDate(), pvi.dt_entrega_vendas_pedido) < @qt_dia_aguardo
    and isnull(pvi.qt_saldo_pedido_venda,0) > 0  then 'S' 
  else
    'N' end as 'Vencido',

  case when 
    getDate() > pvi.dt_entrega_vendas_pedido and IsNull(pvi.qt_saldo_pedido_venda,0) > 0 then 'S'
  else 'N'end as 'Atrasado',

  case when 
    pvi.dt_cancelamento_item is null then 'N' 
  else
    'S' end as 'Cancelado',
  case when 
    exists (select top 1 x.cd_produto
            from Produto_Producao x
            where x.cd_produto = pvi.cd_produto) then 'S' 
  else
    'N' end as 'Processo', 

  case when 
    (IsNull(pvi.qt_saldo_pedido_venda,0) = 0) and (isnull(pvi.dt_cancelamento_item,'') ='') then 'S' 
  else 
    'N' end as 'Faturado',
  case when 
    pv.dt_credito_pedido_venda is null then 'S' 
  else 
    'N' end as 'Credito_Nao_Lib',
  case when
   isnull(pvi.ic_desconto_item_pedido,'N') = 'S' and pvi.dt_desconto_item_pedido is null then 'S'
  else
    'N'
  end as 'Desconto_Nao_Lib',

  pvi.cd_grupo_produto,

  IsNull(gpc.ic_processo_grupo_produto,'N') as 'GeraProcesso',
  case when isnull(pp.cd_processo,0)=0 then
    'N'
  else
    'S'
  end                                       as 'Processo_Fabricacao',

  --Verificar se houve devolução pelo Cliente na Tabela de Itens de Nota de Saída
  --Carlos 06/12/2004
 
  case when 
     exists ( select top 1 ni.cd_pedido_venda
              from
                Nota_Saida_Item ni with (nolock) 
              where
                ni.cd_pedido_venda      = pvi.cd_pedido_venda      and
                ni.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
                ni.ic_status_item_nota_saida = 'D') Then 'S'
--              order by
--                ni.dt_cancel_item_nota_saida desc ) then 'S'
   else
     'N' 
   end                                      as 'Devolucao',

  pp.cd_processo,
  pp.dt_processo,
  ci.cd_consulta, 
  ci.cd_item_consulta, 
  vnd.nm_vendedor,
  pp.nm_processista,
  case when isnull(p.cd_fase_produto_baixa,0)=0 then @cd_fase_produto 
                                                else p.cd_fase_produto_baixa end as 'cd_fase_produto',
  ps.qt_saldo_reserva_produto as 'Saldo',
  ps.qt_minimo_produto        as 'EstoqueMinimo',
  fp.nm_fase_produto          as 'Fase',
  case when pvi.cd_produto>0 then
       case when ps.qt_saldo_reserva_produto<0 or 
                 ps.qt_saldo_reserva_produto<=isnull(ps.qt_minimo_produto,0) 
       then abs(ps.qt_saldo_reserva_produto)+isnull(ps.qt_minimo_produto,0)
       else 0.00 end 
  else pvi.qt_item_pedido_venda end  as 'QtdProducao',                                         
  sp.nm_status_processo,
  pp.dt_fimprod_processo,
  case sp.cd_status_processo 
    When 5
      Then 'S'
    Else 'N'
  End as 'ProcessoEncerrado',
  case when isnull(pvi.cd_servico,0)>0 then
     cast(s.cd_servico as varchar(25)) 
  else
    case when isnull(pvi.cd_produto,0)>0 then
       p.cd_mascara_produto
    else 
      cast(pvi.cd_grupo_produto as varchar(25))
    end
  end                                 as cd_mascara_produto,

  case when isnull(pvi.cd_produto,0)>0 then
     isnull(p.cd_desenho_produto,pvi.cd_desenho_item_pedido)
  else
     pvi.cd_desenho_item_pedido
  end                                as cd_desenho_produto,

  case when isnull(pvi.cd_produto,0)>0 then
    isnull(p.cd_rev_desenho_produto,pvi.cd_rev_des_item_pedido)
  else
    pvi.cd_rev_des_item_pedido
  end                                as cd_rev_desenho_produto,

  isnull(pp.ic_libprog_processo,'N') as 'Liberado',

  ReqCompra = ( select top 1 cd_requisicao_compra from Requisicao_Compra_Item
                where cd_pedido_venda = pvi.cd_pedido_venda and
                      cd_item_pedido_venda = pvi.cd_item_pedido_venda order by cd_requisicao_compra desc ),
  pvi.nm_observacao_fabrica1,
  pvi.nm_observacao_fabrica2,

  --Dados do Faturamento

  --nsi.cd_nota_saida,

  nsi.cd_identificacao_nota_saida as cd_nota_saida,
  nsi.dt_nota_saida,
  nsi.dt_saida_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.qt_item_nota_saida,
  nsi.qt_devolucao_item_nota,
  nsi.qt_item_nota_saida as qt_faturada


--select * from pedido_venda_item

FROM
  Pedido_Venda pv                   with (nolock)
  inner join Pedido_Venda_Item pvi  with (nolock)  on pv.cd_pedido_venda = pvi.cd_pedido_venda 
--  left join Pedido_Venda_Item pvi with (nolock)  on pv.cd_pedido_venda = pvi.cd_pedido_venda 
  left outer join Consulta cns      with (nolock)  on pvi.cd_consulta = cns.cd_consulta
  left outer join vendedor vnd      with (nolock)  on cns.cd_vendedor_interno = vnd.cd_vendedor
  left outer join consulta_itens ci with (nolock)  on pvi.cd_consulta = ci.cd_consulta and
                                                      pvi.cd_item_consulta = ci.cd_item_consulta
     
  inner join Vendedor vi with (nolock)               on pv.cd_vendedor_interno = vi.cd_vendedor 
--  left join Vendedor vi with (nolock)               on pv.cd_vendedor_interno = vi.cd_vendedor 
  left outer join Produto p   with (nolock)          on p.cd_produto=pvi.cd_produto
  left outer join Vendedor ve with (nolock)          on  pv.cd_vendedor = ve.cd_vendedor 
  left outer join Cliente cli with (nolock)          on cli.cd_cliente  = pv.cd_cliente  
  left outer join Grupo_Produto_Custo gpc            on gpc.cd_grupo_produto = pvi.cd_grupo_produto 
  left outer join Processo_Producao pp with (nolock) on pp.cd_pedido_venda = pvi.cd_pedido_venda and 
                                                        pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  left outer join Produto_Saldo ps with (nolock)     on ps.cd_produto      = pvi.cd_produto and
                                                        ps.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                             then @cd_fase_produto 
                                                                             else p.cd_fase_produto_baixa end 
  left outer join Fase_Produto fp with (nolock)      on fp.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                             then @cd_fase_produto 
                                                                             else p.cd_fase_produto_baixa end 
  left outer join Status_Processo sp with (nolock) on pp.cd_status_processo = sp.cd_status_processo
  left outer join Servico s          with (nolock) on s.cd_servico          = pvi.cd_servico

  LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                         nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda

where
  IsNull(pvi.cd_pedido_venda,0) = ( case when @cd_pedido = 0 then
                                    IsNull(pvi.cd_pedido_venda,0) else 
                                    @cd_pedido end ) and
   (pvi.dt_item_pedido_venda between ( case when @cd_pedido = 0 then
                                        @dt_inicial else 
                                        pvi.dt_item_pedido_venda end ) and
                                      ( case when @cd_pedido = 0 then
                                        @dt_final else 
                                        pvi.dt_item_pedido_venda end )
                                      ) and
  (IsNull(p.ic_processo_produto,
   IsNull(gpc.ic_processo_grupo_produto,
   Isnull(s.ic_processo_servico,'N'))) = 'S') and
-- ((IsNull(p.ic_processo_produto,IsNull(gpc.ic_processo_grupo_produto,'N')) = 'S')) and
  -- Assim, vou ter que filtrar por tipo de pedido ou seja:
  -- A - Só vou trazer os em abertos ou com saldo maior que 0 ..
  -- Diferente disso, trarei todos, pois Saldo é sempre maior que ele - 1
  -- Daniel C. Neto. - 01/06/2004
  ( IsNull(pvi.qt_saldo_pedido_venda,0) > ( case when @ic_tipo_filtro = 'A' then
                                            0 else IsNull(pvi.qt_saldo_pedido_venda,0) - 1
                                            end ) ) --and
  and 
  isnull(pvi.cd_produto_servico,0)=0
  --Kit
--  (IsNull(pvi.ic_kit_grupo_produto,'N') = 'N') 

--order by pvi.dt_item_pedido_venda desc
--order by Prazo desc

Union

-- Trazer os itens que estão em composição de item de pedido de venda que
-- são produzidos

select --distinct
  pvi.qt_saldo_pedido_venda,
  pv.cd_pedido_venda, 
  pvi.cd_item_pedido_venda,
  pvc.cd_id_item_pedido_venda,         -- acrescentar à outra selec para fazer o union
  pvi.dt_item_pedido_venda, 
 (pvi.qt_saldo_pedido_venda * pvc.qt_item_produto_comp) as qt_saldo_pedido_venda, 
  pvi.dt_entrega_vendas_pedido,
  pvi.dt_entrega_fabrica_pedido,
  pvi.dt_reprog_item_pedido,
  pvc.vl_item_comp_pedido as vl_unitario_item_pedido,
--  pvi.vl_unitario_item_pedido, 
--  pvi.nm_produto_pedido, 
--  pvi.nm_fantasia_produto,
--   case 
--     when pvi.cd_servico > 0 then
--       cast(pvi.ds_produto_pedido_venda as varchar(50))
--     else
--       p.nm_produto
--   end as nm_produto_pedido,
  case 
    when isnull(pvi.cd_servico,0) > 0 then 
      case 
        when cast(pvi.ds_produto_pedido_venda as varchar(50)) <> '' then 
          cast(pvi.ds_produto_pedido_venda as varchar(50)) 
        else pvi.nm_produto_pedido
      end
    else IsNull(pvi.nm_produto_pedido, p.nm_produto)
  End as nm_produto_pedido,
  pvc.nm_fantasia_produto,
  ve.nm_fantasia_vendedor AS nm_fant_ve, 
  vi.nm_fantasia_vendedor AS nm_fant_vi,
  case when (isnull(pvi.qt_saldo_pedido_venda,0) = 0) then
    0  
  else
    Datediff(d,pv.dt_pedido_venda,GetDate()) end as 'Prazo',

  case when (isnull(pvi.dt_entrega_vendas_pedido,'')=''  or
             isnull(pvi.qt_saldo_pedido_venda,0) = 0) then
    0  
  else
    Datediff(d, GetDate(), pvi.dt_entrega_vendas_pedido) end as 'Atraso',

  cli.nm_fantasia_cliente,
--  (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as 'VlrTotal',
  (pvc.vl_item_comp_pedido * (pvc.qt_item_produto_comp * pvi.qt_saldo_pedido_venda)) as 'VlrTotal',
  pvi.ic_orcamento_pedido_venda                            as 'Orcado',

  case when 
    Datediff(d, GetDate(), pvi.dt_entrega_vendas_pedido) < @qt_dia_aguardo
    and isnull(pvi.qt_saldo_pedido_venda,0) > 0  then 'S' 
  else
    'N' end as 'Vencido',

  case when 
    getDate() > pvi.dt_entrega_vendas_pedido and IsNull(pvi.qt_saldo_pedido_venda,0) > 0 then 'S'
  else 'N'end as 'Atrasado',

  case when 
    pvi.dt_cancelamento_item is null then 'N' 
  else
    'S' end as 'Cancelado',
  case when 
    exists (select top 1 x.cd_produto
            from Produto_Producao x
            where x.cd_produto = pvc.cd_produto) then 'S'
--            where x.cd_produto = pvi.cd_produto) then 'S' 
  else
    'N' end as 'Processo', 
  case when 
    (IsNull(pvi.qt_saldo_pedido_venda,0) = 0) and (isnull(pvi.dt_cancelamento_item,'') ='') then 'S' 
  else 
    'N' end as 'Faturado',
  case when 
    pv.dt_credito_pedido_venda is null then 'S' 
  else 
    'N' end as 'Credito_Nao_Lib',

  case when
   isnull(pvi.ic_desconto_item_pedido,'N') = 'S' and pvi.dt_desconto_item_pedido is null then 'S'
  else
    'N'
  end as 'Desconto_Nao_Lib',

  pvi.cd_grupo_produto,
  IsNull(p.ic_processo_produto, gpc.ic_processo_grupo_produto) as 'GeraProcesso',

  case when isnull(pp.cd_processo,0)=0 then
    'N'
  else
    'S' end as 'Processo_Fabricacao',

  case when 
     exists ( select top 1 ni.cd_pedido_venda
              from
                Nota_Saida_Item ni
              where
                ni.cd_pedido_venda      = pvi.cd_pedido_venda      and
                ni.cd_item_pedido_venda = pvi.cd_item_pedido_venda and             
                ni.ic_status_item_nota_saida = 'D') Then 'S'
--              order by
--                ni.dt_cancel_item_nota_saida desc ) then 'S'
   else
     'N' end as 'Devolucao',

  pp.cd_processo,
  pp.dt_processo,
  ci.cd_consulta, 
  ci.cd_item_consulta, 
  vnd.nm_vendedor,
  pp.nm_processista,
  case when isnull(p.cd_fase_produto_baixa,0)=0 then @cd_fase_produto 
                                                else p.cd_fase_produto_baixa end as 'cd_fase_produto',
  ps.qt_saldo_reserva_produto as 'Saldo',
  ps.qt_minimo_produto        as 'EstoqueMinimo',
  fp.nm_fase_produto          as 'Fase',
  case when pvi.cd_produto>0 then
       case when ps.qt_saldo_reserva_produto<0 or 
                 ps.qt_saldo_reserva_produto<=isnull(ps.qt_minimo_produto,0) 
       then abs(ps.qt_saldo_reserva_produto)+isnull(ps.qt_minimo_produto,0)
       else 0.00 end 
  else pvi.qt_item_pedido_venda end  as 'QtdProducao',                                         
  sp.nm_status_processo,
  pp.dt_fimprod_processo,
  case sp.cd_status_processo 
    When 5
      Then 'S'
    Else 'N'
  End as 'ProcessoEncerrado',
  p.cd_mascara_produto,
  p.cd_desenho_produto,
  p.cd_rev_desenho_produto,
  isnull(pp.ic_libprog_processo,'N') as 'Liberado',
  ReqCompra = ( select top 1 cd_requisicao_compra from Requisicao_Compra_Item
                where cd_pedido_venda = pvi.cd_pedido_venda and
                      cd_item_pedido_venda = pvi.cd_item_pedido_venda order by cd_requisicao_compra desc ),
  pvi.nm_observacao_fabrica1,
  pvi.nm_observacao_fabrica2,

  --Dados do Faturamento
  --nsi.cd_nota_saida,

  nsi.cd_identificacao_nota_saida as cd_nota_saida,
  nsi.dt_nota_saida,
  nsi.dt_saida_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.qt_item_nota_saida,
  nsi.qt_devolucao_item_nota,
  nsi.qt_item_nota_saida as qt_faturada


FROM
  Pedido_Venda pv                   with (nolock)
  inner join Pedido_Venda_Item pvi  with (nolock)  on pv.cd_pedido_venda = pvi.cd_pedido_venda 
  left outer join Consulta cns      with (nolock)      on pvi.cd_consulta = cns.cd_consulta
  left outer join vendedor vnd      with (nolock)      on cns.cd_vendedor_interno = vnd.cd_vendedor
  left outer join consulta_itens ci with (nolock) on pvi.cd_consulta = ci.cd_consulta and
                                                     pvi.cd_item_consulta = ci.cd_item_consulta
     
  inner join Vendedor vi            with (nolock)               on pv.cd_vendedor_interno = vi.cd_vendedor 
  inner join Pedido_Venda_Composicao pvc with (nolock) on pvi.cd_pedido_venda = pvc.cd_pedido_venda and
                                                     pvi.cd_item_pedido_venda = pvc.cd_item_pedido_venda
--  left outer join Produto p with (nolock)            on p.cd_produto=pvi.cd_produto
  left outer join Produto p with (nolock)               on p.cd_produto = pvc.cd_produto
  left outer join Vendedor ve with (nolock)             on  pv.cd_vendedor = ve.cd_vendedor 
  left outer join Cliente cli with (nolock)             on cli.cd_cliente  = pv.cd_cliente  
  left outer join Grupo_Produto_Custo gpc with (nolock) on gpc.cd_grupo_produto = p.cd_grupo_produto 
  left outer join Processo_Producao pp with (nolock)    on pp.cd_pedido_venda = pvi.cd_pedido_venda and 
                                                           pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
                                                           pp.cd_id_item_pedido_venda = pvc.cd_id_item_pedido_venda
--  left outer join Produto_Saldo ps with (nolock)     on ps.cd_produto      = pvi.cd_produto and
  left outer join Produto_Saldo ps with (nolock  )     on ps.cd_produto      = pvc.cd_produto and
                                                          ps.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                             then @cd_fase_produto 
                                                                             else p.cd_fase_produto_baixa end 
  left outer join Fase_Produto fp with (nolock)      on fp.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                             then @cd_fase_produto 
                                                                             else p.cd_fase_produto_baixa end 
  left outer join Status_Processo sp with (nolock) on pp.cd_status_processo = sp.cd_status_processo
  left outer join Servico s          with (nolock) on s.cd_servico          = pvi.cd_servico
  LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                         nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda

where
  --Pedido
  IsNull(pvi.cd_pedido_venda,0) = ( case when @cd_pedido = 0 then
                                    IsNull(pvi.cd_pedido_venda,0) else 
                                    @cd_pedido end ) and
  --Item
   (pvi.dt_item_pedido_venda between ( case when @cd_pedido = 0 then
                                        @dt_inicial else 
                                        pvi.dt_item_pedido_venda end ) and
                                      ( case when @cd_pedido = 0 then
                                        @dt_final else 
                                        pvi.dt_item_pedido_venda end )
                                      ) and

  --Verifica se o Produto ou Grupo de produto é Executado Processo de Fabricação 
  
  (IsNull(p.ic_processo_produto,
   IsNull(gpc.ic_processo_grupo_produto,
   Isnull(s.ic_processo_servico,'N'))) = 'S') and

  --Saldo do Item do pedido de Venda
  ( IsNull(pvi.qt_saldo_pedido_venda,0) > ( case when @ic_tipo_filtro = 'A' then
                                            0 else IsNull(pvi.qt_saldo_pedido_venda,0) - 1
                                            end ) ) and
  --Kit
  (IsNull(pvi.ic_kit_grupo_produto,'N') = 'S')
  and 
  isnull(pvi.cd_produto_servico,0)=0

--order by Prazo desc
order by 13 desc

