
-------------------------------------------------------------------------------
--sp_helptext pr_posicao_custo_fechamento_mensal
-------------------------------------------------------------------------------
--pr_posicao_custo_fechamento_mensal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Posição de Estoque do Produto
--Data             : 29.09.2009
--Alteração        : 05.02.2010 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_posicao_custo_fechamento_mensal
@dt_inicial      datetime = '',
@dt_final        datetime = '',
--@dt_base         datetime,
@cd_fase_produto int      = 0

as

declare @vl_moeda float

--set @vl_moeda = 
set @vl_moeda = 2.5653 --Euro de Fevereiro de 2010


if @cd_fase_produto is null
   set @cd_fase_produto = 3

--select * from fase_produto

set @cd_fase_produto = 3 --Temporário

declare @dt_base datetime

set @dt_base = @dt_inicial

--if @dt_base is null
--   set @dt_base = @dt_inicial

  ---select * from categoria_produto

  select
    mp.nm_marca_produto                                                       as Marca,
    cp.sg_categoria_produto                                                   as Categoria,
    cp.cd_mascara_categoria,
    fp.nm_fase_produto,
    fec.cd_fase_produto,
    fec.cd_produto,
    gp.cd_grupo_produto,
    gp.nm_grupo_produto,
    cf.cd_mascara_classificacao,
    isnull(dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto)
         ,p.cd_mascara_produto)                                               as Codigo,
    p.nm_fantasia_produto                                                     as Produto,
    p.nm_produto                                                              as Discriminacao,
    isnull(um.sg_unidade_medida,ump.sg_unidade_medida)                        as Unidade, 
    p.qt_peso_bruto                                                           as PesoUnitario,
    isnull(cast(fec.qt_atual_prod_fechamento as decimal(25,4)),0)             as Quantidade,
    (fec.vl_custo_prod_fechamento / isnull(fec.qt_atual_prod_fechamento,0))   as Unitario,

  --Caso for o Preço de Importação

--   isnull(case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --tpi.vl_produto_importacao
-- 
--      ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--      
--      * 
-- 
--      case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   end,0)                                                                         as 'Unitario',

  isnull(fec.vl_custo_prod_fechamento,0)                                    as Total,

--   isnull(cast(fec.qt_atual_prod_fechamento as decimal(25,4)),0)        
-- 
--   *
-- 
--   isnull(( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--      
--      * 
-- 
--      case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end,0) 
--                                                                              as 'Total',

    mv.cd_metodo_valoracao,
    mv.nm_metodo_valoracao

--    tpi.vl_produto_importacao                                                    

  into
    #p1

  from Produto_Fechamento fec                   with(nolock)
    left outer join Produto p                   with(nolock) on fec.cd_produto             = p.cd_produto 
    left outer join Produto_Custo pc            with(nolock) on p.cd_produto               = pc.cd_produto
    left outer join Grupo_Produto gp            with(nolock) on gp.cd_grupo_produto        = p.cd_grupo_produto   
    left outer join Grupo_Produto_Custo gpc     with(nolock) on gpc.cd_grupo_produto       = p.cd_grupo_produto   
    left outer join Unidade_Medida um           with(nolock) on um.cd_unidade_medida       = gpc.cd_unidade_valoracao
    left outer join Unidade_Medida ump          with(nolock) on ump.cd_unidade_medida      = p.cd_unidade_medida
    left outer join Produto_Fiscal pf           with(nolock) on p.cd_produto               = pf.cd_produto 
    left outer join Classificacao_Fiscal cf     with(nolock) on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
    left outer join Fase_Produto fp             with(nolock) on fec.cd_fase_produto        = fp.cd_fase_produto
    left outer join Metodo_Valoracao mv         with(nolock) on fec.cd_metodo_valoracao    = mv.cd_metodo_valoracao 
    left outer join Categoria_Produto cp        with(nolock) on cp.cd_categoria_produto    = p.cd_categoria_produto
    left outer join Marca_Produto mp            with(nolock) on mp.cd_marca_produto        = p.cd_marca_produto 
    left outer join Status_Produto sp           with(nolock) on sp.cd_status_produto       = p.cd_status_produto
--     left outer join tabela_preco_importacao  tpi with (nolock) on tpi.cd_produto              = fec.cd_produto and
--                                                                  tpi.dt_inicial_preco        = '02/01/2010'   and
--                                                                  tpi.dt_final_preco          = '02/28/2010'       

  where 
    --mv.ic_controla_inventario = 'S' and
    fec.cd_fase_produto = case when @cd_fase_produto = 0 then fec.cd_fase_produto 
                                                         else @cd_fase_produto end 
    and      
    fec.dt_produto_fechamento = @dt_base and
    isnull(fec.qt_atual_prod_fechamento,0) > 0 
    and 
    fec.cd_fase_produto = case when @cd_fase_produto = 0 then fec.cd_fase_produto else @cd_fase_produto end
    and isnull(sp.ic_bloqueia_uso_produto,'N')='N'

--select * from status_produto

order by
  p.nm_produto

set @cd_fase_produto = 4 --Temporário

  select
    mp.nm_marca_produto                                                       as Marca,
    cp.sg_categoria_produto                                                   as Categoria,
    cp.cd_mascara_categoria,
    fp.nm_fase_produto,
    fec.cd_fase_produto,
    fec.cd_produto,
    gp.cd_grupo_produto,
    gp.nm_grupo_produto,
    cf.cd_mascara_classificacao,
    isnull(dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto)
         ,p.cd_mascara_produto)                                               as Codigo,
    p.nm_fantasia_produto                                                     as Produto,
    p.nm_produto                                                              as Discriminacao,
    isnull(um.sg_unidade_medida,ump.sg_unidade_medida)                        as Unidade, 
    p.qt_peso_bruto                                                           as PesoUnitario,
    isnull(cast(fec.qt_atual_prod_fechamento as decimal(25,4)),0)             as Quantidade,
    (fec.vl_custo_prod_fechamento / isnull(fec.qt_atual_prod_fechamento,0))   as Unitario,
    isnull(fec.vl_custo_prod_fechamento,0)                                    as Total,


    mv.cd_metodo_valoracao,
    mv.nm_metodo_valoracao
