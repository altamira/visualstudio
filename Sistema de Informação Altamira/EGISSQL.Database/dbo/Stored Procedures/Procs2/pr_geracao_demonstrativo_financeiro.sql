
-------------------------------------------------------------------------------
--pr_geracao_demonstrativo_financeiro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Geração do Demonstrativo Financeiro
-- 
--Data             : 02/03/2005
--Atualizado       : 03/03/2005 - Colocado a Somatória dos Valores do Plano_Financeiro_Movimento - Carlos Fernandes
--                 : 16.10.2005 - Revisão Geral - Carlos Fernandes
--                 : 17.10.2005 - Traço/Negrito 
--                                Tabela Temporária para busca dos Centros de Custos / Pai e Filho - Carlos Fernandes
--                 : 08.03.2006 - Verificação Geral do Procedimento - Carlos Fernandes
--                 : 03.04.2006 - Mostrar ou não contas com lançamentos zerados - Danilo  Campoi  
---------------------------------------------------------------------------------------------------------------------
create procedure pr_geracao_demonstrativo_financeiro
@cd_dr_tipo               int,
@ic_mostra_conta_zerada   varchar,
@dt_inicial               datetime,
@dt_final                 datetime,
@cd_centro_custo          int = 0,
@cd_tipo_lancamento_fluxo int = 2          --1 : Previsto      /      --2 : Realizado
                                      

as

-------------------------------------------------------------------------------------------------------------------
--Tabela Auxiliar com os dados do centro de custo
-------------------------------------------------------------------------------------------------------------------
--select * from centro_custo

--if @cd_centro_custo > 0 
--begin

  Create table #CentroCusto 
  ( cd_centro_custo int )

  --Centro de Custo Informado
  insert into #CentroCusto
  select 
    cd_centro_custo
   from 
     Centro_Custo
   where
     cd_centro_custo = @cd_centro_custo

  --Centro de Custo Pai
  insert into #CentroCusto
  select 
    cd_centro_custo
   from 
     Centro_Custo
   where
      cd_centro_custo_pai = @cd_centro_custo

   --select * from #CentroCusto
   --select * from Plano_Financeiro_Movimento


