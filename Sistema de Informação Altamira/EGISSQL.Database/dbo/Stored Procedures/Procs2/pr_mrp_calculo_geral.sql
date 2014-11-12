
-------------------------------------------------------------------------------
--sp_helptext pr_mrp_calculo_geral
-------------------------------------------------------------------------------
--pr_mrp_calculo_geral
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo Geral - Geração de Necessidades de Compras / Produção = MRP
--
--Data             : 17.09.2007
--
--Alteração        : 11.06.2010
-- 26.08.2010 - flag do processo padrão de custo --> ic_custo_processo_padrao - Carlos Fernandes
-- 09.11.2010 - ajustes diversos - carlos fernandes
------------------------------------------------------------------------------
create procedure pr_mrp_calculo_geral
@ic_parametro int      = 0,    --> 0 --> Consulta / 9 --> Cálculo
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@ic_agrupado  char(1)  = 'N',
@cd_plano_mrp int      = 0,    --> Plano MRP que deverá ser gerado as Necessidades
@cd_usuario   int      = 0

as

-------------------------------------------------------------------------------
--Montagem de uma tabela agrupada por Produto
-------------------------------------------------------------------------------
--select * from plano_mrp_composicao

select
  pe.cd_produto,
  sum( isnull(qt_plano_mrp,0) ) as qt_programacao_entrega
into
  #Programacao

from
  plano_mrp_composicao pe with (nolock) 

where
  --Plano MRP
  pe.cd_plano_mrp                  = case when @cd_plano_mrp = 0 then pe.cd_plano_mrp else @cd_plano_mrp end and
  isnull(pe.cd_processo,0)=0           and
  isnull(pe.cd_requisicao_compra,0)=0  and
  isnull(pe.cd_requisicao_interna,0)=0

group by
  pe.cd_produto

--select * from #Programacao
--select * from processo_padrao
--select * from plano_mrp_composicao
--delete from plano_mrp_composicao where cd_item_plano_mrp>1

-------------------------------------------------------------------------------
--Necessidade do Produto Principal
-------------------------------------------------------------------------------

select 
 tp.cd_tipo_produto_projeto,
 tp.nm_tipo_produto_projeto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.cd_fase_produto,
  fp.nm_fase_produto,
  pe.cd_produto,
  pe.qt_programacao_entrega,
  p.qt_leadtime_compra,
  p.cd_versao_produto,
  ps.qt_saldo_reserva_produto,
  xp.cd_processo_padrao,
  null                        as cd_processo_produto

into
  #Necessidade

from
  #Programacao pe                         with (nolock )
  inner join Produto p                    with (nolock ) on p.cd_produto               = pe.cd_produto

  left outer join Unidade_Medida um       with (nolock ) on um.cd_unidade_medida       = p.cd_unidade_medida


  left outer join Produto_Saldo ps        with (nolock ) on ps.cd_produto              = pe.cd_produto and
                                                            ps.cd_fase_produto         = p.cd_fase_produto_baixa

  left outer join Fase_Produto fp         with (nolock ) on fp.cd_fase_produto         = ps.cd_fase_produto

  left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto 
                                                            --and pp.cd_fase_produto         = ps.cd_fase_produto

  left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto

  left outer join Produto_Producao    xp  with (nolock ) on xp.cd_produto              = p.cd_produto

--  left outer join Processo_Padrao     xxp with (nolock ) on xxp.cd_processo_padrao     = xp.cd_processo_padrao

--select * from produto_producao
--select * from produto_processo where cd_produto = 615

-- where
--   isnull(xxp.ic_custo_processo_padrao,'N')='S'

order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto

--select * from #Necessidade

-------------------------------------------------------------------------------
--Necessidade da Composição do Produto
-------------------------------------------------------------------------------

select 
 tp.cd_tipo_produto_projeto,
 tp.nm_tipo_produto_projeto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.cd_fase_produto,
  fp.nm_fase_produto,
  p.cd_produto,
  pe.qt_programacao_entrega * pc.qt_produto_composicao as qt_programacao_entrega,
  p.qt_leadtime_compra,
  p.cd_versao_produto,
  ps.qt_saldo_reserva_produto,
  xp.cd_processo_padrao,
  null                                                 as cd_processo_produto  

