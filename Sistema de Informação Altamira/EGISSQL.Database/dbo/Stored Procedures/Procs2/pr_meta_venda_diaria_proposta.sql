
CREATE   PROCEDURE pr_meta_venda_diaria_proposta
--pr_meta_venda_diaria_proposta
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EgisSql
--Objetivo: Calcular as Metas de Vendas Diárias para as Propostas.
-- ( Falta Definição correta.)
--Data: 30/06/2003
--Atualizado: 
---------------------------------------------------
@dt_base as Datetime,
@cd_vendedor as integer

AS

declare @qt_dia_imediato as integer

set @qt_dia_imediato = ( select qt_dia_imediato_empresa 
			 from Parametro_Comercial
			 where cd_empresa = dbo.fn_empresa())

-------------------------------------------------------------
if @cd_vendedor = 0 -- Meta de Propostas gerais.
-------------------------------------------------------------
begin

select 
  mv.cd_empresa,
  max(mv.vl_venda_imediato_meta) as 'Meta_Imediato',
  max(mv.vl_venda_mes_meta) as 'Meta_Mes', 
  sum(IsNull(ci.qt_item_consulta,0) * 
      IsNull(ci.vl_unitario_item_consulta,0)) as 'Propostas', 
  sum(IsNull(cii.qt_item_consulta,0) *
      IsNull(cii.vl_unitario_item_consulta,0)) as 'PropostasImediatas'
into 
  #MetaPropostas1
from
  Meta_Venda mv,
  Consulta c left outer join
  Consulta_Itens ci on ci.cd_consulta = c.cd_consulta left outer join
  Consulta_Itens cii on cii.cd_consulta = c.cd_consulta and 
                            (cii.dt_entrega_consulta - c.dt_consulta) <=
			    @qt_dia_imediato
where
  mv.cd_empresa = dbo.fn_empresa() and
  isnull(c.ic_consignacao_consulta,'N') = 'N'               and
 (ci.qt_item_consulta * ci.vl_unitario_item_consulta) > 0 and
 (cii.qt_item_consulta * cii.vl_unitario_item_consulta) > 0 and
  month(c.dt_consulta) = month(@dt_base)               and
  year(c.dt_consulta) = year(@dt_base)               and
 (ci.dt_perda_consulta_itens is null  )                      and
 (cii.dt_perda_consulta_itens is null  )                     and
  c.dt_consulta <= @dt_base

group by 
  mv.cd_empresa
--------------------------------------------------------------------------------------
-- Mostra a Tabela com dados do Mês, Porcentagem, Dias Transcorridos e dias Úteis.
--------------------------------------------------------------------------------------
  declare @qt_dia_util as integer
  declare @qt_dia_transc as integer

  -- Dias úteis é do mês todo.
  set @qt_dia_util = ( select count(dt_agenda) from Agenda 
                       where month(dt_agenda) = month(@dt_base) and
                       year(dt_agenda) = year(@dt_base) and
                       ic_util = 'S')

  set @qt_dia_transc = ( select count(dt_agenda) from Agenda 
                       where month(dt_agenda) = month(@dt_base) and
                       year(dt_agenda) = year(@dt_base) and
		       dt_agenda <= @dt_base and
                       ic_util = 'S')

------------------------------------------------
-- Calculando Projeção e Necessidade
------------------------------------------------

select 
  cd_empresa,
  Meta_Imediato,
  Meta_Mes, 
  @qt_dia_util as 'DiaUtil',
  @qt_dia_transc as 'DiaTransc',
  cast(Propostas as decimal(25,2)) as Propostas, 
  cast(PropostasImediatas as decimal(25,2)) as PropostasImediatas,
  (Propostas*100)/Meta_Mes as 'perc_proposta',
  (PropostasImediatas*100)/Meta_Imediato as 'perc_proposta_imediata',
  ((Propostas/@qt_dia_transc) * (@qt_dia_util - @qt_dia_transc)) as 'Projecao',
  ((PropostasImediatas/@qt_dia_transc) * (@qt_dia_util - @qt_dia_transc)) as 'ProjecaoImediata',
  case when Meta_Mes < Propostas then 0 
  else ((Meta_Mes - Propostas) / (@qt_dia_util - @qt_dia_transc)) end as 'Necessidade',
  case when Meta_Imediato < PropostasImediatas then 0 
  else ((Meta_Imediato - PropostasImediatas) / (@qt_dia_util - @qt_dia_transc)) end as 'NecessidadeImediata'

into
  #MetaPropostasTotal1
from
  #MetaPropostas1
order by 1 desc

-----------------------------------------------------------------
-- Calculando valor abaixo da Meta e fazendo seleção final.
-----------------------------------------------------------------

select
  *,
  case when (Meta_Mes - Projecao) < 0 then 0 
  else (Meta_Mes - Projecao) end as 'Abaixo',
  case when (Meta_Imediato - ProjecaoImediata) < 0 then 0 
  else (Meta_Imediato - ProjecaoImediata) end as 'AbaixoImediato'
from
  #MetaPropostasTotal1
  
end

-----------------------------------------------------------
else -- Seleciona as Metas pelo vendedor selecionado.
-----------------------------------------------------------
return    

