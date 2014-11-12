
CREATE PROCEDURE pr_analise_calculo_orcamento  
  
@cd_consulta               int,  
@cd_item_consulta          int,  
@cd_tipo_produto_espessura int = null, -- Necessário nos casos de Placa para Molde, para Base ...  
                                       -- é Placa, MAS o markup é o de molde/base   
@cd_aplicacao_markup       int = null  -- Necessário nos casos de Placa para Molde, para Base ...  
                                       -- é Placa, MAS o markup é o de molde/base   
as  
  
declare @qt_item_componente       int  
declare @qt_pesliq_item_orcamento float  
declare @qt_pesbru_item_orcamento float  
declare @vl_custo_mat_prima       float  
declare @vl_venda_mat_prima       float  
declare @vl_custo_componente      float  
declare @vl_venda_componente      float  
declare @qt_hora_mao_obra_padrao  float  
declare @qt_hora_mao_obra_serv    float  
declare @vl_custo_mao_obra_padrao float  
declare @vl_custo_mao_obra_serv   float  
declare @vl_venda_mao_obra_padrao float  
declare @vl_venda_mao_obra_serv   float  
declare @qt_item_servico_externo  float  
declare @vl_total_servico_externo float  
declare @pc_lucro_servico         float  
declare @pc_markup_mat_prima      float   
declare @pc_markup_componente     float  
declare @pc_markup_mao_obra_padrao float  
declare @pc_markup_sem_lucro      float  
declare @pc_markup_mao_obra_serv  float  
declare @sg_produto_espessura     char(10)  
-- Dados de CQ
declare @cd_tipo_manifold       int     -- FMX, FMH ...
declare @ic_orcamento_calculado char(1) -- Se será calculado por MP, Cpo. e MO ou virá dos componentes
declare @cd_produto_padrao      int     -- Manifold padrão que foi usado para busca do Markup

-- Busca somente dados de CQ (se for o caso)
select top 1
       @cd_tipo_manifold       = cct.cd_tipo_manifold,
       @cd_produto_padrao      = cct.cd_produto_padrao_orcam, 
       @ic_orcamento_calculado = ts.ic_orcamento_calculado
--
from consulta_caract_tecnica_cq cct,
     tipo_sistema_cq ts
--
where cct.cd_consulta      = @cd_consulta and 
      cct.cd_item_consulta = @cd_item_consulta and 
      cct.cd_tipo_sistema  = ts.cd_tipo_sistema 

set @ic_orcamento_calculado = isnull(@ic_orcamento_calculado,'S')
  
select top 1 
       @pc_markup_componente      = isnull(pc_markup_componente,1),
       @pc_markup_mao_obra_padrao = isnull(pc_markup_mao_obra,1),
       @pc_markup_mat_prima       = isnull(pc_markup_mat_prima,1)
from consulta_item_orcamento  
where cd_consulta      = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta
  
select @vl_custo_mat_prima       = sum(vl_custo_mat_prima),
       @qt_pesliq_item_orcamento = sum(qt_pesliq_item_orcamento),
       @qt_pesbru_item_orcamento = sum(qt_pesbru_item_orcamento)
from consulta_item_orcamento 
where cd_consulta = @cd_consulta and
      cd_item_consulta = @cd_item_consulta 

declare @nm_produto_consulta varchar(5)  
declare @cd_moeda_cotacao    int   
declare @vl_moeda_cotacao    float  
declare @dt_moeda_cotacao    datetime 
declare @Exportacao          char(1)
  
select @nm_produto_consulta = substring(a.nm_produto_consulta,1,5),  
       @cd_moeda_cotacao    = a.cd_moeda_cotacao,   
       @Exportacao          = isnull(tm.ic_exportacao_tipo_mercado,'N')
--
from consulta_itens a 
--
inner join Consulta co on
a.cd_consulta = co.cd_consulta
inner join Cliente cl on
co.cd_cliente = cl.cd_cliente
left outer join Tipo_Mercado tm on
cl.cd_tipo_mercado = tm.cd_tipo_mercado

