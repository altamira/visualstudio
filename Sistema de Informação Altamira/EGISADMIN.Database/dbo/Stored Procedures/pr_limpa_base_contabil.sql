
create procedure pr_limpa_base_contabil
@cd_empresa int

as

select 
  rac.cd_registro_atividade as RegistroAtividade,
  rac.dt_registro_atividade as DataRegistroAtividade,
  ucs.nm_fantasia_usuario as Usuario,
  mod.nm_modulo as Modulo,
  rac.cd_atividade_cliente as AtividadeCliente,
  rac.qt_hora_atividade as QuantidadeHoraAtividade,
  con.nm_consultor as Consultor,  
  rac.ds_registro_atividade as DescricaoRegistroAtividade  
  
from 
  registro_atividade_cliente rac
left outer join usuario_cliente_sistema ucs
  on ucs.cd_usuario_sistema = rac.cd_usuario_sistema
left outer join modulo mod
  on mod.cd_modulo = rac.cd_modulo
left outer join consultor_implantacao con
  on rac.cd_consultor = con.cd_consultor

order by rac.cd_registro_atividade, rac.dt_registro_atividade
