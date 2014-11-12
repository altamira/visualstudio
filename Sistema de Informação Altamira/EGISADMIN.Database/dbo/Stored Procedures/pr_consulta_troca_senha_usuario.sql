
-------------------------------------------------------------------------------
--pr_consulta_troca_senha_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Senhas Trocas por Usuário
--Data             : 07.01.2005
--Atualizado       : 07.01.2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_troca_senha_usuario
@dt_inicial datetime,
@dt_final   datetime

as

--select * from usuario
--select * from historico_senha_usuario

select
  u.nm_fantasia_usuario       as Usuario,
  d.nm_departamento           as Departamento,
  u.cd_senha_usuario          as SenhaAtual,
  u.dt_validade_senha_usuario as ValidadeSenha,
  hs.dt_troca_senha           as DataTroca,
  hs.cd_senha_usuario         as SenhaTroca
from
  Usuario u 
  left outer join egissql.dbo.departamento d on d.cd_departamento = u.cd_departamento
  left outer join historico_senha_usuario hs on hs.cd_usuario     = u.cd_usuario
order by
  u.nm_fantasia_usuario,
  hs.dt_troca_senha desc
