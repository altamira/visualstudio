
CREATE procedure pr_produto_sem_categoria
--------------------------------------------------------------------------------------------------
--pr_produto_sem_categoria
--------------------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                                           2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes 
--Produto sem Categoria
--Categoria do Produto
--Data         : 26.01.2004
--------------------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final   datetime
as

select
  cd_produto           as Codigo,
  cd_mascara_produto   as Mascara,
  nm_fantasia_produto  as Fantasia,
  nm_produto           as Descricao
from
  Produto
where
  isnull(cd_categoria_produto,0)=0

