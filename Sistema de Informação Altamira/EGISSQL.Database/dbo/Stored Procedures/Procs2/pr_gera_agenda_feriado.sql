
-------------------------------------------------------------------------------
--sp_helptext pr_gera_agenda_feriado
-------------------------------------------------------------------------------
--pr_gera_agenda_feriado
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática da Agenda de Feriados
--Data             : 27.05.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_agenda_feriado
@cd_ano     int = 0
--@cd_usuario int = 0
as

--select * from feriado
--select * from agenda_feriado

--Deleta os registros anteriores para evitar violação de chave

--delete from agenda_feriado where year(dt_agenda_feriado)=@cd_ano
                               

select
 cast( substring(dt_padrao_feriado,4,2) + '/' + 
       substring(dt_padrao_feriado,1,2) + '/' + 
       cast(@cd_ano as varchar(4))  as datetime ) dt_agenda_feriado,
 cd_feriado,
 'geração automática'  as nm_observacao_feriado,
 0                     as cd_usuario,
 getdate()             as dt_usuario
into
 #agenda
from
  feriado
where
  isnull(ic_padrao_feriado,'N')='S' and
  dt_padrao_feriado is not null


--select * from #agenda

insert into
  agenda_feriado
select
  *
from
  #agenda 

 
--select * from ano
--delete from agenda_feriado where year(dt_agenda_feriado)=2010
