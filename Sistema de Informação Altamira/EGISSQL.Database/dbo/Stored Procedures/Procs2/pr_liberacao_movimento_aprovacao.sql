
-------------------------------------------------------------------------------
--sp_helptext pr_liberacao_movimento_aprovacao
-------------------------------------------------------------------------------
--pr_liberacao_movimento_aprovacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Liberação do Movimento para Aprovação
--                   Requisições de Viagem
--                   Solicitação de Adiantamento
--                   Solicitação de Pagamento
--                   Prestação   de Contas
--Data             : 15.02.2008
--Alteração        : 18.02.2008 - Finalização da procedure
-- 26.02.2008 - Mostrar o Total da Composição quando o valor for zero - Carlos Fernandes
-- 28.04.2008 - Verificação - Carlos Fernandes
-- 01.09.2008 - Não mostrar o solicitação de Adiantamento de Cartão de Crédito - Carlos Fernandes
-- 13.10.2008 - Hierarquia de Aprovação na Consulta - Carlos Fernandes
-- 17.11.2008 - Mudança para Usuário Supervisor - Carlos Fernandes/João 
-------------------------------------------------------------------------------------------------
create procedure pr_liberacao_movimento_aprovacao
@ic_selecao           int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = '',
@cd_requisicao_viagem int      = 0,
@cd_solicitacao_adto  int      = 0,
@cd_solicitacao_pagto int      = 0,
@cd_prestacao         int      = 0,
@cd_usuario           int      = 0,
@ic_parametro         int      = 0

as

if @ic_parametro = 0
begin

declare @ic_supervisor         char(1)
declare @cd_departamento       int
declare @cd_centro_custo       int
declare @cd_funcionario_origem int

select
   @ic_supervisor         = isnull(u.ic_tipo_usuario,'N'),
   @cd_departamento       = isnull(f.cd_departamento,0),
   @cd_centro_custo       = isnull(f.cd_centro_custo,0),
   @cd_funcionario_origem = isnull(f.cd_funcionario,0)
from
   egisadmin.dbo.usuario u       with (nolock) 
   left outer join funcionario f on f.cd_funcionario = u.cd_funcionario
where
  u.cd_usuario = @cd_usuario

--select @cd_usuario,@cd_funcionario_origem

if @ic_supervisor = 'S'
begin
   set @cd_usuario = 0
end

--select * from requisicao_viagem

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
  dlf.cd_funcionario           as cd_funcionario_liberacao,
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

  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = rv.cd_departamento and
                                                                          dlf.cd_centro_custo      = rv.cd_centro_custo and 
                                                                          dlf.cd_funcionario       = @cd_funcionario_origem

  left outer join requisicao_viagem_liberacao rvl        with (nolock) on rvl.cd_requisicao_viagem = rv.cd_requisicao_viagem
  left outer join funcionario fl                         with (nolock) on fl.cd_funcionario        = rv.cd_funcionario

where 

--  @cd_centro_custo = dlf.cd_centro_custo and
  @cd_departamento = dlf.cd_departamento and

  rv.cd_requisicao_viagem = case when @cd_requisicao_viagem = 0 then rv.cd_requisicao_viagem else @cd_requisicao_viagem end and
  daf.cd_funcionario   <> rv.cd_funcionario
  and rv.dt_liberacao_aprovacao is null
  and case when isnull(fl.cd_funcionario_liberacao,0)=0
      then @cd_funcionario_origem 
      else fl.cd_funcionario_liberacao end            = @cd_funcionario_origem

order by
  rv.dt_requisicao_viagem

--select * from #requisicao

--Solicitação de Adiantamento
--select * from solicitacao_adiantamento

select
  distinct
  'SA'              as ic_tipo_documento,
  sa.cd_solicitacao as cd_documento,
  sa.dt_solicitacao as dt_documento,
  sa.cd_funcionario,
  sa.cd_departamento,
  sa.cd_centro_custo,
  sa.cd_assunto_viagem,
  isnull(sa.vl_adiantamento,0)             as vl_documento,
  dlf.cd_funcionario                       as cd_funcionario_liberacao,
  0                                        as cd_tipo_viagem,
  cast(sa.ds_solicitacao as varchar(8000)) as ds_documento
 
into
  #Solicitacao_Adiantamento