--  if exists ( select top 1 cd_centro_custo from #CentroCusto )
--  begin

    select 
      pfm.*
    into 
      #MovCC
    from 
      Plano_Financeiro_Movimento pfm, #CentroCusto cc
     where
       pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
       pfm.cd_centro_custo           = cc.cd_centro_custo              and
       pfm.cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo 

    --select * from #MovCC

--   end

--end
--else
--begin
-------------------------------------------------------------------------------------------------------------------
--Montagem da Tabela Auxiliar
-------------------------------------------------------------------------------------------------------------------

  select 
    pfm.*
  into 
    #MovFin
  from 
    Plano_Financeiro_Movimento pfm
   where
     isnull(pfm.cd_centro_custo,0) = case when @cd_centro_custo=0 then isnull(pfm.cd_centro_custo,0) else @cd_centro_custo end and
     pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
     pfm.cd_movimento not in ( select cd_movimento from #MovCC )     and
     pfm.cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo 


--   select * from #MovFin

--end

SELECT
  * 
into #Movimento
FROM #MovFin
UNION ALL
(   SELECT * FROM #MovCC )

--select * from #Movimento

-------------------------------------------------------------------------------------------------------------------
--Grupo
-------------------------------------------------------------------------------------------------------------------
--select * from dr_grupo

select 
  g.cd_mascara_dr_grupo            as CodigoGrupo,
  cast('' as varchar(20))          as CodigoItem,
  g.qt_ordem_dr_grupo              as Ordem,
  0                                as Item,
  0                                as Plano,
  g.nm_dr_grupo                    as Grupo,
  'S'                              as Apresenta,  
  cast( 0 as float )               as Janeiro,
  cast( 0 as float )               as Fevereiro,
  cast( 0 as float )               as Marco,
  cast( 0 as float )               as Abril,
  cast( 0 as float )               as Maio,
  cast( 0 as float )               as Junho,
  cast( 0 as float )               as Julho,
  cast( 0 as float )               as Agosto,
  cast( 0 as float )               as Setembro,
  cast( 0 as float )               as Outubro,
  cast( 0 as float )               as Novembro,
  cast( 0 as float )               as Dezembro,
  isnull(g.cd_dr_grupo,0)          as cd_dr_grupo,
  0                                as cd_item_dr_grupo,
  'X'                              as Operacao,
  g.ic_negrito_dr_grupo            as Negrito,
  g.ic_traco_dr_grupo              as Traco,                   
  0                                as cd_grupo_operacao,
  isnull(g.ic_titulo_dr_grupo,'N') as Titulo

into
  #Demonstrativo_Grupo
from
  dr_grupo g
where
  g.cd_dr_tipo = @cd_dr_tipo and 
  isnull(g.ic_ativo_dr_grupo,'N')='S'
order by
  g.qt_ordem_dr_grupo

--select * from #Demonstrativo_Grupo


-------------------------------------------------------------------------------------------------------------------
--Composição do Grupo
-------------------------------------------------------------------------------------------------------------------
--select * from dr_grupo_composicao

select 
  g.cd_mascara_dr_grupo               as CodigoGrupo,
  gc.cd_mascara_item_dr_grupo         as CodigoItem,
  g.qt_ordem_dr_grupo                 as Ordem,
  gc.qt_ordem_item_dr_grupo           as Item,
  0                                   as Plano,
  gc.nm_item_dr_grupo                 as Grupo,
  isnull(ic_mostra_item_dr_grupo,'N') as Apresenta,  
  cast( 0 as float )                  as Janeiro,
  cast( 0 as float )                  as Fevereiro,
  cast( 0 as float )                  as Marco,
  cast( 0 as float )                  as Abril,
  cast( 0 as float )                  as Maio,
  cast( 0 as float )                  as Junho,
  cast( 0 as float )                  as Julho,
  cast( 0 as float )                  as Agosto,
  cast( 0 as float )                  as Setembro,
  cast( 0 as float )                  as Outubro,
  cast( 0 as float )                  as Novembro,
  cast( 0 as float )                  as Dezembro,
  isnull(g.cd_dr_grupo,0)             as cd_dr_grupo,
  isnull(gc.cd_item_dr_grupo,0)       as cd_item_dr_grupo,
  'X'                                 as Operacao,
  gc.ic_negrito_item_dr_grupo         as Negrito,
  gc.ic_traco_item_dr_grupo           as Traco,                              
  0                                   as cd_grupo_operacao,
  'N'                                 as Titulo

into
  #Demonstrativo_Composicao
from
  dr_grupo g
  left outer join dr_grupo_composicao gc on gc.cd_dr_grupo         = g.cd_dr_grupo

where
  g.cd_dr_tipo = @cd_dr_tipo and
  isnull(gc.ic_mostra_item_dr_grupo,'N') = 'S'
order by
  g.qt_ordem_dr_grupo

--select * from #Demonstrativo_Composicao order by codigoGrupo,CodigoItem,Item


-------------------------------------------------------------------------------------------------------------------
--Plano Financeiro
-------------------------------------------------------------------------------------------------------------------
--select * from dr_plano_financeiro

select 
  g.cd_mascara_dr_grupo                          as CodigoGrupo,
  gc.cd_mascara_item_dr_grupo                    as CodigoItem,
  g.qt_ordem_dr_grupo                            as Ordem,
  gc.qt_ordem_item_dr_grupo                      as Item,
  pf.cd_plano_financeiro                         as Plano,
  pf.nm_conta_plano_financeiro                   as Grupo,
  isnull(ic_dr_plano_financeiro,'N')             as Apresenta,
  
  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro          and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 1 ),0) as Janeiro,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 2 ),0) as Fevereiro,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 3 ),0) as Marco,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 4 ),0) as Abril,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 5 ),0) as Maio,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 6 ),0) as Junho,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 7 ),0) as Julho,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 8 ),0) as Agosto,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 9 ),0) as Setembro,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
    cd_plano_financeiro       = dp.cd_plano_financeiro and 
    dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
    cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
    month(dt_movto_plano_financeiro) = 10 ),0) as Outubro,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     month(dt_movto_plano_financeiro) = 11 ),0) as Novembro,

  isnull(( select sum( isnull(vl_plano_financeiro,0) ) 
  from #Movimento 
  where
     cd_plano_financeiro       = dp.cd_plano_financeiro and 
     cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo       and
     dt_movto_plano_financeiro between @dt_inicial and @dt_final and 
     month(dt_movto_plano_financeiro) = 12 ),0) as Dezembro,

  isnull(g.cd_dr_grupo,0)                          as cd_dr_grupo,
  isnull(gc.cd_item_dr_grupo,0)                    as cd_item_dr_grupo,
  case when pf.cd_tipo_operacao = 1 
       then 'S' else 'E' end                       as 'Operacao',
  'N'                                              as Negrito,
  'N'                                              as Traco,
   0                                               as cd_grupo_operacao,
  'N'                                              as Titulo
        
 
