
create procedure pr_demonstrativo_custo_producao_pro
-----------------------------------------------------------------------------------------------------------
--pr_demonstrativo_custo_producao_pro
-----------------------------------------------------------------------------------------------------------
--Global Business Solution Ltda                             2005
-----------------------------------------------------------------------------------------------------------
--Stored Procedure     : SQL Servecr Microsoft 2000  
--Autor                : Clelson Luiz Camargo
--Objetivo             : Demostrativo de Custo de Produção
--Data                 : 23.02.2005
--Atualizado           : 23.02.2005 - Acerto do valor total da ociosidade - Clelson Camargo
--		                 : 24.02.2005 - Correção da UN dos materiais - Clelson Camargo
--                     : 11.05.2005 - Incluido consulta do custo das máquinas por OP. - Márcio
-- 21.02.2008 - Ajustes Gerais na Procedure - Carlos Fernandes
-- 12.07.2008 - Modificação do Custo de Operação para o Operador - Carlos Fernandes
-- 27.10.2008 - Ajuste Diversos - Carlos Fernandes
-- 26.05.2009 - Complemento de campos e mostrar os serviços externos - Carlos/Douglas 
-- 05.12.2009 - Verificação do Preços - Carlos Fernandes
-- 28.12.2009 - Serviço Externo - Carlos Fernandes
-- 15.05.2010 - Modificações diversas/Cálculo/Ajustes - Carlos Fernandes
-- 09.06.2010 - Serviço Externo - Carlos Fernandes
-- 22.07.2010 - verificação de campos obrigatórios - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------
 @ic_tipo_consulta Int      = 0,  -- Tipo da consulta
 @cd_processo      Int      = 0,  -- Número do processo de producao
 @dt_inicial       Datetime = '', -- Data inicial
 @dt_final         DateTime = ''  -- Data final

as

-- if @dt_inicial is null
--    set @dt_inicial = getdate()
-- 
-- if @dt_final is null
--    set @dt_final = getdate()


-- Uso em + de um tipo

declare
   @qt_apontado_periodo         float,
   @qt_apontado_periodo_maquina float,
   @qt_hora_diaria_agenda       float,
   @qt_capacidade_individual    float,
   @qt_dias_uteis_periodo       int,
   @qt_operadores               int,
   @qt_maquina                  int,
   @qt_apontado_processo        float

--
declare @ic_ociosa_hora_producao char(1)

select
  @ic_ociosa_hora_producao = isnull(ic_ociosa_hora_producao,'N')
from
  parametro_custo with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


-- Pega os dias úteis no período

set @qt_dias_uteis_periodo = isnull(dbo.fn_GetQtdDiaUtilPeriodo(@dt_inicial, @dt_final, 'U'),0)

-- Pega as horas diárias produtivas e a quantidade de horas no mês

select
 @qt_hora_diaria_agenda  = isnull(qt_hora_diaria_agenda,0)
from
 Parametro_agenda with (nolock) 
where 
 cd_empresa = dbo.fn_empresa()

-- Pega a capacidade individual
set @qt_capacidade_individual = @qt_dias_uteis_periodo * @qt_hora_diaria_agenda

-------------------------------------------------------------------------------------------------------------
-- MÃO DE OBRA - INICIO
-------------------------------------------------------------------------------------------------------------
-- Resumo dos apontamentos do período por operador
create table #Apontamento_Operador_Periodo(
  cd_operador                  int   null,
  qt_capacidade_operador       float null,
  qt_apontado_operador_periodo float null,
  qt_ociosidade_periodo        float null,
  qt_hora_extra_periodo        float null
)

insert into #Apontamento_Operador_Periodo(cd_operador, qt_capacidade_operador, qt_apontado_operador_periodo)
select
 ppa.cd_operador,
 @qt_capacidade_individual, 
 Round(sum((cast(datepart(hh, cast(hr_final_apontamento as datetime)) as float) +
 (cast(datepart(mi, cast(hr_final_apontamento as datetime)) as float) /60)) -
 (cast(datepart(hh, cast(hr_inicial_apontamento as datetime)) as float) +
 (cast(datepart(mi, cast(hr_inicial_apontamento as datetime)) as float) /60))
 ), 4)
from
 processo_producao_apontamento ppa    with (nolock) 
 left outer join processo_producao pp with (nolock) on ppa.cd_processo = pp.cd_processo
where
  ppa.dt_processo_apontamento between @dt_inicial and @dt_final and
  pp.cd_status_processo <> 6 -- Cancelada
group by
 ppa.cd_operador

update #Apontamento_Operador_Periodo
set
 qt_ociosidade_periodo = 
  case when @qt_capacidade_individual - qt_apontado_operador_periodo > 0
       then @qt_capacidade_individual - qt_apontado_operador_periodo
       else 0
       end,

 qt_hora_extra_periodo =
  case when @qt_capacidade_individual - qt_apontado_operador_periodo < 0
       then @qt_capacidade_individual - qt_apontado_operador_periodo
       else 0
       end

--select * from #apontamento_operador_periodo

-- Pega o numero de operadores e o total trabalhado no período

select
 @qt_operadores       = count(aop.cd_operador),
 @qt_apontado_periodo = sum(aop.qt_apontado_operador_periodo)
from
 #Apontamento_Operador_Periodo aop

if @cd_processo <> 0
begin
 -- Calcula os apontamentos do processo
 select cd_operador,
  Round(sum((cast(datepart(hh, cast(hr_final_apontamento as datetime)) as float) + 
      (cast(datepart(mi, cast(hr_final_apontamento as datetime)) as float) /60)) -
      (cast(datepart(hh, cast(hr_inicial_apontamento as datetime)) as float) + 
      (cast(datepart(mi, cast(hr_inicial_apontamento as datetime)) as float) /60))
     ), 4) as 'qt_apontado_operador_periodo'
  into
   #Apontamento_Processo
  from processo_producao_apontamento ppa with (nolock)
  where 
    cd_processo = @cd_processo
  group by cd_operador
