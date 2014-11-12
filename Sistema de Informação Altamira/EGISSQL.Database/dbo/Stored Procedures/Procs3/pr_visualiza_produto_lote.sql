
-------------------------------------------------------------------------------
--pr_visualiza_produto_lote
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--                 : 05.05.2005 - Incluído a Descrição do produto
--                 : 07.05.2005 - Incluído o Saldo da Reserva - Carlos Fernandes
--                 : 22.10.2005 - Acerto da Quantidade/Lote - Carlos Fernandes
-- 18.11.2010 - Ajustes Diversos - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_visualiza_produto_lote
@cd_produto int
as

select
  p.nm_fantasia_produto                   as Produto,
  p.cd_mascara_Produto                    as Codigo,
  p.nm_produto                            as Descricao,
  lp.nm_ref_lote_produto                  as LoteProduto,
  lpi.qt_produto_lote_produto             as Quantidade,
  lps.qt_saldo_atual_lote                 as Saldo,
  lps.qt_saldo_reserva_lote               as SaldoReserva,
  lp.dt_entrada_lote_produto              as Entrada,
  lp.dt_inicial_lote_produto              as InicioValidade,
  lp.dt_final_lote_produto                as FinalValidade,
  cast ( getdate() - 
         lp.dt_final_lote_produto as int) as Dias,
  lpi.nm_obs_item_lote_produto            as Observacao

from
  Lote_Produto_Item lpi                  with (nolock) 
  left outer join Lote_produto lp        with (nolock) on lp.cd_lote_produto  = lpi.cd_lote_produto
  left outer join Lote_produto_Saldo lps with (nolock) on lps.cd_lote_produto = lpi.cd_lote_produto and
                                                          lps.cd_produto      = lpi.cd_produto
  left outer join Produto p              with (nolock) on p.cd_produto        = lpi.cd_produto

where
  @cd_produto = lpi.cd_produto         and
  isnull(lp.nm_lote_produto,'') <> ''  and 
  isnull(lps.qt_saldo_atual_lote,0)>0

order by
  lp.dt_final_lote_produto,
  lp.dt_entrada_lote_produto

