
--------------------------------------------------------------------------------
CREATE PROCEDURE pr_mapa_diario_atraso_maquina
-------------------------------------------------------------------------------- 
--GBS - Global Business Solution              2004
--Stored Procedure : Microsoft SQL Server     2004
--Autor(es)      : Daniel Duela
--Banco de Dados : EGISSQL 
--Objetivo       : Rotinas para Cálculo de Atraso Diário de Máquina
--Data           : 19/05/2004
--Atualização    : 09/06/2004 - Mudado para pegar somente até a data de hoje.
--                            - Daniel C. Neto.

------------------------------------------------------------------------------ 

@ic_parametro   int,
@dt_inicial     datetime,
@cd_maquina     int


as 

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Cálculo de Atraso Diário de Máquina por PROCESSO
-------------------------------------------------------------------------------
begin
  select
    ppc.dt_estimada_operacao as 'dt_atraso',
    sum(ppc.qt_hora_estimado_processo) as 'qt_hora'
  from
    Processo_Producao_Composicao ppc
  inner join Processo_Producao pp on
    ppc.cd_processo = pp.cd_processo
  where
    ppc.dt_estimada_operacao between @dt_inicial and GetDate() and
    ppc.cd_maquina = @cd_maquina and
    isnull(pp.dt_fimprod_processo,'')='' and
    not exists (select 'x' from Processo_Producao_Apontamento ppa
                where
                  ppa.cd_processo = ppc.cd_processo and
                  ppa.cd_item_processo = ppc.cd_seq_processo)
  group by
    ppc.dt_estimada_operacao
end

-------------------------------------------------------------------------------
if @ic_parametro = 2 -- Cálculo de Atraso Diário de Máquina por PROGRAMAÇÃO
-------------------------------------------------------------------------------
begin
  select
    p.dt_programacao as 'dt_atraso',
    sum(pc.qt_hora_prog_operacao) as 'qt_hora'
  from
    Programacao p
  inner join Programacao_Composicao pc on
    p.cd_programacao = pc.cd_programacao
  where
    p.dt_programacao between @dt_inicial and @dt_inicial+31 and
    p.cd_maquina = @cd_maquina and
    isnull(pc.dt_fim_prod_operacao,'')=''
  group by
    p.dt_programacao
end

-------------------------------------------------------------------------------
if @ic_parametro = 3 -- Saldo Anterior por PROCESSO
-------------------------------------------------------------------------------
begin
  select
    sum(ppc.qt_hora_estimado_processo) as 'qt_hora'
  from
    Processo_Producao_Composicao ppc
  inner join Processo_Producao pp on
    ppc.cd_processo = pp.cd_processo
  where
    month(ppc.dt_estimada_operacao) = month(@dt_inicial)-1 and
    ppc.cd_maquina = @cd_maquina and
    isnull(pp.dt_fimprod_processo,'')='' and
    not exists (select 'x' from Processo_Producao_Apontamento ppa
                where
                  ppa.cd_processo = ppc.cd_processo and
                  ppa.cd_item_processo = ppc.cd_seq_processo)
  group by
    ppc.dt_estimada_operacao
end

-------------------------------------------------------------------------------
if @ic_parametro = 4 -- Saldo Anterior por PROGRAMAÇÃO
-------------------------------------------------------------------------------
begin
  select
    sum(pc.qt_hora_prog_operacao) as 'qt_hora'
  from
    Programacao p
  inner join Programacao_Composicao pc on
    p.cd_programacao = pc.cd_programacao
  where
    month(p.dt_programacao) = month(@dt_inicial)-1 and
    p.cd_maquina = @cd_maquina and
    isnull(pc.dt_fim_prod_operacao,'')=''
  group by
    p.dt_programacao
end

--------------------------------------------------------
else if @ic_parametro = 5 -- Totais por Máquina
--------------------------------------------------------
begin
  select
    ppc.dt_estimada_operacao as 'dt_atraso',
    sum(ppc.qt_hora_estimado_processo) as 'qt_hora'
  from
    Processo_Producao_Composicao ppc
  inner join Processo_Producao pp on
    ppc.cd_processo = pp.cd_processo
  where
    ppc.dt_estimada_operacao between @dt_inicial and GetDate() and
--    ppc.cd_maquina = @cd_maquina and
    isnull(pp.dt_fimprod_processo,'')='' and
    not exists (select 'x' from Processo_Producao_Apontamento ppa
                where
                  ppa.cd_processo = ppc.cd_processo and
                  ppa.cd_item_processo = ppc.cd_seq_processo)
  group by
    ppc.dt_estimada_operacao

end
--------------------------------------------------------
else if @ic_parametro = 6 -- Totais por Máquina
--------------------------------------------------------
begin
  select
    p.dt_programacao as 'dt_atraso',
    sum(pc.qt_hora_prog_operacao) as 'qt_hora'
  from
    Programacao p
  inner join Programacao_Composicao pc on
    p.cd_programacao = pc.cd_programacao
  where
    p.dt_programacao between @dt_inicial and @dt_inicial+31 and
    isnull(pc.dt_fim_prod_operacao,'')=''
  group by
    p.dt_programacao
end


