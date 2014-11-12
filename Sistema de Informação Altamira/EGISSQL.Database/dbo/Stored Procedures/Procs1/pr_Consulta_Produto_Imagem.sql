
-------------------------------------------------------------------------------
--pr_Consulta_Produto_Imagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Pegar Produtos com suas imagens
--Data             : 16/09/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_Consulta_Produto_Imagem
@cd_grupo_produto integer,
@cd_categoria_produto integer
as

Select 
     p.cd_categoria_produto,
     p.cd_grupo_produto,  
     p.cd_produto,
     p.cd_mascara_produto,
     p.nm_produto,
     p.nm_fantasia_produto,
     um.sg_unidade_medida,
     pi.cd_produto_imagem,
     pi.nm_imagem_produto 
From 
     Produto p
     left outer join Produto_Imagem pi on
     pi.cd_produto = p.cd_produto
     left outer join Unidade_Medida um on
     um.cd_unidade_medida = p.cd_unidade_medida
where
     p.cd_grupo_produto = case when isnull(@cd_grupo_produto,0) = 0 then
                          isnull(p.cd_grupo_produto,0)
                          else
                          isnull(@cd_grupo_produto,0)
                          end          and
     p.cd_categoria_produto = case when isnull(@cd_categoria_produto,0) = 0 then
                              isnull(p.cd_categoria_produto,0)
                              else
                              isnull(@cd_categoria_produto,0)
                              end and
     pi.nm_imagem_produto <> ''
Order By p.cd_produto

