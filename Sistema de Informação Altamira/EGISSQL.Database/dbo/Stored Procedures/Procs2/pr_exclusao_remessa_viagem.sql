
-------------------------------------------------------------------------------
--pr_exclusao_remessa_viagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão completa da Remessa da Viagem, caso não tenha sido
--                   fechada
--Data             : 07.05.2006
--Alteração        : 
--01.09.2008 - Exclusão Completa - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_exclusao_remessa_viagem

@cd_remessa_viagem int = 0

as


if @cd_remessa_viagem > 0 
begin
  
  --Verifica se a Remessa de Viagem não está fechada
 
  declare @dt_fechamento_viagem datetime

  select
    @dt_fechamento_viagem = dt_fechamento_viagem
  from
    Remessa_Viagem with(nolock)
  where
    cd_remessa_viagem = @cd_remessa_viagem

  --select @cd_remessa_viagem,@dt_fechamento_viagem

  if @dt_fechamento_viagem is null
  begin

    --Montagem da Tabela auxiliar para Exclusão de Documentos a Pagar e Receber

    select
      cd_remessa_viagem,
      cd_documento_receber
    into
      #AuxDocReceber
    from
      Remessa_Viagem_Parcela_Recebimento
    where
      cd_remessa_viagem = @cd_remessa_viagem      
        
    declare @cd_documento_receber int

    while exists ( select top 1 cd_documento_receber from #AuxDocreceber )
    begin
      select top 1 
        @cd_documento_receber = cd_documento_receber 
      from 
       #AuxDocreceber     
 
      delete from documento_receber where @cd_documento_receber = cd_documento_receber 

      delete from #AuxDocreceber    where  @cd_documento_receber = cd_documento_receber 
 
    end

    --Contas a Pagar

    select
      cd_remessa_viagem,
      cd_documento_pagar
    into
      #AuxDocPagar
    from
      Remessa_Viagem_Parcela
    where
      cd_remessa_viagem = @cd_remessa_viagem
    
    declare @cd_documento_pagar int

    while exists ( select top 1 cd_documento_pagar from #AuxDocPagar )
    begin
      select top 1 
        @cd_documento_pagar = cd_documento_pagar
      from 
       #AuxDocPagar
 
      delete from documento_pagar where @cd_documento_pagar = cd_documento_pagar

      delete from #AuxDocPagar    where @cd_documento_pagar = cd_documento_pagar
 
    end

    --Deleta as tabelas de Remessa

    delete from remessa_viagem_item_pedido         where cd_remessa_viagem = @cd_remessa_viagem
    delete from remessa_viagem_pedido_parcela      where cd_remessa_viagem = @cd_remessa_viagem
    delete from remessa_viagem_pedido              where cd_remessa_viagem = @cd_remessa_viagem
    delete from remessa_viagem_parcela             where cd_remessa_viagem = @cd_remessa_viagem
    delete from remessa_viagem_parcela_recebimento where cd_remessa_viagem = @cd_remessa_viagem
    delete from remessa_viagem_despesa             where cd_remessa_viagem = @cd_remessa_viagem
    delete from remessa_viagem                     where cd_remessa_viagem = @cd_remessa_viagem

  end  

end

--select * from remessa_viagem
--select * from documento_receber
--select * from remessa_viagem_parcela
--select * from remessa_viagem_parcela_recebimento
--select * from remessa_viagem_pedido_parcela

