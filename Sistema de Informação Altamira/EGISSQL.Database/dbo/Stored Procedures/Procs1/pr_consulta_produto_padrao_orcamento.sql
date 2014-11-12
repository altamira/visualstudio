
CREATE PROCEDURE pr_consulta_produto_padrao_orcamento

@sg_parametro char(5)

as

Select a.cd_serie_produto                      as 'CodigoProduto',
       max(a.sg_serie_produto)                 as 'NomeFantasia',
       null                                    as 'Mascara',
       max(a.nm_serie_produto)                 as 'Descricao',
       Upper(max(d.sg_tipo_produto_espessura)) as 'Tipo' 
-----
into #TmpSerieProduto
-----

from SERIE_PRODUTO a

left outer join serie_produto_especificacao b on 
a.cd_serie_produto = b.cd_serie_produto

left outer join grupo_produto c on 
b.cd_grupo_produto = c.cd_grupo_produto

left outer join tipo_produto_espessura d on 
c.cd_tipo_produto_espessura = d.cd_tipo_produto_espessura
  
--where a.cd_serie_produto in 
--        (select cd_serie_produto from serie_produto_componente)

group by a.cd_serie_produto

UNION

Select p.cd_produto          as 'CodigoProduto',
       p.nm_fantasia_produto as 'NomeFantasia',
       p.cd_mascara_produto  as 'Mascara',
       p.nm_produto          as 'Descricao',
       Upper(d.sg_tipo_produto_espessura) as 'Tipo' 

From Produto p

Left Outer Join Grupo_Produto c on 
p.cd_grupo_produto = c.cd_grupo_produto

left outer join tipo_produto_espessura d on 
c.cd_tipo_produto_espessura = d.cd_tipo_produto_espessura

where c.cd_tipo_produto_espessura = 1 -- Moldes

--Select a.cd_produto_pai                        as 'CodigoProduto', 
--       max(b.nm_fantasia_produto)              as 'NomeFantasia',
--       max(b.cd_mascara_produto)               as 'Mascara',  
--       max(b.nm_produto)                       as 'Descricao',
--       Upper(max(d.sg_tipo_produto_espessura)) as 'Tipo' 

--from Produto_Composicao a

--Inner Join Produto b on 
--a.cd_produto_pai = b.cd_produto

--Left Outer Join Grupo_Produto c on 
--b.cd_grupo_produto = c.cd_grupo_produto

--left outer join tipo_produto_espessura d on 
--c.cd_tipo_produto_espessura = d.cd_tipo_produto_espessura

--group by a.cd_produto_pai 


UNION


Select (cd_base_estampo_medida+100) as 'CodigoProduto', -- Para não confundir com as séries
        nm_fantasia_produto         as 'NomeFantasia',
        null                        as 'Mascara',  
        null                        as 'Descricao',
        'BASE'                      as 'Tipo' 

from Base_Estampo_Medida 

--
-- Query Final
--

select * from #TmpSerieProduto
where tipo = @sg_parametro
order by NomeFantasia

