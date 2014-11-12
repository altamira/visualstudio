
CREATE PROCEDURE pr_requisicao_interna_maquina

---------------------------------------------------------------------------------------------------------
--pr_requisicao_interna_maquina
---------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2005
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Requisições Interna por Máquina.
--Data             : 23/01/2005
--Atualizado       : 
---------------------------------------------------------------------------------------------------------

@cd_maquina    int,
@dt_inicial    datetime,
@dt_final      datetime


AS

select
  m.nm_fantasia_maquina as Maquina,
  rii.cd_requisicao_interna,
  ri.dt_requisicao_interna,
  ri.dt_necessidade,
  d.nm_departamento,
  c.nm_centro_custo,
  a.nm_aplicacao_produto,
  rii.cd_item_req_interna,
  rii.qt_item_req_interna,
  rii.qt_entregue_req_interna,  --Quantidade Entregue
  rii.dt_item_estoque_req,      --Data da Entrega / Baixa do Estoque
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida

from
  requisicao_interna ri
  left outer join requisicao_interna_item  rii on ri.cd_requisicao_interna = rii.cd_requisicao_interna
  left outer join Maquina                  m   on m.cd_maquina             = rii.cd_maquina
  left outer join Departamento             d   on d.cd_departamento        = ri.cd_departamento
  left outer join Aplicacao_Produto        a   on a.cd_aplicacao_produto   = ri.cd_aplicacao_produto
  left outer join Centro_Custo             c   on c.cd_centro_custo        = ri.cd_centro_custo
  left outer join Produto                  p   on p.cd_produto             = rii.cd_produto
  left outer join Unidade_Medida          um   on um.cd_unidade_medida     = rii.cd_unidade_medida 
where
  ri.dt_requisicao_interna between @dt_inicial and @dt_final and
  isnull(ri.ic_maquina,'N') = 'S'                            and
  m.cd_maquina = case when @cd_maquina = 0 then m.cd_maquina else @cd_maquina end
order by
  m.nm_fantasia_maquina

--select * from servico
--select * from produto
--select * from requisicao_interna
--select * from requisicao_interna_item
