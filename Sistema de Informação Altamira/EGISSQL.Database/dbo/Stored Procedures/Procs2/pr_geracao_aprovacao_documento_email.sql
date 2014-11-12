
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_aprovacao_documento_email
-------------------------------------------------------------------------------
--pr_geracao_aprovacao_documento_email
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Aprovação de Documentos por e-mail
--Data             : 23.10.2007
--Alteração        : 23.11.2007 - Aprovação da Solicitação de Adiantamento - Carlos Fernandes
--24.11.2007 - Finalização dos tipos de documento para aprovação - Carlos Fernandes
--30.11.2007 - Atualização do Flag de Gerado e-mail - Carlos Fernandes
--09.02.2008 - Acerto do usuário da Aprovação/Funcionário - Carlos Fernandes
--26.02.2008 - Atualização do Comentário - digitado na página de Aprovação - Carlos Fernandes
--20.03.2008 - Acerto da Atualização do Aprovador - Carlos Fernandes
--28.03.2008 - Modificação do Status da RV sem valor - Carlos Fernandes
--09.06.2008 - Duplicidade de Aprovação - Carlos Fernandes
----------------------------------------------------------------------------------------------
create procedure pr_geracao_aprovacao_documento_email
@cd_documento       int         = 0,
@cd_tipo_assinatura int         = 0,
@cd_usuario         int         = 0,
@ic_tipo_aprovacao  char(1)     = 'N', --Sim ou Não
@nm_obs_documento   varchar(40) = '',
@ic_parametro       int         = 0    --1:inclusão 2:exclusão
as

declare @cd_funcionario       int
declare @cd_tipo_aprovacao    int

select
  @cd_tipo_aprovacao = isnull(cd_tipo_aprovacao,0)
from
  egisadmin.dbo.usuario  
where
  cd_usuario = @cd_usuario

------------------------------------------------------------------------------
--Tipos de Assinatura / Aprovação
------------------------------------------------------------------------------
--1 : Requisição  de viagem
--2 : Solicitação de Adiantamento
--3 : Prestação   de Contas
--4 : Solicitação de Pagamento
--5 : Autorização de Pagamento
------------------------------------------------------------------------------


set @cd_funcionario = 0

------------------------------------------------------------------------------
--Requisição de Viagem
------------------------------------------------------------------------------
--select cd_tipo_aprovacao,* from egisadmin.dbo.usuario
--select * from requisicao_viagem_aprovacao
--select * from requisicao_viagem
--select * from solicitacao_adiantamento 

if @cd_tipo_assinatura = 1 and @cd_documento>0 
begin

  declare @cd_solicitacao int
  declare @vl_adto_viagem decimal(25,2)

  select
    top 1
    @cd_solicitacao = isnull(cd_solicitacao,0),
    @cd_funcionario = isnull(cd_funcionario_aprovacao,0)
  from
    Solicitacao_Adiantamento with (nolock)
  where
    cd_requisicao_viagem = @cd_documento
  order by
    cd_requisicao_viagem

  --Localiza o usuário correto da Aprovação

  select
    top 1
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(rv.cd_funcionario_aprovacao,@cd_funcionario),
    @vl_adto_viagem = isnull(vl_adto_viagem,0) 

  from
    requisicao_viagem rv with (nolock)
    left outer join egisadmin.dbo.usuario u on u.cd_funcionario = rv.cd_funcionario_aprovacao
  where
    cd_requisicao_viagem = @cd_documento
  order by
    cd_requisicao_viagem        

