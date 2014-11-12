

/****** Object:  Stored Procedure dbo.pr_verifica_max_mov    Script Date: 13/12/2002 15:08:45 ******/
--pr_verifica_max_mov
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Verifica a maquina onde o cone está
--Data         : 20.03.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_verifica_max_mov
as
select 
  cd_movimento as MovCone,
  dt_movimento_cone
from 
  movimento_cone 
where cd_movimento = (select max(cd_movimento) from movimento_cone)


