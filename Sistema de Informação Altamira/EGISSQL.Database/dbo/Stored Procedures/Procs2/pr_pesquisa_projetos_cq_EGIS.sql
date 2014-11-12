
--pr_pesquisa_projetos_cq_EGIS
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Selecão de Registros da Tabela de Projetos : só seleção
--Data             : 20.09.2001
--Atualizado       : 26.11.2001 - Lucio
--                 : 12.11.2002 - Lucio
--                 : 15.12.2004 Lucio
-----------------------------------------------------------------------------------
create procedure pr_pesquisa_projetos_cq_EGIS

@ic_tipo_pesquisa int,
@cd_tipo_projeto  int = 0

as

select
  a.cd_projeto,
  a.cd_interno_projeto,
  a.dt_inicio_projeto,
  a.dt_fim_projeto, 
  a.dt_info_cliente_projeto,
  a.dt_info_processo_projeto,
  a.ic_padrao_projeto,
  a.cd_pedido_venda,
  a.cd_item_pedido_venda,
  a.nm_produto_cliente,
  a.qt_espessura_projeto,
  a.qt_largura_projeto,
  a.qt_comprimento_projeto,
  a.ic_revisado_projeto,
  a.dt_entrada_projeto,
  a.ic_desenho_projeto,
  a.ic_simulacao_injecao,
  a.nm_comp_material_plastico,
  a.cd_pedido_venda_molde,
  a.cd_item_pedido_molde,
  a.ic_cancelamento_projeto,
  a.ic_garantia_projeto,
  a.cd_consulta,
  a.dt_entrega_cliente,
  a.qt_distancia_centros,
  a.qt_peso_produto_projeto,
  b.nm_fantasia_projetista,
  c.nm_tipo_projeto,
  d.nm_status_projeto,
  e.nm_material_plastico,
  h.nm_fantasia_cliente      as 'Fan_Cli',
  f.cd_vendedor_interno      as 'Interno',
  f.cd_vendedor              as 'Setor',
  g.cd_os_tipo_pedido_venda  as 'OS'

into #tmpProjeto

from 
  projeto a, 
  projetista b, 
  tipo_projeto c, 
  status_projeto d, 
  material_plastico e,
  pedido_venda f,
  pedido_venda_item g,
  cliente h

where 
  (@cd_tipo_projeto = 0 or
   a.cd_tipo_projeto       = @cd_tipo_projeto)      and
   a.cd_projetista        *= b.cd_projetista        and
   a.cd_tipo_projeto       = c.cd_tipo_projeto      and
   a.cd_status_projeto     = d.cd_status_projeto    and
   a.cd_material_plastico *= e.cd_material_plastico and
   a.cd_pedido_venda       = f.cd_pedido_venda      and
   a.cd_pedido_venda       = g.cd_pedido_venda      and
   a.cd_item_pedido_venda  = g.cd_item_pedido_venda and
   f.cd_cliente            = h.cd_cliente                

-- Seleciona de acordo com parâmetro 0 = Manifold, 1 = Todos os Itens (Buchas e Ponteiras)

if @ic_tipo_pesquisa = 0 

begin

  select a.*,
         b.cd_tipo_manifold,
         b.cd_produto         as 'Produto',
         b.qt_vias_manifold   as 'Qtde',
         b.qt_vias_manifold   as 'Vias',
         b.qt_niveis_manifold as 'Niveis',
         b.ic_massa_manifold  as 'Massa'

  into #tmpSelItemFiltro

  from #tmpProjeto a, 
       Item_Projeto b
  where  
       a.cd_projeto *= b.cd_projeto and
       b.cd_tipo_manifold is not null

  select a.*,
         b.sg_tipo_manifold as 'Manifold'
  from
       #tmpSelItemFiltro a,
       Tipo_Manifold b
  where
       a.cd_tipo_manifold *= b.cd_tipo_manifold
  order by a.cd_projeto desc

end
else
begin

  select a.*,
         b.cd_tipo_manifold,
         b.cd_produto         as 'Produto',
         b.qt_vias_manifold   as 'Qtde',
         b.qt_vias_manifold   as 'Vias',
         b.qt_niveis_manifold as 'Niveis',
         b.ic_massa_manifold  as 'Massa'

  into #tmpSelItemGeral

  from #tmpProjeto a, 
       Item_Projeto b
  where  
       a.cd_projeto *= b.cd_projeto

  select a.*,
         b.sg_tipo_manifold as 'Manifold'
  from
       #tmpSelItemGeral a,
       Tipo_Manifold b
  where
       a.cd_tipo_manifold *= b.cd_tipo_manifold
  order by a.cd_projeto desc

end

