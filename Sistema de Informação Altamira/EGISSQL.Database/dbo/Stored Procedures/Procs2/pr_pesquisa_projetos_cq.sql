

/****** Object:  Stored Procedure dbo.pr_pesquisa_projetos_cq    Script Date: 13/12/2002 15:08:38 ******/
--pr_pesquisa_projetos_cq
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Selecao de Registros da Tabela de Projetos : só seleçao
--Data             : 20.09.2001
--Atualizado       : 
-----------------------------------------------------------------------------------
create procedure pr_pesquisa_projetos_cq
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
  b.nm_fantasia_projetista,
  c.nm_tipo_projeto,
  d.nm_status_projeto,
  e.nm_material_plastico,
  f.fan_cli,
  f.vendint            as 'Interno',
  f.vdext02            as 'Setor',
  g.numos              as 'OS',
  h.qt_vias_manifold   as 'Vias',
  h.qt_niveis_manifold as 'Niveis',
  h.ic_massa_manifold  as 'Massa',
  h.cd_tipo_manifold
into #tmpProjeto
from 
  projeto a, 
  projetista b, 
  tipo_projeto c, 
  status_projeto d, 
  material_plastico e,
  sap.dbo.cadped f,
  sap.dbo.cadiped g,
  item_projeto h
where 
   a.cd_projetista        *= b.cd_projetista        and
   a.cd_tipo_projeto       = c.cd_tipo_projeto      and
   a.cd_status_projeto     = d.cd_status_projeto    and
   a.cd_material_plastico *= e.cd_material_plastico and
   a.cd_pedido_venda       = f.pedido               and
   a.cd_pedido_venda       = g.pedidoit             and
   a.cd_item_pedido_venda  = g.item                 and
   g.fatsmoit              = 'N'                    and
   a.cd_projeto           *= h.cd_projeto           and
   h.cd_tipo_manifold is not null                  
select a.*,
       b.nm_tipo_manifold as 'Manifold',
       b.sg_tipo_manifold as 'Sigla'
from 
   #tmpProjeto a,
   tipo_manifold b
where
   a.cd_tipo_manifold *= b.cd_tipo_manifold 
order by a.cd_projeto desc


