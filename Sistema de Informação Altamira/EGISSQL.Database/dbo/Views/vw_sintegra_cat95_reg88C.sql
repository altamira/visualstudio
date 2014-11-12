
--vw_sintegra_cat95_reg88C
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Lista o Registro 88C do Arquivo Magnético CAT-95
--Data: 15/03/2004
--Atualizado: 
-----------------------------------------------------------------------------------------

create view vw_sintegra_cat95_reg88C
as

select distinct
  vw.cd_cnpj					as 'CNPJ',
  isnull(snf.cd_modelo_serie_nota,'01')		as 'Modelo',
  isnull(snf.sg_serie_nota_fiscal,'1')		as 'Serie',
  ne.cd_nota_entrada                    	as 'Numero',
  opf.cd_mascara_operacao               	as 'CFOP',
  nei.cd_item_nota_entrada			as 'ItemNF',
  isnull(p.cd_mascara_produto,'999999999')	as 'CodigoProduto',
  cast(str(nei.qt_item_nota_entrada,25,3) as decimal(25,3))
  						as 'QtdeProduto',
  cast(null as decimal(25,2))			as 'BCST',
  cast(null as decimal(25,2))			as 'ICMSST',
  cast(null as decimal(25,2))			as 'ICMSCompl',
  cast(null as decimal(25,2))			as 'BCRetencao',
  cast(null as decimal(25,2))			as 'ICMSRetido'  
from
  nota_entrada_item nei
inner join
  nota_entrada ne
on
  ne.cd_nota_entrada = nei.cd_nota_entrada and
  ne.cd_fornecedor = nei.cd_fornecedor and
  ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
left outer join
  vw_destinatario_rapida vw
on
  vw.cd_tipo_destinatario = ne.cd_tipo_destinatario and
  vw.cd_destinatario = ne.cd_fornecedor
left outer join 
  serie_nota_fiscal snf
on 
  snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
inner join
  operacao_fiscal opf
on
  opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
left outer join
  produto p
on
  p.cd_produto = nei.cd_produto
where
  (isnull(opf.ic_servico_operacao,'N') <> 'S') and
  (isnull(opf.ic_cat95_operacao_fiscal,'N') <> 'S')
group by
  ne.cd_nota_entrada,
  isnull(p.cd_mascara_produto,'999999999'),
  vw.cd_cnpj,
  isnull(snf.cd_modelo_serie_nota,'01'),
  isnull(snf.sg_serie_nota_fiscal,'1'),
  opf.cd_mascara_operacao,
  nei.cd_item_nota_entrada,
  cast(str(nei.qt_item_nota_entrada,25,3) as decimal(25,3))


