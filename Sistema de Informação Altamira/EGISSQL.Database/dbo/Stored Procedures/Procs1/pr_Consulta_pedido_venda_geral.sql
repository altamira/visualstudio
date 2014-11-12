
CREATE PROCEDURE pr_Consulta_pedido_venda_geral
-------------------------------------------------------------------------------
--pr_Consulta_pedido_venda_geral
-------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                    2004
------------------------------------------------------------------------------- 
--Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)            : Sandro Campos
-- Banco de Dados       : EGISSQL
-- Objetivo             : Consulta de Pedido de Venda Geral
-- Data                 : 27/04/2002	
-- Atualizado           : 10/03/2003 - Igor Gama 
--                                   - Qdo selecionar o pedido cancelado, ele traz todos os itens abertos e cancelados.
--                                     @ic_parametro : 1-> Header
--	                             - 2-> item
--	                             - 3-> item, não repete o item e traz o campo nota e item da nota com valor zerado
--                                     @cd_status_pedido
--                                     @dt_inicial
--                                     @dt_final
-- 12/06/2003 - Daniel C. Neto - Incluído campos de QtdeCancelado e QtdeAtivado.
-- 04.08.2003 - Fabio - Apresentar o serviço na mesma coluna do produto
-- 25/11/2004 - Incluído loja - Daniel C. Neto.
-- 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- 10/01/2005 - Acerto no parâmetro 4 - Daniel C. Neto.
-- 14/03/2005 - Otimização do Parâmetro 4 - Daniel C. Neto.
-- 09.05.2005 - Mostar o Lote do Produto - Carlos Fernandes
-- 01.06.2005 - Filtro por vendedor: Inclusão do parâmetro @cd_vendedor - Ricardo Vano
-- 08.06.2005 - Verificação - Rafael Santiago
-- 06.04.2006 - Apresentar se o item do pedido de venda já foi reservado pelo montador - Fabio - POLIMOLD
-- 23.03.2009 - Data de Entrega nos itens - Carlos Fernandes
-- 12.03.2010 - Número da Ordem de Produção - Carlos Fernandes 
-- 19.07.2010 - Flag para Pedido Fechado - Carlos Fernandes
-------------------------------------------------------------------------------------------

@ic_parametro        int,  
@cd_vendedor         int = 0,  
@cd_vendedor_interno int = 0,  
@ic_vendedor_interno char(1) = 'N',  
@cd_status_pedido    int,  
@cd_pedido_venda     int,  
@dt_inicial          Datetime,  
@dt_final            Datetime,  
@cd_loja             int = 0   
  
as  
  
  
if @ic_parametro = 1  
begin   

  Select distinct  
    isnull(pv.ic_fechado_pedido,'N') as 'ic_fechado_pedido',
    pv.cd_cliente                    as 'CodCliente',  
    c.nm_fantasia_cliente            as 'Cliente',  
    pv.cd_pedido_venda               as 'Pedido',  
    pv.dt_pedido_venda               as 'Emissao',  
    pv.cd_vendedor                   as 'CodVendedor',    
    pv.cd_status_Pedido              as 'Status',    
    v.nm_fantasia_vendedor           as 'Vendedor',  
    v.nm_fantasia_vendedor           as 'VendedorInterno',  
    pv.ds_cancelamento_Pedido        as 'MotivoCancelamento',  
    pv.dt_cancelamento_Pedido        as 'DataCancelamento',  
    pv.ds_Ativacao_Pedido            as 'MotivoAtivacao',  
    pv.dt_Ativacao_Pedido            as 'DataAtivacao',  
    pv.cd_contato                    as 'CodContato',  
    pv.vl_total_pedido_venda         as 'ValorPedido',  
    cc.nm_contato_cliente            as 'NomeContato',  
    nsi.cd_nota_saida                as 'NF',  
    pvi.cd_om,  

    case IsNull(pvi.cd_om,0)  
      when 0 then 
        0  
      else 
        (Select top 1 qt_item_om from om where cd_om = pvi.cd_om)  
      end as qt_item_om,
    pvi.dt_reservado_montagem

  from Pedido_Venda pv                   with (nolock) 
  Left Outer Join Pedido_Venda_item pvi  with (nolock) 
    On pv.cd_pedido_venda = pvi.cd_pedido_venda  
  Left Join Cliente c                    with (nolock) 
    On pv.cd_cliente = c.cd_cliente  
  Left Join Vendedor v  
    On v.cd_vendedor = pv.cd_vendedor  
  Left Outer Join Tipo_Vendedor tv  
    On tv.cd_tipo_vendedor = v.cd_tipo_vendedor  
  Left Join cliente_contato cc  
    On (pv.cd_cliente = cc.cd_Cliente) and  
       (pv.cd_contato = cc.cd_Contato)  
  Left Outer Join Nota_Saida_Item nsi  
    On pvi.cd_pedido_venda = nsi.cd_pedido_venda and   
       pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda  
  where (pv.dt_pedido_venda between @dt_inicial and @dt_final) and  
       ((pv.cd_status_pedido = @cd_status_pedido) or (@cd_status_pedido = 0)) and -- or (pvi.dt_cancelamento_item is not null) or (pvi.dt_ativacao_item is not null)) and   
       ((pv.cd_pedido_venda = @cd_pedido_venda) or (@cd_pedido_venda = 0)) and    
       (isnull (pv.ic_consignacao_pedido,'N') = 'N') and  
       IsNull(pv.cd_loja,0) = ( case when @cd_loja = 0 then  
                                  IsNull(pv.cd_loja,0) else  
                                  @cd_loja end )   
  order by pv.dt_pedido_venda desc  
