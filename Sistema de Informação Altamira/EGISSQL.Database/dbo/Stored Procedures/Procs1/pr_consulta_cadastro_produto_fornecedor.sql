
-------------------------------------------------------------------------------
--pr_consulta_cadastro_produto_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta do Cadastro de Produtos por Fornecedor
--Data             : 29.03.2006
--Alteração        : 02.05.2006
-- 16.08.2008 - Mostrar o preço de custo do produto - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_cadastro_produto_fornecedor
@cd_fornecedor int = 0

as

--select * from fornecedor_produto
--select * from fornecedor

select
  f.cd_fornecedor,
  f.nm_fantasia_fornecedor,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  sp.nm_status_produto,
  fp.nm_referencia_fornecedor,
  fp.nm_marca_fornecedor,
  (case   fp.ic_cotacao_fornecedor
		when 'S' then
			'Sim'	
      else
	      'Não'
   end) as ic_cotacao_fornecedor,
  oc.nm_opcao_compra,
  f.cd_ddd,
  '('+f.cd_ddd+')-'+cd_telefone as cd_telefone,
  '('+f.cd_ddd+')-'+cd_fax      as cd_fax,
  f.dt_cadastro_fornecedor,
  f.nm_razao_social,
  isnull(pc.vl_custo_produto,0) as vl_custo_produto
from
  fornecedor f with (nolock) 
  inner join fornecedor_produto fp  with (nolock) on fp.cd_fornecedor     = f.cd_fornecedor
  inner join produto p              with (nolock) on p.cd_produto         = fp.cd_produto
  left outer join produto_custo pc  with (nolock) on pc.cd_produto        = p.cd_produto
  left outer join status_produto sp on sp.cd_status_produto = p.cd_status_produto
  left outer join unidade_medida um on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join opcao_compra oc   on oc.cd_opcao_compra   = fp.cd_opcao_compra
where
  f.cd_fornecedor = case when @cd_fornecedor = 0 then f.cd_fornecedor else @cd_fornecedor end

order by
  f.nm_fantasia_fornecedor,
  p.nm_fantasia_produto
