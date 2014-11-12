
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_faturamento_produto_abisolo
-------------------------------------------------------------------------------
--pr_consulta_faturamento_produto_abisolo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta do Faturamento de Produtos para o Abisolo
--Data             : 05.04.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_faturamento_produto_abisolo
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from vw_faturamento

--select

select
  --p.cd_produto,
  --p.nm_fantasia_produto,
  --p.nm_produto,

  a.nm_classificacao_abisolo              as Classificacao,
  sum( vw.qt_item_nota_saida )            as Quantidade,
  sum( vw.vl_unitario_item_total )        as Total
from
  Produto p
  inner join vw_faturamento vw             on vw.cd_produto              = p.cd_produto
  inner join status_produto sp             on sp.cd_status_produto       = p.cd_status_produto
  left outer join produto_classificacao pc on pc.cd_produto              = p.cd_produto
  left outer join abisolo_classificacao a  on a.cd_classificacao_abisolo = pc.cd_classificacao_abisolo
  
where
  isnull(sp.ic_bloqueia_uso_produto,'N')='N' and
  p.cd_grupo_produto = 1                     and
  vw.dt_nota_saida between @dt_inicial       and @dt_final
  and isnull(vw.ic_comercial_operacao,'N')='S'
  --Status da Nota Fiscal 
  and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)
  and ( vw.ic_analise_op_fiscal  = 'S' )      --Verifica apenas as operações fiscais selecionadas para o BI
  and ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

group by
  a.nm_classificacao_abisolo

order by
    a.nm_classificacao_abisolo
  



-- select vw.cd_produto,pc.* 
-- from vw_faturamento vw 
--      left outer join produto_classificacao pc on pc.cd_produto = pc.cd_produto
-- where vw.dt_nota_saida between '01/01/2010' and '01/31/2010'

