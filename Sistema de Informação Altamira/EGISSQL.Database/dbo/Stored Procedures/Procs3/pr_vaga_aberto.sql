

create procedure pr_vaga_aberto
@cd_requisicao_vaga integer,
@ic_selecao integer,
@dt_inicial datetime,
@dt_final datetime
as
if @ic_selecao = 0 --listar por emissao
select 
   rv.cd_requisicao_vaga,
   rv.dt_requisicao_vaga, 
   rv.dt_necessidade_vaga,
   s.nm_seccao,
   rvc.qt_item_requisicao,
   rvc.vl_salario_vaga,
   rvc.vl_total_item_requisicao as total,
   tv.nm_tipo_vaga, 
   mv.nm_motivo_vaga,
   d.nm_departamento,
   rv.ds_requisicao_vaga,
   nm_centro_custo as 'Centro_Custo',
   c.nm_fantasia_cliente,
   (case when rv.dt_necessidade_vaga < getdate() then
     'S'
   else
     'N'
   end) as 'ic_atraso',
   (case when ca.cd_requisicao_vaga = rv.cd_requisicao_vaga then
     'S'
   else
     'N'
   end) as 'ic_candidato',   
   ('N') as 'ic_selecao',
   rv.ic_liberado_selecao,
   dt_liberacao_requisicao,
   cf.nm_cargo_funcionario
from
   requisicao_vaga rv   
   left outer join requisicao_vaga_composicao rvc on rvc.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Departamento d on d.cd_departamento = rv.cd_departamento
   left outer join seccao s on s.cd_seccao = rv.cd_seccao
   left outer join motivo_vaga mv on mv.cd_motivo_vaga = rv.cd_motivo_vaga
   left outer join Tipo_Vaga tv on tv.cd_tipo_vaga = rv.cd_tipo_vaga
   left outer join Cliente c on c.cd_cliente = rv.cd_cliente
   left outer join Candidato ca on ca.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Centro_Custo cc on cc.cd_centro_custo = rv.cd_centro_custo
   left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = rvc.cd_cargo_funcionario
Where rv.cd_requisicao_vaga = case when isnull(@cd_requisicao_vaga,0) = 0 then
                                isnull(rv.cd_requisicao_vaga,0)
                              else
                                isnull(@cd_requisicao_vaga,0)
                              end   and
      isnull(rv.ic_liberado_selecao,'N') = 'S' and
       rv.dt_requisicao_vaga between @dt_inicial and @dt_final 
else
select --Listar po Liberação 
   rv.cd_requisicao_vaga,
   rv.dt_requisicao_vaga, 
   rv.dt_necessidade_vaga,
   s.nm_seccao,
   rvc.qt_item_requisicao,
   rvc.vl_salario_vaga,
   rvc.vl_total_item_requisicao as total,
   tv.nm_tipo_vaga, 
   mv.nm_motivo_vaga,
   d.nm_departamento,
   rv.ds_requisicao_vaga,
   nm_centro_custo as 'Centro_Custo',
   c.nm_fantasia_cliente,
   (case when rv.dt_necessidade_vaga < getdate() then
     'S'
   else
     'N'
   end) as 'ic_atraso',
   (case when ca.cd_requisicao_vaga = rv.cd_requisicao_vaga then
     'S'
   else
     'N'
   end) as 'ic_candidato',   
   ('N') as 'ic_selecao',
   rv.ic_liberado_selecao,
   dt_liberacao_requisicao,
   cf.nm_cargo_funcionario
from
   requisicao_vaga rv   
   left outer join requisicao_vaga_composicao rvc on rvc.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Departamento d on d.cd_departamento = rv.cd_departamento
   left outer join seccao s on s.cd_seccao = rv.cd_seccao
   left outer join motivo_vaga mv on mv.cd_motivo_vaga = rv.cd_motivo_vaga
   left outer join Tipo_Vaga tv on tv.cd_tipo_vaga = rv.cd_tipo_vaga
   left outer join Cliente c on c.cd_cliente = rv.cd_cliente
   left outer join Candidato ca on ca.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Centro_Custo cc on cc.cd_centro_custo = rv.cd_centro_custo
   left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = rvc.cd_cargo_funcionario
Where rv.cd_requisicao_vaga = case when isnull(@cd_requisicao_vaga,0) = 0 then
                                isnull(rv.cd_requisicao_vaga,0)
                              else
                                isnull(@cd_requisicao_vaga,0)
                              end   and
      isnull(rv.ic_liberado_selecao,'N') = 'S' and
       rv.dt_liberacao_requisicao between @dt_inicial and @dt_final 
