
-----------------------------------------------------------------------------------
--pr_exclusao_programacao_processo
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Exclusão Completa da Programação por Processo
--                                               
--                                                
--
--Data             : 12.06.2004
--Alteração        : 12.06.2004
--                   19.06.2004 - Limpeza da Data Real de Programação no Processo
-- 16/08/2004 - Limpeza da cd_maquina_processo - Daniel C. Neto.
-- 25/08/2004 - Gravação do campo ic_prog_mapa_processo - Daniel C. Neto.
-- 15/09/2004 - Acerto na atualização do Processo de Produção - Daniel C. Neto.
-- 05.09.2007 - Acertos Diversos - Carlos Fernandes
-- 28.09.2007 - Acerto da Situação da Ordem de Produção - Carlos Fernandes
-- 16.10.2007 - Verificação - Carlos Fernandes
-- 01.11.2007 - Acerto na data de programação do processo - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_exclusao_programacao_processo
@cd_processo               int = 0,      --Processo
@cd_programacao_exc        int = 0,      --Programação
@cd_item_programacao       int = 0       --Item da Programação

as

begin

  --Montagem de uma tabela temporária para exclusão das programações
  --Atualização das horas da tabela de Programação

  select 
    cd_programacao,   
    cd_item_programacao,
    cd_processo,
    cd_item_processo,
    qt_hora_prog_operacao

  into
    #Programacao
  from 
    programacao_composicao with (nolock)
  where
    IsNull(cd_processo,0) = @cd_processo  and
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
      @qt_hora_prog_operacao = qt_hora_prog_operacao,
      @cd_item_processo      = cd_item_processo
    from
      #Programacao

    --Atualiza a Horas de Programação da Tabela que Controla a Programação
    
    update
      Programacao
    set
      qt_hora_prog_maquina = qt_hora_prog_maquina - @qt_hora_prog_operacao 
    where
      cd_programacao = @cd_programacao 


    --Atualiza a data da Composição do Processo
  
    update
      Processo_Producao_Composicao
    set
      dt_prog_mapa_processo   = null,
      dt_programacao_processo = null,
      cd_maquina_processo     = null
    where
      cd_processo      = @cd_processo and
      cd_item_processo = @cd_item_processo

    --Deleta o item da tabela temporária
    delete from #Programacao where cd_programacao      = @cd_programacao and
                                   cd_item_programacao = @cd_item_prog
                
    
  end
  

  --Deleta todos os registros referente ao processo  

  delete 
  from 
     programacao_composicao
  where
    IsNull(cd_processo,0) = @cd_processo  and
    cd_programacao = ( case when @cd_programacao_exc = 0 then cd_programacao 
                                                         else @cd_programacao_exc end ) and

    cd_item_programacao = ( case when @cd_item_programacao = 0 then cd_item_programacao 
                                                               else @cd_item_programacao end ) 

--Atualiza o Processo com Dados da Programacao
--Somente quando for o Processo completo
if not exists ( select top 1 'x' from programacao_composicao where cd_processo = @cd_processo )
begin

    update
      Processo_Producao
    set
      cd_usuario_mapa_processo = 0,
      dt_prog_processo         = null,
      dt_entrega_prog_processo = null,
      ic_prog_mapa_processo    = 'N',
      nm_situacao_op           = null
    where
      cd_processo=@cd_processo

  
end



end
