
CREATE PROCEDURE pr_pedidos_fabricacao_pcp

-- 1 = Pedidos, 2 = Itens de 1 pedido
@ic_parametro    int             = 0,
@cd_pedido_venda int             = 0,
-- Data de emissão dos pedidos
@dt_inicial      datetime,
@dt_final        datetime

as

Select
      a.cd_cliente                as 'CodCliente',
      b.nm_fantasia_cliente       as 'Cliente',
      b.cd_ddd                    as 'Ddd',
      b.cd_telefone               as 'Fone',
      a.cd_pedido_venda           as 'Pedido',
      d.cd_item_pedido_venda      as 'Item',
      a.dt_pedido_venda           as 'Emissao',
      d.qt_item_pedido_venda      as 'Qtde',
      d.cd_grupo_produto          as 'Grupo',
      d.qt_saldo_pedido_venda     as 'QtdeSaldo',
     (d.qt_item_pedido_venda *
      d.vl_unitario_item_pedido)  as 'Venda',
      d.dt_entrega_vendas_pedido  as 'Comercial',
      d.dt_entrega_fabrica_pedido as 'Fabrica',
      d.dt_reprog_item_pedido     as 'Reprogramacao',
      d.cd_produto,
      p.nm_fantasia_produto,     
      d.cd_grupo_produto,
      a.cd_vendedor               as 'CodVendedor',  
      c.nm_fantasia_vendedor      as 'Setor',
      a.cd_vendedor_interno       as 'CodVendInterno',
      e.nm_fantasia_vendedor      as 'VendedorInterno',

      -- Tipo do Pedido : 1 = Normal, 2 = Especial
     
      TipoPedido = 
      case when isnull(tp.sg_tipo_pedido,'')<>'' then
          tp.sg_tipo_pedido
      else
         Case when a.cd_tipo_pedido = 1 then 'PV' 
              when a.cd_tipo_pedido = 2 then 'PVE' 
              else Null
         end
      end,
      a.ic_smo_pedido_venda       as 'Smo',

      Descricao = d.nm_produto_pedido,

--      Case when a.cd_tipo_pedido = 1 then
--        (Select max(nm_produto) from produto where cd_produto = d.CD_PRODUTO)
--           when a.cd_tipo_pedido = 2 then  
--        (Select max(nm_produto_pedido_venda) from pedido_venda_item_especial 
--                where cd_pedido_venda = d.CD_PEDIDO_VENDA and
--                      cd_item_pedido_venda = d.CD_ITEM_PEDIDO_VENDA)
--      else Null end,

      Pcp = case when isnull(d.ic_controle_pcp_pedido,'N')='N'  and isnull(p.ic_pcp_produto,'N')='N'
            then  
              Case when isnull(d.cd_produto,0)>0 
              then
               (Select max( isnull(ic_controle_pcp_produto,isnull(ic_pcp_produto,'N')) ) from produto   
                where cd_produto = d.CD_PRODUTO)
              else         
                case when isnull(d.cd_servico,0)>0 and isnull(s.ic_pcp_servico,'N') = 'S' then
                    isnull(s.ic_pcp_servico,'N')
                else                                   
                   --Grupo de Produto
                  (Select max( isnull(ic_controle_pcp_grupo,'N') )   from grupo_produto    
                   where cd_grupo_produto = d.CD_GRUPO_PRODUTO)
                end
              end
            else 
              Case when isnull(p.ic_pcp_produto,'N')='S' then
                p.ic_pcp_produto
              else            
                isnull(d.ic_controle_pcp_pedido,'N')     end
            end,

      Programado = 
      Case when d.dt_entrega_fabrica_pedido is null then 'N' else 'S' end,
      ds_produto_pedido_venda as 'Observacao',
      ds_observacao_fabrica   as 'ObservacaoFabrica',
      nm_observacao_fabrica1  as 'Obs1',
      nm_observacao_fabrica2  as 'Obs2',
      f.nm_condicao_pagamento as 'CondicaoPagamento',
      GeraReqCompra = 
      case when gp.ic_especial_grupo_produto = 'S' and
                gp.ic_controle_pcp_grupo     = 'S' and 
                gp.ic_processo_grupo_produto = 'N' then
      'S' else 'N' end,
      a.ic_lista_pcp_pedido_venda as 'ProgramadoPcp',
      d.cd_consulta,
      d.cd_item_consulta,
      d.qt_liquido_item_pedido    as PesoLiquido,
      d.qt_bruto_item_pedido      as PesoBruto,

--       ( select max(cd_nota_saida) from Nota_Saida_Item where cd_pedido_venda      = d.cd_pedido_venda and
--                                                         cd_item_pedido_venda = d.cd_item_pedido_venda and
--                                                         dt_restricao_item_nota is null ) as cd_nota_saida,

      nsi.cd_identificacao_nota_saida as cd_nota_saida,

      pp.cd_processo,
      isnull(d.ic_manut_mapa_producao,'S') as Mapa,
      d.cd_motivo_reprogramacao,
      pp.cd_processo_padrao