from 
  Solicitacao_Adiantamento sa                            with (nolock)
  left outer join departamento_aprovacao_funcionario daf with (nolock) on daf.cd_departamento      = sa.cd_departamento and
                                                                          daf.cd_centro_custo      = sa.cd_centro_custo 

  left outer join funcionario f                          with (nolock) on daf.cd_funcionario       = f.cd_funcionario
  left outer join Tipo_Aprovacao ta                      with (nolock) on ta.cd_tipo_aprovacao     = daf.cd_tipo_aprovacao
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = sa.cd_departamento and
                                                                          dlf.cd_centro_custo      = sa.cd_centro_custo and
                                                                          dlf.cd_funcionario       = @cd_funcionario_origem

  left outer join solicitacao_adiantamento_liberacao rvl with (nolock) on rvl.cd_solicitacao       = sa.cd_solicitacao
  left outer join funcionario fl                         with (nolock) on fl.cd_funcionario        = sa.cd_funcionario

where 
--  @cd_centro_custo = dlf.cd_centro_custo and
  @cd_departamento = dlf.cd_departamento and
  sa.cd_solicitacao = case when @cd_solicitacao_adto = 0 then sa.cd_solicitacao else @cd_solicitacao_adto end and
  daf.cd_funcionario <> sa.cd_funcionario
  and isnull(sa.cd_requisicao_viagem,0)=0 
  and isnull(sa.cd_cartao_credito,0)   =0
  and sa.dt_liberacao_aprovacao is null
  and case when isnull(fl.cd_funcionario_liberacao,0)=0
      then @cd_funcionario_origem 
      else fl.cd_funcionario_liberacao end            = @cd_funcionario_origem

order by
  sa.dt_solicitacao

--select * from solicitacao_adiantamento

--Solicitação de Pagamento

select
  distinct
  'SP'                                     as ic_tipo_documento,
  sa.cd_solicitacao                        as cd_documento,
  sa.dt_solicitacao                        as dt_documento,
  sa.cd_funcionario,
  sa.cd_departamento,
  sa.cd_centro_custo,
  sa.cd_assunto_viagem,
  isnull(sa.vl_pagamento,0)                as vl_documento,
  dlf.cd_funcionario                       as cd_funcionario_liberacao,
  0                                        as cd_tipo_viagem, 
  cast(sa.ds_solicitacao as varchar(8000)) as ds_documento

into
  #Solicitacao_Pagamento
from 
  Solicitacao_Pagamento sa                               with (nolock)
  left outer join departamento_aprovacao_funcionario daf with (nolock) on daf.cd_departamento      = sa.cd_departamento and
                                                                          daf.cd_centro_custo      = sa.cd_centro_custo 
  left outer join funcionario f                          with (nolock) on daf.cd_funcionario       = f.cd_funcionario
  left outer join Tipo_Aprovacao ta                      with (nolock) on ta.cd_tipo_aprovacao     = daf.cd_tipo_aprovacao
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = sa.cd_departamento and
                                                                          dlf.cd_centro_custo      = sa.cd_centro_custo and
                                                                          dlf.cd_funcionario       = @cd_funcionario_origem
  left outer join solicitacao_pagamento_liberacao rvl    with (nolock) on rvl.cd_solicitacao       = sa.cd_solicitacao
  left outer join funcionario fl                         with (nolock) on fl.cd_funcionario        = sa.cd_funcionario

where 
--  @cd_centro_custo = dlf.cd_centro_custo and
  @cd_departamento = dlf.cd_departamento and
  sa.cd_solicitacao = case when @cd_solicitacao_pagto = 0 then sa.cd_solicitacao else @cd_solicitacao_pagto end and
  daf.cd_funcionario <> sa.cd_funcionario
  and sa.dt_liberacao_aprovacao is null
  and case when isnull(fl.cd_funcionario_liberacao,0)=0
      then @cd_funcionario_origem 
      else fl.cd_funcionario_liberacao end            = @cd_funcionario_origem

order by
  sa.dt_solicitacao

--Prestação de Contas
--select * from prestacao_conta