end  
    -----------------------------------------------------------------------------------------  
else if @ic_parametro = 2 -- Consulta somente dos Itens do Pedido de Venda  
    -----------------------------------------------------------------------------------------  
begin  
  Select 
    pvi.cd_pedido_venda           as 'PedidoVenda',  
    pvi.cd_produto                as 'CodigoProduto',  
    'CodigoProdutoBaixa' =  case   
                              when p.cd_produto_baixa_estoque is null then  
                                p.cd_produto  
                              else p.cd_produto_baixa_estoque  
                            end,  
    pvi.nm_produto_pedido         as 'DescricaoProduto',  
    pvi.cd_item_pedido_venda      as 'Item',  
    pvi.qt_item_pedido_venda      as 'Qtde',  
    pvi.vl_unitario_item_pedido   as 'Unitario',  
    (pvi.qt_item_pedido_venda *  pvi.vl_unitario_item_pedido)  as 'Venda',  
    pvi.pc_desconto_item_pedido   as 'PercDesconto',  
    pvi.qt_saldo_pedido_venda     as 'QtdeSaldo',  
    pvi.nm_mot_canc_item_pedido   as 'MotivoCancelamento',  
    pvi.dt_cancelamento_item      as 'DataCancelamento',  
    pvi.nm_mot_ativ_item_pedido   as 'MotivoAtivacao',  
    pvi.dt_ativacao_item          as 'DataAtivacao',  
    pvi.dt_entrega_vendas_pedido  as 'Comercial',  
    pvi.dt_entrega_fabrica_pedido as 'Fabrica',  
    pvi.dt_reprog_item_pedido     as 'Reprogramacao',  
    pvi.qt_dia_entrega_pedido     as 'PrazoEntrega',  
    pvi.cd_lote_item_pedido,         
    ProdCusto.ic_peps_produto     as 'Peps',
    case  
      when ic_pedido_venda_item = 'P' then  
        pvi.nm_fantasia_produto  
      else  
       (Select top 1 nm_servico from Servico where cd_servico = pvi.cd_servico)  
    end as 'fantasiaproduto',  
    isnull( ( select top 1 
                'S'   
              from 
                Nota_Saida_Item   
              where   
                cd_pedido_venda      = pvi.cd_pedido_venda and  
                cd_item_pedido_venda = pvi.cd_item_pedido_venda and  
                IsNull(cd_status_nota,0) not in(4,7) ),'N' ) as 'ic_contido_em_nf',  
    0 as ic_selecionado,  
    nsi.cd_nota_saida            as 'NF',  
    nsi.cd_item_nota_saida       as 'NFItem',  
    pvi.qt_cancelado_item_pedido as 'QtdeCancelado',  
    pvi.qt_ativado_pedido_venda  as 'QtdeAtivado',  
    pvi.cd_om,  
    case IsNull(pvi.cd_om,0)  
      when 0 then 
        0  
      else 
        (Select top 1 qt_item_om from om where cd_om = pvi.cd_om)  
    end as qt_item_om,  
    pvi.ic_kit_grupo_produto,
    pvi.dt_reservado_montagem,
    isnull(pvi.ic_baixa_composicao_item,isnull(p.ic_baixa_composicao_prod,'N')) as ic_baixa_composicao_item

  from Pedido_Venda_item pvi  with (nolock) 
  Left Join Pedido_venda pv   with (nolock) 
    On pv.cd_pedido_venda = pvi.cd_pedido_venda  
  Left Join Produto P  
    On P.cd_Produto = pvi.cd_Produto  
  Left Join Produto_Custo ProdCusto  
    On ProdCusto.cd_Produto = pvi.cd_Produto  
  Left Outer Join Nota_Saida_Item nsi  
    On pvi.cd_pedido_venda = nsi.cd_pedido_venda and   
       pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda  
  where    
    (pv.dt_pedido_venda between @dt_inicial and   
                                @dt_final)        and  
    (isnull (pv.ic_consignacao_pedido,'N') = 'N') and  
    (pvi.cd_pedido_venda = @cd_pedido_venda) and  
    IsNull(pv.cd_loja,0) = ( case when @cd_loja = 0 then  
                               IsNull(pv.cd_loja,0) 
                             else  
                               @cd_loja 
                             end )   
  order by pv.dt_pedido_venda desc  

