
--vw_sintegra_cat95_reg88T
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Lista o Registro 88T do Arquivo Magnético CAT-95
--Data: 15/03/2004
--Atualizado: 
-----------------------------------------------------------------------------------------

create view vw_sintegra_cat95_reg88T
as

select distinct
  vw.cd_cnpj					as 'CNPJ',
  ne.dt_receb_nota_entrada			as 'Recebto',
  uf.sg_estado					as 'UF',
  isnull(snf.cd_modelo_serie_nota,'01')		as 'Modelo',
  isnull(snf.sg_serie_nota_fiscal,'1')		as 'Serie',
  ne.cd_nota_entrada                    	as 'Numero',
  cast(null as char(1))				as 'CIF_FOB',
  t.cd_cnpj_transportadora			as 'CNPJTransp',
  uft.sg_estado					as 'UFTransp',
  t.cd_insc_estadual				as 'IETransp',
  cast(null as int)				as 'Modal',
  cast(null as char(7))				as 'Placa1',
  cast(null as char(2))				as 'UF1',
  cast(null as char(7))				as 'Placa2',
  cast(null as char(2))				as 'UF2',  
  cast(null as char(7))				as 'Placa3',
  cast(null as char(2))				as 'UF3'
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
  Transportadora t
on
  t.cd_transportadora = ne.cd_transportadora
left outer join
  Estado uft
on
  uf.cd_pais = t.cd_pais and
  uf.cd_estado = t.cd_estado
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



