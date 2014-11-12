
CREATE procedure pr_servico_sem_categoria
--------------------------------------------------------------------------------------------------
--pr_servico_sem_categoria
--------------------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                                           2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes 
--servico sem Categoria
--Categoria do servico
--Data         : 26.01.2004
--------------------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final   datetime
as

select
  cd_servico           as Codigo,
  cd_mascara_servico   as Mascara,
  nm_servico           as Descricao
from
  servico
where
  isnull(cd_categoria_produto,0)=0

