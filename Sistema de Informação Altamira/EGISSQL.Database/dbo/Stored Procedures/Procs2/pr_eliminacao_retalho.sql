
-------------------------------------------------------------------------------
--pr_eliminacao_retalho
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 03/02/2005
--Atualizado       : 03/02/2005
--------------------------------------------------------------------------------------------------
create procedure pr_eliminacao_retalho
@cd_tipo_retalho int

as

--select * from produto_saldo

select 
  tr.nm_tipo_retalho          as Retalho,
  tr.qt_limite_minimo_retalho as Limite,
  gp.nm_grupo_produto         as GrupoProduto,
  p.cd_produto                as CodigoProduto,
  p.cd_mascara_produto        as MascaraProduto,
  p.nm_fantasia_produto       as Fantasia,
  p.nm_produto                as DescricaoProduto,
  um.sg_unidade_medida        as Unidade,
  ps.qt_saldo_atual_produto   as Saldo,
  fp.nm_fase_produto          as FaseProduto,
  0                           as Lote,   --Definir
  0                           as Peca,   --Definir
  px.cd_produto               as 'CodigoProdutoNovo',
  px.cd_mascara_produto       as 'MascaraNovoProduto',
  px.nm_fantasia_produto      as 'FantasiaNovoProduto',
  px.nm_produto               as 'DescricaoNovoProduto'
  
from
  Tipo_Retalho tr
  --left outer join Grupo_Produto  gp        on gp.cd_tipo_retalho   = tr.cd_tipo_retalho 
  left outer join Produto        p         on p.cd_tipo_retalho    = tr.cd_tipo_retalho
  left outer join Grupo_Produto  gp        on p.cd_grupo_produto   = gp.cd_grupo_produto
  left outer join Unidade_Medida um        on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Produto_Saldo  ps        on ps.cd_produto        = p.cd_produto
  left outer join Fase_Produto   fp        on fp.cd_fase_produto   = ps.cd_fase_produto
  left outer join Tipo_Retalho_Produto trp on trp.cd_tipo_retalho  = p.cd_tipo_retalho --and
                                              --trp.cd_produto       = p.cd_produto       and
                                              --trp.cd_fase_produto  = ps.cd_fase_produto
  left outer join produto px               on px.cd_produto        = trp.cd_produto
where
  tr.cd_tipo_retalho = case when @cd_tipo_retalho = 0 then tr.cd_tipo_retalho else @cd_tipo_retalho end and
  isnull(ps.qt_saldo_atual_produto,0)>0 and
  isnull(ps.qt_saldo_atual_produto,0) <= tr.qt_limite_minimo_retalho



