
--vw_sintegra_cat95_reg51
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Lista o Registro 51 do Arquivo Magnético CAT-95
--Data: ???
--Atualizado: 15/03/2004 - Utilizando novo frag da Operação Fiscal que indica a CAT-95 - ELIAS
-----------------------------------------------------------------------------------------
create view vw_sintegra_cat95_reg51 
as

select distinct
  uf.sg_estado as sg_estado_nota_saida,
  ne.dt_nota_entrada as dt_nota_saida,
  ne.cd_nota_entrada as cd_nota_saida,
  ne.dt_receb_nota_entrada as 'DataEmissaoRecto',
  uf.sg_estado as 'UF',
  ne.cd_nota_entrada as 'Numero',
  'CNPJ' = case when (uf.sg_estado = 'EX') then
             '00000000000000'
           else
             vw.cd_cnpj
           end,
  'InscricaoEstadual' = case when (uf.sg_estado = 'EX') then
                          'ISENTO'
                        else
                          case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                            ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
                          then 
                            'Isento'
                          else 
                            vw.cd_inscestadual
                          end
                        end,
  IsNull(snf.sg_serie_nota_fiscal,'1') as 'Serie',
  'N' as 'Situacao',
  opf.cd_mascara_operacao as 'CFOP',
  round(sum(IsNull(neir.vl_cont_reg_nota_entrada,0)),2) as 'ValorTotal',
  round(sum(IsNull(neir.vl_ipi_reg_nota_entrada,0)),2) as 'ValorIPI',
  round(sum(IsNull(neir.vl_ipiisen_reg_nota_entr,0)),2) as 'IsentaNaoTributada',
  round(sum(IsNull(neir.vl_ipioutr_reg_nota_entr,0)),2) as 'Outras'

from
  nota_entrada_item_registro neir
inner join
  nota_entrada ne
on
  ne.cd_nota_entrada = neir.cd_nota_entrada and
  ne.cd_fornecedor = neir.cd_fornecedor and
  ne.cd_operacao_fiscal = neir.cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal
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
where
  (IsNull(opf.ic_servico_operacao,'N') <> 'S') and
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
  case when (uf.sg_estado = 'EX') then
    'ISENTO'
  else
    case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
      ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
    then 
      'Isento'
    else 
      vw.cd_inscestadual
    end
  end, 
  IsNull(snf.sg_serie_nota_fiscal,'1'),
  opf.cd_mascara_operacao



