

/****** Object:  Stored Procedure dbo.pr_orcamento_camara_quente    Script Date: 13/12/2002 15:08:37 ******/
--pr_projetos_camara_quente
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Dados de Orçamento para a Proposta
--Data             : 28.09.2001
--Atualizado       : 
-----------------------------------------------------------------------------------
create procedure pr_orcamento_camara_quente
@cd_consulta int,
@cd_item_consulta int
as
select
  a.cd_consulta,
  a.cd_item_consulta,
  a.nm_produto_cliente,
  a.ic_desenho_produto, 
  a.ds_observacao_produto,
  a.ds_aplicacao_produto,
  a.ds_ponto_injecao_consulta,
  a.qt_cavidade_consulta,
  a.qt_peso_produto_consulta,
  a.nm_comp_material_plastico,
  b.sg_material_plastico,
  b.nm_material_plastico,
  c.nm_tipo_sistema
from 
  orcamento_cq a, 
  material_plastico b,
  tipo_sistema_cq c
where 
  a.cd_consulta           = @cd_consulta and
  a.cd_item_consulta      = @cd_item_consulta and
  a.cd_material_plastico *= b.cd_material_plastico and
  a.cd_tipo_sistema      *= c.cd_tipo_sistema


