
-----------------------------------------------------------------------------------
--pr_limpeza_exclusao_programacao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a limpeza total / exclusão dos registros das tabelas
--                   Programacao
--                   Programacao_Composição
--
--Data             : 13.07.2004
--Alteração        : 
--                   
--
-----------------------------------------------------------------------------------
create procedure pr_limpeza_exclusao_programacao
@cd_maquina          int         --Máquina

as
begin


--Tabela temporária para deleção

  select 
     cd_programacao
  into
     #Programacao
  from
     Programacao p
  where
     p.cd_maquina = case when @cd_maquina = 0 then p.cd_maquina
                                              else @cd_maquina end 
      
  --Deleta a Programação da Máquina
  delete from programacao_composicao where cd_programacao in ( select cd_programacao from #Programacao )

  delete from programacao where cd_programacao in ( select cd_programacao from #Programacao )

end
