
-------------------------------------------------------------------------------
--sp_helptext pr_documentacao_pendente_funcionario
-------------------------------------------------------------------------------
--pr_documentacao_pendente_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta de Documentação Pendente de Funcionário
--Data             : 22.01.2011
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_documentacao_pendente_funcionario
@dt_inicial datetime = '',
@dt_final   datetime = ''
as


--select * from funcionario

select
  f.cd_funcionario,
  f.nm_funcionario,
  d.nm_departamento,
  f.dt_admissao_funcionario,
  f.cd_telefone_funcionario,
  f.cd_cel_funcionario,
  f.cd_ramal_funcionario,
  f.nm_email_funcionario   
  
from
  funcionario f                        with (nolock)
  inner join funcionario_documento fd  on fd.cd_funcionario = f.cd_funcionario
  left outer join departamento d       on d.cd_departamento = f.cd_departamento
where
 isnull(ic_doc_pendente_funcionario,'S')='S' 

order by
  f.nm_funcionario
  


