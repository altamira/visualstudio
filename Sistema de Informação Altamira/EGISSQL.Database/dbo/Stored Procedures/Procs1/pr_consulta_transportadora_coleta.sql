
-------------------------------------------------------------------------------
--pr_consulta_transportadora_coleta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consultar Transportadoras que Coletam
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_transportadora_coleta
as

select 
	t.nm_fantasia,
	t.cd_ddd,
	t.ic_cobra_coleta,
	t.cd_telefone,
	t.ic_ativo_transportadora,
	e.nm_estado,
	c.nm_cidade

from transportadora t left outer join
	estado e on e.cd_estado = t.cd_estado left outer join
	cidade c on c.cd_cidade = t.cd_cidade	

Where t.ic_ativo_transportadora = 's'

order By t.nm_fantasia

