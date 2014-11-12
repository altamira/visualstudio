
CREATE VIEW vw_negociacao_proposta
------------------------------------------------------------------------------------
--sp_helptext vw_negociacao_proposta
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra o último registro completo da negociação da Proposta
--
--Data                  : 01.03.2008
--Atualização           : 01.03.2008
------------------------------------------------------------------------------------
--15.12.2008 - Performance - Carlos Fernandes
------------------------------------------------------------------------------------
as

select 
  'S'                       as ic_negociacao,
  cn.cd_consulta,
  cn.dt_negociacao_consulta,
  cn.nm_negociacao_consulta,
  u.nm_fantasia_usuario       as Usuario,
  v.nm_fantasia_vendedor      as Vendedor
-- into
--   #Negocicao
from 
  consulta_negociacao cn                  with (nolock) 
  left outer join egisadmin.dbo.usuario u with (nolock) on u.cd_usuario  = cn.cd_usuario
  left outer join vendedor v              with (nolock) on v.cd_vendedor = cn.cd_vendedor

-- order by
--   dt_negociacao_consulta desc

 
