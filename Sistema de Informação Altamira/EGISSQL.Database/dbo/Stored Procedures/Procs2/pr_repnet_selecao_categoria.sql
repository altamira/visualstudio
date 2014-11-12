






--pr_repnet_selecao_categoria
--------------------------------------------------------------------------------------
--GBS-Global Business Solution                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Selecao de Categoria de Produtos para Consulta
--Data        : 07.04.2002
--Atualizado  : 07.04.2002
--------------------------------------------------------------------------------------
CREATE    procedure pr_repnet_selecao_categoria
@nm_categoria_produto as varchar(30)
as
  
select
   cd_categoria_produto as 'Codigo',
   nm_categoria_produto as 'Categoria'
from
  Categoria_Produto
Where
  ic_vendas_categoria = 'S' and
  nm_categoria_produto like @nm_categoria_produto+'%'
order by
  nm_categoria_produto 






