
-------------------------------------------------------------------------------
--pr_gera_grupo_produto_valoracao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera a Tabela de Grupo de Produto para Valoração do Estoque
--Data             : 12.11.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_grupo_produto_valoracao
@cd_usuario int = 0

as

delete from grupo_produto_valoracao

--select * from fase_produto

select
  cd_fase_produto,
  cd_metodo_valoracao,
  cd_tipo_grupo_inventario
into
  #Fase
from
  Fase_Produto

declare @cd_fase_produto          int
declare @cd_metodo_valoracao      int
declare @cd_tipo_grupo_inventario int

while exists( select top 1 cd_fase_produto from #Fase )

begin

  select top 1
    @cd_fase_produto          = cd_fase_produto,
    @cd_metodo_valoracao      = cd_metodo_valoracao,
    @cd_tipo_grupo_inventario = cd_tipo_grupo_inventario
  from
    #Fase

  insert into grupo_produto_valoracao
  select
    cd_grupo_produto,
    @cd_fase_produto,
    1,
    @cd_metodo_valoracao,
    '',
    @cd_usuario,
    getdate(),
    null,
    @cd_tipo_grupo_inventario

  from
    grupo_produto
  where
    cd_grupo_produto>0 and @cd_fase_produto>0

  delete from #Fase where cd_fase_produto = @cd_fase_produto
 

end

drop table #Fase

select * from grupo_produto_valoracao

