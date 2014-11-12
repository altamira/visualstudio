

/****** Object:  Stored Procedure dbo.pr_verifica_tipo_movimento    Script Date: 13/12/2002 15:08:45 ******/
--pr_verifica_tipo_movimento
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Verifica o ultimo tipo de movimento do cone
--Data         : 20.03.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_verifica_tipo_movimento
@cd_cone int
as
if exists(select * from Movimento_Cone where cd_cone=@cd_cone)
begin
 select dt_movimento_cone as dt_movimento_cone,
        cd_movimento      as cd_movimento,
        cd_tipo_movimento
 from
   Movimento_Cone
 Where
   cd_cone = @cd_cone and
   cd_movimento = (select max(cd_movimento) from Movimento_Cone where cd_cone = @cd_cone) 
end
else
begin
  select
    dt_movimento_cone, 
    cd_movimento,
    cd_tipo_movimento
  from 
    Movimento_Cone
  where
    cd_cone=@cd_cone
end


