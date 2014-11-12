

/****** Object:  Stored Procedure dbo.pr_projetos_camara_quente    Script Date: 13/12/2002 15:08:39 ******/
--pr_projetos_camara_quente
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Selecao de Registros da Tabela Projetos
--Data             : 30.05.2001
--Atualizado       : 
-----------------------------------------------------------------------------------
create procedure pr_projetos_camara_quente
@ic_parametro int
as
if @ic_parametro = 0  -- Cadastro de Projetos
begin
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
  a.cd_status_projeto,
  a.cd_tipo_projeto,
  a.cd_projetista, 
  a.dt_entrada_projeto,
  a.cd_material_plastico,
  a.ic_desenho_projeto,
  a.ic_simulacao_injecao,
  a.nm_caminho_simulacao,
  a.nm_comp_material_plastico,
  a.cd_pedido_venda_molde,
  a.cd_item_pedido_molde,
  a.ic_cancelamento_projeto,
  a.ic_garantia_projeto,
  a.qt_distancia_centros,
  a.cd_consulta,a.cd_usuario,
  a.dt_usuario, 
  a.dt_entrega_cliente--,
--  b.nm_fantasia_projetista,
--  c.nm_tipo_projeto,
--  d.nm_status_projeto,
--  e.nm_material_plastico,
--  f.fan_cli,
--  f.vendint as 'Interno',
--  f.vdext02 as 'Setor',
--  g.numos   as 'OS'
from 
  projeto a--, 
--  projetista b, 
--  tipo_projeto c, 
--  status_projeto d, 
--  material_plastico e,
--  sap.dbo.cadped f,
--  sap.dbo.cadiped g
--where 
--   a.cd_projetista         = b.cd_projetista        and
--   a.cd_tipo_projeto       = c.cd_tipo_projeto      and
--   a.cd_status_projeto     = d.cd_status_projeto    and
--   a.cd_material_plastico  = e.cd_material_plastico and
--   a.cd_pedido_venda       = f.pedido               and
--   a.cd_pedido_venda       = g.pedidoit             and
--   a.cd_item_pedido_venda  = g.item                 and
--   g.fatsmoit = 'N'
order by a.cd_projeto desc
end
--if @ic_parametro = 1  -- Cadastro de Projetos
--begin
  
  
--end