where a.cd_consulta      = @cd_consulta and  
      a.cd_item_consulta = @cd_item_consulta  
  
-- Códigos para buscar markup "sem lucro"  

declare @cd_aplicacao_markup_especifico int
  
if @cd_aplicacao_markup is null  
begin
   declare @cd_grupo_produto int   
   select Top 1
          @cd_grupo_produto =  ci.cd_grupo_produto
   from Consulta_Itens ci
   where ci.cd_consulta       = @cd_consulta and 
         ci.cd_item_consulta  = @cd_item_consulta
   
   select @cd_aplicacao_markup_especifico = cd_aplicacao_markup
   from grupo_produto_markup
   where cd_grupo_produto = @cd_grupo_produto and
         cd_moeda = @cd_moeda_cotacao
   
   if isnull(@cd_aplicacao_markup_especifico,0) > 0
      set @cd_aplicacao_markup = @cd_aplicacao_markup_especifico
   else
      set @cd_aplicacao_markup = (select top 1 cd_aplicacao_markup  
                                  from grupo_produto_custo
                                  where cd_grupo_produto = @cd_grupo_produto)
end
  
-- As placas, por exemplo, pode "pegar" markup de Molde/Base  
if @cd_tipo_produto_espessura is not null   
  set @sg_produto_espessura = (select top 1 sg_tipo_produto_espessura  
                               from tipo_produto_espessura  
                               where cd_tipo_produto_espessura = @cd_tipo_produto_espessura)  
else  
  set @sg_produto_espessura = (select top 1 tpe.sg_tipo_produto_espessura  
                               from grupo_produto gp,   
                                    consulta_itens ci,  
                                    tipo_produto_espessura tpe  
                               where ci.cd_consulta      = @cd_consulta and  
                                     ci.cd_item_consulta = @cd_item_consulta and  
                                     ci.cd_grupo_produto = gp.cd_grupo_produto and  
                                     gp.cd_tipo_produto_espessura = tpe.cd_tipo_produto_espessura)  
  
select @pc_markup_sem_lucro = sum(a.pc_formacao_markup)  
from formacao_markup a,  
     tipo_markup b             
where a.cd_aplicacao_markup = @cd_aplicacao_markup and  
      a.ic_tipo_formacao_markup = 'A' and  
      a.cd_tipo_markup = b.cd_tipo_markup and  
      b.ic_tipo_markup_lucro <> 'S'  
  
-- Alterado em 03/05/05 : Pegar última cotação (e não a gravada na Proposta)

declare @ic_conversao_moeda char(1)

select top 1 
       @vl_moeda_cotacao   = vm.vl_moeda,
       @dt_moeda_cotacao   = vm.dt_moeda,
       @ic_conversao_moeda = m.ic_convercao_moeda      
--
from valor_moeda vm
--
inner join moeda m on
vm.cd_moeda = m.cd_moeda 
where vm.cd_moeda = @cd_moeda_cotacao

order by vm.dt_moeda desc

--Código colocado em 15.12.2004 por "segurança". Não está aprovado ainda pelo Chicão ! Lucio.  
set @nm_produto_consulta=''  
  
if @nm_produto_consulta in ('MPE-1','MPE-2','MPE-3','MPE-4','MPE-5')  
  set @pc_lucro_servico = 20  
else  
  select @pc_lucro_servico = (select top 1 pc_tipo_lucro from Tipo_Lucro  
                              where ic_servico_tipo_lucro = 'S')  
  
set @pc_markup_mao_obra_serv = (100 - (@pc_markup_sem_lucro + @pc_lucro_servico)) / 100   
  
set @pc_markup_sem_lucro = (100-sum(@pc_markup_sem_lucro))/100  
 
-- Componentes : Custo e Venda
  
