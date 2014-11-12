
-------------------------------------------------------------------------------
--pr_atualiza_produto_lista_material
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Atualiza a Quantidade de Produto da Lista de Material
--                   Geração pelo EPLAN
--
--Data             : 29/01/2005
--Atualizado       : 29/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_atualiza_produto_lista_material
@cd_projeto      int,
@cd_item_projeto int,
@cd_produto      int,
@qt_produto      float
as

--select * from projeto_composicao_material

declare @cd_projeto_material int

--Localiza o produto na lista

select 
  @cd_projeto_material = isnull(cd_projeto_material,0) 
from
  Projeto_Composicao_Material
where
  cd_projeto      = @cd_projeto      and
  cd_item_projeto = @cd_item_projeto and
  cd_produto      = @cd_produto

if @cd_projeto_material > 0 
begin

  update
    Projeto_Composicao_Material
  set
    qt_projeto_material = qt_projeto_material + @qt_produto
  where
  cd_projeto               = @cd_projeto      and
  cd_item_projeto          = @cd_item_projeto and
  cd_projeto_material      = @cd_projeto_material and
  cd_produto               = @cd_produto

end

