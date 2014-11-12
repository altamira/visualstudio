
-------------------------------------------------------------------------------
--sp_helptext pr_posicao_consumo_produto
-------------------------------------------------------------------------------
--pr_posicao_consumo_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Posição de Consumo do Produto
--Data             : 22.10.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_posicao_consumo_produto
@cd_produto      int      = 0,
@dt_base         datetime = '',
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_fase_produto int = 0

as

declare @cd_fase_produto_padrao int

select
  @cd_fase_produto_padrao = isnull(pc.cd_fase_produto,0)
from
  parametro_comercial pc with (nolock)
where
  pc.cd_empresa = dbo.fn_empresa()

select
  p.cd_produto,

  isnull(( select sum( qt_item_pedido_venda )
    from
     vw_venda_bi vw 
    where
     vw.cd_produto = p.cd_produto and
     vw.dt_pedido_venda = @dt_base ),0)                        as qt_venda_diaria,

  isnull(( select sum( qt_item_pedido_venda )
    from
     vw_venda_bi vw 
    where
     vw.cd_produto = p.cd_produto and
     vw.dt_pedido_venda between @dt_inicial and @dt_final ),0) as qt_venda_mensal,

  isnull(( select sum( qt_devolucao_item_nota )
    from
     vw_faturamento_devolucao vw 
    where
     vw.cd_produto = p.cd_produto and
     vw.dt_restricao_item_nota = @dt_base ),0)                       as qt_devolucao_diaria,

  isnull(( select sum( qt_devolucao_item_nota )
    from
     vw_faturamento_devolucao vw 
    where
     vw.cd_produto = p.cd_produto and
     vw.dt_restricao_item_nota between @dt_inicial and @dt_final  ),0)                    as qt_devolucao_mensal,

  (select max( dt_pedido_venda )
    from
     vw_venda_bi vw 
    where
     vw.cd_produto = p.cd_produto )   as dt_maior_venda,

  (select min( dt_pedido_venda )
    from
     vw_venda_bi vw 
    where
     vw.cd_produto = p.cd_produto )    as dt_menor_venda,

  isnull(( select min( qt_item_pedido_venda )
    from
     vw_venda_bi vw 
    where
     vw.cd_produto = p.cd_produto),0)  as qt_menor_venda,

  isnull(( select max( qt_item_pedido_venda )
    from
     vw_venda_bi vw 
    where
     vw.cd_produto = p.cd_produto),0)  as qt_maior_venda

into
  #Aux_Produto

from
  Produto p                         with (nolock) 
where
  p.cd_produto            = case when @cd_produto = 0 then p.cd_produto else @cd_produto end 


select 
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  p.nm_marca_produto,
  p.qt_leadtime_compra,    --Tempo de Compra do Produto
  p.vl_produto,            --Preço de Venda

  a.qt_venda_diaria,
  a.qt_venda_mensal,
  a.qt_devolucao_diaria,
  a.qt_devolucao_mensal,

  0.0000                   as qt_giro_diario,
  0.0000                   as qt_giro_semanal,
  0.0000                   as qt_giro_mensal,

  ps.qt_saldo_reserva_produto,
  ps.qt_saldo_atual_produto,
  ps.qt_minimo_produto,
  ps.qt_maximo_produto,
  
  0                         as qt_duracao_estoque,
  0.0000                    as qt_compra_diaria,
  0.0000                    as qt_sugestao_compra,

  a.qt_maior_venda,
  a.qt_menor_venda,

  a.dt_maior_venda,
  a.dt_menor_venda,

  (select count(pf.cd_fornecedor)
   from
     fornecedor_produto pf
   where
     pf.cd_produto = p.cd_produto )                         as qt_fornecedor,

  pc.vl_custo_produto, 

  margem = (pc.vl_custo_produto/p.vl_produto),

  isnull(( select top 1  qt_item_nota_entrada
    from
     vw_recebimento_entrada vw 
    where
     vw.cd_produto = p.cd_produto 
    order by 
     dt_receb_nota_entrada desc ),0)                      as qt_ultima_compra,

  isnull(( select top 1  vl_item_nota_entrada
    from
     vw_recebimento_entrada vw 
    where
     vw.cd_produto = p.cd_produto 
    order by 
     dt_receb_nota_entrada desc ),0)                      as vl_ultima_compra,

    (select max( dt_receb_nota_entrada )
    from
     vw_recebimento_entrada vw 
    where
     vw.cd_produto = p.cd_produto )      as dt_ultima_compra,

    isnull(( select top 1  nm_fantasia_fornecedor
    from
     vw_recebimento_entrada vw 
    where
     vw.cd_produto = p.cd_produto 
    order by 
     dt_receb_nota_entrada desc ),'') as nm_fornecedor_ultima_compra  
    
from
  Produto p                         with (nolock) 
  left outer join produto_custo  pc with (nolock) on pc.cd_produto        = p.cd_produto
  left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join produto_saldo ps  with (nolock) on ps.cd_produto        = p.cd_produto and
                                                     ps.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                     @cd_fase_produto else p.cd_fase_produto_baixa end
  left outer join fase_produto fp   with (nolock) on fp.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                     @cd_fase_produto else p.cd_fase_produto_baixa end
  left outer join #Aux_Produto a    with (nolock) on a.cd_produto = p.cd_produto                                                           
where
  p.cd_produto            = case when @cd_produto = 0 then p.cd_produto else @cd_produto end and
  p.cd_fase_produto_baixa = case when @cd_fase_produto = 0 then p.cd_fase_produto_baixa else @cd_fase_produto end
  

--select * from fornecedor_produto where cd_produto = 263
--select * from produto_saldo
--select * from produto_compra
--select * from produto