select @qt_item_componente  = count(qt_item_comp_orcamento),  
       @vl_custo_componente = sum((case when isnull(vl_custo_produto,0) = 0 then vl_produto 
                              else vl_custo_produto end) * qt_item_comp_orcamento),
       @vl_venda_componente = sum((case when (isnull(vl_custo_produto,0) = 0 or isnull(@pc_markup_componente,0) = 0) then vl_produto 
                              else (vl_custo_produto/@pc_markup_componente) end) * qt_item_comp_orcamento)
--
from consulta_item_componente a
--
where cd_consulta      = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta and
      isnull(ic_acessorio_orcamento,'N') <> 'S' 
  
-- Horas e Custo de MO (Fases)  
  
select qt_hora_mao_obra_padrao    = (case when go.ic_serv_grupo_orcamento <> 'S' then a.qt_hora_item_orcamento  else 0 end),  
       vl_custo_mao_obra_padrao   = (case when go.ic_serv_grupo_orcamento <> 'S' then a.vl_custo_item_orcamento else 0 end),  
       qt_hora_mao_obra_serv      = (case when go.ic_serv_grupo_orcamento = 'S'  then a.qt_hora_item_orcamento  else 0 end),  
       vl_custo_mao_obra_serv     = (case when go.ic_serv_grupo_orcamento = 'S'  then a.vl_custo_item_orcamento else 0 end),  
       qt_hora_convencional_fase  = (case when tmo.cd_tipo_mao_obra = 1 then a.qt_hora_item_orcamento  else 0 end),  
       qt_hora_CNC_fase           = (case when tmo.cd_tipo_mao_obra = 2 then a.qt_hora_item_orcamento  else 0 end),  
       qt_hora_refrigeracao_fase  = (case when tmo.cd_tipo_mao_obra = 4 then a.qt_hora_item_orcamento  else 0 end),  
       vl_custo_convencional_fase = (case when tmo.cd_tipo_mao_obra = 1 then a.vl_custo_item_orcamento else 0 end),  
       vl_custo_CNC_fase          = (case when tmo.cd_tipo_mao_obra = 2 then a.vl_custo_item_orcamento else 0 end),  
       vl_custo_refrigeracao_fase = (case when tmo.cd_tipo_mao_obra = 4 then a.vl_custo_item_orcamento else 0 end)  
----  
into #TmpConsultaItemOrcamentoCat  
----  
from consulta_item_orcamento_cat a,  
     consulta_item_orcamento b,  
     categoria_orcamento co,  
     grupo_orcamento go,  
     mao_obra mo,  
     tipo_mao_obra tmo  
  
where a.cd_consulta            = @cd_consulta and  
      a.cd_item_consulta       = @cd_item_consulta and  
      a.cd_consulta            = b.cd_consulta and  
      a.cd_item_consulta       = b.cd_item_consulta and  
      a.cd_item_orcamento      = b.cd_item_orcamento and  
      a.cd_categoria_orcamento = co.cd_categoria_orcamento and  
      co.cd_grupo_orcamento    = go.cd_grupo_orcamento and  
      go.cd_mao_obra           = mo.cd_mao_obra and  
      mo.cd_tipo_mao_obra      = tmo.cd_tipo_mao_obra   
  
declare @qt_hora_convencional_fase     float  
declare @qt_hora_CNC_fase              float  
declare @qt_hora_refrigeracao_fase     float  
declare @qt_hora_mandrilhadora_refrig  float  
declare @qt_hora_mandrilhadora_aloj    float  
declare @vl_custo_convencional_fase    float  
declare @vl_custo_CNC_fase             float  
declare @vl_custo_refrigeracao_fase    float  
declare @vl_custo_mandrilhadora_refrig float  
declare @vl_custo_mandrilhadora_aloj   float  
declare @vl_venda_mandrilhadora_refrig float  
declare @vl_venda_mandrilhadora_aloj   float  
  
-- Horas de mandrilhadora em Refrigeração  
  
select @qt_hora_mandrilhadora_refrig = sum((case when isnull(qt_hora_mandrilhadora,0) > 0 then qt_hora_mandrilhadora  
                                            else 0 end)),  
       @vl_custo_mandrilhadora_refrig = sum((case when isnull(vl_custo_mandrilhadora,0) > 0 then vl_custo_mandrilhadora  
                                            else 0 end))  