--  select * from #Apontamento_Processo

 -- Calcula o total trabalhado na OP

 select
  @qt_apontado_processo = Round(sum(qt_apontado_operador_periodo), 4)
 from
  #Apontamento_Processo

-- print @qt_apontado_processo

end

-------------------------------------------------------------------------------------------------------------
-- MÃO DE OBRA - END
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- MAQUINA - BEGIN
-------------------------------------------------------------------------------------------------------------

-- Resumo dos apontamentos do período por máquina
create table #Apontamento_Maquina_Periodo(
  cd_maquina            int                 null,
  qt_capacidade_maquina float               null,
  qt_apontado_periodo_maquina_periodo float null,
  qt_ociosidade_periodo float               null,
  qt_hora_extra_periodo float               null
)

insert into #Apontamento_Maquina_Periodo(cd_maquina, qt_capacidade_maquina, qt_apontado_periodo_maquina_periodo)
select
 ppa.cd_maquina,
 @qt_capacidade_individual, 
 Round(sum((cast(datepart(hh, cast(hr_final_apontamento as datetime)) as float) +
 (cast(datepart(mi, cast(hr_final_apontamento as datetime)) as float) /60)) -
 (cast(datepart(hh, cast(hr_inicial_apontamento as datetime)) as float) +
 (cast(datepart(mi, cast(hr_inicial_apontamento as datetime)) as float) /60))
 ), 4)
from
 processo_producao_apontamento ppa   with (nolock) 
left outer join processo_producao pp with (nolock) on ppa.cd_processo = pp.cd_processo
where
  ppa.dt_processo_apontamento between @dt_inicial and @dt_final and
  pp.cd_status_processo <> 6 -- Cancelada
group by
 ppa.cd_maquina

update #Apontamento_Maquina_Periodo
set
 qt_ociosidade_periodo = 
  case when @qt_capacidade_individual - qt_apontado_periodo_maquina_periodo > 0
       then @qt_capacidade_individual - qt_apontado_periodo_maquina_periodo
       else 0
       end,

 qt_hora_extra_periodo =
  case when @qt_capacidade_individual - qt_apontado_periodo_maquina_periodo < 0
       then @qt_capacidade_individual - qt_apontado_periodo_maquina_periodo
       else 0
       end

--select * from #apontamento_maquina_periodo

-- Pega o numero de maquina e o total trabalhado no período

select
 @qt_maquina                  = count(amp.cd_maquina),
 @qt_apontado_periodo_maquina = sum(isnull(amp.qt_apontado_periodo_maquina_periodo,0))

from
 #Apontamento_Maquina_Periodo amp

if @cd_processo <> 0
begin
 -- Calcula os apontamentos do processo
 select cd_maquina,
  Round(sum((cast(datepart(hh, cast(hr_final_apontamento as datetime)) as float) + 
      (cast(datepart(mi, cast(hr_final_apontamento as datetime)) as float) /60)) -
      (cast(datepart(hh, cast(hr_inicial_apontamento as datetime)) as float) + 
      (cast(datepart(mi, cast(hr_inicial_apontamento as datetime)) as float) /60))
     ), 4) as 'qt_apontado_periodo_maquina_periodo'
  into
   #Apontamento_Processo_Maquina
  from processo_producao_apontamento ppa with (nolock) 
  where
    cd_processo = @cd_processo
  group by 
    cd_maquina

--  select * from #Apontamento_Processo_Maquina

 -- Calcula o total trabalhado na OP
 select
  @qt_apontado_processo = Round(sum(qt_apontado_periodo_maquina_periodo), 4)
 from
  #Apontamento_Processo_Maquina
-- print @qt_apontado_processo

end

-------------------------------------------------------------------------------------------------------------
-- MAQUINA - END
-------------------------------------------------------------------------------------------------------------

--Tabelas Auxiliares-----------------------------------------------------------------------------------------

    --Ultima operacao em que é realizado o apontamento da Inspeção com o Número 
    --Total de Peças Produzidas

    select
      pp.cd_processo,
      max(ppa.cd_item_processo)                     as cd_item_processo,
      sum( isnull(ppa.qt_peca_aprov_apontamento,0)) as Aprovada
  
    into
      #UltimaOperacao

    from
      processo_producao pp                         with (nolock) 
      inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo
      left outer join Operacao                 o   with (nolock) on o.cd_operacao   = ppa.cd_operacao  
    where
      isnull(o.ic_analise_apontamento,'N' )='S'           --Somente a Operação configurada no Cadastro

    group by
      pp.cd_processo
    order by
      pp.cd_processo,
      ppa.cd_item_processo desc

    --select * from #UltimaOperacao


    --Quantidade de Peças que foram Refugadas
 
    select
      pp.cd_processo,
      sum( isnull(ppa.qt_peca_ruim_produzida,0)) as Refugo
  
    into
      #Refugo

    from
      processo_producao pp                         with (nolock) 
      inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo
      left outer join Operacao                 o   with (nolock) on o.cd_operacao   = ppa.cd_operacao  
    group by
      pp.cd_processo
    order by
      pp.cd_processo

    --select * from #Refugo

    --Tabela Auxiliar com todos os processos  

    select
      pp.cd_processo,
      max(pp.dt_entrega_processo)                   as DataEntrega,
      max(ppa.dt_processo_apontamento)              as DataProducao,

      max(isnull(up.Aprovada,0)) +
      max( isnull(ppx.Refugo,0) )                   as Producao,

      max(isnull(up.Aprovada,0))                    as Aprovada,
      max(isnull(ppx.Refugo,0) )                    as Refugo

    into
      #AuxProducao

    from
      processo_producao pp                         with (nolock) 
      inner join #UltimaOperacao               up  with (nolock) on up.cd_processo       = pp.cd_processo 
      inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo      = up.cd_processo       and
                                                                    ppa.cd_item_processo = up.cd_item_processo

      inner join #Refugo ppx                       with (nolock) on ppx.cd_processo      = pp.cd_processo       


    where
     cd_status_processo = 5 --Ordem de Produção Encerrada


    group by
      pp.cd_processo


