--pr_Mostra_Menu_Modulo
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Carlos Cardoso Fernandes
--Consulta de Menu utizados nos Módulos
--Data          : 26.06.2002
--Atualizado    : 
--              : 
---------------------------------------------------------------------------------------

CREATE procedure pr_Mostra_Menu_Modulo
@cd_menu int
as

select
  cv.nm_cadeia_valor,
   m.nm_modulo,
   f.nm_funcao,
  me.nm_menu,
 mfm.* 
from 
  Cadeia_Valor cv,
  Modulo_funcao_menu mfm,
  Modulo m, 
  Funcao f,
  Menu me
Where
  cv.cd_cadeia_valor = m.cd_cadeia_valor and
  m.cd_modulo = mfm.cd_modulo and
  f.cd_funcao = mfm.cd_funcao and
  me.cd_menu   = mfm.cd_menu  and
  mfm.cd_menu  = @cd_menu
order by
   mfm.cd_modulo

