
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2007
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Geração da Prestação de Contas com a Requisição de Viagem
--Data           : 01.05.2007
--Atualizado     : 01.05.2007
--               : 01.05.2007
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_geracao_prestacao_requisicao_viagem
@cd_requisicao_viagem    int      = 0,
@cd_usuario              int      = 0
as

--select * from solicitacao_adiantamento
--select * from requisicao_viagem
--select * from prestacao_conta

  declare @Tabela		     varchar(50)
  declare @cd_prestacao              int

  set @cd_prestacao = 0

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Prestacao_Conta' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_prestacao', @codigo = @cd_prestacao output
	
  while exists(Select top 1 'x' from prestacao_conta where cd_prestacao = @cd_prestacao)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_prestacao', @codigo = @cd_prestacao output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_prestacao, 'D'
  end

  --select * from finalidade_adiantamento
  --select * from motivo_prestacao_conta

  select
    @cd_prestacao                                as cd_prestacao,
    getdate()                                    as dt_prestacao,

    isnull(( select top 1 cd_tipo_prestacao
      from
       Tipo_Prestacao_Conta 
      where 
         isnull(ic_pad_tipo_prestacao,'N')='S' ),0)
                                                 as cd_tipo_prestacao,

     ds_requisicao_viagem                        as ds_prestacao,
     cd_funcionario,
     cd_departamento,
     cd_centro_custo,
     'A'                                         as ic_status_prestacao,
     @cd_usuario                                 as cd_usuario,
     getdate()                                   as dt_usuario,

     isnull(( select top 1 cd_motivo_prestacao
      from
       Motivo_Prestacao_Conta 
      where 
         isnull(ic_pad_motivo_prestacao,'N')='S' ),0)

                                                 as cd_motivo_prestacao,
    cd_requisicao_viagem,
    cd_moeda,
    vl_total_viagem                              as vl_prestacao,

    isnull(
     (select top 1 cd_solicitacao 
     from solicitacao_adiantamento
     where
       cd_requisicao_viagem = rv.cd_requisicao_viagem),0)
                                                 as cd_solicitacao_adiantamento

  into
    #Prestacao_Conta 
  from
    Requisicao_Viagem rv
  where
    cd_requisicao_viagem = @cd_requisicao_viagem  


  insert into Prestacao_Conta
  select
    *
  from
    #Prestacao_Conta
   

  --Liberação do Código

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_prestacao, 'D'

  --Geração da Composição

  select @cd_prestacao as cd_prestacao