-------------------------------------------------------------------------------
if @ic_tipo_consulta = 0 -- Resultado Custo Producao
-------------------------------------------------------------------------------
begin
 declare
   @qt_capaciade_total                 float,
   @qt_ociosidade                      float,
   @vl_custo_horas_trabalhadas         float,
   @vl_custo_encargos                  float,
   @vl_custo_ociosidade                float,
   @vl_materia_prima_periodo           float,
   @vl_despesas_gerais                 float,
   @vl_total_despesas                  float,
   @vl_total_itens_produzidos          float,
   @vl_custo_ociosidade_maquina        float,
   @vl_custo_horas_trabalhadas_maquina float,
   @qt_capaciade_total_maquina         float,
   @qt_ociosidade_maquina              float

 -- Pega a capacidade total

 set @qt_capaciade_total         = @qt_operadores * @qt_capacidade_individual
 set @qt_capaciade_total_maquina = @qt_maquina    * @qt_capacidade_individual

 -- Pega a ociosidade

 set @qt_ociosidade         = @qt_capaciade_total         - @qt_apontado_periodo
 set @qt_ociosidade_maquina = @qt_capaciade_total_maquina - @qt_apontado_periodo_maquina

 -- Pega os custos com mão de obra

 select
  @vl_custo_horas_trabalhadas = sum(isnull(ov.vl_operador,0) * isnull(aop.qt_apontado_operador_periodo,0)),
  @vl_custo_encargos          = sum((isnull(ov.vl_encargo_operador,0) * isnull(aop.qt_apontado_operador_periodo,0))
                                    + (isnull(ov.vl_encargo_operador,0) * isnull(aop.qt_ociosidade_periodo,0))),
  @vl_custo_ociosidade        = sum(isnull(ov.vl_operador,0) * isnull(aop.qt_ociosidade_periodo,0))

 from
  #Apontamento_Operador_Periodo aop
  left outer join operador_valor ov on ov.cd_operador = aop.cd_operador
 where
  ov.dt_inicial_operador >= @dt_inicial and 
  ov.dt_final_operador   <= @dt_final

 -- Pega os custos Máquina

 select
  @vl_custo_horas_trabalhadas_maquina = sum(isnull(mv.vl_hora_maquina,0) * isnull(amp.qt_apontado_periodo_maquina_periodo,0)),
  @vl_custo_ociosidade_maquina        = sum(isnull(mv.vl_hora_maquina,0) * isnull(amp.qt_ociosidade_periodo,0))
 from
  #Apontamento_Maquina_Periodo amp
 left outer join maquina_valor mv on mv.cd_maquina = amp.cd_maquina
 where
  mv.dt_inicial_maquina >= @dt_inicial and 
  mv.dt_final_maquina   <= @dt_final


 -- pega os custos com matéria prima dos processos terminados no período

 select
   @vl_materia_prima_periodo = sum(isnull(ppc.qt_comp_processo,0) * isnull(me.vl_custo_contabil_produto,0))
 from
   Processo_Producao pp                            with (nolock) 
  left outer join Processo_Producao_Componente ppc with (nolock) on ppc.cd_processo         = pp.cd_processo
  left outer join Movimento_Estoque me             with (nolock) on me.cd_movimento_estoque = ppc.cd_movimento_estoque 
 where
   pp.dt_fimprod_processo between @dt_inicial and @dt_final and
   pp.cd_status_processo <> 6 -- Cancelada

 -- Pega as despesas gerais de producao
 select
  @vl_despesas_gerais = sum(isnull(dpv.vl_despesa_producao,0))
 from
  despesa_producao_valor dpv with (nolock) 
 where
  dt_inicio_despesa_prod >= @dt_inicial and 
  dt_final_despesa_prod  <= @dt_final
 
 -- Pega o valor total das despesas
 set @vl_total_despesas = 
     @vl_custo_horas_trabalhadas
   	+ @vl_custo_encargos
   	+ @vl_custo_ociosidade
   	+ @vl_materia_prima_periodo
   	+ @vl_despesas_gerais
        + @vl_custo_ociosidade_maquina
        + @vl_custo_horas_trabalhadas_maquina

 -- Pega o valor total dos itens produzidos

 select
  @vl_total_itens_produzidos =
   sum(isnull(pp.qt_planejada_processo,0) * 
      (isnull(pvi.vl_unitario_item_pedido,0) - (isnull(pvi.vl_unitario_item_pedido,0) * isnull(pvi.pc_ipi,0) / 100)))
  from 
   Processo_Producao pp                  with (nolock) 
   left outer join Pedido_Venda_Item pvi with (nolock) on pvi.cd_pedido_venda = pp.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
  where
   pp.dt_fimprod_processo between @dt_inicial and @dt_final and
   pp.cd_status_processo <> 6 -- Cancelada
 