into
  #Necessidade_Composicao

from
  #Programacao pe                         with (nolock )

  inner join Produto_Composicao pc        with (nolock ) on pc.cd_produto_pai          = pe.cd_produto

  inner join Produto p                    with (nolock ) on p.cd_produto               = pc.cd_produto                                                        
                                                            and
                                                            isnull(p.cd_versao_produto,0)        = isnull(pc.cd_versao_produto,0)
   left outer join Unidade_Medida um       with (nolock ) on um.cd_unidade_medida       = p.cd_unidade_medida
   left outer join Produto_Saldo ps        with (nolock ) on ps.cd_produto              = pe.cd_produto and
                                                             ps.cd_fase_produto         = pc.cd_fase_produto
   left outer join Fase_Produto fp         with (nolock ) on fp.cd_fase_produto         = ps.cd_fase_produto
   left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto --and
                                                            --pp.cd_fase_produto         = ps.cd_fase_produto

   left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto
   left outer join Produto_Producao     xp with (nolock ) on xp.cd_produto              = p.cd_produto
   
--  left outer join Processo_Padrao     xxp with (nolock ) on xxp.cd_processo_padrao     = xp.cd_processo_padrao

--select * from produto_producao

-- where
--   isnull(xxp.ic_custo_processo_padrao,'N')='S'

order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto


--select * from #Necessidade_Composicao

-------------------------------------------------------------------------------
--Necessidade da Composição do Processo Padrão
-------------------------------------------------------------------------------
--select * from processo_padrao_produto

select 
 tp.cd_tipo_produto_projeto,
 tp.nm_tipo_produto_projeto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.cd_fase_produto,
  fp.nm_fase_produto,
  p.cd_produto,
  pe.qt_programacao_entrega * pc.qt_produto_processo as qt_programacao_entrega,
  p.qt_leadtime_compra,
  p.cd_versao_produto,
  ps.qt_saldo_reserva_produto,
  xp.cd_processo_padrao,
  pprod.cd_processo_padrao                           as cd_processo_produto

into
  #Necessidade_Processo

from
  #Necessidade pe                         with (nolock )

  inner join Processo_Padrao         xp   with (nolock)  on xp.cd_processo_padrao      = pe.cd_processo_padrao
  inner join Processo_Padrao_Produto pc   with (nolock ) on pc.cd_processo_padrao      = xp.cd_processo_padrao
  inner join Produto p                    with (nolock ) on p.cd_produto               = pc.cd_produto                                                        

  left outer join Unidade_Medida um       with (nolock ) on um.cd_unidade_medida       = p.cd_unidade_medida

  left outer join Produto_Saldo ps        with (nolock ) on ps.cd_produto              = pc.cd_produto and
                                                            ps.cd_fase_produto         = pc.cd_fase_produto

  left outer join Fase_Produto fp         with (nolock ) on fp.cd_fase_produto         = ps.cd_fase_produto

  left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto --and
                                                            --pp.cd_fase_produto         = ps.cd_fase_produto

  left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto
  left outer join Produto_Producao pprod  with (nolock)  on pprod.cd_produto           = p.cd_produto
  left outer join processo_padrao xxp     with (nolock)  on xxp.cd_processo_padrao     = pprod.cd_processo_padrao

--select * from produto_producao where cd_produto = 5112

 where
   isnull(xxp.ic_custo_processo_padrao,'N')='S'
   

order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto

--select * from produto_producao
--select * from #Necessidade_Processo

--Composição dos Produtos que estão que possuem processo padrão------------------------------------------
--fn_componente_processo_padra( pp )

select 
 tp.cd_tipo_produto_projeto,
 tp.nm_tipo_produto_projeto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.cd_fase_produto,
  fp.nm_fase_produto,
  p.cd_produto,
  pe.qt_programacao_entrega * pc.qt_produto_processo as qt_programacao_entrega,
  p.qt_leadtime_compra,
  p.cd_versao_produto,
  ps.qt_saldo_reserva_produto,
  xp.cd_processo_padrao,
  pprod.cd_processo_padrao                           as cd_processo_produto

into
  #Necessidade_Processo_Composicao