--    tpi.vl_produto_importacao                                                   
 
  into 
    #p2

  from Produto_Fechamento fec                   with(nolock)
    left outer join Produto p                   with(nolock) on fec.cd_produto             = p.cd_produto 
    left outer join Produto_Custo pc            with(nolock) on p.cd_produto               = pc.cd_produto
    left outer join Grupo_Produto gp            with(nolock) on gp.cd_grupo_produto        = p.cd_grupo_produto   
    left outer join Grupo_Produto_Custo gpc     with(nolock) on gpc.cd_grupo_produto       = p.cd_grupo_produto   
    left outer join Unidade_Medida um           with(nolock) on um.cd_unidade_medida       = gpc.cd_unidade_valoracao
    left outer join Unidade_Medida ump          with(nolock) on ump.cd_unidade_medida      = p.cd_unidade_medida
    left outer join Produto_Fiscal pf           with(nolock) on p.cd_produto               = pf.cd_produto 
    left outer join Classificacao_Fiscal cf     with(nolock) on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
    left outer join Fase_Produto fp             with(nolock) on fec.cd_fase_produto        = fp.cd_fase_produto
    left outer join Metodo_Valoracao mv         with(nolock) on fec.cd_metodo_valoracao    = mv.cd_metodo_valoracao 
    left outer join Categoria_Produto cp        with(nolock) on cp.cd_categoria_produto    = p.cd_categoria_produto
    left outer join Marca_Produto mp            with(nolock) on mp.cd_marca_produto        = p.cd_marca_produto 
    left outer join Status_Produto sp           with(nolock) on sp.cd_status_produto       = p.cd_status_produto

--     left outer join tabela_preco_importacao  tpi with (nolock) on tpi.cd_produto              = fec.cd_produto and
--                                                                  tpi.dt_inicial_preco        = '02/01/2010'   and
--                                                                 tpi.dt_final_preco          = '02/28/2010'       

  where 
    --mv.ic_controla_inventario = 'S' and
    fec.cd_fase_produto = case when @cd_fase_produto = 0 then fec.cd_fase_produto 
                                                         else @cd_fase_produto end 
    and      
    fec.dt_produto_fechamento = @dt_base and
    isnull(fec.qt_atual_prod_fechamento,0) > 0 
    and 
    fec.cd_fase_produto = case when @cd_fase_produto = 0 then fec.cd_fase_produto else @cd_fase_produto end
    and isnull(sp.ic_bloqueia_uso_produto,'N')='N'

order by
  p.nm_produto


update
  #p1
set
  Quantidade = isnull(p1.Quantidade,0) + isnull(p2.Quantidade,0),
  Total      = isnull(p1.Total,0)      + isnull(p2.Total,0)
from
  #p1 p1
  inner join #p2 p2 on p1.cd_produto = p2.cd_produto


--Mostra a Tabela

insert into #p1
select
  *
from
  #p2
where
  cd_produto not in ( select cd_produto from #p1 )  
  and
  isnull(Quantidade,0)>0

select
  *
from
  #p1
where
  isnull(Quantidade,0)>0
order by
  Discriminacao

-- select
--   *
-- from 
--   #p1
-- where
--   isnull(Quantidade,0)>0
-- union all
--   select * from #p2
--   where
--     cd_produto not in ( select cd_produto from #p1 )  
--      and
--      isnull(Quantidade,0)>0

  
-- update
--   #p1
-- 
-- select
--   p1.*
-- from
--   #p1 p1
--   left outer join #p2 p2 on p1.cd_produto = p2.cd_produto