select
  @qt_dias_uteis_periodo              as qt_dias_uteis_periodo,
  @qt_hora_diaria_agenda              as qt_hora_diaria_agenda,
  @qt_capacidade_individual           as qt_capacidade_individual,
  @qt_operadores                      as qt_operadores,
  @qt_maquina                         as qt_maquina,
  @qt_capaciade_total                 as qt_capaciade_total,
  @qt_capaciade_total_maquina         as qt_capaciade_total_maquina,
  @qt_apontado_periodo                as qt_apontado_periodo,
  @qt_apontado_periodo_maquina        as qt_apontado_periodo_maquina,
  @qt_ociosidade                      as qt_ociosidade,
  @qt_ociosidade_maquina              as qt_ociosidade_maquina,
  @vl_custo_horas_trabalhadas         as vl_custo_horas_trabalhadas,
  @vl_custo_horas_trabalhadas_maquina as vl_custo_horas_trabalhadas_maquina,
  @vl_custo_encargos                  as vl_custo_encargos,
  @vl_custo_ociosidade                as vl_custo_ociosidade,
  @vl_custo_ociosidade_maquina        as vl_custo_ociosidade_maquina,
  @vl_materia_prima_periodo           as vl_materia_prima_periodo,
  @vl_despesas_gerais                 as vl_despesas_gerais,
  @vl_total_despesas                  as vl_total_despesas,
  @vl_total_itens_produzidos          as vl_total_itens_produzidos,
  case when @vl_total_itens_produzidos>0 then
  (@vl_total_itens_produzidos - @vl_total_despesas) / @vl_total_itens_produzidos * 100 
  else
   0.00
  end                                as pc_margem

end

-------------------------------------------------------------------------------
else if @ic_tipo_consulta = 1 -- Dados do cabeçalho/Principal
-------------------------------------------------------------------------------
begin

--     --Ultima operacao em que é realizado o apontamento da Inspeção com o Número 
--     --Total de Peças Produzidas
-- 
--     select
--       pp.cd_processo,
--       max(ppa.cd_item_processo)                     as cd_item_processo,
--       sum( isnull(ppa.qt_peca_aprov_apontamento,0)) as Aprovada
--   
--     into
--       #UltimaOperacao
-- 
--     from
--       processo_producao pp                         with (nolock) 
--       inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo
--       left outer join Operacao                 o   with (nolock) on o.cd_operacao   = ppa.cd_operacao  
--     where
--       isnull(o.ic_analise_apontamento,'N' )='S'           --Somente a Operação configurada no Cadastro
-- 
--     group by
--       pp.cd_processo
--     order by
--       pp.cd_processo,
--       ppa.cd_item_processo desc
-- 
--     --select * from #UltimaOperacao
-- 
-- 
--     --Quantidade de Peças que foram Refugadas
--  
--     select
--       pp.cd_processo,
--       sum( isnull(ppa.qt_peca_ruim_produzida,0)) as Refugo
--   
--     into
--       #Refugo
-- 
--     from
--       processo_producao pp                         with (nolock) 
--       inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo
--       left outer join Operacao                 o   with (nolock) on o.cd_operacao   = ppa.cd_operacao  
--     group by
--       pp.cd_processo
--     order by
--       pp.cd_processo
-- 
--     --select * from #Refugo
-- 
--     --Tabela Auxiliar com todos os processos  
-- 
--     select
--       pp.cd_processo,
--       max(pp.dt_entrega_processo)                   as DataEntrega,
--       max(ppa.dt_processo_apontamento)              as DataProducao,
-- 
--       max(isnull(up.Aprovada,0)) +
--       max( isnull(ppx.Refugo,0) )                   as Producao,
-- 
--       max(isnull(up.Aprovada,0))                    as Aprovada,
--       max(isnull(ppx.Refugo,0) )                    as Refugo
-- 
--     into
--       #AuxProducao
-- 
--     from
--       processo_producao pp                         with (nolock) 
--       inner join #UltimaOperacao               up  with (nolock) on up.cd_processo       = pp.cd_processo 
--       inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo      = up.cd_processo       and
--                                                                     ppa.cd_item_processo = up.cd_item_processo
-- 
--       inner join #Refugo ppx                       with (nolock) on ppx.cd_processo      = pp.cd_processo       
-- 
-- 
--     where
--      cd_status_processo = 5 --Ordem de Produção Encerrada
-- 
-- 
--     group by
--       pp.cd_processo


    --select * from #AuxProducao order by cd_processo

   --select * from processo_producao_apontamento

 if @cd_processo = 0 -- Seleciona pelo período passado
 begin

   select
     pp.cd_processo,
     pp.cd_pedido_venda,
     pp.cd_item_pedido_venda,
     pp.qt_planejada_processo,
     a.DataProducao,
     pp.dt_entrega_processo,

     isnull(a.Producao,0)                as qt_produzida_processo,
     isnull(a.Aprovada,0)                as qt_aprovada_processo,
     isnull(a.Refugo,0)                  as Refugo,

--      0.00                             as qt_produzida_processo,
--      0.00                             as qt_aprovada_processo,

