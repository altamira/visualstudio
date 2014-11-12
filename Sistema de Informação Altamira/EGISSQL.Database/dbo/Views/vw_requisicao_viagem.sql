
CREATE VIEW vw_requisicao_viagem
------------------------------------------------------------------------------------
--vw_requisicao_viagem
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : View para Mostrar a Requisição de Viagem
--Data                  : 14.11.2007
--Atualização           : 24.11.2007 - Colocação do Aprovador - Carlos Fernandes
--24.01.2008 - Ajustes dos campos
--15.02.2008 - Acerto do Campo de Observação - Carlos Fernandes
--13.03.2008 - Verificação do Valor para Outra Moeda - Carlos Fernandes
--04.04.2008 - Tipo de Adiantamento - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from funcionario

Select 

  rv.*,

  isnull(f.cd_chapa_funcionario,f.cd_funcionario)          as cd_chapa_funcionario,
  isnull(f.nm_funcionario,'')                              as nm_funcionario,
  isnull(d.nm_departamento,'')                             as nm_departamento,
  isnull(cc.nm_centro_custo,'')                            as nm_centro_custo,
  isnull(tv.nm_tipo_viagem,'')                             as nm_tipo_viagem,
  isnull(pv.nm_projeto_viagem,'')                          as nm_projeto_viagem,
  isnull(av.nm_assunto_viagem,'')                          as nm_assunto_viagem,
  isnull(tp.nm_tipo_prioridade,'')                         as nm_tipo_prioridade,
  isnull(u.nm_usuario,'')                                  as nm_usuario,

  case when ap.dt_aprovacao_ap is not null then
     ap.dt_aprovacao_ap
  else 
     ''
  end                                                      as dt_aprovacao_ap,

  isnull(ua.nm_fantasia_usuario,'')                        as nm_usuario_autorizacao_ap,
  isnull(sa.cd_solicitacao,0)                              as cd_solicitacao,


  cast(rv.dt_inicio_viagem as datetime)                    as nm_inicio_viagem,
  cast(rv.dt_fim_viagem    as datetime)                    as nm_fim_viagem, 
  isnull(ta.nm_tipo_adiantamento,'')                       as nm_tipo_adiantamento,
  isnull(m.sg_moeda,'')                                    as sg_moeda,

  case when isnull(rv.cd_moeda,1)=1 then
     isnull(rv.vl_adto_viagem,0)           
  else
     isnull(rv.vl_adto_moeda,0)
  end                                                      as valor_adiantamento,

  rtrim(ltrim(cast( isnull(rv.vl_adto_viagem,0) 
                                       as varchar)))       as valorstring,

  cast(rv.ds_requisicao_viagem as varchar(8000))           as ds_requisicao
  --select * from requisicao_viagem

from
  Requisicao_Viagem rv                  with (nolock) 
  left join Assunto_Viagem av           with (nolock) on (rv.cd_assunto_viagem   = av.cd_assunto_viagem) 
  left join Funcionario f               with (nolock) on (f.cd_funcionario       = rv.cd_funcionario) 
  left join Departamento d              with (nolock) on (d.cd_departamento      = rv.cd_departamento) 
  left join Centro_Custo cc             with (nolock) on (cc.cd_centro_custo     = rv.cd_centro_custo)
  left join Tipo_Viagem tv              with (nolock) on (tv.cd_tipo_viagem      = rv.cd_tipo_viagem) 
  left join Projeto_Viagem pv           with (nolock) on (pv.cd_projeto_viagem   = rv.cd_projeto_viagem) 
  left join Tipo_Prioridade tp          with (nolock) on (tp.cd_tipo_prioridade  = rv.cd_tipo_prioridade) 
  left join EGISAdmin.dbo.Usuario u     with (nolock) on (u.cd_usuario           = rv.cd_usuario_liberacao)
  left join Autorizacao_Pagamento ap    with (nolock) on (ap.cd_ap               = rv.cd_ap)
  left join EGISAdmin.dbo.Usuario ua    with (nolock) on (ua.cd_usuario          = ap.cd_usuario_aprovacao)
  left join Solicitacao_Adiantamento sa with (nolock) on sa.cd_requisicao_viagem = rv.cd_requisicao_viagem
  left join Moeda m                     with (nolock) on m.cd_moeda              = rv.cd_moeda 
  left join Tipo_Adiantamento ta        with (nolock) on ta.cd_tipo_adiantamento = rv.cd_tipo_adiantamento                                                      
