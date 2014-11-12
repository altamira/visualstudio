
--pr_montagem_sequencia_usinagem
-----------------------------------------------------------------------------------------------
-- Polimold
-- Stored Procedure : SQL Server
-- Autor(es)        : Cleiton Marques
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta da Montagens que não estão na tabela Sequencia_Usinagem_Montagem
-- Data             : 23/04/2003	
-- Atualizado       : 
------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_montagem_sequencia_usinagem
@cd_maquina int,          
@cd_magazine int,
@cd_sequencia_usinagem int,
@cd_placa int,
@cd_item int,
@cd_tipo_montagem int,
@cd_tipo_serie int


as

select cd_montagem,
       nm_montagem 
from Montagem
where cd_montagem not in
( 

select cd_montagem
from Sequencia_usinagem_montagem 
where cd_maquina            = @cd_maquina            and
      cd_magazine           = @cd_magazine           and
      cd_sequencia_usinagem = @cd_sequencia_usinagem and
      cd_placa              = @cd_placa              and
      cd_item               = @cd_item               and
      cd_tipo_montagem      = @cd_tipo_montagem      and
      cd_tipo_serie_produto = @cd_tipo_serie
)