--     0.00                             as qt_tempo_estimado,
--     0.00                             as qt_tempo_realizado,

  --Total de Horas da Ordem de Produção

  isnull(( select sum( (isnull(qt_hora_estimado_processo,0) + isnull(qt_hora_setup_processo,0))/60 )
    from
      processo_producao_composicao ppc with (nolock) 
    where
      pp.cd_processo = ppc.cd_processo ),0)                                                       as qt_tempo_estimado,

  --Total de Horas do Apontamento da Ordem de Produção

  isnull( (select sum( isnull(qt_processo_apontamento,0) )
    from
      processo_producao_apontamento ppa with (nolock) 
    where 
      pp.cd_processo = ppa.cd_processo ),0)                                                       as qt_tempo_realizado,


     pv.dt_pedido_venda,
     c.nm_fantasia_cliente,
     v.nm_fantasia_vendedor,
     pd.nm_fantasia_produto,
     pd.nm_produto,

     isnull(pvi.vl_unitario_item_pedido,0) as vl_unitario,
     isnull(pvi.vl_unitario_item_pedido,0) as vl_liquido_unitario,

     --Dedução do IPI foi comentado pelo Carlos em 05.12.2009

     --Round( isnull(pvi.vl_unitario_item_pedido,0) -
     --     ( isnull(pvi.vl_unitario_item_pedido,0) * isnull(pvi.pc_ipi,0) / 100), 2)
     --                                      as vl_liquido_unitario, -- valor - ipi

     pp.dt_processo,
     pp.dt_inicio_processo,
     pp.dt_fimprod_processo,
     pd.cd_produto,
     dbo.fn_indice_markup( pc.cd_aplicacao_markup, pc.cd_tipo_lucro, pc.cd_produto) as Markup

  from 
   Processo_Producao pp                  with (nolock) 
   left outer join #AuxProducao a        with (nolock) on a.cd_processo            = pp.cd_processo
   left outer join Pedido_Venda pv       with (nolock) on pv.cd_pedido_venda       = pp.cd_pedido_venda
   left outer join Cliente c             with (nolock) on c.cd_cliente             = pv.cd_cliente
   left outer join Vendedor v            with (nolock) on v.cd_vendedor            = pv.cd_vendedor
   left outer join Produto pd            with (nolock) on pd.cd_produto            = pp.cd_produto
   left outer join Pedido_Venda_Item pvi with (nolock) on pvi.cd_pedido_venda      = pp.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
   left outer join Produto_Custo pc      with (nolock) on pc.cd_produto            = pd.cd_produto

  where
   pp.dt_fimprod_processo between @dt_inicial and @dt_final and
   pp.cd_status_processo <> 6 -- Cancelada
  order by
   pp.cd_processo
end

 else -- seleciona pelo processo (1 registro)

  select
   pp.cd_processo,
   pp.cd_pedido_venda,
   pp.cd_item_pedido_venda,
   pp.qt_planejada_processo,
   a.DataProducao,
   pp.dt_entrega_processo,

--     0.00                             as qt_produzida_processo,
--     0.00                             as qt_aprovada_processo,
     isnull(a.Producao,0)                as qt_produzida_processo,
     isnull(a.Aprovada,0)                as qt_aprovada_processo,
     isnull(a.Refugo,0)                  as Refugo,

--     0.00                             as qt_tempo_estimado,
--     0.00                             as qt_tempo_realizado,
  isnull(( select sum( (isnull(qt_hora_estimado_processo,0) + isnull(qt_hora_setup_processo,0))/60 )
    from
      processo_producao_composicao ppc
    where
      pp.cd_processo = ppc.cd_processo ),0)                                                       as qt_tempo_estimado,

  --Total de Horas do Apontamento da Ordem de Produção

  isnull( (select sum( isnull(qt_processo_apontamento,0) )
    from
      processo_producao_apontamento ppa
    where 
      pp.cd_processo = ppa.cd_processo ),0)                                                       as qt_tempo_realizado,

   pv.dt_pedido_venda,
   c.nm_fantasia_cliente,
   v.nm_fantasia_vendedor,
   pd.nm_fantasia_produto,
   pd.nm_produto,

   isnull(pvi.vl_unitario_item_pedido,0) as vl_unitario,
   isnull(pvi.vl_unitario_item_pedido,0) as vl_liquido_unitario,

--      Round( isnull(pvi.vl_unitario_item_pedido,0) -
--           ( isnull(pvi.vl_unitario_item_pedido,0) * isnull(pvi.pc_ipi,0) / 100), 2)
--                                            as vl_liquido_unitario, -- valor - ipi
   pp.dt_processo,
   pp.dt_inicio_processo,
   pp.dt_fimprod_processo,
   pd.cd_produto,
   dbo.fn_indice_markup( pc.cd_aplicacao_markup, pc.cd_tipo_lucro, pc.cd_produto) as Markup

  from 
   Processo_Producao pp                  with (nolock) 
   left outer join #AuxProducao a        with (nolock) on a.cd_processo            = pp.cd_processo
   left outer join Pedido_Venda pv       with (nolock) on pv.cd_pedido_venda       = pp.cd_pedido_venda
   left outer join Cliente c             with (nolock) on c.cd_cliente             = pv.cd_cliente
   left outer join Vendedor v            with (nolock) on v.cd_vendedor            = pv.cd_vendedor
   left outer join Produto pd            with (nolock) on pd.cd_produto            = pp.cd_produto
   left outer join Pedido_Venda_Item pvi with (nolock) on pvi.cd_pedido_venda      = pp.cd_pedido_venda and
                                                          pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
   left outer join Produto_Custo pc      with (nolock) on pc.cd_produto            = pd.cd_produto

  where
    pp.cd_status_processo <> 6 and -- Cancelada
   (pp.cd_processo = @cd_processo)

end

-------------------------------------------------------------------------------
else if @ic_tipo_consulta = 2 -- Despesas gerais de producao
-------------------------------------------------------------------------------
begin

 select
  dpv.cd_despesa_producao,
  dp.nm_despesa_producao,
  isnull(dpv.vl_despesa_producao,0) as vl_despesa_producao,  
  @qt_apontado_periodo              as qt_apontado_periodo,
  case when @qt_apontado_periodo>0 then
    Round( isnull(dpv.vl_despesa_producao,0) / (@qt_apontado_periodo) * @qt_apontado_processo, 2)  
  else
    0.00
  end
