
-------------------------------------------------------------------------------
--pr_busca_turno_maquina
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Busca o Horário de Início do 1o. Turno e Horário Final do último turno que a 
--                   a máquina opera
--Data             : 05.11.2005
--Atualizado       : 05.11.2005
--------------------------------------------------------------------------------------------------
create procedure pr_busca_turno_maquina
@cd_maquina int = 0
as

select 
  mt.cd_maquina,
  mt.cd_turno,
  mt.qt_hora_operacao_maquina,
  t.hr_inicio_turno,
  t.hr_fim_turno
into #AuxMaqTurno
from 
  maquina_turno mt 
  inner join turno t on t.cd_turno = mt.cd_turno 
where 
  mt.cd_maquina              = case when @cd_maquina=0 then mt.cd_maquina else @cd_maquina end and
  isnull(mt.ic_operacao,'N') = 'S'
order by 
  mt.cd_maquina,
  mt.cd_turno
  
--select * from #AuxMaqTurno

declare @hr_inicio varchar(8)
declare @hr_final  varchar(8)
declare @cd_maq    int
declare @cd_turno  int

set @hr_inicio = ''

while exists ( select top 1 cd_maquina from #AuxMaqTurno )
begin
  select top 1
    @cd_maq    = cd_maquina,
    @cd_turno  = cd_turno,
    @hr_inicio = case when isnull(@hr_inicio,'')= '' then hr_inicio_turno else @hr_inicio end,
    @hr_final  = hr_fim_turno
  from
    #AuxMaqTurno
  order by 
   cd_maquina,
   cd_turno
  
  delete from #AuxMaqTurno where @cd_maq = cd_maquina and @cd_turno = cd_turno    

end

select 
  @cd_maquina as cd_maquina,
  @hr_inicio  as hr_inicio_turno,
  @hr_final   as hr_fim_turno

