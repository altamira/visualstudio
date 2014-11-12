
-------------------------------------------------------------------------------
--pr_consulta_data_agenda_livre_visita
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Checagem da Agenda de Visita do Vendedor
--Data             : 16/01/2005
--Atualizado       
--------------------------------------------------------------------------------
create procedure pr_consulta_data_agenda_livre_visita
@cd_vendedor int,       --Vendedor
@dt_inicial  datetime,  --Data Inicial da Visita
@dt_final    datetime   --Data Final

as




declare @qt_visita_diaria        int  --Quantidade de Visitas Díária
declare @qt_visita_agenda        int  --Quantidade de Visitas Agendada
declare @qt_saldo_visita         int  --Quantidade de Saldos de Visitas a Realizar
declare @dt_proxima_visita       datetime
declare @qt_saldo_proxima_visita int

set @qt_visita_diaria        = 0
set @qt_visita_agenda        = 0
set @qt_saldo_visita         = 0
set @qt_saldo_proxima_visita = 0

--Visita Diária do Cadastro de Vendedor

select @qt_visita_diaria = isnull(qt_visita_diaria_vendedor,0)
from
  Vendedor
where
  cd_vendedor = @cd_vendedor


--Verifica se a Visita Diária é Zero e Busca da Tabela de Parâmetro CRM

if @qt_visita_diaria = 0 
begin

  --select * from parametro_crm
  select @qt_visita_diaria = isnull(qt_visita_vendedor,0)
  from
     Parametro_CRM
  where
     cd_empresa = dbo.fn_empresa()

end


select 
  @cd_vendedor      as cd_vendedor,
  a.dt_agenda       as DataVisita,
  a.ic_util         as Util,
  @qt_visita_diaria as VisitaDiaria,
  VisitaAgendada = ( 
     select isnull ( count(*) , 0 ) 
     from
      Visita 
    where
     cd_vendedor = @cd_vendedor and
     dt_visita   = a.dt_agenda )
into 
  #AgendaVisita   
from
  Agenda a 

where
 a.dt_agenda between @dt_inicial and @dt_final


select 
  *,
  VisitaDiaria-VisitaAgendada as Saldo 
from 
  #AgendaVisita
where
  ( VisitaDiaria-VisitaAgendada ) > 0

