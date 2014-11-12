
-------------------------------------------------------------------------------
--pr_consulta_lista_preco_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Diego Santiago / Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 08/07/2005
--Atualizado       : 08/07/2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_lista_preco_servico
@dt_inicial datetime,
@dt_final   datetime
as

select
  gs.nm_grupo_servico        as GrupoServico,
   s.nm_servico              as Servico,
   s.vl_servico              as ValorServico,
  gp.nm_grupo_produto        as Grupo,
  cp.nm_categoria_produto    as Categoria,
  pe.nm_grupo_preco_produto  as GrupoPreco
from
  Servico s
  left outer join Grupo_Servico gs        on gs.cd_grupo_servico       = s.cd_grupo_servico
  left outer join Grupo_Produto gp        on gp.cd_grupo_produto       = s.cd_grupo_produto
  left outer join Categoria_Produto cp    on cp.cd_categoria_produto   = s.cd_categoria_produto
  left outer join Grupo_Preco_Produto pe  on pe.cd_grupo_preco_produto = s.cd_grupo_preco_produto
where
  isnull(s.ic_lp_servico,'N')='S'  

