

/****** Object:  Stored Procedure dbo.pr_verifica_regiao_lancada1    Script Date: 13/12/2002 15:08:45 ******/

--pr_verifica_regiao_lancada1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes
--Verifica se uma determinada Região já foi lançada para um 
--Vendedor
--Data         : 14.12.2000
--Atualizado   : 01.10.2002 - Migração bco. Egis - DUELA
-----------------------------------------------------------------------------------
CREATE procedure pr_verifica_regiao_lancada1

@cd_regiao char(10)

as

select a.cd_vendedor,b.nm_fantasia_vendedor
from 
   Divisao_area_vendedor a, Vendedor b
where
   @cd_regiao    = a.cd_geomapa and
   a.cd_vendedor = b.cd_vendedor


