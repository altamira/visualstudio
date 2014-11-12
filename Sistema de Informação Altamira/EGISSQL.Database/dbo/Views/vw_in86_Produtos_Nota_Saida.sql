
CREATE VIEW vw_in86_Produtos_Nota_Saida

--vw_in86_Produtos_Nota_Saida
-------------------------------------------------------------
--GBS - Global Business Solution	                       2004
--Stored Procedure	: Microsoft SQL Server               2004
--Autor(es)		      : André de Oliveira Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Relação de todos os produtos de notas de saída, indiferente do tipo da nota E/S.
--Data			        : 24/03/2004
-------------------------------------------------------------
as

select distinct
  vw.produto,
  p.nm_produto, 
  p.dt_usuario
from
  vw_produto_saida vw

  inner join Produto p
    on p.cd_produto = vw.produto
where
  isnull( vw.produto, 0 ) > 0

