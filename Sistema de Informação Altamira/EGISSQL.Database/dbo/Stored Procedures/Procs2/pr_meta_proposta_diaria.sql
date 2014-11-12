
CREATE   PROCEDURE pr_meta_proposta_diaria
-------------------------------------------------------------------------------
--pr_meta_proposta_diaria
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                	   2004
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Daniel C. Neto.
--Banco de Dados          : EgisSql
--Objetivo                : Calcular as Metas de Vendas Diárias para as Propostas.
--                          (  Falta Definição correta.)
--Data                    : 30/06/2003
--Atualizado              : 03/07/2003 - Acerto na soma da Proposta com Proposta imediata.
--                          - Daniel C. Neto.
--                        : 17/11/2003 - Dudu - Acerto nas fórmulas
--                        : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                        : 30.05.2006 - Tipo de Mercado - Carlos Fernandes
--                        : 05.06.2006 - Ajuste da Fórmula da Projeção - Carlos Fernandes
------------------------------------------------------------------------------------------

@dt_base         Datetime,
@cd_vendedor     int = 0,
@cd_tipo_mercado int = 0

AS

set @cd_vendedor = isnull(@cd_vendedor,0)

declare @qt_dia_imediato as integer

-- qtde. de dias para ser considerado "Imediato"
set @qt_dia_imediato = ( select qt_dia_imediato_empresa 
			 from Parametro_Comercial
			 where cd_empresa = dbo.fn_empresa())

-- Propostas não imediatas
select 
  mv.cd_empresa,
  max(mv.vl_proposta_imediato_meta)  as 'Meta_Imediato',
  max(mv.vl_proposta_mes_meta)       as 'Meta_Mes', 
  sum(IsNull(ci.qt_item_consulta,0) *  IsNull(ci.vl_unitario_item_consulta,0)) as 'Propostas',
  cast(0 as Float)                   as PropostasImediatas,

  max(mv.qt_proposta_imediato_meta)  as 'Qt_Meta_Imediato',
  max(mv.qt_proposta_mes_meta)       as 'Qt_Meta_Mes', 
  sum(IsNull(ci.qt_item_consulta,0)) as 'Qt_Propostas',
  cast(0 as Float)                   as Qt_PropostasImediatas
into 
  #MetaPropostasInicial
from
  Meta_Venda mv,
  Consulta c inner join
  Consulta_Itens ci on ci.cd_consulta = c.cd_consulta
where
  mv.cd_empresa = dbo.fn_empresa() and
  isnull(c.ic_consignacao_consulta,'N') = 'N' and
  month(c.dt_consulta) = month(@dt_base) and
  year(c.dt_consulta) = year(@dt_base) and
  c.dt_consulta <= @dt_base and
  @dt_base between mv.dt_inicial_meta_venda and mv.dt_final_meta_venda and
  IsNull(mv.ic_padrao_meta_venda,'N') = 'S' and
  (ci.dt_perda_consulta_itens is null or ci.dt_perda_consulta_itens > @dt_base ) and 
  (ci.dt_entrega_consulta - c.dt_consulta) > @qt_dia_imediato and 
  (ci.qt_item_consulta * ci.vl_unitario_item_consulta) > 0
  and
  c.cd_vendedor = ( case @cd_vendedor when 0
                      then c.cd_vendedor
                      else @cd_vendedor
                    end )

  --Tipo de Mercado
   and mv.cd_tipo_mercado = case when @cd_tipo_mercado = 0 then mv.cd_tipo_mercado else @cd_tipo_mercado end

group by 
  mv.cd_empresa, mv.dt_inicial_meta_venda, mv.dt_final_meta_venda

-- Propostas Imediatas
select 
  mv.cd_empresa,
  max(mv.vl_venda_imediato_meta)      as 'Meta_Imediato',
  max(mv.vl_venda_mes_meta)           as 'Meta_Mes', 
  cast(0 as Float)                    as 'Propostas', 
  sum(IsNull(cii.qt_item_consulta,0) * IsNull(cii.vl_unitario_item_consulta,0)) as 'PropostasImediatas',

  max(mv.qt_venda_imediato_meta)      as 'Qt_Meta_Imediato',
  max(mv.qt_venda_mes_meta)           as 'Qt_Meta_Mes', 
  cast(0 as Float)                    as 'Qt_Propostas', 
  sum(IsNull(cii.qt_item_consulta,0)) as 'Qt_PropostasImediatas'
into 
  #MetaPropostasImediata
from
  Meta_Venda mv,
  Consulta c inner join
  Consulta_Itens cii on cii.cd_consulta = c.cd_consulta 
where
  mv.cd_empresa = dbo.fn_empresa() and
  isnull(c.ic_consignacao_consulta,'N') = 'N'               and
  month(c.dt_consulta) = month(@dt_base)               and
  year(c.dt_consulta) = year(@dt_base)               and
  c.dt_consulta <= @dt_base and
  @dt_base between mv.dt_inicial_meta_venda and mv.dt_final_meta_venda and
  IsNull(mv.ic_padrao_meta_venda,'N') = 'S' and 
  (cii.dt_entrega_consulta - c.dt_consulta) <= @qt_dia_imediato and
  (cii.qt_item_consulta * cii.vl_unitario_item_consulta) > 0 and
  (cii.dt_perda_consulta_itens is null or cii.dt_perda_consulta_itens > @dt_base)
  and
  c.cd_vendedor = ( case @cd_vendedor when 0
                      then c.cd_vendedor
                      else @cd_vendedor
                    end )
  --Tipo de Mercado
   and mv.cd_tipo_mercado = case when @cd_tipo_mercado = 0 then mv.cd_tipo_mercado else @cd_tipo_mercado end

