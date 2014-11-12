
-------------------------------------------------------------------------------
--pr_observacao_lista_preco_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_observacao_lista_preco_produto
@cd_grupo_produto int = 0,
@cd_produto       int = 0

as

  select
    p.nm_preco_lista_produto  as Observacao,
    p.cd_produto,              
    p.cd_mascara_produto      as Fantasia,
    p.nm_fantasia_produto     as Codigo,
    p.nm_produto              as Produto,
    um.sg_unidade_medida      as Unidade
  from
    Produto p
    left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
    left outer join Grupo_Produto  gp on gp.cd_grupo_produto  = p.cd_grupo_produto
  where
    p.cd_produto       = case when @cd_produto       = 0 then p.cd_produto       else @cd_produto end and
    p.cd_grupo_produto = case when @cd_grupo_produto = 0 then p.cd_grupo_produto else @cd_grupo_produto end 
 

