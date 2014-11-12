
CREATE PROCEDURE pr_consulta_produto_componente
--------------------------------------------------------------------------------------------------------------
-- GBS - Global Business Sollution             2003
--------------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)      : Daniel C. Neto 
--Banco de Dados : EgisSql
--Objetivo       : Consultar um produto filho em produtos pais.
--Data           : 10/02/2004
--Atualizado     : 09.12.2005 - Consulta dos Produtos em Processo Padrão - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------

@cd_produto int = 0

as

--Produto - Componente em Composição

select
  pc.cd_produto,
  pc.cd_produto_pai,
  dbo.fn_mascara_produto(pc.cd_produto_pai) as 'cd_mascara_produto',
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  f.nm_fase_produto,
  pc.qt_produto_composicao,
  p.cd_versao_produto,
  0                                         as cd_processo_padrao
into #AuxProd1
from
  Produto_COmposicao pc inner join
  Produto p         on p.cd_produto = pc.cd_produto_pai left outer join
  Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida left outer join
  Fase_Produto f    on f.cd_fase_produto = pc.cd_fase_produto 
where
  pc.cd_produto = @cd_produto
order by
  p.nm_fantasia_produto

--Produto - Componente em Processo Padrão
select
  pc.cd_produto,
  ppc.cd_produto                            as cd_produto_pai,
  dbo.fn_mascara_produto(ppc.cd_produto)    as 'cd_mascara_produto',
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  f.nm_fase_produto,
  pc.qt_produto_processo                    as qt_produto_composicao,
  1                                         as cd_versao_produto,
  ppc.cd_processo_padrao                    
into #AuxProd2
from
  Processo_Padrao_Produto pc 
  left outer join Produto_Producao ppc on ppc.cd_processo_padrao = pc.cd_processo_padrao
  inner join Produto p                 on p.cd_produto           = ppc.cd_produto
  left outer join Unidade_Medida um    on um.cd_unidade_medida   = p.cd_unidade_medida 
  left outer join Fase_Produto f       on f.cd_fase_produto      = pc.cd_fase_produto 
where
  pc.cd_produto = @cd_produto
order by
  p.nm_fantasia_produto

SELECT * FROM #AuxProd1
UNION ALL
( SELECT * FROM #AuxProd2 )

--select * from #AuxProd


