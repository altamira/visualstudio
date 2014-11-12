
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_documento_aprovacao
-------------------------------------------------------------------------------
--pr_consulta_documento_aprovacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Documentos para Aprovação
--                   Montagem de uma Página ASP
--Data             : 12.11.2007
--Alteração        : 
 ------------------------------------------------------------------------------
create procedure pr_consulta_documento_aprovacao
@cd_tipo_documento      char(2) = '',
@cd_documento_aprovacao int     = 0

as


if @cd_documento_aprovacao >0 
begin
  if @cd_tipo_documento = 'RV'
  begin

    select 
      rv.*,
      av.nm_assunto_viagem,
      f.nm_funcionario,
      d.nm_departamento  ,
      cc.nm_centro_custo,
      tv.nm_tipo_viagem,
      pv.nm_projeto_viagem,
      tp.nm_tipo_prioridade,
      u.nm_usuario,
      ap.dt_aprovacao_ap,
      ua.nm_fantasia_usuario as nm_usuario_autorizacao_ap,
      sa.cd_solicitacao,
      m.sg_moeda
    from
      Requisicao_Viagem rv with (nolock)
      left join Assunto_Viagem av           on (rv.cd_assunto_viagem  = av.cd_assunto_viagem) 
      left join Funcionario f               on (f.cd_funcionario      = rv.cd_funcionario) 
      left join Departamento d              on (d.cd_departamento     = rv.cd_departamento) 
      left join Centro_Custo cc             on (cc.cd_centro_custo    = rv.cd_centro_custo)
      left join Tipo_Viagem tv              on (tv.cd_tipo_viagem     = rv.cd_tipo_viagem) 
      left join Projeto_Viagem pv           on (pv.cd_projeto_viagem  = rv.cd_projeto_viagem) 
      left join Tipo_Prioridade tp          on (tp.cd_tipo_prioridade = rv.cd_tipo_prioridade) 
      left join EGISAdmin.dbo.Usuario u     on (u.cd_usuario          = rv.cd_usuario_liberacao)
      left join Autorizacao_Pagamento ap    on (ap.cd_ap              = rv.cd_ap)
      left join EGISAdmin.dbo.Usuario ua    on (ua.cd_usuario       = ap.cd_usuario_aprovacao)
      left join Solicitacao_Adiantamento sa on sa.cd_requisicao_viagem = rv.cd_requisicao_viagem
      left join Moeda m                     on m.cd_moeda = rv.cd_moeda
    where
       rv.cd_requisicao_viagem = @cd_documento_aprovacao
     
  end


end

