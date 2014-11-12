

create procedure pr_requisicao_vaga
@ic_parametro integer,
@cd_requisicao_vaga integer
as
if @ic_parametro = 0 --listar todas 
select 
   rv.dt_baixa_requisicao,
   rv.cd_requisicao_vaga,
   rv.dt_requisicao_vaga, 
   rv.dt_necessidade_vaga,
   s.cd_seccao,
   tv.nm_tipo_vaga, 
   mv.nm_motivo_vaga,
   d.nm_departamento,
   rv.ds_requisicao_vaga,
   nm_centro_custo as 'Centro_Custo',
   c.cd_cliente,
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
   rv.dt_liberacao_requisicao,
   u.nm_usuario,
   rv.cd_usuario,
   rv.cd_departamento,
   rv.cd_centro_custo,
   rv.cd_tipo_vaga, 
   rv.cd_motivo_vaga,
   GetDate() as Data,
   c.nm_fantasia_cliente
from
   requisicao_vaga rv   
   left outer join Departamento d on d.cd_departamento = rv.cd_departamento
   left outer join seccao s on s.cd_seccao = rv.cd_seccao
   left outer join motivo_vaga mv on mv.cd_motivo_vaga = rv.cd_motivo_vaga
   left outer join Tipo_Vaga tv on tv.cd_tipo_vaga = rv.cd_tipo_vaga
   left outer join Cliente c on c.cd_cliente = rv.cd_cliente
   left outer join Candidato ca on ca.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Centro_Custo cc on cc.cd_centro_custo = rv.cd_centro_custo
   left outer join EgisAdmin.dbo.Usuario u on u.cd_usuario = rv.cd_usuario
Where rv.cd_requisicao_vaga = case when isnull(@cd_requisicao_vaga,0) = 0 then
                                isnull(rv.cd_requisicao_vaga,0)
                              else
                                isnull(@cd_requisicao_vaga,0)
                              end
else
if @ic_parametro = 1 --listar abertas
select 
   rv.dt_baixa_requisicao,
   rv.cd_requisicao_vaga,
   rv.dt_requisicao_vaga, 
   rv.dt_necessidade_vaga,
   s.cd_seccao,
   tv.nm_tipo_vaga, 
   mv.nm_motivo_vaga,
   d.nm_departamento,
   rv.ds_requisicao_vaga,
   nm_centro_custo as 'Centro_Custo',
   c.cd_cliente,
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
   rv.dt_liberacao_requisicao,
   u.nm_usuario,
   rv.cd_usuario,
   rv.cd_departamento,
   rv.cd_centro_custo,
   rv.cd_tipo_vaga, 
   rv.cd_motivo_vaga,
   GetDate() as Data,
   c.nm_fantasia_cliente
from
   requisicao_vaga rv   
   left outer join Departamento d on d.cd_departamento = rv.cd_departamento
   left outer join seccao s on s.cd_seccao = rv.cd_seccao
   left outer join motivo_vaga mv on mv.cd_motivo_vaga = rv.cd_motivo_vaga
   left outer join Tipo_Vaga tv on tv.cd_tipo_vaga = rv.cd_tipo_vaga
   left outer join Cliente c on c.cd_cliente = rv.cd_cliente
   left outer join Candidato ca on ca.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Centro_Custo cc on cc.cd_centro_custo = rv.cd_centro_custo
   left outer join EgisAdmin.dbo.Usuario u on u.cd_usuario = rv.cd_usuario
where rv.cd_requisicao_vaga = case when isnull(@cd_requisicao_vaga,0) = 0 then
                                isnull(rv.cd_requisicao_vaga,0)
                              else
                                isnull(@cd_requisicao_vaga,0)
                              end and
      rv.dt_baixa_requisicao is null
else --listar efetivadas
select 
   rv.dt_baixa_requisicao,
   rv.cd_requisicao_vaga,
   rv.dt_requisicao_vaga, 
   rv.dt_necessidade_vaga,
   s.cd_seccao,
   tv.nm_tipo_vaga, 
   mv.nm_motivo_vaga,
   d.nm_departamento,
   rv.ds_requisicao_vaga,
   nm_centro_custo as 'Centro_Custo',
   c.cd_cliente,
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
   rv.dt_liberacao_requisicao,
   u.nm_usuario,
   rv.cd_usuario,
   rv.cd_departamento,
   rv.cd_centro_custo,
   rv.cd_tipo_vaga, 
   rv.cd_motivo_vaga,
   GetDate() as Data,
   c.nm_fantasia_cliente
from
   requisicao_vaga rv   
   left outer join Departamento d on d.cd_departamento = rv.cd_departamento
   left outer join seccao s on s.cd_seccao = rv.cd_seccao
   left outer join motivo_vaga mv on mv.cd_motivo_vaga = rv.cd_motivo_vaga
   left outer join Tipo_Vaga tv on tv.cd_tipo_vaga = rv.cd_tipo_vaga
   left outer join Cliente c on c.cd_cliente = rv.cd_cliente
   left outer join Candidato ca on ca.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Centro_Custo cc on cc.cd_centro_custo = rv.cd_centro_custo
   left outer join EgisAdmin.dbo.Usuario u on u.cd_usuario = rv.cd_usuario
where rv.cd_requisicao_vaga = case when isnull(@cd_requisicao_vaga,0) = 0 then
                                isnull(rv.cd_requisicao_vaga,0)
                              else
                                isnull(@cd_requisicao_vaga,0)
                              end and
      rv.dt_baixa_requisicao is not null
