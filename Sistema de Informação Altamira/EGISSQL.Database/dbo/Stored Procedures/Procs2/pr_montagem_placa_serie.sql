
--pr_montagem_placa_serie
-----------------------------------------------------------------------------------------------
-- Polimold
-- Stored Procedure : SQL Server
-- Autor(es)        : Cleiton Marques
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta da Montagens que não estão na tabela Sequencia_Usinagem_Montagem
-- Data             : 23/04/2003	
-- Atualizado       : 
------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_montagem_placa_serie
@cd_serie int,          
@cd_tipo_serie int,
@cd_placa int,
@cd_tipo_montagem int


as

select cd_montagem,
       nm_montagem 
from Montagem
where cd_montagem not in
( 

select cd_montagem
from placa_serie_montagem 
where cd_serie_produto      = @cd_serie              and
      cd_tipo_serie         = @cd_tipo_serie         and
      cd_placa              = @cd_placa              and
      cd_tipo_montagem      = @cd_tipo_montagem
)


