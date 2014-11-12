
--vw_sintegra_cat95_reg88D
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Lista o Registro 88D do Arquivo Magnético CAT-95
--Data: 15/03/2004
--Atualizado: 
-----------------------------------------------------------------------------------------

create view vw_sintegra_cat95_reg88D
as

select distinct
  vw.cd_cnpj					as 'CNPJ',
  vw.cd_inscestadual				as 'IE',
  uf.sg_estado					as 'UF',
  isnull(snf.cd_modelo_serie_nota,'01')		as 'Modelo',
  isnull(snf.sg_serie_nota_fiscal,'1')		as 'Serie',
  ne.cd_nota_entrada                    	as 'Numero',
  opf.cd_mascara_operacao               	as 'CFOP',
  ne.dt_nota_entrada				as 'Emissao',
  ne.dt_receb_nota_entrada			as 'Recebto',
  cast(null as varchar(14))			as 'CNPJSaida',
  cast(null as char(2))				as 'UFSaida',
  cast(null as varchar(14))			as 'IESaida',
  cast(null as varchar(14))			as 'CNPJRecebto',
  cast(null as char(2))				as 'UFRecebto',
  cast(null as varchar(14))			as 'IERecebto'
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
  Estado uf
on
  uf.cd_pais = vw.cd_pais and
  uf.cd_estado = vw.cd_estado
left outer join 
  serie_nota_fiscal snf
on 
  snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
inner join
  operacao_fiscal opf
on
  opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
where
  (isnull(opf.ic_servico_operacao,'N') <> 'S') and
  (isnull(opf.ic_cat95_operacao_fiscal,'N') <> 'S')



