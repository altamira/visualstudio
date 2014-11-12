

/****** Object:  Stored Procedure dbo.pr_gerencial_coleta_prod_concorrente    Script Date: 13/12/2002 15:08:33 ******/


--pr_gerencial_coleta_prod_concorrente
--------------------------------------------------------------------------------------
--Global Business Solution Ltda
--Stored Procedure : SQL Server Microsoft 2002  
--Carlos Cardoso Fernandes         
--Consulta Gerencial de Coleta de Merchandising
--Data          : 30.05.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
CREATE  procedure pr_gerencial_coleta_prod_concorrente
@dt_inicial datetime,
@dt_final   datetime
as

select 
   red.nm_rede_loja,
   ban.nm_bandeira_loja,
   cp.nm_categoria_produto, 
   p.nm_coleta_prd_concorrente,
   sum(coi.qt_frente_item_coleta) as 'frentes'
into #frente 
from
   Coleta_produto_concorrente p, 
   categoria_produto cp,
   coleta co,
   coleta_item coi,
   rede_loja   red,
   bandeira_loja ban,
   loja_coleta   loj 
where 
  p.cd_categoria_produto = cp.cd_categoria_produto  and
  co.dt_coleta between @dt_inicial and @dt_final    and
  co.cd_loja_coleta = loj.cd_loja_coleta            and
  loj.cd_bandeira_loja = ban.cd_bandeira_loja       and
  ban.cd_rede_loja     = red.cd_rede_loja       and
  co.cd_coleta         = coi.cd_coleta              and
  p.cd_produto         = coi.cd_produto             

group by
   red.nm_rede_loja,
   ban.nm_bandeira_loja,
   cp.nm_categoria_produto,
   p.nm_coleta_prd_concorrente


declare @vl_total_frente float
set @vl_total_frente = 0

select @vl_total_frente =  @vl_total_frente + frentes
from #frente

select *,(frentes/@vl_total_frente)*100 as 'PercFrente' 
from 
  #frente





