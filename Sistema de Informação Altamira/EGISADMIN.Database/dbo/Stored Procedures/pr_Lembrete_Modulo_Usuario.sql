--pr_Mostra_Menu_Modulo
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Carlos Cardoso Fernandes
--Busca os Lembrete por Módulo e Usuário
--Data          : 27.06.2002
--Atualizado    : 
--              : 
---------------------------------------------------------------------------------------

CREATE procedure pr_Lembrete_Modulo_Usuario
@cd_modulo  int,
@cd_usuario int
as

select
  ul.dt_usuario_lembrete, 
  pl.*
from
  Processo_Lembrete pl,Usuario_Lembrete Ul
where
  pl.cd_modulo  = @cd_modulo  and
  ul.cd_usuario = @cd_usuario and
  ul.dt_usuario_lembrete is null and 
  ul.cd_processo_lembrete = pl.cd_processo_lembrete 

