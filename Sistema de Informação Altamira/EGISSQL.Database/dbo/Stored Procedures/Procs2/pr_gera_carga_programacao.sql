
-----------------------------------------------------------------------------------
--pr_gera_carga_programacao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a programação das operações do processo por máquina
--                   Sequenciamento das Operações
--
--Data             : 16.05.2004
--Alteração        : 12.06.2004
--
--                   17/06/2004 - Feito rotina para atualizar todas as máquinas de uma vez caso
--                                seja passado 0 no parâmetro - Daniel C. Neto.
--                   13.07.2004 - Não está gravando o código da Máquina Correto ( Carlos )
--  
-----------------------------------------------------------------------------------------------
create procedure pr_gera_carga_programacao
@cd_maquina int,
@dt_inicial datetime,
@dt_final   datetime
as

declare @dt_programacao           datetime
declare @qt_hora_operacao_maquina float
declare @cd_programacao           int
declare @ic_util                  char(1)
declare @ic_fabrica_operacao      char(1)
declare @cd_maquina_selecionada   int

set @qt_hora_operacao_maquina = 0

select
  cd_maquina
into #Maquina
from
  Maquina
where
  IsNull(cd_maquina,0) = (case when @cd_maquina = 0 then
                             IsNull(cd_maquina,0)   else @cd_maquina end )

while exists ( select 'x' from #Maquina)
begin

  set @cd_maquina_selecionada = ( select top 1 cd_maquina from #Maquina ) 
   
  select
    @qt_hora_operacao_maquina =   sum(qt_hora_operacao_maquina)
  from 
    Maquina m,
    maquina_turno mt
  where
    m.cd_maquina                    = @cd_maquina_selecionada and
    isnull(m.ic_mapa_producao ,'N') = 'S' and
    m.cd_maquina = mt.cd_maquina          and
    isnull(mt.ic_operacao,'N')      ='S'
  group by
    m.cd_maquina
  order by
    m.cd_maquina


  --Utilizar a rotina pega código ( conversar com Fábio )
  --

  set @dt_programacao = @dt_inicial

  while @dt_programacao <= @dt_final
  begin

    --Verificação da Agenda 

    set @ic_util                 = 'N'
    set @ic_fabrica_operacao     = 'N'

    --Loop para achar a data de disponibilidade útil para programacao
    --Carlos 12.6.2004          

    while @ic_util = 'N' 
    begin

      select
        @ic_util             = isnull(ic_util,'N'),
        @ic_fabrica_operacao = isnull(ic_fabrica_operacao,'N')
      from 
        agenda
      where 
        dt_agenda = @dt_programacao

      if ( @ic_util = 'N' and @ic_fabrica_operacao = 'N' )
         set @dt_programacao  = @dt_programacao + 1

      if ( @ic_util = 'N' and @ic_fabrica_operacao = 'S' )
         set @ic_util = 'S'
     
    end


    set @cd_programacao = (select isnull(max(cd_programacao),0)+1 from Programacao)

    --select * from programacao

    insert into programacao
      (cd_programacao,
       cd_maquina,
       dt_programacao,
       qt_hora_operacao_maquina,
       qt_hora_prog_maquina,
       qt_hora_reservada_maquina,
       qt_hora_simulada_maquina,
       qt_processo_prog_maquina,
       qt_hora_prog_simulacao,
       qt_hora_disp_simulacao,
       qt_hora_prod_maquina)
    values
      ( @cd_programacao,
        @cd_maquina_selecionada,
        @dt_programacao,
        @qt_hora_operacao_maquina,
        0,
        0,
        0,
        0,
        0,
        0,
        0)

    set @dt_programacao = @dt_programacao + 1

  end

  delete from #Maquina where cd_maquina = @cd_maquina_selecionada

end

