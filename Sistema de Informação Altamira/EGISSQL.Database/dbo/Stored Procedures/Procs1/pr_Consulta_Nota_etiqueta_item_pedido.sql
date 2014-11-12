
-------------------------------------------------------------------------------
--sp_helptext pr_Consulta_Nota_etiqueta_item_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Emissão de Etiqueta para Item do pedido
--Data             : 17.05.2010
-- 11.08.2010 - Ajustes Diversos - Carlos Fernandes
----------------------------------------------------------------------------------------------
create procedure pr_Consulta_Nota_etiqueta_item_pedido
@ic_parametro         int      = 0,
@cd_pedido_venda      int      = 0,
--@cd_pedido_venda_item int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''
--@cd_etiqueta          int      = 0

as

declare @ic_tipo char(1)
declare @dt_hoje datetime

if @ic_parametro = 1 --Não Impressas
begin
  set @ic_tipo      = 'N'   
end

if @ic_parametro = 2 --Reimpressão
begin
  set @ic_tipo      = 'S'
end

------------------------------------------------------------------------------------------
--Itens do pedido
------------------------------------------------------------------------------------------

  -- select * from nota_saida_item
  -- select * from produto
  -- select * from pedido_venda
  -- select ic_etiq_emb_pedido_venda, * from pedido_venda_item where cd_item_pedido_venda = 1

  select
    0                                                        as Selecao,
    pv.cd_pedido_venda                                       as Pedido,
    pv.dt_pedido_venda                                       as Emissao,
    pvi.cd_item_pedido_venda                                 as Item,
    pvi.cd_produto                                           as Cod_Produto,
    pvi.nm_produto_pedido                                    as Produto,
    pvi.nm_fantasia_produto                                  as Fantasia_Produto,
    pvi.ds_produto_pedido_venda                              as Descricao_Produto,

    --select * from vw_destinatario

    --ns.nm_fantasia_nota_saida                                as Destinatario,
    vw.nm_fantasia                                           as Destinatario,
    vw.nm_cidade                                             as Cidade_Nota_Saida_Pedido,
    vw.sg_estado                                             as estado,


    pv.ic_etiq_emb_pedido_venda                              as Etiqueta_Pedido_Venda,
    '('+rtrim(ltrim(vw.cd_ddd))+')-'+vw.cd_telefone                        as Telefone,
    -- isnull(pv.vl_total_pedido_venda,0)                      as Total_pedido_venda,
    --Total do Item 
   isnull(pvi.qt_item_pedido_venda,0) * 
   isnull(pvi.vl_unitario_item_pedido,0)                     as Total_Pedido_venda,

     isnull(ns.qt_volume_nota_saida,0)                       as volume,
   
    --Soma da Capacidade da Embalagem
   
    isnull(te.qt_peso_tipo_embalagem,0) +  
    isnull(pvi.qt_bruto_item_pedido,0)                        as PesoBruto,
    isnull(pvi.qt_liquido_item_pedido,0)                      as PesoLiquido,

    --(nsi.qt_item_nota_saida * nsi.qt_bruto_item_nota_saida)  as PesoBruto,
    --(nsi.qt_item_nota_saida * nsi.qt_liquido_item_nota)      as PesoLiquido,

--     ns.nm_fantasia_nota_saida                               as Destinatario,
     pvi.cd_pedido_venda                                      as PedidoVenda,
     pvi.cd_lote_item_pedido                                  as LotePedido,
     p.nm_marca_produto                                       as Marca,
     lp.dt_inicial_lote_produto                               as InicioValidade,
     lp.dt_final_lote_produto                                 as FinalValidade,
     Mensagem = 'Armazenar em lugar fresco e seco, protegido do calor e umidade.',
     isnull(te.qt_unidade_tipo_embalagem,0)                   as qt_capacidade,
     isnull(te.qt_peso_tipo_embalagem,0)                      as qt_peso_embalagem,
 
     case when isnull(te.qt_unidade_tipo_embalagem,0)>0 
     then
      --(nsi.qt_item_nota_saida * nsi.qt_bruto_item_nota_saida)/isnull(te.qt_unidade_tipo_embalagem,0)
       case
         when (pvi.qt_item_pedido_venda)/isnull(te.qt_unidade_tipo_embalagem,0) > cast((pvi.qt_item_pedido_venda)/isnull(te.qt_unidade_tipo_embalagem,0) as int ) then
           cast((pvi.qt_item_pedido_venda)/isnull(te.qt_unidade_tipo_embalagem,0) as int ) +1
         else
           cast((pvi.qt_item_pedido_venda)/isnull(te.qt_unidade_tipo_embalagem,0) as int )
       end 
     else
       1
      --nsi.qt_item_nota_saida
      --pvi.qt_item_pedido_venda
     end                                                     as qt_etiqueta
 
--     nsi.cd_pdcompra_item_pedido                             as pedido_compra,
--     ns.nm_cidade_nota_saida                                 as cidade,
--     @dt_hoje                                                as dt_impressao,    
--     nsi.cd_pedido_venda                                     as Pedido,
--     nsi.cd_item_pedido_venda                                as ItemPedido,
--     ns.nm_razao_social_nota                                 as Razao_Social

--
--   into
--     #etiqueta


-- select * from #etiqueta 

  from
    Pedido_Venda_item pvi             with (nolock) 
--    inner join Pedido_Venda_Item pvi  with (nolock) on pvi.cd_pedido_venda    = pv.cd_pedido_venda

    left outer join Produto    p      with (nolock) on p.cd_produto            = pvi.cd_produto
    left outer join Lote_Produto lp   with (nolock) on lp.nm_ref_lote_produto  = pvi.cd_lote_item_pedido
    left outer join Tipo_Embalagem te with (nolock) on te.cd_tipo_embalagem    = p.cd_tipo_embalagem
    left outer join pedido_venda pv   with (nolock) on pv.cd_pedido_venda      = pvi.cd_pedido_venda
    left outer join nota_saida ns     with (nolock) on ns.cd_pedido_venda      = pv.cd_pedido_venda    
--    left outer join Cliente    c      with (nolock) on c.cd_cliente            = pv.cd_cliente

    left outer join vw_destinatario vw with (nolock) on vw.cd_destinatario      = pv.cd_cliente and
                                                       vw.cd_tipo_destinatario = 1
  where
    pv.cd_pedido_venda       = case when @cd_pedido_venda=0        then pv.cd_pedido_venda       else @cd_pedido_venda                       end and
--    pvi.cd_item_pedido_venda = case when @cd_pedido_venda_item = 0 then pvi.cd_item_pedido_venda else @cd_pedido_venda_item end and
    pv.dt_pedido_venda  between ( case when @cd_pedido_venda=0        then @dt_inicial else pv.dt_pedido_venda end ) and
                                ( case when @cd_pedido_venda=0        then @dt_final   else pv.dt_pedido_venda end )

    and pv.dt_cancelamento_pedido  is null                       --Somente as Nota não Canceladas
    and isnull(pv.ic_etiq_emb_pedido_venda,'N') = @ic_tipo       --Etiquetas não impressas p/ Impressão ou Reimpressão
    and pvi.dt_cancelamento_item is null

  order by 
    pv.cd_pedido_venda, pvi.cd_item_pedido_venda


--select * from pedido_venda_item

