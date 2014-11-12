
-------------------------------------------------------------------------------
--pr_analise_produto_producao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Análise de Produtos para Geração de Ordem de Produção
--Data             : 20.06.2006
--Alteração        : 21.06.2006
--                 : 17/11/2006 - Modificado para pegar a fase de baixa do produto - Daniel C. Neto.
--                 : 10/01/2007 - Correção da duplicação dos produtos da grid - Anderson
------------------------------------------------------------------------------
create procedure pr_analise_produto_producao
@cd_produto      int = 0,
@cd_fase_produto int = 0

as

select
  cast( 0 as int) as ic_selecionado,
  p.cd_produto ,
  gp.cd_grupo_produto,
  gp.nm_grupo_produto,
  fp.nm_fase_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  p.qt_peso_liquido,
  p.qt_peso_bruto,
  p.qt_leadtime_produto,
  --p.qt_leadtime_compra,

  --Dados da Tabela Produto Saldo------------------------------------------------------

  isnull(ps.qt_saldo_reserva_produto,0) as 'Saldo',
  isnull(ps.qt_producao_produto,0)      as 'Producao',
  isnull(ps.qt_minimo_produto,0)        as 'Minimo',

  --Verifica se o Produto possui Processo de Produção Padrão---------------------------  
  Processo = ( case when 
                    ( select top 1 isnull(ppp.cd_processo_padrao,0) from Produto_Producao ppp where ppp.cd_produto = p.cd_produto ) > 0 
               then 'S' else 'N' end ),

 --Código do Processo Padrão
 ( select top 1 isnull(ppp.cd_processo_padrao,0) from Produto_Producao ppp where ppp.cd_produto = p.cd_produto ) as cd_processo_padrao

into
  #AnaliseProducaoProduto
  
from
  Produto p
  left outer join Grupo_Produto gp            on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join Unidade_Medida um           on um.cd_unidade_medida = gp.cd_unidade_medida
  left outer join Produto_Saldo ps            on ps.cd_produto        = p.cd_produto and
                                                 ps.cd_fase_produto   = p.cd_fase_produto_baixa
  left outer join Fase_Produto  fp            on fp.cd_fase_produto   = p.cd_fase_produto_baixa

where
  p.cd_produto       = case when @cd_produto      = 0 then p.cd_produto       else @cd_produto end      and
  ps.cd_fase_produto = case when @cd_fase_produto = 0 then ps.cd_fase_produto else @cd_fase_produto end and
  --Verificar qual o flag correto
  isnull(p.ic_controle_pcp_produto,'N') = 'S' and
  isnull(p.ic_pcp_produto,'N')          = 'S' and
  isnull(p.ic_producao_produto,'N')     = 'S' and
  --Verificar se é necessário
  isnull(p.ic_processo_produto,'N')     = 'S'
  
order by
  p.cd_grupo_produto,
  p.nm_fantasia_produto

--select * from produto
--select * from produto_saldo


select
  a.*,
  abs( a.Producao + a.Saldo ) as '1',
  --Cálculo da Quantidade Sugerida para Produção---------------------------------------
  case 
    when a.Saldo <= 0 then case when ( abs( a.Saldo ) - a.Producao ) + Minimo > 0 then ( abs(a.Saldo) - a.Producao ) else 0.00 end
    else case when a.Minimo > 0 and a.Minimo - ( a.Producao + a.Saldo ) <= a.Saldo then ( a.Producao + a.Saldo ) - a.Minimo else 0.00 end
  end as Sugestao

from
  #AnaliseProducaoProduto a
order by
  a.cd_grupo_produto,
  a.nm_fantasia_produto

--select * from produto_saldo where cd_produto = 391
--select * from processo_padrao_produto
--select * from produto_producao

