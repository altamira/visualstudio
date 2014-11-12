
-------------------------------------------------------------------------------
--pr_operacao_fiscal_sem_conta_contabil
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Grupo de Produtos sem Conta Contábil
--Data             : 23/08/2005
--Atualizado       : 23/08/2005
--------------------------------------------------------------------------------------------------
create procedure pr_operacao_fiscal_sem_conta_contabil
@dt_inicial datetime,
@dt_final   datetime
as

--select * from operacao_fiscal
--select * from operacao_fiscal_contabilizacao

select
  opf.cd_operacao_fiscal   as Codigo,
  opf.cd_mascara_operacao  as CFOP,
  opf.nm_operacao_fiscal   as Descricao
 
from
  Operacao_Fiscal opf
where
  opf.cd_operacao_fiscal not in ( select cd_operacao_fiscal from Operacao_Fiscal_Contabilizacao )