end  
-----------------------------------------------------------------------------------------  
else if @ic_parametro = 3 -- Consulta somente dos Itens do Pedido de Venda  
-----------------------------------------------------------------------------------------  
begin  

  Select 
    pvi.cd_pedido_venda           as 'PedidoVenda',  
    pvi.cd_produto                as 'CodigoProduto',  
    'CodigoProdutoBaixa'          =  case 
                                       when p.cd_produto_baixa_estoque is null then  
                                         p.cd_produto  
                                       else 
                                         p.cd_produto_baixa_estoque  
                                     end,             
    pvi.nm_produto_pedido         as 'DescricaoProduto',  
    pvi.cd_item_pedido_venda      as 'Item',  
    pvi.qt_item_pedido_venda      as 'Qtde',  
    pvi.vl_unitario_item_pedido   as 'Unitario',  
    (pvi.qt_item_pedido_venda *  pvi.vl_unitario_item_pedido)  as 'Venda',  
    pvi.pc_desconto_item_pedido   as 'PercDesconto',  
    pvi.qt_saldo_pedido_venda     as 'QtdeSaldo',  
    pvi.nm_mot_canc_item_pedido   as 'MotivoCancelamento',  
    pvi.dt_cancelamento_item      as 'DataCancelamento',  
    pvi.nm_mot_ativ_item_pedido   as 'MotivoAtivacao',  
    pvi.dt_ativacao_item          as 'DataAtivacao',  
    pvi.dt_entrega_vendas_pedido  as 'Comercial',  
    pvi.dt_entrega_fabrica_pedido as 'Fabrica',  
    pvi.dt_reprog_item_pedido     as 'Reprogramacao',  
    pvi.qt_dia_entrega_pedido     as 'PrazoEntrega',  
    pvi.cd_lote_item_pedido,         
    ProdCusto.ic_peps_produto     as 'Peps',     
    case 
      when ic_pedido_venda_item = 'P' then  
        pvi.nm_fantasia_produto  
      else  
       (Select top 1 nm_servico from Servico where cd_servico = pvi.cd_servico)  
    end as 'fantasiaproduto',  
    isnull( ( Select top 1 
                'S'   
              from 
                Nota_Saida_Item  with (nolock)   
              where   
                cd_pedido_venda      = pvi.cd_pedido_venda and  
                cd_item_pedido_venda = pvi.cd_item_pedido_venda and  
                IsNull(cd_status_nota,0) not in(4,7) ),'N' ) as 'ic_contido_em_nf',  
    0 as ic_selecionado,  
    0                            as 'NF',  
    0                            as 'NFItem',  
    pvi.qt_cancelado_item_pedido as 'QtdeCancelado',  
    pvi.qt_ativado_pedido_venda  as 'QtdeAtivado',  
    pvi.cd_om,  
    case IsNull(pvi.cd_om,0)  
      when 0 then 
        0  
      else 
        (Select top 1 qt_item_om from om where cd_om = pvi.cd_om)  
   end as qt_item_om,  
   pvi.ic_kit_grupo_produto,
   pvi.dt_reservado_montagem,
   isnull(pvi.ic_baixa_composicao_item,isnull(p.ic_baixa_composicao_prod,'N')) as ic_baixa_composicao_item,
   cd_processo = ( select top 1 
                    vw.cd_processo
                   from
                     vw_ordem_producao_pedido_venda vw
                   where
                     pvi.cd_pedido_venda      = vw.cd_pedido_venda and
                     pvi.cd_item_pedido_venda = vw.cd_item_pedido_venda )
                  

  from Pedido_Venda_item pvi  with (nolock)
  Left Join Pedido_venda pv   with (nolock) On pv.cd_pedido_venda = pvi.cd_pedido_venda  
  Left Join Produto P                       On P.cd_Produto = pvi.cd_Produto  
  Left Join Produto_Custo ProdCusto         On ProdCusto.cd_Produto = pvi.cd_Produto  
  where   
    (pvi.cd_pedido_venda = @cd_pedido_venda) and  
     IsNull(pv.cd_loja,0) = ( case 
                                when @cd_loja = 0 then  
                                  IsNull(pv.cd_loja,0) 
                                else  
                                  @cd_loja 
                              end )   
   order by pv.dt_pedido_venda desc  
