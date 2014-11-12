
CREATE VIEW vw_conta_corrente
------------------------------------------------------------------------------------
--sp_helptext vw_conta_corrente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Mostra as Contas Correntes da empresa
--
--Data                  : 13.12.2010
--Atualização           : 
--
------------------------------------------------------------------------------------
as
 

--select * from conta_agencia_banco

select
  c.cd_conta_banco,
  c.cd_banco,
  c.cd_agencia_banco,
  c.nm_conta_banco,
  b.cd_numero_banco,
  a.cd_numero_agencia_banco,
  a.nm_agencia_banco,
  ltrim(rtrim(cast(isnull(b.cd_numero_banco,'') as varchar)))+'/'+
  ltrim(rtrim(cast(isnull(a.cd_numero_agencia_banco,'') as varchar)))+'/'+
  ltrim(rtrim(cast(isnull(c.nm_conta_banco,'') as varchar))) as 'Conta'

from
  conta_agencia_banco c      with (nolock) 
  inner join agencia_banco a with (nolock) on a.cd_agencia_banco = c.cd_agencia_banco
  inner join banco         b with (nolock) on b.cd_banco         = c.cd_banco

--select * from banco
--select * from agencia_banco