--aqui  Round(dpv.vl_despesa_producao / (@qt_apontado_periodo_maquina) * @qt_apontado_processo, 2) 
                                    as valor_op
 from
  despesa_producao_valor dpv          with (nolock) 
  left outer join despesa_producao dp with (nolock) on dp.cd_despesa_producao = dpv.cd_despesa_producao
 where
  dt_inicio_despesa_prod >=  @dt_inicial and 
  dt_final_despesa_prod  <=  @dt_final 

 order by
  3 desc

end

-------------------------------------------------------------------------------
else if @ic_tipo_consulta = 3 -- Mao de obra
-------------------------------------------------------------------------------
begin
 select
  o.cd_operador,
  o.nm_operador,
  case when isnull(ov.vl_operador,0)>0 then
    isnull(ov.vl_operador,0)
  else
    isnull(o.vl_hora_operador,0)
  end                                  as vl_operador,

  case when isnull(ov.vl_encargo_operador,0)>0 then
    isnull(ov.vl_encargo_operador,0)
  else
    isnull(o.vl_encargo_operador,0)
  end                                  as vl_encargo_operador,

  ap.qt_apontado_operador_periodo      as qt_trabalho_efetivo,

  -- Calculo das horas ociosas
  case when @ic_ociosa_hora_producao='S' and aop.qt_capacidade_operador>0 then 
     Round((aop.qt_ociosidade_periodo / aop.qt_capacidade_operador) * ap.qt_apontado_operador_periodo, 4)
  else
    0.00
  end                                  as qt_horas_ociosa,

  -- Calculo do valor total hora

  Round(case when isnull(ov.vl_operador,0)>0 then
    isnull(ov.vl_operador,0) 
  else
    isnull(o.vl_hora_operador,0)
  end * ap.qt_apontado_operador_periodo, 2) as vl_total_hora,

  -- Calculo do valor total dos encargos
  Round(case when isnull(ov.vl_encargo_operador,0)>0 then
     isnull(ov.vl_encargo_operador,0) 
  else
     isnull(o.vl_encargo_operador,0)
  end * ap.qt_apontado_operador_periodo, 2) as vl_total_encargo,

  -- Calculo do valor das horas ociosas

  case when @ic_ociosa_hora_producao='S' and aop.qt_capacidade_operador>0 then

  Round(

    (case when isnull(ov.vl_operador,0)>0 then ov.vl_operador else o.vl_hora_operador end
    +
     case when isnull(ov.vl_encargo_operador,0)>0 then ov.vl_encargo_operador else o.vl_encargo_operador end
    ) -- (vlHora + vlEncargos) * Horas
     * Round((aop.qt_ociosidade_periodo / aop.qt_capacidade_operador) * ap.qt_apontado_operador_periodo, 4), -- qt_horas_ociosas
     2)
 else
  0.00
 end                                       as vl_total_ociosidade,

  -- Calculo do custo da mão de obra

  (Round(case when isnull(ov.vl_operador,0)>0 then ov.vl_operador else o.vl_hora_operador end
   * ap.qt_apontado_operador_periodo, 2) -- vl_total_hora
   + 
   Round(case when isnull(ov.vl_encargo_operador,0)>0 then ov.vl_encargo_operador else o.vl_encargo_operador end
   * ap.qt_apontado_operador_periodo, 2) -- vl_total_encargo
   
   + 

   case when @ic_ociosa_hora_producao='S' and aop.qt_capacidade_operador > 0 then
   Round((case when isnull(ov.vl_operador,0)>0 then ov.vl_operador else o.vl_hora_operador end
     + 
     case when isnull(ov.vl_encargo_operador,0)>0 then ov.vl_encargo_operador else o.vl_encargo_operador end) 
   * case when aop.qt_capacidade_operador>0 then
     ((aop.qt_ociosidade_periodo / aop.qt_capacidade_operador) * ap.qt_apontado_operador_periodo)
     else 
      0.00
     end, 2) 
   else
     0.00
   end -- vl_total_ociosidade
    )

                                                      as custo_mo

 from
  #Apontamento_Processo ap
 left outer join operador_valor ov                 on ov.cd_operador         = ap.cd_operador and
                                                      ov.dt_inicial_operador >= @dt_inicial and 
                                                      ov.dt_final_operador   <= @dt_final

 left outer join operador o                        on o.cd_operador   = ap.cd_operador
 left outer join #Apontamento_Operador_Periodo aop on aop.cd_operador = ap.cd_operador

--  where
--   ov.dt_inicial_operador >= @dt_inicial and 
--   ov.dt_final_operador   <= @dt_final

 order by
  o.nm_operador

end

-------------------------------------------------------------------------------
else if @ic_tipo_consulta = 4 -- Matéria Prima
-------------------------------------------------------------------------------
begin
 select
   ppc.cd_processo,
   ppc.cd_componente_processo,
   p.nm_fantasia_produto,
   p.nm_produto,
   um.sg_unidade_medida,
   ppc.qt_comp_processo,
   isnull(case when isnull(me.vl_custo_contabil_produto,0)>0 
   then
       me.vl_custo_contabil_produto 
   else
       pc.vl_custo_produto 
   end,0)                                                          as 'vl_unitario_movimento',

   Round(ppc.qt_comp_processo * 

   isnull(case when isnull(me.vl_custo_contabil_produto,0)>0 
   then
       me.vl_custo_contabil_produto 
   else
       pc.vl_custo_produto 
   end,0), 2)                                                        as 'Custo_Total'

 from 
  Processo_Producao_Componente ppc      with (nolock) 
  left outer join Produto p             with (nolock) on  p.cd_produto            = ppc.cd_produto
  left outer join Produto_Custo pc      with (nolock) on pc.cd_produto            = p.cd_produto 
  left outer join Unidade_Medida um     with (nolock) on  um.cd_unidade_medida    = p.cd_unidade_medida
  left outer join Movimento_Estoque me  with (nolock) on  me.cd_movimento_estoque = ppc.cd_movimento_estoque 
  left outer join processo_producao pp  with (nolock) on  pp.cd_processo          = ppc.cd_processo
 where
    pp.cd_status_processo <> 6 and -- Cancelada
    ppc.cd_processo = @cd_processo
 order by
  ppc.cd_componente_processo