end  
---------------------------------------------------------------------------------------------------  
else     if @ic_parametro = 4 --Consulta de Pedidos de Vendas  
---------------------------------------------------------------------------------------------------  
begin   
  Select distinct  
      isnull(pv.ic_fechado_pedido,'N') as 'ic_fechado_pedido',
      pv.cd_cliente                as 'CodCliente',  
      c.nm_fantasia_cliente        as 'Cliente',  
      pv.cd_pedido_venda           as 'Pedido',  
      pv.dt_pedido_venda           as 'Emissao',  
      pv.cd_vendedor               as 'CodVendedor',    
      pv.cd_status_Pedido          as 'Status',    
      v.nm_fantasia_vendedor       as 'Vendedor',  
      vi.nm_fantasia_vendedor      as 'VendedorInterno',  
      pv.ds_cancelamento_Pedido    as 'MotivoCancelamento',  
      pv.dt_cancelamento_Pedido    as 'DataCancelamento',  
      pv.ds_Ativacao_Pedido        as 'MotivoAtivacao',  
      pv.dt_Ativacao_Pedido        as 'DataAtivacao',  
      pv.cd_contato                as 'CodContato',  
      pv.vl_total_pedido_venda     as 'ValorPedido',  
      cc.nm_contato_cliente        as 'NomeContato',  
      0                            as 'NF',  
      0 as cd_om,  
      0.00 as qt_item_om  
  from Pedido_Venda pv  with (nolock) 
  Left Join Cliente c  
    On pv.cd_cliente = c.cd_cliente  
  Left Join Vendedor v  
    On v.cd_vendedor = pv.cd_vendedor  
  Left Join cliente_contato cc  
    On (pv.cd_cliente = cc.cd_Cliente) and  
       (pv.cd_contato = cc.cd_Contato)  
  Left Outer Join Tipo_Vendedor tv  
    On tv.cd_tipo_vendedor = v.cd_tipo_vendedor  
  Left Join Vendedor vi  
    On vi.cd_vendedor = pv.cd_vendedor_interno  
  where  
    IsNull(pv.cd_status_pedido,0) = ( case 
                                        when (@cd_status_pedido = 0) and IsNull(pv.cd_status_pedido,0) = 7 then 
                                          IsNull(pv.cd_status_pedido,0) + 1  
                                        when (@cd_status_pedido = 0) and IsNull(pv.cd_status_pedido,0) <> 7 then 
                                          IsNull(pv.cd_status_pedido,0)  
                                        else 
                                          @cd_status_pedido 
                                      end ) and   
    pv.cd_pedido_venda = ( case 
                             when @cd_pedido_venda = 0 then 
                               pv.cd_pedido_venda 
                             else 
                               @cd_pedido_venda 
                           end ) and  
    pv.dt_pedido_venda between ( case 
                                   when @cd_pedido_venda = 0 then 
                                     @dt_inicial 
                                   else 
                                     pv.dt_pedido_venda 
                                 end ) and   
                               ( case 
                                   when @cd_pedido_venda = 0 then 
                                     @dt_final 
                                   else 
                                     pv.dt_pedido_venda 
                                 end ) and  
    IsNull(pv.cd_loja,0)    = ( case 
                                  when @cd_loja = 0 then  
                                    IsNull(pv.cd_loja,0) 
                                  else  
                                    @cd_loja 
                                end ) and            
    isnull(v.cd_vendedor,0) = ( case 
                                  when @cd_vendedor = 0 then 
                                    isnull(v.cd_vendedor,0) 
                                  else 
                                    @cd_vendedor 
                                end ) and  
    isnull(vi.cd_vendedor,0) = ( case 
                                   when @cd_vendedor_interno = 0 then 
                                     isnull(vi.cd_vendedor,0) 
                                   else 
                                     @cd_vendedor_interno 
                                 end )
  order by pv.dt_pedido_venda desc  

end  


