
-------------------------------------------------------------------------------
--pr_consulta_custo_reposicao_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta do Custo de Reposição 
--
--Parâmetros       : Grupo de Produto
--                   Produto
--
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_custo_reposicao_produto
@cd_grupo_produto int,
@ic_tipo_filtro char(1),
@nm_filtro        varchar(80)
as


--select * from pedido_compra_item
--select * from nota_entrada_item
 
 select
   gp.nm_grupo_produto,
   p.cd_produto,
   p.cd_mascara_produto          as Codigo,
   p.nm_fantasia_produto         as Fantasia,
   p.nm_produto                  as Descricao,
   p.cd_unidade_medida,
   um.sg_unidade_medida          as Unidade,
   isnull(pc.vl_custo_produto,0) as Custo,
   sp.nm_status_produto,

   UltimaCompra = ( 
    select 
      max(dt_item_pedido_compra) 
    from 
      Pedido_Compra_item 
    where 
      p.cd_produto = cd_produto and dt_item_canc_ped_compra is null )


from
  Produto p
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Produto_Custo  pc on pc.cd_produto        = p.cd_produto
  left outer join Status_Produto sp on sp.cd_status_produto = p.cd_status_produto
  left outer join Grupo_Produto gp  on gp.cd_grupo_produto  = p.cd_grupo_produto
where
  gp.cd_grupo_produto = case when @cd_grupo_produto = 0 then gp.cd_grupo_produto else @cd_grupo_produto end and
  (case when @ic_tipo_filtro = 'C' then
    p.cd_mascara_produto 
   else
    p.nm_fantasia_produto end ) like @nm_filtro + '%'

order by
  p.cd_grupo_produto,
  p.cd_mascara_produto