--  select @cd_usuario,@cd_funcionario

  if @ic_parametro = 1
  begin

    --Atualiza a Requisição de Viagem com o Status de Fechado

    if @vl_adto_viagem = 0
    begin
      update
        requisicao_viagem
      set
        cd_status_requisicao = 4
      from
        requisicao_viagem rv
        inner join tipo_adiantamento ta on ta.cd_tipo_adiantamento = rv.cd_tipo_adiantamento
      where
        rv.cd_requisicao_viagem = @cd_documento and
        isnull(ic_gera_adiantamento,'S') = 'N'  --O tipo de Adiantamento não pode gerar Adiantamento
  

    end

    delete from requisicao_viagem_aprovacao        where cd_requisicao_viagem = @cd_documento   and cd_usuario_aprovacao = @cd_usuario
    delete from solicitacao_adiantamento_aprovacao where cd_solicitacao       = @cd_solicitacao and cd_usuario_aprovacao = @cd_usuario

    --Deleta a Aprovação
    delete from requisicao_viagem_aprovacao
    where
      cd_requisicao_viagem = @cd_documento      and
      cd_tipo_aprovacao    = @cd_tipo_aprovacao and
      cd_funcionario       = @cd_funcionario


    --Insere a Aprovação
    insert into 
      requisicao_viagem_aprovacao
    select
      @cd_documento                      as cd_requisicao_viagem,
      ( select isnull( max ( isnull(cd_item_aprovacao,0) ),0) + 1 from requisicao_viagem_aprovacao where cd_requisicao_viagem = @cd_documento )
                                         as cd_item_aprovacao,
      @cd_usuario                        as cd_usuario_aprovacao,
      getdate()                          as dt_aprovacao_req_viagem,
      @nm_obs_documento                  as nm_obs_aprovacao,
      @cd_usuario                        as cd_usuario,
      getdate()                          as dt_usuario,
      @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
      @ic_tipo_aprovacao                 as ic_aprovado,
      @cd_funcionario                    as cd_funcionario
    
    --select * from requisicao_viagem
    --select * from requisicao_viagem_aprovacao
    --select * from solicitacao_adiantamento

    --Solicitação de Adiantamento
    --select * from solicitacao_adiantamento_aprovacao

    if @cd_solicitacao>0
    begin

      update Solicitacao_Adiantamento
      set
        ic_email_solicitacao      = 'S',
        dt_liberacao_adiantamento = getdate(),
        cd_usuario_liberacao      = @cd_usuario
      where 
        cd_solicitacao       = @cd_solicitacao    

      delete Solicitacao_Adiantamento_Aprovacao 
      where
        cd_solicitacao    = @cd_solicitacao    and
        cd_tipo_aprovacao = @cd_tipo_aprovacao and
        cd_funcionario    = @cd_funcionario

      insert into
        Solicitacao_Adiantamento_Aprovacao 
      select
        @cd_solicitacao                    as cd_solicitacao,
        @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
        @cd_usuario                        as cd_usuario_aprovacao,
        getdate()                          as dt_usuario_aprovacao,
        'Aprovação via e-mail'             as nm_obs_aprovacao,
        @cd_usuario                        as cd_usuario,
        getdate()                          as dt_usuario,
        @ic_tipo_aprovacao                 as ic_aprovado,
        @cd_funcionario                    as cd_funcionario

    end
 
  end

  --Deleta as Aprovações

  if @ic_parametro = 2
  begin
    delete from requisicao_viagem_aprovacao        where cd_requisicao_viagem = @cd_documento   and cd_usuario_aprovacao = @cd_usuario
    delete from solicitacao_adiantamento_aprovacao where cd_solicitacao       = @cd_solicitacao and cd_usuario_aprovacao = @cd_usuario
  end

end

------------------------------------------------------------------------------
--Solicitação de Adiantamento
------------------------------------------------------------------------------

if @cd_tipo_assinatura = 2 and @cd_documento>0 
begin

  --Localiza o usuário correto da Aprovação

  select
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(sa.cd_funcionario_aprovacao,0)
  from
    solicitacao_adiantamento sa             with (nolock)
    left outer join egisadmin.dbo.usuario u with (nolock) on u.cd_funcionario = sa.cd_funcionario_aprovacao
  where
    sa.cd_solicitacao = @cd_documento


  delete from solicitacao_adiantamento_aprovacao 
  where 
     cd_solicitacao       = @cd_documento      and 
     cd_usuario_aprovacao = @cd_usuario        and
     cd_tipo_aprovacao    = @cd_tipo_aprovacao and
     cd_funcionario       = @cd_funcionario

  if @ic_parametro = 1
  begin

    insert into
      Solicitacao_Adiantamento_Aprovacao 
    select
      @cd_documento                      as cd_solicitacao,
      @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
      @cd_usuario                        as cd_usuario_aprovacao,
      getdate()                          as dt_usuario_aprovacao,
      'Aprovação via e-mail'             as nm_obs_aprovacao,
      @cd_usuario                        as cd_usuario,
      getdate()                          as dt_usuario,
      @ic_tipo_aprovacao                 as ic_aprovado,
      @cd_funcionario                    as cd_funcionario


  end

  --Deleta as Aprovações

  if @ic_parametro = 2
  begin
    delete from solicitacao_adiantamento_aprovacao 
    where 
       cd_solicitacao       = @cd_documento and 
       cd_usuario_aprovacao = @cd_usuario
  end