from consulta_item_orcamento_refrigeracao  
where cd_consulta      = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta  
  
-- Horas de mandrilhadora em Alojamento  
  
select @qt_hora_mandrilhadora_aloj = sum((case when isnull(qt_hora_mandrilhadora,0) > 0 then qt_hora_mandrilhadora  
                                            else 0 end)),  
       @vl_custo_mandrilhadora_aloj = sum((case when isnull(vl_custo_mandrilhadora,0) > 0 then vl_custo_mandrilhadora  
                                            else 0 end))  
from consulta_item_orcamento_alojamento  
where cd_consulta      = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta  
  
-- Totaliza todas as fases  
  
select @qt_hora_mao_obra_padrao     = sum(qt_hora_mao_obra_padrao),  
       @vl_custo_mao_obra_padrao    = sum(vl_custo_mao_obra_padrao),  
       @qt_hora_mao_obra_serv       = sum(qt_hora_mao_obra_serv),  
       @vl_custo_mao_obra_serv      = sum(vl_custo_mao_obra_serv),  
       @qt_hora_convencional_fase   = sum(qt_hora_convencional_fase),  
       @qt_hora_refrigeracao_fase   = sum(qt_hora_refrigeracao_fase),  
       @qt_hora_CNC_fase            = sum(qt_hora_CNC_fase),  
       @vl_custo_convencional_fase  = sum(vl_custo_convencional_fase),  
       @vl_custo_CNC_fase           = sum(vl_custo_CNC_fase),  
       @vl_custo_refrigeracao_fase  = sum(vl_custo_refrigeracao_fase)  
  
from #TmpConsultaItemOrcamentoCat  

if upper(@sg_produto_espessura) <> 'MOLDE'
   set @pc_markup_mao_obra_serv = @pc_markup_mao_obra_padrao  

-- Seleciona total de horas : CNC, Convencional, Refrigeração e Mandrilhadora (Agregadas)  
-- Por placa  
  
select cd_consulta,  
       cd_item_consulta,  
       cd_item_orcamento,  
       cd_item_serv_manual,   
       qt_hora_convencional =   
       case when cd_tipo_mao_obra = 1 and ic_tipo_mao_obra <> 'M' then isnull(qt_hora_item_serv_manual,0) else 0 end,   
       vl_custo_convencional =   
       case when cd_tipo_mao_obra = 1 and ic_tipo_mao_obra <> 'M' then isnull(vl_total_item_serv_manual,0) else 0 end,   
       qt_hora_CNC =   
       case when cd_tipo_mao_obra = 2  then isnull(qt_hora_item_serv_manual,0) else 0 end,  
       vl_custo_CNC =   
       case when cd_tipo_mao_obra = 2  then isnull(vl_total_item_serv_manual,0) else 0 end,  
       qt_hora_refrigeracao =   
       case when cd_tipo_mao_obra = 4   then isnull(qt_hora_item_serv_manual,0) else 0 end,   
       vl_custo_refrigeracao =   
       case when cd_tipo_mao_obra = 4   then isnull(vl_total_item_serv_manual,0) else 0 end,   
       qt_hora_mandrilhadora =   
       case when ic_tipo_mao_obra = 'M' then isnull(qt_hora_item_serv_manual,0) else 0 end,  
       vl_custo_mandrilhadora =   
       case when ic_tipo_mao_obra = 'M' then isnull(vl_total_item_serv_manual,0) else 0 end  
-------  
into #TmpServicoManual  
-------  
from consulta_item_orcamento_servico_manual  
  
where cd_consulta      = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta  
  
-- Variáveis referente serviços agregados  
  
declare @qt_hora_serv_manual    float  
declare @vl_custo_serv_manual   float  
declare @vl_venda_serv_manual   float  
declare @qt_hora_CNC            float  
declare @vl_custo_CNC           float  
declare @qt_hora_convencional   float  
declare @vl_custo_convencional  float  
declare @qt_hora_refrigeracao   float  
declare @vl_custo_refrigeracao  float  
declare @qt_hora_mandrilhadora  float  
declare @vl_custo_mandrilhadora float  
  
