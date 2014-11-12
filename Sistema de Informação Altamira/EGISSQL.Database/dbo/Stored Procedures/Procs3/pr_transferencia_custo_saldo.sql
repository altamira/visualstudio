
create procedure pr_transferencia_custo_saldo
@dt_fechamento datetime
as 

select 
  p.cd_mascara_produto          as 'COD_ITEM'
  , pf.cd_fase_produto          as 'FASECUSTOS'
  , pf.qt_atual_prod_fechamento as 'QUANTIDADE'
  , p.nm_fantasia_produto       as 'COD_ANT'
from
  produto_fechamento pf,
  produto p
where
  pf.dt_produto_fechamento = @dt_fechamento
  and
  p.cd_produto = pf.cd_produto
 