--select * from plano_financeiro
--select * from dr_plano_financeiro

into
  #Demonstrativo_Plano
from
  dr_grupo g
  left outer join dr_grupo_composicao        gc  on gc.cd_dr_grupo         = g.cd_dr_grupo
  left outer join dr_plano_financeiro        dp  on dp.cd_dr_grupo         = g.cd_dr_grupo and
                                                    dp.cd_item_dr_grupo    = gc.cd_item_dr_grupo 
  left outer join plano_financeiro           pf  on pf.cd_plano_financeiro = dp.cd_plano_financeiro

where
  g.cd_dr_tipo = @cd_dr_tipo 
order by
  g.qt_ordem_dr_grupo

--select * from #Demonstrativo_plano order by codigoGrupo,CodigoItem,Item


SELECT * 
into #Demo
FROM #Demonstrativo_grupo
UNION ALL
(   SELECT * FROM #Demonstrativo_composicao
   UNION
   SELECT * FROM #Demonstrativo_plano
)

--select * from #Demo  ok


-------------------------------------------------------------------------------------------------------------------
--Totalizaçao das Contas de Composição e Grupo
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------  
--Totalizaçao das Contas de Composição e Grupo  
-------------------------------------------------------------------------------------------------------------------  
  
--Montagem da Tabela para Somatória  
  
select  
 *   
into #AuxSomaPlano  
from   
 dr_plano_financeiro  
  
  
--select * from #AuxSomaPlano  
    
declare @cd_grupo           int  
declare @cd_item_grupo      int   
declare @cd_plano           int  
declare @cd_grupo_operacao  int   
declare @ic_tipo_operacao   char(1)  
declare @vl_total_janeiro   float  
declare @vl_total_fevereiro float  
declare @vl_total_marco     float  
declare @vl_total_abril     float  
declare @vl_total_maio      float  
declare @vl_total_junho     float  
declare @vl_total_julho     float  
declare @vl_total_agosto    float  
declare @vl_total_setembro  float  
declare @vl_total_outubro   float  
declare @vl_total_novembro  float  
declare @vl_total_dezembro  float  
declare @vl_total           float  
  
set @vl_total_janeiro   = 0  
set @vl_total_fevereiro = 0  
set @vl_total_marco     = 0  
set @vl_total_abril     = 0  
set @vl_total_maio      = 0  
set @vl_total_junho     = 0  
set @vl_total_julho     = 0  
set @vl_total_agosto    = 0  
set @vl_total_setembro  = 0  
set @vl_total_outubro   = 0  
set @vl_total_novembro  = 0  
set @vl_total_dezembro  = 0  
  
--Cálculo dos grupos/Composição  
  
