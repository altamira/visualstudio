
-----------------------------------------------------------------------------------
--pr_geracao_inventario_fisico_fase
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Geração do Inventário Físico
--                   
--Data             : 11.09.2003
-----------------------------------------------------------------------------------
create procedure pr_geracao_inventario_fisico_fase
@dt_inicial datetime,
@dt_final   datetime
as
select
  p.cd_grupo_produto,
  pf.cd_fase_produto,
  p.cd_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  u.nm_unidade_medida,
  pc.cd_mat_prima,
  pf.qt_atual_prod_fechamento,
  p.qt_peso_bruto,
  pf.qt_atual_prod_fechamento * p.qt_peso_bruto as 'qt_peso_total'
  
from
  Grupo_Produto_Custo gpc,
  Produto        p, 
  Unidade_Medida u,
  Produto_Fechamento pf,
  Produto_Custo  pc
where
  p.cd_grupo_produto = gpc.cd_grupo_produto    and
  isnull(gpc.ic_invent_fisico_grupo,'N')='S'   and 
  p.cd_unidade_medida = u.cd_unidade_medida    and
  p.cd_produto = pf.cd_produto                 and
  pf.dt_produto_fechamento between @dt_inicial and @dt_final and
  isnull(pf.qt_atual_prod_fechamento,0)>0      and
  p.cd_produto *= pc.cd_produto
order by
  p.cd_grupo_produto,
  pf.cd_fase_produto


