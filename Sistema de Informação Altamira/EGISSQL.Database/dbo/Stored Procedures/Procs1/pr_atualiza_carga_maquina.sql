
-----------------------------------------------------------------------------------
--pr_atualiza_carga_maquina
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
--
--Stored Procedure : SQL Server Microsoft 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Módulo           : APSNET
--Objetivo         : Programação de Produção
--                   Executa a atualização da Carga Máquina com os Dados Básicos
--                   da Máquina.
--
--Data             : 16.05.2004
--Alteração        : 12.06.2004
--                 : 19.07.2004 - Checagem da Geração da Data de Disponibilidade  
--                   06/08/2004 - Mudança na data de disponibilidade - Carlos/ Daniel C. Neto.
--                   09/08/2004 - Ajustes Finais
--                   20.08.2007 - Verificação - Carlos Fernandes
--                   21.09.2007 - Verificação da Disponibilidade da Máquina - Carlos Fernandes
-- 15.03.2010 - Ordem de Produção que estão Canceladas e Encerradas não pode entrar - Carlos Fernandes
--------------------------------------------------------------------------------------------------------
create procedure pr_atualiza_carga_maquina
@dt_base    as datetime = '',
@dt_inicial as datetime = '',
@cd_usuario as int      = 0
as

--Montagem Automática da Tabela Carga Máquina

select 

  --Máquina
  m.cd_maquina,

  --Ordem de Apresentação
  max(isnull(m.qt_ordem_mapa,0))            as cd_ordem_carga_maquina,

  --Total de Horas que a Máquina Opera
  sum(isnull(qt_hora_operacao_maquina,0))   as qt_carga_maquina,

  --Quantidade de Turnos
  count(isnull(qt_hora_operacao_maquina,0)) as qt_turno_carga_maquina,

  --Apresenta na Carga Máquina
  max(m.ic_mapa_producao)                   as ic_carga_maquina,

  --Data da Disponibilidade
  dt_disp_carga_maquina = (

     isnull( (select top 1 p.dt_programacao
     from
       programacao p with (nolock) 
       left outer join agenda a on a.dt_agenda = p.dt_programacao
     
     where
       cd_maquina = m.cd_maquina and
       dt_programacao > @dt_base and
       isnull(p.qt_hora_prog_maquina,0)<isnull(p.qt_hora_operacao_maquina,0) and
          
       ( case when IsNull(ic_util,'N') = 'S' then
           IsNull(ic_util,'N') else IsNull(ic_fabrica_operacao,'N') end ) = 'S' 
       --and
       --isnull(dbo.fn_disponibilidade_maquina(p.cd_maquina, p.dt_programacao),0)-isnull(p.qt_hora_prog_maquina,0) > 0 

      order by
         p.dt_programacao ),@dt_base )),

-- Carlos/ Carrasco
--       isnull(qt_hora_operacao_maquina,0)-isnull(qt_hora_prog_maquina,0) > 0 ),@dt_base )),
-- 06/08/2004

  --Dias de Programação-Hoje

  qt_dia_prog_carga_maquina = 
     cast ( 
       isnull(( select max(dt_programacao) 
       from
         Programacao with (nolock) 
       where
         cd_maquina = m.cd_maquina and
         isnull(qt_hora_prog_maquina,0) > 0 ),getdate() ) - getdate() as int),

  --Horas Programadas

  qt_prog_carga_maquina = (
  select
    sum( isnull(qt_hora_prog_maquina,0) )
  from
    Programacao with (nolock) 
  where
    cd_maquina      = m.cd_maquina   and
    dt_programacao >= @dt_base       and
    isnull(qt_hora_prog_maquina,0)>0 and
    isnull(ic_fim_producao,'N') = 'N' ),

  --Horas de Operacao

  0.00 as qt_operacao_carga_maquina,

--   --Quantidade de Horas Disponíveis
-- 
--   qt_disp_carga_maquina = (
-- 
--      isnull( (select top 1 qt_hora_operacao_maquina-qt_hora_prog_maquina
--      from
--        programacao
--      where
--        cd_maquina      = m.cd_maquina and
--        dt_programacao >= @dt_base  and
--        isnull(qt_hora_operacao_maquina,0)-isnull(qt_hora_prog_maquina,0) > 0 ),sum(qt_hora_operacao_maquina) )),

--   --Quantidade de Horas Disponíveis

