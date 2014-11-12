
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_necessidade_programacao_entrega
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Necessidades de Compras / Produção = MRP
--
--Data             : 17.09.2007
--
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_necessidade_programacao_entrega
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

-------------------------------------------------------------------------------
--Montagem de uma tabela agrupada por Produto
-------------------------------------------------------------------------------

select
  pe.cd_produto,
  sum( isnull(qt_programacao_entrega,0) ) as qt_programacao_entrega
into
  #Programacao
from
  Programacao_Entrega pe
where
  isnull(pe.cd_processo,0)=0           and
  isnull(pe.cd_requisicao_compra,0)=0  and
  isnull(pe.cd_requisicao_interna,0)=0
group by
  pe.cd_produto

--select * from #Programacao
--select * from processo_padrao

-------------------------------------------------------------------------------
--Necessidade do Produto Principal
-------------------------------------------------------------------------------

select 
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
  xp.cd_processo_padrao

into
  #Necessidade
from
  #Programacao pe                         with (nolock )
  inner join Produto p                    with (nolock ) on p.cd_produto               = pe.cd_produto
  left outer join Unidade_Medida um       with (nolock ) on um.cd_unidade_medida       = p.cd_unidade_medida
  left outer join Produto_Saldo ps        with (nolock ) on ps.cd_produto              = pe.cd_produto and
                                                         ps.cd_fase_produto         = p.cd_fase_produto_baixa
  left outer join Fase_Produto fp         with (nolock ) on fp.cd_fase_produto         = ps.cd_fase_produto
  left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto and
                                                            pp.cd_fase_produto         = ps.cd_fase_produto
  left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto
  left outer join Produto_Producao    xp with (nolock ) on xp.cd_produto              = p.cd_produto
order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto

--select * from #Necessidade

-------------------------------------------------------------------------------
--Necessidade da Composição do Produto
-------------------------------------------------------------------------------

select 
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
  xp.cd_processo_padrao
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
   left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto and
                                                            pp.cd_fase_produto         = ps.cd_fase_produto

   left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto
   left outer join Produto_Producao     xp with (nolock ) on xp.cd_produto              = p.cd_produto
   
order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto


--select * from #Necessidade_Composicao

-------------------------------------------------------------------------------
--Necessidade da Composição do Processo Padrão
-------------------------------------------------------------------------------
--select * from processo_padrao_produto

select 
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
  xp.cd_processo_padrao
into
  #Necessidade_Processo
from
  #Necessidade pe                         with (nolock )

  inner join Processo_Padrao         xp   with (nolock)  on xp.cd_processo_padrao = pe.cd_processo_padrao
  inner join Processo_Padrao_Produto pc   with (nolock ) on pc.cd_processo_padrao = pe.cd_processo_padrao
  inner join Produto p                    with (nolock ) on p.cd_produto          = pc.cd_produto                                                        
  left outer join Unidade_Medida um       with (nolock ) on um.cd_unidade_medida       = p.cd_unidade_medida
  left outer join Produto_Saldo ps        with (nolock ) on ps.cd_produto              = pe.cd_produto and
                                                            ps.cd_fase_produto         = pc.cd_fase_produto
  left outer join Fase_Produto fp         with (nolock ) on fp.cd_fase_produto         = ps.cd_fase_produto
  left outer join Produto_Processo     pp with (nolock ) on pp.cd_produto              = p.cd_produto and
                                                            pp.cd_fase_produto         = ps.cd_fase_produto

   left outer join Tipo_Produto_Projeto tp with (nolock ) on tp.cd_tipo_produto_projeto = pp.cd_tipo_produto_projeto
   
order by
  tp.nm_tipo_produto_projeto,
  p.nm_fantasia_produto

--select * from #Necessidade_Processo


--Unificação das Tabelas

select
  *
from
  #Necessidade
Union all
  select * from #Necessidade_Composicao
Union all
  select * from #Necessidade_Processo

order by
  nm_tipo_produto_projeto,
  nm_fantasia_produto
  

--select * from produto_compra
--select * from produto_composicao where cd_produto_pai = 263
--select * from produto_composicao where cd_produto     = 24337
--select cd_versao_produto,* from produto where cd_produto = 263
--select * from produto_producao

