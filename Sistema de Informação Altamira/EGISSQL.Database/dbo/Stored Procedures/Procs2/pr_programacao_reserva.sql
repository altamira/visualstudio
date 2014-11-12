
create procedure pr_programacao_reserva
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Daniel C. Neto.
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Reserva
--                   Executa a programação de reserva de máquina
--                   Sequenciamento das Operações
--Data             : 05/08/2004
--                   15/09/2004 - Incluída rotina para programar os dias de reserva de acordo com o período
--                                da reserva - Daniel C. Neto.
--                   23/09/2004 - Incluído novo parâmetro para evitar duplicações quando tiver mais de uma reserva
--                                no mesmo dia.
--                   02.02.2005 - Acerto da Programação com Diversos Dias - Carlos
-----------------------------------------------------------------------------------------------------------

@cd_reserva_programacao int,
@cd_maquina             int,
@dt_inicio_programacao  datetime,
@cd_usuario             int

--@cd_reserva            = número da reserva
--@dt_inicio_programacao = data de início da programação
--@cd_usuario            = usuário que fez a programação
--@cd_tipo_programacao   = 0 --> Todo o Processo
--                       = 1 --> Apenas uma Operação/Sequência do Processo

as

--Parâmetro_Manufatura
--
--Busca os parâmetros, para início da  Programação
--                     e    final para Geração do Prazo de entrega
--
--

  declare 
    @qt_dia_inicio_operacao int,
    @qt_dia_fim_operacao    int

	select
	  @qt_dia_inicio_operacao = isnull(qt_dia_inicio_operacao,0),
	  @qt_dia_fim_operacao    = isnull(qt_dia_fim_operacao,0) 
	from
	  Parametro_Manufatura
	where
	  cd_empresa = dbo.fn_empresa()

-- select
--   @qt_dia_inicio_operacao,
--   @qt_dia_fim_operacao

--Montagem da Tabela Auxiliar de Programação

  select 
    rm.* ,
    @dt_inicio_programacao as dt_inicio_processo,
    0 as qt_prioridade_processo, 
    cast(null as datetime) as dt_mp_processo,                    
    m.nm_fantasia_maquina                as 'maquina',
    isnull(m.ic_mapa_producao,'N')       as 'progmaq',
    cast(null as varchar)                as 'operacao',
    cast(null as varchar)                as 'progop', 
    cast(null as varchar)                as 'agmp',
    cast(null as varchar)                as 'opant',
    cast(null as float)                  as 'desctoop',
    cm.dt_disp_carga_maquina,                               --Data       de Disponibilidade  na Carga Máquina
    isnull(cm.qt_disp_carga_maquina,0)   as 'qtdHoraDisp'  --Quantidade de Horas Disponível na Carga Máquina]


  into #Programacao

  from 
    Reserva_Programacao          rm,
    maquina                      m,
    carga_maquina                cm
  where
    rm.cd_reserva_programacao = @cd_reserva_programacao and
    rm.cd_maquina             *= m.cd_maquina and
    rm.cd_maquina             *= cm.cd_maquina


--select * from reserva_programacao 
--Tabela Programacao
--  select * from #Programacao

--Programacao

  declare 
    @qt_hora_prog          float,
    @dt_programacao        datetime,
    @qt_hora_programacao   float,
    @cd_Reserva            int,
    @dt_inicio_processo    datetime,
    @dt_final_processo     datetime,
    @nm_obs_reserva_prog   varchar(80)

  create table #Agenda ( dt_agenda datetime null )

  while exists(select top 1 cd_maquina from #Programacao )
  begin

    --Dados 

	  select top 1
	    @qt_hora_programacao  = qt_hora_reserva_prog,
            @cd_Reserva           = cd_reserva_programacao,
            @dt_programacao       = dt_reserva_programacao,
            @dt_inicio_processo   = cast( cast(dt_inicio_reserva_prog as int ) as DateTime ),
            @dt_final_processo    = cast( cast(dt_final_reserva_prog as int )  as DateTime ), --Data Final de Programação da Reserva
            @nm_obs_reserva_prog  = nm_obs_reserva_prog
	  from
	    #Programacao
	  where
	    progmaq = 'S' --Verifica se a Máquina/Operação é Programada no Mapa de Programação

    --Tabela Temporária com os Dias para programação

    insert into #Agenda
    select
      dt_agenda
    from 
      Agenda
    where 
      dt_agenda between @dt_inicio_processo and @dt_final_processo and
      ( isnull(ic_util,'N') = 'S'                                    or
      ( isnull(ic_util,'N') = 'N' and isnull(ic_fabrica_operacao,'N') = 'S' ))
                                    
--select * from agenda
--    select * from #Agenda

    while exists (select top 1 'x' from #Agenda )
    begin

      select top 1 @dt_inicio_processo = dt_agenda 
      from 
        #Agenda 
      order by 
        dt_agenda 

--      select @dt_inicio_processo as 'Inicio'
    	
      --Gera a Programação
      if ( @dt_inicio_processo is not null ) and ( @dt_inicio_processo <= @dt_final_processo )
      begin
    
         exec pr_gera_data_programacao @cd_maquina,
                                       @dt_inicio_processo,
	                               @qt_hora_programacao,
	                               1,
	                               1,
	                               @cd_usuario,
                                       0,
                                       0,
                                       0,
                                       0,
                                       @dt_inicio_processo,
                                       Null,
                                       @nm_obs_reserva_prog,                            
                                       @cd_Reserva

      end
 
      delete from #Agenda where dt_agenda = @dt_inicio_processo

    end

    --Deleta o registro da Tabela Auxiliar de Programação
    delete #programacao 
    where 
      cd_reserva_programacao      = @cd_Reserva

    --Atualiza a Data de Programação
    set @dt_programacao = @dt_programacao + 1

  end