while exists ( select top 1 cd_dr_grupo from #AuxSomaPlano )  
begin  
  
  select top 1  
    @cd_grupo           = isnull(cd_dr_grupo,0),  
    @cd_item_grupo      = isnull(cd_item_dr_grupo,0),  
    @cd_plano           = isnull(cd_plano_financeiro,0)  
  from  
    #AuxSomaPlano  
  
  --select @cd_grupo,@cd_item_grupo,@cd_plano  
  
  --Busca o valor do Plano Financeiro na Soma  
  
  --Grupo  
  
  select  
    @vl_total_janeiro   = isnull(Janeiro  ,0),  
    @vl_total_fevereiro = isnull(Fevereiro,0),  
    @vl_total_marco     = isnull(Marco    ,0),  
    @vl_total_abril     = isnull(Abril    ,0),  
    @vl_total_maio      = isnull(Maio     ,0),  
    @vl_total_junho     = isnull(Junho    ,0),  
    @vl_total_julho     = isnull(Julho    ,0),  
    @vl_total_agosto    = isnull(Agosto   ,0),  
    @vl_total_setembro  = isnull(Setembro ,0),  
    @vl_total_outubro   = isnull(Outubro  ,0),  
    @vl_total_novembro  = isnull(Novembro ,0),   
    @vl_total_dezembro  = isnull(Dezembro ,0)   
 from  
    #Demo  
 where  
    isnull(Plano,0)>0                        and    
    @cd_grupo           = cd_dr_grupo        and  
    @cd_plano           = Plano  
  
  --Composição   
  
  select  
    @vl_total_janeiro   = isnull(Janeiro  ,0),  
    @vl_total_fevereiro = isnull(Fevereiro,0),  
    @vl_total_marco     = isnull(Marco    ,0),  
    @vl_total_abril     = isnull(Abril    ,0),  
    @vl_total_maio      = isnull(Maio     ,0),  
    @vl_total_junho     = isnull(Junho    ,0),  
    @vl_total_julho     = isnull(Julho    ,0),  
    @vl_total_agosto    = isnull(Agosto   ,0),  
    @vl_total_setembro  = isnull(Setembro ,0),  
    @vl_total_outubro   = isnull(Outubro  ,0),  
    @vl_total_novembro  = isnull(Novembro ,0),   
    @vl_total_dezembro  = isnull(Dezembro ,0)   
 from  
    #Demo  
 where  
    isnull(Plano,0)>0                        and    
    @cd_grupo  = cd_dr_grupo        and  
    @cd_item_grupo      = cd_item_dr_grupo   and  
    @cd_plano           = Plano  
  
  --Atualiza os Valores Somados  
    
  update  
    #demo  
  set  
    Janeiro   = Janeiro   + @vl_total_janeiro,  
    Fevereiro = Fevereiro + @vl_total_fevereiro,  
    Marco     = Marco     + @vl_total_marco,  
    Abril     = Abril     + @vl_total_abril,  
    Maio      = Maio      + @vl_total_maio,  
    Junho     = Junho     + @vl_total_junho,  
    Julho     = Julho     + @vl_total_julho,  
    Agosto    = Agosto    + @vl_total_agosto,  
    Setembro  = Setembro  + @vl_total_setembro,  
    Outubro   = Outubro   + @vl_total_outubro,  
    Novembro  = Novembro  + @vl_total_novembro,  
    Dezembro  = Dezembro  + @vl_total_dezembro  
  where   
    @cd_grupo       = cd_dr_grupo      and   
    @cd_item_grupo  = cd_item_dr_grupo and  
    isnull(plano,0) = 0  
  
  --Deleta o Registro da tabela Auxiliar  
  
  delete from #AuxSomaPlano   
  where   
     @cd_grupo      = isnull(cd_dr_grupo,0)      and   
     @cd_item_grupo = isnull(cd_item_dr_grupo,0) and   
     @cd_plano      = isnull(cd_plano_financeiro,0)  
  
end  
  
--select * from #Demo  
  
--select * from dr_plano_financeiro  

set @vl_total_janeiro   = 0
set @vl_total_fevereiro = 0
set @vl_total_marco     = 0
set @vl_total_abril     = 0
set @vl_total_maio      = 0
set @vl_total_junho     = 0
set @vl_total_julho     = 0
set @vl_total_agosto    = 0
set @vl_total_setembro  = 0
set @vl_total_outubro   = 0
set @vl_total_novembro  = 0
set @vl_total_dezembro  = 0

-------------------------------------------------------------------------------------------------------------------
--Montagem das Contas de Operação com Grupo e Composição
-------------------------------------------------------------------------------------------------------------------

--Montagem da Tabela de Operação
--select * from dr_grupo_operacao_item

select
  *
into #AuxOperacao
from
  dr_grupo_operacao_item 

-- select cd_dr_grupo,cd_dr_grupo_operacao,cd_dr_grupo_calculo,cd_item_dr_grupo,cd_item_dr_calculo
-- from
--   dr_grupo_operacao_item 

  --Valores Mensais  
  
  set @vl_total_janeiro   = 0  
  set @vl_total_fevereiro = 0  
  set @vl_total_marco     = 0  
  set @vl_total_abril     = 0  
  set @vl_total_maio      = 0  
  set @vl_total_junho     = 0  
  set @vl_total_julho     = 0  
  set @vl_total_agosto    = 0  
  set @vl_total_setembro  = 0  
  set @vl_total_outubro   = 0  
  set @vl_total_novembro  = 0  
  set @vl_total_dezembro  = 0  

--Cálculo dos grupos/Composição
--Montagem conforme a Operação de cada Grupo

--select * from #AuxOperacao

-- select cd_dr_grupo,cd_dr_grupo_operacao,cd_dr_grupo_calculo,cd_item_dr_grupo,cd_item_dr_calculo
-- from
-- #AuxOperacao

--select * from #Demo order by CodigoGrupo, CodigoItem, Ordem, Item, Plano

declare @cd_grupo_calculo int
declare @cd_item_calculo  int

while exists ( select top 1 cd_dr_grupo from #AuxOperacao )
begin

  select top 1
    @cd_grupo           = isnull(cd_dr_grupo,0),           --Grupo que será Atualizado
    @cd_grupo_operacao  = isnull(cd_dr_grupo_operacao,0),  --Grupo com      o Valor para Operação Soma
    @cd_grupo_calculo   = isnull(cd_dr_grupo_calculo,0),   --Grupo com      o Valor para Cálculo p/Operação  
    @cd_item_grupo      = isnull(cd_item_dr_grupo,0),      --Composição com o Valor para Operação Soma/OPeração
    @cd_item_calculo    = isnull(cd_item_dr_calculo,0),    --Composição com o Valor para Cálculo p/Operação
    @ic_tipo_operacao   = ic_tipo_operacao                 --Operação
  from
    #AuxOperacao
  order by
    cd_dr_grupo,
    cd_dr_grupo_operacao,
    cd_item_dr_grupo
 
  if @cd_item_grupo = 0
  begin
    --Valores Mensais  
    set @vl_total_janeiro   = 0  
    set @vl_total_fevereiro = 0  
    set @vl_total_marco     = 0  
    set @vl_total_abril     = 0  
    set @vl_total_maio      = 0  
    set @vl_total_junho     = 0  
    set @vl_total_julho     = 0  
    set @vl_total_agosto    = 0  
    set @vl_total_setembro  = 0  
    set @vl_total_outubro   = 0  
    set @vl_total_novembro  = 0  
    set @vl_total_dezembro  = 0  
  end

  --Grupo em Operação sem Plano Financeiro
  
  select  
    @vl_total_janeiro   = @vl_total_janeiro   + (isnull(d.Janeiro  ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_fevereiro = @vl_total_fevereiro + (isnull(d.Fevereiro,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_marco     = @vl_total_marco     + (isnull(d.Marco    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_abril     = @vl_total_abril     + (isnull(d.Abril    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_maio      = @vl_total_maio      + (isnull(d.Maio     ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_junho     = @vl_total_junho     + (isnull(d.Junho    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_julho     = @vl_total_julho     + (isnull(d.Julho    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_agosto    = @vl_total_agosto    + (isnull(d.Agosto   ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_setembro  = @vl_total_setembro  + (isnull(d.Setembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_outubro   = @vl_total_outubro   + (isnull(d.Outubro  ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_novembro  = @vl_total_novembro  + (isnull(d.Novembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),   
    @vl_total_dezembro  = @vl_total_dezembro  + (isnull(d.Dezembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end)   
 from  
    #Demo d  
 where  
    @cd_grupo_operacao  = d.cd_dr_grupo        and  
    @cd_item_grupo      = d.cd_item_dr_grupo   and  
    isnull(d.plano,0)   = 0                    and  
    d.grupo is not null                        and
    @cd_grupo_calculo   = 0

  --Grupo em Operação com Plano Financeiro
  
  select  
    @vl_total_janeiro   = @vl_total_janeiro   + (isnull(d.Janeiro  ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_fevereiro = @vl_total_fevereiro + (isnull(d.Fevereiro,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_marco     = @vl_total_marco     + (isnull(d.Marco    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_abril     = @vl_total_abril     + (isnull(d.Abril    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_maio      = @vl_total_maio      + (isnull(d.Maio     ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_junho     = @vl_total_junho     + (isnull(d.Junho    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_julho     = @vl_total_julho     + (isnull(d.Julho    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_agosto    = @vl_total_agosto    + (isnull(d.Agosto   ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_setembro  = @vl_total_setembro  + (isnull(d.Setembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_outubro   = @vl_total_outubro   + (isnull(d.Outubro  ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_novembro  = @vl_total_novembro  + (isnull(d.Novembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),   
    @vl_total_dezembro  = @vl_total_dezembro  + (isnull(d.Dezembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end)   
 from  
    #Demo d  
 where  
    @cd_grupo_operacao  = d.cd_dr_grupo        and  
    @cd_item_grupo      = 0                    and
    isnull(d.plano,0)   > 0                    and  
    d.grupo is not null                        and
    @cd_grupo_calculo   = 0

  --Grupo em Operação com 02 Grupos de Cálculo

  --1o.Grupo  

  select  
    @vl_total_janeiro   = @vl_total_janeiro   + isnull(d.Janeiro  ,0), 
    @vl_total_fevereiro = @vl_total_fevereiro + isnull(d.Fevereiro,0), 
    @vl_total_marco     = @vl_total_marco     + isnull(d.Marco    ,0), 
    @vl_total_abril     = @vl_total_abril     + isnull(d.Abril    ,0), 
    @vl_total_maio      = @vl_total_maio      + isnull(d.Maio     ,0), 
    @vl_total_junho     = @vl_total_junho     + isnull(d.Junho    ,0), 
    @vl_total_julho     = @vl_total_julho     + isnull(d.Julho    ,0), 
    @vl_total_agosto    = @vl_total_agosto    + isnull(d.Agosto   ,0), 
    @vl_total_setembro  = @vl_total_setembro  + isnull(d.Setembro ,0), 
    @vl_total_outubro   = @vl_total_outubro   + isnull(d.Outubro  ,0), 
    @vl_total_novembro  = @vl_total_novembro  + isnull(d.Novembro ,0), 
    @vl_total_dezembro  = @vl_total_dezembro  + isnull(d.Dezembro ,0) 
 from  
    #Demo d  
 where  
    @cd_grupo_operacao  = d.cd_dr_grupo        and  
    @cd_item_grupo      = 0                    and
    isnull(d.plano,0)   = 0                    and 
    d.item = 0                                 and 
    d.grupo is not null                        and
    @cd_grupo_calculo   > 0

  --2o.Grupo  
  select  
    @vl_total_janeiro   = @vl_total_janeiro   + (isnull(d.Janeiro  ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_fevereiro = @vl_total_fevereiro + (isnull(d.Fevereiro,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_marco     = @vl_total_marco     + (isnull(d.Marco    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_abril     = @vl_total_abril     + (isnull(d.Abril    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_maio      = @vl_total_maio      + (isnull(d.Maio     ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_junho     = @vl_total_junho     + (isnull(d.Junho    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_julho     = @vl_total_julho     + (isnull(d.Julho    ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_agosto    = @vl_total_agosto    + (isnull(d.Agosto   ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_setembro  = @vl_total_setembro  + (isnull(d.Setembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_outubro   = @vl_total_outubro   + (isnull(d.Outubro  ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),  
    @vl_total_novembro  = @vl_total_novembro  + (isnull(d.Novembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end),   
    @vl_total_dezembro  = @vl_total_dezembro  + (isnull(d.Dezembro ,0) * case when @ic_tipo_operacao='U' then -1 else case when @ic_tipo_operacao='A' then 0 else 1 end end)   
 from  
    #Demo d  
 where  
    @cd_grupo_calculo   = d.cd_dr_grupo        and  
    @cd_item_grupo      = 0                    and
    isnull(d.plano,0)   = 0                    and 
    d.item = 0                                 and 
    d.grupo is not null                        and
    @cd_grupo_calculo   > 0


  --select @vl_total_marco,@cd_grupo_operacao,@cd_item_grupo

  --Atualiza o Grupo Principal  

--  select @ic_tipo_operacao,@cd_grupo,@vl_total_marco,@vg_total_marco,@vi_total_marco

  update
    #demo
  set
    Janeiro   = Janeiro   + @vl_total_janeiro,   
    Fevereiro = Fevereiro + @vl_total_fevereiro, 
    Marco     = Marco     + @vl_total_marco,     
    Abril     = Abril     + @vl_total_abril,     
    Maio      = Maio      + @vl_total_maio,      
    Junho     = Junho     + @vl_total_junho,     
    Julho     = Julho     + @vl_total_julho,     
    Agosto    = Agosto    + @vl_total_agosto,    
    Setembro  = Setembro  + @vl_total_setembro,  
    Outubro   = Outubro   + @vl_total_outubro,   
    Novembro  = Novembro  + @vl_total_novembro,  
    Dezembro  = Dezembro  + @vl_total_dezembro  
  where 
    @cd_grupo            = cd_dr_grupo        and 
    isnull(plano,0)      = 0                  
    and cd_item_dr_grupo = 0

  --Deleta o Registro da tabela Auxiliar

  delete from #AuxOperacao
  where 
     @cd_grupo          = isnull(cd_dr_grupo,0)          and 
     @cd_grupo_operacao = isnull(cd_dr_grupo_operacao,0) and
     @cd_item_grupo     = isnull(cd_item_dr_grupo,0)   
  
end

--select * from #Demo order by CodigoGrupo, CodigoItem, Ordem, Item, Plano

--select * from #Demo

-------------------------------------------------------------------------------------------------------------------
--Total Geral
-------------------------------------------------------------------------------------------------------------------
set @vl_total_janeiro   = 0
set @vl_total_fevereiro = 0
set @vl_total_marco     = 0
set @vl_total_abril     = 0
set @vl_total_maio      = 0
set @vl_total_junho     = 0
set @vl_total_julho     = 0
set @vl_total_agosto    = 0
set @vl_total_setembro  = 0
set @vl_total_outubro   = 0
set @vl_total_novembro  = 0
set @vl_total_dezembro  = 0

select
  @vl_total_janeiro   = sum( isnull(Janeiro  ,0) ),
  @vl_total_fevereiro = sum( isnull(Fevereiro,0) ),
  @vl_total_marco     = sum( isnull(Marco    ,0) ),
  @vl_total_abril     = sum( isnull(Abril    ,0) ),
  @vl_total_maio      = sum( isnull(Maio     ,0) ),
  @vl_total_junho     = sum( isnull(Junho    ,0) ),
  @vl_total_julho     = sum( isnull(Julho    ,0) ),
  @vl_total_agosto    = sum( isnull(Agosto   ,0) ),
  @vl_total_setembro  = sum( isnull(Setembro ,0) ),
  @vl_total_outubro   = sum( isnull(Outubro  ,0) ),
  @vl_total_novembro  = sum( isnull(Novembro ,0) ),
  @vl_total_dezembro  = sum( isnull(Dezembro ,0) )
from  
  #Demo

select 
  @vl_total = @vl_total_janeiro  + @vl_total_fevereiro + @vl_total_marco  + @vl_total_abril    + @vl_total_maio +
               @vl_total_junho    + @vl_total_julho     + @vl_total_agosto + @vl_total_setembro + @vl_total_outubro + 
              @vl_total_novembro + @vl_total_dezembro

-------------------------------------------------------------------------------------------------------------------
--Apresentação do Demonstrativo
-------------------------------------------------------------------------------------------------------------------
 
--A checagem do parâmetro abaixo, para mostrar as contas com Valor Zero ou Não.
if @ic_mostra_conta_zerada = 'S'
  Begin
     select 
       *,
     Total    = Janeiro + Fevereiro + Marco + Abril + Maio + Junho + Julho + Agosto + Setembro + Outubro + Novembro + Dezembro,
     pc_jan   = case when @vl_total_janeiro>0   then ( Janeiro  /@vl_total_janeiro   ) * 100 else 0 end,
     pc_fev   = case when @vl_total_fevereiro>0 then ( Fevereiro/@vl_total_fevereiro ) * 100 else 0 end,
     pc_mar   = case when @vl_total_Marco>0     then ( Marco    /@vl_total_marco     ) * 100 else 0 end,
     pc_abr   = case when @vl_total_Abril>0     then ( Abril    /@vl_total_abril     ) * 100 else 0 end,
     pc_mai   = case when @vl_total_Maio>0      then ( Maio     /@vl_total_maio      ) * 100 else 0 end,
     pc_jun   = case when @vl_total_Junho>0     then ( Junho    /@vl_total_junho     ) * 100 else 0 end,
     pc_jul   = case when @vl_total_Julho>0     then ( Julho    /@vl_total_julho     ) * 100 else 0 end,
     pc_ago   = case when @vl_total_Agosto>0    then ( Agosto   /@vl_total_agosto    ) * 100 else 0 end,
     pc_set   = case when @vl_total_Setembro>0  then ( Setembro /@vl_total_setembro  ) * 100 else 0 end,
     pc_out   = case when @vl_total_Outubro>0   then ( Outubro  /@vl_total_outubro   ) * 100 else 0 end,
     pc_nov   = case when @vl_total_Novembro>0  then ( Novembro /@vl_total_novembro  ) * 100 else 0 end,
     pc_dez   = case when @vl_total_Dezembro>0  then ( Dezembro /@vl_total_dezembro  ) * 100 else 0 end,
     pc_total = case when @vl_total >0  then ( (Janeiro + Fevereiro + Marco + Abril + Maio + Junho + Julho + Agosto + Setembro + Outubro + Novembro + Dezembro) /@vl_total  ) * 100 else 0 end 
 
     from 
        #demo
     where
       Grupo is not null and
       Apresenta = 'S'   
    
    
    Order by
    CodigoGrupo, CodigoItem, Ordem, Item, Plano
 End       
 
 if @ic_mostra_conta_zerada = 'N'
  Begin 
     select 
       *,
     Total    = Janeiro + Fevereiro + Marco + Abril + Maio + Junho + Julho + Agosto + Setembro + Outubro + Novembro + Dezembro,
     pc_jan   = case when @vl_total_janeiro>0   then ( Janeiro  /@vl_total_janeiro   ) * 100 else 0 end,
     pc_fev   = case when @vl_total_fevereiro>0 then ( Fevereiro/@vl_total_fevereiro ) * 100 else 0 end,
     pc_mar   = case when @vl_total_Marco>0     then ( Marco    /@vl_total_marco     ) * 100 else 0 end,
     pc_abr   = case when @vl_total_Abril>0     then ( Abril    /@vl_total_abril     ) * 100 else 0 end,
     pc_mai   = case when @vl_total_Maio>0      then ( Maio     /@vl_total_maio      ) * 100 else 0 end,
     pc_jun   = case when @vl_total_Junho>0     then ( Junho    /@vl_total_junho     ) * 100 else 0 end,
     pc_jul   = case when @vl_total_Julho>0     then ( Julho    /@vl_total_julho     ) * 100 else 0 end,
     pc_ago   = case when @vl_total_Agosto>0    then ( Agosto   /@vl_total_agosto    ) * 100 else 0 end,
     pc_set   = case when @vl_total_Setembro>0  then ( Setembro /@vl_total_setembro  ) * 100 else 0 end,
     pc_out   = case when @vl_total_Outubro>0   then ( Outubro  /@vl_total_outubro   ) * 100 else 0 end,
     pc_nov   = case when @vl_total_Novembro>0  then ( Novembro /@vl_total_novembro  ) * 100 else 0 end,
     pc_dez   = case when @vl_total_Dezembro>0  then ( Dezembro /@vl_total_dezembro  ) * 100 else 0 end,
     pc_total = case when @vl_total >0  then ( (Janeiro + Fevereiro + Marco + Abril + Maio + Junho + Julho + Agosto + Setembro + Outubro + Novembro + Dezembro) /@vl_total  ) * 100 else 0 end 
 
     from 
        #demo
     where
       Grupo is not null and
       Apresenta = 'S'   and 
       (Janeiro + Fevereiro + Marco + Abril + Maio + Junho + Julho + Agosto + Setembro + Outubro + Novembro + Dezembro)<>0
    
    Order by
    CodigoGrupo, CodigoItem, Ordem, Item, Plano
 End       

--AtualizaValor:
--begin
--  
--  print 'Atualiza valor Geral das Contas de Grupo'
--
--end

