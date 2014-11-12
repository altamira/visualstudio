

/****** Object:  Stored Procedure dbo.pr_consulta_coleta_total_frente    Script Date: 13/12/2002 15:08:18 ******/
CREATE PROCEDURE pr_consulta_coleta_total_frente
/*---------------------------------------------------------------------------  
  procedure      : pr_consulta_coleta_total_frente
  Autor(es)      : Adriano Levy  
  Banco de dados : EgisSql
  Objetivo       : 
  Data           : 28/05/2002
---------------------------------------------------------------------------  */
@ic_parametro  char(1),
@dt_inicial    datetime,
@dt_final      datetime,
@pc_objetivo   float
as
/* Inicio Tabela Concorrente */

select 
       rl.nm_rede_loja as 'Redec',
       bl.nm_bandeira_loja as 'Bandeirac',
       lc.nm_loja_coleta as 'Lojac', 
       rc.nm_regiao_coleta 'Regiaoc',
       isnull(c.nm_coleta_prd_concorrente,'') as 'Concorrentec',
       isnull(p.nm_produto,'') as 'Produto',
       sum(isnull(cast(ci.qt_frente_item_coleta as integer),0)) as 'TotFrentec',
       sum(isnull(cast(ci.qt_duzia_item_coleta as numeric(25,2)),0)) as 'TotRepc',
       max(isnull(cast(ci.vl_item_coleta as numeric(25,2)),0)) as 'PrcMaxc',
       min(isnull(cast(ci.vl_item_coleta as numeric(25,2)),0)) as 'PrcMinc',
       avg(isnull(cast(ci.vl_item_coleta as numeric(25,2)),0)) as 'PrcMedc'

into #Concorrente

from
   Coleta_Produto_Concorrente c
left outer join produto p
     on p.cd_produto = c.cd_produto
left outer join coleta_item ci
     on ci.cd_produto_concorrente=c.cd_coleta_prd_concorrente
left outer join coleta cl
     on cl.cd_coleta=ci.cd_coleta
left outer join loja_coleta lc
     on lc.cd_loja_coleta=cl.cd_loja_coleta
left outer join regiao_coleta rc
     on rc.cd_regiao_coleta=cl.cd_regiao_coleta
left outer join bandeira_loja bl
     on bl.cd_bandeira_loja=lc.cd_bandeira_loja
left outer join rede_loja rl
     on rl.cd_rede_loja=bl.cD_rede_loja

group by
       rl.nm_rede_loja,
       bl.nm_bandeira_loja,
       lc.nm_loja_coleta, 
       rc.nm_regiao_coleta,
       c.nm_coleta_prd_concorrente,
       p.nm_produto

/* Inicio Tabela Produto */

select 
       rl.nm_rede_loja as 'Rede',
       bl.nm_bandeira_loja as 'Bandeira',
       lc.nm_loja_coleta as 'Loja', 
       rc.nm_regiao_coleta 'Regiao',
       isnull(p.nm_produto,'') as 'Produto',
       isnull(c.nm_coleta_prd_concorrente,'') as 'Concorrente',
       sum(isnull(cast(ci.qt_frente_item_coleta as integer),0)) as 'TotFrenteP',
       sum(isnull(cast(ci.qt_duzia_item_coleta as numeric(25,2)),0)) as 'TotRepP',
       max(isnull(cast(ci.vl_item_coleta as numeric(25,2)),0)) as 'PrcMaxP',
       min(isnull(cast(ci.vl_item_coleta as numeric(25,2)),0)) as 'PrcMinp',
       avg(isnull(cast(ci.vl_item_coleta as numeric(25,2)),0)) as 'PrcMedp'

into #Produto

from
   produto p
left outer join Coleta_Produto_Concorrente c
     on c.cd_produto = p.cd_produto
left outer join coleta_item ci
     on ci.cd_produto=p.cd_produto
left outer join coleta cl
     on cl.cd_coleta=ci.cd_coleta
left outer join loja_coleta lc
     on lc.cd_loja_coleta=cl.cd_loja_coleta
left outer join regiao_coleta rc
     on rc.cd_regiao_coleta=cl.cd_regiao_coleta
left outer join bandeira_loja bl
     on bl.cd_bandeira_loja=lc.cd_bandeira_loja
left outer join rede_loja rl
     on rl.cd_rede_loja=bl.cD_rede_loja

group by
       rl.nm_rede_loja,
       bl.nm_bandeira_loja,
       lc.nm_loja_coleta, 
       rc.nm_regiao_coleta,
       p.nm_produto,
       c.nm_coleta_prd_concorrente

Select P.*,
       C.TotFrenteC,
       C.TotRepC,
       C.PrcMaxC,
       C.PrcMinC,
       C.PrcMedC,
       isnull(P.TOTFRENTEP,0) + isnull(c.totfrentec,0) as 'totalfrente'
     

from #Produto p
left outer join #Concorrente c on (c.produto=p.produto and c.redec=p.rede and c.bandeirac=p.bandeira and c.lojac=p.loja and c.regiaoc=p.regiao)





