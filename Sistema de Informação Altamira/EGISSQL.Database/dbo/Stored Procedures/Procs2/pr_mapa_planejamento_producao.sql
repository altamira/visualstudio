
CREATE PROCEDURE pr_mapa_planejamento_producao
-------------------------------------------------------------------------------------------
--Polimold Industrial S/A                      2004                                      --
--Stored Procedure: Microsoft SQL Server       2004                                      --
--Autor(es): DANIEL DUELA / DANIEL CARRASCO                                              -- 
--Banco de Dados: EGISSQL                                                                -- 
--Objetivo: Montar Mapa de Planejamento para Produção                                    --
--Data: 24/03/2004                                                                       --
--Atualizado:                            						 --
-- 23/04/2004 - Acerto no cálculo da disponibilidade - Daniel C. Neto.
-- 27/04/2004 - Acerto no filtro de Máquina e de grupo - Daniel C. Neto.
-------------------------------------------------------------------------------------------
@cd_grupo_maquina int,
@cd_maquina int,
@dt_inicial datetime,
@dt_final datetime

as

begin

--indica que a semana começa com o nº 1
SET DATEFIRST 1

  --Abaixo são selecionados as máquinas utilizadas conforme o dia da semana
  -----------------------------------
  select  cd_maquina, dia 
  into #Maquina_Turno_Operacao 
  from
  (select distinct
    cd_maquina,
    1 as Dia
   from Maquina_Turno_Operacao
   --
   union all
   --
   select distinct
     cd_maquina,
     2 as Dia
   from Maquina_Turno_Operacao
   where ic_dia2_operacao_maquina = 'S'
   --
   union all
   --
   select distinct
     cd_maquina,
     3 as Dia
   from Maquina_Turno_Operacao
   where ic_dia3_operacao_maquina = 'S'
   --
   union all
   --
   select distinct
     cd_maquina,
     4 as Dia
   from Maquina_Turno_Operacao
   where ic_dia4_operacao_maquina = 'S'
   --
   union all
   --
   select distinct
     cd_maquina,
     5 as Dia
   from Maquina_Turno_Operacao
   where ic_dia5_operacao_maquina = 'S'
   --
   union all
   --
   select distinct
     cd_maquina,
     6 as Dia
   from Maquina_Turno_Operacao
   where ic_dia6_operacao_maquina = 'S'
   --
   union all
   --
   select distinct
     cd_maquina,
     7 as Dia
   from Maquina_Turno_Operacao
   where ic_dia7_operacao_maquina = 'S') Maquina_Turno_Operacao
   -----------------------------------

  --Seleciona as máquinas e os pedidos de venda relacionados á elas.
  --Exemplo : Na semana 1 a Máquina XPTO tem os PV (2342, 2343, 2344, 2344)
  --          que tem a seguinte Composição para os clientes : Banana, Laranja e Limão
  select
    ppc.cd_maquina,
    ppc.cd_grupo_maquina,
    cli.nm_fantasia_cliente,
    pp.cd_pedido_venda,
    ppc.cd_item_processo,
    ppc.qt_hora_estimado_processo
  into #Temp
  from 
    Processo_Producao pp
      left outer join 
    Pedido_Venda pv 
      on pp.cd_pedido_venda = pv.cd_pedido_venda
      left outer join 
    Cliente cli 
      on pv.cd_cliente = cli.cd_cliente
      left outer join 
    Processo_Producao_Composicao ppc 
      on pp.cd_processo = ppc.cd_processo
      inner join 
    #Maquina_Turno_Operacao mto 
      on ppc.cd_maquina = mto.cd_maquina and
        (DATEPART(dw, ppc.dt_estimada_operacao)) = mto.dia
  where
    (ppc.cd_maquina = @cd_maquina or @cd_maquina = 0)and
    (ppc.cd_grupo_maquina = @cd_grupo_maquina or @cd_grupo_maquina = 0) and
    ppc.dt_estimada_operacao between @dt_inicial and @dt_final and
    pp.cd_pedido_venda is not null


  select 
    mt.cd_maquina,
    m.cd_grupo_maquina,
    sum(t.qt_hora_estimado_processo) as 'qt_total_carga',
    200.00 as 'qt_total_disp'
--    sum(isnull(mt.qt_hora_operacao_maquina,0)) as 'qt_total_disp'
  into #Temp1
  from 
    Maquina_Turno mt 
      inner join
    Maquina m 
      on m.cd_maquina = mt.cd_maquina 
      left outer join
    #Temp t 
      on mt.cd_maquina = t.cd_maquina
  where
    (m.cd_maquina = @cd_maquina or @cd_maquina = 0)and
    (m.cd_grupo_maquina = @cd_grupo_maquina or @cd_grupo_maquina = 0) and
    ic_operacao = 'S'  
  group by
    mt.cd_maquina,
    m.cd_grupo_maquina


  select
    t1.*,
    m.nm_maquina,
    gm.sg_grupo_maquina,
    -- Somente para informativo, não está sendo usado no sistema.
    case when qt_total_disp > qt_total_carga then
      'S' else 'N' end as ic_disponivel,
    case when qt_total_disp = qt_total_carga then
      'S' else 'N' end as ic_completa,
    case when qt_total_disp < qt_total_carga then
      'S' else 'N' end as ic_excesso,
    case when (qt_total_carga = 0) and (qt_total_disp = 0) then
      'S' else 'N' end as ic_planejamento
  from
    #Temp1 t1
  left outer join Maquina m on
    t1.cd_maquina = m.cd_maquina
  left outer join Grupo_Maquina gm on
    t1.cd_grupo_maquina = gm.cd_grupo_maquina

  drop table #Maquina_Turno_Operacao
  drop table #Temp

end