select
  distinct
  'PC'                    as ic_tipo_documento,
  pc.cd_prestacao         as cd_documento,
  pc.dt_prestacao         as dt_documento,
  pc.cd_funcionario,
  pc.cd_departamento,
  pc.cd_centro_custo,
  pc.cd_assunto_viagem,
  case when isnull(pc.vl_prestacao,0)=0 
  then
   --select * from prestacao_conta_composicao
   ( select sum( isnull(vl_total_despesa,0) ) from prestacao_conta_composicao where cd_prestacao = pc.cd_prestacao )
  else
    isnull(pc.vl_prestacao,0) *
    case when isnull(pc.vl_prestacao,0)>0 
    then
      1
    else
      -1
    end 
  end                                    as vl_documento, 
  dlf.cd_funcionario                     as cd_funcionario_liberacao,
  0                                      as cd_tipo_viagem,
  cast(pc.ds_prestacao as varchar(8000)) as ds_documento
  
 
into
  #Prestacao

from 
  prestacao_conta pc                                     with (nolock)
  left outer join departamento_aprovacao_funcionario daf with (nolock) on daf.cd_departamento      = pc.cd_departamento and
                                                                          daf.cd_centro_custo      = pc.cd_centro_custo 
  left outer join funcionario f                          with (nolock) on daf.cd_funcionario       = f.cd_funcionario
  left outer join Tipo_Aprovacao ta                      with (nolock) on ta.cd_tipo_aprovacao     = daf.cd_tipo_aprovacao
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = pc.cd_departamento and
                                                                          dlf.cd_centro_custo      = pc.cd_centro_custo and
                                                                          dlf.cd_funcionario       = @cd_funcionario_origem

  left outer join prestacao_conta_liberacao rvl          with (nolock) on rvl.cd_prestacao         = pc.cd_prestacao
  left outer join funcionario fl                         with (nolock) on fl.cd_funcionario        = pc.cd_funcionario

where 
--  @cd_centro_custo = dlf.cd_centro_custo and
  @cd_departamento = dlf.cd_departamento and

  pc.cd_prestacao = case when @cd_prestacao = 0 then pc.cd_prestacao else @cd_prestacao end and
  daf.cd_funcionario   <> pc.cd_funcionario
  and pc.dt_liberacao_aprovacao is null
  and case when isnull(fl.cd_funcionario_liberacao,0)=0
      then @cd_funcionario_origem 
      else fl.cd_funcionario_liberacao end            = @cd_funcionario_origem

order by
  pc.dt_prestacao

if @cd_requisicao_viagem<>0
begin
--  print '1'
  select * from #Requisicao order by dt_documento desc
end

if @cd_solicitacao_adto<>0
begin
--  print '1'
  select * from #Solicitacao_Adiantamento order by dt_documento desc
end

if @cd_solicitacao_adto<>0
begin
--print '1'
  select * from #Solicitacao_Pagamento order by dt_documento desc
end

if @cd_prestacao<>0
begin
--  print '1'
  select * from #Prestacao order by dt_documento desc
end

if @cd_requisicao_viagem = 0 and @cd_solicitacao_adto = 0 and @cd_solicitacao_pagto = 0 and @cd_prestacao = 0
begin
  select
    *
  into
    #Apresentacao
  from
    #Requisicao
  union all
    select * from #solicitacao_adiantamento
  union all
    select * from #solicitacao_pagamento
  union all
    select * from #prestacao

  select
    identity(int,1,1) as cd_controle,
    @ic_selecao                as Sel,
    a.*,
    f.nm_funcionario,
    d.nm_departamento,
    cc.nm_centro_custo,
    av.nm_assunto_viagem,
    tv.nm_tipo_viagem
  into
    #Controle_Apresentacao
  from
    #Apresentacao a
    left outer join Funcionario f     on f.cd_funcionario   = a.cd_funcionario
    left outer join Departamento d    on d.cd_departamento  = a.cd_departamento
    left outer join Centro_Custo cc   on cc.cd_centro_custo = a.cd_centro_custo
    left outer join Assunto_Viagem av on av.cd_assunto_viagem = a.cd_assunto_viagem
    left outer join Tipo_Viagem    tv on tv.cd_tipo_viagem    = a.cd_tipo_viagem
  order by
    cd_documento

  select
    *
  from
    #Controle_Apresentacao
  order by
    cd_documento 
  
end

end

