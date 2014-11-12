
-------------------------------------------------------------------------------
--pr_checagem_agenda_visita_vendedor
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
create procedure pr_checagem_agenda_visita_vendedor
@cd_vendedor int,       --Vendedor
@dt_inicial  datetime   --Data da Visita


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

--Calculo da Quantidade de Visitas Agendadas

select 
  @qt_visita_agenda = isnull ( count(*) , 0 ) 
from
  Visita 
where
  cd_vendedor = @cd_vendedor and
  dt_visita   = @dt_inicial  

--Saldo de Visitas

select @qt_saldo_visita = @qt_visita_diaria - @qt_visita_agenda

--Próxima Visita

declare @ic_proxima_visita char(1)
declare @ic_util           char(1)

set @ic_proxima_visita       = 'N' 
set @dt_proxima_visita       = @dt_inicial + 1 --Proxima Visita 

while @ic_proxima_visita = 'N' 
begin

  set @ic_util                 = 'N'
  set @qt_saldo_proxima_visita = 0

  --Verifica a agenda

  select 
    @dt_proxima_visita = dt_agenda,
    @ic_util           = isnull(ic_util,'N')
  from
    Agenda
  where
    dt_agenda = @dt_proxima_visita


  --Verifica se é dia útil

  if @ic_util = 'S'
  begin
    --Checa Data e Saldo da Visita

    select 
      @qt_saldo_proxima_visita = @qt_visita_diaria - isnull ( count(*) , 0 ) 
    from
      Visita 
    where
      cd_vendedor = @cd_vendedor and
      dt_visita   = @dt_proxima_visita

    --Verifica o Saldo de Visita na Data
     
    if @qt_saldo_proxima_visita>0 
    begin
      set @ic_proxima_visita = 'S' 
      set @dt_proxima_visita = @dt_proxima_visita - 1    
    end

  end

  --select @dt_proxima_visita,@ic_util,@qt_visita_diaria,@qt_saldo_proxima_visita
  

  set @dt_proxima_visita = @dt_proxima_visita + 1

end

--select * from agenda


select 
  @qt_visita_diaria        as VisitaDiaria,
  @qt_visita_agenda        as VisitaAgendada,
  @qt_saldo_visita         as SaldoVisita,
  @dt_proxima_visita       as ProximaVisita,
  @qt_saldo_proxima_visita as SaldoProximaVisita,
  @ic_util                 as Util


