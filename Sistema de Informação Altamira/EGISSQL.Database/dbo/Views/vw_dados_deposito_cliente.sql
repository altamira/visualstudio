
CREATE VIEW vw_dados_deposito_cliente
------------------------------------------------------------------------------------
--sp_helptext vw_dados_deposito_cliente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Dados do Depósito em Conta do Cliente 
--Data                  : 03.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as
 
select
  c.cd_cliente,
  c.nm_fantasia_cliente,
  b.nm_fantasia_banco,
  ag.nm_agencia_banco,
  ag.cd_numero_agencia_banco,
  cab.nm_conta_banco,  
  cab.cd_dac_conta_banco,
  case when isnull(cab.cd_conta_banco,0)>0 then
    'Dep. '+rtrim(ltrim(b.nm_fantasia_banco))+' Ag.'+rtrim(ltrim(ag.cd_numero_agencia_banco))+' c/c: '+rtrim(ltrim(cab.nm_conta_banco))+'-'+cab.cd_dac_conta_banco
  else
    cast('' as varchar(80))
  end                                      as nm_mensagem_conta
from
  Cliente c                                with (nolock)
  inner join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente       = c.cd_cliente
  left outer join conta_agencia_banco  cab with (nolock) on cab.cd_conta_banco  = ci.cd_conta_banco
  left outer join Banco                b   with (nolock) on b.cd_banco          = cab.cd_banco
  left outer join Agencia_Banco        ag  with (nolock) on ag.cd_agencia_banco = cab.cd_agencia_banco


--select * from conta_agencia_banco
--select * from banco
--select * from agencia_banco

