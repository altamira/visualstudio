
CREATE PROCEDURE pr_consulta_produto_com_arvore

as

Select a.cd_produto_pai           as 'CodigoProduto', 
       max(b.cd_mascara_produto)  as 'Mascara',  
       max(b.nm_fantasia_produto) as 'NomeFantasia',
       max(b.nm_produto)          as 'Descricao'
from
  Produto_Composicao a
  Left Join Produto b 
  On a.cd_produto_pai = b.cd_produto

group by a.cd_produto_pai 
order by max(b.nm_fantasia_produto)

