
-------------------------------------------------------------------------------
--sp_helptext pr_checagem_reenvio_movimento_aprovacao
-------------------------------------------------------------------------------
--pr_checagem_reenvio_movimento_aprovacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consulta de Documentos Enviados para Aprovação e 
--                   Não Aprovados no tempo determinado nos parâmetros
--                   
--Data             : 11.04.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_checagem_reenvio_movimento_aprovacao
@ic_selecao           int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = '',
@cd_requisicao_viagem int      = 0,
@cd_solicitacao_adto  int      = 0,
@cd_solicitacao_pagto int      = 0,
@cd_prestacao         int      = 0

as


--Requisição de Viagem

select
  distinct
  'RV'                    as ic_tipo_documento,
  rv.cd_requisicao_viagem as cd_documento,
  rv.dt_requisicao_viagem as dt_documento,
  rv.cd_funcionario,
  rv.cd_departamento,
  rv.cd_centro_custo,
  rv.cd_assunto_viagem,
  isnull(rv.vl_adto_viagem,0)  as vl_documento,
  daf.cd_funcionario           as cd_funcionario_liberacao,
  rv.cd_tipo_viagem,
  cast(rv.ds_requisicao_viagem as varchar(8000)) as ds_documento
into
  #Requisicao
from 
  requisicao_viagem rv                                   with (nolock)
  left outer join departamento_aprovacao_funcionario daf with (nolock) on daf.cd_departamento      = rv.cd_departamento and
                                                                          daf.cd_centro_custo      = rv.cd_centro_custo 

  left outer join funcionario f                          with (nolock) on daf.cd_funcionario       = f.cd_funcionario

  left outer join Tipo_Aprovacao ta                      with (nolock) on ta.cd_tipo_aprovacao     = daf.cd_tipo_aprovacao


where 
  rv.cd_requisicao_viagem = case when @cd_requisicao_viagem = 0 then rv.cd_requisicao_viagem else @cd_requisicao_viagem end and
  rv.cd_requisicao_viagem not in ( select cd_requisicao_viagem from requisicao_viagem_aprovacao )
order by
  rv.dt_requisicao_viagem

if @cd_requisicao_viagem = 0 and @cd_solicitacao_adto = 0 and @cd_solicitacao_pagto = 0 and @cd_prestacao = 0
begin
  select
    *
  into
    #Apresentacao
  from
    #Requisicao
--   union all
--     select * from #solicitacao_adiantamento
--   union all
--     select * from #solicitacao_pagamento
--   union all
--     select * from #prestacao

  select
    @ic_selecao                as Sel,
    a.*,
    f.nm_funcionario,
    d.nm_departamento,
    cc.nm_centro_custo,
    av.nm_assunto_viagem,
    tv.nm_tipo_viagem
  from
    #Apresentacao a
    left outer join Funcionario f     on f.cd_funcionario   = a.cd_funcionario
    left outer join Departamento d    on d.cd_departamento  = a.cd_departamento
    left outer join Centro_Custo cc   on cc.cd_centro_custo = a.cd_centro_custo
    left outer join Assunto_Viagem av on av.cd_assunto_viagem = a.cd_assunto_viagem
    left outer join Tipo_Viagem    tv on tv.cd_tipo_viagem    = a.cd_tipo_viagem
  order by
    cd_documento

end


