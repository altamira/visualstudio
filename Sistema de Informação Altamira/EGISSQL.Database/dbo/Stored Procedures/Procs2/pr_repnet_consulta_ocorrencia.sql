






--pr_repnet_consulta_ocorrencia
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Clientes Novos por Vendedor
--Data          : 07.04.2002
--Atualizado    : 
----------------- ---------------------------------------------------------------------
CREATE procedure pr_repnet_consulta_ocorrencia
@dt_inicial  as datetime,
@dt_final   as  datetime,
@ic_tipo_usuario as char(10),
@cd_usuario as int
as

select 
  o.cd_ocorrencia as 'Codigo' ,
  o.dt_ocorrencia as 'Data',
  o.ds_ocorrencia as 'Descricao',
  u.nm_usuario as 'Remetente',
  so.nm_tipo_status_ocorrencia as 'Status'
from 
  ocorrencia o
    Left Outer Join
  Ocorrencia_Tipo_Status so
    on o.cd_status_ocorrencia = so.cd_tipo_status_ocorrencia
    Left Outer Join
  EgisAdmin.dbo.Usuario u
    on o.cd_usuario_origem = u.cd_usuario
where (';'+(RTrim(LTrim(IsNull(cd_com_copias, '')))) + ';') like '%;'+Str(@cd_usuario)+';%' or cd_usuario_destino = @cd_usuario and
      dt_ocorrencia between @dt_inicial and @dt_final