-------
into #TmpPedidosGeral
-------
from
    Pedido_Venda a                      with (nolock)

    Left Join Cliente b                  with (nolock) On a.cd_cliente            = b.cd_cliente
    Left Join Vendedor c                 with (nolock) On a.cd_vendedor           = c.cd_vendedor 
    Left Join Pedido_Venda_Item d        with (nolock) On a.cd_pedido_venda       = d.cd_pedido_venda 
    Left Join Vendedor e                 with (nolock) On a.cd_vendedor_interno   = e.cd_vendedor 
    Left Join Condicao_Pagamento f       with (nolock) On a.cd_condicao_pagamento = f.cd_condicao_pagamento
    Left Outer Join Grupo_Produto gp     with (nolock) on d.cd_grupo_produto      = gp.cd_grupo_produto
    Left Outer Join Produto p            with (nolock) on p.cd_produto            = d.cd_produto
    Left Outer Join Tipo_Pedido tp       with (nolock) on tp.cd_tipo_pedido       = a.cd_tipo_pedido    
    Left Outer Join Processo_Producao pp with (nolock) on pp.cd_pedido_venda      = d.cd_pedido_venda and
                                                          pp.cd_item_pedido_venda = d.cd_item_pedido_venda and
                                                          isnull(pp.cd_produto,0) = isnull(d.cd_produto,0)

    Left Outer Join Servico s            with (nolock) on s.cd_servico            = d.cd_servico

    LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = d.cd_pedido_venda      and
                                                           nsi.cd_item_pedido_venda = d.cd_item_pedido_venda
--select * from processo_producao

    where
      a.cd_pedido_venda =
      case 
        when @ic_parametro = 1 and @cd_pedido_venda>0 
        then
          case when @cd_pedido_venda = 0 then a.cd_pedido_venda else @cd_pedido_venda end    
        else
          a.cd_pedido_venda
        end
                                                    and
       a.dt_pedido_venda between 
       (case
         when (@ic_parametro = 1 and @cd_pedido_venda>0 ) or (@ic_parametro = 2 and @cd_pedido_venda>0)
         then
           a.dt_pedido_venda 
         else
          @dt_inicial end ) and @dt_final                      and
       d.dt_cancelamento_item is null                          and  
       isnull(a.ic_consignacao_pedido,'N') = 'N'               
--and
--      (d.qt_item_pedido_venda * d.vl_unitario_item_pedido) > 0 
 
-- Seleciona somente os pedidos Pcp e se está selecionando Pedidos ou Itens

-----------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta todos os pedidos do período 
-----------------------------------------------------------------------------------------
begin
--   select *    from #TmpPedidosGeral

   select Pedido,
          Max(Cliente)     as 'Cliente', 
          Max(Setor)       as 'Setor', 
          Max(Smo)         as 'Smo', 
          Max(Emissao)     as 'Emissao', 
          Max(TipoPedido)  as 'TipoPedido',
          Count(*)         as 'TotItens',
          Sum(Venda)       as 'ValorTotal',
          Especial = 
          Case when Max(TipoPedido) = 'PV'  then 'Não'
               when Max(TipoPedido) = 'PVE' then 'Sim'
          else '' end,
          Max(CondicaoPagamento) as 'CondicaoPagamento',
          Max(Grupo)             as 'Grupo',
          Max(ProgramadoPcp)     as 'ProgramadoPcp',
          Max(Mapa)              as 'Mapa' 

   from #TmpPedidosGeral
   where
     Pedido = case when @cd_pedido_venda = 0 then Pedido else @cd_pedido_venda end and
     isnull(Pcp,'N') = 'S' 
     --and Mapa            = 'S'

   group by Pedido
   order by Emissao
end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Consulta todos os itens de um pedido selecionado
-----------------------------------------------------------------------------------------

   select Pedido,
          Item,
          CodCliente, 
          Cliente, 
          DDD, Fone,
          Comercial,
          Fabrica,
          Reprogramacao,
          CodVendedor,
          Setor, 
          CodVendInterno, 
          VendedorInterno,
          Emissao, 
          Qtde,
          QtdeSaldo,
          Venda,
          Grupo,
          GeraReqCompra,
          Especial = 
          Case when TipoPedido = 'PV' then 'N'
               when TipoPedido = 'PVE' then 'S'
          else '' end,
          Programado,
          Unidade =  
          Case when TipoPedido = 'PV' then
            (Select max(a.sg_unidade_medida) from unidade_medida a, produto b
                    where b.cd_produto = CD_PRODUTO and
                          b.cd_unidade_medida = a.cd_unidade_medida)
               when TipoPedido = 'PVE' then  
            (Select max(a.sg_unidade_medida) from unidade_medida a, grupo_produto b
                    where b.cd_grupo_produto = CD_GRUPO_PRODUTO and
                          b.cd_unidade_medida = a.cd_unidade_medida)
          else '' end,
          Descricao,
          Observacao, 
          ObservacaoFabrica,
          Obs1,
          Obs2,
          CondicaoPagamento,
          cd_produto,
          cd_grupo_produto,
          nm_fantasia_produto,
          cd_consulta,
          cd_item_consulta,
          PesoLiquido,
          PesoBruto,
          cd_nota_saida,
          cd_processo,
          Mapa,
          cd_processo_padrao

   from #TmpPedidosGeral
   where isnull(Pcp,'N') = 'S'      and
         --Mapa            = 'S'      and

         Pedido = @cd_pedido_venda
   order by Item

