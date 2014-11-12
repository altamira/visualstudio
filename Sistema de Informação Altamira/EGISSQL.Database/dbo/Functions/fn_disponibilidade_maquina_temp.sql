--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2003
--Stored Procedure : SQL Server 2000
--Autor		   : Fabio Cesar Magalhães
--Objetivo	 : Apresentar as informações das máquinas da view que serão utilizadas em mapas
--Data       : 29.04.2004
--Atualizado : 
--
-------------------------------------------------------------------------------------------

CREATE FUNCTION fn_disponibilidade_maquina_temp
(@cd_maquina       int,
 @dt_disponibilidade datetime)
RETURNS float
as 
Begin
    declare @qt_disponibilidade decimal(18,4)

    Select 
      @qt_disponibilidade = sum(IsNull(qt_hora_operacao_maquina,0)) 
    from 
      maquina_turno mt
--     left outer join 
--       maquina_turno_operacao mto
    where 
      mt.cd_maquina = @cd_maquina--  m.cd_maquina 
--       and IsNull(mt.ic_operacao,'S') = 'S'
--       and mt.cd_turno = 


-- case datepart(dw,@dt_disponibilidade)

  return @qt_disponibilidade
end
