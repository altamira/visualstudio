
-----------------------------------------------------------------------------------
--pr_reserva_programacao_maquina
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Reserva de Programação Máquina
--                   Consulta da Reserva da Programação da Máquina
--                   
--
--Data             : 11.06.2004
--Alteração        : 
--                   
-- 25/06/2004 - Incluído nome do Usuário. - Daniel C. Neto.
-----------------------------------------------------------------------------------
create procedure pr_reserva_programacao_maquina

@dt_inicial as datetime,
@dt_final   as datetime,
@cd_maquina as int

as

  select 
    rm.cd_reserva_programacao,
    rm.dt_reserva_programacao,
    rm.cd_maquina,
    rm.qt_hora_reserva_prog,
    rm.cd_tipo_reserva_maquina,
    rm.cd_cliente,
    rm.nm_obs_reserva_prog,
    rm.cd_usuario,
    rm.dt_inicio_reserva_prog,
    rm.dt_final_reserva_prog,
    m.nm_fantasia_maquina,
    c.nm_fantasia_cliente,
    tr.nm_tipo_reserva_maquina,
    rm.dt_usuario,
    rm.ds_reserva_programacao,
    u.nm_fantasia_usuario,
    ( select count(cd_turno)
      from Maquina_Turno mt 
      where mt.cd_maquina = rm.cd_maquina ) as qt_turno,
    ( select sum(qt_hora_operacao_maquina)
      from Maquina_Turno mt 
      where mt.cd_maquina = rm.cd_maquina ) as qt_hora_operacao,
    a.dt_disp_carga_maquina
      
  from
    Reserva_Programacao rm
    left outer join Maquina m               on m.cd_maquina               = rm.cd_maquina
    left outer join Tipo_Reserva_maquina tr on tr.cd_tipo_reserva_maquina = rm.cd_tipo_reserva_maquina 
    left outer join Cliente c               on c.cd_cliente               = rm.cd_cliente             
    left outer join EGISADMIN.dbo.Usuario u on u.cd_usuario = rm.cd_usuario
	  left outer join Carga_maquina a         on a.cd_maquina = rm.cd_maquina 

  where
    rm.dt_reserva_programacao between @dt_inicial and @dt_final and
    rm.cd_maquina = ( case @cd_maquina when 0 then rm.cd_maquina
                                       else @cd_maquina 
                      end
                     )