if @ic_parametro = 9 and @cd_requisicao_viagem > 0
begin

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
  f.cd_funcionario_liberacao,
  rv.cd_tipo_viagem,
  cast(rv.ds_requisicao_viagem as varchar(8000)) as ds_documento

from 
  requisicao_viagem rv                                   with (nolock)
  left outer join funcionario f                          with (nolock) on f.cd_funcionario         = rv.cd_funcionario
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = rv.cd_departamento and
                                                                          dlf.cd_centro_custo      = rv.cd_centro_custo 
                                                                          

where 
  rv.cd_requisicao_viagem = case when @cd_requisicao_viagem = 0 then rv.cd_requisicao_viagem else @cd_requisicao_viagem end 
  
order by
  rv.dt_requisicao_viagem
  
end


if @ic_parametro = 9 and @cd_solicitacao_adto > 0
begin

select
  distinct
  'SA'              as ic_tipo_documento,
  sa.cd_solicitacao as cd_documento,
  sa.dt_solicitacao as dt_documento,
  sa.cd_funcionario,
  sa.cd_departamento,
  sa.cd_centro_custo,
  sa.cd_assunto_viagem,
  isnull(sa.vl_adiantamento,0)             as vl_documento,
  dlf.cd_funcionario                       as cd_funcionario_liberacao,
  0                                        as cd_tipo_viagem,
  cast(sa.ds_solicitacao as varchar(8000)) as ds_documento
 
from 
  Solicitacao_Adiantamento sa                            with (nolock)
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = sa.cd_departamento and
                                                                          dlf.cd_centro_custo      = sa.cd_centro_custo 


where 
  sa.cd_solicitacao = case when @cd_solicitacao_adto = 0 then sa.cd_solicitacao else @cd_solicitacao_adto end 

order by
  sa.dt_solicitacao

end

if @ic_parametro = 9 and @cd_solicitacao_pagto > 0
begin

select
  distinct
  'SP'                                     as ic_tipo_documento,
  sa.cd_solicitacao                        as cd_documento,
  sa.dt_solicitacao                        as dt_documento,
  sa.cd_funcionario,
  sa.cd_departamento,
  sa.cd_centro_custo,
  sa.cd_assunto_viagem,
  isnull(sa.vl_pagamento,0)                as vl_documento,
  dlf.cd_funcionario                       as cd_funcionario_liberacao,
  0                                        as cd_tipo_viagem, 
  cast(sa.ds_solicitacao as varchar(8000)) as ds_documento

from 
  Solicitacao_Pagamento sa                               with (nolock)
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = sa.cd_departamento and
                                                                          dlf.cd_centro_custo      = sa.cd_centro_custo 

where 
  sa.cd_solicitacao = case when @cd_solicitacao_pagto = 0 then sa.cd_solicitacao else @cd_solicitacao_pagto end 

order by
  sa.dt_solicitacao

end

if @ic_parametro = 9 and @cd_prestacao > 0
begin

select
  distinct
  'PC'                    as ic_tipo_documento,
  pc.cd_prestacao         as cd_documento,
  pc.dt_prestacao         as dt_documento,
  pc.cd_funcionario,
  pc.cd_departamento,
  pc.cd_centro_custo,
  pc.cd_assunto_viagem,
  case when isnull(pc.vl_prestacao,0)=0 
  then
   --select * from prestacao_conta_composicao
   ( select sum( isnull(vl_total_despesa,0) ) from prestacao_conta_composicao where cd_prestacao = pc.cd_prestacao )
  else
    isnull(pc.vl_prestacao,0) *
    case when isnull(pc.vl_prestacao,0)>0 
    then
      1
    else
      -1
    end 
  end                                    as vl_documento, 
  dlf.cd_funcionario                     as cd_funcionario_liberacao,
  0                                      as cd_tipo_viagem,
  cast(pc.ds_prestacao as varchar(8000)) as ds_documento
  

from 
  prestacao_conta pc                                     with (nolock)
  inner join      departamento_liberacao_funcionario dlf with (nolock) on dlf.cd_departamento      = pc.cd_departamento and
                                                                          dlf.cd_centro_custo      = pc.cd_centro_custo 
where 

  pc.cd_prestacao = case when @cd_prestacao = 0 then pc.cd_prestacao else @cd_prestacao end 

order by
  pc.dt_prestacao

end

