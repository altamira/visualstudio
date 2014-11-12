

--pr_coordenadas
-------------------------------------------------------------------------------------------
-- Polimold
-- Stored Procedure : SQL Server
-- Autor(es)        : Cleiton Marques
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta Cordenadas de Series
-- Data             : 26/12/2002	
-- Atualizado       : 
CREATE PROCEDURE pr_coordenadas
@cd_serie_produto int,          
@cd_tipo_serie_produto int

as

select * from Coordenada
where cd_serie_produto=@cd_serie_produto and
      cd_tipo_serie_produto=@cd_tipo_serie_produto



