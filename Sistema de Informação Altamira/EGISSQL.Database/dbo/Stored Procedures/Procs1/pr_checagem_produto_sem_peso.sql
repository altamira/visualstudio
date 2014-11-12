
-------------------------------------------------------------------------------
--pr_checagem_produto_sem_peso
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes / Diego Borba
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 06.08.2005
--Atualizado       : 06.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_checagem_produto_sem_peso
@dt_inicial datetime,
@dt_final   datetime

as

--select * from produto

select
  gp.nm_grupo_produto    as GrupoProduto,
   p.cd_mascara_produto  as Codigo,
   p.nm_fantasia_produto as Fantasia,
   p.nm_produto          as Descricao,
   p.qt_peso_liquido     as PesoLiquido,
   p.qt_peso_bruto       as PesoBruto
from
  Produto p
  left outer join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
where
  isnull(p.qt_peso_bruto,0)=0

