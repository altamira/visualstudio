
CREATE PROCEDURE pr_requisicao_compra_maquina

---------------------------------------------------------------------------------------------------------
--pr_requisicao_compra_maquina
---------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2005
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Requisições de Compra por Máquina.
--Data             : 23/01/2005
--Atualizado       : 20.08.2006 - Ajustes na consulta para Serviço - Carlos Fernandes
---------------------------------------------------------------------------------------------------------

@cd_maquina    int,
@dt_inicial    datetime,
@dt_final      datetime


AS

select
  m.nm_fantasia_maquina                 as Maquina,
  rci.cd_requisicao_compra              as Requisicao,
  rc.dt_emissao_req_compra              as Data,
  d.nm_departamento                     as Departamento,
  a.nm_aplicacao_produto                as Aplicacao,
  c.nm_centro_custo                     as CentroCusto,
  rci.cd_item_requisicao_compra         as Item,
  rci.qt_item_requisicao_compra         as Qtde,
  case when isnull(rci.cd_produto,0)>0 
       then p.cd_mascara_produto
       else s.cd_mascara_servico end    as CodigoProduto,
  p.nm_fantasia_produto                 as Produto,
  p.nm_produto                          as DescricaoProduto,
  s.nm_servico                          as Servico,
  um.sg_unidade_medida                  as UnidadeMedida,
  rci.nm_marca_item_req_compra          as Marca

from
  requisicao_compra rc
  left outer join requisicao_compra_item  rci on rc.cd_requisicao_compra = rci.cd_requisicao_compra
  left outer join Maquina                 m   on m.cd_maquina            = rci.cd_maquina
  left outer join Departamento            d   on d.cd_departamento       = rc.cd_departamento
  left outer join Aplicacao_Produto       a   on a.cd_aplicacao_produto  = rc.cd_aplicacao_produto
  left outer join Centro_Custo            c   on c.cd_centro_custo       = rc.cd_centro_custo
  left outer join Produto                 p   on p.cd_produto            = rci.cd_produto
  left outer join Servico                 s   on s.cd_servico            = rci.cd_servico
  left outer join Unidade_Medida         um   on um.cd_unidade_medida    = rci.cd_unidade_medida 
where
  rc.dt_emissao_req_compra between @dt_inicial and @dt_final and
  isnull(rc.ic_maquina,'N') = 'S'                            and
  m.cd_maquina = case when @cd_maquina = 0 then m.cd_maquina else @cd_maquina end
order by
  m.nm_fantasia_maquina

--select * from servico
--select * from produto
--select * from requisicao_compra
--select * from requisicao_compra_item

