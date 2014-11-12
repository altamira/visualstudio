
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_aberto_produto_carteira
-------------------------------------------------------------------------------
--pr_mapa_aberto_produto_carteira
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa em Aberto de Produtos em Carteira
--Data             : 22.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_mapa_aberto_produto_carteira
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

declare @cd_fase_produto int
set @cd_fase_produto = 0

select 
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial pc with (nolock)
where
  pc.cd_empresa = dbo.fn_empresa()

--select * from vw_venda_bi

select
  vw.cd_produto,
  vw.cd_mascara_produto,
  vw.nm_fantasia_produto,
  vw.nm_produto,
  vw.sg_unidade_medida,
  sum(vw.qt_saldo_pedido_venda)                               as qt_saldo_pedido_venda,
  sum(vw.qt_saldo_pedido_venda * vw.vl_unitario_item_pedido ) as vl_total,
  count(vw.cd_cliente)                                        as qt_cliente,
  max(isnull(ps.qt_saldo_reserva_produto,0))                  as qt_saldo_reserva_produto --Disponível

--select * from produto_saldo
  
   
from
  vw_venda_bi vw                   with (nolock)
  inner join produto p             with (nolock) on p.cd_produto       = vw.cd_produto
  left outer join produto_saldo ps with (nolock) on ps.cd_produto      = p.cd_produto and
                                                    ps.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0
                                                                         then @cd_fase_produto 
                                                                         else p.cd_fase_produto_baixa end
where
  vw.dt_pedido_venda between @dt_inicial and @dt_final

group by
  vw.cd_produto,
  vw.cd_mascara_produto,
  vw.nm_fantasia_produto,
  vw.nm_produto,
  vw.sg_unidade_medida
order by
  vw.nm_fantasia_produto

