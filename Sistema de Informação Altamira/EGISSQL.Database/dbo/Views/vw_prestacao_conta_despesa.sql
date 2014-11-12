
--sp_helptext vw_prestacao_conta_despesa

CREATE VIEW vw_prestacao_conta_despesa
------------------------------------------------------------------------------------
--vw_prestacao_conta_despesa
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os dados da Despesa Prestação de Conta
--Data                  : 17.11.2007
--Atualização           : 19.11.2007 - Projeto - Carlos Fernandes	
------------------------------------------------------------------------------------

as

--select * from prestacao_conta_composicao

Select 
  ppc.*,
  td.nm_tipo_despesa,
  pv.nm_projeto_viagem as nm_projeto
from 
  Prestacao_Conta_Composicao ppc    with (nolock)
  left outer join tipo_despesa td   with (nolock) on td.cd_tipo_despesa   = ppc.cd_tipo_despesa
  left outer join projeto_viagem pv with (nolock) on pv.cd_projeto_viagem = ppc.cd_projeto_viagem