end
-------------------------------------------------------------------------------
else if @ic_tipo_consulta = 5 -- Maquina
-------------------------------------------------------------------------------
begin

 --select * from maquina
 
 select
  m.cd_maquina,
  m.nm_maquina,
  m.vl_custo_maquina,

  isnull(case when isnull(mv.vl_hora_maquina,0)=0 then
    m.vl_custo_maquina
  else
    mv.vl_hora_maquina
 end,0)                                            as vl_hora_maquina,

  isnull(ap.qt_apontado_periodo_maquina_periodo,0) as qt_trabalho_efetivo,

  -- Calculo das horas ociosas
  case when @ic_ociosa_hora_producao='S' and amp.qt_capacidade_maquina>0 then
    isnull(Round(( isnull(amp.qt_ociosidade_periodo,0) / amp.qt_capacidade_maquina) * ap.qt_apontado_periodo_maquina_periodo, 4),0)
  else
   0.00
  end                                as qt_horas_ociosa,

  -- Calculo do valor total hora

  Round(
  case when isnull(mv.vl_hora_maquina,0)>0 then mv.vl_hora_maquina else m.vl_custo_maquina end
  * isnull(ap.qt_apontado_periodo_maquina_periodo,0), 2) as vl_total_hora,

  -- Calculo do valor das horas ociosas
  case when @ic_ociosa_hora_producao='S' and amp.qt_capacidade_maquina>0  then

  isnull(Round((
       case when isnull(mv.vl_hora_maquina,0)>0 then mv.vl_hora_maquina else m.vl_custo_maquina end) -- (vlHora) * Horas
     * Round((isnull(amp.qt_ociosidade_periodo,0) / amp.qt_capacidade_maquina) * ap.qt_apontado_periodo_maquina_periodo, 4), -- qt_horas_ociosas
     2),0) 
  else
   0.00
  end                                 as vl_total_ociosidade,

  -- Calculo do custo da maquina

  (Round(  case when isnull(mv.vl_hora_maquina,0)>0 then mv.vl_hora_maquina else m.vl_custo_maquina end
   * isnull(ap.qt_apontado_periodo_maquina_periodo,0), 2) -- vl_total_hora
  + 
  case when @ic_ociosa_hora_producao='S' and amp.qt_capacidade_maquina>0 then

   Round( ( case when isnull(mv.vl_hora_maquina,0)>0 then mv.vl_hora_maquina else m.vl_custo_maquina end)
          * 
          ((isnull(amp.qt_ociosidade_periodo,0) / amp.qt_capacidade_maquina ) * ap.qt_apontado_periodo_maquina_periodo)
         , 2) -- vl_total_ociosidade
  else
   0.00
  end  )                                          as custo_ma

 from

  #Apontamento_Processo_Maquina ap                 with (nolock) 
  left outer join Maquina_Valor mv                 with (nolock) on mv.cd_maquina          = ap.cd_maquina  and
                                                                    mv.dt_inicial_maquina >= @dt_inicial    and
                                                                    mv.dt_final_maquina   <= @dt_final

  left outer join Maquina m                        with (nolock) on m.cd_maquina   = ap.cd_maquina
  left outer join #Apontamento_maquina_Periodo amp with (nolock) on amp.cd_maquina = ap.cd_maquina

 --where
--  mv.dt_inicial_maquina >= @dt_inicial and
--  mv.dt_final_maquina   <=   @dt_final

 order by
  m.nm_maquina

end
-------------------------------------------------------------------------------
else if @ic_tipo_consulta = 6 -- Serviço Externo
-------------------------------------------------------------------------------
begin
 --select * from processo_producao_composicao
 --select * from servico_especial

 select
   ppc.cd_processo,
   ppc.cd_item_processo,
   ppc.cd_servico_especial,
   se.nm_servico_especial,
   um.sg_unidade_medida,
   pp.qt_planejada_processo,

   --a.Aprovada,
   a.Producao                as Aprovada,

   --Peso Unitário

   isnull(p.qt_peso_bruto,0) as qt_peso_bruto,

   --Quantidade em Peso

   case when isnull(se.ic_tipo_custo_servico,'T')='K'   
   then               
     a.Producao * isnull(p.qt_peso_bruto,0)
   else
     0.00
   end                       as qt_peso_total_servico,

   se.vl_servico_especial,
   se.vl_minimo_servico,
   se.qt_lote_minimo_servico,

   --Calculo do Custo Total

   CustoTotalServico  = 

                                case when isnull(ppc.cd_servico_especial,0)=0 --Verifica se existe serviço
                                then 0.00 
                                else     
                                     --Custo do Servico para o Produto

                                     case when isnull(se.ic_tipo_custo_servico,'T')<>'K' 
                                     then
