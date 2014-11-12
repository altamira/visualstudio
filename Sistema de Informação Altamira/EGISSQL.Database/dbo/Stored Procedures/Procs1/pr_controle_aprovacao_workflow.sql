
CREATE PROCEDURE pr_controle_aprovacao_workflow


AS

select 
	mw.cd_movimento,
	0 as Sel,
	mw.cd_documento as 'Documento',
	mw.dt_movimento as 'Data',
	mw.vl_movimento as 'Valor',
	mw.cd_status as 'Status',
	pw.cd_departamento_Origem as 'Origem',
	pw.cd_departamento_destino as 'Destino',
	u.nm_usuario as 'Usuario',
	mw.nm_obs_movimento as 'Observacao',
	mw.cd_usuario,
	mw.dt_usuario	
from movimento_workflow mw
left outer join processo_workflow pw on pw.cd_processo=mw.cd_processo
left outer join usuario u on u.cd_usuario = mw.cd_usuario
where mw.cd_movimento not in (select cd_movimento from movimento_workflow_aprovacao)