-- Seleciona TOTAL de horas agregadas em SERVIÇOS MANUAIS  
  
select @qt_hora_serv_manual    = sum(isnull(a.qt_hora_item_serv_manual,0)),  
       @vl_custo_serv_manual   = sum(isnull(a.vl_total_item_serv_manual,0)),  
       @qt_hora_CNC            = sum(isnull(b.qt_hora_CNC,0)),  
       @qt_hora_convencional   = sum(isnull(b.qt_hora_convencional,0)),  
       @qt_hora_refrigeracao   = sum(isnull(b.qt_hora_refrigeracao,0)),  
       @qt_hora_mandrilhadora  = sum(isnull(b.qt_hora_mandrilhadora,0)),  
       @vl_custo_CNC           = sum(isnull(b.vl_custo_CNC,0)),  
       @vl_custo_convencional  = sum(isnull(b.vl_custo_convencional,0)),  
       @vl_custo_refrigeracao  = sum(isnull(b.vl_custo_refrigeracao,0)),  
       @vl_custo_mandrilhadora = sum(isnull(b.vl_custo_mandrilhadora,0))  
  
from consulta_item_orcamento_servico_manual a,  
     #TmpServicoManual b  
  
where a.cd_consulta         = @cd_consulta and  
      a.cd_item_consulta    = @cd_item_consulta and  
      a.cd_consulta         = b.cd_consulta and  
      a.cd_item_consulta    = b.cd_item_consulta and  
      a.cd_item_orcamento   = b.cd_item_orcamento and  
      a.cd_item_serv_manual = b.cd_item_serv_manual  
  
-- Valor total de serviços externos  
  
select @vl_total_servico_externo = sum(isnull(vl_total_servico_externo,0)),  
       @qt_item_servico_externo  = sum(isnull(qt_item_servico_externo,0))  
from Consulta_Item_Servico_Externo   
where cd_consulta      = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta  
  
declare @vl_venda_PV float  
declare @vl_lista_PV float  
declare @pc_desc_PV  float  

--Valores do Pedido de Venda (se Houver ...)

select top 1  
       @vl_venda_PV = round(vl_unitario_item_pedido,2),  
       @vl_lista_PV = round(vl_lista_item_pedido,2),  
       @pc_desc_PV  = round(pc_desconto_item_pedido,2)  
--
from pedido_venda_item  
--
where cd_consulta = @cd_consulta and  
      cd_item_consulta = @cd_item_consulta  
order by cd_pedido_venda desc  

declare @vl_medio_moeda float
if @Exportacao = 'S'
begin
   select top 1 @vl_medio_moeda = vl_moeda_periodo 
   from valor_moeda_periodo
   where cd_moeda = @cd_moeda_cotacao and
        (getdate() between dt_inicial_periodo and dt_final_periodo)
   
   set @vl_custo_mat_prima           = isnull(@vl_custo_mat_prima,0)            / @vl_medio_moeda
   set @vl_custo_componente          = isnull(@vl_custo_componente,0)           / @vl_medio_moeda
   set @vl_custo_mao_obra_padrao     = isnull(@vl_custo_mao_obra_padrao,0)      / @vl_medio_moeda
   set @vl_custo_mao_obra_serv       = isnull(@vl_custo_mao_obra_serv,0)        / @vl_medio_moeda
   set @vl_custo_serv_manual         = isnull(@vl_custo_serv_manual,0)          / @vl_medio_moeda
   set @vl_custo_CNC                 = isnull(@vl_custo_CNC,0)                  / @vl_medio_moeda
   set @vl_custo_CNC_fase            = isnull(@vl_custo_CNC_fase,0)             / @vl_medio_moeda
   set @vl_custo_convencional        = isnull(@vl_custo_convencional,0)         / @vl_medio_moeda
   set @vl_custo_convencional_fase   = isnull(@vl_custo_convencional_fase,0)    / @vl_medio_moeda
   set @vl_custo_refrigeracao        = isnull(@vl_custo_refrigeracao,0)         / @vl_medio_moeda
   set @vl_custo_refrigeracao_fase   = isnull(@vl_custo_refrigeracao_fase,0)    / @vl_medio_moeda
   set @vl_custo_mandrilhadora       = isnull(@vl_custo_mandrilhadora,0)        / @vl_medio_moeda
   set @vl_custo_mandrilhadora_refrig= isnull(@vl_custo_mandrilhadora_refrig,0) / @vl_medio_moeda   
   set @vl_custo_mandrilhadora_aloj  = isnull(@vl_custo_mandrilhadora_aloj,0)   / @vl_medio_moeda
