

/****** Object:  Stored Procedure dbo.pr_Ramo_Atividade_SMC    Script Date: 13/12/2002 15:08:10 ******/
CREATE PROCEDURE pr_Ramo_Atividade_SMC
AS

truncate table ramo_atividade

select 
identity(int, 1, 1)                       'cd_ramo_atividade',
convert(varchar(40), seg.Descricao)       'nm_ramo_atividade',
null                                      'sg_ramo_atividade',
null                                      'qt_cilente_ramo_atividade',
null                                      'pc_cliente_ramo_atividade',
1                                         'cd_usuario',
getdate()                                 'dt_usuario'
into
  #ramo_atividade
from 
  smc.dbo.segmentomercado seg
order by seg.descricao

select * from #ramo_atividade

Insert into ramo_atividade
select 
cd_ramo_atividade,
nm_ramo_atividade,
sg_ramo_atividade,
qt_cilente_ramo_atividade,
pc_cliente_ramo_atividade,
cd_usuario,
dt_usuario,
null,
null
from #ramo_atividade

drop table #ramo_atividade





