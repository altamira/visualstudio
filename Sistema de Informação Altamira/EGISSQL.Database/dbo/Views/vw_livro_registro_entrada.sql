
-- vw_livro_registro_entrada
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Entradas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 12/04/2004 - Quando o destinatário da NFE for a própria Polimold 
--                          zerar CNPJ e IE Isento - ELIAS
-- ---------------------------------------------------------------------------------------
-- 
create view vw_livro_registro_entrada
as

    -- ENTRADAS
    select
      distinct
      cast('E' as char(1))			       	as 'ENTRADASAIDA',
      cast(ni.dt_receb_nota_entrada as datetime)       	as 'RECEBTOSAIDA',
      cast(n.nm_especie_nota_entrada as varchar(20))    as 'ESPECIE',
      cast(ni.sg_serie_nota_fiscal as char(3))          as 'SERIE',
      cast(replicate('0',2-len(isnull(s.cd_modelo_serie_nota,'01')))+
                    isnull(s.cd_modelo_serie_nota,'01') as char(2))
                                         		as 'MODELO',
      cast('T' as char(1))				as 'EMITENTE',
      cast(ni.cd_nota_entrada as integer)               as 'NUMERO',
      cast(ni.dt_nota_entrada as datetime)             	as 'EMISSAO',
      cast(ni.sg_estado as char(2))                   	as 'UF',
      'CNPJ' = case when ((uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa)) then
                 '00000000000000'
               else
                 isnull(vw.cd_cnpj,'00000000000000')
               end,
      'IE' = case when ((uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa)) then
               'ISENTO'
             else
               case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                 ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
               then 
                 'Isento'
               else 
                 isnull(vw.cd_inscestadual,'00000000000000')
               end
             end,
      sum(IsNull(ni.vl_cont_reg_nota_entrada,0))       	as 'VlrContabil',
      cast(dbo.fn_limpa_mascara(op.cd_mascara_operacao) as char(4))	       	
							as 'CFOP',
      sum(IsNull(ni.vl_bicms_reg_nota_entrada,0))      	as 'BCICMS',	
      isnull(ni.pc_icms_reg_nota_entrada,0)            	as 'AliqICMS',
      sum(IsNull(ni.vl_icms_reg_nota_entrada,0))       	as 'ICMS',
      sum(IsNull(ni.vl_icmsisen_reg_nota_entr,0))      	as 'ICMSIsento',
      sum(IsNull(ni.vl_icmsoutr_reg_nota_entr,0))      	as 'ICMSOutras',
      sum(IsNull(ni.vl_bipi_reg_nota_entrada,0))       	as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_reg_nota_entrada,0))	       	as 'IPI',
      sum(IsNUll(ni.vl_ipiisen_reg_nota_entr,0))       	as 'IPIIsento',
      sum(IsNUll(ni.vl_ipioutr_reg_nota_entr,0))       	as 'IPIOutras',
      cast('N' as char(1))				as 'Situacao'
    from
      Nota_Entrada_Item_Registro ni
    left outer join
      Nota_Entrada n
    on
      n.cd_nota_entrada = ni.cd_nota_entrada and
      n.cd_fornecedor = ni.cd_fornecedor and
      n.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    left outer join
      Serie_Nota_Fiscal s
    on
      s.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
    left outer join
      vw_Destinatario_Rapida vw
    on
      vw.cd_tipo_destinatario = n.cd_tipo_destinatario and
      vw.cd_destinatario = n.cd_fornecedor
    left outer join
      Estado uf
    on
      uf.cd_pais = vw.cd_pais and
      uf.cd_estado = vw.cd_estado
    left outer join
      EgisAdmin.dbo.Empresa e
    on
      e.cd_empresa = dbo.fn_empresa()
    where
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      isnull(op.ic_servico_operacao,'N') = 'N'  and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      n.nm_especie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      s.cd_modelo_serie_nota,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      n.nm_fantasia_destinatario,
      ni.sg_estado,
      uf.sg_estado,
      vw.cd_cnpj,
      vw.ic_isento_inscestadual,
      vw.cd_inscestadual,
      op.cd_mascara_operacao,
      isnull(ni.pc_icms_reg_nota_entrada,0),
      e.cd_cgc_empresa

--select * from vw_livro_registro_entrada where numero = 7367

