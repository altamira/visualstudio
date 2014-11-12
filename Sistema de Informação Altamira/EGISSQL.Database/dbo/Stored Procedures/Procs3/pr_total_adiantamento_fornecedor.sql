
-------------------------------------------------------------------------------
--sp_helptext pr_total_adiantamento_fornecedor
-------------------------------------------------------------------------------
--pr_total_adiantamento_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Total de Adiantamento de Fornecedores
--Data             : 28/05/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_total_adiantamento_fornecedor
@cd_fornecedor int = 0

as

--select * from fornecedor_adiantamento

select
  cd_fornecedor,
  sum ( isnull(vl_adto_fornecedor,0)) as TotalAdiantamento
from
  fornecedor_adiantamento
where
  cd_fornecedor = @cd_fornecedor and
  dt_baixa_adto_fornecedor is null
group by
  cd_fornecedor