--                                       se.vl_servico_especial * a.Aprovada
                                       se.vl_servico_especial * a.Producao
                                     else
                                       case when isnull(se.ic_tipo_custo_servico,'T')='K'   
                                       then               
                                          se.vl_servico_especial * isnull(p.qt_peso_bruto,0) * a.Producao
                                       else  
                                         isnull(pse.vl_custo_produto_servico,1)  
                                       end  
                                     end  
                                 end


--Antes 16.05.2010
--
--                                 case when isnull(ppc.cd_servico_especial,0)=0 
--                                 then 0.00 
--                                 else     
--                                   ( ( 
-- 
-- 
-- --Quantidade Padrão do Processo
-- --                                     case when isnull(se.ic_tipo_custo_servico,'T')='T'
-- --                                      then
-- --                                        1
-- --                                      else 
-- --                                        isnull(pp.qt_processo_padrao,1)
-- --                                      end
-- --
-- --                                     * 
-- --select * from servico_especial
--                                      --Custo do Servico para o Produto
-- 
--                                      case when isnull(se.vl_minimo_servico,0)>0 and isnull(se.ic_tipo_custo_servico,'T')<>'K' 
--                                      then
--                                        case when (se.vl_minimo_servico/se.vl_servico_especial) <= a.Aprovada --pp.qt_planejada_processo
--                                        then
-- 
--                                         dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
--                                                                  isnull(se.qt_fator_conversao_servico,0), 
--                                                                  isnull(se.ic_sinal_conversao_servico,''))
-- 
--                                        else
--                                         (se.vl_minimo_servico
--                                         /
--                                         case when isnull(a.Aprovada,0) > 0 --isnull(pp.qt_planejada_processo,0)>0 
--                                         then
--                                           a.Aprovada --pp.qt_planejada_processo
--                                         else
--                                           1
--                                         end)
--                                        end 
--   
--                                      else
--                                        case when isnull(se.vl_minimo_servico,0)>0 and isnull(se.ic_tipo_custo_servico,'T')='K'   
--                                        then               
-- --                                             (se.vl_minimo_servico /  
-- --                                             case when isnull(pp.qt_processo_padrao,0)>0   
-- --                                             then  
-- --                                               pp.qt_processo_padrao  
-- --                                             else  
-- --                                               1  
-- --                                             end)  
--   
--   
--                                           case when (se.vl_minimo_servico/se.vl_servico_especial) <= pp.qt_planejada_processo
--                                           then  
--                                               se.vl_servico_especial * isnull(p.qt_peso_bruto,0)
--                                           else  
--                                             (se.vl_minimo_servico /  
--                                             case when isnull(a.Aprovada,0)>0 --isnull(pp.qt_planejada_processo,0)>0   
--                                             then  
--                                               a.Aprovada --pp.qt_planejada_processo
--                                             else  
--                                               1  
--                                             end)  
--   
--                                           end  
--   
--                                        else  
--                                          isnull(pse.vl_custo_produto_servico,1)  
--                                        end  
--                                      end  
-- 
--                                      *
-- 
--                                     --Tempo
--                                     ( case when isnull(se.ic_tipo_custo_servico,'T')='T' 
--                                       then isnull(ppc.qt_hora_setup_processo,0)
--                                            /
--                                            case when isnull(a.Aprovada,0)>0 --isnull(pp.qt_planejada_processo,0)>0 
--                                            then
--                                              a.Aprovada --isnull(pp.qt_planejada_processo,0)
--                                            else
--                                              1
--                                            end
--                                       else 
--                                         --Peso da Produto/Preça
--                                         case when isnull(se.ic_tipo_custo_servico,'T')='K' 
--                                         then
--                                           case when isnull(p.qt_peso_bruto,0)>0 
--                                           then 1 --isnull(p.qt_peso_bruto,0) 
--                                           else 1 end
--                                         else
--                                           1
--                                         end
--                                       end )
--                                     
--                                      + 
-- 
--                                      --Tempo
-- 
--                                      case when isnull(se.ic_tipo_custo_servico,'T')='T'
--                                      then
--                                        isnull(ppc.qt_hora_estimado_processo,0)
--                                      else
--                                        0
--                                      end
--  
--                                      ) 
--                                        
--                                      * 
-- 
--                                      case when 
--                                      dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
--                                                              isnull(se.qt_fator_conversao_servico,0), 
--                                                              isnull(se.ic_sinal_conversao_servico,''))>0 and
--                                      isnull(se.vl_minimo_servico,0)=0
--                                      then
--                                        dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
--                                                              isnull(se.qt_fator_conversao_servico,0), 
--                                                              isnull(se.ic_sinal_conversao_servico,'')) 
-- 
--                                      else
--                                        1
--                                      end    )
-- 
--                                end

 from

   processo_producao_composicao ppc    with (nolock) 
   inner join processo_producao pp     with (nolock) on pp.cd_processo           = ppc.cd_processo
   left outer join #AuxProducao a      with (nolock) on a.cd_processo            = pp.cd_processo
   left outer join servico_especial se with (nolock) on se.cd_servico_especial   = ppc.cd_servico_especial
   left outer join unidade_medida   um with (nolock) on um.cd_unidade_medida     = se.cd_unidade_medida
   left outer join produto_servico_especial pse 
                                       with (nolock) on pse.cd_produto           = pp.cd_produto and
                                                        pse.cd_servico_especial  = ppc.cd_servico_especial

   left outer join produto p           with (nolock) on p.cd_produto           = pp.cd_produto

 where
    pp.cd_status_processo <> 6 and -- Cancelada
    ppc.cd_processo = @cd_processo and
    isnull(ppc.cd_servico_especial,0)>0


 order by
   pp.cd_processo

--select * from processo_producao_composicao
 
end

--select * from maquina
---------------------------------------------------------------------------------