group by 
  mv.cd_empresa, mv.dt_inicial_meta_venda, mv.dt_final_meta_venda

-- Juntar os dois tipos de Propostas
select 
  cd_empresa,
  Meta_Imediato,
  Meta_Mes, 
  Qt_Meta_Imediato,
  Qt_Meta_Mes, 
  SUM( IsNull(Propostas,0) + IsNull(PropostasImediatas,0) ) as 'Propostas',
  SUM( PropostasImediatas ) as 'PropostasImediatas',
  SUM( IsNull(Qt_Propostas,0) + IsNull(Qt_PropostasImediatas,0) ) as 'Qt_Propostas',
  SUM( Qt_PropostasImediatas ) as 'Qt_PropostasImediatas'
into #MetaPropostas1
from
  ( select * from #MetaPropostasInicial union all select * from #MetaPropostasImediata ) p
group by
  cd_empresa,
  Meta_Imediato,
  Meta_Mes,
  Qt_Meta_Imediato,
  Qt_Meta_Mes

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

--print(@qt_dia_util)
--print(@qt_dia_transc)

------------------------------------------------
-- Calculando Projeção, Necessidade e Posição
------------------------------------------------

select cd_empresa, 
       max(Meta_Imediato)         as Meta_Imediato,
       max(Meta_Mes)              as Meta_Mes,
       max(Qt_Meta_Imediato)      as Qt_Meta_Imediato,
       max(Qt_Meta_Mes)           as Qt_Meta_Mes,
       @qt_dia_util               as DiaUtil,
       @qt_dia_transc             as DiaTransc,
       sum(Propostas)             as Propostas,
       sum(PropostasImediatas)    as PropostasImediatas,
       sum(Qt_Propostas)          as Qt_Propostas,
       sum(Qt_PropostasImediatas) as Qt_PropostasImediatas
into 
  #MetaPropostas
from 
  #MetaPropostas1
group by
  cd_empresa

select 
  cd_empresa,
  Meta_Imediato,
  Meta_Mes, 
  Qt_Meta_Imediato,
  Qt_Meta_Mes, 
  @qt_dia_util                                                                      as 'DiaUtil',
  @qt_dia_transc                                                                    as 'DiaTransc',

  -- Valores
  cast(Propostas as decimal(25,2))                                                  as Propostas, 
  (Propostas*100)/Meta_Mes                                                          as 'perc_proposta',
  (Propostas/@qt_dia_transc)                                                        as 'MediaDiaria' ,
  ( @qt_dia_util * (Propostas/@qt_dia_transc) )                                     as 'Projecao',

  case when Meta_Mes < Propostas then 0 
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Mes - Propostas)
  else ((Meta_Mes - Propostas) / (@qt_dia_util - @qt_dia_transc)) end               as 'Necessidade',

  ((Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Propostas                          as 'Abaixo',

  cast(PropostasImediatas as decimal(25,2))                                         as PropostasImediatas,
  (PropostasImediatas*100)/Meta_Imediato                                            as 'perc_proposta_imediata',
  (PropostasImediatas/@qt_dia_transc)                                               as 'MediaDiariaImediata' ,
  (@qt_dia_util * (PropostasImediatas/@qt_dia_transc))                              as 'ProjecaoImediata',

  case when Meta_Imediato < PropostasImediatas then 0 
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Imediato - PropostasImediatas)
  else ((Meta_Imediato - PropostasImediatas) / (@qt_dia_util - @qt_dia_transc)) end as 'NecessidadeImediata',

  ((Meta_Imediato / @qt_dia_util) * @qt_dia_transc) - PropostasImediatas            as 'AbaixoImediato',

  -- Quantidades
  cast(Qt_Propostas as decimal(25,2))                                               as Qt_Propostas, 
  (Qt_Propostas*100)/Qt_Meta_Mes                                                    as 'Qt_perc_proposta',
  (Qt_Propostas/@qt_dia_transc)                                                     as 'Qt_MediaDiaria' ,
  ( @qt_dia_util * (Qt_Propostas/@qt_dia_transc) )                                  as 'Qt_Projecao',

  case when Qt_Meta_Mes < Qt_Propostas then 0 
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Qt_Meta_Mes - Qt_Propostas)
  else ((Qt_Meta_Mes - Qt_Propostas) / (@qt_dia_util - @qt_dia_transc)) end         as 'Qt_Necessidade',

  ((Qt_Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Qt_Propostas                    as 'Qt_Abaixo',

  cast(Qt_PropostasImediatas as decimal(25,2))                                      as Qt_PropostasImediatas,
  (Qt_PropostasImediatas*100)/Qt_Meta_Imediato                                      as 'Qt_perc_proposta_imediata',
  (Qt_PropostasImediatas/@qt_dia_transc)                                            as 'Qt_MediaDiariaImediata',
  (@qt_dia_util * (Qt_PropostasImediatas/@qt_dia_transc))                           as 'Qt_ProjecaoImediata',

  case when Qt_Meta_Imediato < Qt_PropostasImediatas then 0 
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Qt_Meta_Imediato - Qt_PropostasImediatas)
  else ((Qt_Meta_Imediato - Qt_PropostasImediatas) / (@qt_dia_util - @qt_dia_transc)) end as 'Qt_NecessidadeImediata',

  ((Qt_Meta_Imediato / @qt_dia_util) * @qt_dia_transc) - Qt_PropostasImediatas      as 'Qt_AbaixoImediato'

from
  #MetaPropostas
order by 1 desc