-- Alterado por Ludinei/Lucio em 26/08/2004 => Correção das Horas Disponiveis

  qt_disp_carga_maquina = (

     isnull( (select top 1 isnull(dbo.fn_disponibilidade_maquina(cd_maquina, dt_programacao),0)-
                           isnull(qt_hora_prog_maquina,0)
     from
       programacao p   with (nolock) 
       left outer join agenda a on a.dt_agenda = p.dt_programacao
     where
       cd_maquina = m.cd_maquina and
       dt_programacao >= @dt_base and
       ( case when IsNull(ic_util,'N') = 'S' then
           IsNull(ic_util,'N') else IsNull(ic_fabrica_operacao,'N') end ) = 'S' and
       isnull(dbo.fn_disponibilidade_maquina(cd_maquina, dt_programacao),0)-isnull(qt_hora_prog_maquina,0) > 0 

      order by p.dt_programacao),sum(isnull(m.qt_hora_real_maquina,0)) )),


  --Data de Atraso
  --select * from programacao_composicao

  dt_atraso_carga_maquina = (
  select
    min(p.dt_programacao)
  from
    Programacao p                        with (nolock) 
    inner join programacao_composicao pc with (nolock) on p.cd_programacao = pc.cd_programacao
    left outer join processo_producao pp with (nolock) on pp.cd_processo   = pc.cd_processo
  where
    m.cd_maquina     = p.cd_maquina      and
    p.cd_programacao = pc.cd_programacao and
    pp.dt_canc_processo is null          and --Não Canceladas
    pp.cd_status_processo <> 5           and --Encerradas
    pc.dt_fim_prod_operacao is null      and
    p.dt_programacao < @dt_base ),

  --Qtd. Horas de Atraso
  --select * from programacao_composicao


  qt_atraso_carga_maquina = (
  select
    sum( isnull(pc.qt_hora_prog_operacao,0) )
  from
    Programacao p                        with (nolock) 
    inner join programacao_composicao pc with (nolock) on p.cd_programacao = pc.cd_programacao
    left outer join processo_producao pp with (nolock) on pp.cd_processo   = pc.cd_processo

  where
    m.cd_maquina     = p.cd_maquina      and
    p.cd_programacao = pc.cd_programacao and
    pp.dt_canc_processo is null          and --Não Canceladas
    pp.cd_status_processo <> 5           and --Encerradas
    pc.dt_fim_prod_operacao is null      and
    p.dt_programacao<@dt_base             ) ,

  --Utilidade
  'S' as ic_util_carga_maquina,

  --Observacao
  'Gerado Automaticamente' as nm_obs_carga_maquina,

  --Data de Programacao
  dt_prog_carga_maquina = ( 
     select max(dt_programacao) 
     from
       Programacao with (nolock) 
     where
       cd_maquina = m.cd_maquina and
       isnull(qt_hora_prog_maquina,0) > 0 and 
       dt_programacao >= @dt_base),
       

 --Usuário
  @cd_usuario        as cd_usuario,

 --Data 
  getdate()          as dt_usuario,

  --Dias de Atraso-Hoje

  qt_dia_atraso_carga_maq = 
     cast ( getdate() -
       (   select 
             min(p.dt_programacao)
           from
             Programacao p                        with (nolock) 
             inner join programacao_composicao pc with (nolock) on p.cd_programacao = pc.cd_programacao
             left outer join processo_producao pp with (nolock) on pp.cd_processo   = pc.cd_processo
           where
             m.cd_maquina     = p.cd_maquina      and
             p.cd_programacao = pc.cd_programacao and
             pc.dt_fim_prod_operacao is null      and
             pp.dt_canc_processo is null          and --Não Canceladas
             pp.cd_status_processo <> 5           and --Encerradas
             p.dt_programacao < @dt_base ) as int)


into #Aux_CargaMaquina  
from 
  maquina m,
  maquina_turno mt
where
  isnull(m.ic_mapa_producao ,'N') = 'S' and
  m.cd_maquina = mt.cd_maquina          and
  isnull(mt.ic_operacao,'N')='S'
group by
  m.cd_maquina
order by
  m.cd_maquina

--select * from carga_maquina

--Montagem da Tabela Programacao
truncate table carga_maquina

insert Carga_Maquina select * from #Aux_CargaMaquina


--select * from maquina
--select * from programacao
--select * from programacao_composicao
--select getdate()
--select * from carga_maquina
--sp_help carga_maquina

