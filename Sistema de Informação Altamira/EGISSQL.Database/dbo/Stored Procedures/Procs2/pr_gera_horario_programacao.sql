
-------------------------------------------------------------------------------
--pr_gera_horario_programacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Geração do Horário de Programação - Programacao_Composição
--                   Entrada tem que ser hora decimal
--
--Data             : 05.11.2005
--Atualizado       : 05.11.2005
--
--------------------------------------------------------------------------------------------------
create procedure pr_gera_horario_programacao
@hr_entrada      varchar(8),
@qt_hora_entrada float        --Hora Decimal
as


declare @hora    float
declare @minuto  float
declare @segundo float
declare @qt_hora float
declare @hr_saida varchar(8)

set @hora    = cast(substring(@hr_entrada,1,2) as float )
set @minuto  = cast(substring(@hr_entrada,4,2) as float )/60
set @segundo = cast(substring(@hr_entrada,7,2) as float )/3600


set @qt_hora = @hora + @minuto + @segundo 

--  select @hora,
--         @minuto,
--         @segundo
-- 
--  select @qt_hora
--  select @qt_hora + @qt_hora_entrada

set @qt_hora = @qt_hora + @qt_hora_entrada

--Conversão

set @hora    = cast( cast(@qt_hora as int) as float)
set @minuto  = cast( cast((@qt_hora-@hora)*60 as int ) as float )
set @segundo = cast( cast(((@qt_hora-@hora)*60-@minuto)*60 as int ) as float )

-- select @hora,
--        @minuto,
--        @segundo

declare @ch varchar(2)
declare @cm varchar(2)
declare @cs varchar(2)

set @ch = case when @hora<10 then '0'+cast(@hora as varchar(2))
                             else cast(@hora as varchar(2)) end

set @cm = case when @minuto<10 then '0'+cast(@minuto as varchar(2))
                               else cast(@minuto as varchar(2)) end


set @cs = case when @segundo<10 then '0'+cast(@segundo as varchar(2))
                                else cast(@segundo as varchar(2)) end

set @hr_saida = @ch+':'+@cm+':'+@cs

select @hr_saida as hr_saida

