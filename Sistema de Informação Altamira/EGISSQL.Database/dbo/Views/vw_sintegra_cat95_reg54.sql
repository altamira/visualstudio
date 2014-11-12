
--vw_sintegra_cat95_reg54
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Lista o Registro 54 do Arquivo Magnético CAT-95
--Data: ???
--Atualizado: 15/03/2004 - Utilizando novo frag da Operação Fiscal que indica a CAT-95 - ELIAS
-----------------------------------------------------------------------------------------

create view vw_sintegra_cat95_reg54 
as

select distinct
  uf.sg_estado as sg_estado_nota_saida,
  ne.dt_nota_entrada as dt_nota_saida,
  ne.cd_nota_entrada as cd_nota_saida,
  ne.dt_receb_nota_entrada as 'DataEmissaoRecto',
  'CNPJ' = case when (uf.sg_estado = 'EX') then
             '00000000000000'
           else
             vw.cd_cnpj
           end,
  IsNull(snf.cd_modelo_serie_nota,'01') as 'Modelo',
  IsNull(snf.sg_serie_nota_fiscal,'1')  as 'Serie',
  ne.cd_nota_entrada                    as 'Numero',
  opf.cd_mascara_operacao               as 'CFOP',
  case when (isnull(nei.cd_situacao_tributaria,'')='') then
    '000'
  else
    nei.cd_situacao_tributaria
  end                                   as 'CST',
  IsNull(p.cd_mascara_produto, '999999999' ) as 'CodigoProduto',
  round(sum(isnull(nei.qt_item_nota_entrada,0)),3)     as 'Quantidade',
  round(sum(isnull(nei.vl_total_nota_entr_item,0)),2)  as 'ValorProduto',
  round(sum(isnull(nei.vl_bicms_nota_entrada,0)),2)    as 'BaseCalculoICMS',
  cast(0 as decimal(25,2))                             as 'BaseICMSSubstituicao',
  round(sum(isnull(nei.vl_ipi_nota_entrada,0)),2)      as 'ValorIPI',
  max(round(nei.pc_icms_nota_entrada,2))               as 'Aliquota'
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
  estado uf
on
  uf.cd_estado = vw.cd_estado and
  uf.cd_pais = vw.cd_pais    
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
  uf.sg_estado,
  ne.dt_nota_entrada,
  ne.dt_receb_nota_entrada,
  ne.cd_nota_entrada,
  case when (uf.sg_estado = 'EX') then
             '00000000000000'
           else
             vw.cd_cnpj
           end,
  isnull(snf.cd_modelo_serie_nota,'01'),
  isnull(snf.sg_serie_nota_fiscal,'1'),
  opf.cd_mascara_operacao,
  case when (isnull(nei.cd_situacao_tributaria,'')='') then
    '000'
  else
    nei.cd_situacao_tributaria
  end,
  isnull(p.cd_mascara_produto,'999999999')



