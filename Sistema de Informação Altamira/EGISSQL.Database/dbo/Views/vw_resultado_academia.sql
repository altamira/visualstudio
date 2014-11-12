
CREATE VIEW vw_resultado_academia
------------------------------------------------------------------------------------
--vw_resultado_academia
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2006
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : View para ser utilizada nas consultas de ranking da Academia
--Data                  : 19.02.2006
--Atualização           : 19.02.2006
------------------------------------------------------------------------------------
as

select
  a.cd_aluno,
  a.nm_aluno,
  pa.nm_plano,
  ap.vl_plano_aluno
from
  aluno a
  left outer join Aluno_Plano    ap on ap.cd_aluno = a.cd_aluno
  left outer join Plano_Academia pa on pa.cd_plano = ap.cd_plano

 
