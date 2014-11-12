
--------------------------------------------------------------------------------------------------
--pr_localiza_produto
--------------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
--------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de produto pelos 02 códigos
--Data             : 06.02.2005
--Atualizado       : 06.02.2005
--------------------------------------------------------------------------------------------------
create procedure pr_localiza_produto
@nm_pesquisa_produto varchar(30)
as

declare @ic_localizou        int

set @ic_localizou = 0

--Fantasia

select
  top 1
  @ic_localizou = cd_produto
from 
  produto
where
  nm_fantasia_produto = @nm_pesquisa_produto

--Mascara

if @ic_localizou = 0
begin
  select
    top 1 
    @ic_localizou = cd_produto
  from 
    produto
  where
    cd_mascara_produto = @nm_pesquisa_produto
  
end

select 
  @ic_localizou
  cd_produto,
  nm_fantasia_produto,
  cd_mascara_produto,
  nm_produto
from 
  Produto
where
  cd_produto = @ic_localizou

--select * from produto

--sp_help produto

