

----------------------------------------------------------------
--pr_assinatura_fiscal
----------------------------------------------------------------
--GBS - Global Business Solution Ltda           	    2004
----------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Carlos Fernandes
--Banco de Dados      : SQL 
--Objetivo            : Assintura do Livro de Inventário
--Data                : 
--Atualizado          : 
------------------------------------------------------------------------------------------------

CREATE procedure pr_assinatura_fiscal    
as    
    
select    
  cast('' as varchar(50)) as 'Nome1Inventario',    
  cast('' as varchar(50)) as 'Cargo1Inventario',    
  cast('' as varchar(50)) as 'Nome2Inventario',    
  cast('' as varchar(50)) as 'Cargo2Inventario'    
    