end


------------------------------------------------------------------------------
--Prestação de Contas
------------------------------------------------------------------------------
--select * from prestacao_conta

if @cd_tipo_assinatura = 3 and @cd_documento>0 
begin

  --Localiza o usuário correto da Aprovação

  select
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(pc.cd_funcionario_aprovacao,0)
  from
    prestacao_conta pc                      with (nolock) 
    left outer join egisadmin.dbo.usuario u with (nolock) on u.cd_funcionario = pc.cd_funcionario_aprovacao
  where
    pc.cd_prestacao = @cd_documento


  --select * from prestacao_conta_aprovacao

  delete from prestacao_conta_aprovacao 
  where 
     cd_prestacao         = @cd_documento and 
     cd_usuario_aprovacao = @cd_usuario

  if @ic_parametro = 1
  begin

    insert into
      Prestacao_Conta_Aprovacao 
    select
      @cd_documento                      as cd_prestacao,
      @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
      @cd_usuario                        as cd_usuario_aprovacao,
      getdate()                          as dt_usuario_aprovacao,
      'Aprovação via e-mail'             as nm_obs_aprovacao,
      @cd_usuario                        as cd_usuario,
      getdate()                          as dt_usuario,
      @ic_tipo_aprovacao                 as ic_aprovado,
      @cd_funcionario                    as cd_funcionario

  end

  --Deleta as Aprovações

  if @ic_parametro = 2
  begin
    delete from prestacao_conta_aprovacao where cd_prestacao = @cd_documento and cd_usuario_aprovacao = @cd_usuario
  end

end

------------------------------------------------------------------------------
--Solicitação de Pagamento
------------------------------------------------------------------------------
if @cd_tipo_assinatura = 4 and @cd_documento>0 
begin

  --Localiza o usuário correto da Aprovação

  select
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(sp.cd_funcionario_aprovacao,0)
  from
    solicitacao_pagamento sp
    left outer join egisadmin.dbo.usuario u on u.cd_funcionario = sp.cd_funcionario_aprovacao
  where
    sp.cd_solicitacao = @cd_documento

  --select * from solicitacao_pagamento_aprovacao

  delete from solicitacao_pagamento_aprovacao where cd_solicitacao = @cd_documento and cd_usuario_aprovacao = @cd_usuario

  if @ic_parametro = 1
  begin

    insert into
       Solicitacao_Pagamento_Aprovacao
    select
        @cd_documento                      as cd_solicitacao,
        @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
        @cd_usuario                        as cd_usuario_aprovacao,
        getdate()                          as dt_usuario_aprovacao,
        'Aprovação via e-mail'             as nm_obs_aprovacao,
        @cd_usuario                        as cd_usuario,
        getdate()                          as dt_usuario,
       ( select isnull( max ( isnull(cd_item_aprovacao,0) ),0) + 1 from solicitacao_pagamento_aprovacao where cd_solicitacao = @cd_documento )
                                           as cd_item_aprovacao,
        @ic_tipo_aprovacao                 as ic_aprovado,
        @cd_funcionario                    as cd_funcionario

  end

  --Deleta as Aprovações

  if @ic_parametro = 2
  begin
    delete from solicitacao_pagamento_aprovacao where cd_solicitacao = @cd_documento and cd_usuario_aprovacao = @cd_usuario
  end

end

------------------------------------------------------------------------------
--Autorização de Pagamento
------------------------------------------------------------------------------