from
  #Necessidade_Processo pe                with (nolock )

  inner join Processo_Padrao         xp   with (nolock)  on xp.cd_processo_padrao      = pe.cd_processo_produto
  inner join Processo_Padrao_Produto pc   with (nolock ) on pc.cd_processo_padrao      = pe.cd_processo_produto
  inner join Produto p                    with (nolock ) on p.cd_produto               = pc.cd_produto                                                        
  left outer join Unidade_Medida um       with (nolock ) on um.cd_unidade_medida       = p.cd_unidade_medida
  left outer join Produto_Saldo ps        with (nolock ) on ps.cd_produto              = pe.cd_produto and
                                                            ps.cd_fase_produto         = pc.cd_fase_produto
  left outer join Fase_Produto fp         with (nolock ) on fp.cd_fase_produto         = ps.cd_fase_produto
  left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto --and
--                                                            pp.cd_fase_produto         = ps.cd_fase_produto

  left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto
  left outer join Produto_Producao pprod  with (nolock)  on pprod.cd_produto           = p.cd_produto

where
  isnull(xp.ic_custo_processo_padrao,'N')='S'
   
order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto


--select * from #Necessidade_Processo_Composicao




--Unificação das Tabelas


select
  *
into
  #Geral

from
  #Necessidade

Union all
  select * from #Necessidade_Composicao
Union all
  select * from #Necessidade_Processo
Union all
  select * from #Necessidade_Processo_Composicao

-- order by
--   nm_tipo_produto_projeto,
--   nm_fantasia_produto


--SET @ic_agrupado = 'S'

if @ic_parametro = 0
begin
  
if @ic_agrupado = 'N' 
begin

  select * from #Geral
  order by
    nm_tipo_produto_projeto,
    nm_fantasia_produto

end


if @ic_agrupado = 'S' 
begin

  select
   cd_tipo_produto_projeto,
   nm_tipo_produto_projeto,
   cd_mascara_produto,
   nm_fantasia_produto,
   nm_produto,
   sg_unidade_medida,
   cd_fase_produto,
   nm_fase_produto,
   cd_produto,   
   sum( isnull(qt_programacao_entrega,0)) as qt_programacao_entrega,
   max(qt_leadtime_compra)                as qt_leadtime_compra,
   max(cd_versao_produto)                 as cd_versao_produto,
   max(qt_saldo_reserva_produto)          as qt_saldo_reserva_produto,
   null                                   as cd_processo_padrao,
   null                                   as cd_processo_produto
  from #Geral
  group by
   cd_tipo_produto_projeto,
   nm_tipo_produto_projeto,
   cd_mascara_produto,
   nm_fantasia_produto,
   nm_produto,
   sg_unidade_medida,
   cd_fase_produto,
   nm_fase_produto,
   cd_produto
   
  order by
    nm_tipo_produto_projeto,
    nm_fantasia_produto

end

end

--Gera a Tabela de Necessidades do Plano MRP

if @ic_parametro = 9

begin

if @cd_plano_mrp <> 0
begin

  select
   @cd_plano_mrp                         as cd_plano_mrp,
   identity(int,1,1)                     as cd_item_necessidade,
   cd_tipo_produto_projeto,
   cd_produto,
   cd_fase_produto,
   sum( isnull(qt_programacao_entrega,0)) as qt_item_necessidade,
   0                                      as cd_requisicao_compra,
   0                                      as cd_requisicao_interna,
   0                                      as cd_processo,
   'MRP'                                  as nm_obs_item_necessidade,
   @cd_usuario                            as cd_usuario,
   getdate()                              as dt_usuario

  into
    #plano_mrp_necessidade

  from #Geral
  group by
   cd_tipo_produto_projeto,
   cd_produto,
   cd_fase_produto
   

  --plano_mrp_necessidade

  delete from plano_mrp_necessidade
  where
    cd_plano_mrp = @cd_plano_mrp

  insert into
    plano_mrp_necessidade
  select
    *
  from
    #plano_mrp_necessidade

  drop table #plano_mrp_necessidade

end

end


--select * from produto_compra
--select * from produto_composicao where cd_produto_pai = 263
--select * from produto_composicao where cd_produto     = 24337
--select cd_versao_produto,* from produto where cd_produto = 263
--select * from produto_producao