-- set @vl_total_servico_externo     = isnull(@vl_total_servico_externo,0)      / @vl_medio_moeda
   -- Aplica markup sobre o serviço externo também
-- if (@vl_total_servico_externo > 0) and (@pc_markup_mao_obra_padrao > 0)
--    set @vl_total_servico_externo = @vl_total_servico_externo / @pc_markup_mao_obra_padrao

   -- Valor de venda dos componentes
   if (@vl_custo_componente > 0) and (@pc_markup_componente > 0)  
      set @vl_venda_componente = @vl_custo_componente / @pc_markup_componente
end
  
-- Valores de venda Matéria-Prima
if (@vl_custo_mat_prima > 0) and (@pc_markup_mat_prima > 0)  
   set @vl_venda_mat_prima = @vl_custo_mat_prima / @pc_markup_mat_prima
  
-- Valores de venda Mão de Obra  
if (@vl_custo_mao_obra_padrao > 0) and (@pc_markup_mao_obra_padrao > 0)  
   set @vl_venda_mao_obra_padrao = @vl_custo_mao_obra_padrao / @pc_markup_mao_obra_padrao  
  
-- Valores de venda Mão de Obra (Serv. Agregados)  

if isnull(@cd_aplicacao_markup_especifico,0) > 0
begin
   declare @pc_markup_diferenciado float
   select
      @pc_markup_diferenciado = (100 - sum(pc_formacao_markup) ) / 100
   from formacao_markup
   where 
      cd_aplicacao_markup     = @cd_aplicacao_markup and
     (ic_tipo_formacao_markup = 'A' or -- Ambos 
      ic_tipo_formacao_markup = 'M')
   
   set @pc_markup_mao_obra_serv = @pc_markup_diferenciado
end
  
set @vl_venda_mao_obra_serv        = @vl_custo_mao_obra_serv        / @pc_markup_mao_obra_serv  
set @vl_venda_mandrilhadora_refrig = @vl_custo_mandrilhadora_refrig / @pc_markup_mao_obra_serv  
set @vl_venda_mandrilhadora_aloj   = @vl_custo_mandrilhadora_aloj   / @pc_markup_mao_obra_serv  

if (@vl_custo_serv_manual > 0) and (@pc_markup_mao_obra_serv > 0)  
   set @vl_venda_serv_manual = @vl_custo_serv_manual / @pc_markup_mao_obra_serv  
  
if (@ic_conversao_moeda = 'S') and (@dt_moeda_cotacao is null)  
   set @dt_moeda_cotacao = getdate()  
  
-- Busca Valor em outra moeda para Cálculo mais abaixo  
if (@ic_conversao_moeda = 'S') and (isnull(@vl_moeda_cotacao,0) = 0)
begin  
   select @vl_moeda_cotacao = vl_moeda  
   from valor_moeda  
   where cd_moeda = @cd_moeda_cotacao and  
         dt_moeda = @dt_moeda_cotacao  
end  

