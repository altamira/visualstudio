create procedure pr_atualiza_programacao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a atualização da tabela programação
--                   com os dados de cálculo da programação/máquina
--Data             : 16.05.2004
--Alteração        : 12.06.2004
-----------------------------------------------------------------------------------
@cd_maquina          int,         --Máquina
@dt_programacao      datetime,    --Data da Programação
@qt_hora_programacao float,       --Quantidade horas
@ic_parametro        int,         --Parametro 
@cd_programacao      int,         --Código da Programação
@cd_item_programacao int          --Item   da Programação

--@ic_parametro 
--0 = Adição
--1 = Subtração
--9 = Realiza a Atualização das horas na tabela de programação composição
as
begin

   --Atualização da tabela de programação composição
   update
     Programacao_composicao
   set
     qt_hora_prog_operacao = @qt_hora_programacao
   where
     cd_programacao      = @cd_programacao       and
     cd_item_programacao = @cd_item_programacao


  --Adição
  update
     Programacao
  set
     qt_hora_prog_maquina = IsNull((select sum(IsNull(qt_hora_prog_operacao,0)) 
                             from Programacao_composicao 
                             where cd_programacao = @cd_programacao),0)
  where
     cd_programacao = @cd_programacao

end

