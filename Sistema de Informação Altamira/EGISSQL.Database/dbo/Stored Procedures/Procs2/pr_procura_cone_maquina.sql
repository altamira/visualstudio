

/****** Object:  Stored Procedure dbo.pr_procura_cone_maquina    Script Date: 13/12/2002 15:08:39 ******/
--pr_procura_cone_maquina
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton Marques de Souza
--Procura cone nas máquinas
--Data         : 20.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
create procedure pr_procura_cone_maquina
@cd_Cone int,
@data datetime
as
declare @cdMov int
set @cdMov = 0
select  @cdMov = max(cd_movimento)
from   Movimento_Cone
where  cd_cone=@cd_Cone and
       cd_tipo_movimento=1
 
select a.dt_movimento_cone   as 'data',
       b.nm_fantasia_maquina as 'maquina',
       c.nm_fantasia_usuario as 'usuario',
       retorno =
       case 
         when convert(int,(select qt_tempo_retorno_cone from Ferramenta_cone where cd_cone=@cd_Cone)-(@data - (select dt_movimento_cone from Movimento_cone where cd_cone=@cd_Cone and cd_movimento=@cdMov)))> 0 then 
                convert(int,(select qt_tempo_retorno_cone from Ferramenta_cone where cd_cone=@cd_Cone)-(@data - (select dt_movimento_cone from Movimento_cone where cd_cone=@cd_Cone and cd_movimento=@cdMov)))
         when convert(int,(select qt_tempo_retorno_cone from Ferramenta_cone where cd_cone=@cd_Cone)-(@data - (select dt_movimento_cone from Movimento_cone where cd_cone=@cd_Cone and cd_movimento=@cdMov)))<=0 then 0
       end,
       convert(int,(@Data - a.dt_movimento_cone)) as 'Operacao'
 
from   Movimento_Cone a, Maquina b, SapAdmin.dbo.usuario c
where  a.cd_movimento= @cdMov      and
       a.cd_maquina = b.cd_maquina and
       a.cd_usuario = c.cd_usuario
   
 