if (isnull(@qt_hora_mao_obra_serv,0)+isnull(@qt_hora_serv_manual,0)) = 0  
   set @pc_markup_mao_obra_serv = 0  
   
   --  
   --   
   --  
   select  
      a.cd_consulta,  
      a.cd_item_consulta,  
      @cd_moeda_cotacao as cd_moeda,  
      vl_moeda_cotacao =
      case when @cd_moeda_cotacao <> 1 then 
         @vl_moeda_cotacao else null end,
      @dt_moeda_cotacao as dt_cambio_cotacao,  
      @dt_moeda_cotacao as dt_moeda_cotacao,  

      max(a.qt_item_consulta)             as qt_item_consulta,  
      max(p.vl_produto)                   as PrecoListaPadrao,  
      max(a.vl_lista_item_consulta)       as UltimoValorLista,  
  
      ValorOrcadoTmp =  
      case when @ic_orcamento_calculado = 'S' then
        round( isnull(@vl_venda_mat_prima,0)     + isnull(@vl_venda_componente,0)+  
               isnull(@vl_venda_serv_manual,0)   + isnull(@vl_venda_mao_obra_padrao,0)+
               isnull(@vl_venda_mao_obra_serv,0) + isnull(@vl_total_servico_externo,0) ,2)
      else 
         isnull(@vl_venda_componente,0) end, -- Soma somente os componentes : Preço já fechado !
        
      max(a.qt_dia_entrega_consulta)      as qt_dia_entrega_consulta,  
        
      isnull(@qt_pesbru_item_orcamento,0) as 'MPPesoBruto',  
      isnull(@qt_pesliq_item_orcamento,0) as 'MPPesoLiquido',  
      isnull(@vl_custo_mat_prima,0)       as 'MPCusto',  
      isnull(@vl_venda_mat_prima,0)       as 'MPVenda',  
      isnull(@pc_markup_mat_prima,0)      as 'MPCoeficiente',  
      max(isnull(a.ic_considera_mp_orcamento,'S'))   
              as 'ConsideraMP',   
      cast(max(isnull(p.nm_fantasia_produto,sp.sg_serie_produto)) as varchar(15))  
                                          as 'MPPadrao',   
  
      @qt_item_componente                 as 'ComponenteQtde',  
      isnull(@vl_custo_componente,0)      as 'ComponenteCusto',  
      @pc_markup_componente               as 'ComponenteCoeficiente',  
      @vl_venda_componente                as 'ComponenteVenda',  
        
      MargemCusto = -- Soma de todos os Custos        
          isnull(@vl_custo_mat_prima,0)+isnull(@vl_custo_componente,0)+  
         (isnull(@vl_custo_mao_obra_padrao,0)+isnull(@vl_custo_mao_obra_serv,0)+isnull(@vl_custo_serv_manual,0)),  
       
      -- Totais referente Mão-de-Obra Padrão      
      @qt_hora_mao_obra_padrao            as 'MOHoras',  
      @vl_custo_mao_obra_padrao           as 'MOCusto',  
      @pc_markup_mao_obra_padrao          as 'MOCoeficiente',  
      @vl_venda_mao_obra_padrao           as 'MOVenda',  
             
      @vl_venda_PV                        as 'VendaPV',  
      @vl_lista_PV                        as 'ListaPV',  
      @pc_desc_PV                         as 'DescPV',  
  
      -- Mão de obra agregadas  
      isnull(@qt_hora_mao_obra_serv,0)+isnull(@qt_hora_serv_manual,0)    as 'AGHoras',  
      isnull(@vl_custo_mao_obra_serv,0)+isnull(@vl_custo_serv_manual,0)  as 'AGCusto',  
      @pc_markup_mao_obra_serv                                           as 'AGCoeficiente',  
      isnull(@vl_venda_mao_obra_serv,0)+isnull(@vl_venda_serv_manual,0)  as 'AGVenda',  
      
      isnull(@qt_hora_CNC,0)           + isnull(@qt_hora_CNC_fase,0)               as AG_H_Cnc,  
      isnull(@qt_hora_convencional,0)  + isnull(@qt_hora_convencional_fase,0)      as AG_H_Convencional,  
      isnull(@qt_hora_refrigeracao,0)  + isnull(@qt_hora_refrigeracao_fase,0)      as AG_H_Refrigeracao,  
      isnull(@qt_hora_mandrilhadora,0) + isnull(@qt_hora_mandrilhadora_refrig,0) +  
         isnull(@qt_hora_mandrilhadora_aloj,0)                                     as AG_H_Mandrilhadora,  
        
      isnull(@vl_custo_CNC,0)           + isnull(@vl_custo_CNC_fase,0)               as AG_C_Cnc,  
      isnull(@vl_custo_convencional,0)  + isnull(@vl_custo_convencional_fase,0)      as AG_C_Convencional,  
      isnull(@vl_custo_refrigeracao,0)  + isnull(@vl_custo_refrigeracao_fase,0)      as AG_C_Refrigeracao,  
      isnull(@vl_custo_mandrilhadora,0) + isnull(@vl_custo_mandrilhadora_refrig,0) +   
         isnull(@vl_custo_mandrilhadora_aloj,0)                                      as AG_C_Mandrilhadora,  
                    
      0.00                                as 'CustoFabricacao',  
      isnull(@vl_total_servico_externo,0) as 'SEValor',  
      isnull(@qt_item_servico_externo,0)  as 'SEQtde',
      @Exportacao                         as 'Exportacao'
  
   into #TmpCalculoOrcamento  
  
   from   
      Consulta_Itens a  

   left outer join Produto p on  
   -- Se for nulo, deve ser Manifold (está em outra tabela ...)
   isnull(a.cd_produto_padrao_orcam,@cd_produto_padrao) = p.cd_produto  
  
   left outer join Serie_Produto sp on  
   a.cd_serie_produto_padrao = sp.cd_serie_produto  
  
   where  
      a.cd_consulta       = @cd_consulta and  
      a.cd_item_consulta  = @cd_item_consulta  
  
   group by a.cd_consulta,  
            a.cd_item_consulta  
   
   --  
   --  
   --  
   
   select *,  
          ValorOutraMoeda =  
          case when (@Exportacao = 'S') and (@ic_conversao_moeda = 'S') and 
                    (@vl_moeda_cotacao > 0) and (ValorOrcadoTmp > 0) then ValorOrcadoTmp
          else 0 end,  

          ValorOrcado =
          case when (@Exportacao = 'S') and (@ic_conversao_moeda = 'S') and 
                    (@vl_moeda_cotacao > 0) and (ValorOrcadoTmp > 0) then 
              (ValorOrcadoTmp * @vl_moeda_cotacao)
          else 
               ValorOrcadoTmp 
          end,  
          
          PrecoSemServico = ValorOrcadoTmp - AGVenda,  
          
          -- Total de mão-de-obra  
          MOHoras + AGHoras    as 'TOTHorasMO',  
          MOCusto + AGCusto    as 'TOTCustoMO',  
          MOVenda + AGVenda    as 'TOTVendaMO',  
         
          MargemBruta = --Valor orçado * Markup sem lucro  
          ValorOrcadoTmp * @pc_markup_sem_lucro,  
            
          MargemLiquida = -- Margem Bruta - Custo  
         (round(ValorOrcadoTmp,2) * @pc_markup_sem_lucro) - round(MargemCusto,2),  
            
          MargemPerc = -- Margem Liquida / Valor Orçado * 100  
         ((ValorOrcadoTmp * @pc_markup_sem_lucro) - MargemCusto) / ValorOrcadoTmp * 100,  
            
          MargemTxHora = -- Valor Orçado * Markup sem lucro - (CustoMP+CustoCMP) / Total Horas MO  
        ((ValorOrcadoTmp * @pc_markup_sem_lucro) - (MPCusto + ComponenteCusto)) / (MOHoras+AGHoras),  
  
          VlLucroZero = -- Custo / Markup sem lucro + Serv. Ext.  
          MargemCusto / @pc_markup_sem_lucro + SEValor,   
           
          @pc_markup_sem_lucro as 'PcTaxaHora'  
  
   from #TmpCalculoOrcamento  
     
