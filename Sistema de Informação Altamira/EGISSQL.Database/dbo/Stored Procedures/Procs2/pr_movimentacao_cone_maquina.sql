

/****** Object:  Stored Procedure dbo.pr_movimentacao_cone_maquina    Script Date: 13/12/2002 15:08:36 ******/
--pr_movimentacao_cone_maquina
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Monstra a Movimentaçao por Máquina
--Data         : 15.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_movimentacao_cone_maquina
@cd_maquina int,
@dt_inicial datetime,
@dt_final   datetime
as
select a.dt_movimento_cone              as 'data',
       a.cd_cone                        as 'cone',
       a.cd_tipo_movimento, 
       b.nm_tipo_movimento              as 'tipomovimento',
       isnull(a.qt_dia_operacao_cone,0) as 'dias',
       d.nm_fantasia_usuario            as 'usuario'
     
from 
  movimento_cone a,tipo_movimento_cone b,SapAdmin.dbo.usuario d
where
  @cd_maquina         = a.cd_maquina        and
  a.dt_movimento_cone between @dt_inicial   and @dt_final and
  a.cd_tipo_movimento = b.cd_tipo_movimento and
  a.cd_usuario        = d.cd_usuario
order by
  a.dt_movimento_cone


