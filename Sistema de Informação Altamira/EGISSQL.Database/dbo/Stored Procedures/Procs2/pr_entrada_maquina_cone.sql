

/****** Object:  Stored Procedure dbo.pr_entrada_maquina_cone    Script Date: 13/12/2002 15:08:28 ******/
--pr_entrada_maquina_cone
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Busca a Ultima da de Entrada do Cone em um máquina
--Data         : 15.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_entrada_maquina_cone
@cd_cone           int,
@cd_maquina        int,
@cd_tipo_movimento int
as
select a.cd_cone,max(a.dt_movimento_cone)   as 'data'
     
from 
  movimento_cone a
where
  @cd_cone           = a.cd_cone              and
  @cd_maquina        = a.cd_maquina           and 
  @cd_tipo_movimento = a.cd_tipo_movimento
group by
  a.cd_cone


