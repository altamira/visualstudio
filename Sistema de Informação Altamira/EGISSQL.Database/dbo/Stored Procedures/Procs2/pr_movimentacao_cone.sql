

/****** Object:  Stored Procedure dbo.pr_movimentacao_cone    Script Date: 13/12/2002 15:08:36 ******/
--pr_movimentacao_cone
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Monstra a Movimentaçao por Cone
--Data         : 15.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_movimentacao_cone
@cd_cone    int,
@dt_inicial datetime,
@dt_final   datetime
as
declare @dt_dia datetime
set     @dt_dia = getdate()
select a.dt_movimento_cone              as 'data',
       a.cd_tipo_movimento, 
       b.nm_tipo_movimento              as 'tipomovimento',
       c.nm_fantasia_maquina            as 'maquina',
       isnull(a.qt_dia_operacao_cone,0) as 'dias',
       d.nm_fantasia_usuario            as 'usuario'
 
     
from 
  movimento_cone a,tipo_movimento_cone b,maquina c,SapAdmin.dbo.usuario d
where
  @cd_cone            = a.cd_cone           and
  a.dt_movimento_cone between @dt_inicial   and @dt_final and
  a.cd_tipo_movimento = b.cd_tipo_movimento and
  a.cd_maquina        = c.cd_maquina        and
  a.cd_usuario        = d.cd_usuario
order by
  a.dt_movimento_cone


