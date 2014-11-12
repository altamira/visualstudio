
-----------------------------------------------------------------------------------
--pr_exclusao_programacao_reserva
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Daniel C. Neto.
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Reserva
--                   Exclusão Completa da Programação por Reserva
--                                               
--                                                
--
--Data             : 05/08/2004
-----------------------------------------------------------------------------------
create procedure pr_exclusao_programacao_reserva
@cd_reserva                int,        --Processo
@cd_programacao_exc        int=0,      --Programação
@cd_item_programacao       int=0       --Item da Programação

as
begin

  --Montagem de uma tabela temporária para exclusão das programações
  --Atualização das horas da tabela de Programação

  select 
    cd_programacao,   
    cd_item_programacao,
    cd_reserva_programacao,
    qt_hora_prog_operacao

  into
    #Programacao
  from 
    programacao_composicao
  where
    IsNull(cd_reserva_programacao,0) = @cd_reserva  and
    cd_programacao = ( case when @cd_programacao_exc = 0 then cd_programacao 
                                                         else @cd_programacao_exc end ) and
     cd_item_programacao = ( case when @cd_item_programacao = 0 then cd_item_programacao
                                                                else @cd_item_programacao end ) 

 
  declare @cd_programacao        int
  declare @cd_item_prog          int
  declare @qt_hora_prog_operacao float
  declare @cd_item_processo      int

  while exists ( select top 1 cd_programacao from #Programacao ) 
  begin

    select top 1   
      @cd_programacao        = cd_programacao,
      @cd_item_prog          = cd_item_programacao,
      @qt_hora_prog_operacao = qt_hora_prog_operacao
    from
      #Programacao

    --Atualiza a Horas de Programação da Tabela que Controla a Programação
    
    update
      Programacao
    set
      qt_hora_prog_maquina = qt_hora_prog_maquina - @qt_hora_prog_operacao 
    where
      cd_programacao = @cd_programacao 



    --Deleta o item da tabela temporária
    delete from #Programacao where cd_programacao      = @cd_programacao and
                                   cd_item_programacao = @cd_item_prog
                
    
  end
  

  --Atualiza o Processo com Dados da Programacao

  --Somente quando for o Processo completo
  --Deleta todos os registros referente a reserva
  delete 
  from 
     programacao_composicao
  where
    IsNull(cd_reserva_programacao,0) = @cd_reserva  and
    cd_programacao = ( case when @cd_programacao_exc = 0 then cd_programacao 
                                                         else @cd_programacao_exc end ) and

    cd_item_programacao = ( case when @cd_item_programacao = 0 then cd_item_programacao 
                                                               else @cd_item_programacao end ) 

end
