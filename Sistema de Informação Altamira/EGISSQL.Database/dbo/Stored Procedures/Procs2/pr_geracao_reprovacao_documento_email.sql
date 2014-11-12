
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_reprovacao_documento_email
-------------------------------------------------------------------------------
--pr_geracao_reprovacao_documento_email
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Reprovação de Documentos por e-mail
--Data             : 23.10.2007
--Alteração        : 23.11.2007 - Aprovação da Solicitação de Adiantamento - Carlos Fernandes
--24.11.2007 - Finalização dos tipos de documento para aprovação - Carlos Fernandes
--09.02.2008 - Acerto do Funcionário da Reprovação - Carlos Fernandes
----------------------------------------------------------------------------------------------
create procedure pr_geracao_reprovacao_documento_email
@cd_documento       int         = 0,
@cd_tipo_assinatura int         = 0,
@cd_usuario         int         = 0,
@ic_tipo_aprovacao  char(1)     = 'N', --Sim ou Não
@nm_obs_documento   varchar(40) = '',
@ic_parametro       int         = 0    --1:inclusão 2:exclusão
as

declare @cd_funcionario    int
declare @cd_tipo_aprovacao int

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

if @cd_tipo_assinatura = 1 and @cd_documento>0 
begin

  declare @cd_solicitacao int

  select
    top 1
    @cd_solicitacao = isnull(cd_solicitacao,0),
    @cd_funcionario = isnull(cd_funcionario_aprovacao,0) 

  from
    Solicitacao_Adiantamento 
  where
    cd_requisicao_viagem = @cd_documento
  order by
    cd_requisicao_viagem  

  --Localiza o usuário correto da Aprovação

  select
    top 1
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(cd_funcionario_aprovacao,0) 
  from
    requisicao_viagem rv
    left outer join egisadmin.dbo.usuario u on u.cd_funcionario = rv.cd_funcionario_aprovacao
  where
    cd_requisicao_viagem = @cd_documento
  order by
    cd_requisicao_viagem

  if @ic_parametro = 1
  begin

    delete from requisicao_viagem_aprovacao        where cd_requisicao_viagem = @cd_documento   and cd_usuario_aprovacao = @cd_usuario
    delete from solicitacao_adiantamento_aprovacao where cd_solicitacao       = @cd_solicitacao and cd_usuario_aprovacao = @cd_usuario

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
    --select * from solicitacao_adiantamento

    --Solicitação de Adiantamento
    --select * from solicitacao_adiantamento_aprovacao

    if @cd_solicitacao>0
    begin
      insert into
        Solicitacao_Adiantamento_Aprovacao 
      select
        @cd_solicitacao                    as cd_solicitacao,
        @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
        @cd_usuario                        as cd_usuario_aprovacao,
        getdate()                          as dt_usuario_aprovacao,
        'Reprovado via e-mail'             as nm_obs_aprovacao,
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
    top 1

    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(cd_funcionario_aprovacao,0) 

  from
    solicitacao_adiantamento sa
    left outer join egisadmin.dbo.usuario u on u.cd_funcionario = sa.cd_funcionario_aprovacao
  where
    sa.cd_solicitacao = @cd_documento
  order by
    sa.cd_solicitacao 

  delete from solicitacao_adiantamento_aprovacao where cd_solicitacao = @cd_documento and cd_usuario_aprovacao = @cd_usuario

  if @ic_parametro = 1
  begin

    insert into
      Solicitacao_Adiantamento_Aprovacao 
    select
      @cd_documento                      as cd_solicitacao,
      @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
      @cd_usuario                        as cd_usuario_aprovacao,
      getdate()                          as dt_usuario_aprovacao,
      'Reprovado via e-mail'             as nm_obs_aprovacao,
      @cd_usuario                        as cd_usuario,
      getdate()                          as dt_usuario,
      @ic_tipo_aprovacao                 as ic_aprovado,
      @cd_funcionario                    as cd_funcionario

  end

  --Deleta as Aprovações

  if @ic_parametro = 2
  begin
    delete from solicitacao_adiantamento_aprovacao where cd_solicitacao = @cd_documento and cd_usuario_aprovacao = @cd_usuario
  end

end


------------------------------------------------------------------------------
--Prestação de Contas
------------------------------------------------------------------------------
if @cd_tipo_assinatura = 3 and @cd_documento>0 
begin

  --Localiza o usuário correto da Aprovação

  select
    top 1
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(cd_funcionario_aprovacao,0) 

  from
    prestacao_conta pc
    left outer join egisadmin.dbo.usuario u on u.cd_funcionario = pc.cd_funcionario_aprovacao
  where
    pc.cd_prestacao = @cd_documento
  order by
    pc.cd_prestacao

  --select * from prestacao_conta_aprovacao

  delete from prestacao_conta_aprovacao where cd_prestacao = @cd_documento and cd_usuario_aprovacao = @cd_usuario

  if @ic_parametro = 1
  begin

    insert into
      Prestacao_Conta_Aprovacao 
    select
      @cd_documento                      as cd_prestacao,
      @cd_tipo_aprovacao                 as cd_tipo_aprovacao,
      @cd_usuario                        as cd_usuario_aprovacao,
      getdate()                          as dt_usuario_aprovacao,
      'Reprovado via e-mail'             as nm_obs_aprovacao,
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
    top 1
    @cd_usuario     = isnull(u.cd_usuario,@cd_usuario),
    @cd_funcionario = isnull(cd_funcionario_aprovacao,0) 

  from
    solicitacao_pagamento sp
    inner join egisadmin.dbo.usuario u on u.cd_funcionario = sp.cd_funcionario_aprovacao
  where
    sp.cd_solicitacao = @cd_documento
  order by
    sp.cd_solicitacao

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
        'Reprovado via e-mail'             as nm_obs_aprovacao,
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


